# Coffee Cash — Client Sync Logic (AI Reference)

## 0. Purpose & scope

This file is a complete technical reference for the **client-side (Flutter)** implementation of the offline-first sync system, written so an AI working on the backend/dashboard can understand exactly what the app sends, when, why, and what invariants it relies on — without reading the Flutter source. Companion doc: `default-catalog-and-images.md` (same folder) — a focused addendum on the default-catalog/image-upload rules referenced in §7 below.

Base contract (endpoint, multipart shape, per-array upsert semantics, deletion/idempotency rules) is whatever the backend team already has as `sync/upload`'s spec — this document only describes the **client's actual behavior on top of that contract**, including where it currently deviates or leaves something unresolved.

## 1. Data model / identity

- Every syncable local row (`Shift`, `Customer`, `Category`, `MenuItem`, `Order`, `OrderItem`, `TreasuryTransaction`) has a client-generated `uuid` (v4), assigned once at creation, immutable afterward.
- The local ObjectBox integer `id` is purely internal — never sent to the server.
- Dine-in Tables and "Matches" Seats (a second, separate seating concept in the app) also get client uuids, used ONLY to resolve `location.table_uuid` on orders — neither is ever synced as its own entity/array.

## 2. `synced` flags — what "already uploaded" means

- `Shift`, `Customer`, `Category`, `MenuItem`, `Order` each carry a boolean `synced` (default `false`).
- `OrderItem` and `TreasuryTransaction` do **not** have a `synced` flag — see §5 and §6 for why that's safe.
- Flips to `true` only after the enclosing upload HTTP call returns success (2xx).
- Editing a Customer/Category/MenuItem (name, price, image, reorder) resets its `synced` back to `false` — next upload re-sends the full current object (upsert, not a diff).
- A `Shift`'s `synced` becomes `true` only when **its own** upload succeeds — each shift is a separate `sync/upload` call.

## 3. Upload trigger & retry (`sync_uuid`)

- Upload is user-initiated: offered right after a shift is closed (optional, connectivity-gated), or retried later at any time from "Shift History" for any shift where `synced == false`.
- `Shift.pendingSyncUuid` is generated once (client `Uuid v4`) on the first upload attempt for that shift, persisted to the local DB **before** the network call, and reused verbatim on every retry until the upload succeeds (then cleared). This value is sent as the payload's `sync_uuid` — satisfies the backend's idempotent-retry contract without any content-hash diffing.
- On failure (network error, non-2xx): nothing local changes except `pendingSyncUuid` staying set. Safe to retry with the identical prepared payload.
- On success: `pendingSyncUuid` cleared, `Shift.synced = true`, `Shift.syncedAt = now()`.

## 4. What's included in one upload — shift windowing

There is **no explicit foreign key** from `Order`/`TreasuryTransaction` to `Shift`. A record belongs to shift S if its relevant timestamp falls in `[S.startedAt, S.closedAt ?? now()]` — orders windowed by `closedAt`, treasury transactions by `createdAt`. This single windowing rule (`ShiftWindow.contains`) is shared by the in-app shift-summary screen and the sync payload builder, so what a cashier sees on-screen for a shift and what gets uploaded for it are always the same set.

One `sync/upload` call for shift S contains:
- `shift.uuid` — S's own uuid, generated client-side at `startShift()` time (see §11.1 — this is an open question, not a confirmed contract).
- All **currently-unsynced** Customers/Categories/MenuItems — **not** shift-scoped; catalog/customer edits simply ride along on whichever shift happens to sync next.
- Orders whose `closedAt` is in S's window, split into `paid_orders[]`/`cancelled_orders[]`/`deferred_orders[]` by status — see §5 for the synced/unsynced split within that.
- Treasury transactions whose `createdAt` is in S's window — unconditional, see §6.
- `payments[]` — only synthesized `debt_collection` entries, see §5.
- `deleted_customers[]`/`deleted_categories[]`/`deleted_menu_items[]` — from a small local pending-deletion queue (§8), not shift-scoped, cleared on **any** successful upload.

## 5. Orders — the cross-shift deferred-order problem

The trickiest part of the client logic. Get this wrong and debt collection double-books or corrupts a previously-synced order's shift attribution.

For every order whose `closedAt` falls in shift S's window:

- **`order.synced == false`** → the order's entire lifecycle (creation → resolution) happened inside shift S. Sent as a full object in `paid_orders[]`/`cancelled_orders[]`/`deferred_orders[]` (by `statusEnum`) with its `items[]`. Its `paid_amount` is expected to create the idempotent `order_payment` per the base contract — the client does **not** also emit a `payments[]` entry for this order.
- **`order.synced == true` and status == `paid`** → this order was already synced as `deferred` in a **past, already-uploaded** shift, and is now being collected (paid off) during shift S — locally the "collect deferred order" flow flips its status to `paid`. The client does **not** resend the order object (would rewrite an already-known order's shift/timestamps). Instead it emits one `payments[]` entry per matching `TreasuryTransaction` (source: transactions linked to this order, filtered to S's window):
  ```json
  { "uuid": "<fresh payment uuid>", "order_uuid": "<order.uuid>", "shift_uuid": "<S.uuid>",
    "type": "debt_collection", "payment_method": "cash", "amount": "60.00", "paid_at": "2026-08-24T12:00:00Z" }
  ```
- **`order.synced == true` and status == `cancelled`** → a previously-synced deferred order was written off (cancelled to drop the debt) during a later shift. **The client currently sends nothing for this case.** There is no wire representation for it today — known, intentional gap, see §11.2.
- A deferred order's `closedAt` is fixed at defer-time and only changes when its status later transitions (paid/cancelled), so it can never land in more than one shift's window while still `deferred` — no double-send risk there.

On successful upload, the client marks `synced = true` on every order it made a decision about above (fresh sends, and the debt-collection/write-off cases), so the same order is never re-evaluated on a future upload.

## 6. Treasury transactions

No `synced` flag — every transaction is created only while some shift is active, so its `createdAt` unambiguously belongs to exactly one shift's window at creation time (no retroactive-shift ambiguity like orders have). Sent in full whenever its owning shift uploads. Each entry carries `employee_id` (client field `createdById`, set from the logged-in employee at creation time) — distinct from the payload's top-level `cashier.employee_id`, which is always whoever is performing the upload itself.

Note: the same real-world cash event can legitimately appear in **both** `treasury_transactions[]` (generic cash-drawer ledger entry) **and** `payments[]` as a `debt_collection` — these are two different backend concepts by design, not a double-count bug.

## 7. Catalog upsert (Customers/Categories/MenuItems)

No per-field dirty-tracking — every currently-unsynced row's **full current object** is sent (never a diff), matching "last successful upload wins" upsert semantics. Drag-reordering (`sort_order` change) also flips `synced = false` for every reordered row, since `sort_order` is part of the synced object.

### Default catalog & images

Full detail in `default-catalog-and-images.md`. Summary: the app ships with a bundled starter catalog (`is_default: true` on those Category/MenuItem rows). As long as a default row's image is still its original bundled asset, `image_key` stays `null` and a client-informational `local_asset_path` field carries the asset path instead (e.g. `assets/images/seed_items/hot_tea_plain.png`) — no image bytes are ever uploaded for it. If the cafe owner later replaces a default item's picture with a real photo, it transparently switches to normal image-upload behavior — that decision is driven by whether `imagePath` is currently a bundled-asset path or a real file path, not by the `is_default` flag itself (so a default item with a replaced photo still reports `is_default: true` but uploads its image normally).

### Images ZIP construction

- `image_key` is set only when the local image file: exists on disk (`File.existsSync()`), has an accepted extension (`jpg`/`jpeg`/`png`/`webp`), and is **not** a bundled-asset path.
- `images.zip` is built from exactly the same filtered set used to produce `image_key` values (single source of truth inside `SyncPayloadBuilder`) — this was a real historical bug: the client used to decide file-existence independently in two places (JSON builder vs. zip builder), which could desync and trigger the backend's `"ZIP files must match image_key values exactly"` 422. Now structurally guaranteed consistent.
- Every unsynced category/menu-item with a real, existing, accepted-type image gets re-zipped on every upload it's part of — no per-row "did the image actually change" tracking yet. Accepted inefficiency for now, flagged as a bandwidth fast-follow.

## 8. Deletion tracking

Hard-delete UX is unchanged — deleting a customer/category/menu-item removes it locally immediately, same as before this sync feature existed. A separate local "pending deletion" table only gets a row when the thing being deleted had `synced == true` (i.e. the server already knew about it) — a never-synced local-only record is just hard-deleted with no trace. `deleted_customers[]`/`deleted_categories[]`/`deleted_menu_items[]` are populated from this table on every upload, and the consumed rows are cleared on success. Deliberately **not** shift-scoped — rides along on whichever upload happens next.

## 9. Money & quantity encoding — ⚠️ live deviation from the base spec

As currently implemented, the payload builder formats **all** monetary values (`opening_balance`, `closing_balance`, order `subtotal`/`total`/`paid_amount`, order-item `price`/`line_total`, payment `amount`, treasury `amount`) and order-item `quantity` as **fixed-decimal strings** (`"500.00"`, `"2.000"`) rather than JSON numbers. If the base spec's "all money values must be numeric" requirement is enforced strictly server-side, this will fail validation. Needs an explicit decision: either the backend accepts string-encoded decimals (common practice to dodge float-precision issues), or the client needs to revert to numeric JSON values.

## 10. Multipart request shape

`POST /api/v1/sync/upload`, `multipart/form-data`, boundary auto-generated by the HTTP client (never set manually):
- part `data`: `sync_data.json.gz` — the JSON described above, gzip-compressed off the UI thread.
- part `images`: `images.zip` — present only when at least one `image_key` is referenced anywhere in the payload; omitted entirely otherwise.
- `Authorization: Bearer <token>` — the logged-in user's session token, same as every other authenticated request.

## 11. Known open questions

Not silently resolved client-side — flagged here and to the app's own product owner.

1. **`shift.uuid` pre-existence.** The base spec states the uploaded `shift.uuid` "must already exist in the authenticated Cafe, be closed, and have `synced_at = null`" — implying some prior registration step. No shift-creation/registration endpoint has been specified. The client currently just generates the uuid locally at `startShift()` time and sends it directly on first upload, same as every other entity. Unconfirmed whether the first successful upload implicitly registers the shift, or whether a separate call is required.
2. **Write-off of an already-synced deferred order** (§5) has no wire representation today — a real product/contract gap, not a code TODO.
3. **`location.table_uuid` for "seat" locations.** The app has two distinct seating concepts — dine-in Tables, and a separate "Matches" area (e.g. for watching sports events) — both currently resolve into the same `location.table_uuid` field. Unconfirmed whether the backend needs to distinguish them.
4. **Default catalog image hosting** — purely a "don't upload it" decision client-side today (§7); the backend's actual hosting/display strategy for these is still undecided (options laid out in `default-catalog-and-images.md`, §4).
5. **The download/"bootstrap" direction is entirely unimplemented, both sides.** Pulling the latest catalog/customers on shift-open has no agreed endpoint contract yet. The client has a fully-fake placeholder (`SyncRepo.pullBootstrapFake`) that only drives a simulated progress UI and writes nothing to the local database — deliberately not implemented further until this direction's contract exists.

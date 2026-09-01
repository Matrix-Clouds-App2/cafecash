# Sync payload — وردية فيها نشاط (طلبات + خزنة) — 2026-09-01

**مش نسخة حقيقية متسحبة من لوج** — ده payload مبني بالإيد بنفس شكل اللي `SyncPayloadBuilder`
بيطلعه (`lib/features/sync/data/sync_payload_builder.dart`)، عشان نقدر نجرّب رفع/دمج
وردية **مش فاضية** (فيها طلبات وحركات خزنة وعميل)، مش زي فيكستشر `2026-08-30-first-sync-empty-shift`
اللي كانت كتالوج بس.

## محتوى الوردية

| | |
|---|---|
| `sync_uuid` | `3a9f0e21-4c8d-4b7a-9f10-2d6e5c1b8a44` |
| `shift.uuid` | `0f4c2c1e-7a3b-4d59-9c14-8b6f2a10dd77` |
| `cashier.employee_id` / `shift.employee_id` | `6` |
| الوردية | فُتحت `2026-09-01T10:00:00Z`، قُفلت `2026-09-01T14:30:00Z` |
| الرصيد | `500.00 → 670.00` (افتتاح 500 + إيراد 200 − مصروف 30) |
| العملاء | 1 (`أحمد سيد` — الطلب الآجل مربوط بيه) |
| الكتالوج | نفس الكتالوج الافتراضي (6 أقسام + 52 صنف، `is_default: true`) — 8 من أصناف العصائر بـ `uuid` placeholder |
| `paid_orders` | 3 (ترابيزة 5 = 80 كاش، ترابيزة 3 = 75 محفظة، ترابيزة 1 = 45 كاش) |
| `cancelled_orders` | 1 (ترابيزة 7 = 60، السبب: "العميل مشي قبل التحضير") |
| `deferred_orders` | 1 (ترابيزة 2، للعميل أحمد = 90) |
| `treasury_transactions` | 4 (3 إيراد دفع طلبات + 1 مصروف "شراء ثلج") |
| `payments` | فاضي (مفيش تحصيل آجل من ورديات سابقة في السيناريو ده) |
| المحذوفات | فاضية |
| `images.zip` | مش موجود — مفيش أي `image_key` |

## الملفات

| الملف | إيه هو |
|---|---|
| `rebuild.py` | السكريبت اللي بيبني الـ 3 ملفات تحت. `python3 rebuild.py .` |
| `sync_data.json` | الـ payload مقروء (indent=2) — **للقراءة فقط** |
| `sync_data.compact.json` | الـ JSON بالظبط زي `jsonEncode` (من غير مسافات، UTF-8، العربي مش escaped) — ده اللي بيتضغط |
| `sync_data.json.gz` | **الملف المضغوط** — gzip لـ `sync_data.compact.json` |

```
compact json bytes = 20404
sha256(compact)    = eb85bca74834298f3e2f35e8b8a079a1d743018fba22b528e3edb153ca16f5bf
gzip bytes         = 3602   (Python gzip؛ الـ archive package بتاع التطبيق بيطلع رقم أكبر شوية لنفس المحتوى)
```

## شكل الطلب في الـ payload

كل طلب (من `_orderJson`):

```json
{
  "uuid": "...",
  "customer_uuid": null | "uuid",
  "location": { "table_uuid": null, "number": 5 },
  "subtotal": "80.00",
  "discount_amount": "0.00",
  "total": "80.00",
  "created_at_client": "2026-09-01T10:12:04.000Z",
  "closed_at_client": "2026-09-01T10:31:22.000Z",
  "items": [
    { "uuid": "...", "menu_item_uuid": "...", "name": "قهوة",
      "price": "20.00", "quantity": "2.000", "line_total": "40.00" }
  ],
  "payment_method": "cash",   // paid فقط
  "paid_amount": "80.00",     // paid فقط
  "cancel_reason": "..."      // cancelled فقط
}
```

`quantity` بـ 3 خانات عشرية، باقي الفلوس بـ 2. الطلبات بتترتب على مصفوفات منفصلة
(`paid_orders` / `cancelled_orders` / `deferred_orders`) — مفيش حقل `status` جوّه الطلب،
المصفوفة نفسها هي اللي بتحدد الحالة.

## الاستخدام

- **رفع:** `POST /api/v1/sync/upload` — part اسمه `data` = `sync_data.json.gz`، من غير `images`.
- **bootstrap/هيدرشن:** نفس المصفوفات (`paid_orders`/`cancelled_orders`/`deferred_orders`/
  `treasury_transactions`/`payments`) بيقراها `BootstrapSnapshot.fromJson`
  (`lib/features/sync/data/models/bootstrap_snapshot.dart`)، فالملف ده صالح كـ ردّ
  `sync/bootstrap` أو `shifts/{id}` بعد لفّه في `{ "data": { ... } }` لو محتاج.

تفاصيل الحقول الكاملة في `../../sync-upload-example.md` و `../../ai-reference.md`.

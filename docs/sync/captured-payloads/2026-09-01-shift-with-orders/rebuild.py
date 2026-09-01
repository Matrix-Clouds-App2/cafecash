#!/usr/bin/env python3
"""
Synthetic sync-upload payload for a shift that actually has activity:
customers + paid/cancelled/deferred orders + treasury transactions.

Not a real capture — hand-built to match `SyncPayloadBuilder` output shape
(lib/features/sync/data/sync_payload_builder.dart) so the backend / bootstrap
merge can be exercised against a non-empty shift.

Run:  python3 rebuild.py .
"""
import json, gzip, hashlib, io, sys

ASSET = "assets/images/seed_items/"


def cat(uuid, name, sort, asset):
    return {
        "uuid": uuid, "name": name, "sort_order": sort,
        "is_active": True, "is_default": True,
        "image_key": None, "local_asset_path": ASSET + asset,
    }


def item(uuid, cat_uuid, name, price, sort, asset):
    return {
        "uuid": uuid, "category_uuid": cat_uuid, "name": name,
        "price": f"{price:.2f}", "sort_order": sort,
        "is_active": True, "is_default": True,
        "image_key": None, "local_asset_path": ASSET + asset,
    }


C_COFFEE = "1ffcd1c1-d208-4c71-97f3-0b181fa86aa4"
C_HOT = "feb6d840-c013-4754-9ada-b1c5f5752cd8"
C_COLD = "5a15b829-3c6e-4a06-a741-c780ba5a3a53"
C_SODA = "238db62b-f1e9-4b32-9172-cddb7c280ed8"
C_FOOD = "e5fb4cb8-01e5-4802-8a5c-ae455bef3ea5"
C_ICE = "74bb501e-4f2d-4c4a-bc25-306d7a54e223"

categories = [
    cat(C_COFFEE, "قهوة", 0, "coffee_plain.png"),
    cat(C_HOT, "مشروبات ساخنة", 1, "hot_tea_plain.png"),
    cat(C_COLD, "عصائر ومشروبات باردة", 2, "cold_water.png"),
    cat(C_SODA, "مشروبات غازية", 3, "soda_pepsi.png"),
    cat(C_FOOD, "مأكولات", 4, "food_om_ali.png"),
    cat(C_ICE, "آيس كريم", 5, "ice_chocolate.png"),
]

PH = [f"00000000-0000-4000-8000-0000000000{i:02d}" for i in range(8)]

menu_items = [
    item("8d6ebe70-0a7b-45cf-a8c3-128474d117b7", C_COFFEE, "قهوة", 20, 0, "coffee_plain.png"),
    item("7fa6ec79-1ad6-4482-9a40-b264cb5a7b21", C_COFFEE, "قهوة دبل", 30, 1, "coffee_double.png"),
    item("64f2ce40-554b-460c-bf10-c502517c58a3", C_COFFEE, "قهوة فرنساوي", 35, 2, "coffee_french.png"),
    item("e72dfd40-5097-4d53-9640-277e1f57bf6e", C_COFFEE, "كابتشينو", 35, 3, "cappuccino.png"),
    item("0ab51e8f-5447-47d1-88d9-2bc7da86fbe6", C_COFFEE, "لاتيه", 40, 4, "latte.png"),
    item("99331b2d-c26e-46f6-8b33-3e6be0823619", C_COFFEE, "نسكافيه بحليب", 35, 5, "nescafe_milk.png"),
    item("549a1508-3c49-47f2-90d0-12ce59ec4cf3", C_COFFEE, "نسكافيه بلاك", 25, 6, "nescafe_black.png"),
    item("0edf8305-3cd3-4777-b25c-fc911be1d722", C_HOT, "شاي عادي", 15, 0, "hot_tea_plain.png"),
    item("66f9e420-e279-49e3-9271-43996d1d557b", C_HOT, "شاي فتلة", 20, 1, "hot_tea_fatla.png"),
    item("e513e02d-504c-4312-bd99-eda075ddf099", C_HOT, "ليمون", 25, 2, "hot_lemon.png"),
    item("18d8aba5-a249-42de-8e7f-d7c4ff69f576", C_HOT, "حلبة", 15, 3, "hot_helba.png"),
    item("b613d13c-be6a-41a4-9050-c90a1cd243c4", C_HOT, "زنجبيل", 25, 4, "hot_ginger.png"),
    item("bab9f875-0416-4050-8de7-a4427b5f1891", C_HOT, "سحلب بالمكسرات", 45, 5, "hot_sahlab_nuts.png"),
    item("e3c03db8-d172-4a4f-b73b-f79c169c8eb5", C_HOT, "سحلب سادة", 30, 6, "hot_sahlab_plain.png"),
    item("983490dd-b355-4538-8228-992a4a5c7267", C_HOT, "شاي اخضر", 15, 7, "hot_tea_green.png"),
    item("da219f25-6979-4a09-b4b0-9b6ecb0af4da", C_HOT, "شاي بحليب", 30, 8, "hot_tea_milk.png"),
    item("c0d69845-687e-4b10-97dc-804abc4c7fb4", C_HOT, "قرفة بحليب", 45, 9, "hot_cinnamon_milk.png"),
    item("786be382-bb7c-480b-baa3-7af71213ac46", C_HOT, "قرفة سادة", 25, 10, "hot_cinnamon_plain.png"),
    item("636cdc54-0c88-4e34-b52a-1e71fc832613", C_HOT, "كركاديه", 25, 11, "hot_karkade.png"),
    item("f20dfff4-65ae-45d6-a94e-62d10912de86", C_HOT, "ينسون بليمون", 20, 12, "hot_anise_lemon.png"),
    item("9b260687-a56a-48e4-92bb-0eb5f9bd9c75", C_HOT, "ينسون", 15, 13, "hot_anise.png"),
    item(PH[0], C_COLD, "مياه معدنية", 10, 0, "cold_water.png"),
    item(PH[1], C_COLD, "جوافة باللبن", 45, 1, "cold_guava_milk.png"),
    item(PH[2], C_COLD, "عصير برتقال", 30, 2, "cold_orange.png"),
    item(PH[3], C_COLD, "عصير جوافة", 30, 3, "cold_guava.png"),
    item(PH[4], C_COLD, "عصير رمان", 50, 4, "cold_pomegranate.png"),
    item(PH[5], C_COLD, "عصير فراولة", 35, 5, "cold_strawberry.png"),
    item(PH[6], C_COLD, "عصير مانجو", 40, 6, "cold_mango.png"),
    item(PH[7], C_COLD, "عناب", 35, 7, "cold_enab.png"),
    item("57606515-5f5a-480f-bd8b-396a58233525", C_COLD, "ليمون نعناع", 30, 8, "cold_lemon_mint.png"),
    item("56df8269-ae01-465b-89a6-d852f73952bf", C_COLD, "ليمونادا", 35, 9, "cold_lemonade.png"),
    item("2d7a1ab0-eda6-458e-a024-88e8f6d38323", C_COLD, "مشروب بوريو", 50, 10, "cold_pureo.png"),
    item("2bdf3bd7-a8fa-4bc3-baad-9eefda27ad6c", C_COLD, "موز باللبن", 45, 11, "cold_banana_milk.png"),
    item("8912fac5-cac5-4c7b-8d09-a8c27576caab", C_SODA, "بيبسي", 30, 0, "soda_pepsi.png"),
    item("b2e85b7a-7dc9-470a-86f3-279e05eabf65", C_SODA, "سبرايت", 30, 1, "soda_sprite.png"),
    item("5e190c11-4e4f-43f8-ac3d-cec996e0ee90", C_SODA, "سفن أب", 30, 2, "soda_sevenup.png"),
    item("10d919f7-fdc5-4834-885a-0a0087dcf540", C_SODA, "شويبس أناناس", 35, 3, "soda_schweppes_pineapple.png"),
    item("0aa7527b-a203-4230-9e4f-86d198d645dd", C_SODA, "شويبس خوخ", 35, 4, "soda_schweppes_peach.png"),
    item("5194a1b0-8e7f-44f4-bbe6-00ddd141a5dd", C_SODA, "شويبس ليمون نعناع", 35, 5, "soda_schweppes_lemonmint.png"),
    item("daf86531-e0db-46ed-9dca-8393fa849218", C_SODA, "فانتا برتقال", 30, 6, "soda_fanta_orange.png"),
    item("f67534a0-819d-472e-b66a-7d1a8eb1af43", C_SODA, "فانتا تفاح", 30, 7, "soda_fanta_apple.png"),
    item("6e651901-3b1d-461c-af7a-93d2a814bb4c", C_SODA, "كوكاكولا", 30, 8, "soda_cola.png"),
    item("a3e6bb57-559b-4bbb-8704-c6da80c51ec8", C_SODA, "مشروب V", 35, 9, "soda_v.png"),
    item("1f6d6905-44bc-4833-8140-f61a770778ad", C_SODA, "ميرندا برتقال", 30, 10, "soda_mirinda.png"),
    item("1b2a8a12-a545-4364-8292-0c2ccbcb0957", C_FOOD, "أم علي", 50, 0, "food_om_ali.png"),
    item("b8aa9861-f89d-48a8-8cf5-bc09af6ef8d0", C_FOOD, "حمص الشام", 40, 1, "food_hummus.png"),
    item("3d5e589b-6bdf-4b4d-a434-5029badf1f08", C_FOOD, "زبادي بالعسل", 45, 2, "food_yogurt_honey.png"),
    item("d10c8859-05db-4007-b3ba-6d5d27e44a2c", C_FOOD, "زبادي فواكه", 50, 3, "food_yogurt_fruit.png"),
    item("9126714e-d2d7-4ed1-93f6-ea8e34a7f3eb", C_FOOD, "كوكتيل فواكه", 50, 4, "food_fruit_cocktail.png"),
    item("b8a617d6-ac63-4112-b110-8572fcdf2389", C_ICE, "آيس كريم شيكولاتة", 40, 0, "ice_chocolate.png"),
    item("fb3e401f-c8bd-400f-8ea2-ce14dbda188d", C_ICE, "آيس كريم فانيليا", 35, 1, "ice_vanilla.png"),
    item("c4069407-cce6-4321-a85d-de6332ff712d", C_ICE, "آيس كريم مانجو", 40, 2, "ice_mango.png"),
]

PRICE = {m["uuid"]: float(m["price"]) for m in menu_items}
NAME = {m["uuid"]: m["name"] for m in menu_items}

SHIFT_UUID = "0f4c2c1e-7a3b-4d59-9c14-8b6f2a10dd77"

CUST_AHMED = "c1a11111-1111-4111-8111-111111111111"

customers = [
    {"uuid": CUST_AHMED, "name": "أحمد سيد", "phone": "01001234567"},
]


def oitem(oi_uuid, mi_uuid, qty):
    price = PRICE[mi_uuid]
    return {
        "uuid": oi_uuid,
        "menu_item_uuid": mi_uuid,
        "name": NAME[mi_uuid],
        "price": f"{price:.2f}",
        "quantity": f"{qty:.3f}",
        "line_total": f"{price * qty:.2f}",
    }


def order(uuid, *, table_number, created, closed, items,
          customer_uuid=None, status,
          payment_method=None, cancel_reason=None):
    total = round(sum(PRICE[i["menu_item_uuid"]] * float(i["quantity"]) for i in items), 2)
    o = {
        "uuid": uuid,
        "customer_uuid": customer_uuid,
        "location": {"table_uuid": None, "number": table_number},
        "subtotal": f"{total:.2f}",
        "discount_amount": "0.00",
        "total": f"{total:.2f}",
        "created_at_client": created,
        "closed_at_client": closed,
        "items": items,
    }
    if status == "paid":
        o["payment_method"] = payment_method or "cash"
        o["paid_amount"] = f"{total:.2f}"
    elif status == "cancelled":
        o["cancel_reason"] = cancel_reason
    return o


paid_orders = [
    order("a0000001-0000-4000-8000-000000000001",
          table_number=5,
          created="2026-09-01T10:12:04.000Z",
          closed="2026-09-01T10:31:22.000Z",
          status="paid", payment_method="cash",
          items=[
              oitem("b0000001-0000-4000-8000-000000000001", "8d6ebe70-0a7b-45cf-a8c3-128474d117b7", 2),
              oitem("b0000001-0000-4000-8000-000000000002", "0ab51e8f-5447-47d1-88d9-2bc7da86fbe6", 1),
          ]),
    order("a0000002-0000-4000-8000-000000000002",
          table_number=3,
          created="2026-09-01T11:03:41.000Z",
          closed="2026-09-01T11:40:10.000Z",
          status="paid", payment_method="wallet",
          items=[
              oitem("b0000002-0000-4000-8000-000000000001", "e72dfd40-5097-4d53-9640-277e1f57bf6e", 1),
              oitem("b0000002-0000-4000-8000-000000000002", "b8a617d6-ac63-4112-b110-8572fcdf2389", 1),
          ]),
    order("a0000003-0000-4000-8000-000000000003",
          table_number=1,
          created="2026-09-01T12:22:00.000Z",
          closed="2026-09-01T12:35:47.000Z",
          status="paid", payment_method="cash",
          items=[
              oitem("b0000003-0000-4000-8000-000000000001", "0edf8305-3cd3-4777-b25c-fc911be1d722", 3),
          ]),
]

cancelled_orders = [
    order("a0000004-0000-4000-8000-000000000004",
          table_number=7,
          created="2026-09-01T11:15:00.000Z",
          closed="2026-09-01T11:19:30.000Z",
          status="cancelled", cancel_reason="العميل مشي قبل التحضير",
          items=[
              oitem("b0000004-0000-4000-8000-000000000001", "8912fac5-cac5-4c7b-8d09-a8c27576caab", 2),
          ]),
]

deferred_orders = [
    order("a0000005-0000-4000-8000-000000000005",
          table_number=2,
          customer_uuid=CUST_AHMED,
          created="2026-09-01T13:05:00.000Z",
          closed="2026-09-01T13:44:12.000Z",
          status="deferred",
          items=[
              oitem("b0000005-0000-4000-8000-000000000001", "1b2a8a12-a545-4364-8292-0c2ccbcb0957", 1),
              oitem("b0000005-0000-4000-8000-000000000002", "00000000-0000-4000-8000-000000000006", 1),
          ]),
]


def txn(uuid, title, subtitle, amount, is_income, at):
    return {
        "uuid": uuid, "shift_uuid": SHIFT_UUID, "employee_id": 6,
        "title": title, "subtitle": subtitle,
        "amount": f"{amount:.2f}", "is_income": is_income,
        "created_at_client": at,
    }


treasury_transactions = [
    txn("d0000001-0000-4000-8000-000000000001", "دفع طلب", "ترابيزة 5", 80.00, True, "2026-09-01T10:31:22.000Z"),
    txn("d0000002-0000-4000-8000-000000000002", "دفع طلب", "ترابيزة 3", 75.00, True, "2026-09-01T11:40:10.000Z"),
    txn("d0000003-0000-4000-8000-000000000003", "دفع طلب", "ترابيزة 1", 45.00, True, "2026-09-01T12:35:47.000Z"),
    txn("d0000004-0000-4000-8000-000000000004", "مصروف", "شراء ثلج", 30.00, False, "2026-09-01T12:50:00.000Z"),
]

OPENING = 500.00
income = sum(float(t["amount"]) for t in treasury_transactions if t["is_income"])
expense = sum(float(t["amount"]) for t in treasury_transactions if not t["is_income"])
closing = OPENING + income - expense

payload = {
    "sync_uuid": "3a9f0e21-4c8d-4b7a-9f10-2d6e5c1b8a44",
    "cashier": {"employee_id": 6},
    "shift": {
        "uuid": SHIFT_UUID,
        "employee_id": 6,
        "opening_balance": f"{OPENING:.2f}",
        "closing_balance": f"{closing:.2f}",
        "started_at": "2026-09-01T10:00:00.000Z",
        "closed_at": "2026-09-01T14:30:00.000Z",
    },
    "customers": customers,
    "categories": categories,
    "menu_items": menu_items,
    "paid_orders": paid_orders,
    "cancelled_orders": cancelled_orders,
    "deferred_orders": deferred_orders,
    "payments": [],
    "treasury_transactions": treasury_transactions,
    "deleted_customers": [],
    "deleted_categories": [],
    "deleted_menu_items": [],
}

compact = json.dumps(payload, ensure_ascii=False, separators=(",", ":"))
raw = compact.encode("utf-8")

print("categories:", len(categories))
print("menu_items:", len(menu_items))
print("customers:", len(customers))
print("paid_orders:", len(paid_orders), " cancelled:", len(cancelled_orders),
      " deferred:", len(deferred_orders))
print("treasury_transactions:", len(treasury_transactions))
print(f"closing_balance: {closing:.2f}  (opening {OPENING:.2f} + income {income:.2f} - expense {expense:.2f})")
print("compact json bytes:", len(raw))
print("sha256(json):", hashlib.sha256(raw).hexdigest())

pretty = json.dumps(payload, ensure_ascii=False, indent=2)

outdir = sys.argv[1] if len(sys.argv) > 1 else "."
with open(f"{outdir}/sync_data.json", "w", encoding="utf-8") as f:
    f.write(pretty + "\n")
with open(f"{outdir}/sync_data.compact.json", "wb") as f:
    f.write(raw)
buf = io.BytesIO()
with gzip.GzipFile(filename="sync_data.json", mode="wb", fileobj=buf, mtime=0) as gz:
    gz.write(raw)
gzbytes = buf.getvalue()
with open(f"{outdir}/sync_data.json.gz", "wb") as f:
    f.write(gzbytes)
print("gzip bytes:", len(gzbytes))

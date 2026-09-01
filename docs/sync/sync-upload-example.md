# Sync Upload — مثال الـ Payload كامل (للـ Backend)

**Endpoint:** `POST https://cafe.matrixclouds.net/api/v1/sync/upload`
**Content-Type:** `multipart/form-data`
**Auth:** `Authorization: Bearer <token>` (نفس توكن باقي الـ requests)

الريكوست بيتبعت كـ multipart فيه جزء أو جزئين:

| الـ part | اسم الملف | إجباري؟ | المحتوى |
|---|---|---|---|
| `data` | `sync_data.json.gz` | ✅ دايمًا | ملف الـ JSON اللي تحت، **مضغوط gzip** |
| `images` | `images.zip` | اختياري | ملف zip فيه صور الأصناف/الكاتيجوريز الجديدة. بيتبعت **بس** لو فيه `image_key` واحد على الأقل في الـ JSON، غير كده مش موجود خالص |

---

## مثال الـ JSON (بعد فك الـ gzip)

```json
{
  "sync_uuid": "9f1c2d7e-4a6b-4c11-9e2f-1a2b3c4d5e6f",

  "cashier": {
    "employee_id": 12
  },

  "shift": {
    "uuid": "c0a80101-7d3e-4b2a-8f10-2b9d4e6f7a01",
    "employee_id": 12,
    "opening_balance": "500.00",
    "closing_balance": "1850.00",
    "started_at": "2026-08-27T06:00:00.000Z",
    "closed_at": "2026-08-27T14:00:00.000Z"
  },

  "customers": [
    {
      "uuid": "d1e2f3a4-1111-4c22-9a33-4b5c6d7e8f90",
      "name": "أحمد محمد",
      "phone": "01001234567"
    }
  ],

  "categories": [
    {
      "uuid": "a1a1a1a1-2222-4c33-9d44-5e6f7a8b9c01",
      "name": "مشروبات ساخنة",
      "sort_order": 0,
      "is_active": true,
      "is_default": true,
      "image_key": null,
      "local_asset_path": "assets/images/seed_items/hot_drink.png"
    },
    {
      "uuid": "b2b2b2b2-3333-4c44-9e55-6f7a8b9c0d12",
      "name": "ساندويتشات",
      "sort_order": 5,
      "is_active": true,
      "is_default": false,
      "image_key": "b2b2b2b2-3333-4c44-9e55-6f7a8b9c0d12.jpg",
      "local_asset_path": null
    }
  ],

  "menu_items": [
    {
      "uuid": "c3c3c3c3-4444-4c55-9f66-7a8b9c0d1e23",
      "category_uuid": "a1a1a1a1-2222-4c33-9d44-5e6f7a8b9c01",
      "name": "شاي",
      "price": "10.00",
      "sort_order": 0,
      "is_active": true,
      "is_default": true,
      "image_key": null,
      "local_asset_path": "assets/images/seed_items/tea.png"
    },
    {
      "uuid": "d4d4d4d4-5555-4c66-9a77-8b9c0d1e2f34",
      "category_uuid": "b2b2b2b2-3333-4c44-9e55-6f7a8b9c0d12",
      "name": "ساندويتش حلاوة",
      "price": "25.00",
      "sort_order": 1,
      "is_active": true,
      "is_default": false,
      "image_key": "d4d4d4d4-5555-4c66-9a77-8b9c0d1e2f34.png",
      "local_asset_path": null
    }
  ],

  "paid_orders": [
    {
      "uuid": "e5e5e5e5-6666-4c77-9b88-9c0d1e2f3a45",
      "customer_uuid": null,
      "location": {
        "table_uuid": "f6f6f6f6-7777-4c88-9c99-0d1e2f3a4b56",
        "number": 3
      },
      "subtotal": "45.00",
      "discount_amount": "0.00",
      "total": "45.00",
      "created_at_client": "2026-08-27T09:10:00.000Z",
      "closed_at_client": "2026-08-27T09:35:00.000Z",
      "items": [
        {
          "uuid": "a7a7a7a7-8888-4c99-9daa-1e2f3a4b5c67",
          "menu_item_uuid": "c3c3c3c3-4444-4c55-9f66-7a8b9c0d1e23",
          "name": "شاي",
          "price": "10.00",
          "quantity": "2.000",
          "line_total": "20.00"
        },
        {
          "uuid": "b8b8b8b8-9999-4caa-9ebb-2f3a4b5c6d78",
          "menu_item_uuid": "d4d4d4d4-5555-4c66-9a77-8b9c0d1e2f34",
          "name": "ساندويتش حلاوة",
          "price": "25.00",
          "quantity": "1.000",
          "line_total": "25.00"
        }
      ],
      "payment_method": "cash",
      "paid_amount": "45.00"
    }
  ],

  "cancelled_orders": [
    {
      "uuid": "c9c9c9c9-aaaa-4cbb-9fcc-3a4b5c6d7e89",
      "customer_uuid": null,
      "location": {
        "table_uuid": null,
        "number": 7
      },
      "subtotal": "30.00",
      "discount_amount": "0.00",
      "total": "30.00",
      "created_at_client": "2026-08-27T10:00:00.000Z",
      "closed_at_client": "2026-08-27T10:05:00.000Z",
      "items": [
        {
          "uuid": "dadadada-bbbb-4ccc-9add-4b5c6d7e8f90",
          "menu_item_uuid": "c3c3c3c3-4444-4c55-9f66-7a8b9c0d1e23",
          "name": "شاي",
          "price": "10.00",
          "quantity": "3.000",
          "line_total": "30.00"
        }
      ],
      "cancel_reason": "العميل مشي قبل التحضير"
    }
  ],

  "deferred_orders": [
    {
      "uuid": "ebebebeb-cccc-4ddd-9bee-5c6d7e8f9a01",
      "customer_uuid": "d1e2f3a4-1111-4c22-9a33-4b5c6d7e8f90",
      "location": {
        "table_uuid": null,
        "number": 1
      },
      "subtotal": "60.00",
      "discount_amount": "0.00",
      "total": "60.00",
      "created_at_client": "2026-08-27T11:20:00.000Z",
      "closed_at_client": "2026-08-27T11:45:00.000Z",
      "items": [
        {
          "uuid": "fcfcfcfc-dddd-4eee-9cff-6d7e8f9a0b12",
          "menu_item_uuid": "d4d4d4d4-5555-4c66-9a77-8b9c0d1e2f34",
          "name": "ساندويتش حلاوة",
          "price": "25.00",
          "quantity": "2.000",
          "line_total": "50.00"
        },
        {
          "uuid": "0d0d0d0d-eeee-4fff-9d00-7e8f9a0b1c23",
          "menu_item_uuid": "c3c3c3c3-4444-4c55-9f66-7a8b9c0d1e23",
          "name": "شاي",
          "price": "10.00",
          "quantity": "1.000",
          "line_total": "10.00"
        }
      ]
    }
  ],

  "payments": [
    {
      "uuid": "1e1e1e1e-ffff-4a11-9e22-8f9a0b1c2d34",
      "order_uuid": "aa11bb22-1234-4c56-9d78-9a0b1c2d3e45",
      "shift_uuid": "c0a80101-7d3e-4b2a-8f10-2b9d4e6f7a01",
      "type": "debt_collection",
      "payment_method": "cash",
      "amount": "60.00",
      "paid_at": "2026-08-27T12:30:00.000Z"
    }
  ],

  "treasury_transactions": [
    {
      "uuid": "2f2f2f2f-0000-4b22-9f33-9a0b1c2d3e46",
      "shift_uuid": "c0a80101-7d3e-4b2a-8f10-2b9d4e6f7a01",
      "employee_id": 12,
      "title": "شراء مستلزمات",
      "subtitle": "أكياس سكر + شاي",
      "amount": "120.00",
      "is_income": false,
      "created_at_client": "2026-08-27T08:15:00.000Z"
    },
    {
      "uuid": "3a3a3a3a-1111-4c33-9a44-0b1c2d3e4f57",
      "shift_uuid": "c0a80101-7d3e-4b2a-8f10-2b9d4e6f7a01",
      "employee_id": 12,
      "title": "إيداع نقدي",
      "subtitle": "من الخزنة الرئيسية",
      "amount": "300.00",
      "is_income": true,
      "created_at_client": "2026-08-27T13:00:00.000Z"
    }
  ],

  "deleted_customers": [
    "aaaaaaaa-1111-4b22-9c33-111111111111"
  ],
  "deleted_categories": [
    "bbbbbbbb-2222-4c33-9d44-222222222222"
  ],
  "deleted_menu_items": [
    "cccccccc-3333-4d44-9e55-333333333333"
  ]
}
```

---

## وصف الحقول

كل الـ `uuid` بيتولّد من الموبايل (UUID v4) وثابت مدى الحياة. الـ id الرقمي المحلي مش بيتبعت خالص.
كل المبالغ والكميات بتتبعت كـ **string** (`"45.00"` للفلوس، `"2.000"` للكمية). كل التواريخ **UTC ISO-8601**.

### الجذر

| الحقل | الوصف |
|---|---|
| `sync_uuid` | معرّف فريد للـ upload attempt نفسه. لو الريكوست فشل واتعاد، بيتبعت بنفس القيمة → استخدمه عشان تتجاهل الريكوست المكرر (idempotency). |
| `cashier.employee_id` | الموظف اللي بيعمل الـ upload حاليًا (اللي فاتح التطبيق). |

### `shift` — الوردية اللي بتتقفل

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف الوردية. |
| `employee_id` | الموظف اللي فتح الوردية. |
| `opening_balance` / `closing_balance` | رصيد الخزنة أول وآخر الوردية. `closing_balance` ممكن يكون `null` لو لسه ماتقفلتش (مش المفروض يحصل في الـ upload). |
| `started_at` / `closed_at` | وقت فتح وقفل الوردية. |

> كل الطلبات والحركات اللي تحت بتخص الوردية دي: أي سجل وقته بين `started_at` و `closed_at` بيتحسب عليها.

### `customers[]` — العملاء الجدد/المتعدّلين

بيتبعت العميل هنا لو **جديد** أو **اتعدّل** ولسه ماترفعش. تحديث كامل للأوبجكت (مش diff).

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف العميل. |
| `name` / `phone` | الاسم والتليفون. |

### `categories[]` — أقسام المنيو الجديدة/المتعدّلة

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف القسم. |
| `name` | اسم القسم. |
| `sort_order` | ترتيب الظهور في المنيو (رقم). |
| `is_active` | دايمًا `true` حاليًا. |
| `is_default` | `true` لو القسم من المنيو الجاهزة اللي بتيجي مع التطبيق، `false` لو الكافيه ضافه بنفسه. |
| `image_key` | اسم ملف الصورة جوا `images.zip` (زي `"<uuid>.jpg"`). بيكون `null` لو مفيش صورة مرفوعة (القسم الافتراضي بصورته الأصلية). |
| `local_asset_path` | مسار الصورة الجاهزة جوا التطبيق. بييجي بدل `image_key` للأقسام الافتراضية اللي لسه بصورتها الأصلية — للعلم فقط، مفيش بايتات صورة بتترفع لها. |

### `menu_items[]` — أصناف المنيو الجديدة/المتعدّلة

نفس منطق `categories`، بالإضافة لـ:

| الحقل | الوصف |
|---|---|
| `category_uuid` | القسم اللي الصنف تابع له. |
| `price` | سعر الصنف. |

### الطلبات — `paid_orders[]` / `cancelled_orders[]` / `deferred_orders[]`

مقسومة حسب حالة الطلب: مدفوع / ملغي / آجل (على الحساب). بنية الطلب واحدة في التلاتة:

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف الطلب. |
| `customer_uuid` | العميل المرتبط بالطلب، أو `null` لو زبون عادي (بدون حساب). |
| `location.table_uuid` | معرّف الطاولة، أو `null` لو الطلب مش مربوط بطاولة. |
| `location.number` | رقم الطاولة/الطلب الظاهر للكاشير. |
| `subtotal` | إجمالي الأصناف قبل الخصم. |
| `discount_amount` | قيمة الخصم (حاليًا دايمًا `"0.00"`). |
| `total` | الإجمالي النهائي. |
| `created_at_client` / `closed_at_client` | وقت فتح وقفل الطلب. |
| `items[]` | أصناف الطلب (تفصيل تحت). |

حقول إضافية حسب النوع:

| النوع | حقول زيادة |
|---|---|
| `paid_orders[]` | `payment_method` (`"cash"` أو `"wallet"`) + `paid_amount` (المبلغ المدفوع). |
| `cancelled_orders[]` | `cancel_reason` (سبب الإلغاء، ممكن يكون `null`). |
| `deferred_orders[]` | مفيش حقول زيادة. |

#### `items[]` داخل الطلب

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف سطر الصنف في الطلب. |
| `menu_item_uuid` | الصنف الأصلي من المنيو. |
| `name` / `price` | اسم وسعر الصنف وقت الطلب (snapshot). |
| `quantity` | الكمية (`"2.000"`). |
| `line_total` | `price × quantity`. |

### `payments[]` — تحصيل طلبات آجلة قديمة

بيظهر هنا بس لما عميل يدفع طلب **آجل كان اترفع في وردية سابقة**. بنبعت حركة الدفع بس، مش الطلب نفسه تاني.

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف عملية الدفع (جديد). |
| `order_uuid` | الطلب الآجل القديم اللي اتدفع. |
| `shift_uuid` | الوردية الحالية اللي اتحصل فيها المبلغ. |
| `type` | دايمًا `"debt_collection"`. |
| `payment_method` | طريقة الدفع (`"cash"` افتراضيًا). |
| `amount` | المبلغ المحصّل. |
| `paid_at` | وقت التحصيل. |

### `treasury_transactions[]` — حركات الخزنة

أي إيداع/مصروف على الخزنة خلال الوردية.

| الحقل | الوصف |
|---|---|
| `uuid` | معرّف الحركة. |
| `shift_uuid` | الوردية بتاعتها. |
| `employee_id` | الموظف اللي عمل الحركة (ممكن يكون `null`). |
| `title` / `subtitle` | وصف الحركة. |
| `amount` | القيمة. |
| `is_income` | `true` = دخل للخزنة، `false` = مصروف. |
| `created_at_client` | وقت الحركة. |

### `deleted_*[]` — المحذوفات

قوايم `uuid` بس لعناصر **اتحذفت بعد ما كانت اترفعت** قبل كده. لو عنصر اتعمل واتحذف محليًا من غير ما يترفع خالص، مش بيظهر هنا.

| الحقل | الوصف |
|---|---|
| `deleted_customers[]` | معرّفات عملاء اتحذفوا. |
| `deleted_categories[]` | معرّفات أقسام اتحذفت. |
| `deleted_menu_items[]` | معرّفات أصناف اتحذفت. |

---

## الرد المتوقع من السيرفر

الموبايل بيقرأ من `data` في الرد:

```json
{
  "message": "...",
  "status": true,
  "data": {
    "sync_uuid": "9f1c2d7e-4a6b-4c11-9e2f-1a2b3c4d5e6f",
    "shift_uuid": "c0a80101-7d3e-4b2a-8f10-2b9d4e6f7a01",
    "duplicate": false
  }
}
```

| الحقل | الوصف |
|---|---|
| `sync_uuid` | نفس اللي اتبعت (تأكيد). |
| `shift_uuid` | معرّف الوردية عند السيرفر. لو رجع مختلف عن اللي اتبعت، الموبايل بيحدّث المحلي بقيمة السيرفر. |
| `duplicate` | `true` لو الريكوست ده وصل قبل كده بنفس `sync_uuid` واتعالج — الموبايل بيعتبرها نجاح عادي. |

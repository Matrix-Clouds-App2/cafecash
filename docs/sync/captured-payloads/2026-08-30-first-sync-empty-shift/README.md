# Captured sync payload — أول Sync لوردية فاضية (2026-08-30)

نسخة **حقيقية** من الـ payload اللي طلع من تطبيق الكاشير في محاولة رفع فعلية، متسحبة من `logcat` بتاريخ 2026-08-30. الغرض إن الباك إند يقدر يعيد نفس الريكوست بالظبط ويشوف الخطأ عنده.

## سياق المحاولة

| | |
|---|---|
| الجهاز | Android (`com.coffee_cash`, pid 9894) |
| `sync_uuid` | `6e781dfb-cc80-4bfd-8393-62a71f008cbf` |
| `shift.uuid` | `b9515b4d-2724-4bc7-9098-4fb01ba957c6` |
| `cashier.employee_id` / `shift.employee_id` | `6` |
| الوردية | فُتحت `2026-08-30T09:57:27.934Z`، قُفلت `2026-08-30T09:58:01.470862Z`، رصيد `500.00 → 500.00` |
| المحتوى | الكتالوج الافتراضي بس (6 أقسام + 52 صنف، كلهم `is_default: true`, `image_key: null`). صفر عملاء، صفر طلبات، صفر حركات خزنة، صفر محذوفات |
| `images.zip` | **مش موجود** — مفيش أي `image_key` في الـ payload، فالتطبيق ما بيبعتش الـ part ده أصلًا |

## الملفات

| الملف | إيه هو |
|---|---|
| `sync_data.json` | الـ payload مقروء (pretty-printed, indent=2). **للقراءة فقط** — مش ده اللي بيتبعت بالظبط |
| `sync_data.compact.json` | الـ JSON بالظبط زي ما التطبيق بيسلسله (`jsonEncode` — من غير أي مسافات، UTF-8، العربي مش escaped). **ده اللي بيتضغط ويتبعت** |
| `sync_data.json.gz` | نسخة gzip من `sync_data.compact.json` |

## إثبات إن اللي في الملفات ده مطابق للي التطبيق بعته فعلًا

التطبيق طبع في اللوج بالحرف:

```
╟ sync_data.json.gz: 16231 bytes -> 3184 bytes gzipped
```

الـ `sync_data.compact.json` هنا **حجمه 16231 byte بالظبط** — نفس الرقم اللي التطبيق قاسه قبل الضغط. يعني بنية الـ payload متطابقة 100% مع اللي اتبعت.

```
sha256(sync_data.compact.json) = 6bb0aad90a684fde9ad7a6f37bd05e025923d7d1c5369abdfb0904a9b768dc1f
عدد البايتات                    = 16231   (التطبيق: 16231 ✓)
```

### تحفظ واحد: 8 UUIDs

اللوج على أندرويد بيقص السطور لما تعدّي حد معيّن (`LOG_FLOWCTRL: LOGS OVER PROC QUOTA … DROPPED`)، وده أكل سطور 8 أصناف من قسم "عصائر ومشروبات باردة" (`sort_order` من 0 لـ 7: مياه معدنية، جوافة باللبن، عصير برتقال، عصير جوافة، عصير رمان، عصير فراولة، عصير مانجو، عناب).

الأصناف نفسها (الاسم/السعر/الترتيب/الصورة) اتعوّضت من الـ seeder بتاع التطبيق (`lib/core/utils/default_items_seeder.dart`)، لكن الـ `uuid` بتاعهم مش معروف فحطّينا placeholder شكله:

```
00000000-0000-4000-8000-0000000000NN
```

ده **مش بيأثر على حجم الـ payload ولا بنيته** (كل UUID طوله 36 حرف ثابت)، فالـ 16231 byte لسه صح. لو الباك إند محتاج الـ UUIDs الحقيقية دي، محتاجين نعيد سحب لوج كامل من غير قص (`adb logcat -v time > full.log` وقت الرفع) ونحدّث الملفات.

## إزاي الريكوست بيتبعت (الغلاف)

```
POST https://cafe.matrixclouds.net/api/v1/sync/upload
Content-Type: multipart/form-data; boundary=<auto>
Authorization: Bearer <token>
Accept-Language: ar
```

| الـ part | اسم الملف | المحتوى |
|---|---|---|
| `data` | `sync_data.json.gz` | gzip لـ `sync_data.compact.json` |
| `images` | `images.zip` | **مش موجود في الحالة دي** (مفيش `image_key`) |

الاستجابة اللي التطبيق بيقراها: `{ "message", "status", "data": { "sync_uuid", "shift_uuid", "duplicate" } }`.

تفاصيل الحقول كاملة في `../../sync-upload-example.md` و `../../ai-reference.md`.

### ملحوظة عن الـ gzip

التطبيق بيضغط بـ deflate مكتوب بالـ Dart (`archive` package) — أضعف شوية من `zlib`، عشان كده طلع عنده 3184 byte، وأي أداة `gzip` عادية هتطلع رقم أقل شوية لنفس المحتوى. **المحتوى بعد فك الضغط واحد بايت-بايت** (نفس الـ 16231 byte، نفس الـ sha256 فوق) — وده اللي الباك إند بيتعامل معاه. اختلاف بايتات الغلاف مالوش أي علاقة بأي 4xx/5xx.

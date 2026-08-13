# Vivacare White Label — دليل المشروع

Flutter base template (White Label) بيستخدم **Cubit (flutter_bloc)** لإدارة الحالة، **GetIt** لل-DI، **Dio** للنتورك، **easy_localization** للترجمة، و**flutter_screenutil** للمقاسات. الهدف إن أي فيتشر جديدة تتبني بنفس الباترن ده بالظبط.

---

## 1) هيكل الفولدرات (Structure)

```
lib/
  app/
    app.dart                 # MyApp: MultiBlocProvider + MaterialApp + ScreenUtilInit
    router/
      routes.dart             # أسماء الـ routes (constants)
      app_router.dart          # RouteGenerator.generateRoute (switch-case)
      navigation_services.dart # navigatorKey عشان الناڤيجيشن من بره الـ widget tree
    theme/
      app_theme.dart           # lightTheme / darkTheme

  core/
    di/injection.dart          # setupDi() — تسجيل كل حاجة في GetIt
    network/
      dio_client.dart          # DioClient (get/post/put/patch/delete/postForm/putForm) + Auth/Lang interceptors
      api_endpoints.dart        # كل الـ paths (base + endpoints) في مكان واحد
      api_response.dart         # ApiResponse<T> wrapper عام (message/status/data)
      network_exceptions.dart   # NetworkException.fromDioException(e)
    storage/local_storage.dart # GetStorage (عادي) + FlutterSecureStorage (للـ token فقط)
    utils/
      app_colors.dart           # AppColors + ColorModel (light/dark) — كل الألوان من هنا
      app_constants.dart        # AppConstants (paddings, radius, durations, pageSize...) + kUserModel/kIsGuest
      app_images.dart           # AppImages (كل مسارات الصور والأيقونات)
      locale_keys.dart          # LocaleKeys (مفاتيح الترجمة) — مرآة لملفات en.json/ar.json
      app_overlay.dart          # AppOverlay.showError/showSuccess (بانر بدل SnackBar)
      convert_helper.dart / helper_methods.dart
    widgets/                    # الـ Widgets العامة المشتركة بين كل الفيتشرز (شرح تفصيلي تحت)
    extensions/extensions.dart # num.height/.width/.paddingX + BuildContext.pushNamed...

  features/
    <feature_name>/
      data/
        <feature>_repo.dart     # بيكلم DioClient مباشرة ويرجع Model أو يرمي NetworkException
        models/*.dart            # الموديلز (fromJson/toJson) — Equatable
      logic/
        <feature>_cubit.dart     # الـ Cubit، بيستدعي الـ Repo فقط (مش Dio مباشرة)
        <feature>_state.dart     # part of الـ cubit — sealed states (Initial/Loading/Success/Error)
      presentation/
        <name>_screen.dart       # الشاشة نفسها بس (build + state management)، من غير أي private widget كلاس
        widgets/                 # ✅ إجباري: أي جزء UI مُقسّم بييجي هنا في ملف منفصل
          <widget_name>.dart
```

الفيتشرز الموجودة دلوقتي: `auth`, `home`, `profile`, `more`, `layout`, `onboarding`, `splash`.

---

## 2) قاعدة الـ Widgets — أهم حاجة تتاخد بالجدية

> **ممنوع** إنك تعمل private widget (`_HeaderSection`, `_ProfileCard`, `_MoreTile`...) جوا نفس ملف الشاشة أو تحت الكلاس الرئيسي بـ underscore.
> **لازم** كل جزء UI منفصل (تقسيمة منطقية للشاشة) يبقى **كلاس عام (public)** في **ملف منفصل** جوا `presentation/widgets/` بتاعة نفس الفيتشر.

- مسار الملف: `lib/features/<feature>/presentation/widgets/<widget_name>.dart`
- اسم الملف بـ snake_case، اسم الكلاس بـ PascalCase وعادةً مش بيبدأ بـ underscore (إلا لو داخلي جدًا جوا نفس ملف الويدجت وده استثناء نادر مثل helper class صغير جوا نفس ملف الويدجت).
- في `lib/features/auth/presentation/widgets/` فيه ملف `.gitkeep` بس — يعني الفولدر اتعمل بالفعل وناقص إنه يتاستخدم.
- **ملاحظة (دين تِكنيكال موجود):** حاليًا `login_screen.dart`, `more_screen.dart`, `on_boarding_screen.dart`, `layout_screen.dart` كلهم فيهم private widgets جوا نفس الملف (زي `_HeaderSection`, `_ProfileCard`, `_MoreTile`, `_LanguageSheet`, `_ConfirmDialog`, `_CustomNavBar`...). **القاعدة الجديدة تتطبق على أي كود جديد أو أي تعديل في الملفات دي من دلوقتي** — لو هتلمس أي شاشة من دول، انقل الـ widgets الداخلية بتاعتها لفولدر `widgets/` بتاعتها كجزء من الشغل.
- الويدجتس العامة اللي بتتشارك بين أكتر من فيتشر تروح `lib/core/widgets/` مش جوا فيتشر معينة.

### الاستثناء الوحيد
`State` class بتاعة `StatefulWidget` (زي `_LoginScreenState`) ده مش "widget مقسّم" وليه استثناء طبيعي في Flutter — ده جزء أساسي من الـ StatefulWidget نفسه، مش المقصود بالقاعدة.

---

## 3) Core Widgets الجاهزة (استخدمها بدل ما تعمل واحدة جديدة)

كل دول في `lib/core/widgets/` — **قبل ما تعمل widget جديد دور هنا الأول**:

| Widget | الاستخدام |
|---|---|
| `AppText` | بديل `Text` — بيحط `fontFamily: 'Cairo'` تلقائي. **استخدمه دايمًا بدل `Text` العادي** لأي نص في التطبيق. |
| `CustomButton` (`app_button.dart`, الاسم القديم `AppButton` متعمل له alias) | الزرار الأساسي — بارامترز: `title`/`child`, `color`, `borderColor`, `textColor`, `isOutlined`, `loading`, `expanded`, `radius`... بيحتوي على `CustomLoadingWidget` تلقائي لو `loading: true`. |
| `CustomTextField` (`app_text_field.dart`, alias قديم `AppTextField`) | حقل الإدخال الموحّد — فيه `isPassword` (بيتحكم في obscure + toggle icon تلقائي)، ألوان بوردر افتراضية، ودعم لـ validator. |
| `CustomLoadingWidget` | Loading indicator موحّد (`loading_animation_widget`). |
| `CustomTapEffect` | Wrapper بيدي "scale animation" بسيط لأي حاجة قابلة للضغط بدل `GestureDetector` العادي لو عايز إحساس لمسة. |
| `PrimaryHeader` | الهيدر الأخضر الرئيسي مع الدائرة الذهبية الشفافة (مستخدم في Login وHome). |
| `CustomImage` / `CustomImageOnlyRadius` | صورة Network مع `errorBuilder` بيرجع لـ `AppImages.holder` تلقائيًا لو فشل التحميل. `openBottomSheet()` لعرض الصورة full-screen بالـ `PhotoView`. |
| `CustomScreenStateLayout` (`screen_state_layout.dart`) | Wrapper موحّد لحالات الشاشة: `isLoading` / `error` (`ErrorModel`) / `isEmpty` / success — بيرجع `CustomLoadingWidget` / `CustomErrorView` / `CustomNoDataView` تلقائيًا لو مبعتش builder مخصص. **استخدمه في أي شاشة فيها API call بدل ما تكتب if/else يدوي.** |
| `AppEmpty` / `AppError` | حالات فاضية/خطأ بسيطة مستقلة (لو مش محتاج الـ layout الكامل). |
| `CustomPaginationListView<T>` / `CustomPaginationGridview<T>` (`pagination_widgets/`) | لستة/جريد مع **infinite scroll pagination** جاهز (`onLoadMore`, `hasMorePages`, `isMoreLoading`, `onRefresh`). استخدمهم لأي API فيه pagination بدل ما تعمل `ScrollController` يدوي. |
| `AppOverlay` (`utils/app_overlay.dart`) | `AppOverlay.showError(msg)` / `AppOverlay.showSuccess(msg)` — بانر متحرك أعلى الشاشة بدل `ScaffoldMessenger`/`SnackBar`. الـ Cubits بتنادي عليه مباشرة عند الخطأ. |

---

## 4) الألوان (Colors)

كل الألوان في `lib/core/utils/app_colors.dart` عن طريق `ColorModel(lightColor, darkColor)`:

```dart
AppColors.primaryColor      // 0xff0a3320 (أخضر غامق) — نفس اللون light/dark
AppColors.secondaryColor    // 0xff1B5583 (أزرق)
AppColors.backgroundColor   // أبيض / 0xff121212
AppColors.surfaceColor
AppColors.textPrimaryColor  // 0xff1A1A1A / أبيض
AppColors.textSecondaryColor
AppColors.errorColor
AppColors.successColor
AppColors.dividerColor
AppColors.hintColor
AppColors.cardColor
AppColors.accentGold        // 0xFFD4A843 — لزرار الـ CTA النهائي في الـ onboarding وبعض التفاصيل الذهبية
```

**قاعدة الاستخدام:** متستخدمش `.light` أو `.dark` مباشرة في الـ UI. استخدم دايمًا:

```dart
AppColors.primaryColor.themeColor
```

`themeColor` (extension `ColorTheme`) بيقرأ `Theme.of(context).brightness` تلقائي من الـ `navigationKey.currentContext` ويرجع اللون المناسب. لو محتاج لون جديد مش موجود، **ضيفه في `AppColors` كـ `ColorModel` جديد** (متكتبش `Color(0xFF...)` inline في الشاشات إلا لو تفصيلة صغيرة جدًا خاصة بشاشة واحدة زي اللي موجودة حاليًا في `login_screen.dart`/`more_screen.dart` — الأفضل حتى دي تترفع لـ `AppColors` أول ما تتكرر في مكان تاني).

الـ Theme نفسه (`app_theme.dart`) بيبني `ColorScheme.fromSeed` من `AppColors.primaryColor` + خط `Cairo` كـ font family افتراضي، و`themeMode: ThemeMode.light` مضبوط حاليًا في `app.dart` (الـ dark theme موجود بس مش مفعّل).

---

## 5) الترجمة (Localization)

- الباكدج: `easy_localization`. ملفات الترجمة: `assets/translations/en.json` و`assets/translations/ar.json` (لازم يفضلوا متطابقين في المفاتيح).
- كل مفتاح ترجمة **لازم** يتضاف في `lib/core/utils/locale_keys.dart` كـ `static const String` (نفس الـ dot path بالظبط، مقسّم بأقسام بكومنتات `// ─── Section ───`).
- الاستخدام في الكود: `LocaleKeys.auth_login.tr()` (من `easy_localization`). ممنوع نص hardcoded في الـ UI (لا بالعربي ولا بالإنجليزي) — لازم يمر على `LocaleKeys` + `en.json`/`ar.json`.
- عند إضافة نص جديد: (1) ضيفه في `en.json` و`ar.json` بنفس المفتاح، (2) ضيف الـ constant المطابق في `locale_keys.dart`، (3) استخدمه بـ `.tr()`.
- اللغة الافتراضية `ar` (`LocalStorage.getLang() => 'ar'` لو مفيش قيمة محفوظة)، وبتتغيّر من `MoreScreen._showLanguageSheet` وبتترسل في هيدر كل request كـ `Accept-Language` (شوف `dio_client.dart`).

---

## 6) دورة الـ API (API Cycle)

```
UI (Screen)
  └─ context.read<XCubit>().doSomething(...)
        └─ Cubit: emit(Loading) → يستدعي Repo.method()
              └─ Repo: بيستخدم getIt<DioClient>() (get/post/put/patch/delete/postForm/putForm)
                    └─ DioClient: بيحط baseUrl + Authorization header (لو فيه token) + Accept-Language + PrettyDioLogger (debug فقط)
                          └─ عند 401: يمسح كل التخزين ويرجع Login تلقائيًا (AuthInterceptor.onError) + AppOverlay.showError
              └─ Repo: يحول response.data لـ Model (UserModel.fromJson) أو يرمي NetworkException.fromDioException(e)
        └─ Cubit: emit(Success(model)) أو catch(e) → emit(Error(msg)) + غالبًا AppOverlay.showError(msg)
  └─ UI: BlocBuilder/BlocListener/BlocSelector بيقرأ الـ State ويبني الشاشة (أو CustomScreenStateLayout لو فيه loading/error/empty)
```

نقط مهمة:
- **الـ Cubit لا يكلم `DioClient` مباشرة أبدًا** — دايمًا عن طريق `Repo`. الـ `Repo` هو اللي فيه try/catch على `DioException` ويحوّله لـ `NetworkException`.
- الـ Repos بتاخد dependencies بتاعتها (`DioClient`, `LocalStorage`) في الـ constructor، ومسجلة كـ `registerLazySingleton` في `injection.dart`. الـ Cubits مسجلة كـ `registerFactory` (نسخة جديدة كل مرة تتعمل provide).
- شكل الـ Response القياسي من الباك إند: `{ "message": str, "status": bool, "data": {...} }` — فيه `ApiResponse<T>` جاهز لو حبيت تستخدمه، لكن الـ Repos الحالية بتعمل parsing يدوي من `response.data['data']`.
- الـ States دايمًا `sealed class` بأربع حالات أساسية: `Initial` / `Loading` / `Success(data)` / `Error(message)`، معمولة بـ `Equatable`، وموجودة في ملف `part of` منفصل (`<feature>_state.dart`).
- الـ Endpoints/paths كلها مركزية في `ApiEndpoints` — ممنوع تكتب string path مباشر في الـ Repo.
- الـ Token محفوظ في `FlutterSecureStorage` (مش `GetStorage` العادي) لأنه بيانات حساسة؛ باقي البيانات (user json، lang، onboarding seen) في `GetStorage`.
- `kUserModel` / `kIsGuest` (في `app_constants.dart`) متغيرين global بيتحدّثوا من `ProfileCubit.getProfile()` — استخدمهم لو محتاج تعرف حالة الجست من أي مكان من غير ما تعمل `context.watch`.

---

## 7) Routing

- كل الأسماء constants في `Routes` (`app/router/routes.dart`).
- التنقل عن طريق `RouteGenerator.generateRoute` (switch-case) في `app_router.dart` — أي شاشة جديدة لازم يتضاف لها `case` هنا.
- الـ arguments بتتبعت كـ `Map<String, dynamic>?` في `settings.arguments`.
- للناڤيجيشن من بره الـ widget tree (زي جوا `DioClient`/interceptors) استخدم `NavigationService.navigationKey.currentState`.

---

## 8) Dependency Injection

كل حاجة بتتسجل مرة واحدة في `core/di/injection.dart` عن طريق `setupDi()`:
- `registerLazySingleton` → Storage, DioClient, Repos (نسخة واحدة طول عمر الأبلكيشن).
- `registerFactory` → Cubits (نسخة جديدة كل مرة).

أي فيتشر جديدة (Repo + Cubit) لازم تتسجل هنا بنفس النمط.

---

## 9) الأحجام والـ Extensions (Sizing)

- المشروع بيستخدم `flutter_screenutil` (design size `375x812`). استخدم `.w` / `.h` / `.sp` / `.r` بدل الأرقام الخام في أي مقاس جديد.
- في `core/extensions/extensions.dart`:
  - `num.height` / `num.width` → `SizedBox` سريع (`16.height` بدل `SizedBox(height: 16.h)`).
  - `num.paddingAll` / `.paddingVert` / `.paddingHorizontal` / `.paddingStart` / `.paddingEnd` / `.paddingTop` / `.paddingBottom` → `EdgeInsetsDirectional` (بتدعم RTL/LTR تلقائي — استخدمها بدل `EdgeInsets.symmetric` العادي في شاشات فيها نص عربي).
  - `BuildContext.pushNamed` / `.pushReplacementNamed` / `.pushNamedAndRemoveUntil` / `.pop()` → اختصارات فوق `Navigator.of(this)`.

---

## 10) قواعد عامة للكود (Clean Code)

- ملف الشاشة (`*_screen.dart`) يفضل يحتوي بس: الكلاس الرئيسي + الـ State بتاعته (لو Stateful). أي تقسيمة تانية → `presentation/widgets/`.
- الويدجت المشتركة بين فيتشرز متعددة → `core/widgets/`، مش نسخ ولزق بين الفيتشرز.
- الألوان/النصوص/الصور/المسافات كلها من الملفات المركزية (`AppColors`, `LocaleKeys`, `AppImages`, `AppConstants`) — مفيش hardcoded values في نص الشاشة إلا لو تفصيلة فريدة جدًا مش هتتكرر.
- الـ Models: `Equatable` + `fromJson`/`toJson` صريحين (من غير code generation حاليًا في المشروع).
- الـ Cubit بيرمي/يمسك الأخطاء بنفسه ويعرض `AppOverlay.showError` — الـ UI مش المفروض تعمل try/catch بتاعها.

import 'package:app_base/app/router/navigation_services.dart';
import 'package:app_base/features/auth/data/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';

class AppConstants {
  AppConstants._();

  // ─── App ──────────────────────────────────────────────────────────────────
  static const String appName = 'كافيه كاش';

  // ─── Pagination ───────────────────────────────────────────────────────────
  static const int pageSize = 15;
  static const int firstPage = 1;

  // ─── Animation ────────────────────────────────────────────────────────────
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // ─── UI ───────────────────────────────────────────────────────────────────
  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // ─── Links ────────────────────────────────────────────────────────────────
  static const String facebookUrl =
      'https://www.facebook.com/CafeCash?rdid=JTeUnABpxEwFqbxX&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1cXaPAS2Np%2F%3Fref%3D1#';
}

class AppFonts {
  static const String familyFont = 'Cairo';
}

/// The currently authenticated user. `null` means the user is browsing as a guest.
UserModel? kUserModel;

/// Returns `true` when the user is NOT logged in (guest mode).
/// Use this everywhere in the app to guard authenticated-only actions.
bool get kIsGuest => kUserModel == null;
bool get kIsOwner => kUserModel?.isOwner ?? false;
bool get kIsArabic =>
    NavigationService.navigationKey.currentContext?.locale.languageCode == 'ar';

/// `true` for guests (not applicable) and for a logged-in user whose cafe
/// subscription currently covers "now" — computed offline from `ends_at`, so a
/// missing/expired/not-yet-started subscription reads as locked.
bool get kSubscriptionActive =>
    kUserModel == null || (kUserModel!.subscription?.hasLiveCoverage ?? false);

bool get kSubscriptionLocked => !kSubscriptionActive;

bool kWalletPaymentEnabled = true;

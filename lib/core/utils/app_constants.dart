import 'package:app_base/features/auth/data/models/user_model.dart';

class AppConstants {
  AppConstants._();

  // ─── App ──────────────────────────────────────────────────────────────────
  static const String appName = 'App Base';

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
}
class AppFonts {
  static const String familyFont ='Cairo';
}

/// The currently authenticated user. `null` means the user is browsing as a guest.
UserModel? kUserModel;

/// Returns `true` when the user is NOT logged in (guest mode).
/// Use this everywhere in the app to guard authenticated-only actions.
bool get kIsGuest => kUserModel == null;

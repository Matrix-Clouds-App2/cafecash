class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://cafe.matrixclouds.net/api/v1/';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  // No password-based login: "login" is requesting an OTP for an existing
  // phone via [resendOtp] (same endpoint the OTP screen's "resend" re-uses),
  // then confirming it via [verifyOtp] — that call is what actually returns
  // the token.
  static const String register = 'auth/register';
  static const String resendOtp = 'auth/resend-otp';
  static const String verifyOtp = 'auth/verify-otp';
  static const String profile = 'auth/me';
  static const String account = 'auth/account';

  // ─── Employees ────────────────────────────────────────────────────────────
  static const String employees = 'employees';
  static String employee(int id) => 'employees/$id';

  // ─── Subscription ─────────────────────────────────────────────────────────
  static const String subscription = 'subscription';
  static const String subscriptionPlans = 'subscription-plans';
  static String cafeSubscription(int cafeId) =>
      'admin/cafes/$cafeId/subscription';
  static String cafeSubscriptionRenew(int cafeId) =>
      'admin/cafes/$cafeId/subscription/renew';
  static String cafeSubscriptionHistory(int cafeId) =>
      'admin/cafes/$cafeId/subscriptions';

  // ─── Sync ─────────────────────────────────────────────────────────────────
  static const String syncUpload = 'sync/upload';
  static const String syncBootstrap = 'sync/bootstrap';
  static const String catalogImageBase =
      'https://cafe.matrixclouds.net/storage/';

  // ─── Shifts ───────────────────────────────────────────────────────────────
  static const String shifts = 'shifts';
  static String shiftDetails(Object idOrUuid) => 'shifts/$idOrUuid';
}

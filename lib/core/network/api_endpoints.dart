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
}

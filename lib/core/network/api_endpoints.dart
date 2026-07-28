class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com/';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String login = 'clients/login';
  static const String register = 'clients/register';
  static const String logout = 'clients/logout';
  static const String profile = 'clients/profile';
}

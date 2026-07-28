import 'package:get_storage/get_storage.dart';

class LocalStorage {
  LocalStorage() : _box = GetStorage();

  final GetStorage _box;

  // ─── Generic typed methods ────────────────────────────────────────────────
  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write<T>(String key, T value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  bool has(String key) => _box.hasData(key);
  Future<void> clearAll() => _box.erase();

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const _tokenKey = 'token';
  static const _userKey = 'user';

  String? getToken() => read<String>(_tokenKey);
  Future<void> setToken(String v) => write(_tokenKey, v);
  Future<void> removeToken() => remove(_tokenKey);

  Map<String, dynamic>? getUser() => read<Map<String, dynamic>>(_userKey);
  Future<void> setUser(Map<String, dynamic> user) => write(_userKey, user);

  bool get isLoggedIn => getToken() != null;

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const _onboardingSeenKey = 'onboarding_seen';

  bool get isOnboardingSeen => read<bool>(_onboardingSeenKey) ?? false;
  Future<void> setOnboardingSeen() => write(_onboardingSeenKey, true);

  // ─── Settings ─────────────────────────────────────────────────────────────
  static const _langKey = 'lang';
  static const _themeKey = 'theme';

  String getLang() => read<String>(_langKey) ?? 'ar';
  Future<void> setLang(String lang) => write(_langKey, lang);

  String getTheme() => read<String>(_themeKey) ?? 'system';
  Future<void> setTheme(String theme) => write(_themeKey, theme);

  // ─── Prayer Notifications ─────────────────────────────────────────────────
  static const _prayerNotifKey = 'prayer_notifications_enabled';

  bool get prayerNotificationsEnabled => read<bool>(_prayerNotifKey) ?? false;
  Future<void> setPrayerNotificationsEnabled(bool v) => write(_prayerNotifKey, v);

  // ─── Calendar added sessions ──────────────────────────────────────────────
  static const _calendarSessionsKey = 'calendar_added_sessions';

  List<int> getCalendarAddedSessions() {
    final raw = read<List>(_calendarSessionsKey);
    return raw?.map((e) => e as int).toList() ?? [];
  }

  Future<void> addCalendarSession(int sessionId) {
    final list = getCalendarAddedSessions();
    if (!list.contains(sessionId)) list.add(sessionId);
    return write(_calendarSessionsKey, list);
  }

  bool isCalendarSessionAdded(int sessionId) =>
      getCalendarAddedSessions().contains(sessionId);
}

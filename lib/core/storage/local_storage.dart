import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  LocalStorage()
      : _box = GetStorage(),
        _secureBox = const FlutterSecureStorage();

  final GetStorage _box;
  final FlutterSecureStorage _secureBox;

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write<T>(String key, T value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  bool has(String key) => _box.hasData(key);

  Future<void> clearAll() async {
    await _secureBox.delete(key: _tokenKey);
    await _box.erase();
  }

  static const _tokenKey = 'token';
  static const _hasTokenKey = 'has_token';
  static const _userKey = 'user';

  Future<String?> getToken() => _secureBox.read(key: _tokenKey);

  Future<void> setToken(String v) async {
    await _secureBox.write(key: _tokenKey, value: v);
    await write(_hasTokenKey, true);
  }

  Future<void> removeToken() async {
    await _secureBox.delete(key: _tokenKey);
    await remove(_hasTokenKey);
  }

  Map<String, dynamic>? getUser() => read<Map<String, dynamic>>(_userKey);
  Future<void> setUser(Map<String, dynamic> user) => write(_userKey, user);

  bool get isLoggedIn => read<bool>(_hasTokenKey) ?? false;

  static const _onboardingSeenKey = 'onboarding_seen';

  bool get isOnboardingSeen => read<bool>(_onboardingSeenKey) ?? false;
  Future<void> setOnboardingSeen() => write(_onboardingSeenKey, true);

  static const _langKey = 'lang';

  String getLang() => read<String>(_langKey) ?? 'ar';
  Future<void> setLang(String lang) => write(_langKey, lang);

  static const _hallColumnsKey = 'hall_columns_per_row';

  int getHallColumns() => read<int>(_hallColumnsKey) ?? 3;
  Future<void> setHallColumns(int columns) => write(_hallColumnsKey, columns);

  static const _matchesColumnsKey = 'matches_columns_per_row';

  int getMatchesColumns() => read<int>(_matchesColumnsKey) ?? 3;
  Future<void> setMatchesColumns(int columns) =>
      write(_matchesColumnsKey, columns);

  static const _walletPaymentEnabledKey = 'wallet_payment_enabled';

  bool getWalletPaymentEnabled() =>
      read<bool>(_walletPaymentEnabledKey) ?? true;
  Future<void> setWalletPaymentEnabled(bool enabled) =>
      write(_walletPaymentEnabledKey, enabled);

  static const _defaultItemsSeededKey = 'default_items_seeded';

  bool get isDefaultItemsSeeded => read<bool>(_defaultItemsSeededKey) ?? false;
  Future<void> setDefaultItemsSeeded() => write(_defaultItemsSeededKey, true);
}

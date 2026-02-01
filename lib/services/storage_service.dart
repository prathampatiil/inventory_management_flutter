import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ================= BASE KEYS =================
  static const String _userKey = 'user';
  static const String _loginKey = 'isLoggedIn';
  static const String _themeKey = 'themeMode';

  // ================= PREFS =================
  static SharedPreferences? _prefs;

  // ================= INIT =================
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  void _ensureInit() {
    if (_prefs == null) {
      throw Exception(
        'StorageService not initialized. Call StorageService.init() in main().',
      );
    }
  }

  // ================= AUTH =================

  Future<void> saveUser(Map<String, dynamic> user) async {
    _ensureInit();
    await _prefs!.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> loadUser() async {
    _ensureInit();
    final String? data = _prefs!.getString(_userKey);
    if (data == null) return null;
    return jsonDecode(data);
  }

  Future<void> setLogin(bool value) async {
    _ensureInit();
    await _prefs!.setBool(_loginKey, value);
  }

  Future<bool> isLoggedIn() async {
    _ensureInit();
    return _prefs!.getBool(_loginKey) ?? false;
  }

  /// ✅ REQUIRED FOR GetX Middleware (SYNC)
  bool isLoggedInSync() {
    return _prefs?.getBool(_loginKey) ?? false;
  }

  // ================= USER-SCOPED KEYS =================

  String _productsKey(String username) => 'products_$username';
  String _salesKey(String username) => 'sales_$username';

  // ================= PRODUCTS (PER USER) =================

  Future<void> saveProducts(
    String username,
    List<Map<String, dynamic>> products,
  ) async {
    _ensureInit();
    await _prefs!.setString(_productsKey(username), jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> loadProducts(String username) async {
    _ensureInit();
    final String? data = _prefs!.getString(_productsKey(username));
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= SALES (PER USER) =================

  Future<void> saveSales(
    String username,
    List<Map<String, dynamic>> sales,
  ) async {
    _ensureInit();
    await _prefs!.setString(_salesKey(username), jsonEncode(sales));
  }

  Future<List<Map<String, dynamic>>> loadSales(String username) async {
    _ensureInit();
    final String? data = _prefs!.getString(_salesKey(username));
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= THEME =================

  Future<void> saveThemeMode(String mode) async {
    _ensureInit();
    await _prefs!.setString(_themeKey, mode);
  }

  Future<String?> loadThemeMode() async {
    _ensureInit();
    return _prefs!.getString(_themeKey);
  }

  // ================= UTIL =================

  /// ⚠️ Clears EVERYTHING (use only for reset app)
  Future<void> clearAll() async {
    _ensureInit();
    await _prefs!.clear();
  }

  /// ✅ Clears ONLY user data (safe on logout)
  Future<void> clearUserData(String username) async {
    _ensureInit();
    await _prefs!.remove(_productsKey(username));
    await _prefs!.remove(_salesKey(username));
  }
}

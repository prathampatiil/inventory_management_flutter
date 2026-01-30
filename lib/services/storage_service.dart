import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ================= KEYS =================
  static const String _userKey = 'user';
  static const String _loginKey = 'isLoggedIn';
  static const String _productsKey = 'products';
  static const String _salesKey = 'sales';
  static const String _themeKey = 'themeMode';

  // ================= SINGLETON PREFS =================
  static SharedPreferences? _prefs;

  // ================= INIT (CALL ON APP START) =================
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ================= INTERNAL GUARD =================
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

  // ================= PRODUCTS =================

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    _ensureInit();
    await _prefs!.setString(_productsKey, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> loadProducts() async {
    _ensureInit();
    final String? data = _prefs!.getString(_productsKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= SALES =================

  Future<void> saveSales(List<Map<String, dynamic>> sales) async {
    _ensureInit();
    await _prefs!.setString(_salesKey, jsonEncode(sales));
  }

  Future<List<Map<String, dynamic>>> loadSales() async {
    _ensureInit();
    final String? data = _prefs!.getString(_salesKey);
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

  Future<void> clearAll() async {
    _ensureInit();
    await _prefs!.clear();
  }
}

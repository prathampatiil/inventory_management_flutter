import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ================= KEYS =================
  static const String _userKey = 'user';
  static const String _loginKey = 'isLoggedIn';
  static const String _productsKey = 'products';
  static const String _salesKey = 'sales';

  // ================= SINGLETON PREFS =================
  static SharedPreferences? _prefs;

  // ================= INIT (CALL ON APP START) =================
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ================= AUTH =================

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs!.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final String? data = _prefs!.getString(_userKey);
    if (data == null) return null;
    return jsonDecode(data);
  }

  Future<void> setLogin(bool value) async {
    await _prefs!.setBool(_loginKey, value);
  }

  Future<bool> isLoggedIn() async {
    return _prefs!.getBool(_loginKey) ?? false;
  }

  /// ✅ REQUIRED FOR GetX MIDDLEWARE (SYNC)
  bool isLoggedInSync() {
    return _prefs?.getBool(_loginKey) ?? false;
  }

  // ================= PRODUCTS =================

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    await _prefs!.setString(_productsKey, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> loadProducts() async {
    final String? data = _prefs!.getString(_productsKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= SALES =================

  Future<void> saveSales(List<Map<String, dynamic>> sales) async {
    await _prefs!.setString(_salesKey, jsonEncode(sales));
  }

  Future<List<Map<String, dynamic>>> loadSales() async {
    final String? data = _prefs!.getString(_salesKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= UTIL =================

  Future<void> clearAll() async {
    await _prefs!.clear();
  }
}

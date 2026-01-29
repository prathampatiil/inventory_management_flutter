import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // ================= KEYS =================
  static const String _userKey = 'user';
  static const String _loginKey = 'isLoggedIn';
  static const String _productsKey = 'products';
  static const String _salesKey = 'sales';

  // ================= AUTH =================

  Future<void> saveUser(Map<String, dynamic> user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_userKey);
    if (data == null) return null;
    return jsonDecode(data);
  }

  Future<void> setLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, value);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  // ================= PRODUCTS =================

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_productsKey, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> loadProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_productsKey);

    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= SALES =================

  Future<void> saveSales(List<Map<String, dynamic>> sales) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_salesKey, jsonEncode(sales));
  }

  Future<List<Map<String, dynamic>>> loadSales() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_salesKey);

    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ================= UTIL =================

  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

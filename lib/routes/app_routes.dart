/// Centralized route names for the entire app
/// This avoids hard-coded strings and prevents GetX navigation crashes
class AppRoutes {
  // ================= AUTH =================
  static const String login = '/login';
  static const String register = '/register';

  // ================= DASHBOARD =================
  static const String home = '/home';

  // ================= PRODUCTS =================
  static const String productList = '/products';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';

  // ================= SALES =================
  static const String sales = '/sales';

  // ================= SETTINGS =================
  static const String settings = '/settings';
}

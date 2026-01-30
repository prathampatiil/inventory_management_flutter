import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'middlewares/auth_middleware.dart';
import 'routes/app_routes.dart';
import 'services/storage_service.dart';

// ================= AUTH =================
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';

// ================= DASHBOARD =================
import 'views/dashboard/dashboard_view.dart';

// ================= PRODUCTS =================
import 'views/product/product_list_view.dart';
import 'views/product/add_product_view.dart';
import 'views/product/edit_product_view.dart';

// ================= SALES & SETTINGS =================
import 'views/sales/sales_view.dart';
import 'views/settings/settings_view.dart';

// ================= THEME =================
import 'controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Init SharedPreferences ONCE
  await StorageService.init();

  final storage = StorageService();
  final bool isLoggedIn = await storage.isLoggedIn();

  runApp(InventoryApp(isLoggedIn: isLoggedIn));
}

class InventoryApp extends StatelessWidget {
  final bool isLoggedIn;

  const InventoryApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // ✅ Create ThemeController once
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory Management',

        // ✅ Centralized bindings
        initialBinding: InitialBinding(),

        // ================= THEME =================
        // 🔥 IMPORTANT FIX
        themeMode: themeController.flutterThemeMode,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          brightness: Brightness.light,
        ),

        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),

        // ================= AUTH BOOTSTRAP =================
        initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,

        // ================= ROUTES =================
        getPages: [
          // ---------- AUTH ----------
          GetPage(
            name: AppRoutes.login,
            page: () => LoginView(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.register,
            page: () => RegisterView(),
            middlewares: [AuthMiddleware()],
          ),

          // ---------- DASHBOARD ----------
          GetPage(
            name: AppRoutes.home,
            page: () => DashboardView(),
            middlewares: [AuthMiddleware()],
          ),

          // ---------- PRODUCTS ----------
          GetPage(
            name: AppRoutes.productList,
            page: () => ProductListView(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.addProduct,
            page: () => AddProductView(),
            middlewares: [AuthMiddleware()],
          ),
          GetPage(
            name: AppRoutes.editProduct,
            page: () => EditProductView(),
            middlewares: [AuthMiddleware()],
          ),

          // ---------- SALES ----------
          GetPage(
            name: AppRoutes.sales,
            page: () => SalesView(),
            middlewares: [AuthMiddleware()],
          ),

          // ---------- SETTINGS ----------
          GetPage(
            name: AppRoutes.settings,
            page: () => SettingsView(),
            middlewares: [AuthMiddleware()],
          ),
        ],
      ),
    );
  }
}

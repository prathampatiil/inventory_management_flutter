import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_management/middlewares/auth_middleware.dart';
import 'package:inventory_management/views/sales/sales_view.dart';

import 'bindings/initial_binding.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  final StorageService storageService = StorageService();
  final bool isLoggedIn = await storageService.isLoggedIn();

  runApp(InventoryApp(isLoggedIn: isLoggedIn));
}

class InventoryApp extends StatelessWidget {
  final bool isLoggedIn;

  const InventoryApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',

      // ✅ SINGLE PLACE WHERE CONTROLLERS ARE CREATED
      initialBinding: InitialBinding(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // ✅ LOGIN CHECK
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
        GetPage(name: AppRoutes.sales, page: () => SalesView()),
      ],
    );
  }
}

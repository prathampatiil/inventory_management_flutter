import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_routes.dart';
import 'services/storage_service.dart';

// AUTH
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // 👇 LOGIN CHECK
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,

      getPages: [
        // ================= AUTH =================
        GetPage(name: AppRoutes.login, page: () => LoginView()),
        GetPage(name: AppRoutes.register, page: () => RegisterView()),

        // ================= DASHBOARD =================
      ],
    );
  }
}

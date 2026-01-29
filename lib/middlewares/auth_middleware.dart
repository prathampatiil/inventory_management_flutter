import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthMiddleware extends GetMiddleware {
  final StorageService _storage = StorageService();

  @override
  RouteSettings? redirect(String? route) {
    final bool isLoggedIn = _storage.isLoggedInSync();

    // 🔒 Not logged in → block protected routes
    if (!isLoggedIn &&
        route != AppRoutes.login &&
        route != AppRoutes.register) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // 🔐 Logged in → block auth routes
    if (isLoggedIn &&
        (route == AppRoutes.login || route == AppRoutes.register)) {
      return const RouteSettings(name: AppRoutes.home);
    }

    return null; // allow navigation
  }
}

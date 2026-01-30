import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

enum AppThemeMode { system, light, dark }

class SettingsController extends GetxController {
  final StorageService _storage = StorageService();

  final Rx<AppThemeMode> themeMode = AppThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  // ================= LOAD =================
  Future<void> _loadTheme() async {
    final mode = await _storage.loadThemeMode();

    switch (mode) {
      case 'light':
        themeMode.value = AppThemeMode.light;
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'dark':
        themeMode.value = AppThemeMode.dark;
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        themeMode.value = AppThemeMode.system;
        Get.changeThemeMode(ThemeMode.system);
    }
  }

  // ================= SET THEME =================
  Future<void> setTheme(AppThemeMode mode) async {
    themeMode.value = mode;

    switch (mode) {
      case AppThemeMode.light:
        Get.changeThemeMode(ThemeMode.light);
        await _storage.saveThemeMode('light');
        break;
      case AppThemeMode.dark:
        Get.changeThemeMode(ThemeMode.dark);
        await _storage.saveThemeMode('dark');
        break;
      case AppThemeMode.system:
        Get.changeThemeMode(ThemeMode.system);
        await _storage.saveThemeMode('system');
        break;
    }
  }
}

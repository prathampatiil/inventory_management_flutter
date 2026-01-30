import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

/// App-level theme options
enum AppThemeMode { system, light, dark }

class ThemeController extends GetxController {
  final StorageService _storage = StorageService();

  /// Reactive theme state
  final Rx<AppThemeMode> themeMode = AppThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  /// Convert AppThemeMode → Flutter ThemeMode
  ThemeMode get flutterThemeMode {
    switch (themeMode.value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  // ================= LOAD =================

  Future<void> _loadTheme() async {
    final String? savedMode = await _storage.loadThemeMode();

    if (savedMode != null) {
      themeMode.value = AppThemeMode.values.firstWhere(
        (e) => e.name == savedMode,
        orElse: () => AppThemeMode.system,
      );
    } else {
      themeMode.value = AppThemeMode.system;
    }

    // Apply immediately
    Get.changeThemeMode(flutterThemeMode);
  }

  // ================= CHANGE =================

  Future<void> changeTheme(AppThemeMode mode) async {
    if (themeMode.value == mode) return;

    themeMode.value = mode;
    await _storage.saveThemeMode(mode.name);

    Get.changeThemeMode(flutterThemeMode);
  }
}

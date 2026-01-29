import 'package:get/get.dart';

import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storage = StorageService();

  // ================= STATE =================
  final RxString username = ''.obs;
  final RxString password = ''.obs;

  // ================= REGISTER =================
  Future<void> register() async {
    final String u = username.value.trim();
    final String p = password.value.trim();

    if (u.isEmpty || p.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final UserModel user = UserModel(username: u, password: p);

    // ✅ Save user ONLY
    await _storage.saveUser(user.toJson());

    // ❌ DO NOT mark logged in
    await _storage.setLogin(false);

    _clearFields();

    // ✅ Redirect to LOGIN (real app behavior)
    Get.offAllNamed(AppRoutes.login);

    Get.snackbar(
      'Success',
      'Registration successful. Please login.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ================= LOGIN =================
  Future<void> login() async {
    final String u = username.value.trim();
    final String p = password.value.trim();

    if (u.isEmpty || p.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final Map<String, dynamic>? savedUser = await _storage.loadUser();

    if (savedUser == null) {
      Get.snackbar(
        'Error',
        'No user found. Please register first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final UserModel user = UserModel.fromJson(savedUser);

    if (user.username == u && user.password == p) {
      // ✅ Login success
      await _storage.setLogin(true);

      _clearFields();

      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Error',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _storage.setLogin(false);

    _clearFields();

    Get.offAllNamed(AppRoutes.login);
  }

  // ================= HELPERS =================
  void _clearFields() {
    username.value = '';
    password.value = '';
  }
}

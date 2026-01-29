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
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final UserModel user = UserModel(
      username: username.value,
      password: password.value,
    );

    await _storage.saveUser(user.toJson());
    await _storage.setLogin(true);

    // Clear fields after success
    username.value = '';
    password.value = '';

    // Navigate to dashboard
    Get.offAllNamed(AppRoutes.home);
  }

  // ================= LOGIN =================
  Future<void> login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
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

    if (user.username == username.value && user.password == password.value) {
      await _storage.setLogin(true);

      // Clear fields after success
      username.value = '';
      password.value = '';

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

    // Clear state
    username.value = '';
    password.value = '';

    Get.offAllNamed(AppRoutes.login);
  }
}

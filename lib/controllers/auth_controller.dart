import 'package:get/get.dart';

import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storage = StorageService();

  final username = ''.obs;
  final password = ''.obs;

  // ================= REGISTER =================
  Future<void> register() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    final user = UserModel(username: username.value, password: password.value);

    await _storage.saveUser(user.toJson());
    await _storage.setLogin(true);

    Get.offAllNamed(AppRoutes.home);
  }

  // ================= LOGIN =================
  Future<void> login() async {
    final savedUser = await _storage.loadUser();

    if (savedUser == null) {
      Get.snackbar('Error', 'No user found. Please register.');
      return;
    }

    final user = UserModel.fromJson(savedUser);

    if (user.username == username.value && user.password == password.value) {
      await _storage.setLogin(true);
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _storage.setLogin(false);
    Get.offAllNamed(AppRoutes.login);
  }
}

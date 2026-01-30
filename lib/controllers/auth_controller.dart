import 'package:get/get.dart';

import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storage = StorageService();

  // ================= STATE =================
  final RxString username = ''.obs;
  final RxString password = ''.obs;

  UserModel? _currentUser;

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    _loadUser(); // ✅ load persisted user on app start
  }

  Future<void> _loadUser() async {
    final Map<String, dynamic>? data = await _storage.loadUser();
    if (data != null) {
      _currentUser = UserModel.fromJson(data);
      username.value = _currentUser!.username;
      password.value = _currentUser!.password;
    }
  }

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

    await _storage.saveUser(user.toJson());

    // ❌ Do NOT auto-login after register
    await _storage.setLogin(false);

    _currentUser = user;
    _clearFields();

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

    final Map<String, dynamic>? saved = await _storage.loadUser();
    if (saved == null) {
      Get.snackbar(
        'Error',
        'No user found. Please register first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final UserModel user = UserModel.fromJson(saved);

    if (user.username == u && user.password == p) {
      await _storage.setLogin(true);

      _currentUser = user;
      username.value = user.username;
      password.value = user.password;

      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Error',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================= UPDATE USERNAME =================
  Future<void> updateUsername(String newName) async {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    final Map<String, dynamic>? data = await _storage.loadUser();
    if (data == null) return;

    final UserModel existingUser = UserModel.fromJson(data);

    final UserModel updatedUser = existingUser.copyWith(username: trimmed);

    await _storage.saveUser(updatedUser.toJson());

    _currentUser = updatedUser;
    username.value = trimmed;

    Get.snackbar(
      'Success',
      'Username updated',
      snackPosition: SnackPosition.BOTTOM,
    );
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

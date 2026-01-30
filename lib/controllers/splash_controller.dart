import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storage = StorageService();

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Small delay so animation feels smooth
    await Future.delayed(const Duration(seconds: 3));

    final bool isLoggedIn = await _storage.isLoggedIn();

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}

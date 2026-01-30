import 'package:get/get.dart';
import 'package:inventory_management/controllers/settings_controller.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/dashboard_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
  }
}

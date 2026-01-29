import 'package:get/get.dart';

import 'product_controller.dart';
import '../models/product_model.dart';

class DashboardController extends GetxController {
  // ================= DEPENDENCIES =================
  final ProductController productController = Get.find<ProductController>();

  // ================= KPI STATE =================
  final RxInt totalProducts = 0.obs;
  final RxInt totalStock = 0.obs;
  final RxInt lowStockCount = 0.obs;

  static const int lowStockThreshold = 5;

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();

    // Initial KPI calculation
    _calculateStats();

    // Recalculate KPIs whenever product list changes
    ever<List<ProductModel>>(
      productController.products,
      (_) => _calculateStats(),
    );
  }

  // ================= KPI LOGIC =================
  void _calculateStats() {
    final List<ProductModel> products = productController.products.toList();

    totalProducts.value = products.length;

    int stockSum = 0;
    int lowStock = 0;

    for (final product in products) {
      stockSum += product.stock;

      if (product.stock <= lowStockThreshold) {
        lowStock++;
      }
    }

    totalStock.value = stockSum;
    lowStockCount.value = lowStock;
  }
}

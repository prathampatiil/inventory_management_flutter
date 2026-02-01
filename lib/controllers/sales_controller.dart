import 'dart:math';
import 'package:get/get.dart';

import '../models/sale_model.dart';
import '../models/product_model.dart';
import '../services/storage_service.dart';
import 'product_controller.dart';
import 'auth_controller.dart';

class SalesController extends GetxController {
  final StorageService _storage = StorageService();
  final ProductController _productController = Get.find<ProductController>();
  final AuthController _authController = Get.find<AuthController>();

  // ================= STATE =================
  final RxList<SaleModel> sales = <SaleModel>[].obs;

  // ================= FORM STATE =================
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  final RxInt quantity = 1.obs;

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    loadSales();
  }

  // ================= LOAD / SAVE =================

  Future<void> loadSales() async {
    final String username = _authController.username.value;
    if (username.isEmpty) return;

    final data = await _storage.loadSales(username);

    sales.assignAll(data.map((e) => SaleModel.fromJson(e)).toList());
  }

  Future<void> _save() async {
    final String username = _authController.username.value;
    if (username.isEmpty) return;

    await _storage.saveSales(username, sales.map((e) => e.toJson()).toList());
  }

  // ================= ADD SALE =================
  void addSale() {
    final ProductModel? product = selectedProduct.value;

    if (product == null) {
      Get.snackbar('Error', 'Please select a product');
      return;
    }

    if (quantity.value <= 0) {
      Get.snackbar('Error', 'Quantity must be greater than 0');
      return;
    }

    // 🔄 Always refresh product from controller
    final ProductModel? currentProduct = _productController.products
        .firstWhereOrNull((p) => p.id == product.id);

    if (currentProduct == null) {
      Get.snackbar('Error', 'Product no longer exists');
      return;
    }

    if (quantity.value > currentProduct.stock) {
      Get.snackbar('Error', 'Not enough stock available');
      return;
    }

    // 🔻 Reduce stock (user-scoped product)
    _productController.reduceStock(
      productId: currentProduct.id,
      quantity: quantity.value,
    );

    final sale = SaleModel(
      id: _generateId(),
      productId: currentProduct.id,
      productName: currentProduct.name,
      quantity: quantity.value,
      price: currentProduct.price * quantity.value,
      createdAt: DateTime.now(),
    );

    sales.add(sale);
    _save();

    // Reset form
    selectedProduct.value = null;
    quantity.value = 1;

    Get.back();
  }

  // ================= DELETE SALE =================
  void deleteSale(SaleModel sale) {
    // 🔁 Restore stock correctly
    _productController.restoreStock(
      productId: sale.productId,
      quantity: sale.quantity,
    );

    sales.removeWhere((s) => s.id == sale.id);
    _save();
  }

  // ================= HELPERS =================
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}'
        '${Random().nextInt(999)}';
  }
}

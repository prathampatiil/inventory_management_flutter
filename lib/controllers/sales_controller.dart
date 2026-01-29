import 'dart:math';
import 'package:get/get.dart';

import '../models/sale_model.dart';
import '../models/product_model.dart';
import '../services/storage_service.dart';
import 'product_controller.dart';

class SalesController extends GetxController {
  final StorageService _storage = StorageService();
  final ProductController productController = Get.find<ProductController>();

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
    final data = await _storage.loadSales();
    sales.assignAll(data.map((e) => SaleModel.fromJson(e)).toList());
  }

  Future<void> _save() async {
    await _storage.saveSales(sales.map((e) => e.toJson()).toList());
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

    // Refresh product (important if list updated)
    final currentProduct = productController.products.firstWhereOrNull(
      (p) => p.id == product.id,
    );

    if (currentProduct == null) {
      Get.snackbar('Error', 'Product no longer exists');
      return;
    }

    if (quantity.value > currentProduct.stock) {
      Get.snackbar('Error', 'Not enough stock available');
      return;
    }

    // 🔻 Reduce stock
    productController.reduceStock(
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
    // Restore stock safely
    productController.restoreStock(
      productId: sale.productId,
      quantity: sale.quantity,
    );

    sales.removeWhere((s) => s.id == sale.id);
    _save();
  }

  // ================= HELPERS =================
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}';
  }
}

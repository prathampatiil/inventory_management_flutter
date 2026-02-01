import 'dart:math';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/storage_service.dart';
import 'auth_controller.dart';

class ProductController extends GetxController {
  final StorageService _storage = StorageService();
  final AuthController _auth = Get.find<AuthController>();

  // ================= STATE =================
  final RxList<ProductModel> products = <ProductModel>[].obs;

  // ================= FORM FIELDS =================
  final RxString name = ''.obs;
  final RxString category = ''.obs;
  final RxDouble price = 0.0.obs;
  final RxInt stock = 0.obs;

  ProductModel? editingProduct;

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  // ================= LOAD / SAVE =================

  Future<void> loadProducts() async {
    final String username = _auth.username.value;
    if (username.isEmpty) return;

    final data = await _storage.loadProducts(username);
    products.assignAll(data.map((e) => ProductModel.fromJson(e)).toList());
  }

  Future<void> _save() async {
    final String username = _auth.username.value;
    if (username.isEmpty) return;

    await _storage.saveProducts(
      username,
      products.map((e) => e.toJson()).toList(),
    );
  }

  // ================= ADD PRODUCT =================
  void addProduct() {
    if (!_validate()) return;

    final product = ProductModel(
      id: _generateId(),
      name: name.value.trim(),
      category: category.value.trim(),
      price: price.value,
      stock: stock.value,
      createdAt: DateTime.now(),
    );

    products.add(product);
    _save();

    clearForm();
    Get.back();
  }

  // ================= EDIT PRODUCT =================
  void setForEdit(ProductModel product) {
    editingProduct = product;
    name.value = product.name;
    category.value = product.category;
    price.value = product.price;
    stock.value = product.stock;
  }

  void updateProduct() {
    if (editingProduct == null || !_validate()) return;

    final index = products.indexWhere((p) => p.id == editingProduct!.id);

    if (index == -1) return;

    products[index] = ProductModel(
      id: editingProduct!.id,
      name: name.value.trim(),
      category: category.value.trim(),
      price: price.value,
      stock: stock.value,
      createdAt: editingProduct!.createdAt,
    );

    _save();
    clearForm();
    editingProduct = null;
    Get.back();
  }

  // ================= DELETE PRODUCT =================
  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
    _save();
  }

  // ================= STOCK MANAGEMENT =================

  /// Reduce stock when a sale is created
  void reduceStock({required String productId, required int quantity}) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final product = products[index];

    if (quantity <= 0 || quantity > product.stock) return;

    products[index] = product.copyWith(stock: product.stock - quantity);

    _save();
  }

  /// Restore stock when a sale is deleted
  void restoreStock({required String productId, required int quantity}) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final product = products[index];

    products[index] = product.copyWith(stock: product.stock + quantity);

    _save();
  }

  // ================= HELPERS =================
  void clearForm() {
    name.value = '';
    category.value = '';
    price.value = 0.0;
    stock.value = 0;
  }

  bool _validate() {
    if (name.value.trim().isEmpty) {
      Get.snackbar('Error', 'Product name is required');
      return false;
    }

    if (category.value.trim().isEmpty) {
      Get.snackbar('Error', 'Category is required');
      return false;
    }

    if (price.value <= 0) {
      Get.snackbar('Error', 'Price must be greater than 0');
      return false;
    }

    if (stock.value < 0) {
      Get.snackbar('Error', 'Stock cannot be negative');
      return false;
    }

    return true;
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}'
        '${Random().nextInt(999)}';
  }
}

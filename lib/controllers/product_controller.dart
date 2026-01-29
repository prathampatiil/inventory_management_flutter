import 'dart:math';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/storage_service.dart';

class ProductController extends GetxController {
  final StorageService _storage = StorageService();

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
    final data = await _storage.loadProducts();
    products.assignAll(data.map((e) => ProductModel.fromJson(e)).toList());
  }

  Future<void> _save() async {
    await _storage.saveProducts(products.map((e) => e.toJson()).toList());
  }

  // ================= ADD =================
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

  // ================= EDIT =================
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

  // ================= DELETE =================
  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
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
    if (name.value.trim().isEmpty || category.value.trim().isEmpty) {
      Get.snackbar('Error', 'Name and category are required');
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
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(999).toString();
  }
}

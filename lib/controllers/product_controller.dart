import 'dart:math';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/storage_service.dart';

class ProductController extends GetxController {
  final StorageService _storage = StorageService();

  final RxList<ProductModel> products = <ProductModel>[].obs;

  // form fields
  final name = ''.obs;
  final category = ''.obs;
  final price = 0.0.obs;
  final stock = 0.obs;

  ProductModel? editingProduct;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await _storage.loadProducts();
    products.value = data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> _save() async {
    await _storage.saveProducts(products.map((e) => e.toJson()).toList());
  }

  void addProduct() {
    if (!_validate()) return;

    products.add(
      ProductModel(
        id:
            DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(999).toString(),
        name: name.value,
        category: category.value,
        price: price.value,
        stock: stock.value,
        createdAt: DateTime.now(),
      ),
    );

    _save();
    clearForm();
    Get.back();
  }

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

    products[index] = ProductModel(
      id: editingProduct!.id,
      name: name.value,
      category: category.value,
      price: price.value,
      stock: stock.value,
      createdAt: editingProduct!.createdAt,
    );

    _save();
    clearForm();
    editingProduct = null;
    Get.back();
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
    _save();
  }

  void clearForm() {
    name.value = '';
    category.value = '';
    price.value = 0;
    stock.value = 0;
  }

  bool _validate() {
    if (name.isEmpty ||
        category.isEmpty ||
        price.value <= 0 ||
        stock.value < 0) {
      Get.snackbar('Error', 'Invalid product data');
      return false;
    }
    return true;
  }
}

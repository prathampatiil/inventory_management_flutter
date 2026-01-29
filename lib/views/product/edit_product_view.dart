import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';

class EditProductView extends StatelessWidget {
  EditProductView({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            children: [
              // ================= PRODUCT NAME =================
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => controller.name.value = v,
                controller: TextEditingController(
                  text: controller.name.value,
                ),
              ),

              const SizedBox(height: 16),

              // ================= CATEGORY =================
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => controller.category.value = v,
                controller: TextEditingController(
                  text: controller.category.value,
                ),
              ),

              const SizedBox(height: 16),

              // ================= PRICE =================
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    controller.price.value = double.tryParse(v) ?? 0,
                controller: TextEditingController(
                  text: controller.price.value.toString(),
                ),
              ),

              const SizedBox(height: 16),

              // ================= STOCK =================
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    controller.stock.value = int.tryParse(v) ?? 0,
                controller: TextEditingController(
                  text: controller.stock.value.toString(),
                ),
              ),

              const SizedBox(height: 24),

              // ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.updateProduct,
                  child: const Text(
                    'Update Product',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

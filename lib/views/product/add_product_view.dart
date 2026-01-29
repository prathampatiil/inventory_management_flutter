import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';

class AddProductView extends StatelessWidget {
  AddProductView({super.key});

  final ProductController controller = Get.find<ProductController>();

  // ✅ Controllers MUST be created once
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController categoryCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= PRODUCT NAME =================
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // ================= CATEGORY =================
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // ================= PRICE =================
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // ================= STOCK =================
            TextField(
              controller: stockCtrl,
              decoration: const InputDecoration(
                labelText: 'Stock Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // ================= ADD BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // 🔹 Push values into controller
                  controller.name.value = nameCtrl.text;
                  controller.category.value = categoryCtrl.text;
                  controller.price.value = double.tryParse(priceCtrl.text) ?? 0;
                  controller.stock.value = int.tryParse(stockCtrl.text) ?? 0;

                  controller.addProduct();

                  // 🔹 Clear fields AFTER success
                  nameCtrl.clear();
                  categoryCtrl.clear();
                  priceCtrl.clear();
                  stockCtrl.clear();
                },
                child: const Text(
                  'Add Product',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

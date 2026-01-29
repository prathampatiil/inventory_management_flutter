import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../routes/app_routes.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.clearForm();
          Get.toNamed(AppRoutes.addProduct);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 44, 19, 59),
              Color.fromARGB(255, 166, 145, 172),
              Color(0xFFF3E5F5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.products.isEmpty) {
              return const Center(
                child: Text(
                  'No products added yet',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.products.length,
              itemBuilder: (_, i) {
                final p = controller.products[i];
                final bool lowStock = p.stock <= 5;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: lowStock
                          ? Colors.red
                          : Colors.deepPurple,
                      child: const Icon(Icons.inventory_2, color: Colors.white),
                    ),
                    title: Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(p.category),
                        const SizedBox(height: 2),
                        Text(
                          '₹${p.price.toStringAsFixed(2)} • Stock: ${p.stock}',
                          style: TextStyle(
                            color: lowStock ? Colors.red : Colors.grey[700],
                            fontWeight: lowStock
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          controller.setForEdit(p);
                          Get.toNamed(AppRoutes.editProduct);
                        } else if (value == 'delete') {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Delete Product'),
                              content: const Text(
                                'Are you sure you want to delete this product?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: Get.back,
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    controller.deleteProduct(p.id);
                                    Get.back();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

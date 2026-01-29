import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../routes/app_routes.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm();
          Get.toNamed(AppRoutes.addProduct);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => controller.products.isEmpty
            ? const Center(child: Text('No products added'))
            : ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (_, i) {
                  final p = controller.products[i];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                        '${p.category} • ₹${p.price} • Stock: ${p.stock}',
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            controller.setForEdit(p);
                            Get.toNamed(AppRoutes.editProduct);
                          } else {
                            controller.deleteProduct(p.id);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sales_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class SalesView extends StatelessWidget {
  SalesView({super.key});

  final SalesController salesController = Get.put(SalesController());
  final ProductController productController = Get.find<ProductController>();

  final TextEditingController qtyController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ================= ADD SALE =================
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'New Sale',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ===== PRODUCT DROPDOWN =====
                        Obx(
                          () => DropdownButtonFormField<ProductModel>(
                            value: salesController.selectedProduct.value,
                            decoration: const InputDecoration(
                              labelText: 'Product',
                              border: OutlineInputBorder(),
                            ),
                            items: productController.products.map((p) {
                              return DropdownMenuItem<ProductModel>(
                                value: p,
                                child: Text('${p.name} (Stock: ${p.stock})'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              salesController.selectedProduct.value = value;
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== QUANTITY =====
                        TextFormField(
                          controller: qtyController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            salesController.quantity.value =
                                int.tryParse(value) ?? 1;
                          },
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Complete Sale'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              salesController.addSale();
                              qtyController.text = '1';
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ================= SALES HISTORY =================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sales History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: Obx(() {
                    final sales = salesController.sales;

                    if (sales.isEmpty) {
                      return const Center(
                        child: Text(
                          'No sales yet',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: sales.length,
                      itemBuilder: (_, index) {
                        final sale = sales[sales.length - 1 - index];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.receipt_long,
                              color: Colors.deepPurple,
                            ),
                            title: Text(sale.productName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Qty: ${sale.quantity} • ₹${sale.price.toStringAsFixed(2)}',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${sale.createdAt.day}/${sale.createdAt.month}/${sale.createdAt.year}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Delete Sale'),
                                    content: const Text(
                                      'Stock will be restored.',
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
                                          salesController.deleteSale(sale);
                                          Get.back();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

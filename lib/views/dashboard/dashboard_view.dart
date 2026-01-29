import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import 'widgets/kpi_card.dart';
import 'widgets/quick_action_tile.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );

  final ProductController productController = Get.find<ProductController>();

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

      // ================= DRAWER =================
      drawer: Drawer(
        child: Column(
          children: [
            // ===== USER PROFILE =====
            Obx(
              () => UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.deepPurple),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                ),
                accountName: Text(
                  authController.username.value.isEmpty
                      ? 'User'
                      : authController.username.value,
                ),
                accountEmail: const Text('Logged in user'),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () => Get.back(),
                  ),

                  ListTile(
                    leading: const Icon(Icons.inventory),
                    title: const Text('Products'),
                    onTap: () => Get.toNamed(AppRoutes.productList),
                  ),

                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('Sales'),
                    onTap: () => Get.toNamed(AppRoutes.sales),
                  ),

                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () => Get.toNamed(AppRoutes.settings),
                  ),

                  const Divider(),

                  // ===== LOGOUT =====
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {
                      Get.back();
                      authController.logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= KPI SECTION =================
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: KpiCard(
                        title: 'Products',
                        value: dashboardController.totalProducts.value
                            .toString(),
                        icon: Icons.inventory_2,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KpiCard(
                        title: 'Total Stock',
                        value: dashboardController.totalStock.value.toString(),
                        icon: Icons.numbers,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KpiCard(
                        title: 'Low Stock',
                        value: dashboardController.lowStockCount.value
                            .toString(),
                        icon: Icons.warning,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= QUICK ACTIONS =================
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: QuickActionTile(
                      label: 'Add Product',
                      icon: Icons.add,
                      onTap: () => Get.toNamed(AppRoutes.addProduct),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionTile(
                      label: 'View Products',
                      icon: Icons.list,
                      onTap: () => Get.toNamed(AppRoutes.productList),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ================= RECENT ACTIVITY =================
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              Obx(() {
                final products = productController.products;

                if (products.isEmpty) {
                  return const Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  );
                }

                final recentProducts = products.reversed.take(5).toList();

                return Column(
                  children: recentProducts.map((p) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.inventory_2),
                        title: Text(p.name),
                        subtitle: Text('Stock: ${p.stock}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ===== EDIT =====
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                productController.setForEdit(p);
                                Get.toNamed(AppRoutes.editProduct);
                              },
                            ),

                            // ===== DELETE =====
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
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
                                          productController.deleteProduct(p.id);
                                          Get.back();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

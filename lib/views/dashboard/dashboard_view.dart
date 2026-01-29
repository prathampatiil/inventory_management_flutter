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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,

      // ================= DRAWER =================
      drawer: Drawer(
        child: Column(
          children: [
            // ===== USER PROFILE HEADER =====
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authController.username.value.isEmpty
                              ? 'User'
                              : authController.username.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Inventory Manager',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  _drawerItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    onTap: () => Get.back(),
                  ),
                  _drawerItem(
                    icon: Icons.inventory,
                    label: 'Products',
                    onTap: () => Get.toNamed(AppRoutes.productList),
                  ),
                  _drawerItem(
                    icon: Icons.receipt_long,
                    label: 'Sales',
                    onTap: () => Get.toNamed(AppRoutes.sales),
                  ),
                  _drawerItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () => Get.toNamed(AppRoutes.settings),
                  ),
                  const Divider(),
                  _drawerItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    color: Colors.redAccent,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              dashboardController.onInit();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
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
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: KpiCard(
                            title: 'Total Stock',
                            value: dashboardController.totalStock.value
                                .toString(),
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

                  const SizedBox(height: 28),

                  // ================= QUICK ACTIONS =================
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Obx(() {
                    final products = productController.products;

                    if (products.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No recent activity',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: products.reversed.take(5).map((p) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.inventory_2,
                              color: Colors.deepPurple,
                            ),
                            title: Text(p.name),
                            subtitle: Text('Stock: ${p.stock}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                productController.setForEdit(p);
                                Get.toNamed(AppRoutes.editProduct);
                              },
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
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}

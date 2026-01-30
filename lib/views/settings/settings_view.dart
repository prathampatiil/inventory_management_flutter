import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../services/storage_service.dart';
import 'edit_profile_view.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3E5F5), Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ================= USER PROFILE =================
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.username.value.isEmpty
                                  ? 'User'
                                  : authController.username.value,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Inventory User',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= ACCOUNT =================
            _sectionTitle('Account'),
            _settingsTile(
              icon: Icons.person_outline,
              title: 'Profile',
              subtitle: 'Edit username',
              onTap: () => Get.to(() => EditProfileView()),
            ),

            const SizedBox(height: 16),

            // ================= APP =================
            _sectionTitle('App'),

            // ===== THEME TOGGLE =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Column(
                  children: [
                    RadioListTile<AppThemeMode>(
                      title: const Text('System default'),
                      value: AppThemeMode.system,
                      groupValue: themeController.themeMode.value,
                      onChanged: (v) => themeController.changeTheme(v!),
                    ),
                    RadioListTile<AppThemeMode>(
                      title: const Text('Light'),
                      value: AppThemeMode.light,
                      groupValue: themeController.themeMode.value,
                      onChanged: (v) => themeController.changeTheme(v!),
                    ),
                    RadioListTile<AppThemeMode>(
                      title: const Text('Dark'),
                      value: AppThemeMode.dark,
                      groupValue: themeController.themeMode.value,
                      onChanged: (v) => themeController.changeTheme(v!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            _settingsTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'English',
              onTap: () {
                Get.snackbar(
                  'Coming soon',
                  'Multi-language support coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),

            const SizedBox(height: 16),

            // ================= DATA =================
            _sectionTitle('Data'),
            _settingsTile(
              icon: Icons.delete_forever,
              title: 'Reset App Data',
              subtitle: 'Delete all products, sales & users',
              iconColor: Colors.red,
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Reset App Data'),
                    content: const Text(
                      'This will permanently delete all data.\n'
                      'This action cannot be undone.',
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
                        onPressed: () async {
                          await storageService.clearAll();
                          Get.back();
                          authController.logout();
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ================= SECURITY =================
            _sectionTitle('Security'),
            _settingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of this account',
              iconColor: Colors.redAccent,
              onTap: authController.logout,
            ),

            const SizedBox(height: 32),

            // ================= FOOTER =================
            Center(
              child: Text(
                'Inventory Management App\nv1.0.0',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = Colors.deepPurple,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

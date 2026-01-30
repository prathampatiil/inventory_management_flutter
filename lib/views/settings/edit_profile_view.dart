import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final AuthController authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // preload username ONCE
    usernameController.text = authController.username.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // ================= AVATAR =================
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: const CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 48, color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================= INFO =================
            Text(
              'Update your username',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'This name will be visible across the app',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 32),

            // ================= USERNAME FIELD =================
            TextField(
              controller: usernameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================= SAVE BUTTON =================
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  final newUsername = usernameController.text.trim();

                  if (newUsername.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Username cannot be empty',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  await authController.updateUsername(newUsername);

                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

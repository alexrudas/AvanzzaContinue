import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final uidController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: uidController,
              decoration: const InputDecoration(labelText: 'UID'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.login(uidController.text.trim()),
              child: const Text('Ingresar'),
            )
          ],
        ),
      ),
    );
  }
}

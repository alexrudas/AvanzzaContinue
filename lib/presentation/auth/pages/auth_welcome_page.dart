import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AuthWelcomePage extends StatelessWidget {
  const AuthWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Bienvenido a Avanzza 2.0', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.toNamed(Routes.phone),
                child: const Text('Iniciar sesión con teléfono'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';
import '../../../routes/app_pages.dart';

class SelectHolderTypePage extends StatelessWidget {
  const SelectHolderTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tipo de titular')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Persona'),
              onTap: () async {
                await reg.setTitularType('persona');
                Get.toNamed(Routes.role);
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text('Empresa'),
              onTap: () async {
                await reg.setTitularType('empresa');
                Get.toNamed(Routes.role);
              },
            ),
          ],
        ),
      ),
    );
  }
}

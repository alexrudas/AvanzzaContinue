import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/registration_controller.dart';

class ProviderSubtypePage extends StatelessWidget {
  const ProviderSubtypePage({super.key});

  Future<void> _goNext(RegistrationController reg) async {
    await Get.toNamed(Routes.providerAssetTypes);
    await Get.toNamed(Routes.providerCategories);
    final ats = reg.progress.value?.assetTypeIds ?? const <String>[];
    if (ats.contains('vehiculos')) {
      await Get.toNamed(Routes.providerSegments);
    }
    await Get.toNamed(Routes.providerCoverage);
    // Al terminar, ir al HomeRouter para abrir el workspace sin registro
    Get.offAllNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tipo de proveedor')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Servicios'),
            onTap: () async {
              await reg.setProviderType('servicios');
              await _goNext(reg);
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Artículos'),
            onTap: () async {
              await reg.setProviderType('articulos');
              await _goNext(reg);
            },
          ),
        ],
      ),
    );
  }
}

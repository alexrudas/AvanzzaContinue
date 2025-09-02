import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/org_selection_controller.dart';

class OrgSelectionPage extends StatelessWidget {
  const OrgSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrgSelectionController());

    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Organización')),
      body: Obx(() {
        final orgs = controller.orgs;
        if (orgs.isEmpty) {
          return const Center(child: Text('No hay organizaciones'));
        }
        return ListView.builder(
          itemCount: orgs.length,
          itemBuilder: (_, i) {
            final org = orgs[i];
            return ListTile(
              title: Text(org.nombre),
              subtitle: Text(org.id),
              onTap: () => controller.selectOrg(org),
            );
          },
        );
      }),
    );
  }
}

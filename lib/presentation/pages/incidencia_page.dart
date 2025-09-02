import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/incidencia_controller.dart';

class IncidenciaPage extends StatelessWidget {
  final String assetId;
  const IncidenciaPage({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IncidenciaController(assetId));
    final textCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Incidencias')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final items = controller.items;
              if (items.isEmpty) return const Center(child: Text('Sin incidencias'));
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final it = items[i];
                  return ListTile(
                    title: Text(it.descripcion),
                    subtitle: Text(it.estado),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textCtrl,
                    decoration: const InputDecoration(hintText: 'Descripción'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    await controller.createIncidencia(textCtrl.text.trim());
                    textCtrl.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

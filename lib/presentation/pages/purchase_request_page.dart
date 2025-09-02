import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/purchase_request_controller.dart';

class PurchaseRequestPage extends StatelessWidget {
  const PurchaseRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseRequestController());
    final textCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitud de Compra')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final items = controller.items;
              if (items.isEmpty) return const Center(child: Text('Sin solicitudes'));
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final it = items[i];
                  return ListTile(
                    title: Text(it.tipoRepuesto),
                    subtitle: Text('Cantidad: ${it.cantidad}'),
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
                    decoration: const InputDecoration(hintText: 'Tipo de repuesto'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    await controller.createRequest(tipoRepuesto: textCtrl.text.trim());
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

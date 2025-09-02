import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/asset_list_controller.dart';

class AssetListPage extends StatelessWidget {
  const AssetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AssetListController());

    return Scaffold(
      appBar: AppBar(title: const Text('Activos')),
      body: Obx(() {
        final items = controller.assets;
        if (items.isEmpty) return const Center(child: Text('Sin activos'));
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final a = items[i];
            return ListTile(
              title: Text(a.assetType),
              subtitle: Text(a.id),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mock add
          final nowId = DateTime.now().millisecondsSinceEpoch.toString();
          // TODO: construct AssetEntity via a form; using placeholder here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

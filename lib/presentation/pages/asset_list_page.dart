import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/presentation/widgets/selectors/asset_type_selector.dart';
import 'package:avanzza/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/asset_list_controller.dart';

class AssetListPage extends StatelessWidget {
  const AssetListPage({
    super.key,
  });

  final AssetType? assetType = AssetType.vehiculo;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AssetListController());

    return Scaffold(
      appBar: AppBar(title: const Text('Activos')),
      body: Obx(() {
        final items = controller.assets;
        if (items.isEmpty) {
          return Column(
            children: [
              AssetTypeSelector(
                selected: assetType,
                enabled: true,
                onChanged: (type) {
                  // controller.assetType.value = type;
                },
                title: 'Tipo de activo',
                subtitle: 'Selecciona la categoría del activo',
              ),
              const Center(child: Text('Sin activos')),
            ],
          );
        }
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
          showAssetTypeSheet(
            context,
            onChanged: (value) {
              if (value.isVehiculo) {
                Get.toNamed(Routes.runtVehicleConsult);
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

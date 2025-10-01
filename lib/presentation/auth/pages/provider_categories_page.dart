import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/registration_controller.dart';

class ProviderCategoriesPage extends StatefulWidget {
  const ProviderCategoriesPage({super.key});

  @override
  State<ProviderCategoriesPage> createState() => _ProviderCategoriesPageState();
}

class _ProviderCategoriesPageState extends State<ProviderCategoriesPage> {
  String? _selected;

  List<Map<String, String>> _options(
      String providerType, List<String> assetTypeIds, String titularType) {
    final list = <Map<String, String>>[];
    if (providerType == 'articulos') {
      if (assetTypeIds.contains('vehiculos'))
        list.add({'id': 'lubricentro', 'label': 'Lubricentro'});
      if (assetTypeIds.contains('inmuebles'))
        list.add({'id': 'ferreteria', 'label': 'Ferretería'});
      list.add({'id': 'insumos_generales', 'label': 'Insumos generales'});
    } else {
      list.add(
          {'id': 'mecanico_independiente', 'label': 'Mecánico independiente'});
      if (titularType == 'empresa') {
        list.add({'id': 'taller', 'label': 'Taller'});
        list.add({'id': 'facility', 'label': 'Facility management'});
      }
      list.add({
        'id': 'servicios_especializados',
        'label': 'Servicios especializados'
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    final tipo = reg.titularType.value.isNotEmpty
        ? reg.titularType.value
        : (reg.progress.value?.titularType ?? 'persona');
    final provType = reg.providerType.value.isNotEmpty
        ? reg.providerType.value
        : (reg.progress.value?.providerType ?? 'servicios');
    final assetTypes = reg.progress.value?.assetTypeIds ?? const <String>[];
    final opts = _options(provType, assetTypes, tipo);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías proveedor')),
      body: ListView(
        children: [
          for (final o in opts)
            RadioListTile<String>(
              title: Text(o['label']!),
              value: o['id']!,
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _selected == null
                  ? null
                  : () async {
                      await reg.setBusinessCategory(_selected!);
                      Get.back();
                    },
              child: const Text('Guardar categoría'),
            ),
          ),
        ],
      ),
    );
  }
}

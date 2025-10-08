import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/repositories/catalog_repository.dart';
import '../controllers/registration_controller.dart';

class ProviderCategoriesPage extends StatefulWidget {
  const ProviderCategoriesPage({super.key});

  @override
  State<ProviderCategoriesPage> createState() => _ProviderCategoriesPageState();
}

class _ProviderCategoriesPageState extends State<ProviderCategoriesPage> {
  String? _selected;
  DateTime? _openedAt;

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    final di = DIContainer();
    final catalog = di.catalogRepository;

    final providerType = reg.progress.value?.providerType;
    final segment = reg.progress.value?.segment;

    final title = 'Categorías de '
        '${providerType == 'articulos' ? 'Productos' : 'Servicios'} '
        'para '
        '${_segmentLabel(segment ?? '')}';

    List<Map<String, dynamic>> items = [];
    if (providerType != null && segment != null) {
      items = catalog.getProviderCategories(providerType, segment);
    }

    _openedAt ??= DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Builder(builder: (context) {
        if (providerType == null || segment == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Selecciona primero el tipo de proveedor y el segmento que atiendes')),
          );
          return const SizedBox.shrink();
        }

        if (items.isEmpty) {
          // Telemetría GAP, CTA sugerir categoría
          // ignore: avoid_print
          print(
              '[Telemetry] category_gap providerType=$providerType segment=$segment');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'No hay categorías disponibles para esta combinación.'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: abrir formulario de sugerencia
                    },
                    child: const Text('Sugerir categoría'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          children: [
            for (final o in items)
              RadioListTile<String>(
                title: Text(o['label'] as String),
                value: o['id'] as String,
                groupValue: _selected,
                onChanged: (v) => setState(() => _selected = v),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _selected == null
                    ? null
                    : () async {
                        final elapsed = DateTime.now()
                            .difference(_openedAt!)
                            .inMilliseconds;
                        // ignore: avoid_print
                        print(
                            '[Telemetry] category_select id=$_selected duration_ms=$elapsed providerType=$providerType segment=$segment');
                        await reg.setProviderCategory(_selected!);
                        Get.back(result: _selected);
                      },
                child: const Text('Guardar categoría'),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _segmentLabel(String v) {
    switch (v) {
      case 'vehiculos':
        return 'Vehículos';
      case 'inmuebles':
        return 'Inmuebles';
      case 'equipos_construccion':
        return 'Equipos de construcción';
      case 'maquinaria':
        return 'Maquinaria';
      case 'otros_equipos':
        return 'Otros equipos';
      default:
        return v.isEmpty ? '—' : v;
    }
  }
}

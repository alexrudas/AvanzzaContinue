// ============================================================================
// lib/presentation/widgets/purchase/vehicle_spec_picker_sheet.dart
// VEHICLE SPEC PICKER SHEET — Selector de especificación de vehículo (stock)
//
// QUÉ HACE:
// - Bottom sheet que muestra las VehicleSpec derivadas del parque vehicular
//   real del workspace activo y permite elegir una para la PurchaseRequest
//   cuando originType=inventory y el precontexto es AssetType.vehicle.
// - Misma UX que AssetPickerSheet para mantener coherencia del formulario.
// - La derivación se ejecuta UNA vez en initState vía AssetRepository.
//
// QUÉ NO HACE:
// - No recalcula por frame ni dentro del build.
// - No escribe al backend: el snapshot se adjunta al create en submit.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/value/purchase/vehicle_spec.dart';
import '../../controllers/purchase_request_controller.dart';
import '../../controllers/session_context_controller.dart';

class VehicleSpecPickerSheet extends StatefulWidget {
  const VehicleSpecPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const VehicleSpecPickerSheet(),
    );
  }

  @override
  State<VehicleSpecPickerSheet> createState() => _VehicleSpecPickerSheetState();
}

class _VehicleSpecPickerSheetState extends State<VehicleSpecPickerSheet> {
  List<VehicleSpec>? _specs;
  bool _loading = true;
  String? _error;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final session = Get.find<SessionContextController>();
      final orgId = session.user?.activeContext?.orgId;
      if (orgId == null || orgId.isEmpty) {
        setState(() {
          _error = 'Sin organización activa.';
          _loading = false;
        });
        return;
      }
      final specs =
          await DIContainer().assetRepository.fetchVehicleSpecsByOrg(orgId);
      if (!mounted) return;
      setState(() {
        _specs = specs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar especificaciones de vehículo';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<PurchaseRequestController>();

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Seleccionar especificación de vehículo',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                'Se derivan de los vehículos ya registrados en tu workspace. '
                'Formato: Marca Modelo Año — N vehículos.',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('vehicle_spec_picker.search_field'),
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Buscar por marca, modelo o año...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => _searchCtrl.clear(),
                        ),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(PurchaseRequestController controller) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black54)),
      );
    }
    final specs = _specs ?? const <VehicleSpec>[];
    if (specs.isEmpty) {
      return const _EmptySpecs();
    }
    final visible = _query.isEmpty
        ? specs
        : specs.where((s) {
            return s.makeKey.contains(_query) ||
                s.modelKey.contains(_query) ||
                '${s.year}'.contains(_query);
          }).toList();
    if (visible.isEmpty) {
      return Center(
        child: Text(
          'Sin resultados para "${_searchCtrl.text.trim()}"',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
      itemCount: visible.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
      itemBuilder: (_, i) => _SpecTile(
        spec: visible[i],
        onTap: () {
          controller.selectVehicleSpec(visible[i]);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final VehicleSpec spec;
  final VoidCallback onTap;

  const _SpecTile({required this.spec, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = spec.linkedAssetsCount;
    final subtitle = count > 1
        ? '$count vehículos'
        : (count == 1 ? '1 vehículo' : 'Sin vehículos vinculados');
    return ListTile(
      key: Key('vehicle_spec_picker.tile.${spec.id}'),
      leading: const Icon(Icons.directions_car_filled_outlined),
      title: Text(spec.displayLabel),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}

class _EmptySpecs extends StatelessWidget {
  const _EmptySpecs();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: t.hintColor),
            const SizedBox(height: 12),
            Text(
              'No hay vehículos con marca, modelo y año completos',
              style: t.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Registra al menos un vehículo con esos datos para poder pedir '
              'stock por especificación.',
              style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

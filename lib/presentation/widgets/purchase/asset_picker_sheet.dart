// ============================================================================
// lib/presentation/widgets/purchase/asset_picker_sheet.dart
// ASSET PICKER SHEET — Selección real de un activo del workspace activo.
// ============================================================================
// QUÉ HACE:
//   - Bottom sheet que lista los AssetEntity del orgId activo y permite
//     seleccionar uno para vincularlo a una PurchaseRequest (originType=ASSET).
//   - Fuente de datos: AssetRepository.fetchAssetsByOrg(orgId) (vía DIContainer).
//   - Muestra `assetKey` (placa/identificador humano) + tipo.
//
// QUÉ NO HACE:
//   - No edita, crea ni elimina activos.
//   - No resuelve picker por portfolio: alcance es el orgId activo completo.
//
// PRINCIPIOS:
//   - Elimina la UX inaceptable de TextField libre para assetId.
//   - IDs técnicos (UUID) NO los escribe el usuario: se obtienen del tap.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../controllers/purchase_request_controller.dart';
import '../../controllers/session_context_controller.dart';

class AssetPickerSheet extends StatefulWidget {
  const AssetPickerSheet({super.key});

  /// Abre el sheet. Al seleccionar, el controller recibe el assetId y la
  /// etiqueta humana (assetKey) para mostrarla como chip.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const AssetPickerSheet(),
    );
  }

  @override
  State<AssetPickerSheet> createState() => _AssetPickerSheetState();
}

class _AssetPickerSheetState extends State<AssetPickerSheet> {
  List<AssetEntity>? _assets;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
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
      final list = await DIContainer().assetRepository.fetchAssetsByOrg(orgId);
      if (!mounted) return;
      setState(() {
        _assets = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar activos';
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
                  'Seleccionar activo',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                'Elige el activo relacionado con esta solicitud. Solo se muestran '
                'los activos del workspace activo.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                )),
      );
    }
    final assets = _assets ?? const [];
    if (assets.isEmpty) {
      return const _EmptyAssets();
    }
    return ListView.separated(
      itemCount: assets.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
      itemBuilder: (_, i) => _AssetTile(
        asset: assets[i],
        onTap: () {
          controller.selectAsset(
            id: assets[i].id,
            label: assets[i].assetKey,
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const _AssetTile({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (asset.type) {
      AssetType.vehicle => 'Vehículo',
      AssetType.realEstate => 'Inmueble',
      AssetType.machinery => 'Maquinaria',
      AssetType.equipment => 'Equipo',
    };
    return ListTile(
      key: Key('asset_picker.tile.${asset.id}'),
      leading: const Icon(Icons.precision_manufacturing_outlined),
      title: Text(asset.assetKey),
      subtitle: Text(typeLabel),
      onTap: onTap,
    );
  }
}

class _EmptyAssets extends StatelessWidget {
  const _EmptyAssets();

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
              'No hay activos en este workspace',
              style: t.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Registra un activo antes de vincularlo a una solicitud.',
              style:
                  t.textTheme.bodySmall?.copyWith(color: t.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

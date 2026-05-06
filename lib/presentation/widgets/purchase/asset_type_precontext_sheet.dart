// ============================================================================
// lib/presentation/widgets/purchase/asset_type_precontext_sheet.dart
// ASSET TYPE PRECONTEXT SHEET — Precontexto UX para "Nueva solicitud"
// ============================================================================
// QUÉ HACE:
//   - Antes de abrir el formulario de PurchaseRequest, pide al usuario el tipo
//     de activo sobre el que versa la solicitud (Vehículo / Inmueble /
//     Maquinaria / Equipo), listando SOLO los tipos realmente registrados en
//     el workspace activo.
//   - Si existe un único tipo registrado, se salta el sheet y navega directo
//     al formulario preseleccionando ese tipo.
//   - Si no existe ningún tipo registrado, muestra feedback honesto (snackbar)
//     y NO navega al formulario.
//
// QUÉ NO HACE:
//   - No es un campo del dominio/backend: es puro prefiltro UI de Avanzza para
//     contextualizar categorías y el picker de activos.
//   - No persiste nada; la selección viaja como `Get.arguments`.
//   - No reabre backend: el contrato canónico de PurchaseRequest NO cambia.
//
// PRINCIPIOS:
//   - No inventar opciones vacías. Lo que no está registrado, no se muestra.
//   - Salida honesta cuando no hay activos.
//   - Una sola responsabilidad: capturar `AssetType` y delegar navegación.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../common/ensure_registered_guard.dart';
import '../../controllers/session_context_controller.dart';
import '../../../routes/app_pages.dart';

/// Clave pública del argumento que recibe el formulario al navegar.
const String kPurchaseRequestAssetTypeArg = 'assetType';

/// Etiqueta humana de un [AssetType] para UI.
String assetTypeLabel(AssetType t) {
  switch (t) {
    case AssetType.vehicle:
      return 'Vehículos';
    case AssetType.realEstate:
      return 'Inmuebles';
    case AssetType.machinery:
      return 'Maquinaria';
    case AssetType.equipment:
      return 'Equipos';
  }
}

String assetTypeSingular(AssetType t) {
  switch (t) {
    case AssetType.vehicle:
      return 'Vehículo';
    case AssetType.realEstate:
      return 'Inmueble';
    case AssetType.machinery:
      return 'Maquinaria';
    case AssetType.equipment:
      return 'Equipo';
  }
}

IconData assetTypeIcon(AssetType t) {
  switch (t) {
    case AssetType.vehicle:
      return Icons.directions_car_outlined;
    case AssetType.realEstate:
      return Icons.apartment_outlined;
    case AssetType.machinery:
      return Icons.precision_manufacturing_outlined;
    case AssetType.equipment:
      return Icons.handyman_outlined;
  }
}

/// Punto único de entrada al flujo "Nueva solicitud".
///
/// Resuelve el tipo de activo precontexto y navega al formulario. La regla:
///   - 0 tipos registrados  → snackbar honesto, no navega.
///   - 1 tipo registrado    → navega directo con ese tipo preseleccionado.
///   - 2+ tipos registrados → abre [AssetTypePrecontextSheet] y luego navega.
Future<void> startNewPurchaseRequestFlow(BuildContext context) async {
  final guard = EnsureRegisteredGuard();
  await guard.run(() async {
    final session = Get.find<SessionContextController>();
    final orgId = session.user?.activeContext?.orgId;
    if (orgId == null || orgId.isEmpty) {
      _snack('Sin organización activa',
          'Selecciona una organización antes de continuar.');
      return;
    }

    final List<AssetEntity> assets;
    try {
      assets = await DIContainer().assetRepository.fetchAssetsByOrg(orgId);
    } catch (_) {
      _snack('Error', 'No se pudieron cargar tus activos. Intenta de nuevo.');
      return;
    }

    final types = assets.map((a) => a.type).toSet().toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    if (types.isEmpty) {
      _snack('No tienes activos registrados',
          'Registra al menos un activo antes de crear una solicitud.');
      return;
    }

    if (types.length == 1) {
      await Get.toNamed(
        Routes.purchase,
        arguments: {kPurchaseRequestAssetTypeArg: types.first},
      );
      return;
    }

    if (!context.mounted) return;
    final selected = await showModalBottomSheet<AssetType>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AssetTypePrecontextSheet(types: types),
    );
    if (selected == null) return;
    await Get.toNamed(
      Routes.purchase,
      arguments: {kPurchaseRequestAssetTypeArg: selected},
    );
  });
}

void _snack(String title, String msg) {
  Get.snackbar(title, msg,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12));
}

/// Bottom sheet que lista los tipos de activo elegibles.
class AssetTypePrecontextSheet extends StatelessWidget {
  final List<AssetType> types;
  const AssetTypePrecontextSheet({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Selecciona el tipo de activo',
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              'Elige el universo operativo de esta solicitud. Filtrará '
              'categorías y activos disponibles.',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 12),
            for (final t in types)
              ListTile(
                key: Key('precontext_sheet.type.${t.name}'),
                leading: Icon(assetTypeIcon(t),
                    color: theme.colorScheme.primary),
                title: Text(assetTypeLabel(t)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).pop(t),
              ),
          ],
        ),
      ),
    );
  }
}

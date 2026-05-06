// ============================================================================
// lib/presentation/pages/assets_by_type_page.dart
// ASSETS BY TYPE PAGE — Lista dedicada de activos de un tipo seleccionado
//
// QUÉ HACE:
// - Lista los activos del workspace activo filtrados por un AssetType concreto
//   (Vehículos, Inmuebles, Maquinaria, Equipos).
// - Reutiliza la representación humana canónica del proyecto: AssetSummaryMapper
//   + PortfolioAssetOperationalTile (mismo render que los activos dentro de un
//   portafolio).
// - Permite registrar un nuevo activo del tipo en curso vía FAB.
//
// QUÉ NO HACE:
// - No es una vista por portafolio (esa responsabilidad sigue en
//   PortfolioAssetListPage). Aquí el eje es TIPO de activo dentro del workspace.
// - No vuelve a mostrar el tipo en cada tile: el contexto (AppBar) ya lo deja
//   explícito; redundarlo en cada fila sería ruido.
// - No define un mapper o tile propio: reusa los canónicos.
//
// PRINCIPIOS:
// - StatelessWidget puro; el estado vive en AssetListController (compartido
//   con AssetListPage para evitar dobles suscripciones a Isar).
// - Sin lógica de negocio: solo proyección presentacional.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): destino del tap en una tarjeta de tipo en AssetListPage
// (UX agrupada por tipo). Mantiene "Activos" semánticamente separado de
// "Mis Portafolios" (agrupado por propietario).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/asset/asset_entity.dart';
import '../../domain/shared/enums/asset_type.dart';
import '../../domain/value/navigation/asset_detail_args.dart';
import '../../routes/app_pages.dart';
import '../controllers/asset_list_controller.dart';
import '../mappers/asset_summary_mapper.dart';
import '../widgets/asset/portfolio_asset_operational_tile.dart';
import '../widgets/selectors/asset_type_selector.dart';
import 'asset_type_display.dart';

class AssetsByTypePage extends StatelessWidget {
  const AssetsByTypePage({super.key});

  AssetType _resolveType() {
    final arg = Get.arguments;
    if (arg is AssetType) return arg;
    return AssetType.vehicle;
  }

  @override
  Widget build(BuildContext context) {
    final type = _resolveType();
    final display = AssetTypeDisplay.of(type);
    final controller = Get.isRegistered<AssetListController>()
        ? Get.find<AssetListController>()
        : Get.put(AssetListController());

    return Scaffold(
      appBar: AppBar(title: Text(display.pluralLabel)),
      body: Obx(() {
        final filtered =
            controller.assets.where((a) => a.type == type).toList();
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No tienes ${display.pluralLabel.toLowerCase()} registrados.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          itemCount: filtered.length,
          itemBuilder: (_, i) {
            final summary = filtered[i].toSummaryVM();
            return PortfolioAssetOperationalTile(
              summary: summary,
              onTap: () => Get.toNamed(
                Routes.assetDetail,
                arguments: AssetDetailArgs(assetId: summary.assetId),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openRegisterForType(context, type),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Registrar'),
      ),
    );
  }

  void _openRegisterForType(BuildContext context, AssetType type) {
    showAssetTypeSheet(
      context,
      onChanged: (value) {
        if (value.isVehiculo) {
          // Migrado 2026-05: antes apuntaba a `Routes.runtVehicleConsult`
          // (página legacy 1×1 retirada). Ahora flujo canónico.
          Get.toNamed(Routes.assetRegister);
        }
      },
    );
  }
}

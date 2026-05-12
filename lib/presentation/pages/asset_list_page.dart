// ============================================================================
// lib/presentation/pages/asset_list_page.dart
// ASSET LIST PAGE — Vista transversal de activos AGRUPADA POR TIPO
//
// QUÉ HACE:
// - Muestra una tarjeta por cada tipo de activo realmente registrado en el
//   workspace activo (Vehículos, Inmuebles, Maquinaria, Equipos), con su
//   conteo. Solo aparecen los tipos con al menos un activo.
// - Al tocar una tarjeta, navega a [AssetsByTypePage] (Routes.assetsByType)
//   con el AssetType como argumento — vista dedicada con la lista de unidades
//   de ese tipo.
// - Muestra debajo del listado por tipo la sección "Mis Portafolios de
//   activos", reactiva a watchActivePortfoliosByOrg vía AssetListController.
// - Permite registrar un nuevo activo desde el FAB.
//
// QUÉ NO HACE:
// - NO lista activos individuales aquí (esa es responsabilidad de
//   AssetsByTypePage). Esto separa semánticamente "Activos" (eje: tipo) de
//   "Mis Portafolios" (eje: propietario/portafolio).
// - NO muestra tipos en inglés ni UUIDs.
// - NO duplica la lectura de Isar: comparte AssetListController con la página
//   por tipo.
//
// PRINCIPIOS:
// - Reusa AdminAssetCategoryCard (mismo widget que el Home y Portafolios) para
//   coherencia visual con el resto de agrupaciones de la app.
// - StatelessWidget puro; el estado vive en AssetListController.
//
// ENTERPRISE NOTES:
// REESTRUCTURADO (2026-04): de lista plana a vista agrupada por tipo. La lista
// plana migró a AssetsByTypePage (Routes.assetsByType) por contrato UX.
// MOVED-IN (2026-04): la sección "Mis Portafolios de activos" se reubicó
// desde AdminHomePage para centralizar la exploración del inventario aquí.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../domain/entities/asset/asset_entity.dart';
import '../../domain/entities/portfolio/portfolio_entity.dart';
import '../../domain/shared/enums/asset_type.dart';
import '../../routes/app_pages.dart';
import '../controllers/asset_list_controller.dart';
import '../pages/admin/home/admin_home_widgets.dart';
import '../pages/asset_type_display.dart';
import '../widgets/selectors/asset_type_selector.dart';

class AssetListPage extends StatelessWidget {
  const AssetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AssetListController>()
        ? Get.find<AssetListController>()
        : Get.put(AssetListController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Activos')),
      body: Obx(() {
        final counts = _countsByType(controller.assets);
        if (counts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Aún no tienes activos registrados.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final entries = counts.entries.toList()
          ..sort((a, b) => a.key.index.compareTo(b.key.index));

        final children = <Widget>[];

        // ────────────────────────────────────────────────────────────────────
        // SECCIÓN 1 — Tipos de activos
        // Título + una tarjeta por cada tipo con al menos un activo.
        // Subtítulo de cada tarjeta: "<n> registrado(s)" (descriptor útil que
        // sustituye el heredado "Tipo de activo", redundante con el AppBar).
        // Trailing: solo el número, para consistencia con la sección de
        // portafolios.
        // ────────────────────────────────────────────────────────────────────
        children.add(const AdminSectionTitle(title: 'Tipos de activos'));
        children.add(const SizedBox(height: 12));
        for (var i = 0; i < entries.length; i++) {
          if (i > 0) children.add(const SizedBox(height: 12));
          final type = entries[i].key;
          final count = entries[i].value;
          final display = AssetTypeDisplay.of(type);
          children.add(
            AdminAssetCategoryCard(
              title: display.pluralLabel,
              subtitle: '$count ${count == 1 ? 'registrado' : 'registrados'}',
              value: '$count',
              icon: display.icon,
              color: _colorFor(type, cs),
              onTap: () => Get.toNamed(
                Routes.assetsByType,
                arguments: type,
              ),
            ),
          );
        }

        // ────────────────────────────────────────────────────────────────────
        // SECCIÓN 2 — Mis portafolios
        // Lista dinámica desde AssetListController.portfolios (reactiva a
        // watchActivePortfoliosByOrg). Subtítulo: etiqueta del tipo de
        // portafolio (ya descriptiva). Trailing: solo el número, unificado
        // con la sección de tipos.
        // ────────────────────────────────────────────────────────────────────
        children.add(const SizedBox(height: 28));
        children.add(const AdminSectionTitle(title: 'Mis portafolios'));
        children.add(const SizedBox(height: 12));
        children.add(Obx(() {
          final portfolioList = controller.portfolios;
          if (portfolioList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'No hay portafolios activos',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            );
          }
          final items = <Widget>[];
          for (var i = 0; i < portfolioList.length; i++) {
            if (i > 0) items.add(const SizedBox(height: 12));
            final portfolio = portfolioList[i];
            items.add(AdminAssetCategoryCard(
              title: portfolio.portfolioName,
              subtitle: _portfolioTypeLabel(portfolio.portfolioType),
              value: '${portfolio.assetsCount}',
              icon: _portfolioIcon(portfolio.portfolioType),
              color: _portfolioAccentColor,
              onTap: () {
                HapticFeedback.lightImpact();
                // Navega directamente a la vista operativa de activos,
                // eliminando el paso intermedio de PortfolioDetailPage.
                // PortfolioDetailPage sigue disponible vía Routes.portfolioDetail
                // para navegación directa o deep-link desde otros contextos.
                Get.toNamed(
                  Routes.portfolioAssets,
                  arguments: portfolio,
                );
              },
            ));
          }
          return Column(children: items);
        }));

        return ListView(
          // Bottom extra: convivencia con FAB extendido (alto ~56px) + margen.
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: children,
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAssetTypeSheet(
            context,
            onChanged: (value) {
              if (value.isVehiculo) {
                // Migrado 2026-05: antes apuntaba a `Routes.runtVehicleConsult`
                // (página legacy 1×1 retirada). Ahora va al flujo canónico.
                // Si no hay `AssetRegistrationContext` en arguments, la
                // página muestra "No se pudo iniciar el registro" en lugar
                // de crashear — entrada correcta es desde
                // `portfolio_asset_list_page` que sí provee el contexto.
                Get.toNamed(Routes.assetRegister);
              }
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar activo'),
      ),
    );
  }

  Map<AssetType, int> _countsByType(List<AssetEntity> assets) {
    final map = <AssetType, int>{};
    for (final a in assets) {
      map[a.type] = (map[a.type] ?? 0) + 1;
    }
    return map;
  }

  Color _colorFor(AssetType type, ColorScheme cs) => switch (type) {
        AssetType.vehicle => cs.primary,
        AssetType.realEstate => cs.tertiary,
        AssetType.machinery => cs.secondary,
        AssetType.equipment => cs.primary,
      };

  // ==========================================================================
  // PORTFOLIO HELPERS (presentacionales, sin lógica de negocio).
  // Reubicados desde AdminHomePage junto con la sección "Mis Portafolios
  // de activos". Se preserva el mapeo icono/color/label original.
  // ==========================================================================

  IconData _portfolioIcon(PortfolioType type) {
    switch (type) {
      case PortfolioType.vehiculos:
        return Icons.directions_car_outlined;
      case PortfolioType.inmuebles:
        return Icons.home_outlined;
      case PortfolioType.operacionGeneral:
        return Icons.work_outline;
    }
  }

  /// Color único (indigo brand) para las tarjetas de "Mis portafolios",
  /// distinto de la paleta theme (primary/tertiary/secondary) usada por
  /// "Tipos de activos". Así ambas secciones son netamente diferenciables
  /// a simple vista; la iconografía del tipo mantiene la diferenciación
  /// intra-sección entre portafolios.
  static const Color _portfolioAccentColor = AdminHomeDS.accentStart;

  String _portfolioTypeLabel(PortfolioType type) {
    switch (type) {
      case PortfolioType.vehiculos:
        return 'Flota vehicular';
      case PortfolioType.inmuebles:
        return 'Bienes inmuebles';
      case PortfolioType.operacionGeneral:
        return 'Operación general';
    }
  }
}

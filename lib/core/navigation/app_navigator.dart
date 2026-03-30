// ============================================================================
// lib/core/navigation/app_navigator.dart
// APP NAVIGATOR — Política de navegación determinística
//
// QUÉ HACE:
// - Centraliza toda la navegación de alto nivel de la app.
// - Elimina la dependencia del stack implícito de GetX en pantallas terminales.
// - Garantiza que el botón back del AppBar y el botón del sistema de Android
//   siempre naveguen al destino correcto sin importar el entry point.
//
// POLÍTICA ÚNICA (NO hay lógica condicional por entry point):
//   AssetDetail ← back → Portfolio
//   Portfolio   ← back → Home
//   (Siempre, independientemente de cómo se llegó a la pantalla.)
//
// QUÉ NO HACE:
// - No gestiona estado reactivo (no es un GetxController).
// - No accede a repositorios ni a Isar.
// - No decide la ruta según el tipo de activo o el número de activos.
//
// CUÁNDO USAR Get.back() vs AppNavigator:
//   - Get.back(): válido en modales, bottom sheets y flujos secundarios donde
//     el stack es predecible y controlado (p.ej. RtmDetailPage).
//   - AppNavigator: OBLIGATORIO en las pantallas terminales del flujo principal
//     (AssetDetailPage, PortfolioAssetListPage) donde el stack puede ser
//     ambiguo según el entry point.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Resuelve el bug de navegación post-registro donde
// Get.offAllNamed(portfolioAssets) dejaba el stack vacío, haciendo que
// Get.back() no tuviera a dónde ir.
// ============================================================================

import 'package:get/get.dart';

import '../../domain/entities/asset/asset_entity.dart';
import '../../domain/entities/portfolio/portfolio_entity.dart';
import '../../domain/value/navigation/asset_detail_args.dart';
import '../../routes/app_pages.dart';

/// Política de navegación determinística para el flujo principal de activos.
///
/// Todos los métodos son estáticos — no requieren instanciación.
/// Usar directamente: `AppNavigator.goToPortfolio(portfolio)`.
abstract class AppNavigator {
  AppNavigator._();

  // ──────────────────────────────────────────────────────────────────────────
  // FLUJO PRINCIPAL POST-REGISTRO
  // ──────────────────────────────────────────────────────────────────────────

  /// Navegación post-registro exitoso de activo.
  ///
  /// Reemplaza TODO el stack con [Routes.assetDetail] del activo recién creado.
  /// El AppBar back de [AssetDetailPage] irá explícitamente al portafolio.
  ///
  /// Úsalo SIEMPRE tras [AssetRepository.createAssetFromRuntAndLinkToPortfolio].
  static void afterAssetRegistration({
    required AssetEntity asset,
    required PortfolioEntity portfolio,
  }) {
    Get.offAllNamed(
      Routes.assetDetail,
      arguments: AssetDetailArgs(
        assetId: asset.id,
        portfolio: portfolio,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // NAVEGACIÓN EXPLÍCITA — Destinos terminales
  // ──────────────────────────────────────────────────────────────────────────

  /// Navega al detalle de un activo desde un portafolio (flujo normal).
  ///
  /// Usa [Get.toNamed] (preserva el stack). El AppBar back de AssetDetailPage
  /// igualmente irá al portafolio de forma explícita — no depende del stack.
  static void openAssetDetail({
    required String assetId,
    required PortfolioEntity portfolio,
  }) {
    Get.toNamed(
      Routes.assetDetail,
      arguments: AssetDetailArgs(
        assetId: assetId,
        portfolio: portfolio,
      ),
    );
  }

  /// Navega al portafolio (reemplaza la pantalla actual).
  ///
  /// Usado como destino del back en [AssetDetailPage].
  /// Usa [Get.offAllNamed] para garantizar que el portafolio sea la raíz
  /// del stack desde ese punto — su back irá a Home.
  static void goToPortfolio(PortfolioEntity portfolio) {
    Get.offAllNamed(
      Routes.portfolioAssets,
      arguments: portfolio,
    );
  }

  /// Navega al Home (raíz absoluta de la app).
  ///
  /// Usado como destino del back en [PortfolioAssetListPage] y como fallback
  /// cuando no hay portfolio disponible en [AssetDetailPage].
  static void goToHome() {
    Get.offAllNamed(Routes.home);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS COMPUESTOS
  // ──────────────────────────────────────────────────────────────────────────

  /// Back desde [AssetDetailPage].
  ///
  /// Si tiene portfolio → va al portafolio.
  /// Si no tiene portfolio (entry point legacy) → fallback a Home.
  ///
  /// Este método es el ÚNICO punto de decisión de back en AssetDetailPage.
  static void backFromAssetDetail(PortfolioEntity? portfolio) {
    if (portfolio != null) {
      goToPortfolio(portfolio);
    } else {
      goToHome();
    }
  }
}

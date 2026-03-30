// ============================================================================
// lib/domain/value/navigation/asset_detail_args.dart
// ASSET DETAIL ARGS — Argumento tipado de navegación hacia AssetDetailPage
//
// QUÉ HACE:
// - Transporta el assetId y el portfolio de origen necesarios para que
//   AssetDetailPage construya su navegación de retorno sin depender del stack.
// - portfolio es nullable solo para compatibilidad con puntos de entrada
//   legacy (p.ej. "Ver vehículo" desde detección de duplicado donde el
//   PortfolioEntity no está disponible de inmediato). En ese caso el
//   AppBar back navega a Home como fallback seguro.
//
// QUÉ NO HACE:
// - No contiene lógica de negocio.
// - No depende de GetX ni de ningún framework.
//
// USO:
//   // Normal (desde PortfolioAssetListPage):
//   AppNavigator.openAssetDetail(assetId: id, portfolio: portfolio);
//
//   // Tras registro exitoso:
//   AppNavigator.afterAssetRegistration(asset: entity, portfolio: portfolio);
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Parte de la política de navegación determinística
// que elimina la dependencia del stack implícito de GetX.
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../entities/portfolio/portfolio_entity.dart';

/// Argumento de navegación tipado para [Routes.assetDetail].
///
/// Reemplaza el uso de [String] crudo como argumento de navegación.
/// Transporta el contexto mínimo que [AssetDetailPage] necesita para
/// construir su navegación de retorno de forma determinística.
@immutable
class AssetDetailArgs {
  const AssetDetailArgs({
    required this.assetId,
    this.portfolio,
  });

  /// ID del activo a mostrar.
  final String assetId;

  /// Portafolio de origen. Usado para navegar de regreso al portafolio
  /// correspondiente desde el AppBar y el botón de sistema.
  ///
  /// Null solo en rutas legacy donde el PortfolioEntity no está disponible
  /// en el punto de entrada (fallback: navegar a Home).
  final PortfolioEntity? portfolio;
}

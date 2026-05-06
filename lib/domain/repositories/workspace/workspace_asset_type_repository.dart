// ============================================================================
// lib/domain/repositories/workspace/workspace_asset_type_repository.dart
// WORKSPACE ASSET TYPE REPOSITORY — Contrato (Domain)
//
// QUÉ HACE:
// - Define el contrato de lectura de los assetTypes que el workspace
//   activo opera, derivados canónicamente de sus `AssetActorLink`.
// - Único método: `listActive()`. Retorna lista posiblemente vacía.
//
// QUÉ NO HACE:
// - NO escribe. Lectura pura.
// - NO cachea: backend ya tiene cache de 60s si lo añade en el futuro;
//   v1 cliente no añade cache local.
// - NO infiere assetTypes desde Portfolio/Asset legacy. La SSOT es Core API.
//
// PRINCIPIOS:
// - Workspace context viene del JWT (`@ActiveOrgId` en backend). El
//   cliente NUNCA lo envía explícitamente.
// - Errores se propagan tal cual (excepciones tipadas de
//   `remote_exceptions.dart`).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): reemplaza la lista hardcodeada del form de
//   proveedor.
// ============================================================================

import '../../entities/workspace/workspace_asset_type_entity.dart';

abstract class WorkspaceAssetTypeRepository {
  /// `GET /v1/core-common/workspaces/me/asset-types` — devuelve los
  /// assetTypes que el workspace activo opera (derivados de sus
  /// AssetActorLink activos).
  ///
  /// Lista vacía es un resultado válido: el workspace aún no opera ningún
  /// activo. La UI muestra estado guía ("registra un activo primero").
  ///
  /// Throws:
  /// - `UnauthorizedException` si la sesión Firebase está ausente o
  ///   el caller no tiene la capability `workspace_asset_type.read`.
  /// - `NetworkException` ante fallos sin respuesta HTTP.
  /// - `ServerException` ante 5xx.
  Future<List<WorkspaceAssetTypeEntity>> listActive();
}

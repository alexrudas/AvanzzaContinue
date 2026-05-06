// ============================================================================
// lib/domain/entities/workspace/workspace_asset_type_entity.dart
// WORKSPACE ASSET TYPE ENTITY — Tipo de activo que opera el workspace activo
//
// QUÉ HACE:
// - Modela un assetType que el workspace activo opera realmente, derivado
//   de sus `AssetActorLink` activos en backend.
// - Alimentado por `GET /v1/core-common/workspaces/me/asset-types` del
//   Avanzza Core API. Reemplaza la lista hardcodeada `kKnownAssetTypes`
//   que se eliminó al introducir esta resolución dinámica.
//
// QUÉ NO HACE:
// - NO incluye toda la jerarquía de ancestros. El backend ya hace expansion
//   server-side cuando aplica (catálogo de specialties).
// - NO almacena metadata de capacidades, permisos ni stats — solo el
//   mínimo necesario para el dropdown del form.
//
// PRINCIPIOS:
// - Inmutable. Igualdad estructural por `id`.
// - `id` es wire-stable y coincide con `AssetType.id` de Postgres.
// - Default vacío en respuestas significa "el workspace aún no opera
//   ningún tipo de activo" (workspace recién creado, sin activos
//   vinculados). UX guía al usuario a `Routes.assetRegister`.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): reemplazo del dropdown hardcodeado.
// ============================================================================

class WorkspaceAssetTypeEntity {
  /// Identificador estable del catálogo (`AssetType.id` en Postgres).
  /// Ej. `vehicle.car`, `vehicle`, `real_estate.house`.
  final String id;

  /// Nombre legible para mostrar en UI (en español).
  final String name;

  /// Padre jerárquico. Ej. `vehicle.car.parentId == 'vehicle'`.
  /// `null` indica un nodo raíz del catálogo.
  final String? parentId;

  const WorkspaceAssetTypeEntity({
    required this.id,
    required this.name,
    required this.parentId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkspaceAssetTypeEntity && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WorkspaceAssetTypeEntity(id=$id, name=$name)';
}

// ============================================================================
// lib/domain/services/access/asset_class_catalog.dart
// ASSET CLASS CATALOG — fallback cliente del catálogo global de AssetType.
//
// QUÉ HACE:
// - Expone los 5 ids canónicos top-level que Avanzza Core API reconoce como
//   raíces vivas en la tabla `asset_type` (`vehicle`, `real_estate`,
//   `machinery`, `equipment`, `other`).
// - Sirve como fuente de catálogo PARA ESCENARIOS DECLARATIVOS donde el
//   workspace activo todavía no opera ningún `AssetType` (ej. proveedor
//   nuevo haciendo bootstrap sin haber registrado activos previamente).
//
// QUÉ NO HACE:
// - NO reemplaza al endpoint server-side `GET /v1/core-common/workspaces/me/
//   asset-types` cuando éste sí devuelve datos (para flujos donde la
//   relevancia es "qué opera HOY el workspace", no "qué declara cubrir").
// - NO inventa subtipos (`vehicle.car`, `real_estate.house`, ...). Esos
//   sólo deben aparecer cuando exista `GET /v1/catalog/asset-types`
//   global (deuda backend documentada en
//   `core-common/asset-actor-link/constants/asset-class.ts`).
//
// PRINCIPIOS:
// - WIRE-STABLE con backend: los ids del catálogo cliente son LITERAL los
//   valores de `AssetClass` en `asset-class.ts`. Si Core API extiende el
//   enum, ampliar este catálogo en una migración coordinada.
// - Strings de display SIEMPRE en español (idioma único del producto hoy).
// - Solo Dart core; cero dependencias externas.
//
// FUTURO:
// - Cuando Core API publique `GET /v1/catalog/asset-types`, este catálogo
//   debe alimentarse desde ese endpoint y dejar el array hardcodeado como
//   fallback offline. Mientras tanto, este es el contrato cliente.
// ============================================================================

import '../../entities/workspace/workspace_asset_type_entity.dart';

class AssetClassCatalog {
  AssetClassCatalog._();

  /// Catálogo global canónico. Cada `id` corresponde 1:1 con un
  /// `AssetType.id` raíz vivo en Postgres (ver `ASSET_CLASS_TO_ROOT_ID`
  /// en Core API).
  static const List<WorkspaceAssetTypeEntity> _catalog =
      <WorkspaceAssetTypeEntity>[
    WorkspaceAssetTypeEntity(
      id: 'vehicle',
      name: 'Vehículos',
      parentId: null,
    ),
    WorkspaceAssetTypeEntity(
      id: 'real_estate',
      name: 'Inmuebles',
      parentId: null,
    ),
    WorkspaceAssetTypeEntity(
      id: 'machinery',
      name: 'Maquinaria',
      parentId: null,
    ),
    WorkspaceAssetTypeEntity(
      id: 'equipment',
      name: 'Equipos',
      parentId: null,
    ),
    WorkspaceAssetTypeEntity(
      id: 'other',
      name: 'Otros',
      parentId: null,
    ),
  ];

  /// Retorna el catálogo global. Lista inmodificable para evitar mutación
  /// accidental por consumidores.
  static List<WorkspaceAssetTypeEntity> list() =>
      List<WorkspaceAssetTypeEntity>.unmodifiable(_catalog);

  /// Set de ids válidos. Útil en tests y validaciones defensivas.
  static const Set<String> validIds = <String>{
    'vehicle',
    'real_estate',
    'machinery',
    'equipment',
    'other',
  };
}

// ============================================================================
// lib/domain/entities/core_common/value_objects/asset_class.dart
// AssetClass — alias top-level del kind de activo (espejo del backend)
// ============================================================================
//
// QUÉ HACE:
//   Espejo wire-stable del enum `AssetClass` definido en Avanzza Core API
//   (`src/modules/core-common/asset-actor-link/constants/asset-class.ts`).
//   Lo usa el cliente al declarar un vínculo `user_declared` cuando NO
//   conoce el `AssetType.id` canónico — el backend hace la resolución vía
//   `ASSET_CLASS_TO_ROOT_ID` y persiste el id resuelto.
//
// QUÉ NO HACE:
//   - NO mapea a `AssetType.id`. Esa responsabilidad es 100 % del backend.
//   - NO clasifica subtipos (vehicle.car, vehicle.motorcycle). Cuando el
//     cliente necesite seleccionar subtipo, lo hará vía dropdown explícito
//     poblado por `GET /v1/catalog/asset-types` (endpoint pendiente
//     post-Hito 1.x) y enviará el id directo (camino A del XOR).
//   - NO se persiste en Isar/Firestore. Es un valor wire transitorio que
//     viaja del cliente al backend en el body del POST.
//
// WIRE-STABLE:
//   Los `wireName` son contrato. Renombrar un valor rompe el wire. Para
//   introducir un kind nuevo:
//     1) extender este enum (Flutter).
//     2) extender el enum espejo en backend.
//     3) extender `ASSET_CLASS_TO_ROOT_ID` en backend.
//     4) garantizar que el id resuelto exista + isActive=true en seed.
//
// See `avanzza-core-api/src/modules/core-common/asset-actor-link/constants/asset-class.ts`.
// ============================================================================

/// Kinds top-level del modelo Asset que el cliente puede declarar al
/// backend sin conocer el `AssetType.id` canónico. Backend resuelve el id
/// raíz vivo en la tabla `asset_type`.
enum AssetClass {
  /// Vehículos. Backend resuelve a `'vehicle'` (root) bajo el seed actual.
  vehicle,

  /// Inmuebles. Backend resuelve a `'real_estate'` cuando el seed lo
  /// incluya.
  realEstate,

  /// Maquinaria pesada / industrial.
  machinery,

  /// Equipos generales (no-vehículo, no-maquinaria pesada).
  equipment,

  /// Categoría residual para activos fuera de los kinds tipados.
  other,
}

extension AssetClassX on AssetClass {
  /// Wire value enviado al backend en el body del POST.
  /// DEBE coincidir 1:1 con el enum del backend.
  String get wireName {
    switch (this) {
      case AssetClass.vehicle:
        return 'vehicle';
      case AssetClass.realEstate:
        return 'real_estate';
      case AssetClass.machinery:
        return 'machinery';
      case AssetClass.equipment:
        return 'equipment';
      case AssetClass.other:
        return 'other';
    }
  }

  /// Inverso de [wireName]. Lanza [ArgumentError] si el valor no es
  /// reconocido — fail-fast en parsing de respuestas backend.
  static AssetClass fromWire(String raw) {
    switch (raw) {
      case 'vehicle':
        return AssetClass.vehicle;
      case 'real_estate':
        return AssetClass.realEstate;
      case 'machinery':
        return AssetClass.machinery;
      case 'equipment':
        return AssetClass.equipment;
      case 'other':
        return AssetClass.other;
      default:
        throw ArgumentError('AssetClass desconocido: $raw');
    }
  }
}

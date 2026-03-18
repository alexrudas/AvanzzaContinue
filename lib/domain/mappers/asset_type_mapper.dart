// ============================================================================
// lib/domain/mappers/asset_type_mapper.dart
// ASSET TYPE MAPPER — Bridge between registration enum and canonical enum
//
// QUÉ HACE:
// - Convierte AssetRegistrationType (enum del wizard) → AssetType (canonical).
// - Conversión inversa: AssetType → AssetRegistrationType (best-effort).
// - Expone ambas direcciones como métodos estáticos.
//
// QUÉ NO HACE:
// - No modifica wire-names de Isar ni de Firebase.
// - No modifica AssetRegistrationType ni AssetType.
//
// PRINCIPIOS:
// - `otro` no tiene equivalente canónico → lanza UnsupportedError.
//   El wizard debe validar que el usuario no seleccione 'otro' antes de
//   intentar la conversión. Esta política fuerza el error en compile-time.
// - Mapper puro: sin estado, sin dependencias de framework.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): resuelve colisión entre AssetRegistrationType (UI/wizard)
// y AssetType (domain/canonical). El wizard usa AssetRegistrationType;
// AssetRepository y AssetEntity usan AssetType.
// ============================================================================

import '../entities/asset/asset_entity.dart';
import '../shared/enums/asset_type.dart';

/// Converts between the wizard's [AssetRegistrationType] and the domain's
/// canonical [AssetType].
abstract final class AssetTypeMapper {
  /// Maps [AssetRegistrationType] → canonical [AssetType].
  ///
  /// Throws [UnsupportedError] for [AssetRegistrationType.otro] because
  /// there is no canonical equivalent. The wizard must prevent this case
  /// before calling the repository.
  static AssetType toCanonical(AssetRegistrationType reg) {
    switch (reg) {
      case AssetRegistrationType.vehiculo:
        return AssetType.vehicle;
      case AssetRegistrationType.inmueble:
        return AssetType.realEstate;
      case AssetRegistrationType.maquinaria:
        return AssetType.machinery;
      case AssetRegistrationType.equipo:
        return AssetType.equipment;
      case AssetRegistrationType.otro:
        throw UnsupportedError(
          'AssetRegistrationType.otro has no canonical AssetType equivalent. '
          'Validate the selection before calling the repository.',
        );
    }
  }

  /// Maps canonical [AssetType] → [AssetRegistrationType] (best-effort).
  ///
  /// All canonical types have a direct registration counterpart.
  static AssetRegistrationType fromCanonical(AssetType type) {
    switch (type) {
      case AssetType.vehicle:
        return AssetRegistrationType.vehiculo;
      case AssetType.realEstate:
        return AssetRegistrationType.inmueble;
      case AssetType.machinery:
        return AssetRegistrationType.maquinaria;
      case AssetType.equipment:
        return AssetRegistrationType.equipo;
    }
  }
}

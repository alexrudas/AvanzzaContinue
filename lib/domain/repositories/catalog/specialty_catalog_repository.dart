// ============================================================================
// lib/domain/repositories/catalog/specialty_catalog_repository.dart
// SPECIALTY CATALOG REPOSITORY — Contrato (Domain)
//
// QUÉ HACE:
// - Define el contrato de lectura del catálogo global de specialties.
// - Único método: `list({assetType, type})`. Devuelve `SpecialtyCatalogResult`
//   con la lista ya filtrada y ordenada por el backend.
//
// QUÉ NO HACE:
// - NO escribe: el catálogo es read-only desde Core API.
// - NO ordena, deduplica ni filtra en cliente — el backend lo hace.
// - NO cachea: el backend tiene cache de 60s; v1 cliente no añade cache local.
// - NO mapea `null` a `BOTH`. `type == null` significa "sin filtro".
//
// PRINCIPIOS / INVARIANTES:
// - `assetType` es REQUERIDO por backend; si vacío → BadRequestException con
//   `code = INVALID_ASSET_TYPE`.
// - `type` es OPCIONAL (PRODUCT | SERVICE | BOTH). Cualquier otro valor →
//   BadRequestException con `code = INVALID_SPECIALTY_TYPE`.
// - Errores se manejan por `code`, no por `message`.
//
// ENTERPRISE NOTES:
// - Vive en `repositories/catalog/` para no colisionar con el legado
//   `catalog_repository.dart` (categorías de provider en memoria).
// - CREADO (2026-04-25).
// ============================================================================

import '../../entities/catalog/specialty_entity.dart';

/// Resultado de `SpecialtyCatalogRepository.list`.
///
/// Refleja 1:1 el contrato Core API:
/// `{ assetType, resolvedAssetTypes, type, specialties }`.
class SpecialtyCatalogResult {
  /// `assetType` normalizado por backend (lowercase trimmed).
  final String assetType;

  /// Cadena ancestral resuelta por backend (e.g. `["vehicle", "vehicle.car"]`).
  /// Útil para debugging/observabilidad — la UI no lo muestra hoy.
  final List<String> resolvedAssetTypes;

  /// Filtro aplicado (PRODUCT | SERVICE | BOTH) o `null` si no se filtró.
  /// IMPORTANTE: `null` ≠ BOTH. Se preserva el null tal cual viene del wire.
  final SpecialtyKind? type;

  /// Lista de specialties — ya viene filtrada, ordenada (name ASC) y deduplicada.
  /// La UI NO debe reordenar.
  final List<Specialty> specialties;

  const SpecialtyCatalogResult({
    required this.assetType,
    required this.resolvedAssetTypes,
    required this.type,
    required this.specialties,
  });
}

/// Contrato del repositorio de catálogo global de specialties.
///
/// Implementación esperada: thin wrapper sobre `SpecialtyCatalogApiClient`
/// que mapea DTOs ↔ entities. Sin cache local (backend ya cachea 60s).
abstract class SpecialtyCatalogRepository {
  /// Lista specialties del catálogo global compatibles con [assetType].
  ///
  /// - [assetType]: requerido (no vacío). Identificador semántico del tipo
  ///   de activo (e.g. `"vehicle"`, `"vehicle.car"`).
  /// - [type]: filtro opcional. `null` = sin filtro (trae PRODUCT, SERVICE y BOTH).
  ///
  /// Throws:
  /// - `BadRequestException` (code=INVALID_ASSET_TYPE / INVALID_SPECIALTY_TYPE)
  ///   ante input inválido.
  /// - `UnauthorizedException` si la sesión Firebase está ausente o caducó.
  /// - `NetworkException` ante fallos sin respuesta HTTP.
  /// - `ServerException` ante 5xx.
  /// - `RequestCancelledException` si una llamada posterior a [list] o a
  ///   [cancelInFlight] aborta este request. La UI debe ignorarla.
  ///
  /// CONTRATO: cada invocación a [list] cancela cualquier request en curso
  /// disparado por una invocación previa de este repositorio. Ver
  /// [cancelInFlight] para cancelar sin disparar uno nuevo.
  Future<SpecialtyCatalogResult> list({
    required String assetType,
    SpecialtyKind? type,
  });

  /// Cancela el request en vuelo (si lo hay) sin disparar uno nuevo.
  ///
  /// El caller (controller) puede llamarlo en `onClose()` para evitar
  /// que respuestas tardías intenten actualizar UI ya descartada.
  /// Idempotente: si no hay request activo, no hace nada.
  void cancelInFlight();
}

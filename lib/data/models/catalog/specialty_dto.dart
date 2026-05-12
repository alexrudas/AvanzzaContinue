// ============================================================================
// lib/data/models/catalog/specialty_dto.dart
// SPECIALTY DTO + MAPPER — Wire ↔ Domain
//
// QUÉ HACE:
// - Define DTOs 1:1 con el JSON de `GET /v1/catalog/specialties`:
//     - `SpecialtyDto`: { id, key, name, kind }
//     - `SpecialtyCatalogResultDto`: { assetType, resolvedAssetTypes, type,
//       specialties[] }
// - Provee mappers `toEntity()` que descartan `key` (no se usa en UI) y
//   parsean `kind` con `SpecialtyKind.fromWire`.
// - Tolera valores `kind` desconocidos descartando la specialty (defensa
//   en profundidad ante drift de contrato — el backend es la fuente).
//
// QUÉ NO HACE:
// - NO ordena ni deduplica: backend ya entrega lista lista.
// - NO infiere `kind` desde `key` (regla crítica del prompt).
// - NO mapea `type==null` a `BOTH` con `??`. `null` ≠ `BOTH`.
// - NO usa freezed/json_serializable: el DTO es trivial y este módulo
//   no requiere codegen — mantiene la build limpia.
//
// PRINCIPIOS:
// - Parser tolerante a tipos `dynamic` (Dio entrega `Map<String, dynamic>`),
//   pero estricto en presencia/forma de campos requeridos.
// - Lanza `FormatException` ante shape incorrecto: el datasource lo traduce
//   a `ServerException` para que el repo/controller razonen sobre el error.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-25).
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../../domain/entities/catalog/specialty_entity.dart';
import '../../../domain/repositories/catalog/specialty_catalog_repository.dart';

/// DTO 1:1 del item `specialties[i]` del response.
class SpecialtyDto {
  final String id;
  final String key;
  final String name;
  final String kind;

  const SpecialtyDto({
    required this.id,
    required this.key,
    required this.name,
    required this.kind,
  });

  factory SpecialtyDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final key = json['key'];
    final name = json['name'];
    final kind = json['kind'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('SpecialtyDto.id ausente o no es String.');
    }
    if (key is! String) {
      throw const FormatException('SpecialtyDto.key ausente o no es String.');
    }
    if (name is! String) {
      throw const FormatException('SpecialtyDto.name ausente o no es String.');
    }
    if (kind is! String) {
      throw const FormatException('SpecialtyDto.kind ausente o no es String.');
    }
    return SpecialtyDto(id: id, key: key, name: name, kind: kind);
  }

  /// Convierte el DTO a entidad de dominio. Retorna `null` si el `kind`
  /// es desconocido — el caller filtra estos casos sin romper el flujo.
  Specialty? toEntityOrNull() {
    try {
      return Specialty(
        id: id,
        name: name,
        kind: SpecialtyKind.fromWire(kind),
      );
    } catch (e) {
      // Drift de contrato: backend introdujo un kind nuevo. Lo descartamos
      // silenciosamente y registramos en debug — la UI no debe romper.
      debugPrint('[SpecialtyDto] kind desconocido descartado: $kind ($e)');
      return null;
    }
  }
}

/// DTO 1:1 del response completo de `GET /v1/catalog/specialties`.
class SpecialtyCatalogResultDto {
  final String assetType;
  final List<String> resolvedAssetTypes;

  /// Wire string del filtro aplicado (`PRODUCT` | `SERVICE` | `BOTH`) o `null`.
  /// Se preserva tal cual; null NO se mapea a BOTH (regla crítica del prompt).
  final String? type;

  final List<SpecialtyDto> specialties;

  const SpecialtyCatalogResultDto({
    required this.assetType,
    required this.resolvedAssetTypes,
    required this.type,
    required this.specialties,
  });

  factory SpecialtyCatalogResultDto.fromJson(Map<String, dynamic> json) {
    final assetType = json['assetType'];
    final resolved = json['resolvedAssetTypes'];
    final type = json['type'];
    final specialties = json['specialties'];

    if (assetType is! String) {
      throw const FormatException(
          'SpecialtyCatalogResultDto.assetType ausente o no es String.');
    }
    if (resolved is! List) {
      throw const FormatException(
          'SpecialtyCatalogResultDto.resolvedAssetTypes ausente o no es List.');
    }
    if (specialties is! List) {
      throw const FormatException(
          'SpecialtyCatalogResultDto.specialties ausente o no es List.');
    }
    if (type != null && type is! String) {
      throw const FormatException(
          'SpecialtyCatalogResultDto.type debe ser String o null.');
    }

    return SpecialtyCatalogResultDto(
      assetType: assetType,
      resolvedAssetTypes:
          resolved.whereType<String>().toList(growable: false),
      type: type as String?,
      specialties: specialties
          .whereType<Map<String, dynamic>>()
          .map(SpecialtyDto.fromJson)
          .toList(growable: false),
    );
  }

  /// Convierte el DTO a `SpecialtyCatalogResult` de dominio.
  ///
  /// - Filtra entries con `kind` desconocido (drift defensivo).
  /// - Preserva el orden de la API (regla crítica: NO reordenar).
  /// - `type == null` se mantiene como `null` (NO se mapea a BOTH).
  SpecialtyCatalogResult toEntity() {
    final mapped = <Specialty>[];
    for (final dto in specialties) {
      final e = dto.toEntityOrNull();
      if (e != null) mapped.add(e);
    }
    return SpecialtyCatalogResult(
      assetType: assetType,
      resolvedAssetTypes: resolvedAssetTypes,
      type: type == null ? null : SpecialtyKind.fromWire(type!),
      specialties: mapped,
    );
  }
}

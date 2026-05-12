// ============================================================================
// lib/data/models/provider/provider_canonical_dto.dart
// PROVIDER CANONICAL DTOs + MAPPERS — Wire ↔ Domain
//
// QUÉ HACE:
// - Define DTOs request 1:1 con el contrato `POST /v1/providers`.
// - Define DTOs response 1:1 con el response shape compartido por
//   `POST /v1/providers` y `GET /v1/providers/:id`.
// - Provee mappers `toEntity()` que descartan `resolution` /
//   `identityConfidence` (campos diagnósticos del backend, NO contractuales)
//   antes de cruzar a domain.
//
// QUÉ NO HACE:
// - NO normaliza probes (eso es responsabilidad del caller — wire-stable
//   ya viene del backend / cliente normalizador).
// - NO ordena specialties: backend las entrega ordenadas por nombre ASC.
// - NO construye errores tipados: la traducción de DioException → excepción
//   canónica vive en el ApiClient.
//
// PRINCIPIOS:
// - Parsers tolerantes de tipo (`Map<String, dynamic>` desde Dio) pero
//   estrictos en presencia de campos requeridos.
// - Lanza `FormatException` ante shape incorrecto; el ApiClient la traduce
//   a `ServerException`.
// - Skip silencioso de specialties con `kind` desconocido (drift defensivo
//   — mismo patrón que `specialty_dto.dart`).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): Hito 1 — integración Flutter canónica.
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../../domain/entities/catalog/specialty_entity.dart' show SpecialtyKind;
import '../../../domain/entities/provider/provider_canonical_entity.dart';
import '../../../domain/repositories/provider/provider_canonical_repository.dart';

// ─── Request: ProvisionProviderRequestDto ─────────────────────────────────

class ProvisionProviderRequestDto {
  final ProvisionProviderInput input;

  const ProvisionProviderRequestDto(this.input);

  /// Serializa el input de domain a la shape exacta que espera Core API.
  Map<String, dynamic> toJson() {
    final src = input.source;
    final identity = input.identity;
    return <String, dynamic>{
      'source': <String, dynamic>{
        'kind': src.kind.wireName,
        if (src.localKind != null) 'localKind': src.localKind,
        if (src.localId != null) 'localId': src.localId,
        if (src.platformActorId != null) 'platformActorId': src.platformActorId,
      },
      'identity': <String, dynamic>{
        'displayName': identity.displayName,
        'actorKind': identity.actorKind.wireName,
        if (identity.legalName != null) 'legalName': identity.legalName,
        if (identity.fullLegalName != null)
          'fullLegalName': identity.fullLegalName,
      },
      if (input.probes.isNotEmpty)
        'probes': input.probes
            .map(
              (p) => <String, dynamic>{
                'keyType': p.keyTypeWire,
                'normalizedValue': p.normalizedValue,
              },
            )
            .toList(growable: false),
    };
  }
}

// ─── Request: ReplaceSpecialtiesRequestDto ────────────────────────────────

class ReplaceSpecialtiesRequestDto {
  final Set<String> specialtyIds;
  final DateTime providerProfileUpdatedAt;

  const ReplaceSpecialtiesRequestDto({
    required this.specialtyIds,
    required this.providerProfileUpdatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'specialtyIds': specialtyIds.toList(growable: false),
      'providerProfileUpdatedAt': providerProfileUpdatedAt.toIso8601String(),
    };
  }
}

// ─── Response: ProviderCanonicalResponseDto ───────────────────────────────

class ProviderCanonicalSpecialtyDto {
  final String id;
  final String key;
  final String name;
  final String kind; // wire: PRODUCT|SERVICE|BOTH

  const ProviderCanonicalSpecialtyDto({
    required this.id,
    required this.key,
    required this.name,
    required this.kind,
  });

  factory ProviderCanonicalSpecialtyDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final key = json['key'];
    final name = json['name'];
    final kind = json['kind'];
    if (id is! String || id.isEmpty) {
      throw const FormatException(
          'ProviderCanonicalSpecialtyDto.id ausente o no es String.');
    }
    if (key is! String) {
      throw const FormatException(
          'ProviderCanonicalSpecialtyDto.key ausente o no es String.');
    }
    if (name is! String) {
      throw const FormatException(
          'ProviderCanonicalSpecialtyDto.name ausente o no es String.');
    }
    if (kind is! String) {
      throw const FormatException(
          'ProviderCanonicalSpecialtyDto.kind ausente o no es String.');
    }
    return ProviderCanonicalSpecialtyDto(
      id: id,
      key: key,
      name: name,
      kind: kind,
    );
  }

  /// Convierte a entity. Retorna `null` si `kind` es desconocido — el
  /// caller filtra estos casos sin romper el flujo.
  ProviderCanonicalSpecialty? toEntityOrNull() {
    try {
      return ProviderCanonicalSpecialty(
        id: id,
        key: key,
        name: name,
        kind: SpecialtyKind.fromWire(kind),
      );
    } catch (e) {
      debugPrint(
        '[ProviderCanonicalSpecialtyDto] kind desconocido descartado: $kind ($e)',
      );
      return null;
    }
  }
}

class ProviderCanonicalResponseDto {
  final String providerProfileId;
  final String workspaceId;
  final String platformActorId;
  final String displayName;
  final String actorKind; // wire: person|organization
  final String? legalName;
  final String? fullLegalName;
  final bool isActive;
  final double? responseRateAvg;
  final String? notes;
  final List<ProviderCanonicalSpecialtyDto> specialties;
  final String createdAt; // ISO 8601
  final String updatedAt;

  /// Diagnostic only — NO se cruza a domain.
  final String? resolution;

  /// Diagnostic only — NO se cruza a domain.
  final String? identityConfidence;

  const ProviderCanonicalResponseDto({
    required this.providerProfileId,
    required this.workspaceId,
    required this.platformActorId,
    required this.displayName,
    required this.actorKind,
    required this.legalName,
    required this.fullLegalName,
    required this.isActive,
    required this.responseRateAvg,
    required this.notes,
    required this.specialties,
    required this.createdAt,
    required this.updatedAt,
    required this.resolution,
    required this.identityConfidence,
  });

  factory ProviderCanonicalResponseDto.fromJson(Map<String, dynamic> json) {
    final providerProfileId = json['providerProfileId'];
    final workspaceId = json['workspaceId'];
    final platformActorId = json['platformActorId'];
    final displayName = json['displayName'];
    final actorKind = json['actorKind'];
    final isActive = json['isActive'];
    final createdAt = json['createdAt'];
    final updatedAt = json['updatedAt'];
    final specialtiesRaw = json['specialties'];

    if (providerProfileId is! String || providerProfileId.isEmpty) {
      throw const FormatException('providerProfileId ausente o vacío.');
    }
    if (workspaceId is! String) {
      throw const FormatException('workspaceId ausente o no es String.');
    }
    if (platformActorId is! String) {
      throw const FormatException('platformActorId ausente o no es String.');
    }
    if (displayName is! String) {
      throw const FormatException('displayName ausente o no es String.');
    }
    if (actorKind is! String) {
      throw const FormatException('actorKind ausente o no es String.');
    }
    if (isActive is! bool) {
      throw const FormatException('isActive ausente o no es bool.');
    }
    if (createdAt is! String) {
      throw const FormatException('createdAt ausente o no es String.');
    }
    if (updatedAt is! String) {
      throw const FormatException('updatedAt ausente o no es String.');
    }
    if (specialtiesRaw is! List) {
      throw const FormatException('specialties ausente o no es List.');
    }

    final responseRateAvg = json['responseRateAvg'];
    final responseRateAvgD = responseRateAvg is num
        ? responseRateAvg.toDouble()
        : null;

    return ProviderCanonicalResponseDto(
      providerProfileId: providerProfileId,
      workspaceId: workspaceId,
      platformActorId: platformActorId,
      displayName: displayName,
      actorKind: actorKind,
      legalName: json['legalName'] as String?,
      fullLegalName: json['fullLegalName'] as String?,
      isActive: isActive,
      responseRateAvg: responseRateAvgD,
      notes: json['notes'] as String?,
      specialties: specialtiesRaw
          .whereType<Map<String, dynamic>>()
          .map(ProviderCanonicalSpecialtyDto.fromJson)
          .toList(growable: false),
      createdAt: createdAt,
      updatedAt: updatedAt,
      resolution: json['resolution'] as String?,
      identityConfidence: json['identityConfidence'] as String?,
    );
  }

  /// Convierte a entity de dominio. Filtra specialties con `kind` desconocido.
  /// Descarta `resolution` / `identityConfidence` (diagnostic-only).
  ProviderCanonicalEntity toEntity() {
    final mappedSpecialties = <ProviderCanonicalSpecialty>[];
    for (final s in specialties) {
      final entity = s.toEntityOrNull();
      if (entity != null) mappedSpecialties.add(entity);
    }
    return ProviderCanonicalEntity(
      providerProfileId: providerProfileId,
      workspaceId: workspaceId,
      platformActorId: platformActorId,
      displayName: displayName,
      actorKind: ProviderActorKind.fromWire(actorKind),
      legalName: legalName,
      fullLegalName: fullLegalName,
      isActive: isActive,
      responseRateAvg: responseRateAvg,
      notes: notes,
      specialties: mappedSpecialties,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

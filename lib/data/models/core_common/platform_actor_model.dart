// ============================================================================
// lib/data/models/core_common/platform_actor_model.dart
// PLATFORM ACTOR MODEL — Data Layer / Isar + JSON (cache local delgado)
// ============================================================================
// QUÉ HACE:
//   - Persiste un snapshot cacheado de PlatformActorEntity en Isar.
//   - Scope de cache: solo actors referenciados por Relaciones ≥ detectable
//     del workspace, o por MatchCandidates expuestos.
//
// QUÉ NO HACE:
//   - NO es SSOT: el SSOT vive en NestJS (Postgres).
//   - NO guarda VerifiedKeys: el matcher global es el único que las maneja.
//   - NO facilita descubrimiento: el hydrate del cache viene de flujos ya
//     justificados (Relaciones/MatchCandidates expuestos), nunca por búsqueda
//     libre — la política se aplica en el datasource remoto (F3).
//
// CACHE SEMANTICS (CRÍTICAS):
//   - Puede quedar STALE: el actor en NestJS puede cambiar (nombre legal,
//     avatar, primaryVerifiedKey) y este cache NO se entera hasta el próximo
//     fetch remoto.
//   - NO es fuente de verdad: cualquier decisión operativa (emitir Request,
//     confirmar match, transicionar Relación) que dependa de atributos del
//     actor DEBE revalidar contra NestJS antes de proceder.
//   - NO debe usarse para decisiones críticas sin validación: el cache es
//     exclusivamente para latencia de lectura (UI rápida, visualización
//     offline). Cualquier lectura con consecuencias (pagos, cierres, firma
//     de documentos, envío externo con datos personales) debe pasar por el
//     backend directamente.
//
// PRINCIPIOS:
//   - Wire-stable en actorKindWire.
//   - Unique sin replace: colisiones de id explícitas.
//   - El cache puede limpiarse sin pérdida: el SSOT está en backend.
//
// ENTERPRISE NOTES:
//   - linkedUserId opcional: relación 1:1 con User cuando actorKind=person.
// ============================================================================

// NOTA: import de isar_community sin alias — requerido por el codegen.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/platform_actor_entity.dart';
import '../../../domain/entities/core_common/value_objects/actor_kind.dart';

part 'platform_actor_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class PlatformActorModel {
  Id? isarId;

  /// Business ID (único, indexado). Sin replace: colisiones explícitas.
  @Index(unique: true)
  final String id;

  /// Wire name de ActorKind (organization | person).
  final String actorKindWire;

  final String displayName;

  final DateTime createdAt;
  final DateTime updatedAt;

  final String? legalName;
  final String? fullLegalName;
  final String? avatarRef;
  final String? primaryVerifiedKeyId;
  final String? linkedUserId;

  PlatformActorModel({
    this.isarId,
    required this.id,
    required this.actorKindWire,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.legalName,
    this.fullLegalName,
    this.avatarRef,
    this.primaryVerifiedKeyId,
    this.linkedUserId,
  });

  PlatformActorEntity toEntity() => PlatformActorEntity(
        id: id,
        actorKind: ActorKindX.fromWire(actorKindWire),
        displayName: displayName,
        createdAt: createdAt,
        updatedAt: updatedAt,
        legalName: legalName,
        fullLegalName: fullLegalName,
        avatarRef: avatarRef,
        primaryVerifiedKeyId: primaryVerifiedKeyId,
        linkedUserId: linkedUserId,
      );

  factory PlatformActorModel.fromEntity(PlatformActorEntity e) =>
      PlatformActorModel(
        id: e.id,
        actorKindWire: e.actorKind.wireName,
        displayName: e.displayName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        legalName: e.legalName,
        fullLegalName: e.fullLegalName,
        avatarRef: e.avatarRef,
        primaryVerifiedKeyId: e.primaryVerifiedKeyId,
        linkedUserId: e.linkedUserId,
      );

  factory PlatformActorModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformActorModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformActorModelToJson(this);
}

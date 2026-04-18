// ============================================================================
// lib/data/models/core_common/remote/local_organization_remote_dto.dart
// LOCAL ORGANIZATION REMOTE DTO — Data Layer / Contrato remoto Firestore
// ============================================================================
// QUÉ HACE:
//   - Define la forma serializada de LocalOrganization para PERSISTENCIA REMOTA
//     en Firestore, excluyendo DELIBERADAMENTE los campos privados del
//     workspace (notesPrivate, tagsPrivate) que nunca deben viajar.
//   - Expone UNA sola dirección segura: fromEntity(entity) → DTO remoto.
//
// QUÉ NO HACE:
//   - NO reconstruye una Entity "lista para guardar" a partir del DTO remoto.
//     Esa ruta sería peligrosa (perdería privados locales). Por diseño, este
//     DTO NO tiene toEntity().
//   - No sincroniza a NestJS Postgres: la red local vive solo en Firestore
//     del propio workspace + Isar local del cliente.
//
// POR QUÉ NO HAY toEntity():
//   - LocalOrganization contiene campos privados (notesPrivate, tagsPrivate)
//     que viven SOLO en Isar y nunca viajan por la red.
//   - Si existiera toEntity() devolviendo una Entity "válida", un caller ingenuo
//     podría persistirla directamente, PERDIENDO los privados previamente
//     almacenados en Isar.
//   - Ese riesgo queda cerrado eliminando toEntity() en favor de funciones
//     explícitas en el merger centralizado:
//       · hydrateNewLocalOrganizationFromRemote(remote)
//           → crea una Entity nueva (privados vacíos, nombre explícito).
//       · mergeExistingLocalOrganizationWithRemote(remote, existingLocal)
//           → fusiona preservando notesPrivate y tagsPrivate del registro local.
//     Ver: lib/domain/services/core_common/local_organization_remote_merger.dart
//
// CAMPOS EXCLUIDOS POR DISEÑO (privacidad by default):
//   - notesPrivate
//   - tagsPrivate
//
// ============================================================================
// MANIFIESTO — CONTRATO REMOTO Core Common v1
// ============================================================================
//
// Firestore (scope: organizations/{orgId}/...):
//   - localOrganizations      → LocalOrganizationRemoteDto (ESTE ARCHIVO, filtra
//                                notesPrivate, tagsPrivate). Hidratación vía
//                                local_organization_remote_merger.
//   - localContacts           → LocalContactRemoteDto (filtra privados).
//                                Hidratación vía local_contact_remote_merger.
//   - operationalRelationships → OperationalRelationshipEntity.toJson() directo.
//   - operationalRequests      → OperationalRequestEntity.toJson() directo.
//   - requestDeliveries        → RequestDeliveryEntity.toJson() directo.
//   - matchCandidatesCache     → MatchCandidateEntity.toJson() directo
//                                (solo los expuestos al workspace).
//   - platformActorCache       → PlatformActorEntity.toJson() directo
//                                (ver semánticas de cache: stale permitido,
//                                 no decisiones críticas).
//
// NestJS (scope: backend core-api):
//   - POST/GET PlatformActor               → PlatformActorEntity.from/toJson
//   - POST/GET MatchCandidate              → MatchCandidateEntity.from/toJson
//   - POST OperationalRelationshipMirror   → OperationalRelationshipEntity.toJson()
//                                            (backend valida D4:
//                                             state ∈ {vinculada, suspendida, cerrada}).
//   - POST OperationalRequestMirror        → OperationalRequestEntity.toJson()
//                                            (caso de uso del mirror valida D4
//                                             DURA: originChannel == inApp,
//                                             de lo contrario lanza explícitamente).
//
// REGLA GENERAL:
//   - Ningún JSON que viaje a remoto debe contener campos *Private.
//   - Ningún caller puede obtener una Entity persistible SOLO a partir del DTO
//     remoto: la única puerta segura es el merger centralizado.
//   - Cualquier datasource remoto que lea Firestore y hidrate local DEBE pasar
//     por el merger (merge vs hydrate según exista o no el registro local).
// ============================================================================

import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/core_common/local_organization_entity.dart';

part 'local_organization_remote_dto.g.dart';

/// DTO remoto (Firestore) de LocalOrganization.
/// Excluye notesPrivate y tagsPrivate por diseño.
/// NO expone toEntity(): la hidratación pasa por el merger centralizado.
@JsonSerializable(explicitToJson: true)
class LocalOrganizationRemoteDto {
  final String id;
  final String workspaceId;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? legalName;
  final String? taxId;
  final String? primaryPhoneE164;
  final String? primaryEmail;
  final String? website;

  // DELIBERADAMENTE EXCLUIDOS:
  //   - notesPrivate
  //   - tagsPrivate

  final String? snapshotSourcePlatformActorId;
  final DateTime? snapshotAdoptedAt;

  final bool isDeleted;
  final DateTime? deletedAt;

  LocalOrganizationRemoteDto({
    required this.id,
    required this.workspaceId,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.legalName,
    this.taxId,
    this.primaryPhoneE164,
    this.primaryEmail,
    this.website,
    this.snapshotSourcePlatformActorId,
    this.snapshotAdoptedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  /// Crea el DTO desde la Entity. Descarta notesPrivate y tagsPrivate.
  /// Dirección única segura Entity → DTO remoto.
  factory LocalOrganizationRemoteDto.fromEntity(LocalOrganizationEntity e) =>
      LocalOrganizationRemoteDto(
        id: e.id,
        workspaceId: e.workspaceId,
        displayName: e.displayName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        legalName: e.legalName,
        taxId: e.taxId,
        primaryPhoneE164: e.primaryPhoneE164,
        primaryEmail: e.primaryEmail,
        website: e.website,
        snapshotSourcePlatformActorId: e.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: e.snapshotAdoptedAt?.toUtc(),
        isDeleted: e.isDeleted,
        deletedAt: e.deletedAt?.toUtc(),
      );

  factory LocalOrganizationRemoteDto.fromJson(Map<String, dynamic> json) =>
      _$LocalOrganizationRemoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocalOrganizationRemoteDtoToJson(this);
}

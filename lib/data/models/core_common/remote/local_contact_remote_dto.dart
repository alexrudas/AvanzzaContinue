// ============================================================================
// lib/data/models/core_common/remote/local_contact_remote_dto.dart
// LOCAL CONTACT REMOTE DTO — Data Layer / Contrato remoto Firestore
// ============================================================================
// QUÉ HACE:
//   - Forma serializada de LocalContact para persistencia remota en Firestore.
//   - Excluye DELIBERADAMENTE notesPrivate y tagsPrivate.
//   - Expone UNA sola dirección segura: fromEntity(entity) → DTO remoto.
//
// QUÉ NO HACE:
//   - NO reconstruye una Entity "lista para guardar" a partir del DTO remoto.
//     Esa ruta sería peligrosa (perdería privados locales). Por diseño, este
//     DTO NO tiene toEntity().
//   - No sincroniza a NestJS: la red local vive solo en Firestore del workspace
//     + Isar local.
//
// POR QUÉ NO HAY toEntity():
//   - LocalContact contiene campos privados (notesPrivate, tagsPrivate) que
//     viven SOLO en Isar y nunca viajan por la red.
//   - Si existiera toEntity() devolviendo una Entity "válida", un caller
//     ingenuo podría persistirla directamente, PERDIENDO los privados.
//   - Ese riesgo queda cerrado eliminando toEntity() en favor de funciones
//     explícitas en el merger centralizado:
//       · hydrateNewLocalContactFromRemote(remote)
//       · mergeExistingLocalContactWithRemote(remote, existingLocal)
//     Ver: lib/domain/services/core_common/local_contact_remote_merger.dart
//
// CAMPOS EXCLUIDOS POR DISEÑO:
//   - notesPrivate
//   - tagsPrivate
//
// Manifiesto completo del contrato remoto:
//   lib/data/models/core_common/remote/local_organization_remote_dto.dart
// ============================================================================

import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/core_common/local_contact_entity.dart';

part 'local_contact_remote_dto.g.dart';

/// DTO remoto (Firestore) de LocalContact.
/// Excluye notesPrivate y tagsPrivate por diseño.
/// NO expone toEntity(): la hidratación pasa por el merger centralizado.
@JsonSerializable(explicitToJson: true)
class LocalContactRemoteDto {
  final String id;
  final String workspaceId;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? organizationId;
  final String? roleLabel;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final String? docId;

  // DELIBERADAMENTE EXCLUIDOS:
  //   - notesPrivate
  //   - tagsPrivate

  final String? snapshotSourcePlatformActorId;
  final DateTime? snapshotAdoptedAt;

  final bool isDeleted;
  final DateTime? deletedAt;

  LocalContactRemoteDto({
    required this.id,
    required this.workspaceId,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.organizationId,
    this.roleLabel,
    this.primaryPhoneE164,
    this.primaryEmail,
    this.docId,
    this.snapshotSourcePlatformActorId,
    this.snapshotAdoptedAt,
    this.isDeleted = false,
    this.deletedAt,
  });

  /// Crea el DTO desde la Entity. Descarta notesPrivate y tagsPrivate.
  /// Dirección única segura Entity → DTO remoto.
  factory LocalContactRemoteDto.fromEntity(LocalContactEntity e) =>
      LocalContactRemoteDto(
        id: e.id,
        workspaceId: e.workspaceId,
        displayName: e.displayName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        organizationId: e.organizationId,
        roleLabel: e.roleLabel,
        primaryPhoneE164: e.primaryPhoneE164,
        primaryEmail: e.primaryEmail,
        docId: e.docId,
        snapshotSourcePlatformActorId: e.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: e.snapshotAdoptedAt?.toUtc(),
        isDeleted: e.isDeleted,
        deletedAt: e.deletedAt?.toUtc(),
      );

  factory LocalContactRemoteDto.fromJson(Map<String, dynamic> json) =>
      _$LocalContactRemoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocalContactRemoteDtoToJson(this);
}

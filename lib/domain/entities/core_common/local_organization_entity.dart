// ============================================================================
// lib/domain/entities/core_common/local_organization_entity.dart
// LOCAL ORGANIZATION ENTITY — Core Common v1 / Red Local del Workspace
// ============================================================================
// QUÉ HACE:
//   - Representa una organización registrada en la red local del workspace.
//   - SSOT del workspace: el dueño del dato es el workspace, no la plataforma.
//   - Puede existir aunque la organización nunca se registre en Avanzza.
//   - Soporta soft delete (isDeleted + deletedAt).
//
// QUÉ NO HACE:
//   - No representa la organización tenant del SaaS (OrganizationEntity).
//   - No representa un PlatformActor (actor registrado en plataforma).
//   - No persiste por sí misma (LocalOrganizationModel en F3 hará el mapeo).
//   - No sincroniza con plataforma: los campos privados nunca viajan.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - Campos *Private (notesPrivate, tagsPrivate) NUNCA se sincronizan.
//   - snapshotSourcePlatformActorId + snapshotAdoptedAt marcan adopción manual
//     por campo desde un PlatformActor; no crean suscripción.
//   - Soft delete: isDeleted=true + deletedAt=<ts> = registro archivado.
//     El flujo operativo NO borra físicamente; el repo expone delete como soft.
//     Las queries operativas excluyen soft-deleted por default.
//
// ENTERPRISE NOTES:
//   - workspaceId ≡ orgId del tenant SaaS. Partition key de la red local.
//   - taxId se almacena normalizado (NIT sin dígito de verificación, sin puntuación).
//   - primaryPhoneE164 es la llave candidata principal para el matcher.
//   - Ningún campo de esta entidad escribe sobre el PlatformActor correspondiente.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_organization_entity.freezed.dart';
part 'local_organization_entity.g.dart';

/// Organización registrada en la red local de un workspace.
/// SSOT: workspace. Independiente del posible PlatformActor correspondiente.
@freezed
abstract class LocalOrganizationEntity with _$LocalOrganizationEntity {
  const factory LocalOrganizationEntity({
    required String id,

    /// Partition key. Workspace dueño del registro local.
    required String workspaceId,

    /// Nombre usado en la UI del workspace. Puede diferir de legalName.
    required String displayName,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// Razón social legal si se conoce.
    String? legalName,

    /// NIT normalizado sin dígito de verificación ni puntuación. Sin verificación local.
    String? taxId,

    /// Teléfono normalizado a E.164. Llave candidata principal para matching.
    String? primaryPhoneE164,

    /// Email de contacto. Llave candidata secundaria.
    String? primaryEmail,

    /// Sitio web corporativo si aplica.
    String? website,

    /// Nota privada del workspace. NUNCA se sincroniza ni se expone.
    String? notesPrivate,

    /// Tags privadas del workspace. NUNCA se sincronizan.
    @Default(<String>[]) List<String> tagsPrivate,

    /// Si existe, indica que uno o más campos fueron adoptados desde un
    /// PlatformActor concreto (referencia trazable, no suscripción).
    String? snapshotSourcePlatformActorId,

    /// Timestamp del último evento de adopción de campos desde plataforma.
    DateTime? snapshotAdoptedAt,

    /// Soft delete flag. true = registro archivado.
    /// Las queries operativas del repositorio excluyen isDeleted=true por default.
    @Default(false) bool isDeleted,

    /// Timestamp del soft-delete. Null mientras isDeleted=false.
    DateTime? deletedAt,
  }) = _LocalOrganizationEntity;

  factory LocalOrganizationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalOrganizationEntityFromJson(json);
}

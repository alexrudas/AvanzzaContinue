// ============================================================================
// lib/domain/entities/core_common/local_contact_entity.dart
// LOCAL CONTACT ENTITY — Core Common v1 / Red Local del Workspace
// ============================================================================
// QUÉ HACE:
//   - Representa un contacto operativo persona en la red local del workspace.
//   - Puede pertenecer a una LocalOrganization (1:N) o ser independiente.
//   - SSOT del workspace.
//   - Soporta soft delete (isDeleted + deletedAt).
//
// QUÉ NO HACE:
//   - No representa un User (identidad de autenticación).
//   - No representa un PlatformActor (identidad operativa en plataforma).
//   - No lleva atributos específicos por rol (licencias, matrículas, etc.):
//     esos son extensiones futuras, no Core Common.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - organizationId es nullable: soporta contacto suelto.
//   - Campos *Private nunca se sincronizan.
//   - roleLabel es texto libre; NO es semántica de módulo vertical.
//   - Soft delete: isDeleted=true + deletedAt=<ts> = registro archivado.
//     El flujo operativo NO borra físicamente; el repo expone delete como soft.
//
// ENTERPRISE NOTES:
//   - workspaceId ≡ orgId del tenant SaaS.
//   - primaryPhoneE164 es la llave candidata principal de una persona.
//   - docId es cédula o equivalente normalizado (sin puntos, sin guiones).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_contact_entity.freezed.dart';
part 'local_contact_entity.g.dart';

/// Contacto persona registrado en la red local de un workspace.
/// SSOT: workspace. Puede o no pertenecer a una LocalOrganization.
@freezed
abstract class LocalContactEntity with _$LocalContactEntity {
  const factory LocalContactEntity({
    required String id,

    /// Partition key. Workspace dueño del registro local.
    required String workspaceId,

    /// Nombre mostrado en la UI del workspace.
    required String displayName,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// FK opcional a LocalOrganization del mismo workspace.
    /// Null = contacto suelto (ej. conductor persona, técnico freelance).
    String? organizationId,

    /// Etiqueta libre del rol en el workspace ("vendedor", "conductor",
    /// "técnico"). Sin semántica vertical: solo anotación local.
    String? roleLabel,

    /// Teléfono normalizado a E.164. Llave candidata principal.
    String? primaryPhoneE164,

    /// Email de contacto. Llave candidata secundaria.
    String? primaryEmail,

    /// Documento de identidad normalizado. Llave candidata secundaria.
    String? docId,

    /// Nota privada del workspace. NUNCA se sincroniza.
    String? notesPrivate,

    /// Tags privadas del workspace. NUNCA se sincronizan.
    @Default(<String>[]) List<String> tagsPrivate,

    /// PlatformActor origen de adopciones manuales de campo (si aplica).
    String? snapshotSourcePlatformActorId,

    /// Timestamp de la última adopción.
    DateTime? snapshotAdoptedAt,

    /// Soft delete flag. true = registro archivado.
    /// Las queries operativas del repositorio excluyen isDeleted=true por default.
    @Default(false) bool isDeleted,

    /// Timestamp del soft-delete. Null mientras isDeleted=false.
    DateTime? deletedAt,
  }) = _LocalContactEntity;

  factory LocalContactEntity.fromJson(Map<String, dynamic> json) =>
      _$LocalContactEntityFromJson(json);
}

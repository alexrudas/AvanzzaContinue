// ============================================================================
// lib/domain/services/core_common/local_contact_remote_merger.dart
// LOCAL CONTACT REMOTE MERGER — Core Common v1 / Hidratación segura
// ============================================================================
// QUÉ HACE:
//   - Única puerta pública de reconstrucción de LocalContactEntity desde un
//     DTO remoto (LocalContactRemoteDto).
//   - Ofrece DOS rutas explícitas, nunca un "toEntity()" ambiguo:
//       1. hydrateNewLocalContactFromRemote(remote)
//          → crea una Entity nueva, privados vacíos por construcción.
//       2. mergeExistingLocalContactWithRemote(remote, existingLocal)
//          → fusiona preservando notesPrivate y tagsPrivate del local.
//
// QUÉ NO HACE (GUARDRAIL DURO — NO NEGOCIABLE):
//   Este merger es TRANSFORMACIÓN PURA DE DATOS. Prohibido agregar:
//     - I/O de cualquier tipo
//     - acceso a repositorios
//     - acceso a Isar
//     - acceso a Firestore
//     - acceso a HTTP / NestJS / REST
//     - uso de syncService, outbox o colas de mensajes
//     - decisiones de persistencia (upsert, save, delete)
//     - lógica de "buscar si existe" el registro local
//     - efectos colaterales (logs persistentes, telemetría, notificaciones)
//     - dependencias de ambiente (DateTime.now, Random, SharedPreferences, etc.)
//   Si surge la tentación de convertir este archivo en un datasource
//   disfrazado: DETENERSE. Crear un datasource/caso de uso explícito en
//   la capa correspondiente (data/sources, application/use_cases) y dejar
//   que ESE invoque a este merger como función pura.
//
// ALCANCE PERMITIDO (exhaustivo):
//   - hydrateNewLocalContactFromRemote(remote)
//   - mergeExistingLocalContactWithRemote(remote, existingLocal)
//   - validaciones puras mínimas de compatibilidad (id, workspaceId)
//     expresadas como ArgumentError síncrono.
//   - Ninguna otra función pública, ningún estado, ningún servicio.
//
// PRINCIPIOS:
//   - Dominio puro. Ruta única de hidratación.
//   - mergeExisting exige id y workspaceId consistentes: ArgumentError si no.
//
// ENTERPRISE NOTES:
//   - Cierra el riesgo reportado tras F3.a de una ruta implícita desde DTO
//     remoto a Entity persistible que pisara privados locales.
//   - Cualquier extensión futura (restauración de backup, reconciliación
//     bidireccional, etc.) debe documentarse explícitamente aquí y mantener
//     el guardrail duro.
// ============================================================================

import '../../../data/models/core_common/remote/local_contact_remote_dto.dart';
import '../../entities/core_common/local_contact_entity.dart';

/// Crea una [LocalContactEntity] NUEVA a partir de un DTO remoto.
/// notesPrivate=null y tagsPrivate=[] por construcción explícita.
/// Usar solo cuando el caller confirmó que no existe registro local previo.
LocalContactEntity hydrateNewLocalContactFromRemote(
  LocalContactRemoteDto remote,
) {
  return LocalContactEntity(
    id: remote.id,
    workspaceId: remote.workspaceId,
    displayName: remote.displayName,
    createdAt: remote.createdAt,
    updatedAt: remote.updatedAt,
    organizationId: remote.organizationId,
    roleLabel: remote.roleLabel,
    primaryPhoneE164: remote.primaryPhoneE164,
    primaryEmail: remote.primaryEmail,
    docId: remote.docId,
    notesPrivate: null,
    tagsPrivate: const <String>[],
    snapshotSourcePlatformActorId: remote.snapshotSourcePlatformActorId,
    snapshotAdoptedAt: remote.snapshotAdoptedAt,
    isDeleted: remote.isDeleted,
    deletedAt: remote.deletedAt,
  );
}

/// Fusiona un DTO remoto con un [existingLocal] preservando los privados.
///
/// Invariantes:
///   - remote.id == existingLocal.id
///   - remote.workspaceId == existingLocal.workspaceId
LocalContactEntity mergeExistingLocalContactWithRemote({
  required LocalContactRemoteDto remote,
  required LocalContactEntity existingLocal,
}) {
  if (remote.id != existingLocal.id) {
    throw ArgumentError(
      'mergeExistingLocalContactWithRemote: id mismatch '
      '(remote=${remote.id}, local=${existingLocal.id})',
    );
  }
  if (remote.workspaceId != existingLocal.workspaceId) {
    throw ArgumentError(
      'mergeExistingLocalContactWithRemote: workspaceId mismatch '
      '(remote=${remote.workspaceId}, local=${existingLocal.workspaceId})',
    );
  }

  return LocalContactEntity(
    id: remote.id,
    workspaceId: remote.workspaceId,
    displayName: remote.displayName,
    createdAt: remote.createdAt,
    updatedAt: remote.updatedAt,
    organizationId: remote.organizationId,
    roleLabel: remote.roleLabel,
    primaryPhoneE164: remote.primaryPhoneE164,
    primaryEmail: remote.primaryEmail,
    docId: remote.docId,
    // PRIVADOS: preservados del registro local.
    notesPrivate: existingLocal.notesPrivate,
    tagsPrivate: existingLocal.tagsPrivate,
    snapshotSourcePlatformActorId: remote.snapshotSourcePlatformActorId,
    snapshotAdoptedAt: remote.snapshotAdoptedAt,
    isDeleted: remote.isDeleted,
    deletedAt: remote.deletedAt,
  );
}

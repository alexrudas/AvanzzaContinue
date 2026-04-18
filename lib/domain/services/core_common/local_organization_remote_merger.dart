// ============================================================================
// lib/domain/services/core_common/local_organization_remote_merger.dart
// LOCAL ORGANIZATION REMOTE MERGER — Core Common v1 / Hidratación segura
// ============================================================================
// QUÉ HACE:
//   - Única puerta pública de reconstrucción de LocalOrganizationEntity a
//     partir de un DTO remoto (LocalOrganizationRemoteDto).
//   - Ofrece DOS rutas explícitas, NUNCA un "toEntity()" ambiguo:
//       1. hydrateNewLocalOrganizationFromRemote(remote)
//          → crea una Entity nueva (primera sincronización local del registro).
//            notesPrivate=null, tagsPrivate=[] por construcción explícita.
//       2. mergeExistingLocalOrganizationWithRemote(remote, existingLocal)
//          → fusiona el DTO remoto con el registro local ya existente,
//            PRESERVANDO notesPrivate y tagsPrivate del local.
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
//   - hydrateNewLocalOrganizationFromRemote(remote)
//   - mergeExistingLocalOrganizationWithRemote(remote, existingLocal)
//   - validaciones puras mínimas de compatibilidad (id, workspaceId)
//     expresadas como ArgumentError síncrono.
//   - Ninguna otra función pública, ningún estado, ningún servicio.
//
// PRINCIPIOS:
//   - Dominio puro: solo imports de la Entity local y del DTO remoto.
//   - Ruta única de hidratación: cualquier código que obtenga una Entity a
//     partir del DTO remoto DEBE pasar por este merger. El DTO no expone
//     toEntity() para forzar esta disciplina.
//   - mergeExisting exige ids y workspaceId consistentes: lanza ArgumentError
//     si no coinciden. La preservación de privados nunca debe ocurrir contra
//     el registro equivocado.
//
// ENTERPRISE NOTES:
//   - Este archivo cierra el riesgo reportado tras F3.a: evita una ruta
//     implícita desde DTO remoto a Entity persistible que pudiera pisar
//     privados locales.
//   - Si más adelante aparece una tercera ruta (por ejemplo restauración de
//     backup), debe documentarse aquí como función explícita con nombre propio
//     y seguir respetando el guardrail duro.
// ============================================================================

import '../../../data/models/core_common/remote/local_organization_remote_dto.dart';
import '../../entities/core_common/local_organization_entity.dart';

/// Crea una [LocalOrganizationEntity] NUEVA a partir de un DTO remoto.
///
/// Uso: primera sincronización local de un registro que no existe todavía en
/// Isar (el caller validó la ausencia antes).
///
/// notesPrivate y tagsPrivate se setean vacíos EXPLÍCITAMENTE. El caller debe
/// entender que esta Entity NO contiene privados y que si ya existía un
/// registro local previo, perdería sus privados — por eso debe usar
/// [mergeExistingLocalOrganizationWithRemote] en ese caso.
LocalOrganizationEntity hydrateNewLocalOrganizationFromRemote(
  LocalOrganizationRemoteDto remote,
) {
  return LocalOrganizationEntity(
    id: remote.id,
    workspaceId: remote.workspaceId,
    displayName: remote.displayName,
    createdAt: remote.createdAt,
    updatedAt: remote.updatedAt,
    legalName: remote.legalName,
    taxId: remote.taxId,
    primaryPhoneE164: remote.primaryPhoneE164,
    primaryEmail: remote.primaryEmail,
    website: remote.website,
    notesPrivate: null,
    tagsPrivate: const <String>[],
    snapshotSourcePlatformActorId: remote.snapshotSourcePlatformActorId,
    snapshotAdoptedAt: remote.snapshotAdoptedAt,
    isDeleted: remote.isDeleted,
    deletedAt: remote.deletedAt,
  );
}

/// Fusiona un DTO remoto con un [existingLocal] preservando los privados del
/// registro local (notesPrivate, tagsPrivate).
///
/// Campos públicos provienen del remoto (autoridad de sincronización).
/// Campos privados se copian del [existingLocal] sin modificación.
///
/// Invariantes (lanzan ArgumentError si violadas):
///   - remote.id == existingLocal.id
///   - remote.workspaceId == existingLocal.workspaceId
LocalOrganizationEntity mergeExistingLocalOrganizationWithRemote({
  required LocalOrganizationRemoteDto remote,
  required LocalOrganizationEntity existingLocal,
}) {
  if (remote.id != existingLocal.id) {
    throw ArgumentError(
      'mergeExistingLocalOrganizationWithRemote: id mismatch '
      '(remote=${remote.id}, local=${existingLocal.id})',
    );
  }
  if (remote.workspaceId != existingLocal.workspaceId) {
    throw ArgumentError(
      'mergeExistingLocalOrganizationWithRemote: workspaceId mismatch '
      '(remote=${remote.workspaceId}, local=${existingLocal.workspaceId})',
    );
  }

  return LocalOrganizationEntity(
    id: remote.id,
    workspaceId: remote.workspaceId,
    displayName: remote.displayName,
    createdAt: remote.createdAt,
    updatedAt: remote.updatedAt,
    legalName: remote.legalName,
    taxId: remote.taxId,
    primaryPhoneE164: remote.primaryPhoneE164,
    primaryEmail: remote.primaryEmail,
    website: remote.website,
    // PRIVADOS: preservados del registro local.
    notesPrivate: existingLocal.notesPrivate,
    tagsPrivate: existingLocal.tagsPrivate,
    snapshotSourcePlatformActorId: remote.snapshotSourcePlatformActorId,
    snapshotAdoptedAt: remote.snapshotAdoptedAt,
    isDeleted: remote.isDeleted,
    deletedAt: remote.deletedAt,
  );
}

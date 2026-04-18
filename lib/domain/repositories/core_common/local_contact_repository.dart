// ============================================================================
// lib/domain/repositories/core_common/local_contact_repository.dart
// LOCAL CONTACT REPOSITORY — Core Common v1 / Contrato
// ============================================================================
// Qué hace:
//   - Define el contrato de persistencia y consulta de LocalContact.
//   - Soporta pertenencia opcional a LocalOrganization (1:N).
//   - Expone deleteById con semántica de SOFT DELETE.
//
// Qué NO hace:
//   - No implementa nada: contrato de dominio puro.
//   - No crea/elimina en cascada desde LocalOrganization: reasignar organizationId
//     es responsabilidad de un caso de uso, no del repo.
//   - No sincroniza con PlatformActor.
//
// Principios:
//   - Offline-first por contrato.
//   - Scoped por workspaceId.
//   - Queries por llave útiles para matching y detección de duplicados.
//   - NO-DIRECTORIO BY DESIGN: ningún método permite descubrir contactos fuera
//     del grafo del workspace. Las queries por llave solo encuentran registros
//     locales del propio workspace.
//
// Soft delete (semántica v1):
//   - deleteById NO elimina físicamente: marca isDeleted=true + deletedAt=now.
//   - Todas las queries EXCLUYEN soft-deleted por default. Restaurar = save()
//     con isDeleted=false.
//   - Eliminación física reservada a procesos de mantenimiento separados.
//
// Enterprise Notes:
//   - LocalContact puede tener organizationId=null (contacto suelto).
//   - docId se almacena normalizado (sin puntos ni guiones).
//   - deleteById no propaga en cascada a Relationships/Requests asociadas.
// ============================================================================

import '../../entities/core_common/local_contact_entity.dart';

/// Contrato de persistencia y consulta de LocalContact.
/// Scoped por workspaceId (tenant SaaS). Soft-delete by default.
abstract class LocalContactRepository {
  /// Crea o actualiza un LocalContact (write-through).
  /// Para restaurar un registro soft-deleted, se invoca con isDeleted=false.
  Future<void> save(LocalContactEntity contact);

  /// Soft delete: marca isDeleted=true y deletedAt=now.
  /// No borra físicamente. No propaga a Relationships/Requests asociadas.
  Future<void> deleteById(String id);

  /// Retorna la entidad por id o null si no existe.
  /// Incluye registros soft-deleted: el consumidor decide si filtrar.
  Future<LocalContactEntity?> getById(String id);

  /// Stream reactivo por id. Emite null si deja de existir.
  /// Incluye registros soft-deleted.
  Stream<LocalContactEntity?> watchById(String id);

  /// Lista del workspace excluyendo soft-deleted.
  Future<List<LocalContactEntity>> listByWorkspace(String workspaceId);

  /// Stream reactivo de la red local. Excluye soft-deleted.
  Stream<List<LocalContactEntity>> watchByWorkspace(String workspaceId);

  /// Lista los contactos asociados a una LocalOrganization específica.
  /// Si [organizationId] es null, retorna contactos sueltos. Excluye soft-deleted.
  Future<List<LocalContactEntity>> listByOrganization(
    String workspaceId,
    String? organizationId,
  );

  /// Stream reactivo de contactos asociados a una LocalOrganization.
  /// Excluye soft-deleted.
  Stream<List<LocalContactEntity>> watchByOrganization(
    String workspaceId,
    String? organizationId,
  );

  /// Busca contactos cuyo primaryPhoneE164 coincida exactamente.
  /// Excluye soft-deleted. Scope: solo registros locales del workspace.
  Future<List<LocalContactEntity>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  );

  /// Busca contactos cuyo primaryEmail coincida exactamente.
  /// Excluye soft-deleted. Scope: solo registros locales del workspace.
  Future<List<LocalContactEntity>> findByEmail(
    String workspaceId,
    String emailNormalized,
  );

  /// Busca contactos cuyo docId coincida exactamente (normalizado).
  /// Excluye soft-deleted. Scope: solo registros locales del workspace.
  Future<List<LocalContactEntity>> findByDocId(
    String workspaceId,
    String docIdNormalized,
  );
}

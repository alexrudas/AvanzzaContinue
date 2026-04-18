// ============================================================================
// lib/domain/repositories/core_common/local_organization_repository.dart
// LOCAL ORGANIZATION REPOSITORY — Core Common v1 / Contrato
// ============================================================================
// Qué hace:
//   - Define el contrato de persistencia y consulta de LocalOrganization.
//   - Abstrae la fuente (Isar local + Firestore scoped al workspace).
//   - Expone deleteById con semántica de SOFT DELETE (ver abajo).
//
// Qué NO hace:
//   - No implementa nada: es contrato de dominio puro.
//   - No sincroniza con PlatformActor: la adopción manual por campo es caso de uso.
//   - No realiza matching: eso es MatchCandidateRepository.
//   - No filtra notas ni tags al exponer: la filtración fuera de workspace es
//     responsabilidad del mapper remoto (*Private nunca viaja).
//
// Principios:
//   - Offline-first por contrato: reads van a local primero; writes van a local
//     y se encolan para remoto (implementación, no interfaz).
//   - Todas las queries por workspaceId están particionadas por tenant SaaS.
//   - Las queries por llave (phone, taxId) son útiles para detectar duplicados
//     locales y para el hook D8 de colisiones.
//   - NO-DIRECTORIO BY DESIGN: ningún método permite descubrir organizaciones
//     fuera del grafo ya referenciado por el workspace. Las queries por llave
//     solo encuentran registros locales del propio workspace.
//
// Soft delete (semántica v1):
//   - deleteById NO elimina físicamente: marca isDeleted=true + deletedAt=now.
//   - Todas las queries de esta interfaz EXCLUYEN registros con isDeleted=true
//     por default. Para restaurar, el llamador invoca save() con isDeleted=false.
//   - Eliminación física restringida a procesos de mantenimiento separados.
//     El flujo operativo usa soft delete.
//
// Enterprise Notes:
//   - workspaceId ≡ orgId del tenant SaaS.
//   - El repo NO decide visibilidad cross-workspace: la red local es privada.
//   - deleteById no propaga en cascada: Relationships/Requests asociadas deben
//     cerrarse o reasignarse explícitamente por el caso de uso antes.
// ============================================================================

import '../../entities/core_common/local_organization_entity.dart';

/// Contrato de persistencia y consulta de LocalOrganization.
/// Scoped por workspaceId (tenant SaaS). Soft-delete by default.
abstract class LocalOrganizationRepository {
  /// Crea o actualiza una LocalOrganization (write-through).
  /// Para restaurar un registro soft-deleted, se invoca con isDeleted=false.
  Future<void> save(LocalOrganizationEntity organization);

  /// Soft delete: marca isDeleted=true y deletedAt=now.
  /// No borra físicamente. No propaga a Relationships/Requests asociadas.
  Future<void> deleteById(String id);

  /// Retorna la entidad por id o null si no existe.
  /// Incluye registros soft-deleted: el consumidor decide si filtrar.
  Future<LocalOrganizationEntity?> getById(String id);

  /// Stream reactivo de una organización local por id.
  /// Emite null si deja de existir. Incluye registros soft-deleted.
  Stream<LocalOrganizationEntity?> watchById(String id);

  /// Lista del workspace excluyendo soft-deleted (vista operativa).
  Future<List<LocalOrganizationEntity>> listByWorkspace(String workspaceId);

  /// Stream reactivo de la red local. Excluye soft-deleted.
  Stream<List<LocalOrganizationEntity>> watchByWorkspace(String workspaceId);

  /// Busca organizaciones cuyo primaryPhoneE164 coincida exactamente.
  /// Excluye soft-deleted. Scope: solo registros locales del workspace.
  Future<List<LocalOrganizationEntity>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  );

  /// Busca organizaciones cuyo taxId coincida exactamente (NIT sin DV).
  /// Excluye soft-deleted. Scope: solo registros locales del workspace.
  Future<List<LocalOrganizationEntity>> findByTaxId(
    String workspaceId,
    String taxIdNormalized,
  );

  /// Busca por primaryEmail exacto (normalizado, lowercase).
  /// Excluye soft-deleted. Scope: solo registros locales del workspace.
  Future<List<LocalOrganizationEntity>> findByEmail(
    String workspaceId,
    String emailNormalized,
  );
}

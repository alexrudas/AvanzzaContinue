// ============================================================================
// lib/data/sources/local/core_common/local_organization_local_ds.dart
// LOCAL ORGANIZATION LOCAL DS — Data Layer / Sources / Local (F3.b)
// ============================================================================
// QUÉ HACE:
//   - Acceso a LocalOrganizationModel en Isar (CRUD + queries por llave).
//   - Soft delete operativo: deleteById marca isDeleted=true + deletedAt=now.
//   - Queries de lista/stream/find EXCLUYEN soft-deleted por default.
//   - getById y watchById NO filtran soft-deleted (el caller decide).
//
// QUÉ NO HACE:
//   - No mapea a Entity (el repositorio hace Entity ↔ Model en F3.c).
//   - No accede a Firestore ni NestJS.
//   - No orquesta merges con remoto (eso vive en el merger + datasource remoto).
//   - No valida lógica de negocio.
//
// PRINCIPIOS:
//   - Read-modify-write atómico: upsert y softDelete encapsulan dentro de
//     writeTxn para evitar carreras con otras writeTxn concurrentes.
//   - Todas las queries operativas filtran isDeletedEqualTo(false) por diseño.
//   - Timestamps persistidos en UTC (consistente con el resto del módulo).
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/core_common/local_organization_model.dart';

class LocalOrganizationLocalDataSource {
  final Isar _isar;

  LocalOrganizationLocalDataSource(this._isar);

  /// Retorna por id (incluye soft-deleted — el consumer decide).
  Future<LocalOrganizationModel?> getById(String id) async {
    return _isar.localOrganizationModels
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  /// Stream por id (incluye soft-deleted).
  Stream<LocalOrganizationModel?> watchById(String id) {
    return _isar.localOrganizationModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  /// Crea o actualiza. Preserva isarId y createdAt del registro previo si existe.
  Future<LocalOrganizationModel> upsert(LocalOrganizationModel model) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.localOrganizationModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = LocalOrganizationModel(
        isarId: existing?.isarId,
        id: model.id,
        workspaceId: model.workspaceId,
        displayName: model.displayName,
        createdAt: existing?.createdAt ?? model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        legalName: model.legalName,
        taxId: model.taxId,
        primaryPhoneE164: model.primaryPhoneE164,
        primaryEmail: model.primaryEmail,
        website: model.website,
        notesPrivate: model.notesPrivate,
        tagsPrivate: model.tagsPrivate,
        snapshotSourcePlatformActorId: model.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: model.snapshotAdoptedAt?.toUtc(),
        isDeleted: model.isDeleted,
        deletedAt: model.deletedAt?.toUtc(),
      );

      await _isar.localOrganizationModels.put(toSave);
      return toSave;
    });
  }

  /// Soft delete: marca isDeleted=true y deletedAt=now. No borra físicamente.
  Future<void> softDeleteById(String id, DateTime now) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.localOrganizationModels
          .filter()
          .idEqualTo(id)
          .findFirst();
      if (existing == null) return;
      if (existing.isDeleted) return; // idempotencia: ya estaba soft-deleted.

      final updated = LocalOrganizationModel(
        isarId: existing.isarId,
        id: existing.id,
        workspaceId: existing.workspaceId,
        displayName: existing.displayName,
        createdAt: existing.createdAt,
        updatedAt: now.toUtc(),
        legalName: existing.legalName,
        taxId: existing.taxId,
        primaryPhoneE164: existing.primaryPhoneE164,
        primaryEmail: existing.primaryEmail,
        website: existing.website,
        notesPrivate: existing.notesPrivate,
        tagsPrivate: existing.tagsPrivate,
        snapshotSourcePlatformActorId: existing.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: existing.snapshotAdoptedAt,
        isDeleted: true,
        deletedAt: now.toUtc(),
      );
      await _isar.localOrganizationModels.put(updated);
    });
  }

  /// Lista operativa del workspace: excluye soft-deleted.
  Future<List<LocalOrganizationModel>> listByWorkspace(
    String workspaceId,
  ) async {
    return _isar.localOrganizationModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Stream operativo del workspace: excluye soft-deleted.
  Stream<List<LocalOrganizationModel>> watchByWorkspace(
    String workspaceId,
  ) {
    return _isar.localOrganizationModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true);
  }

  /// Busca por primaryPhoneE164 exacto dentro del workspace; excluye soft-deleted.
  Future<List<LocalOrganizationModel>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  ) async {
    return _isar.localOrganizationModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .primaryPhoneE164EqualTo(phoneE164Normalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Busca por taxId exacto dentro del workspace; excluye soft-deleted.
  Future<List<LocalOrganizationModel>> findByTaxId(
    String workspaceId,
    String taxIdNormalized,
  ) async {
    return _isar.localOrganizationModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .taxIdEqualTo(taxIdNormalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Busca por primaryEmail exacto dentro del workspace; excluye soft-deleted.
  Future<List<LocalOrganizationModel>> findByEmail(
    String workspaceId,
    String emailNormalized,
  ) async {
    return _isar.localOrganizationModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .primaryEmailEqualTo(emailNormalized)
        .isDeletedEqualTo(false)
        .findAll();
  }
}

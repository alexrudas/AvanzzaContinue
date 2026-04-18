// ============================================================================
// lib/data/sources/local/core_common/local_contact_local_ds.dart
// LOCAL CONTACT LOCAL DS — Data Layer / Sources / Local (F3.b)
// ============================================================================
// QUÉ HACE:
//   - Acceso a LocalContactModel en Isar.
//   - Soft delete operativo. Queries operativas excluyen soft-deleted.
//
// QUÉ NO HACE:
//   - No mapea a Entity (repo en F3.c).
//   - No accede a remoto.
//
// PRINCIPIOS:
//   - writeTxn atómico para upsert/softDelete.
//   - UTC en timestamps persistidos.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/core_common/local_contact_model.dart';

class LocalContactLocalDataSource {
  final Isar _isar;

  LocalContactLocalDataSource(this._isar);

  Future<LocalContactModel?> getById(String id) async {
    return _isar.localContactModels.filter().idEqualTo(id).findFirst();
  }

  Stream<LocalContactModel?> watchById(String id) {
    return _isar.localContactModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<LocalContactModel> upsert(LocalContactModel model) async {
    return _isar.writeTxn(() async {
      final existing = await _isar.localContactModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final toSave = LocalContactModel(
        isarId: existing?.isarId,
        id: model.id,
        workspaceId: model.workspaceId,
        displayName: model.displayName,
        createdAt: existing?.createdAt ?? model.createdAt.toUtc(),
        updatedAt: model.updatedAt.toUtc(),
        organizationId: model.organizationId,
        roleLabel: model.roleLabel,
        primaryPhoneE164: model.primaryPhoneE164,
        primaryEmail: model.primaryEmail,
        docId: model.docId,
        notesPrivate: model.notesPrivate,
        tagsPrivate: model.tagsPrivate,
        snapshotSourcePlatformActorId: model.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: model.snapshotAdoptedAt?.toUtc(),
        isDeleted: model.isDeleted,
        deletedAt: model.deletedAt?.toUtc(),
      );

      await _isar.localContactModels.put(toSave);
      return toSave;
    });
  }

  Future<void> softDeleteById(String id, DateTime now) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.localContactModels
          .filter()
          .idEqualTo(id)
          .findFirst();
      if (existing == null) return;
      if (existing.isDeleted) return;

      final updated = LocalContactModel(
        isarId: existing.isarId,
        id: existing.id,
        workspaceId: existing.workspaceId,
        displayName: existing.displayName,
        createdAt: existing.createdAt,
        updatedAt: now.toUtc(),
        organizationId: existing.organizationId,
        roleLabel: existing.roleLabel,
        primaryPhoneE164: existing.primaryPhoneE164,
        primaryEmail: existing.primaryEmail,
        docId: existing.docId,
        notesPrivate: existing.notesPrivate,
        tagsPrivate: existing.tagsPrivate,
        snapshotSourcePlatformActorId: existing.snapshotSourcePlatformActorId,
        snapshotAdoptedAt: existing.snapshotAdoptedAt,
        isDeleted: true,
        deletedAt: now.toUtc(),
      );
      await _isar.localContactModels.put(updated);
    });
  }

  Future<List<LocalContactModel>> listByWorkspace(String workspaceId) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Stream<List<LocalContactModel>> watchByWorkspace(String workspaceId) {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true);
  }

  /// organizationId null = contactos sueltos.
  Future<List<LocalContactModel>> listByOrganization(
    String workspaceId,
    String? organizationId,
  ) async {
    final base = _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false);
    if (organizationId == null) {
      return base.organizationIdIsNull().findAll();
    }
    return base.organizationIdEqualTo(organizationId).findAll();
  }

  Stream<List<LocalContactModel>> watchByOrganization(
    String workspaceId,
    String? organizationId,
  ) {
    final base = _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .isDeletedEqualTo(false);
    if (organizationId == null) {
      return base.organizationIdIsNull().watch(fireImmediately: true);
    }
    return base
        .organizationIdEqualTo(organizationId)
        .watch(fireImmediately: true);
  }

  Future<List<LocalContactModel>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .primaryPhoneE164EqualTo(phoneE164Normalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Future<List<LocalContactModel>> findByEmail(
    String workspaceId,
    String emailNormalized,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .primaryEmailEqualTo(emailNormalized)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Future<List<LocalContactModel>> findByDocId(
    String workspaceId,
    String docIdNormalized,
  ) async {
    return _isar.localContactModels
        .filter()
        .workspaceIdEqualTo(workspaceId)
        .docIdEqualTo(docIdNormalized)
        .isDeletedEqualTo(false)
        .findAll();
  }
}

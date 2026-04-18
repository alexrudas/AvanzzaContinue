// ============================================================================
// lib/data/repositories/core_common/local_contact_repository_impl.dart
// LOCAL CONTACT REPOSITORY IMPL — Data Layer / Repositories (F3.c)
// ============================================================================
// QUÉ HACE:
//   - Implementa LocalContactRepository (F1.c endurecido).
//   - Local-first + enqueue a Firestore.
//   - deleteById = soft delete.
//
// QUÉ NO HACE:
//   - No D4, no state machines, no matching.
// ============================================================================

import '../../../core/platform/offline_sync_service.dart';
import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../models/core_common/local_contact_model.dart';
import '../../models/core_common/remote/local_contact_remote_dto.dart';
import '../../sources/local/core_common/local_contact_local_ds.dart';
import '../../sources/remote/core_common/local_contact_firestore_ds.dart';

class LocalContactRepositoryImpl implements LocalContactRepository {
  final LocalContactLocalDataSource _local;
  final LocalContactFirestoreDataSource _remote;
  final OfflineSyncService _sync;

  LocalContactRepositoryImpl({
    required LocalContactLocalDataSource local,
    required LocalContactFirestoreDataSource remote,
    required OfflineSyncService sync,
  })  : _local = local,
        _remote = remote,
        _sync = sync;

  @override
  Future<void> save(LocalContactEntity contact) async {
    final model = LocalContactModel.fromEntity(contact);
    await _local.upsert(model);
    final dto = LocalContactRemoteDto.fromEntity(contact);
    _sync.enqueue(() => _remote.save(contact.workspaceId, dto));
  }

  @override
  Future<void> deleteById(String id) async {
    final existing = await _local.getById(id);
    if (existing == null) return;
    final now = DateTime.now().toUtc();
    await _local.softDeleteById(id, now);
    _sync.enqueue(() => _remote.softDelete(existing.workspaceId, id, now));
  }

  @override
  Future<LocalContactEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Stream<LocalContactEntity?> watchById(String id) {
    return _local.watchById(id).map((m) => m?.toEntity());
  }

  @override
  Future<List<LocalContactEntity>> listByWorkspace(String workspaceId) async {
    final models = await _local.listByWorkspace(workspaceId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<LocalContactEntity>> watchByWorkspace(String workspaceId) {
    return _local
        .watchByWorkspace(workspaceId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<LocalContactEntity>> listByOrganization(
    String workspaceId,
    String? organizationId,
  ) async {
    final models = await _local.listByOrganization(workspaceId, organizationId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<LocalContactEntity>> watchByOrganization(
    String workspaceId,
    String? organizationId,
  ) {
    return _local
        .watchByOrganization(workspaceId, organizationId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<LocalContactEntity>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  ) async {
    final models =
        await _local.findByPhoneE164(workspaceId, phoneE164Normalized);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<LocalContactEntity>> findByEmail(
    String workspaceId,
    String emailNormalized,
  ) async {
    final models = await _local.findByEmail(workspaceId, emailNormalized);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<LocalContactEntity>> findByDocId(
    String workspaceId,
    String docIdNormalized,
  ) async {
    final models = await _local.findByDocId(workspaceId, docIdNormalized);
    return models.map((m) => m.toEntity()).toList();
  }
}

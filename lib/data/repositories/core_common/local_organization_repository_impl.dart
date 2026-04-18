// ============================================================================
// lib/data/repositories/core_common/local_organization_repository_impl.dart
// LOCAL ORGANIZATION REPOSITORY IMPL — Data Layer / Repositories (F3.c)
// ============================================================================
// QUÉ HACE:
//   - Implementa LocalOrganizationRepository (F1.c endurecido).
//   - Local-first: escribe Isar inmediatamente y encola acción remota
//     nombrada en syncService.
//   - deleteById = soft delete (marca local + encola Firestore).
//
// QUÉ NO HACE:
//   - No decide D4, no evalúa state machines, no resuelve matching.
//   - No hace merge remoto/local (eso vive en el merger, invocado aguas arriba
//     por el listener de Firestore cuando se cablee).
//   - No orquesta flujos entre entidades.
//
// REGLAS F3.c:
//   - Las closures enqueue son one-liners a funciones nombradas del remoto.
// ============================================================================

import '../../../core/platform/offline_sync_service.dart';
import '../../../domain/entities/core_common/local_organization_entity.dart';
import '../../../domain/repositories/core_common/local_organization_repository.dart';
import '../../models/core_common/local_organization_model.dart';
import '../../models/core_common/remote/local_organization_remote_dto.dart';
import '../../sources/local/core_common/local_organization_local_ds.dart';
import '../../sources/remote/core_common/local_organization_firestore_ds.dart';

class LocalOrganizationRepositoryImpl implements LocalOrganizationRepository {
  final LocalOrganizationLocalDataSource _local;
  final LocalOrganizationFirestoreDataSource _remote;
  final OfflineSyncService _sync;

  LocalOrganizationRepositoryImpl({
    required LocalOrganizationLocalDataSource local,
    required LocalOrganizationFirestoreDataSource remote,
    required OfflineSyncService sync,
  })  : _local = local,
        _remote = remote,
        _sync = sync;

  @override
  Future<void> save(LocalOrganizationEntity organization) async {
    final model = LocalOrganizationModel.fromEntity(organization);
    await _local.upsert(model);
    final dto = LocalOrganizationRemoteDto.fromEntity(organization);
    _sync.enqueue(() => _remote.save(organization.workspaceId, dto));
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
  Future<LocalOrganizationEntity?> getById(String id) async {
    final m = await _local.getById(id);
    return m?.toEntity();
  }

  @override
  Stream<LocalOrganizationEntity?> watchById(String id) {
    return _local.watchById(id).map((m) => m?.toEntity());
  }

  @override
  Future<List<LocalOrganizationEntity>> listByWorkspace(
    String workspaceId,
  ) async {
    final models = await _local.listByWorkspace(workspaceId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<LocalOrganizationEntity>> watchByWorkspace(String workspaceId) {
    return _local
        .watchByWorkspace(workspaceId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<List<LocalOrganizationEntity>> findByPhoneE164(
    String workspaceId,
    String phoneE164Normalized,
  ) async {
    final models =
        await _local.findByPhoneE164(workspaceId, phoneE164Normalized);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<LocalOrganizationEntity>> findByTaxId(
    String workspaceId,
    String taxIdNormalized,
  ) async {
    final models = await _local.findByTaxId(workspaceId, taxIdNormalized);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<LocalOrganizationEntity>> findByEmail(
    String workspaceId,
    String emailNormalized,
  ) async {
    final models = await _local.findByEmail(workspaceId, emailNormalized);
    return models.map((m) => m.toEntity()).toList();
  }
}

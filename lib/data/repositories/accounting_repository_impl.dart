import 'dart:async';

import 'package:avanzza/core/di/container.dart';

import '../../domain/entities/accounting/accounting_entry_entity.dart';
import '../../domain/entities/accounting/adjustment_entity.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../models/accounting/accounting_entry_model.dart';
import '../models/accounting/adjustment_model.dart';
import '../sources/local/accounting_local_ds.dart';
import '../sources/remote/accounting_remote_ds.dart';

class AccountingRepositoryImpl implements AccountingRepository {
  final AccountingLocalDataSource local;
  final AccountingRemoteDataSource remote;

  AccountingRepositoryImpl({required this.local, required this.remote});

  // READ: local-first with background sync
  @override
  Stream<List<AccountingEntryEntity>> watchEntriesByOrg(String orgId,
      {String? countryId, String? cityId}) async* {
    final controller = StreamController<List<AccountingEntryEntity>>();
    Future(() async {
      try {
        final localList = await local.entriesByOrg(orgId,
            countryId: countryId, cityId: cityId);
        controller.add(localList.map((e) => e.toEntity()).toList());
        final remoteList = await remote.entriesByOrg(orgId,
            countryId: countryId, cityId: cityId);
        await _syncEntries(localList, remoteList);
        final updated = await local.entriesByOrg(orgId,
            countryId: countryId, cityId: cityId);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO: log error
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<AccountingEntryEntity>> fetchEntriesByOrg(String orgId,
      {String? countryId, String? cityId}) async {
    try {
      final localList =
          await local.entriesByOrg(orgId, countryId: countryId, cityId: cityId);
      // background sync
      unawaited(() async {
        try {
          final remoteList = await remote.entriesByOrg(orgId,
              countryId: countryId, cityId: cityId);
          await _syncEntries(localList, remoteList);
        } catch (e) {
          // TODO: log error
        }
      }());
      return localList.map((e) => e.toEntity()).toList();
    } catch (e) {
      // TODO: log error
      rethrow;
    }
  }

  Future<void> _syncEntries(List<AccountingEntryModel> locals,
      List<AccountingEntryModel> remotes) async {
    final byId = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = byId[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertEntry(r);
      }
    }
  }

  @override
  Stream<AccountingEntryEntity?> watchEntry(String id) async* {
    final controller = StreamController<AccountingEntryEntity?>();
    Future(() async {
      try {
        // No direct local get by id method; filter from org read is typical, but for simplicity we fetch by org elsewhere.
        final localList =
            await local.entriesByOrg('', cityId: null, countryId: null);
        final localItem = localList.where((e) => e.id == id).toList();
        controller.add(localItem.isEmpty ? null : localItem.first.toEntity());
        final remoteItem = await remote.getEntry(id);
        if (remoteItem != null) {
          await local.upsertEntry(remoteItem);
          final updatedList =
              await local.entriesByOrg('', cityId: null, countryId: null);
          controller.add(updatedList.firstWhere((e) => e.id == id).toEntity());
        }
      } catch (e) {
        // TODO: log error
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<AccountingEntryEntity?> getEntry(String id) async {
    try {
      final localList =
          await local.entriesByOrg('', cityId: null, countryId: null);
      final localItem = localList.where((e) => e.id == id).toList();
      // background sync
      unawaited(() async {
        try {
          final remoteItem = await remote.getEntry(id);
          if (remoteItem != null) await local.upsertEntry(remoteItem);
        } catch (e) {
          // TODO: log error
        }
      }());
      return localItem.isEmpty ? null : localItem.first.toEntity();
    } catch (e) {
      // TODO: log error
      rethrow;
    }
  }

  // WRITE: write-through (local + remote)
  @override
  Future<void> upsertEntry(AccountingEntryEntity entry) async {
    final now = DateTime.now().toUtc();
    final model = AccountingEntryModel.fromEntity(
        entry.copyWith(updatedAt: entry.updatedAt ?? now));
    try {
      await local.upsertEntry(model);
    } catch (e) {
      // TODO: log local error
    }
    try {
      await remote.upsertEntry(model);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertEntry(model));
    }
  }

  // Adjustments
  @override
  Stream<List<AdjustmentEntity>> watchAdjustments(String entryId) async* {
    final controller = StreamController<List<AdjustmentEntity>>();
    Future(() async {
      try {
        final localList = await local.adjustments(entryId);
        controller.add(localList.map((e) => e.toEntity()).toList());
        final remoteList = await remote.adjustments(entryId);
        await _syncAdjustments(localList, remoteList);
        final updated = await local.adjustments(entryId);
        controller.add(updated.map((e) => e.toEntity()).toList());
      } catch (e) {
        // TODO: log error
      } finally {
        await controller.close();
      }
    });
    yield* controller.stream;
  }

  @override
  Future<List<AdjustmentEntity>> fetchAdjustments(String entryId) async {
    try {
      final localList = await local.adjustments(entryId);
      unawaited(() async {
        try {
          final remoteList = await remote.adjustments(entryId);
          await _syncAdjustments(localList, remoteList);
        } catch (e) {
          // TODO: log error
        }
      }());
      return localList.map((e) => e.toEntity()).toList();
    } catch (e) {
      // TODO: log error
      rethrow;
    }
  }

  Future<void> _syncAdjustments(
      List<AdjustmentModel> locals, List<AdjustmentModel> remotes) async {
    final byId = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = byId[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertAdjustment(r);
      }
    }
  }

  @override
  Future<void> upsertAdjustment(AdjustmentEntity adjustment) async {
    final now = DateTime.now().toUtc();
    final model = AdjustmentModel.fromEntity(
        adjustment.copyWith(updatedAt: adjustment.updatedAt ?? now));
    try {
      await local.upsertAdjustment(model);
    } catch (e) {
      // TODO: log local error
    }
    try {
      await remote.upsertAdjustment(model);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertAdjustment(model));
    }
  }
}

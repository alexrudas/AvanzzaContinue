import 'dart:async';

import 'package:avanzza/core/di/container.dart';

import '../../domain/entities/insurance/insurance_policy_entity.dart';
import '../../domain/entities/insurance/insurance_purchase_entity.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../models/insurance/insurance_policy_model.dart';
import '../models/insurance/insurance_purchase_model.dart';
import '../sources/local/insurance_local_ds.dart';
import '../sources/remote/insurance_remote_ds.dart';

class InsuranceRepositoryImpl implements InsuranceRepository {
  final InsuranceLocalDataSource local;
  final InsuranceRemoteDataSource remote;

  InsuranceRepositoryImpl({required this.local, required this.remote});

  // Policies
  @override
  Stream<List<InsurancePolicyEntity>> watchPoliciesByAsset(String assetId,
      {String? countryId, String? cityId}) async* {
    final controller = StreamController<List<InsurancePolicyEntity>>();
    Future(() async {
      try {
        final localList = await local.policiesByAsset(assetId,
            countryId: countryId, cityId: cityId);
        controller.add(localList.map((e) => e.toEntity()).toList());
        final remoteList = await remote.policiesByAsset(assetId,
            countryId: countryId, cityId: cityId);
        await _syncPolicies(localList, remoteList);
        final updated = await local.policiesByAsset(assetId,
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
  Future<List<InsurancePolicyEntity>> fetchPoliciesByAsset(String assetId,
      {String? countryId, String? cityId}) async {
    try {
      final localList = await local.policiesByAsset(assetId,
          countryId: countryId, cityId: cityId);
      unawaited(() async {
        try {
          final remoteList = await remote.policiesByAsset(assetId,
              countryId: countryId, cityId: cityId);
          await _syncPolicies(localList, remoteList);
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

  Future<void> _syncPolicies(List<InsurancePolicyModel> locals,
      List<InsurancePolicyModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertPolicy(r);
      }
    }
  }

  @override
  Stream<InsurancePolicyEntity?> watchPolicy(String id) async* {
    final controller = StreamController<InsurancePolicyEntity?>();
    Future(() async {
      try {
        final localList =
            await local.policiesByAsset('', countryId: null, cityId: null);
        final localItem = localList.where((e) => e.id == id).toList();
        controller.add(localItem.isEmpty ? null : localItem.first.toEntity());
        final remoteItem = await remote.getPolicy(id);
        if (remoteItem != null) {
          await local.upsertPolicy(remoteItem);
          final updated =
              await local.policiesByAsset('', countryId: null, cityId: null);
          controller.add(updated.firstWhere((e) => e.id == id).toEntity());
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
  Future<InsurancePolicyEntity?> getPolicy(String id) async {
    try {
      final localList =
          await local.policiesByAsset('', countryId: null, cityId: null);
      final localItem = localList.where((e) => e.id == id).toList();
      unawaited(() async {
        try {
          final remoteItem = await remote.getPolicy(id);
          if (remoteItem != null) await local.upsertPolicy(remoteItem);
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

  @override
  Future<void> upsertPolicy(InsurancePolicyEntity policy) async {
    final now = DateTime.now().toUtc();
    final model = InsurancePolicyModel.fromEntity(
        policy.copyWith(updatedAt: policy.updatedAt ?? now));
    try {
      await local.upsertPolicy(model);
    } catch (e) {
      // TODO: log local error
    }
    try {
      await remote.upsertPolicy(model);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPolicy(model));
    }
  }

  // Purchases
  @override
  Stream<List<InsurancePurchaseEntity>> watchPurchasesByOrg(
      String orgId) async* {
    final controller = StreamController<List<InsurancePurchaseEntity>>();
    Future(() async {
      try {
        final localList = await local.purchasesByOrg(orgId);
        controller.add(localList.map((e) => e.toEntity()).toList());
        final remoteList = await remote.purchasesByOrg(orgId);
        await _syncPurchases(localList, remoteList);
        final updated = await local.purchasesByOrg(orgId);
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
  Future<List<InsurancePurchaseEntity>> fetchPurchasesByOrg(
      String orgId) async {
    try {
      final localList = await local.purchasesByOrg(orgId);
      unawaited(() async {
        try {
          final remoteList = await remote.purchasesByOrg(orgId);
          await _syncPurchases(localList, remoteList);
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

  Future<void> _syncPurchases(List<InsurancePurchaseModel> locals,
      List<InsurancePurchaseModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertPurchase(r);
      }
    }
  }

  @override
  Stream<InsurancePurchaseEntity?> watchPurchase(String id) async* {
    final controller = StreamController<InsurancePurchaseEntity?>();
    Future(() async {
      try {
        final localList = await local.purchasesByOrg('');
        final localItem = localList.where((e) => e.id == id).toList();
        controller.add(localItem.isEmpty ? null : localItem.first.toEntity());
        final remoteItem = await remote.getPurchase(id);
        if (remoteItem != null) {
          await local.upsertPurchase(remoteItem);
          final updated = await local.purchasesByOrg('');
          controller.add(updated.firstWhere((e) => e.id == id).toEntity());
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
  Future<InsurancePurchaseEntity?> getPurchase(String id) async {
    try {
      final localList = await local.purchasesByOrg('');
      final localItem = localList.where((e) => e.id == id).toList();
      unawaited(() async {
        try {
          final remoteItem = await remote.getPurchase(id);
          if (remoteItem != null) await local.upsertPurchase(remoteItem);
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

  @override
  Future<void> upsertPurchase(InsurancePurchaseEntity purchase) async {
    final now = DateTime.now().toUtc();
    final model = InsurancePurchaseModel.fromEntity(
        purchase.copyWith(updatedAt: purchase.updatedAt ?? now));
    try {
      await local.upsertPurchase(model);
    } catch (e) {
      // TODO: log local error
    }
    try {
      await remote.upsertPurchase(model);
    } catch (e) {
      DIContainer().syncService.enqueue(() => remote.upsertPurchase(model));
    }
  }
}

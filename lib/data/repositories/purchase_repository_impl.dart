import 'dart:async';

import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/models/purchase/supplier_response_model.dart';
import 'package:avanzza/data/sources/local/purchase_local_ds.dart';
import 'package:avanzza/data/sources/remote/purchase_remote_ds.dart';

import '../../../domain/entities/purchase/purchase_request_entity.dart';
import '../../../domain/entities/purchase/supplier_response_entity.dart';
import '../../../domain/repositories/purchase_repository.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource local;
  final PurchaseRemoteDataSource remote;
  PurchaseRepositoryImpl({required this.local, required this.remote});

  @override
  Stream<List<PurchaseRequestEntity>> watchRequestsByOrg(String orgId,
      {String? cityId, String? assetId}) async* {
    final controller = StreamController<List<PurchaseRequestEntity>>();
    Future(() async {
      final locals =
          await local.requestsByOrg(orgId, cityId: cityId, assetId: assetId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.requestsByOrg(orgId, cityId: cityId, assetId: assetId);
      await _syncRequests(locals, remotes);
      final updated =
          await local.requestsByOrg(orgId, cityId: cityId, assetId: assetId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<PurchaseRequestEntity>> fetchRequestsByOrg(String orgId,
      {String? cityId, String? assetId}) async {
    final locals =
        await local.requestsByOrg(orgId, cityId: cityId, assetId: assetId);
    unawaited(() async {
      final remotes =
          await remote.requestsByOrg(orgId, cityId: cityId, assetId: assetId);
      await _syncRequests(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncRequests(List<PurchaseRequestModel> locals,
      List<PurchaseRequestModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertRequest(r);
      }
    }
  }

  @override
  Stream<PurchaseRequestEntity?> watchRequest(String id) async* {
    final controller = StreamController<PurchaseRequestEntity?>();
    Future(() async {
      final locals = await local.requestsByOrg('', cityId: null, assetId: null);
      final l = locals.where((e) => e.id == id).toList();
      controller.add(l.isEmpty ? null : l.first.toEntity());
      final r = await remote.getRequest(id);
      if (r != null) {
        await local.upsertRequest(r);
        final updated =
            await local.requestsByOrg('', cityId: null, assetId: null);
        controller.add(updated.firstWhere((e) => e.id == id).toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<PurchaseRequestEntity?> getRequest(String id) async {
    final locals = await local.requestsByOrg('', cityId: null, assetId: null);
    final l = locals.where((e) => e.id == id).toList();
    unawaited(() async {
      final r = await remote.getRequest(id);
      if (r != null) await local.upsertRequest(r);
    }());
    return l.isEmpty ? null : l.first.toEntity();
  }

  @override
  Future<void> upsertRequest(PurchaseRequestEntity request) async {
    final now = DateTime.now().toUtc();
    final m = PurchaseRequestModel.fromEntity(
        request.copyWith(updatedAt: request.updatedAt ?? now));
    await local.upsertRequest(m);
    try {
      await remote.upsertRequest(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertRequest(m));
    }
  }

  @override
  Stream<List<SupplierResponseEntity>> watchResponsesByRequest(
      String requestId) async* {
    final controller = StreamController<List<SupplierResponseEntity>>();
    Future(() async {
      final locals = await local.responsesByRequest(requestId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes = await remote.responsesByRequest(requestId);
      await _syncResponses(locals, remotes);
      final updated = await local.responsesByRequest(requestId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<SupplierResponseEntity>> fetchResponsesByRequest(
      String requestId) async {
    final locals = await local.responsesByRequest(requestId);
    unawaited(() async {
      final remotes = await remote.responsesByRequest(requestId);
      await _syncResponses(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncResponses(List<SupplierResponseModel> locals,
      List<SupplierResponseModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertSupplierResponse(r);
      }
    }
  }

  @override
  Future<void> upsertSupplierResponse(SupplierResponseEntity response) async {
    final now = DateTime.now().toUtc();
    final m = SupplierResponseModel.fromEntity(
        response.copyWith(updatedAt: response.updatedAt ?? now));
    await local.upsertSupplierResponse(m);
    try {
      await remote.upsertSupplierResponse(m);
    } catch (_) {
      DIContainer().syncService.enqueue(() => remote.upsertSupplierResponse(m));
    }
  }
}

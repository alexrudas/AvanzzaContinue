import 'dart:async';

import 'package:avanzza/data/models/org/organization_model.dart';
import 'package:avanzza/data/sources/local/org_local_ds.dart';
import 'package:avanzza/data/sources/remote/org_remote_ds.dart';

import '../../../domain/entities/org/organization_entity.dart';
import '../../../domain/repositories/org_repository.dart';

class OrgRepositoryImpl implements OrgRepository {
  final OrgLocalDataSource local;
  final OrgRemoteDataSource remote;
  OrgRepositoryImpl({required this.local, required this.remote});

  @override
  Stream<List<OrganizationEntity>> watchOrgsByUser(String uid,
      {String? countryId, String? cityId}) async* {
    final controller = StreamController<List<OrganizationEntity>>();
    Future(() async {
      final locals =
          await local.orgsByUser(uid, countryId: countryId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes =
          await remote.orgsByUser(uid, countryId: countryId, cityId: cityId);
      await _sync(locals, remotes);
      print("[watchOrgsByUser] remotes $remotes");
      final updated =
          await local.orgsByUser(uid, countryId: countryId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<OrganizationEntity>> fetchOrgsByUser(String uid,
      {String? countryId, String? cityId}) async {
    final locals =
        await local.orgsByUser(uid, countryId: countryId, cityId: cityId);
    unawaited(() async {
      final remotes =
          await remote.orgsByUser(uid, countryId: countryId, cityId: cityId);
      await _sync(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _sync(
      List<OrganizationModel> locals, List<OrganizationModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertOrg(r);
      }
    }
  }

  @override
  Stream<OrganizationEntity?> watchOrg(String orgId) async* {
    final controller = StreamController<OrganizationEntity?>();
    Future(() async {
      final l = await local.getOrg(orgId);
      controller.add(l?.toEntity());
      final r = await remote.getOrg(orgId);
      if (r != null) {
        await local.upsertOrg(r);
        final updated = await local.getOrg(orgId);
        controller.add(updated?.toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<OrganizationEntity?> getOrg(String orgId) async {
    final l = await local.getOrg(orgId);
    unawaited(() async {
      final r = await remote.getOrg(orgId);
      if (r != null) await local.upsertOrg(r);
    }());
    return l?.toEntity();
  }

  @override
  Future<void> upsertOrg(OrganizationEntity org) async {
    final now = DateTime.now().toUtc();
    final m = OrganizationModel.fromEntity(
        org.copyWith(updatedAt: org.updatedAt ?? now));
    await local.upsertOrg(m);
    await remote.upsertOrg(m);
  }

  @override
  Future<void> updateOrgLocation(String orgId,
      {required String countryId, String? regionId, String? cityId}) async {
    // optimistic local update if present
    final current = await local.getOrg(orgId);
    if (current != null) {
      final updated = OrganizationModel(
        isarId: current.isarId,
        id: current.id,
        nombre: current.nombre,
        tipo: current.tipo,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        ownerUid: current.ownerUid,
        logoUrl: current.logoUrl,
        //  metadata: current.metadata,
        isActive: current.isActive,
        createdAt: current.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
      await local.upsertOrg(updated);
    }
    await remote.updateOrgLocation(orgId,
        countryId: countryId, regionId: regionId, cityId: cityId);
  }
}

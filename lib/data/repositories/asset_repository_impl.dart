import 'dart:async';

import 'package:avanzza/data/models/asset/asset_document_model.dart';
import 'package:avanzza/data/models/asset/asset_model.dart';
import 'package:avanzza/data/models/asset/special/asset_inmueble_model.dart';
import 'package:avanzza/data/models/asset/special/asset_maquinaria_model.dart';
import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/sources/local/asset_local_ds.dart';
import 'package:avanzza/data/sources/remote/asset_remote_ds.dart';

import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/asset/asset_document_entity.dart';
import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../../domain/entities/asset/special/asset_inmueble_entity.dart';
import '../../../domain/entities/asset/special/asset_maquinaria_entity.dart';
import '../../../domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource local;
  final AssetRemoteDataSource remote;
  AssetRepositoryImpl({required this.local, required this.remote});

  // Root assets
  @override
  Stream<List<AssetEntity>> watchAssetsByOrg(String orgId,
      {String? assetType, String? cityId}) async* {
    final controller = StreamController<List<AssetEntity>>();
    Future(() async {
      final locals = await local.listAssetsByOrg(orgId,
          assetType: assetType, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes = await remote.listAssetsByOrg(orgId,
          assetType: assetType, cityId: cityId);
      await _syncAssets(locals, remotes);
      final updated = await local.listAssetsByOrg(orgId,
          assetType: assetType, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<AssetEntity>> fetchAssetsByOrg(String orgId,
      {String? assetType, String? cityId}) async {
    final locals = await local.listAssetsByOrg(orgId,
        assetType: assetType, cityId: cityId);
    unawaited(() async {
      final remotes = await remote.listAssetsByOrg(orgId,
          assetType: assetType, cityId: cityId);
      await _syncAssets(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncAssets(
      List<AssetModel> locals, List<AssetModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertAsset(r);
      }
    }
  }

  @override
  Stream<AssetEntity?> watchAsset(String assetId) async* {
    final controller = StreamController<AssetEntity?>();
    Future(() async {
      final l = await local.getAsset(assetId);
      controller.add(l?.toEntity());
      final r = await remote.getAsset(assetId);
      if (r != null) {
        await local.upsertAsset(r);
        final updated = await local.getAsset(assetId);
        controller.add(updated?.toEntity());
      }
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<AssetEntity?> getAsset(String assetId) async {
    final l = await local.getAsset(assetId);
    unawaited(() async {
      final r = await remote.getAsset(assetId);
      if (r != null) await local.upsertAsset(r);
    }());
    return l?.toEntity();
  }

  @override
  Future<void> upsertAsset(AssetEntity asset) async {
    final now = DateTime.now().toUtc();
    final m = AssetModel.fromEntity(
        asset.copyWith(updatedAt: asset.updatedAt ?? now));
    await local.upsertAsset(m);
    await remote.upsertAsset(m);
  }

  @override
  Future<
      ({
        AssetVehiculoEntity? vehiculo,
        AssetInmuebleEntity? inmueble,
        AssetMaquinariaEntity? maquinaria
      })> getAssetDetails(String assetId) async {
    final vLocal = await local.getVehiculo(assetId);
    final iLocal = await local.getInmueble(assetId);
    final mLocal = await local.getMaquinaria(assetId);

    // background sync
    unawaited(() async {
      final vRem = await remote.getVehiculo(assetId);
      if (vRem != null) await local.upsertVehiculo(vRem);
      final iRem = await remote.getInmueble(assetId);
      if (iRem != null) await local.upsertInmueble(iRem);
      final mRem = await remote.getMaquinaria(assetId);
      if (mRem != null) await local.upsertMaquinaria(mRem);
    }());

    return (
      vehiculo: vLocal?.toEntity(),
      inmueble: iLocal?.toEntity(),
      maquinaria: mLocal?.toEntity(),
    );
  }

  @override
  Future<void> upsertVehiculo(AssetVehiculoEntity vehiculo) async {
    final now = DateTime.now().toUtc();
    final m = AssetVehiculoModel.fromEntity(
        vehiculo.copyWith(updatedAt: vehiculo.updatedAt ?? now));
    await local.upsertVehiculo(m);
    await remote.upsertVehiculo(m);
  }

  @override
  Future<void> upsertInmueble(AssetInmuebleEntity inmueble) async {
    final now = DateTime.now().toUtc();
    final m = AssetInmuebleModel.fromEntity(
        inmueble.copyWith(updatedAt: inmueble.updatedAt ?? now));
    await local.upsertInmueble(m);
    await remote.upsertInmueble(m);
  }

  @override
  Future<void> upsertMaquinaria(AssetMaquinariaEntity maquinaria) async {
    final now = DateTime.now().toUtc();
    final m = AssetMaquinariaModel.fromEntity(
        maquinaria.copyWith(updatedAt: maquinaria.updatedAt ?? now));
    await local.upsertMaquinaria(m);
    await remote.upsertMaquinaria(m);
  }

  // Documents
  @override
  Stream<List<AssetDocumentEntity>> watchAssetDocuments(String assetId,
      {String? countryId, String? cityId}) async* {
    final controller = StreamController<List<AssetDocumentEntity>>();
    Future(() async {
      final locals = await local.listDocuments(assetId,
          countryId: countryId, cityId: cityId);
      controller.add(locals.map((e) => e.toEntity()).toList());
      final remotes = await remote.listDocuments(assetId,
          countryId: countryId, cityId: cityId);
      await _syncDocs(locals, remotes);
      final updated = await local.listDocuments(assetId,
          countryId: countryId, cityId: cityId);
      controller.add(updated.map((e) => e.toEntity()).toList());
      await controller.close();
    });
    yield* controller.stream;
  }

  @override
  Future<List<AssetDocumentEntity>> fetchAssetDocuments(String assetId,
      {String? countryId, String? cityId}) async {
    final locals = await local.listDocuments(assetId,
        countryId: countryId, cityId: cityId);
    unawaited(() async {
      final remotes = await remote.listDocuments(assetId,
          countryId: countryId, cityId: cityId);
      await _syncDocs(locals, remotes);
    }());
    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncDocs(
      List<AssetDocumentModel> locals, List<AssetDocumentModel> remotes) async {
    final map = {for (final l in locals) l.id: l};
    for (final r in remotes) {
      final l = map[r.id];
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertDocument(r);
      }
    }
  }

  @override
  Future<void> upsertAssetDocument(AssetDocumentEntity document) async {
    final now = DateTime.now().toUtc();
    final m = AssetDocumentModel.fromEntity(
        document.copyWith(updatedAt: document.updatedAt ?? now));
    await local.upsertDocument(m);
    await remote.upsertDocument(m);
  }
}

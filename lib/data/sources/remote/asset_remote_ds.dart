import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/asset/asset_model.dart';
import '../../models/asset/asset_document_model.dart';
import '../../models/asset/special/asset_vehiculo_model.dart';
import '../../models/asset/special/asset_inmueble_model.dart';
import '../../models/asset/special/asset_maquinaria_model.dart';

class AssetRemoteDataSource {
  final FirebaseFirestore db;
  AssetRemoteDataSource(this.db);

  // Assets
  Future<List<AssetModel>> listAssetsByOrg(String orgId,
      {String? assetType, String? cityId}) async {
    Query q = db.collection('assets').where('orgId', isEqualTo: orgId);
    if (assetType != null) q = q.where('assetType', isEqualTo: assetType);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) =>
            AssetModel.fromFirestore(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<AssetModel?> getAsset(String assetId) async {
    final d = await db.collection('assets').doc(assetId).get();
    if (!d.exists) return null;
    return AssetModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertAsset(AssetModel m) async {
    await db
        .collection('assets')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteAsset(String assetId) async {
    await db.collection('assets').doc(assetId).delete();
  }

  // Specializations
  Future<AssetVehiculoModel?> getVehiculo(String assetId) async {
    final d = await db.collection('asset_vehiculo').doc(assetId).get();
    if (!d.exists) return null;
    return AssetVehiculoModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertVehiculo(AssetVehiculoModel m) async {
    await db
        .collection('asset_vehiculo')
        .doc(m.assetId)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<AssetInmuebleModel?> getInmueble(String assetId) async {
    final d = await db.collection('asset_inmueble').doc(assetId).get();
    if (!d.exists) return null;
    return AssetInmuebleModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertInmueble(AssetInmuebleModel m) async {
    await db
        .collection('asset_inmueble')
        .doc(m.assetId)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<AssetMaquinariaModel?> getMaquinaria(String assetId) async {
    final d = await db.collection('asset_maquinaria').doc(assetId).get();
    if (!d.exists) return null;
    return AssetMaquinariaModel.fromFirestore(d.id, d.data()!);
  }

  Future<void> upsertMaquinaria(AssetMaquinariaModel m) async {
    await db
        .collection('asset_maquinaria')
        .doc(m.assetId)
        .set(m.toJson(), SetOptions(merge: true));
  }

  // Documents
  Future<List<AssetDocumentModel>> listDocuments(String assetId,
      {String? countryId, String? cityId}) async {
    Query q =
        db.collection('asset_documents').where('assetId', isEqualTo: assetId);
    if (countryId != null) q = q.where('countryId', isEqualTo: countryId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => AssetDocumentModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertDocument(AssetDocumentModel m) async {
    await db
        .collection('asset_documents')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteDocument(String id) async {
    await db.collection('asset_documents').doc(id).delete();
  }
}

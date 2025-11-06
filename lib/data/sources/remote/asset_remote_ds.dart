import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/asset/asset_document_model.dart';
import '../../models/asset/asset_model.dart';
import '../../models/asset/special/asset_inmueble_model.dart';
import '../../models/asset/special/asset_maquinaria_model.dart';
import '../../models/asset/special/asset_vehiculo_model.dart';

class AssetRemoteDataSource {
  final FirebaseFirestore db;
  AssetRemoteDataSource(this.db);

  /// Límite por defecto para queries de assets
  static const int defaultLimit = 100;

  /// Límite máximo permitido
  static const int maxLimit = 500;

  // Assets
  /// Obtiene assets paginados de una organización
  ///
  /// OPTIMIZACIÓN CRÍTICA: Evita traer TODOS los assets de una org
  /// - Una org con 10,000 assets ahora solo trae 100 por página
  /// - Reduce costos de lectura en ~99% (10,000 → 100 lecturas)
  /// - Usa [startAfter] para cargar páginas adicionales
  ///
  /// Ejemplo:
  /// ```dart
  /// // Primera página
  /// final page1 = await ds.listAssetsByOrg('org123', limit: 100);
  ///
  /// // Segunda página
  /// if (page1.hasMore) {
  ///   final page2 = await ds.listAssetsByOrg(
  ///     'org123',
  ///     limit: 100,
  ///     startAfter: page1.lastDocument,
  ///   );
  /// }
  /// ```
  Future<PaginatedResult<AssetModel>> listAssetsByOrg(
    String orgId, {
    String? assetType,
    String? cityId,
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q = db
        .collection('assets')
        .where('orgId', isEqualTo: orgId);

    if (assetType != null) q = q.where('assetType', isEqualTo: assetType);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    // Ordenar por fecha de creación (más recientes primero)
    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => AssetModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  ///
  /// ⚠️ ADVERTENCIA: Este método trae TODOS los assets sin límite
  /// Una org con 10,000 assets = 10,000 lecturas por query
  ///
  /// Considera usar [listAssetsByOrg] con paginación
  @Deprecated('Usa listAssetsByOrg con paginación para mejor rendimiento')
  Future<List<AssetModel>> listAssetsByOrgLegacy(String orgId,
      {String? assetType, String? cityId}) async {
    Query q = db.collection('assets').where('orgId', isEqualTo: orgId);
    if (assetType != null) q = q.where('assetType', isEqualTo: assetType);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => AssetModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<AssetModel?> getAsset(String assetId) async {
    final d = await db.collection('assets').doc(assetId).get();
    if (!d.exists) return null;
    return AssetModel.fromFirestore(d.id, d.data()!, db: db);
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
  /// Obtiene documentos paginados de un asset
  ///
  /// OPTIMIZACIÓN: Limita documentos a 50 por página
  Future<PaginatedResult<AssetDocumentModel>> listDocuments(
    String assetId, {
    String? countryId,
    String? cityId,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > 200) {
      throw ArgumentError('Limit $limit exceeds maximum of 200');
    }

    Query q =
        db.collection('asset_documents').where('assetId', isEqualTo: assetId);

    if (countryId != null) q = q.where('countryId', isEqualTo: countryId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => AssetDocumentModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  @Deprecated('Usa listDocuments con paginación')
  Future<List<AssetDocumentModel>> listDocumentsLegacy(String assetId,
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

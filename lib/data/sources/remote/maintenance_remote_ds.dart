import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/paginated_result.dart';
import '../../models/maintenance/incidencia_model.dart';
import '../../models/maintenance/maintenance_finished_model.dart';
import '../../models/maintenance/maintenance_process_model.dart';
import '../../models/maintenance/maintenance_programming_model.dart';

class MaintenanceRemoteDataSource {
  final FirebaseFirestore db;
  MaintenanceRemoteDataSource(this.db);

  /// Límite por defecto para queries de mantenimiento
  static const int defaultLimit = 50;

  /// Límite máximo permitido
  static const int maxLimit = 200;

  // Incidencias
  /// Obtiene incidencias paginadas de una organización
  ///
  /// OPTIMIZACIÓN CRÍTICA: Evita traer TODAS las incidencias históricas
  /// - Una org con 1,000 incidencias ahora solo trae 50 por página
  /// - Reduce costos de lectura en ~95% (1,000 → 50 lecturas)
  Future<PaginatedResult<IncidenciaModel>> incidencias(
    String orgId, {
    String? assetId,
    String? cityId,
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q = db.collection('incidencias').where('orgId', isEqualTo: orgId);

    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => IncidenciaModel.fromFirestore(
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
  @Deprecated('Usa incidencias con paginación')
  Future<List<IncidenciaModel>> incidenciasLegacy(String orgId,
      {String? assetId, String? cityId}) async {
    Query q = db.collection('incidencias').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => IncidenciaModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>,
            db: db))
        .toList();
  }

  Future<void> upsertIncidencia(IncidenciaModel m) async {
    await db
        .collection('incidencias')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteIncidencia(String id) async {
    await db.collection('incidencias').doc(id).delete();
  }

  // Programaciones
  /// Obtiene programaciones paginadas de una organización
  ///
  /// OPTIMIZACIÓN: Limita programaciones a 50 por página
  Future<PaginatedResult<MaintenanceProgrammingModel>> programaciones(
    String orgId, {
    String? assetId,
    String? cityId,
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q = db
        .collection('maintenance_programming')
        .where('orgId', isEqualTo: orgId);

    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => MaintenanceProgrammingModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  @Deprecated('Usa programaciones con paginación')
  Future<List<MaintenanceProgrammingModel>> programacionesLegacy(String orgId,
      {String? assetId, String? cityId}) async {
    Query q = db
        .collection('maintenance_programming')
        .where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => MaintenanceProgrammingModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertProgramacion(MaintenanceProgrammingModel m) async {
    await db
        .collection('maintenance_programming')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteProgramacion(String id) async {
    await db.collection('maintenance_programming').doc(id).delete();
  }

  // Procesos
  /// Obtiene procesos paginados de una organización
  ///
  /// OPTIMIZACIÓN: Limita procesos en curso a 50 por página
  Future<PaginatedResult<MaintenanceProcessModel>> procesos(
    String orgId, {
    String? assetId,
    String? cityId,
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q =
        db.collection('maintenance_process').where('orgId', isEqualTo: orgId);

    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => MaintenanceProcessModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  @Deprecated('Usa procesos con paginación')
  Future<List<MaintenanceProcessModel>> procesosLegacy(String orgId,
      {String? assetId, String? cityId}) async {
    Query q =
        db.collection('maintenance_process').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => MaintenanceProcessModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertProceso(MaintenanceProcessModel m) async {
    await db
        .collection('maintenance_process')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteProceso(String id) async {
    await db.collection('maintenance_process').doc(id).delete();
  }

  // Finalizados
  /// Obtiene mantenimientos finalizados paginados de una organización
  ///
  /// OPTIMIZACIÓN CRÍTICA: Evita traer TODO el historial de mantenimientos
  /// - Una org con 5,000 finalizados ahora solo trae 50 por página
  /// - Reduce costos de lectura en ~99% (5,000 → 50 lecturas)
  Future<PaginatedResult<MaintenanceFinishedModel>> finalizados(
    String orgId, {
    String? assetId,
    String? cityId,
    int limit = defaultLimit,
    DocumentSnapshot? startAfter,
  }) async {
    if (limit > maxLimit) {
      throw ArgumentError('Limit $limit exceeds maximum of $maxLimit');
    }

    Query q =
        db.collection('maintenance_finished').where('orgId', isEqualTo: orgId);

    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);

    q = q.orderBy('createdAt', descending: true).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    final items = snap.docs
        .map((d) => MaintenanceFinishedModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();

    return PaginatedResult(
      items: items,
      lastDocument: snap.docs.isNotEmpty ? snap.docs.last : null,
      hasMore: snap.docs.length == limit,
    );
  }

  /// Método legacy (sin paginación) - DEPRECADO
  @Deprecated('Usa finalizados con paginación')
  Future<List<MaintenanceFinishedModel>> finalizadosLegacy(String orgId,
      {String? assetId, String? cityId}) async {
    Query q =
        db.collection('maintenance_finished').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs
        .map((d) => MaintenanceFinishedModel.fromFirestore(
            d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertFinalizado(MaintenanceFinishedModel m) async {
    await db
        .collection('maintenance_finished')
        .doc(m.id)
        .set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteFinalizado(String id) async {
    await db.collection('maintenance_finished').doc(id).delete();
  }
}

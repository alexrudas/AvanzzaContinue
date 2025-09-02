import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/maintenance/incidencia_model.dart';
import '../../models/maintenance/maintenance_programming_model.dart';
import '../../models/maintenance/maintenance_process_model.dart';
import '../../models/maintenance/maintenance_finished_model.dart';

class MaintenanceRemoteDataSource {
  final FirebaseFirestore db;
  MaintenanceRemoteDataSource(this.db);

  // Incidencias
  Future<List<IncidenciaModel>> incidencias(String orgId, {String? assetId, String? cityId}) async {
    Query q = db.collection('incidencias').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs.map((d) => IncidenciaModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertIncidencia(IncidenciaModel m) async {
    await db.collection('incidencias').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteIncidencia(String id) async {
    await db.collection('incidencias').doc(id).delete();
  }

  // Programaciones
  Future<List<MaintenanceProgrammingModel>> programaciones(String orgId, {String? assetId, String? cityId}) async {
    Query q = db.collection('maintenance_programming').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs.map((d) => MaintenanceProgrammingModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertProgramacion(MaintenanceProgrammingModel m) async {
    await db.collection('maintenance_programming').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteProgramacion(String id) async {
    await db.collection('maintenance_programming').doc(id).delete();
  }

  // Procesos
  Future<List<MaintenanceProcessModel>> procesos(String orgId, {String? assetId, String? cityId}) async {
    Query q = db.collection('maintenance_process').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs.map((d) => MaintenanceProcessModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertProceso(MaintenanceProcessModel m) async {
    await db.collection('maintenance_process').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteProceso(String id) async {
    await db.collection('maintenance_process').doc(id).delete();
  }

  // Finalizados
  Future<List<MaintenanceFinishedModel>> finalizados(String orgId, {String? assetId, String? cityId}) async {
    Query q = db.collection('maintenance_finished').where('orgId', isEqualTo: orgId);
    if (assetId != null) q = q.where('assetId', isEqualTo: assetId);
    if (cityId != null) q = q.where('cityId', isEqualTo: cityId);
    final snap = await q.get();
    return snap.docs.map((d) => MaintenanceFinishedModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertFinalizado(MaintenanceFinishedModel m) async {
    await db.collection('maintenance_finished').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteFinalizado(String id) async {
    await db.collection('maintenance_finished').doc(id).delete();
  }
}

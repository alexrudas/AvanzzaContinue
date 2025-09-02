import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/ai/ai_advisor_model.dart';
import '../../models/ai/ai_prediction_model.dart';
import '../../models/ai/ai_audit_log_model.dart';

class AIRemoteDataSource {
  final FirebaseFirestore db;
  AIRemoteDataSource(this.db);

  // Advisor sessions
  Future<List<AIAdvisorModel>> advisorSessions(String orgId, {String? userId, String? modulo}) async {
    Query q = db.collection('ai_advisor').where('orgId', isEqualTo: orgId);
    if (userId != null) q = q.where('userId', isEqualTo: userId);
    if (modulo != null) q = q.where('modulo', isEqualTo: modulo);
    final snap = await q.get();
    return snap.docs.map((d) => AIAdvisorModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertAdvisor(AIAdvisorModel m) async {
    await db.collection('ai_advisor').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  // Predictions
  Future<List<AIPredictionModel>> predictions(String orgId, {String? tipo, String? targetId}) async {
    Query q = db.collection('ai_predictions').where('orgId', isEqualTo: orgId);
    if (tipo != null) q = q.where('tipo', isEqualTo: tipo);
    if (targetId != null) q = q.where('targetId', isEqualTo: targetId);
    final snap = await q.get();
    return snap.docs.map((d) => AIPredictionModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertPrediction(AIPredictionModel m) async {
    await db.collection('ai_predictions').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }

  // Audit logs
  Future<List<AIAuditLogModel>> auditLogs(String orgId, {String? userId, String? modulo}) async {
    Query q = db.collection('ai_audit_logs').where('orgId', isEqualTo: orgId);
    if (userId != null) q = q.where('userId', isEqualTo: userId);
    if (modulo != null) q = q.where('modulo', isEqualTo: modulo);
    final snap = await q.get();
    return snap.docs.map((d) => AIAuditLogModel.fromFirestore(d.id, d.data() as Map<String,dynamic>)).toList();
  }

  Future<void> upsertAuditLog(AIAuditLogModel m) async {
    await db.collection('ai_audit_logs').doc(m.id).set(m.toJson(), SetOptions(merge: true));
  }
}

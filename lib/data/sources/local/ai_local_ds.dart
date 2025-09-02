import 'package:isar_community/isar.dart';

import '../../models/ai/ai_advisor_model.dart';
import '../../models/ai/ai_audit_log_model.dart';
import '../../models/ai/ai_prediction_model.dart';

class AILocalDataSource {
  final Isar isar;
  AILocalDataSource(this.isar);

  Future<List<AIAdvisorModel>> advisorSessions(String orgId,
      {String? userId, String? modulo}) async {
    final q = isar.aIAdvisorModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(userId != null, (q) => q.userIdEqualTo(userId!))
        .optional(modulo != null, (q) => q.moduloEqualTo(modulo!));
    return q.findAll();
  }

  Future<void> upsertAdvisor(AIAdvisorModel m) async =>
      isar.writeTxn(() async => isar.aIAdvisorModels.put(m));

  Future<List<AIPredictionModel>> predictions(String orgId,
      {String? tipo, String? targetId}) async {
    final q = isar.aIPredictionModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(tipo != null, (q) => q.tipoEqualTo(tipo!))
        .optional(targetId != null, (q) => q.targetIdEqualTo(targetId!));
    return q.findAll();
  }

  Future<void> upsertPrediction(AIPredictionModel m) async =>
      isar.writeTxn(() async => isar.aIPredictionModels.put(m));

  Future<List<AIAuditLogModel>> auditLogs(String orgId,
      {String? userId, String? modulo}) async {
    final q = isar.aIAuditLogModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(userId != null, (q) => q.userIdEqualTo(userId!))
        .optional(modulo != null, (q) => q.moduloEqualTo(modulo!));
    return q.findAll();
  }

  Future<void> upsertAuditLog(AIAuditLogModel m) async =>
      isar.writeTxn(() async => isar.aIAuditLogModels.put(m));
}

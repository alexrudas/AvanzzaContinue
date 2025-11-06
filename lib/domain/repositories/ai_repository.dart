import '../entities/ai/ai_advisor_entity.dart';
import '../entities/ai/ai_prediction_entity.dart';
import '../entities/ai/ai_audit_log_entity.dart';

abstract class AIRepository {
  // Advisor / Assistant
  Future<AIAdvisorEntity> chatAssistant({
    required String orgId,
    required String userId,
    required String inputText,
    Map<String, dynamic>?
        structuredContext, // e.g., {assetId, assetType, cityId}
  });
  Stream<List<AIAdvisorEntity>> watchAdvisorSessions(String orgId,
      {String? userId, String? modulo});
  Future<List<AIAdvisorEntity>> fetchAdvisorSessions(String orgId,
      {String? userId, String? modulo});
  Future<void> upsertAdvisor(AIAdvisorEntity advisor);

  // Predictions
  Future<AIPredictionEntity> analyzeAsset({
    required String orgId,
    required String assetId,
    String? cityId,
    Map<String, dynamic>? context,
  });
  Future<AIPredictionEntity> analyzeMaintenance({
    required String orgId,
    required String targetId, // processId or incidenceId
    Map<String, dynamic>? context,
  });
  Future<AIPredictionEntity> recommendSuppliers({
    required String orgId,
    required String tipoRepuesto,
    String? cityId,
    String? assetId,
  });
  Future<AIPredictionEntity> predictCashflow({
    required String orgId,
    String? countryId,
    String? cityId,
    Map<String, dynamic>? context,
  });
  Stream<List<AIPredictionEntity>> watchPredictions(String orgId,
      {String? tipo, String? targetId});
  Future<List<AIPredictionEntity>> fetchPredictions(String orgId,
      {String? tipo, String? targetId});
  Future<void> upsertPrediction(AIPredictionEntity prediction);

  // Audit logs
  Stream<List<AIAuditLogEntity>> watchAuditLogs(String orgId,
      {String? userId, String? modulo});
  Future<List<AIAuditLogEntity>> fetchAuditLogs(String orgId,
      {String? userId, String? modulo});
  Future<void> upsertAuditLog(AIAuditLogEntity log);
}

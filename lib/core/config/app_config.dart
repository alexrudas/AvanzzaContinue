class AppConfig {
  // Firestore root collections
  static const String colOrganizations = 'organizations';
  static const String colUsers = 'users';
  static const String colMemberships = 'memberships';
  static const String colAssets = 'assets';
  static const String colAssetDocs = 'asset_documents';
  static const String colIncidencias = 'incidencias';
  static const String colMaintProgramming = 'maintenance_programming';
  static const String colMaintProcess = 'maintenance_process';
  static const String colMaintFinished = 'maintenance_finished';
  static const String colPurchaseRequests = 'purchase_requests';
  static const String colSupplierResponses = 'supplier_responses';
  static const String colAccountingEntries = 'accounting_entries';
  static const String colAdjustments = 'adjustments';
  static const String colInsurancePolicies = 'insurance_policies';
  static const String colInsurancePurchases = 'insurance_purchases';
  static const String colChatMessages = 'chat_messages';
  static const String colBroadcastMessages = 'broadcast_messages';
  static const String colAIAdvisor = 'ai_advisor';
  static const String colAIPredictions = 'ai_predictions';
  static const String colAIAuditLogs = 'ai_audit_logs';

  // Feature flags
  static const bool enableOfflineSync = true;
  static const bool enableIsarInspector = false;

  // Build info (could be injected during CI)
  static const String buildFlavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const String buildNumber = String.fromEnvironment('BUILD_NUMBER', defaultValue: '0');
  static const String buildCommit = String.fromEnvironment('BUILD_COMMIT', defaultValue: 'local');
}

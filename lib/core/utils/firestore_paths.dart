class FirestorePaths {
  // Geo
  static const countries = 'countries';
  static const regions = 'regions';
  static const cities = 'cities';
  static const localRegulations = 'local_regulations';

  // Orgs/Users
  static const organizations = 'organizations';
  static const users = 'users';
  static const memberships = 'memberships';

  // Assets
  static const assets = 'assets';
  static const assetVehiculo = 'asset_vehiculo';
  static const assetInmueble = 'asset_inmueble';
  static const assetMaquinaria = 'asset_maquinaria';
  static const assetDocuments = 'asset_documents';

  // Maintenance
  static const incidencias = 'incidencias';
  static const maintenanceProgramming = 'maintenance_programming';
  static const maintenanceProcess = 'maintenance_process';
  static const maintenanceFinished = 'maintenance_finished';

  // Purchases
  static const purchaseRequests = 'purchase_requests';
  static const supplierResponses = 'supplier_responses';

  // Accounting
  static const accountingEntries = 'accounting_entries';
  static const adjustments = 'adjustments';

  // Insurance
  static const insurancePolicies = 'insurance_policies';
  static const insurancePurchases = 'insurance_purchases';

  // Chat
  static const chatMessages = 'chat_messages';
  static const broadcastMessages = 'broadcast_messages';

  // AI
  static const aiAdvisor = 'ai_advisor';
  static const aiPredictions = 'ai_predictions';
  static const aiAuditLogs = 'ai_audit_logs';

  // Asset Audit Log (v1.3.4)
  // Estructura: asset_audit_log/{assetId}/events/{eventId}
  static const assetAuditLog = 'asset_audit_log';
  static const assetAuditLogEvents = 'events';

  // Asset History (v1.3.4)
  // Path canónico: asset_vehiculo/{assetId}/history/{domain}/items/{itemId}
  // 'history' → doc(domain) → 'items' → doc(itemId)
  static const assetHistory = 'history';
}

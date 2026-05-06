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

  /// Kill-switch de la integración canónica de proveedores con Core API.
  ///
  /// Por defecto ON. Cuando está activo, `ProviderFormController.save()`
  /// orquesta la cadena completa:
  ///   `LocalContact.save → match-candidate.probe → POST /v1/providers
  ///    → PUT /v1/providers/:id/specialties`
  /// y la sección "Especialidades" del form aparece cuando hay `assetType`
  /// en contexto.
  ///
  /// Cuando está OFF, el `save()` cae al primer statement de kill-switch:
  /// solo persiste `LocalContact` localmente y retorna OK. NUNCA dispara
  /// probe / provision / replace contra Core API. La sección del selector
  /// también se oculta del form. Útil como rollback inmediato si el
  /// endpoint Core API tiene issues en producción o si el backfill de
  /// capabilities no corrió todavía.
  ///
  /// REGLA OPERATIVA (rollback condition):
  ///   Si los endpoints de Core API resultan inestables o el equipo
  ///   detecta un patrón de fallos en producción, apagar este flag es la
  ///   primera línea de mitigación — sin redeploy de schema, sin migración
  ///   de datos. El usuario recupera el flujo legacy puro (LocalContact
  ///   only) hasta que el backend esté sano y se reactive el flag.
  ///
  /// Endpoints canónicos consumidos cuando ON:
  ///   - `POST /v1/core-common/match-candidates/probe` (registra
  ///     LocalRefAttestation antes del POST en CREATE flow).
  ///   - `POST /v1/providers` (crear/reusar ProviderProfile).
  ///   - `GET  /v1/providers/:providerProfileId` (verificar en EDIT flow).
  ///   - `PUT  /v1/providers/:providerProfileId/specialties` (REPLACE).
  ///
  /// Aquí como `const` por simplicidad — mismo patrón que
  /// `enableOfflineSync` / `enableIsarInspector`. Si se necesita togglear
  /// remoto, migrar a un servicio de feature flags (ej. el patrón de
  /// `AssetSchemaFlags` con backing en Firestore).
  static const bool enableProviderSpecialtiesUI = true;

  // Build info (could be injected during CI)
  static const String buildFlavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const String buildNumber = String.fromEnvironment('BUILD_NUMBER', defaultValue: '0');
  static const String buildCommit = String.fromEnvironment('BUILD_COMMIT', defaultValue: 'local');
}

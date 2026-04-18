// lib/core/di/container.dart
// ignore_for_file: directives_ordering

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/services/session/switch_active_organization_uc.dart';
import '../../data/datasources/organizations/switch_active_organization_remote_ds.dart';
import '../../data/remote/firebase_backend_client.dart';
import '../../data/repositories/accounting_repository_impl.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../data/repositories/asset_registration_draft_repository_impl.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/geo_repository_impl.dart';
import '../../data/repositories/insurance_repository_impl.dart';
import '../../data/repositories/maintenance_repository_impl.dart';
import '../../data/repositories/org_repository_impl.dart';
import '../../data/datasources/integrations_remote_datasource.dart';
import '../../data/local/integrations_local_datasource.dart';
import '../../data/remote/integrations_api_client.dart';
import '../../data/repositories/integrations_repository_impl.dart';
import '../../data/repositories/portfolio_repository_impl.dart';
import '../../data/repositories/purchase_repository_impl.dart';
import '../../domain/repositories/integrations_repository.dart';
import '../platform/owner_refresh_service.dart';
import '../../data/repositories/sync_outbox_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/workspace_repository_impl.dart';
import '../../data/sources/local/accounting_local_ds.dart';
import '../../data/sources/local/ai_local_ds.dart';
import '../../data/sources/local/asset_local_ds.dart';
import '../../data/sources/local/asset_registration_draft_local_ds.dart';
import '../../data/sources/local/chat_local_ds.dart';
import '../../data/sources/local/geo_local_ds.dart';
import '../../data/sources/local/insurance_local_ds.dart';
import '../../data/sources/local/maintenance_local_ds.dart';
import '../../data/sources/local/org_local_ds.dart';
import '../../data/sources/local/portfolio_local_ds.dart';
import '../../data/sources/local/purchase_local_ds.dart';
import '../../data/sources/local/user_local_ds.dart';
import '../../data/sources/remote/accounting_remote_ds.dart';
import '../../data/sources/remote/ai_remote_ds.dart';
import '../../data/sources/remote/asset_remote_ds.dart';
import '../../data/sources/remote/chat_remote_ds.dart';
import '../../data/sources/remote/geo_remote_ds.dart';
import '../../data/sources/remote/insurance_remote_ds.dart';
import '../../data/sources/remote/maintenance_remote_ds.dart';
import '../../data/sources/remote/org_remote_ds.dart';
import '../../data/sources/remote/purchase/purchase_api_client.dart';
import '../../data/sources/remote/user_remote_ds.dart';
import '../../data/sync/asset_audit_service.dart';
import '../../data/sync/asset_firestore_adapter.dart';
import '../../data/sync/asset_history_archive_service.dart';
import '../../data/sync/asset_history_reconciliation_worker.dart';
import '../../data/sync/asset_sync_dispatcher.dart';
import '../../data/sync/asset_sync_engine.dart';
import '../../data/sync/asset_sync_queue.dart';
import '../../data/sync/asset_sync_service.dart';
import '../telemetry/sync_telemetry.dart';
import '../../domain/policies/access_policy.dart';
import '../../domain/policies/automation_policy.dart';
import '../../domain/policies/default_access_policy.dart';
import '../../domain/policies/default_automation_policy.dart';
import '../../domain/policies/default_payout_policy.dart';
import '../../domain/policies/payout_policy.dart';
import '../../domain/policies/policy_context_factory.dart';
import '../../domain/policies/policy_engine.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/repositories/asset_registration_draft_repository.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/geo_repository.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/repositories/org_repository.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../domain/repositories/sync_outbox_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../../domain/services/alerts/asset_alert_snapshot_assembler.dart';
import '../../domain/services/alerts/asset_compliance_alert_orchestrator.dart';
import '../../domain/services/alerts/home_alert_aggregation_service.dart';
import '../alerts/evaluators/soat_alert_adapter.dart';
import '../../domain/services/sync/sync_dispatcher.dart';
import '../../domain/services/sync/sync_engine.dart';
import '../../infrastructure/sync/connectivity_service_adapter.dart';
import '../../infrastructure/sync/firestore_sync_executor.dart';
import '../../infrastructure/sync/system_now_provider.dart';
import '../network/connectivity_service.dart';
import '../platform/offline_sync_service.dart';
import '../utils/firestore_paths.dart';

// ── Core Common v1 imports ───────────────────────────────────────────────────
import 'package:firebase_auth/firebase_auth.dart';

import '../../application/core_common/use_cases/resolve_match_candidate.dart';
import '../../application/core_common/use_cases/start_operational_request.dart';
import '../../application/core_common/use_cases/save_local_contact_with_probe.dart';
import '../../application/core_common/use_cases/save_local_organization_with_probe.dart';
import '../../data/remote/core_api_client.dart';
import '../../data/repositories/core_common/local_contact_repository_impl.dart';
import '../../data/repositories/core_common/local_organization_repository_impl.dart';
import '../../data/repositories/core_common/coordination_flow_repository_impl.dart';
import '../../data/repositories/core_common/match_candidate_repository_impl.dart';
import '../../data/repositories/core_common/operational_relationship_repository_impl.dart';
import '../../data/repositories/core_common/operational_request_repository_impl.dart';
import '../../data/repositories/core_common/request_delivery_repository_impl.dart';
import '../../data/sources/local/core_common/local_contact_local_ds.dart';
import '../../data/sources/local/core_common/local_organization_local_ds.dart';
import '../../data/sources/local/core_common/coordination_flow_local_ds.dart';
import '../../data/sources/local/core_common/match_candidate_local_ds.dart';
import '../../data/sources/local/core_common/operational_relationship_local_ds.dart';
import '../../data/sources/local/core_common/operational_request_local_ds.dart';
import '../../data/sources/local/core_common/request_delivery_local_ds.dart';
import '../../data/sources/remote/core_common/local_contact_firestore_ds.dart';
import '../../data/sources/remote/core_common/local_organization_firestore_ds.dart';
import '../../data/sources/remote/core_common/coordination_flow_api_client.dart';
import '../../data/sources/remote/core_common/match_candidate_nestjs_ds.dart';
import '../../data/sources/remote/core_common/match_candidate_nestjs_ds_impl.dart';
import '../../domain/repositories/core_common/local_contact_repository.dart';
import '../../domain/repositories/core_common/local_organization_repository.dart';
import '../../domain/repositories/core_common/coordination_flow_repository.dart';
import '../../domain/repositories/core_common/match_candidate_repository.dart';
import '../../domain/repositories/core_common/operational_relationship_repository.dart';
import '../../domain/repositories/core_common/operational_request_repository.dart';
import '../../domain/repositories/core_common/request_delivery_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DI CONTAINER — Singleton global de infraestructura
// ─────────────────────────────────────────────────────────────────────────────
//
// RESPONSABILIDAD
// - Centralizar wiring de data sources, repositories, políticas y sync stack.
//
// REGLAS
// - initDI() debe llamarse una sola vez en producción.
// - El container NO soporta reset/re-init completo.
// - El start/stop del sync stack se hace explícitamente desde bootstrap.
// - Este archivo define wiring; NO decide lifecycle de la app.
//
// DECISIÓN DE SYNC ACTUAL
// - Vehicle sync especializado:
//     AssetSyncDispatcher + AssetSyncEngine + AssetSyncService
// - SyncEngineService genérico:
//     se mantiene instanciado como infraestructura compartida,
//     pero NO es el owner principal de entities vehicle:*.
// - OfflineSyncService:
//     permanece por compatibilidad con flujos legacy.
//     NO es el owner principal del sync vehicular actual.
//
// NOTA DE OWNERSHIP
// Cualquier nueva entidad NO vehicular que requiera sync:
// - NO debe asumir automáticamente que usa SyncEngineService genérico
// - Debe documentar explícitamente si:
//   a) reutiliza el engine genérico, o
//   b) introduce stack especializado propio.
// ─────────────────────────────────────────────────────────────────────────────

class DIContainer {
  static final DIContainer _instance = DIContainer._internal();

  factory DIContainer() => _instance;

  DIContainer._internal();

  late final Isar _isar;
  late final FirebaseFirestore _firestore;

  // LEGACY:
  // Sigue existiendo por compatibilidad con flujos previos.
  // NO es el owner principal del sync vehicular actual.
  late final OfflineSyncService _syncService;

  bool _isInitialized = false;

  // ── Data sources ──────────────────────────────────────────────────────────
  late final GeoLocalDataSource geoLocal;
  late final GeoRemoteDataSource geoRemote;

  late final OrgLocalDataSource orgLocal;
  late final OrgRemoteDataSource orgRemote;

  late final UserLocalDataSource userLocal;
  late final UserRemoteDataSource userRemote;

  late final AssetLocalDataSource assetLocal;
  late final AssetRemoteDataSource assetRemote;

  late final MaintenanceLocalDataSource maintenanceLocal;
  late final MaintenanceRemoteDataSource maintenanceRemote;

  late final PurchaseLocalDataSource purchaseLocal;
  late final PurchaseApiClient purchaseRemote;

  late final AccountingLocalDataSource accountingLocal;
  late final AccountingRemoteDataSource accountingRemote;

  late final InsuranceLocalDataSource insuranceLocal;
  late final InsuranceRemoteDataSource insuranceRemote;

  late final ChatLocalDataSource chatLocal;
  late final ChatRemoteDataSource chatRemote;

  late final AILocalDataSource aiLocal;
  late final AIRemoteDataSource aiRemote;

  late final PortfolioLocalDataSource portfolioLocal;
  late final AssetRegistrationDraftLocalDataSource assetRegistrationDraftLocal;

  // ── Repositories ──────────────────────────────────────────────────────────
  late final GeoRepository geoRepository;
  late final OrgRepository orgRepository;
  late final UserRepository userRepository;
  late final AssetRepository assetRepository;
  late final MaintenanceRepository maintenanceRepository;
  late final PurchaseRepository purchaseRepository;
  late final AccountingRepository accountingRepository;
  late final InsuranceRepository insuranceRepository;
  late final ChatRepository chatRepository;
  late final AIRepository aiRepository;
  late final CatalogRepository catalogRepository;
  late final WorkspaceRepository workspaceRepository;
  late final PortfolioRepository portfolioRepository;
  late final IntegrationsRepository integrationsRepository;
  late final OwnerRefreshService ownerRefreshService;
  late final AssetRegistrationDraftRepository assetRegistrationDraftRepository;

  // ── Sync Engine V2 (genérico) ─────────────────────────────────────────────
  late final SyncOutboxRepository syncOutboxRepository;
  late final SyncDispatcher syncDispatcher;
  late final SyncEngineService syncEngineService;

  // ── Asset Audit Service (v1.3.4) ──────────────────────────────────────────
  late final AssetAuditService assetAuditService;

  // ── Sync Telemetry + History Stack (v1.3.4) ───────────────────────────────
  late final SyncTelemetry syncTelemetry;
  late final AssetHistoryArchiveService assetHistoryArchiveService;
  late final AssetHistoryReconciliationWorker assetHistoryReconciliationWorker;

  // ── Asset Sync Stack (vehicle-specific) ───────────────────────────────────
  late final AssetFirestoreAdapter assetFirestoreAdapter;
  late final AssetSyncQueue assetSyncQueue;
  late final AssetSyncService assetSyncService;
  late final AssetSyncEngine assetSyncEngine;
  late final AssetSyncDispatcher assetSyncDispatcher;

  // ── Alert System (V4) ─────────────────────────────────────────────────────
  late final AssetAlertSnapshotAssembler assetAlertSnapshotAssembler;
  late final AssetComplianceAlertOrchestrator assetComplianceAlertOrchestrator;
  late final HomeAlertAggregationService homeAlertAggregationService;

  // ── Policy Layer ──────────────────────────────────────────────────────────
  late final PolicyContextFactory policyContextFactory;
  late final AutomationPolicy automationPolicy;
  late final PayoutPolicy payoutPolicy;
  late final AccessPolicy accessPolicy;
  late final PolicyEngine policyEngine;

  // ── Connectivity ──────────────────────────────────────────────────────────
  late final ConnectivityService connectivityService;

  // ── Session / Org Switch Stack ────────────────────────────────────────────
  late final SwitchActiveOrganizationRemoteDS switchActiveOrganizationRemoteDs;
  late final SwitchActiveOrganizationUC switchActiveOrganizationUc;

  // ── Core Common v1 — Data sources (local) ─────────────────────────────────
  late final LocalOrganizationLocalDataSource localOrganizationLocal;
  late final LocalContactLocalDataSource localContactLocal;
  late final OperationalRelationshipLocalDataSource operationalRelationshipLocal;
  late final OperationalRequestLocalDataSource operationalRequestLocal;
  late final RequestDeliveryLocalDataSource requestDeliveryLocal;
  late final MatchCandidateLocalDataSource matchCandidateLocal;
  late final CoordinationFlowLocalDataSource coordinationFlowLocal;

  // ── Core Common v1 — Data sources (remote) ────────────────────────────────
  // Tras la inversión de D4, Core API es fuente de verdad. Los DS Firestore y
  // los mirrors fueron eliminados; solo queda el stack NestJS real.
  late final LocalOrganizationFirestoreDataSource localOrganizationFirestore;
  late final LocalContactFirestoreDataSource localContactFirestore;
  late final MatchCandidateNestJsDataSource matchCandidateNestJs;
  late final CoordinationFlowApiClient coordinationFlowApi;

  // ── Core Common v1 — Repositories ─────────────────────────────────────────
  late final LocalOrganizationRepository localOrganizationRepository;
  late final LocalContactRepository localContactRepository;
  late final OperationalRelationshipRepository operationalRelationshipRepository;
  late final OperationalRequestRepository operationalRequestRepository;
  late final RequestDeliveryRepository requestDeliveryRepository;
  late final MatchCandidateRepository matchCandidateRepository;
  late final CoordinationFlowRepository coordinationFlowRepository;

  // ── Core Common v1 — Casos de uso ─────────────────────────────────────────
  late final SaveLocalContactWithProbe saveLocalContactWithProbe;
  late final SaveLocalOrganizationWithProbe saveLocalOrganizationWithProbe;
  late final ResolveMatchCandidate resolveMatchCandidate;
  late final StartOperationalRequest startOperationalRequest;

  // ── Getters públicos de infraestructura base ──────────────────────────────
  Isar get isar => _isar;
  FirebaseFirestore get firestore => _firestore;
  OfflineSyncService get syncService => _syncService;
  bool get isInitialized => _isInitialized;
}

// ─────────────────────────────────────────────────────────────────────────────
// INIT DI
// ─────────────────────────────────────────────────────────────────────────────
//
// Idempotencia:
// - Si initDI() se llama de nuevo después de una inicialización exitosa,
//   retorna sin re-wiring.
// - Esto evita reescribir late finals y hace explícito el contrato
//   de una sola inicialización por proceso.
// ─────────────────────────────────────────────────────────────────────────────

Future<void> initDI({
  required Isar isar,
  required FirebaseFirestore firestore,
  required ConnectivityService connectivity,
}) async {
  final c = DIContainer();

  if (c._isInitialized) {
    return;
  }

  // ── Infra base ────────────────────────────────────────────────────────────
  c._isar = isar;
  c._firestore = firestore;
  c._syncService = OfflineSyncService();
  c.connectivityService = connectivity;

  // ── Session / Org Switch Stack ────────────────────────────────────────────
  // FirebaseBackendClient: Dio con Bearer token automático para Firebase Functions.
  // SwitchActiveOrganizationRemoteDS: HTTP datasource para el endpoint switchActiveOrganization.
  // SwitchActiveOrganizationUC: orquestador único del flujo de cambio de org activa.
  c.switchActiveOrganizationRemoteDs = SwitchActiveOrganizationRemoteDS(
    dio: FirebaseBackendClient.create(),
  );
  // userRepository se asigna abajo — se completa antes de que el UC sea usado.
  // La inicialización lazy de late final garantiza que userRepository ya existe
  // cuando switchActiveOrganizationUc.execute() sea invocado en runtime.

  if (!Get.isRegistered<OfflineSyncService>()) {
    Get.put<OfflineSyncService>(c.syncService, permanent: true);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // DATA SOURCES
  // ───────────────────────────────────────────────────────────────────────────
  c.geoLocal = GeoLocalDataSource(isar);
  c.geoRemote = GeoRemoteDataSource(firestore);

  c.orgLocal = OrgLocalDataSource(isar);
  c.orgRemote = OrgRemoteDataSource(firestore);

  c.userLocal = UserLocalDataSource(isar);
  c.userRemote = UserRemoteDataSource(firestore);

  c.assetLocal = AssetLocalDataSource(isar);
  c.assetRemote = AssetRemoteDataSource(firestore);

  c.maintenanceLocal = MaintenanceLocalDataSource(isar);
  c.maintenanceRemote = MaintenanceRemoteDataSource(firestore);

  c.purchaseLocal = PurchaseLocalDataSource(isar);
  // Compras: Core API es la única fuente remota (F5 Hito 17). Firestore
  // retirado. JWT bearer se extrae del mismo helper que usan los otros
  // ApiClients de Core Common.
  c.purchaseRemote = PurchaseApiClient(
    dio: CoreApiClient.create(),
    getIdToken: () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      return user.getIdToken();
    },
  );

  c.accountingLocal = AccountingLocalDataSource(isar);
  c.accountingRemote = AccountingRemoteDataSource(firestore);

  c.insuranceLocal = InsuranceLocalDataSource(isar);
  c.insuranceRemote = InsuranceRemoteDataSource(firestore);

  c.chatLocal = ChatLocalDataSource(isar);
  c.chatRemote = ChatRemoteDataSource(firestore);

  c.aiLocal = AILocalDataSource(isar);
  c.aiRemote = AIRemoteDataSource(firestore);

  c.portfolioLocal = PortfolioLocalDataSource(isar);
  c.assetRegistrationDraftLocal = AssetRegistrationDraftLocalDataSource(isar);

  // ───────────────────────────────────────────────────────────────────────────
  // REPOSITORIES
  // ───────────────────────────────────────────────────────────────────────────
  c.geoRepository = GeoRepositoryImpl(
    local: c.geoLocal,
    remote: c.geoRemote,
  );

  c.orgRepository = OrgRepositoryImpl(
    local: c.orgLocal,
    remote: c.orgRemote,
  );

  c.userRepository = UserRepositoryImpl(
    local: c.userLocal,
    remote: c.userRemote,
  );

  // UC requiere userRepository — se inicializa aquí donde ya está disponible.
  c.switchActiveOrganizationUc = SwitchActiveOrganizationUC(
    remoteDs: c.switchActiveOrganizationRemoteDs,
    userRepository: c.userRepository,
  );

  c.assetRepository = AssetRepositoryImpl(
    local: c.assetLocal,
    remote: c.assetRemote,
    enqueueSync: c.syncService.enqueue,
    portfolioLocalDS: c.portfolioLocal,
  );

  c.maintenanceRepository = MaintenanceRepositoryImpl(
    local: c.maintenanceLocal,
    remote: c.maintenanceRemote,
  );

  c.purchaseRepository = PurchaseRepositoryImpl(
    local: c.purchaseLocal,
    remote: c.purchaseRemote,
  );

  c.accountingRepository = AccountingRepositoryImpl(
    local: c.accountingLocal,
    remote: c.accountingRemote,
  );

  c.insuranceRepository = InsuranceRepositoryImpl(
    local: c.insuranceLocal,
    remote: c.insuranceRemote,
  );

  c.chatRepository = ChatRepositoryImpl(
    local: c.chatLocal,
    remote: c.chatRemote,
  );

  c.aiRepository = AIRepositoryImpl(
    local: c.aiLocal,
    remote: c.aiRemote,
  );

  c.catalogRepository = CatalogRepositoryImpl();

  c.workspaceRepository = WorkspaceRepositoryImpl(
    isar: isar,
    prefsProvider: SharedPreferences.getInstance,
  );

  c.portfolioRepository = PortfolioRepositoryImpl(
    local: c.portfolioLocal,
  );

  // ── Integrations (RUNT Persona + SIMIT) ─────────────────────────────────
  // Dio aislado del global de AppBindings, configurado con baseUrl + API key
  // específica del módulo. Reutiliza la instancia de Isar del container.
  c.integrationsRepository = IntegrationsRepositoryImpl(
    remote: IntegrationsRemoteDatasource(IntegrationsApiClient.create()),
    local: IntegrationsLocalDatasource(isar),
  );

  c.ownerRefreshService = OwnerRefreshService(
    integrations: c.integrationsRepository,
    portfolio: c.portfolioRepository,
  );

  c.assetRegistrationDraftRepository = AssetRegistrationDraftRepositoryImpl(
    c.assetRegistrationDraftLocal,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // POLICY LAYER
  // ───────────────────────────────────────────────────────────────────────────
  c.policyContextFactory = const DefaultPolicyContextFactory();

  c.automationPolicy = DefaultAutomationPolicy(c.policyContextFactory);
  c.payoutPolicy = DefaultPayoutPolicy(c.policyContextFactory);
  c.accessPolicy = DefaultAccessPolicy(c.policyContextFactory);

  c.policyEngine = PolicyEngine(
    automationPolicy: c.automationPolicy,
    payoutPolicy: c.payoutPolicy,
    accessPolicy: c.accessPolicy,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // SYNC OUTBOX — BASE COMPARTIDA
  // ───────────────────────────────────────────────────────────────────────────
  c.syncOutboxRepository = SyncOutboxRepositoryImpl(isar: isar);

  // ───────────────────────────────────────────────────────────────────────────
  // SYNC ENGINE V2 — GENÉRICO
  // ───────────────────────────────────────────────────────────────────────────
  //
  // Se mantiene instanciado porque forma parte de la infraestructura general.
  // Pero NO es el camino preferido para vehicle:* mientras el dispatcher
  // especializado esté activo.
  // ───────────────────────────────────────────────────────────────────────────
  final syncExecutor = FirestoreSyncExecutor(firestore: firestore);
  final connectivityAdapter = ConnectivityServiceAdapter(service: connectivity);
  final nowProvider = SystemNowProvider();

  c.syncDispatcher = SyncDispatcher(
    outboxRepository: c.syncOutboxRepository,
    executor: syncExecutor,
    workerId: 'main_isolate',
  );

  c.syncEngineService = SyncEngineService(
    dispatcher: c.syncDispatcher,
    clock: nowProvider,
    connectivity: connectivityAdapter,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // ASSET AUDIT SERVICE — V1.3.4
  // ───────────────────────────────────────────────────────────────────────────
  c.assetAuditService = AssetAuditService(
    auditEventsCollectionBuilder: (assetId) => firestore
        .collection(FirestorePaths.assetAuditLog)
        .doc(assetId)
        .collection(FirestorePaths.assetAuditLogEvents),
    enqueueAuditOutboxEntry: (entry) => c.syncOutboxRepository.upsert(entry),
  );

  // ───────────────────────────────────────────────────────────────────────────
  // ASSET SYNC STACK — VEHICLE-SPECIFIC
  // ───────────────────────────────────────────────────────────────────────────
  c.assetFirestoreAdapter = const AssetFirestoreAdapter();

  c.assetSyncQueue = AssetSyncQueue(
    outboxRepo: c.syncOutboxRepository,
    adapter: c.assetFirestoreAdapter,
  );

  c.assetSyncService = AssetSyncService(
    localDs: c.assetLocal,
    remoteDs: c.assetRemote,
    queue: c.assetSyncQueue,
    adapter: c.assetFirestoreAdapter,
  );

  c.assetSyncEngine = AssetSyncEngine(
    localDs: c.assetLocal,
    syncService: c.assetSyncService,
    isar: isar,
  );

  c.syncTelemetry = SyncTelemetry();

  c.assetHistoryArchiveService = AssetHistoryArchiveService(
    firestore: firestore,
    auditService: c.assetAuditService,
    telemetry: c.syncTelemetry,
  );

  c.assetHistoryReconciliationWorker = AssetHistoryReconciliationWorker(
    firestore: firestore,
    archiveService: c.assetHistoryArchiveService,
    telemetry: c.syncTelemetry,
  );

  c.assetSyncDispatcher = AssetSyncDispatcher(
    outboxRepo: c.syncOutboxRepository,
    remoteDs: c.assetRemote,
    syncService: c.assetSyncService,
    adapter: c.assetFirestoreAdapter,
    archiveService: c.assetHistoryArchiveService,
    reconciliationWorker: c.assetHistoryReconciliationWorker,
    telemetry: c.syncTelemetry,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // ALERT SYSTEM V4 — PIPELINE CANÓNICO
  // ───────────────────────────────────────────────────────────────────────────
  c.assetAlertSnapshotAssembler = AssetAlertSnapshotAssembler(
    assetRepository: c.assetRepository,
    insuranceRepository: c.insuranceRepository,
  );

  c.assetComplianceAlertOrchestrator = AssetComplianceAlertOrchestrator(
    assembler: c.assetAlertSnapshotAssembler,
    // buildSoatAlert vive en core/ — se inyecta aquí para que el orquestador
    // (domain) no importe core directamente.
    buildSoatAlert: buildSoatAlert,
  );

  c.homeAlertAggregationService = HomeAlertAggregationService(
    orchestrator: c.assetComplianceAlertOrchestrator,
    assetRepository: c.assetRepository,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // CORE COMMON v1 — DATA SOURCES + MIRROR SERVICES + REPOSITORIES
  // ───────────────────────────────────────────────────────────────────────────
  // DS locales (Isar)
  c.localOrganizationLocal = LocalOrganizationLocalDataSource(isar);
  c.localContactLocal = LocalContactLocalDataSource(isar);
  c.operationalRelationshipLocal =
      OperationalRelationshipLocalDataSource(isar);
  c.operationalRequestLocal = OperationalRequestLocalDataSource(isar);
  c.requestDeliveryLocal = RequestDeliveryLocalDataSource(isar);
  c.matchCandidateLocal = MatchCandidateLocalDataSource(isar);
  c.coordinationFlowLocal = CoordinationFlowLocalDataSource(isar);

  // DS remotos Firestore (SOLO para entidades que Flutter crea: locales del
  // workspace — LocalOrganization y LocalContact viven en el cliente).
  c.localOrganizationFirestore =
      LocalOrganizationFirestoreDataSource(firestore);
  c.localContactFirestore = LocalContactFirestoreDataSource(firestore);

  // DS remotos NestJS (impl HTTP real contra avanzza-core-api).
  // getIdToken extrae el Firebase ID Token y el DS lo inyecta como
  // Authorization: Bearer. Sin sesión activa → UnauthorizedException.
  Future<String?> currentIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.getIdToken();
  }
  c.matchCandidateNestJs = MatchCandidateNestJsDataSourceImpl(
    dio: CoreApiClient.create(),
    getIdToken: currentIdToken,
  );
  c.coordinationFlowApi = CoordinationFlowApiClient(
    dio: CoreApiClient.create(),
    getIdToken: currentIdToken,
  );

  // Repositories
  c.localOrganizationRepository = LocalOrganizationRepositoryImpl(
    local: c.localOrganizationLocal,
    remote: c.localOrganizationFirestore,
    sync: c._syncService,
  );
  c.localContactRepository = LocalContactRepositoryImpl(
    local: c.localContactLocal,
    remote: c.localContactFirestore,
    sync: c._syncService,
  );
  // Cache-only (Core API es SSOT tras inversión de D4).
  c.operationalRelationshipRepository = OperationalRelationshipRepositoryImpl(
    local: c.operationalRelationshipLocal,
  );
  // Cache-only. Escrituras solo por hydrateFromRemote (invocado por
  // CoordinationFlowRepository tras HTTP).
  c.operationalRequestRepository = OperationalRequestRepositoryImpl(
    local: c.operationalRequestLocal,
  );
  c.requestDeliveryRepository = RequestDeliveryRepositoryImpl(
    local: c.requestDeliveryLocal,
  );
  c.matchCandidateRepository = MatchCandidateRepositoryImpl(
    local: c.matchCandidateLocal,
    remote: c.matchCandidateNestJs,
    relationshipRepo: c.operationalRelationshipRepository,
  );
  // CoordinationFlow repo — crea flow+request vía HTTP y hidrata en cache.
  // Core API es fuente de verdad; Isar solo cachea la respuesta.
  c.coordinationFlowRepository = CoordinationFlowRepositoryImpl(
    local: c.coordinationFlowLocal,
    remote: c.coordinationFlowApi,
    requestRepo: c.operationalRequestRepository,
  );

  // Caso de uso F5 Hito 1 — único camino autorizado para crear/actualizar
  // LocalContact disparando probe del matcher remoto.
  c.saveLocalContactWithProbe = SaveLocalContactWithProbe(
    contactRepository: c.localContactRepository,
    matchCandidateRepository: c.matchCandidateRepository,
  );

  // Caso de uso F5 Hito 2 — mismo patrón para LocalOrganization.
  c.saveLocalOrganizationWithProbe = SaveLocalOrganizationWithProbe(
    organizationRepository: c.localOrganizationRepository,
    matchCandidateRepository: c.matchCandidateRepository,
  );

  // Caso de uso F5 Hito 3 — resolución (confirm/dismiss) de un MatchCandidate
  // expuesto. Delegado por MatchResolutionSheet desde los indicadores de UI.
  c.resolveMatchCandidate = ResolveMatchCandidate(
    repo: c.matchCandidateRepository,
  );

  // Caso de uso F5 Hito 11 — primera OperationalRequest real creada desde el
  // badge "Vinculado" (RelationshipActionsSheet → start request dialog).
  // Tras la inversión de D4 llama a Core API (POST /v1/coordination-flows) y
  // queda flow+request hidratados en Isar como cache.
  c.startOperationalRequest = StartOperationalRequest(
    repo: c.coordinationFlowRepository,
  );

  c._isInitialized = true;

  // ignore: avoid_print
  print('[Catalog] version: ${c.catalogRepository.version}');
}

// ─────────────────────────────────────────────────────────────────────────────
// START / STOP DEL SYNC STACK
// ─────────────────────────────────────────────────────────────────────────────
//
// REGLA ACTUAL
// 1. Dispatcher vehicle-specific primero (consumer)
// 2. Engine vehicle-specific después (producer)
// 3. Engine genérico NO se arranca aquí para evitar competencia innecesaria
//    con entries vehicle:*
//
// Cuando existan otras entidades reales en outbox (maintenance, insurance,
// accounting, etc.), esta estrategia puede evolucionar.
// ─────────────────────────────────────────────────────────────────────────────

Future<void> startSyncInfrastructure() async {
  final c = DIContainer();

  if (!c.isInitialized) {
    throw StateError(
      'startSyncInfrastructure() llamado antes de initDI().',
    );
  }

  // Consumer primero: evita backlog temporal.
  c.assetSyncDispatcher.start();

  // Producer después: watchers comienzan cuando ya hay consumidor.
  await c.assetSyncEngine.start();

  // Guardrail: asegurar que el engine genérico no compita por vehicle:*.
  await c.syncEngineService.stop(graceful: true);
}

Future<void> stopSyncInfrastructure() async {
  final c = DIContainer();

  if (!c.isInitialized) {
    return;
  }

  // Orden inverso: primero producer, luego consumer.
  await c.assetSyncEngine.stop();
  c.assetSyncDispatcher.stop();

  // Best-effort: si el engine genérico llegó a estar activo, apagarlo.
  await c.syncEngineService.stop(graceful: true);
}

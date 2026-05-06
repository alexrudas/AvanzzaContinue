// lib/core/di/container.dart
// ignore_for_file: directives_ordering

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/sources/local/bootstrap/bootstrap_sync_state_local_ds.dart';
import '../../data/sources/remote/bootstrap/bootstrap_api_client.dart';
import '../../presentation/controllers/bootstrap/bootstrap_sync_controller.dart';
import '../../data/repositories/accounting_repository_impl.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../data/repositories/asset_registration_draft_repository_impl.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../data/repositories/specialty_catalog_repository_impl.dart';
import '../../data/sources/remote/catalog/specialty_catalog_api_client.dart';
import '../../domain/repositories/catalog/specialty_catalog_repository.dart';
import '../../data/repositories/provider/provider_canonical_repository_impl.dart';
import '../../data/repositories/provider/provider_self_repository_impl.dart';
import '../../data/sources/remote/provider/provider_canonical_api_client.dart';
import '../../data/sources/remote/provider/provider_self_api_client.dart';
import '../../domain/repositories/provider/provider_canonical_repository.dart';
import '../../domain/repositories/provider/provider_self_repository.dart';
import '../../data/repositories/workspace/workspace_asset_type_repository_impl.dart';
import '../../data/sources/remote/workspace/workspace_asset_type_api_client.dart';
import '../../domain/repositories/workspace/workspace_asset_type_repository.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/geo_repository_impl.dart';
import '../../data/repositories/insurance_repository_impl.dart';
import '../../data/repositories/maintenance_repository_impl.dart';
import '../../data/repositories/org_repository_impl.dart';
import '../../data/datasources/integrations_remote_datasource.dart';
import '../../data/local/integrations_local_datasource.dart';
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
import '../../data/datasources/local/onboarding_session_local_ds.dart';
import '../../data/sources/local/user_local_ds.dart';
import '../../domain/services/onboarding/onboarding_session_service.dart';
import '../../data/sources/remote/accounting_remote_ds.dart';
import '../../data/sources/remote/ai_remote_ds.dart';
import '../../data/sources/remote/asset_remote_ds.dart';
import '../../data/sources/remote/chat_remote_ds.dart';
import '../../data/sources/remote/geo_remote_ds.dart';
import '../../data/sources/remote/insurance_remote_ds.dart';
import '../../data/sources/remote/maintenance_remote_ds.dart';
import '../../data/sources/remote/org_remote_ds.dart';
import '../../data/repositories/core_common/asset_actor_link_repository_impl.dart';
import '../../data/repositories/core_common/network_relationship_repository_impl.dart';
import '../../data/sources/remote/core_common/asset_actor_link_api_client.dart';
import '../../data/sources/remote/core_common/relationship_api_client.dart';
import '../../domain/repositories/core_common/asset_actor_link_repository.dart';
import '../../domain/repositories/core_common/network_relationship_repository.dart';
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
import '../../application/services/access/access_gateway.dart';
import '../../application/services/access/access_session_state.dart';
import '../../application/services/access/access_snapshot_service.dart';
import '../../application/services/access/provider_context_store.dart';
import '../../application/services/access/session_capabilities_store.dart';
import '../../data/sources/local/access/access_context_snapshot_local_ds.dart';
import '../../data/remote/interceptors/access_interceptor.dart';
import '../../data/remote/interceptors/api_key_interceptor.dart';
import '../../data/repositories/access_repository_impl.dart';
import '../../data/sources/remote/access/access_api_client.dart';
import '../../domain/repositories/access_repository.dart';
import '../../domain/services/session/active_org_id_provider.dart';
import '../config/api_endpoints.dart';
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

  // ── Core Common v1 — Mi Red Operativa (ADR actor-canon hito 5b) ──────────
  /// Cliente HTTP contra `GET /v1/core-common/asset-actor-links` (hito 5a).
  late final AssetActorLinkApiClient assetActorLinkRemote;

  /// Cliente HTTP contra `/v1/core-common/relationships` (hito 3 CRUD).
  late final RelationshipApiClient networkRelationshipRemote;

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

  /// Datasource Isar para `OnboardingSessionModel`. Privado por contrato:
  /// el único cliente autorizado es `onboardingSessionService`.
  late final OnboardingSessionLocalDataSource onboardingSessionLocal;

  /// Owner único del estado de reanudación del onboarding canónico
  /// (FusionadoFlow). Sustituye el uso legacy de `RegistrationProgress`
  /// como mecanismo de resume.
  late final OnboardingSessionService onboardingSessionService;

  // ── Repositories ──────────────────────────────────────────────────────────
  late final GeoRepository geoRepository;
  late final OrgRepository orgRepository;
  late final UserRepository userRepository;
  late final AssetRepository assetRepository;
  late final MaintenanceRepository maintenanceRepository;
  late final PurchaseRepository purchaseRepository;

  /// ADR actor-canon §2.9 — vínculo actor↔activo (read-only).
  /// Fuente canónica para Mi Red Operativa v2; reemplaza el bypass de
  /// PortfolioEntity que será retirado en hito 5c.
  late final AssetActorLinkRepository assetActorLinkRepository;

  /// ADR actor-canon §5 (hito 3) — CRUD operativo de OperationalRelationship.
  /// Nombrado "network" para no colisionar con OperationalRelationshipRepository
  /// preexistente (que sincroniza Firestore — caso distinto).
  late final NetworkRelationshipRepository networkRelationshipRepository;
  late final AccountingRepository accountingRepository;
  late final InsuranceRepository insuranceRepository;
  late final ChatRepository chatRepository;
  late final AIRepository aiRepository;
  late final CatalogRepository catalogRepository;

  /// Catálogo global de specialties (`/v1/catalog/specialties`).
  /// Read-only contra Core API; backend ya cachea 60s — sin cache local.
  late final SpecialtyCatalogRepository specialtyCatalogRepository;

  /// Provisionamiento canónico de proveedor (Hito 1):
  ///   POST /v1/providers
  ///   GET  /v1/providers/:providerProfileId
  ///   PUT  /v1/providers/:providerProfileId/specialties
  /// SSOT en Postgres via Core API; sin cache local.
  late final ProviderCanonicalRepository providerCanonicalRepository;

  /// Provider self-onboarding (MF1):
  ///   POST /v1/providers/bootstrap   → SELF bootstrap + provider_admin_role
  ///   GET  /v1/providers/me          → vista agregada self
  /// SSOT en Postgres via Core API; sin cache local (M2 introduce Isar).
  late final ProviderSelfRepository providerSelfRepository;

  /// AssetTypes que el workspace activo opera (`GET /v1/core-common/
  /// workspaces/me/asset-types`). Reemplaza la lista hardcodeada
  /// `kKnownAssetTypes` que se eliminó al introducir resolución dinámica.
  late final WorkspaceAssetTypeRepository workspaceAssetTypeRepository;
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

  // ── Access Stack (Core API /v1/access + /v1/auth/bootstrap) ──────────────
  // Contrato "Flutter ↔ Core API Access": GET /v1/access/me/context + POST
  // /v1/auth/bootstrap, con interceptor reactivo anti-loop sobre coreDio.
  // `AccessGateway` orquesta el flujo proactivo desde Splash/AuthState.
  // `AccessSessionState` mantiene el flag bootstrapAttempted y el mutex
  // single-flight. `SessionCapabilitiesStore` publica las capabilities
  // resueltas como Rx para que widgets puedan habilitar/ocultar UI.
  late final AccessSessionState accessSessionState;
  late final SessionCapabilitiesStore sessionCapabilitiesStore;
  late final ProviderContextStore providerContextStore;
  late final AccessApiClient accessApiClient;
  late final AccessRepository accessRepository;
  late final AccessGateway accessGateway;
  // Snapshot persistido del estado de acceso. Permite cold starts local-first
  // sin esperar a Core API para hidratar capabilities/isOwner/isProvider.
  late final LocalAccessSnapshotDS accessSnapshotLocalDs;
  late final AccessSnapshotService accessSnapshotService;

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

  // ── HTTP Clients (Core vs Integrations) ───────────────────────────────────
  // Dos Dio completamente aislados, registrados con tag en GetX para hacer
  // imposible inyectar el cliente equivocado. Interceptores y baseUrl
  // confinados al factory — prohibido mutar después de construir.
  //
  //   Dio(tag:'core')         → Avanzza Core API (Pedidos, Proveedores,
  //                              Coordinación). Auth: Bearer Firebase.
  //   Dio(tag:'integrations') → RUNT / SIMIT. Auth: X-API-Key.
  final coreDio = _buildCoreDio();
  final integrationsDio = _buildIntegrationsDio();

  if (!Get.isRegistered<Dio>(tag: 'core')) {
    Get.put<Dio>(coreDio, tag: 'core', permanent: true);
  }
  if (!Get.isRegistered<Dio>(tag: 'integrations')) {
    Get.put<Dio>(integrationsDio, tag: 'integrations', permanent: true);
  }

  if (!Get.isRegistered<OfflineSyncService>()) {
    Get.put<OfflineSyncService>(c.syncService, permanent: true);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // BOOTSTRAP SYNC — orquesta POST /v1/bootstrap en background tras
  // "Ingresar a mi cuenta" (local-first). El usuario navega al workspace
  // ANTES de que el sync complete; el controller mantiene el state machine
  // visible vía Rx para que la UI muestre banner "Preparando tu cuenta…"
  // / botón "Reintentar" sin bloquear navegación.
  // ───────────────────────────────────────────────────────────────────────────
  if (!Get.isRegistered<BootstrapApiClient>()) {
    Get.put<BootstrapApiClient>(
      BootstrapApiClient(dio: coreDio),
      permanent: true,
    );
  }
  if (!Get.isRegistered<BootstrapSyncStateLocalDS>()) {
    Get.put<BootstrapSyncStateLocalDS>(
      BootstrapSyncStateLocalDS(isar),
      permanent: true,
    );
  }
  if (!Get.isRegistered<BootstrapSyncController>()) {
    Get.put<BootstrapSyncController>(
      BootstrapSyncController(
        api: Get.find<BootstrapApiClient>(),
        localDs: Get.find<BootstrapSyncStateLocalDS>(),
      ),
      permanent: true,
    );
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
  // Compras: Core API es la única fuente remota (F5 Hito 17). Usa el Dio
  // tag:'core' con baseUrl=ApiEndpoints.coreBaseUrl y Bearer Firebase.
  c.purchaseRemote = PurchaseApiClient(
    dio: coreDio,
    getIdToken: () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      return user.getIdToken();
    },
  );

  // ── Core Common v1 — Mi Red Operativa (ADR actor-canon hito 5b) ──────────
  // Todos los Api Clients de Core Common usan el único Dio tag:'core'.
  c.assetActorLinkRemote = AssetActorLinkApiClient(
    dio: coreDio,
    getIdToken: () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      return user.getIdToken();
    },
  );
  c.networkRelationshipRemote = RelationshipApiClient(
    dio: coreDio,
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

  // Onboarding session — ownership único de la reanudación del FusionadoFlow.
  c.onboardingSessionLocal = OnboardingSessionLocalDataSource(isar);
  c.onboardingSessionService = OnboardingSessionService(
    local: c.onboardingSessionLocal,
  );

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

  // ── Access Stack wiring ───────────────────────────────────────────────────
  // Orden deliberado:
  //   1) AccessSessionState + SessionCapabilitiesStore (state holders puros).
  //   2) AccessApiClient sobre coreDio (marca sus requests con
  //      skipAccessInterceptor para evitar recursión).
  //   3) AccessRepository (impl thin).
  //   4) AccessGateway (flujo proactivo) + AccessInterceptor (flujo reactivo)
  //      comparten el mismo AccessSessionState y el mismo callback de token
  //      refresh (`FirebaseAuth.currentUser.getIdToken(forceRefresh)`).
  //   5) El interceptor se agrega al coreDio DESPUÉS del _CoreBearerInterceptor
  //      para que los retries internos reciban el Bearer actualizado.
  //
  // `resolveLocalOrgId`: delega dinámicamente en `ActiveOrgIdProvider` si
  // está registrado en GetX. La implementación concreta
  // (`SessionActiveOrgIdProvider`) la registran `SplashBinding` / `HomeBinding`
  // tras `SessionContextController`. Si aún no está registrado (p. ej.
  // primeras fases del arranque antes del splash), retorna null y el
  // gateway/interceptor degradan a SELECT_WORKSPACE sin inventar valores.
  // Esto preserva la regla "core/di NO importa presentation": container.dart
  // solo depende de la interface en domain.
  c.accessSessionState = AccessSessionState();
  c.sessionCapabilitiesStore = SessionCapabilitiesStore();
  c.providerContextStore = ProviderContextStore();
  // Snapshot persistido del access: DS sobre Isar + servicio orquestador.
  // El servicio se inyecta al gateway (escribe en cada SERVER_REFRESH /
  // limpia en logout/switch) y al splash/onboarding (lee/escribe LOCAL_BOOTSTRAP).
  c.accessSnapshotLocalDs = LocalAccessSnapshotDS(c.isar);
  c.accessSnapshotService = AccessSnapshotService(
    ds: c.accessSnapshotLocalDs,
    capabilitiesStore: c.sessionCapabilitiesStore,
    providerContextStore: c.providerContextStore,
  );
  c.accessApiClient = AccessApiClient(
    dio: coreDio,
    getIdToken: () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      return user.getIdToken();
    },
  );
  c.accessRepository = AccessRepositoryImpl(client: c.accessApiClient);

  Future<String?> refreshIdToken({bool forceRefresh = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }

  String? resolveLocalOrgId() {
    if (!Get.isRegistered<ActiveOrgIdProvider>()) return null;
    try {
      return Get.find<ActiveOrgIdProvider>().activeOrgId;
    } catch (_) {
      return null;
    }
  }

  c.accessGateway = AccessGateway(
    repository: c.accessRepository,
    sessionState: c.accessSessionState,
    capabilitiesStore: c.sessionCapabilitiesStore,
    providerContextStore: c.providerContextStore,
    snapshotService: c.accessSnapshotService,
    refreshIdToken: refreshIdToken,
    resolveLocalOrgId: resolveLocalOrgId,
    resolveCurrentUid: () => FirebaseAuth.instance.currentUser?.uid,
  );

  coreDio.interceptors.add(AccessInterceptor(
    dio: coreDio,
    repository: c.accessRepository,
    sessionState: c.accessSessionState,
    refreshIdToken: refreshIdToken,
    resolveLocalOrgId: resolveLocalOrgId,
  ));

  // Exponer a GetX como permanent para que Splash/Controllers hagan
  // Get.find<AccessGateway>() sin pasar por DIContainer.
  if (!Get.isRegistered<AccessSessionState>()) {
    Get.put<AccessSessionState>(c.accessSessionState, permanent: true);
  }
  if (!Get.isRegistered<SessionCapabilitiesStore>()) {
    Get.put<SessionCapabilitiesStore>(c.sessionCapabilitiesStore,
        permanent: true);
  }
  if (!Get.isRegistered<ProviderContextStore>()) {
    Get.put<ProviderContextStore>(c.providerContextStore, permanent: true);
  }
  if (!Get.isRegistered<AccessRepository>()) {
    Get.put<AccessRepository>(c.accessRepository, permanent: true);
  }
  if (!Get.isRegistered<AccessGateway>()) {
    Get.put<AccessGateway>(c.accessGateway, permanent: true);
  }
  if (!Get.isRegistered<AccessSnapshotService>()) {
    Get.put<AccessSnapshotService>(c.accessSnapshotService, permanent: true);
  }

  // AssetActorLinkRepository se inicializa ANTES que AssetRepositoryImpl
  // porque éste último lo recibe como dependencia para declarar
  // vínculos canónicos (`source=user_declared`) cuando se registra un
  // activo. Ver `AssetRepositoryImpl._enqueueDeclareAssetActorLink`.
  c.assetActorLinkRepository = AssetActorLinkRepositoryImpl(
    client: c.assetActorLinkRemote,
  );

  c.assetRepository = AssetRepositoryImpl(
    local: c.assetLocal,
    remote: c.assetRemote,
    enqueueSync: c.syncService.enqueue,
    portfolioLocalDS: c.portfolioLocal,
    assetActorLinks: c.assetActorLinkRepository,
  );

  c.maintenanceRepository = MaintenanceRepositoryImpl(
    local: c.maintenanceLocal,
    remote: c.maintenanceRemote,
  );

  c.purchaseRepository = PurchaseRepositoryImpl(
    local: c.purchaseLocal,
    remote: c.purchaseRemote,
  );

  // ── Core Common v1 — Mi Red Operativa (ADR actor-canon hito 5b) ──────────
  c.networkRelationshipRepository = NetworkRelationshipRepositoryImpl(
    client: c.networkRelationshipRemote,
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

  // Catálogo global de specialties (Core API). Mismo patrón que el resto
  // de api clients: Dio tag:'core' + getIdToken Firebase. Sin cache local.
  c.specialtyCatalogRepository = SpecialtyCatalogRepositoryImpl(
    client: SpecialtyCatalogApiClient(
      dio: coreDio,
      getIdToken: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return null;
        return user.getIdToken();
      },
    ),
  );

  // Provisionamiento canónico de proveedor (Hito 1). Mismo Dio tag:'core'
  // + getIdToken Firebase. Sin cache local — la SSOT vive en Postgres
  // via Core API. Las excepciones tipadas
  // (`AmbiguousPlatformActorException`, `LocalRefNotFoundException`,
  // `ProviderProfileNotFoundException`, `WorkspaceNotFoundException`) se
  // mapean dentro del ApiClient para que el controller pueda ramificar UX.
  c.providerCanonicalRepository = ProviderCanonicalRepositoryImpl(
    client: ProviderCanonicalApiClient(
      dio: coreDio,
      getIdToken: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return null;
        return user.getIdToken();
      },
    ),
  );

  // Provider self-onboarding (MF1): bootstrap + me. Reusa coreDio (con
  // _CoreBearerInterceptor + AccessInterceptor) y el mismo proveedor de
  // ID token Firebase. Sin cache local (online-first; M2 → Isar).
  c.providerSelfRepository = ProviderSelfRepositoryImpl(
    api: ProviderSelfApiClient(
      dio: coreDio,
      getIdToken: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return null;
        return user.getIdToken();
      },
    ),
  );

  // Workspace asset-types (Core API). Mismo patrón canónico:
  // Dio tag:'core' + getIdToken Firebase. Sin cache local. Lo consume
  // `ProviderFormController` para alimentar el dropdown del selector
  // de specialties.
  c.workspaceAssetTypeRepository = WorkspaceAssetTypeRepositoryImpl(
    client: WorkspaceAssetTypeApiClient(
      dio: coreDio,
      getIdToken: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return null;
        return user.getIdToken();
      },
    ),
  );

  c.workspaceRepository = WorkspaceRepositoryImpl(
    isar: isar,
    prefsProvider: SharedPreferences.getInstance,
  );

  c.portfolioRepository = PortfolioRepositoryImpl(
    local: c.portfolioLocal,
  );

  // ── Integrations (RUNT Persona + SIMIT) ─────────────────────────────────
  // Usa el Dio tag:'integrations' con baseUrl=ApiEndpoints.integrationsBaseUrl
  // y X-API-Key. Ningún otro dominio puede ver este cliente.
  c.integrationsRepository = IntegrationsRepositoryImpl(
    remote: IntegrationsRemoteDatasource(integrationsDio),
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
  // Match Candidate + Coordination Flow usan el Dio tag:'core' (mismo que
  // PurchaseApiClient y el resto de Core Common).
  c.matchCandidateNestJs = MatchCandidateNestJsDataSourceImpl(
    dio: coreDio,
    getIdToken: currentIdToken,
  );
  c.coordinationFlowApi = CoordinationFlowApiClient(
    dio: coreDio,
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

// ─────────────────────────────────────────────────────────────────────────────
// HTTP CLIENT FACTORIES (Core vs Integrations) — aislamiento total
// ─────────────────────────────────────────────────────────────────────────────
//
// Dos Dio completamente separados. Interceptores se agregan SOLO dentro del
// factory; ningún consumer puede mutar el Dio después. Tags 'core' e
// 'integrations' en GetX para inyección nombrada.
//
//   coreDio         → baseUrl = ApiEndpoints.coreBaseUrl
//                     interceptores: [_CoreBearerInterceptor, LogInterceptor]
//   integrationsDio → baseUrl = ApiEndpoints.integrationsBaseUrl
//                     interceptores: [ApiKeyInterceptor, LogInterceptor]
// ─────────────────────────────────────────────────────────────────────────────

Dio _buildCoreDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.coreBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      followRedirects: true,
      maxRedirects: 3,
    ),
  );
  dio.interceptors.add(_CoreBearerInterceptor());
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[CORE] $obj'),
      ),
    );
  }
  return dio;
}

Dio _buildIntegrationsDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.integrationsBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      followRedirects: true,
      maxRedirects: 3,
    ),
  );
  dio.interceptors.add(ApiKeyInterceptor());
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[INTEGRATIONS] $obj'),
      ),
    );
  }
  return dio;
}

/// Interceptor único de auth para [coreDio]: inyecta
/// `Authorization: Bearer <firebase-id-token>` cuando hay sesión activa.
///
/// Si el caller ya setó `Authorization` en [Options.headers] (p.ej. los
/// `*ApiClient._authOptions()`), respeta su valor para evitar pisar un token
/// recién refrescado por el caller.
///
/// FAIL-FAST: si no hay sesión Firebase activa o `getIdToken()` falla, el
/// request se rechaza pre-flight con un 401 sintético (`code=
/// MISSING_AUTH_TOKEN_CLIENT`). Antes este caso pasaba silenciosamente y el
/// request salía sin `Authorization`, llegando al backend como
/// `MISSING_AUTH_TOKEN` y, peor, presentándose en UI como "Sin conexión"
/// cuando en realidad era un fallo de identidad. Sintetizar el 401 reusa el
/// mismo pipeline de error que un 401 real (cada `*ApiClient._mapDioError`
/// ya traduce 401 → `UnauthorizedException`), sin tocar 10 mappers.
class _CoreBearerInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers.containsKey('Authorization')) {
      handler.next(options);
      return;
    }

    String? token;
    try {
      token = await FirebaseAuth.instance.currentUser?.getIdToken();
    } catch (e) {
      debugPrint('[CORE] Bearer token fetch failed: $e');
      handler.reject(_synthetic401(options, 'TOKEN_FETCH_FAILED', '$e'));
      return;
    }

    if (token == null || token.isEmpty) {
      handler.reject(_synthetic401(options, 'MISSING_AUTH_TOKEN_CLIENT',
          'No active Firebase session (no ID token).'));
      return;
    }

    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  /// Construye un `DioException` con `Response(401)` sintético. El payload
  /// imita la shape canónica del backend (`{code, message}`) para que
  /// `*ApiClient._mapDioError` lo trate como cualquier otro 401 y emita
  /// `UnauthorizedException`.
  DioException _synthetic401(
    RequestOptions options,
    String code,
    String message,
  ) {
    final response = Response<dynamic>(
      requestOptions: options,
      statusCode: 401,
      statusMessage: 'Unauthorized (client pre-flight)',
      data: <String, dynamic>{'code': code, 'message': message},
    );
    return DioException(
      requestOptions: options,
      response: response,
      type: DioExceptionType.badResponse,
      error: message,
      message: message,
    );
  }
}

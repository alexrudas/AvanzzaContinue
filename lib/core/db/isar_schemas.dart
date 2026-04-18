import 'package:avanzza/data/local/integrations_local_datasource.dart';
import 'package:avanzza/data/models/accounting/accounting_entry_model.dart';
import 'package:avanzza/data/models/accounting/adjustment_model.dart';
import 'package:avanzza/data/models/ai/ai_advisor_model.dart';
import 'package:avanzza/data/models/ai/ai_audit_log_model.dart';
import 'package:avanzza/data/models/ai/ai_prediction_model.dart';
import 'package:avanzza/data/models/asset/asset_document_model.dart';
import 'package:avanzza/data/models/asset/asset_model.dart';
import 'package:avanzza/data/models/asset/asset_registration_draft_model.dart';
import 'package:avanzza/data/models/asset/special/asset_inmueble_model.dart';
import 'package:avanzza/data/models/asset/special/asset_maquinaria_model.dart';
import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/models/auth/registration_progress_model.dart';
import 'package:avanzza/data/models/cache/user_profile_cache_model.dart';
import 'package:avanzza/data/models/campaign/campaign_frequency_model.dart';
import 'package:avanzza/data/models/chat/broadcast_message_model.dart';
import 'package:avanzza/data/models/chat/chat_message_model.dart';
// Core Common v1 — red local + actor de plataforma + relaciones/solicitudes/flows.
import 'package:avanzza/data/models/core_common/coordination_flow_model.dart';
import 'package:avanzza/data/models/core_common/local_contact_model.dart';
import 'package:avanzza/data/models/core_common/local_organization_model.dart';
import 'package:avanzza/data/models/core_common/match_candidate_model.dart';
import 'package:avanzza/data/models/core_common/operational_relationship_model.dart';
import 'package:avanzza/data/models/core_common/operational_request_model.dart';
import 'package:avanzza/data/models/core_common/platform_actor_model.dart';
import 'package:avanzza/data/models/core_common/request_delivery_model.dart';
import 'package:avanzza/data/models/geo/city_model.dart';
import 'package:avanzza/data/models/geo/country_model.dart';
import 'package:avanzza/data/models/geo/local_regulation_model.dart';
import 'package:avanzza/data/models/geo/region_model.dart';
import 'package:avanzza/data/models/insurance/insurance_policy_model.dart';
import 'package:avanzza/data/models/insurance/insurance_purchase_model.dart';
import 'package:avanzza/data/models/maintenance/incidencia_model.dart';
import 'package:avanzza/data/models/maintenance/maintenance_finished_model.dart';
import 'package:avanzza/data/models/maintenance/maintenance_process_model.dart';
import 'package:avanzza/data/models/maintenance/maintenance_programming_model.dart';
import 'package:avanzza/data/models/org/organization_model.dart';
import 'package:avanzza/data/models/portfolio/portfolio_model.dart';
import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/models/purchase/supplier_response_model.dart';
import 'package:avanzza/data/models/settings/theme_pref_model.dart';
import 'package:avanzza/data/models/user/membership_model.dart';
import 'package:avanzza/data/models/user/user_model.dart';
import 'package:avanzza/data/models/user_session_model.dart';
import 'package:avanzza/data/models/workspace/workspace_lite_model.dart';
import 'package:avanzza/data/models/workspace/workspace_state_model.dart';

import '../../infrastructure/isar/entities/account_receivable_projection_entity.dart';
import '../../infrastructure/isar/entities/accounting_event_entity.dart';
import '../../infrastructure/isar/entities/outbox_event_entity.dart';
import '../../infrastructure/local/isar/models/sync/sync_outbox_entry_model.dart';

final allIsarSchemas = [
  // Integrations — RUNT Persona + SIMIT cache (generados por build_runner)
  IntegrationsRuntPersonCacheModelSchema,
  IntegrationsSimitCacheModelSchema,

  // Sync Outbox
  SyncOutboxEntryModelSchema,

  // Audit Trail — P2-D
  AccountingEventEntitySchema,
  AccountReceivableProjectionEntitySchema,
  OutboxEventEntitySchema,

  AccountingEntryModelSchema,
  AdjustmentModelSchema,
  AIAdvisorModelSchema,
  AIAuditLogModelSchema,
  AIPredictionModelSchema,
  AssetDocumentModelSchema,
  AssetInmuebleModelSchema,
  AssetRegistrationDraftModelSchema,
  AssetMaquinariaModelSchema,
  AssetModelSchema,
  AssetVehiculoModelSchema,
  BroadcastMessageModelSchema,
  CampaignFrequencyModelSchema,
  ChatMessageModelSchema,
  CityModelSchema,
  CountryModelSchema,
  IncidenciaModelSchema,
  InsurancePolicyModelSchema,
  InsurancePurchaseModelSchema,

  // Core Common v1 — red local + relaciones + solicitudes + flows (8 colecciones).
  CoordinationFlowModelSchema,
  LocalContactModelSchema,
  LocalOrganizationModelSchema,
  MatchCandidateModelSchema,
  OperationalRelationshipModelSchema,
  OperationalRequestModelSchema,
  PlatformActorModelSchema,
  RequestDeliveryModelSchema,

  LocalRegulationModelSchema,
  MaintenanceFinishedModelSchema,
  MaintenanceProcessModelSchema,
  MaintenanceProgrammingModelSchema,
  MembershipModelSchema,
  OrganizationModelSchema,
  PortfolioModelSchema,
  PurchaseRequestModelSchema,
  RegionModelSchema,
  RegistrationProgressModelSchema,
  SupplierResponseModelSchema,
  ThemePreferenceModelSchema,
  UserModelSchema,
  UserProfileCacheModelSchema,
  UserSessionModelSchema,
  WorkspaceLiteModelSchema,
  WorkspaceStateModelSchema,
];

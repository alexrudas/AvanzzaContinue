import 'package:avanzza/data/models/accounting/accounting_entry_model.dart';
import 'package:avanzza/data/models/accounting/adjustment_model.dart';
import 'package:avanzza/data/models/ai/ai_advisor_model.dart';
import 'package:avanzza/data/models/ai/ai_audit_log_model.dart';
import 'package:avanzza/data/models/ai/ai_prediction_model.dart';
import 'package:avanzza/data/models/asset/asset_document_model.dart';
import 'package:avanzza/data/models/asset/asset_model.dart';
import 'package:avanzza/data/models/asset/special/asset_inmueble_model.dart';
import 'package:avanzza/data/models/asset/special/asset_maquinaria_model.dart';
import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/models/auth/registration_progress_model.dart';
import 'package:avanzza/data/models/cache/user_profile_cache_model.dart';
import 'package:avanzza/data/models/campaign/campaign_frequency_model.dart';
import 'package:avanzza/data/models/chat/broadcast_message_model.dart';
import 'package:avanzza/data/models/chat/chat_message_model.dart';
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
import 'package:avanzza/data/models/purchase/purchase_request_model.dart';
import 'package:avanzza/data/models/purchase/supplier_response_model.dart';
import 'package:avanzza/data/models/settings/theme_pref_model.dart';
import 'package:avanzza/data/models/user/membership_model.dart';
import 'package:avanzza/data/models/user/user_model.dart';
import 'package:avanzza/data/models/user_session_model.dart';
import 'package:avanzza/data/models/workspace/workspace_lite_model.dart';
import 'package:avanzza/data/models/workspace/workspace_state_model.dart';

final allIsarSchemas = [
  AccountingEntryModelSchema,
  AdjustmentModelSchema,
  AIAdvisorModelSchema,
  AIAuditLogModelSchema,
  AIPredictionModelSchema,
  AssetDocumentModelSchema,
  AssetInmuebleModelSchema,
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
  LocalRegulationModelSchema,
  MaintenanceFinishedModelSchema,
  MaintenanceProcessModelSchema,
  MaintenanceProgrammingModelSchema,
  MembershipModelSchema,
  OrganizationModelSchema,
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

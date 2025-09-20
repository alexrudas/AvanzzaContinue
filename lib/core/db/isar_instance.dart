import 'package:avanzza/data/models/cache/user_profile_cache_model.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart' as pp;

import '../../data/models/accounting/accounting_entry_model.dart';
import '../../data/models/accounting/adjustment_model.dart';
import '../../data/models/ai/ai_advisor_model.dart';
import '../../data/models/ai/ai_audit_log_model.dart';
import '../../data/models/ai/ai_prediction_model.dart';
import '../../data/models/asset/asset_document_model.dart';
import '../../data/models/asset/asset_model.dart';
import '../../data/models/asset/special/asset_inmueble_model.dart';
import '../../data/models/asset/special/asset_maquinaria_model.dart';
import '../../data/models/asset/special/asset_vehiculo_model.dart';
import '../../data/models/chat/broadcast_message_model.dart';
import '../../data/models/chat/chat_message_model.dart';
import '../../data/models/geo/city_model.dart';
// Import all generated schemas here

import '../../data/models/geo/country_model.dart';
import '../../data/models/geo/local_regulation_model.dart';
import '../../data/models/geo/region_model.dart';
import '../../data/models/insurance/insurance_policy_model.dart';
import '../../data/models/insurance/insurance_purchase_model.dart';
import '../../data/models/maintenance/incidencia_model.dart';
import '../../data/models/maintenance/maintenance_finished_model.dart';
import '../../data/models/maintenance/maintenance_process_model.dart';
import '../../data/models/maintenance/maintenance_programming_model.dart';
import '../../data/models/org/organization_model.dart';
import '../../data/models/purchase/purchase_request_model.dart';
import '../../data/models/purchase/supplier_response_model.dart';
import '../../data/models/user/membership_model.dart';
import '../../data/models/user/user_model.dart';
import '../../data/models/auth/registration_progress_model.dart';

Future<Isar> openIsar() async {
  final dir = await pp.getApplicationDocumentsDirectory();
  return Isar.open(
    [
      CountryModelSchema,
      RegionModelSchema,
      CityModelSchema,
      LocalRegulationModelSchema,
      OrganizationModelSchema,
      UserModelSchema,
      MembershipModelSchema,
      AssetModelSchema,
      AssetDocumentModelSchema,
      AssetVehiculoModelSchema,
      AssetInmuebleModelSchema,
      AssetMaquinariaModelSchema,
      IncidenciaModelSchema,
      MaintenanceProgrammingModelSchema,
      MaintenanceProcessModelSchema,
      MaintenanceFinishedModelSchema,
      PurchaseRequestModelSchema,
      SupplierResponseModelSchema,
      AccountingEntryModelSchema,
      AdjustmentModelSchema,
      InsurancePolicyModelSchema,
      InsurancePurchaseModelSchema,
      ChatMessageModelSchema,
      BroadcastMessageModelSchema,
      AIAdvisorModelSchema,
      AIPredictionModelSchema,
      AIAuditLogModelSchema,
      UserProfileCacheModelSchema,
      RegistrationProgressModelSchema
    ],
    directory: dir.path,
    inspector: true,
  );
}

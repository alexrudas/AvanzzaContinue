import 'package:avanzza/data/models/asset/asset_model.dart';
import 'package:avanzza/data/models/auth/registration_progress_model.dart';
import 'package:avanzza/data/models/campaign/campaign_frequency_model.dart';
import 'package:avanzza/data/models/geo/city_model.dart';
import 'package:avanzza/data/models/geo/country_model.dart';
import 'package:avanzza/data/models/geo/region_model.dart';
import 'package:avanzza/data/models/maintenance/incidencia_model.dart';
import 'package:avanzza/data/models/org/organization_model.dart';
import 'package:avanzza/data/models/settings/theme_pref_model.dart';
import 'package:avanzza/data/models/user/membership_model.dart';
import 'package:avanzza/data/models/user/user_model.dart';
import 'package:avanzza/data/models/workspace/workspace_lite_model.dart';
import 'package:avanzza/data/models/workspace/workspace_state_model.dart';

final allIsarSchemas = [
  AssetModelSchema,
  CampaignFrequencyModelSchema,
  CityModelSchema,
  RegionModelSchema,
  CountryModelSchema,
  OrganizationModelSchema,
  MembershipModelSchema,
  IncidenciaModelSchema,
  RegistrationProgressModelSchema,
  ThemePreferenceModelSchema,
  WorkspaceLiteModelSchema,
  WorkspaceStateModelSchema,
  UserModelSchema
];

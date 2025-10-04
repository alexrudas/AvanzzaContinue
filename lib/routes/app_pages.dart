import 'package:avanzza/presentation/pages/asset_list_page.dart';
import 'package:get/get.dart';

import '../presentation/auth/pages/auth_welcome_page.dart';
import '../presentation/auth/pages/email_optional_page.dart';
import '../presentation/auth/pages/id_scan_page.dart';
import '../presentation/auth/pages/login_username_password_page.dart';
import '../presentation/auth/pages/mfa_otp_page.dart';
import '../presentation/auth/pages/otp_verify_page.dart';
import '../presentation/auth/pages/phone_input_page.dart';
import '../presentation/auth/pages/provider_asset_types_page.dart';
import '../presentation/auth/pages/provider_categories_page.dart';
import '../presentation/auth/pages/provider_coverage_page.dart';
import '../presentation/auth/pages/provider_segments_page.dart';
import '../presentation/auth/pages/provider_subtype_page.dart';
import '../presentation/auth/pages/select_country_city_page.dart';
import '../presentation/auth/pages/select_holder_type_page.dart';
import '../presentation/auth/pages/select_role_page.dart';
import '../presentation/auth/pages/summary_page.dart';
import '../presentation/auth/pages/terms_page.dart';
import '../presentation/auth/pages/username_password_page.dart';
import '../presentation/bindings/home_binding.dart';
import '../presentation/home/pages/home_router.dart';
import '../presentation/pages/incidencia_page.dart';
import '../presentation/pages/org_selection_page.dart';
import '../presentation/pages/purchase_request_page.dart';

class Routes {
  static const welcome = '/auth/welcome';
  static const phone = '/auth/phone';
  static const otp = '/auth/otp';
  static const countryCity = '/auth/country-city';
  static const role = '/auth/role';
  static const home = '/home';
  static const orgSelect = '/org_select';

  // Nuevas rutas
  static const registerUsername = '/auth/register/username';
  static const registerEmail = '/auth/register/email';
  static const registerIdScan = '/auth/register/id-scan';
  static const registerTerms = '/auth/register/terms';
  static const loginUserPass = '/auth/login';
  static const loginMfa = '/auth/login/mfa';
  static const registerSummary = '/auth/register/summary';
  static const holderType = '/auth/holder-type';
  static const providerSubtype = '/auth/provider/subtype';
  static const providerCategories = '/auth/provider/categories';
  static const providerAssetTypes = '/auth/provider/asset-types';
  static const providerSegments = '/auth/provider/segments';
  static const providerCoverage = '/auth/provider/coverage';

  // Módulos ya existentes
  static const incidencia = '/incidencia';
  static const purchase = '/purchase';

  static const String assets = '/assets';

  static final pages = <GetPage<dynamic>>[
    GetPage(name: welcome, page: () => AuthWelcomePage()),
    GetPage(name: phone, page: () => const PhoneInputPage()),
    GetPage(name: otp, page: () => const OtpVerifyPage()),
    GetPage(name: countryCity, page: () => const SelectCountryCityPage()),
    GetPage(name: role, page: () => const SelectRolePage()),
    GetPage(name: orgSelect, page: () => const OrgSelectionPage()),

    // HomeRouter decide workspace según activeContext
    GetPage(name: home, page: () => const HomeRouter(), binding: HomeBinding()),

    // Nuevas
    GetPage(name: registerUsername, page: () => const UsernamePasswordPage()),
    GetPage(name: registerEmail, page: () => const EmailOptionalPage()),
    GetPage(name: registerIdScan, page: () => const IdScanPage()),
    GetPage(name: registerTerms, page: () => const TermsPage()),
    GetPage(name: loginUserPass, page: () => const LoginUsernamePasswordPage()),
    GetPage(name: loginMfa, page: () => const MfaOtpPage()),
    GetPage(name: registerSummary, page: () => const SummaryPage()),
    GetPage(name: holderType, page: () => const SelectHolderTypePage()),
    GetPage(name: providerSubtype, page: () => const ProviderSubtypePage()),
    GetPage(
        name: providerCategories, page: () => const ProviderCategoriesPage()),
    GetPage(
        name: providerAssetTypes, page: () => const ProviderAssetTypesPage()),
    GetPage(name: providerSegments, page: () => const ProviderSegmentsPage()),
    GetPage(name: providerCoverage, page: () => const ProviderCoveragePage()),

    // Módulos legacy
    GetPage(
        name: incidencia,
        page: () => const IncidenciaPage(assetId: 'asset_mock')),
    GetPage(name: purchase, page: () => const PurchaseRequestPage()),

    GetPage(name: assets, page: () => const AssetListPage()),
  ];
}

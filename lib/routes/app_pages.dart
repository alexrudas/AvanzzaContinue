import 'package:avanzza/presentation/pages/asset_list_page.dart';
import 'package:avanzza/presentation/pages/workspaces/provider_articles_workspace_page.dart'
    show ProviderArticlesWorkspacePage;
import 'package:avanzza/presentation/pages/workspaces/provider_services_workspace_page.dart';
import 'package:get/get.dart';

import '../presentation/auth/pages/auth_welcome_page.dart';
import '../presentation/auth/pages/email_optional_page.dart';
import '../presentation/auth/pages/id_scan_page.dart';
import '../presentation/auth/pages/login_username_password_page.dart';
import '../presentation/auth/pages/mfa_otp_page.dart';
import '../presentation/auth/pages/otp_verify_page.dart';
import '../presentation/auth/pages/phone_input_page.dart';
import '../presentation/auth/pages/provider_coverage_page.dart';
import '../presentation/auth/pages/provider_profile_page.dart';
import '../presentation/auth/pages/select_country_city_page.dart';
import '../presentation/auth/pages/select_profile_page.dart';
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
  static const role = '/auth/role'; // legacy alias
  static const profile = '/auth/profile';
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
  static const providerProfile = '/auth/provider/profile';

  static const providerCoverage = '/auth/provider/coverage';
  static const providerHomeArticles = '/provider/home/articles';
  static const providerHomeServices = '/provider/home/services';
  static const providerWorkspaceArticles = '/provider/workspace/articles';
  static const providerWorkspaceServices = '/provider/workspace/services';

  // Módulos ya existentes
  static const incidencia = '/incidencia';
  static const purchase = '/purchase';

  static const String assets = '/assets';

  static final pages = <GetPage<dynamic>>[
    GetPage(name: welcome, page: () => AuthWelcomePage()),
    GetPage(name: phone, page: () => const PhoneInputPage()),
    GetPage(name: otp, page: () => const OtpVerifyPage()),
    GetPage(name: countryCity, page: () => const SelectCountryCityPage()),
    GetPage(name: profile, page: () => const SelectProfilePage()),
    // legacy aliases
    GetPage(name: role, page: () => const SelectProfilePage()),
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
    // legacy alias
    GetPage(name: holderType, page: () => const SelectProfilePage()),
    // Perfil proveedor unificado y alias legacy
    GetPage(name: providerProfile, page: () => const ProviderProfilePage()),

    GetPage(name: providerCoverage, page: () => const ProviderCoveragePage()),
    GetPage(
        name: providerHomeArticles,
        page: () => const ProviderArticlesWorkspacePage()),
    GetPage(
        name: providerHomeServices,
        page: () => const ProviderServicesWorkspacePage()),
    GetPage(
        name: providerWorkspaceArticles,
        page: () => const ProviderArticlesWorkspacePage()),
    GetPage(
        name: providerWorkspaceServices,
        page: () => const ProviderServicesWorkspacePage()),

    // Módulos legacy
    GetPage(
        name: incidencia,
        page: () => const IncidenciaPage(assetId: 'asset_mock')),
    GetPage(name: purchase, page: () => const PurchaseRequestPage()),

    GetPage(name: assets, page: () => const AssetListPage()),
  ];
}

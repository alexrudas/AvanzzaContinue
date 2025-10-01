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
import '../presentation/bindings/admin/admin_shell_binding.dart';
import '../presentation/bindings/home_binding.dart';
import '../presentation/home/pages/home_router.dart';
import '../presentation/pages/incidencia_page.dart';
import '../presentation/pages/org_selection_page.dart';
import '../presentation/pages/purchase_request_page.dart';
import '../presentation/pages/workspaces/insurance_advisor_workspace_page.dart';
import '../presentation/pages/workspaces/insurer_workspace_page.dart';
import '../presentation/pages/workspaces/legal_workspace_page.dart';
import '../presentation/pages/workspaces/owner_workspace_page.dart';
import '../presentation/pages/workspaces/provider_articles_workspace_page.dart';
import '../presentation/pages/workspaces/provider_services_workspace_page.dart';
import '../presentation/pages/workspaces/renter_workspace_page.dart';
import '../presentation/shell/admin_shell.dart';

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

  // Admin deep-links
  static const admin = '/admin';
  static const adminHome = '/admin/home';
  static const adminMaintenance = '/admin/maintenance';
  static const adminAccounting = '/admin/accounting';
  static const adminPurchase = '/admin/purchase';
  static const adminChat = '/admin/chat';

  // Módulos ya existentes
  static const incidencia = '/incidencia';
  static const purchase = '/purchase';

  static const String assets = '/assets';

  // Workspaces
  static const wsOwner = '/ws/owner';
  static const wsRenter = '/ws/renter';
  static const wsProviderServices = '/ws/provider/services';
  static const wsProviderArticles = '/ws/provider/articles';
  static const wsInsuranceAdvisor = '/ws/insurance/advisor';
  static const wsInsurer = '/ws/insurance/insurer';
  static const wsLegal = '/ws/legal';

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

    // Admin workspace deep-links
    GetPage(
        name: admin,
        page: () => const AdminShell(),
        binding: AdminShellBinding()),
    GetPage(
        name: adminHome,
        page: () => const AdminShell(),
        binding: AdminShellBinding()),
    GetPage(
        name: adminMaintenance,
        page: () => const AdminShell(),
        binding: AdminShellBinding()),
    GetPage(
        name: adminAccounting,
        page: () => const AdminShell(),
        binding: AdminShellBinding()),
    GetPage(
        name: adminPurchase,
        page: () => const AdminShell(),
        binding: AdminShellBinding()),
    GetPage(
        name: adminChat,
        page: () => const AdminShell(),
        binding: AdminShellBinding()),

    GetPage(name: assets, page: () => const AssetListPage()),

    // Workspaces stubs
    GetPage(name: wsOwner, page: () => const OwnerWorkspacePage()),
    GetPage(name: wsRenter, page: () => const RenterWorkspacePage()),
    GetPage(
        name: wsProviderServices,
        page: () => const ProviderServicesWorkspacePage()),
    GetPage(
        name: wsProviderArticles,
        page: () => const ProviderArticlesWorkspacePage()),
    GetPage(
        name: wsInsuranceAdvisor,
        page: () => const InsuranceAdvisorWorkspacePage()),
    GetPage(name: wsInsurer, page: () => const InsurerWorkspacePage()),
    GetPage(name: wsLegal, page: () => const LegalWorkspacePage()),
  ];
}

// lib/routes/app_pages.dart
// ============================================================================
// APP PAGES - Definición de GetPage y Bindings
// ============================================================================
// Separación estándar GetX:
// - app_routes.dart → Constantes de rutas (Routes, _Paths)
// - app_pages.dart → GetPage list y bindings (este archivo)
// ============================================================================

import 'package:avanzza/core/campaign/demo/demo_soat_campaign.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/presentation/pages/asset_list_page.dart';
import 'package:avanzza/presentation/pages/workspaces/provider_articles_workspace_page.dart'
    show ProviderArticlesWorkspacePage;
import 'package:avanzza/presentation/pages/workspaces/provider_services_workspace_page.dart';
import 'package:flutter/foundation.dart';
// NOTE: material.dart is imported ONLY for debug-only error page; in release we redirect without UI.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../presentation/auth/bindings/enhanced_registration_binding.dart';
import '../presentation/auth/pages/auth_welcome_page.dart';
import '../presentation/auth/pages/email_optional_page.dart';
import '../presentation/auth/pages/enhanced_registration_page.dart';
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
import '../presentation/bindings/runt/runt_binding.dart';
import '../presentation/bindings/simit/simit_binding.dart';
import '../presentation/bindings/tenant_home_binding.dart';
import '../presentation/home/pages/home_router.dart';
import '../presentation/pages/incidencia_page.dart';
import '../presentation/pages/org_selection_page.dart';
import '../presentation/pages/purchase_request_page.dart';
import '../presentation/pages/runt/runt_person_consult_page.dart';
import '../presentation/pages/runt/runt_vehicle_consult_page.dart';
import '../presentation/pages/portfolio/wizard/create_portfolio_step1_page.dart';
import '../presentation/pages/portfolio/wizard/create_portfolio_step2_page.dart';
import '../presentation/pages/simit/simit_consult_page.dart';
import '../presentation/pages/tenant/home/tenant_home_page.dart';
import 'app_routes.dart';

// TODO(cleanup): migrar imports a app_routes.dart donde solo se usan constantes
export 'app_routes.dart';

/// Definición de páginas de la aplicación
class AppPages {
  AppPages._();

  static const initial = Routes.welcome;

  static final pages = <GetPage<dynamic>>[
    // ════════════════════════════════════════════════════════════════════════
    // AUTH
    // ════════════════════════════════════════════════════════════════════════
    GetPage(name: Routes.welcome, page: () => AuthWelcomePage()),
    GetPage(name: Routes.phone, page: () => const PhoneInputPage()),
    GetPage(name: Routes.otp, page: () => const OtpVerifyPage()),
    GetPage(name: Routes.countryCity, page: () => const SelectCountryCityPage()),
    GetPage(name: Routes.profile, page: () => const SelectProfilePage()),
    GetPage(name: Routes.orgSelect, page: () => const OrgSelectionPage()),

    // LEGACY_ALIAS: Routes.role -> Canonical: Routes.profile
    GetPage(name: Routes.role, page: () => const _LegacyRedirectPage(to: Routes.profile)),

    // HomeRouter decide workspace según activeContext
    GetPage(
      name: Routes.home,
      page: () => const HomeRouter(),
      binding: HomeBinding(),
    ),

    // Registro
    GetPage(name: Routes.registerUsername, page: () => const UsernamePasswordPage()),
    GetPage(name: Routes.registerEmail, page: () => const EmailOptionalPage()),
    GetPage(name: Routes.registerIdScan, page: () => const IdScanPage()),
    GetPage(name: Routes.registerTerms, page: () => const TermsPage()),
    GetPage(name: Routes.loginUserPass, page: () => const LoginUsernamePasswordPage()),
    GetPage(name: Routes.loginMfa, page: () => const MfaOtpPage()),
    GetPage(name: Routes.registerSummary, page: () => const SummaryPage()),

    // LEGACY_ALIAS: Routes.holderType -> Canonical: Routes.profile
    GetPage(name: Routes.holderType, page: () => const _LegacyRedirectPage(to: Routes.profile)),

    // Provider
    GetPage(name: Routes.providerProfile, page: () => const ProviderProfilePage()),
    GetPage(
      name: Routes.enhancedRegistration,
      page: () => const EnhancedRegistrationPage(),
      binding: EnhancedRegistrationBinding(),
    ),
    GetPage(name: Routes.providerCoverage, page: () => const ProviderCoveragePage()),

    // Canonical: Routes.providerWorkspaceArticles (provider articles workspace)
    GetPage(
      name: Routes.providerWorkspaceArticles,
      page: () => const ProviderArticlesWorkspacePage(),
    ),
    // LEGACY_ALIAS: Routes.providerHomeArticles -> Canonical: Routes.providerWorkspaceArticles
    GetPage(
      name: Routes.providerHomeArticles,
      page: () => const _LegacyRedirectPage(to: Routes.providerWorkspaceArticles),
    ),

    // Canonical: Routes.providerWorkspaceServices (provider services workspace)
    GetPage(
      name: Routes.providerWorkspaceServices,
      page: () => const ProviderServicesWorkspacePage(),
    ),
    // LEGACY_ALIAS: Routes.providerHomeServices -> Canonical: Routes.providerWorkspaceServices
    GetPage(
      name: Routes.providerHomeServices,
      page: () => const _LegacyRedirectPage(to: Routes.providerWorkspaceServices),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // MÓDULOS OPERATIVOS
    // ════════════════════════════════════════════════════════════════════════

    // CONTRACT: Routes.incidencia requiere argument String assetId (no vacío)
    // Uso: Get.toNamed(Routes.incidencia, arguments: assetId)
    // También acepta: Get.toNamed(Routes.incidencia, arguments: {'assetId': assetId})
    GetPage(
      name: Routes.incidencia,
      page: () => _buildIncidenciaPage(),
    ),
    GetPage(name: Routes.purchase, page: () => const PurchaseRequestPage()),
    GetPage(name: Routes.assets, page: () => const AssetListPage()),

    // Tenant Home
    GetPage(
      name: Routes.tenantHome,
      page: () => const TenantHomePage(),
      binding: TenantHomeBinding(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // CONSULTAS EXTERNAS (RUNT / SIMIT)
    // ════════════════════════════════════════════════════════════════════════
    GetPage(
      name: Routes.runtPersonConsult,
      page: () => RuntPersonConsultPage(),
      binding: RuntBinding(),
    ),
    GetPage(
      name: Routes.runtVehicleConsult,
      page: () => RuntVehicleConsultPage(),
      binding: RuntBinding(),
    ),
    GetPage(
      name: Routes.simitConsult,
      page: () => SimitConsultPage(),
      binding: SimitBinding(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // PORTFOLIO / WIZARD
    // ════════════════════════════════════════════════════════════════════════
    GetPage(
      name: Routes.createPortfolioStep1,
      page: () => _buildCreatePortfolioStep1Page(),
    ),
    GetPage(
      name: Routes.createPortfolioStep2,
      page: () => const CreatePortfolioStep2Page(),
      binding: RuntBinding(), // Inyecta RuntController para consulta de vehículos
    ),

    // ════════════════════════════════════════════════════════════════════════
    // DEMO
    // ════════════════════════════════════════════════════════════════════════
    GetPage(name: Routes.demoSoat, page: () => const DemoSoatCampaignPage()),
  ];
}

// ════════════════════════════════════════════════════════════════════════════
// HELPERS PRIVADOS
// ════════════════════════════════════════════════════════════════════════════

/// Página de redirección para alias legacy.
/// StatefulWidget para garantizar 1 sola ejecución de redirect en initState.
/// Preserva arguments y parameters al redirigir.
class _LegacyRedirectPage extends StatefulWidget {
  final String to;
  const _LegacyRedirectPage({required this.to});

  @override
  State<_LegacyRedirectPage> createState() => _LegacyRedirectPageState();
}

class _LegacyRedirectPageState extends State<_LegacyRedirectPage> {
  @override
  void initState() {
    super.initState();
    // Ejecuta redirect 1 sola vez, preservando arguments
    Future.microtask(() {
      // TODO: Get.parameters not available / not guaranteed in this project. Add back only if confirmed.
      Get.offNamed(
        widget.to,
        arguments: Get.arguments,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Construye CreatePortfolioStep1Page con preselectedAssetType desde arguments
Widget _buildCreatePortfolioStep1Page() {
  final args = Get.arguments;
  AssetType? preselectedAssetType;

  if (args is Map) {
    final typeArg = args['preselectedAssetType'];
    if (typeArg is AssetType) {
      preselectedAssetType = typeArg;
    }
  }

  return CreatePortfolioStep1Page(preselectedAssetType: preselectedAssetType);
}

/// Extrae assetId de Get.arguments (String o Map)
String? _resolveAssetIdFromArgs(dynamic args) {
  if (args == null) return null;
  if (args is String && args.isNotEmpty) return args;
  if (args is Map) {
    final value = args['assetId'];
    if (value is String && value.isNotEmpty) return value;
  }
  return null;
}

/// Construye IncidenciaPage con validación estricta de assetId.
/// - En RELEASE: redirige a assets sin UI intermedia.
/// - En DEBUG/PROFILE: muestra pantalla de error para facilitar debugging.
Widget _buildIncidenciaPage() {
  final assetId = _resolveAssetIdFromArgs(Get.arguments);

  if (assetId == null) {
    debugPrint('[AppPages] ERROR: Routes.incidencia navegado sin assetId válido. args=${Get.arguments}');

    if (kReleaseMode) {
      // RELEASE: redirige inmediatamente sin UI intermedia
      Future.microtask(() {
        Get.offNamed(Routes.assets);
      });
      return const SizedBox.shrink();
    } else {
      // DEBUG/PROFILE: muestra pantalla de error para facilitar debugging
      return const _IncidenciaErrorPage();
    }
  }

  return IncidenciaPage(assetId: assetId);
}

/// DEBUG_ONLY_UI: Pantalla de error para DEBUG/PROFILE cuando falta assetId.
/// NUNCA se construye en kReleaseMode (ver _buildIncidenciaPage).
class _IncidenciaErrorPage extends StatelessWidget {
  const _IncidenciaErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error de Navegación'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bug_report, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'DEBUG: assetId faltante',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Routes.incidencia requiere:\nGet.toNamed(Routes.incidencia, arguments: assetId)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                'Get.arguments actual: ${Get.arguments}',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.offNamed(Routes.assets),
                child: const Text('Ir a Activos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

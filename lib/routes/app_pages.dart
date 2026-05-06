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
// TEMPORARY — Demo del flujo de registro v2. Borrar junto con la carpeta.
import 'package:avanzza/presentation/demo_registration_v2/demo_registration_v2_flow.dart';
import 'package:avanzza/presentation/pages/asset_list_page.dart';
import 'package:avanzza/presentation/pages/assets_by_type_page.dart';
import 'package:flutter/foundation.dart';
// NOTE: material.dart is imported ONLY for debug-only error page; in release we redirect without UI.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/entities/workspace/workspace_type.dart';
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
import '../presentation/auth/pages/select_country_city_page.dart';
import '../presentation/auth/pages/select_profile_page.dart';
import '../presentation/auth/pages/summary_page.dart';
import '../presentation/auth/pages/username_password_page.dart';
import '../presentation/bindings/admin/actor_detail_binding.dart';
import '../presentation/bindings/admin/provider_detail_binding.dart';
import '../presentation/bindings/admin/provider_form_binding.dart';
import '../presentation/bindings/admin/providers_directory_binding.dart';
import '../presentation/bindings/alert_center_binding.dart';
import '../presentation/bindings/asset/asset_registration_binding.dart';
import '../presentation/bindings/fleet_alert_binding.dart';
import '../presentation/bindings/provider/provider_me_binding.dart';
import '../presentation/bindings/provider/select_specialties_binding.dart';
import '../presentation/bindings/home_binding.dart';
import '../presentation/bindings/insurance/rc_quote_request_binding.dart';
import '../presentation/bindings/insurance/rc_quote_status_binding.dart';
import '../presentation/bindings/portfolio/portfolio_asset_live_binding.dart';
import '../presentation/bindings/portfolio/portfolio_detail_binding.dart';
import '../presentation/bindings/runt/runt_binding.dart';
import '../presentation/bindings/runt/runt_query_binding.dart';
import '../presentation/bindings/simit/simit_binding.dart';
import '../presentation/bindings/splash_binding.dart';
import '../presentation/bindings/tenant_home_binding.dart';
// LEGACY: import VrcBinding — desactivado junto con vrcConsult/vrcResult GetPages
// import '../presentation/bindings/vrc/vrc_binding.dart';
import '../presentation/home/pages/home_router.dart';
import '../presentation/pages/alerts/alert_center_page.dart';
import '../presentation/pages/alerts/fleet_alert_detail_page.dart';
import '../presentation/pages/alerts/fleet_alert_list_page.dart';
import '../presentation/pages/alerts/fleet_vehicle_alerts_page.dart';
import '../presentation/pages/asset/asset_detail_page.dart';
import '../presentation/pages/asset/asset_registration_page.dart';
import '../presentation/pages/asset/driver_license_detail_page.dart';
import '../presentation/pages/asset/juridical_status_detail_page.dart';
import '../presentation/pages/asset/rtm_detail_page.dart';
import '../presentation/pages/asset/runt_consult_page.dart';
import '../presentation/pages/asset/seguros_rc_detail_page.dart';
import '../presentation/pages/asset/simit_fine_detail_page.dart';
import '../presentation/pages/asset/simit_person_detail_page.dart';
import '../presentation/pages/asset/soat_detail_page.dart';
import '../presentation/pages/asset/vehicle_info_page.dart';
import '../presentation/pages/incidencia_page.dart';
import '../presentation/pages/insurance/rc_quote_request_page.dart';
import '../presentation/pages/insurance/rc_quote_status_page.dart';
import '../presentation/pages/org_selection_page.dart';
import '../presentation/pages/portfolio/portfolio_asset_list_page.dart';
import '../presentation/pages/portfolio/portfolio_asset_live_page.dart';
import '../presentation/pages/portfolio/portfolio_detail_page.dart';
import '../presentation/pages/portfolio/wizard/create_portfolio_step1_page.dart';
import '../presentation/pages/portfolio/wizard/create_portfolio_step2_page.dart';
import '../presentation/pages/portfolio/wizard/runt_query_progress_page.dart';
import '../presentation/pages/portfolio/wizard/runt_query_result_page.dart';
import '../presentation/bindings/purchase_request_binding.dart';
import '../presentation/pages/admin/network/actor_detail_page.dart';
import '../presentation/pages/admin/network/network_operational_screen.dart';
import '../presentation/pages/admin/network/provider_detail_page.dart';
import '../presentation/pages/admin/network/provider_form_page.dart';
import '../presentation/pages/admin/network/providers_directory_page.dart';
import '../presentation/pages/provider/me/provider_me_page.dart';
import '../presentation/pages/provider/specialties/select_specialties_page.dart';
import '../presentation/pages/purchase_request_page.dart';
import '../presentation/pages/runt/runt_person_consult_page.dart';
import '../presentation/pages/runt/runt_vehicle_consult_page.dart';
import '../presentation/pages/simit/simit_consult_page.dart';
import '../presentation/pages/splash/splash_bootstrap_page.dart';
import '../presentation/pages/tenant/home/tenant_home_page.dart';
import '../presentation/bindings/admin/network_operational_binding.dart';
import '../presentation/workspace/workspace_config.dart';
import '../presentation/workspace/workspace_shell.dart';
// LEGACY: vrc_consult_page.dart y vrc_result_page.dart comentados — flujo VRC individual inactivo
// import '../presentation/pages/vrc/vrc_consult_page.dart';
// import '../presentation/pages/vrc/vrc_result_page.dart';
import 'app_routes.dart';

// TODO(cleanup): migrar imports a app_routes.dart donde solo se usan constantes
export 'app_routes.dart';

/// Definición de páginas de la aplicación
class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final pages = <GetPage<dynamic>>[
    // ════════════════════════════════════════════════════════════════════════
    // SPLASH — initialRoute: SplashBootstrapController decide el destino real
    // ════════════════════════════════════════════════════════════════════════
    GetPage(
      name: Routes.splash,
      page: () => const SplashBootstrapPage(),
      binding: SplashBinding(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // AUTH
    // ════════════════════════════════════════════════════════════════════════
    GetPage(name: Routes.welcome, page: () => const AuthWelcomePage()),
    GetPage(name: Routes.phone, page: () => const PhoneInputPage()),
    GetPage(name: Routes.otp, page: () => const OtpVerifyPage()),
    GetPage(
        name: Routes.countryCity, page: () => const SelectCountryCityPage()),
    GetPage(name: Routes.profile, page: () => const SelectProfilePage()),
    GetPage(name: Routes.orgSelect, page: () => const OrgSelectionPage()),

    // LEGACY_ALIAS: Routes.role -> Canonical: Routes.profile
    GetPage(
        name: Routes.role,
        page: () => const _LegacyRedirectPage(to: Routes.profile)),

    // HomeRouter decide workspace según activeContext
    GetPage(
      name: Routes.home,
      page: () => const HomeRouter(),
      binding: HomeBinding(),
    ),

    // Registro
    GetPage(
        name: Routes.registerUsername,
        page: () => const UsernamePasswordPage()),
    GetPage(name: Routes.registerEmail, page: () => const EmailOptionalPage()),
    GetPage(name: Routes.registerIdScan, page: () => const IdScanPage()),
    GetPage(
        name: Routes.loginUserPass,
        page: () => const LoginUsernamePasswordPage()),
    GetPage(name: Routes.loginMfa, page: () => const MfaOtpPage()),
    GetPage(name: Routes.registerSummary, page: () => const SummaryPage()),

    // LEGACY_ALIAS: Routes.holderType -> Canonical: Routes.profile
    GetPage(
        name: Routes.holderType,
        page: () => const _LegacyRedirectPage(to: Routes.profile)),

    GetPage(
      name: Routes.enhancedRegistration,
      page: () => const EnhancedRegistrationPage(),
      binding: EnhancedRegistrationBinding(),
    ),
    GetPage(
        name: Routes.providerCoverage,
        page: () => const ProviderCoveragePage()),

    // ── PROVIDER WORKSPACE SHELL ────────────────────────────────────────
    //
    // Dos rutas reales — diferenciadas por `WorkspaceType` aunque hoy
    // compartan tabs (Fase 2 — UNIFIED PROVIDER SHELL):
    //   · providerWorkspaceServices → WorkspaceType.workshop  (servicios)
    //   · providerWorkspaceArticles → WorkspaceType.supplier  (artículos)
    //
    // El splash decide cuál abrir leyendo
    // `org.capabilityProfiles[].providerSpec.providerType`. El gate
    // `ProviderBootstrapGate` verifica `GET /v1/providers/me` antes de
    // pintar; si `isProvider=false` redirige a `/provider/bootstrap`.
    GetPage(
      name: Routes.providerWorkspaceServices,
      page: () => WorkspaceShell(
        config: NavigationRegistry.configFor(
              WorkspaceType.workshop,
            ) ??
            workspaceFor(rol: 'proveedor'),
      ),
    ),
    GetPage(
      name: Routes.providerWorkspaceArticles,
      page: () => WorkspaceShell(
        config: NavigationRegistry.configFor(
              WorkspaceType.supplier,
            ) ??
            workspaceFor(rol: 'proveedor'),
      ),
    ),

    // LEGACY_ALIAS: Routes.providerHome* -> Canonical: providerWorkspaceServices
    GetPage(
      name: Routes.providerHomeArticles,
      page: () =>
          const _LegacyRedirectPage(to: Routes.providerWorkspaceArticles),
    ),
    GetPage(
      name: Routes.providerHomeServices,
      page: () =>
          const _LegacyRedirectPage(to: Routes.providerWorkspaceServices),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // PROVIDER SELF (MF1 — bootstrap + me)
    // ════════════════════════════════════════════════════════════════════════
    //
    // LEGACY WIZARD BLOCKED (2026-05):
    // Routes.providerBootstrap renderizaba un wizard de 3 pasos que está
    // OFICIALMENTE MUERTO. El bootstrap de provider hoy ocurre server-side
    // en POST /v1/bootstrap (orquestado por `BootstrapSyncController` en
    // background — ver bloque V2.1). Cualquier navegación a esta ruta es
    // un BUG de routing — un flujo zombie que reintroduce fricción que
    // el usuario rechazó.
    //
    // Política: redirigir SIEMPRE a `providerWorkspaceServices`. La pieza
    // de bootstrap real ya corrió o está corriendo; el banner del shell
    // muestra el estado.
    GetPage(
      name: Routes.providerBootstrap,
      page: () =>
          const _LegacyRedirectPage(to: Routes.providerWorkspaceServices),
    ),
    GetPage(
      name: Routes.providerMe,
      page: () => const ProviderMePage(),
      binding: ProviderMeBinding(),
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
    GetPage(
      name: Routes.purchase,
      page: () => const PurchaseRequestPage(),
      binding: PurchaseRequestBinding(),
    ),
    GetPage(name: Routes.assets, page: () => const AssetListPage()),

    // CONTRACT: Routes.assetsByType requiere argument AssetType (enum).
    // Vista dedicada del tipo seleccionado desde la pantalla agrupada.
    GetPage(
      name: Routes.assetsByType,
      page: () => const AssetsByTypePage(),
    ),

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

    // LEGACY — vrc_consult_page.dart y vrc_result_page.dart comentados (flujo VRC individual
    // inactivo tras unificación). GetPages desactivados hasta que se decida eliminar definitivamente.
    // GetPage(name: Routes.vrcConsult, page: () => VrcConsultPage(), binding: VrcBinding()),
    // GetPage(name: Routes.vrcResult, page: () => const VrcResultPage(), binding: VrcBinding()),

    // CONTRACT: Routes.vrcBatchProgress requiere VrcBatchController activo.
    // AssetRegistrationBinding lo registra antes de navegar aquí desde el flujo
    // de registro. El binding se incluye también aquí como guard defensivo.
    // GetPage(
    //   name: Routes.vrcBatchProgress,
    //   page: () => const VrcBatchProgressPage(),
    //   binding: AssetRegistrationBinding(),
    // ),

    // ════════════════════════════════════════════════════════════════════════
    // PORTFOLIO / WIZARD
    // ════════════════════════════════════════════════════════════════════════
    GetPage(
      name: Routes.createPortfolioStep1,
      page: () => _buildCreatePortfolioStep1Page(),
    ),
    // CONTRACT: RuntQueryBinding inyecta RuntQueryController (con fenix=true)
    // para que el controller sobreviva la navegación Step2 → Progress → Result.
    GetPage(
      name: Routes.createPortfolioStep2,
      page: () => const CreatePortfolioStep2Page(),
      binding: RuntQueryBinding(),
    ),
    GetPage(
      name: Routes.runtQueryProgress,
      page: () => const RuntQueryProgressPage(),
      binding: RuntQueryBinding(),
    ),
    GetPage(
      name: Routes.runtQueryResult,
      page: () => const RuntQueryResultPage(),
      binding: RuntQueryBinding(),
    ),

    // CONTRACT: Routes.assetRegister requiere argument AssetRegistrationContext
    // Uso: Get.toNamed(Routes.assetRegister, arguments: AssetRegistrationContext(...))
    GetPage(
      name: Routes.assetRegister,
      page: () => const AssetRegistrationPage(),
      binding: AssetRegistrationBinding(),
    ),

    // CONTRACT: Routes.portfolioDetail requiere argument PortfolioEntity
    // Uso: Get.toNamed(Routes.portfolioDetail, arguments: portfolioEntity)
    GetPage(
      name: Routes.portfolioDetail,
      page: () => const PortfolioDetailPage(),
      binding: PortfolioDetailBinding(),
    ),

    // CONTRACT: Routes.portfolioAssets requiere argument PortfolioEntity
    // Uso: Get.toNamed(Routes.portfolioAssets, arguments: portfolioEntity)
    GetPage(
      name: Routes.portfolioAssets,
      page: () => const PortfolioAssetListPage(),
    ),

    // CONTRACT: Routes.portfolioAssetLive requiere argument AssetRegistrationContext.
    // Navegar con Get.offNamed — remueve el formulario de registro del stack.
    // PortfolioAssetLiveBinding guard-registra Dio/VrcService/VrcBatchController;
    // si AssetRegistrationBinding ya los registró, los reutiliza (estado en vuelo).
    GetPage(
      name: Routes.portfolioAssetLive,
      page: () => const PortfolioAssetLivePage(),
      binding: PortfolioAssetLiveBinding(),
    ),

    // CONTRACT: Routes.assetDetail requiere argument assetId (String)
    // Uso: Get.toNamed(Routes.assetDetail, arguments: assetId)
    GetPage(
      name: Routes.assetDetail,
      page: () => const AssetDetailPage(),
    ),

    // CONTRACT: Routes.assetRtmDetail requiere argument assetId (String)
    // Uso: Get.toNamed(Routes.assetRtmDetail, arguments: assetId)
    GetPage(
      name: Routes.assetRtmDetail,
      page: () => const RtmDetailPage(),
    ),

    // CONTRACT: Routes.soatDetail requiere argument assetId (String)
    // Uso: Get.toNamed(Routes.soatDetail, arguments: assetId)
    GetPage(
      name: Routes.soatDetail,
      page: () => const SoatDetailPage(),
    ),

    // CONTRACT: Routes.segurosRcDetail requiere argument assetId (String)
    // Uso: Get.toNamed(Routes.segurosRcDetail, arguments: assetId)
    GetPage(
      name: Routes.segurosRcDetail,
      page: () => const SegurosRcDetailPage(),
    ),

    // CONTRACT: Routes.legalStatus requiere argument assetId (String)
    // Uso: Get.toNamed(Routes.legalStatus, arguments: assetId)
    GetPage(
      name: Routes.legalStatus,
      page: () => const JuridicalStatusDetailPage(),
    ),

    // CONTRACT: Routes.vehicleInfo requiere argument AssetVehiculoEntity
    // Uso: Get.toNamed(Routes.vehicleInfo, arguments: vehiculo)
    GetPage(
      name: Routes.vehicleInfo,
      page: () => const VehicleInfoPage(),
    ),

    // CONTRACT: Routes.runtConsult requiere argument AssetVehiculoEntity
    // Uso: Get.toNamed(Routes.runtConsult, arguments: vehiculo)
    GetPage(
      name: Routes.runtConsult,
      page: () => const RuntConsultPage(),
    ),

    // CONTRACT: Routes.driverLicenseDetail requiere argument
    //   Map{'data': VrcDataModel, 'checkedAt': DateTime?}
    // Uso: Get.toNamed(Routes.driverLicenseDetail, arguments: {'data': ..., 'checkedAt': ...})
    GetPage(
      name: Routes.driverLicenseDetail,
      page: () => const DriverLicenseDetailPage(),
    ),

    // CONTRACT: Routes.simitPersonDetail requiere argument
    //   Map{'data': VrcDataModel, 'checkedAt': DateTime?}
    // Uso: Get.toNamed(Routes.simitPersonDetail, arguments: {'data': ..., 'checkedAt': ...})
    GetPage(
      name: Routes.simitPersonDetail,
      page: () => const SimitPersonDetailPage(),
    ),

    // CONTRACT: Routes.simitFineDetail requiere argument
    //   Map{'data': VrcDataModel, 'type': String, 'checkedAt': DateTime?}
    //   type: 'comparendos' | 'multas' | 'acuerdosDePago'
    GetPage(
      name: Routes.simitFineDetail,
      page: () => const SimitFineDetailPage(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // ALERTAS
    // ════════════════════════════════════════════════════════════════════════

    // CONTRACT: no requiere arguments — carga todas las alertas de la org activa.
    GetPage(
      name: Routes.alertCenter,
      page: () => const AlertCenterPage(),
      binding: AlertCenterBinding(),
    ),

    // CONTRACT: no requiere arguments — FleetAlertController carga la org activa.
    GetPage(
      name: Routes.fleetAlerts,
      page: () => const FleetAlertListPage(),
      binding: FleetAlertBinding(),
    ),

    // CONTRACT: Get.toNamed(Routes.fleetAlertVehicle, arguments: FleetAlertGroupVm)
    GetPage(
      name: Routes.fleetAlertVehicle,
      page: () => const FleetVehicleAlertsPage(),
    ),

    // CONTRACT: Get.toNamed(Routes.fleetAlertDetail, arguments: AlertCardVm)
    GetPage(
      name: Routes.fleetAlertDetail,
      page: () => const FleetAlertDetailPage(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // FLUJO COTIZACIÓN SRCE (RC Extracontractual)
    // ════════════════════════════════════════════════════════════════════════

    // CONTRACT: Routes.rcQuoteRequest requiere argument Map o RcQuoteRequestArgs.
    // Ver RcQuoteRequestArgs en rc_quote_request_page.dart.
    GetPage(
      name: Routes.rcQuoteRequest,
      page: () => const RcQuoteRequestPage(),
      binding: RcQuoteRequestBinding(),
    ),

    // CONTRACT: Routes.rcQuoteStatus requiere argument InsuranceOpportunityLead
    // o RcQuoteStatusArgs. Ver RcQuoteStatusArgs en rc_quote_status_controller.dart.
    GetPage(
      name: Routes.rcQuoteStatus,
      page: () => const RcQuoteStatusPage(),
      binding: RcQuoteStatusBinding(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // RED OPERATIVA
    // ════════════════════════════════════════════════════════════════════════

    // CONTRACT: no requiere arguments — carga propietarios de la org activa.
    GetPage(
      name: Routes.networkOperational,
      page: () => const NetworkOperationalScreen(),
      binding: NetworkOperationalBinding(),
    ),

    // CONTRACT (ADR actor-canon §10): Routes.actorDetail requiere argument
    //   Map{'actor': NetworkActorVm}
    // Uso: Get.toNamed(Routes.actorDetail, arguments: {'actor': actorVm})
    GetPage(
      name: Routes.actorDetail,
      page: () => const ActorDetailPage(),
      binding: ActorDetailBinding(),
    ),

    // CONTRACT: Routes.providersDirectory no requiere arguments — el binding
    // resuelve orgId desde SessionContextController. Primer rostro visible
    // del arquetipo transversal comercial/servicio (Fase 1 = Proveedores);
    // vistas futuras (Taller/Técnico/Asesor) reutilizarán el mismo controller
    // parametrizando `roleLabel` sin duplicar página.
    GetPage(
      name: Routes.providersDirectory,
      page: () => const ProvidersDirectoryPage(),
      binding: ProvidersDirectoryBinding(),
    ),

    // CONTRACT: Routes.providerDetail requiere arguments = {'providerId': '<id>'}.
    // Ficha lectora por secciones (Datos básicos, Contacto, Ubicación, Tipo y
    // categorías, Cobertura, Observaciones) con CTAs "Editar"/"Eliminar".
    GetPage(
      name: Routes.providerDetail,
      page: () => const ProviderDetailPage(),
      binding: ProviderDetailBinding(),
    ),

    // CONTRACT: Routes.providerForm.
    //   Sin arguments → alta completa.
    //   arguments = {'providerId': '<id>'} → edición completa.
    // Reutiliza el camino canónico `SaveLocalContactWithProbe` (cero write
    // paralelo a la SSOT LocalContact).
    GetPage(
      name: Routes.providerForm,
      page: () => const ProviderFormPage(),
      binding: ProviderFormBinding(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // PROVIDER — CATÁLOGO / SPECIALTIES
    // ════════════════════════════════════════════════════════════════════════

    // CONTRACT: Routes.selectSpecialties requiere arguments con assetType.
    //   Get.toNamed(Routes.selectSpecialties, arguments: {
    //     'assetType': '<assetType-id, p.ej. vehicle.car>',
    //   })
    // RESULT: Set<String> de specialty IDs seleccionados (vía Get.back).
    GetPage(
      name: Routes.selectSpecialties,
      page: () => const SelectSpecialtiesPage(),
      binding: SelectSpecialtiesBinding(),
    ),

    // ════════════════════════════════════════════════════════════════════════
    // DEMO
    // ════════════════════════════════════════════════════════════════════════
    GetPage(name: Routes.demoSoat, page: () => const DemoSoatCampaignPage()),

    // TEMPORARY — Demo experimental del flujo de registro v2 (RUNT temprano +
    // tabs). Coexiste con el flujo canónico hasta que el FusionadoFlow esté
    // hardenado. Borrar junto con `lib/presentation/demo_registration_v2/`.
    GetPage(
      name: Routes.demoRegistrationV2,
      page: () => const DemoRegistrationV2Flow(),
    ),
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
  AssetRegistrationType? preselectedAssetType;

  if (args is Map) {
    final typeArg = args['preselectedAssetType'];
    if (typeArg is AssetRegistrationType) {
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
    debugPrint(
        '[AppPages] ERROR: Routes.incidencia navegado sin assetId válido. args=${Get.arguments}');

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

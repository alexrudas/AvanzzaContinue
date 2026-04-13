// lib/routes/app_routes.dart
// ============================================================================
// ROUTES - Constantes de rutas de navegación
// ============================================================================
// Separación estándar GetX: Routes (público) + _Paths (interno)
// Uso: Get.toNamed(Routes.home)
// ============================================================================

/// Rutas públicas de la aplicación
///
/// Uso: `Get.toNamed(Routes.home)`
///
/// REGLA DE GOBERNANZA: Toda navegación DEBE usar Routes.*
/// NO usar strings hardcodeados como '/home'
abstract class Routes {
  Routes._();

  // ══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ══════════════════════════════════════════════════════════════════════════
  static const welcome = _Paths.welcome;
  static const phone = _Paths.phone;
  static const otp = _Paths.otp;
  static const countryCity = _Paths.countryCity;
  static const role = _Paths.role;
  static const profile = _Paths.profile;
  static const registerUsername = _Paths.registerUsername;
  static const registerEmail = _Paths.registerEmail;
  static const registerIdScan = _Paths.registerIdScan;
  static const loginUserPass = _Paths.loginUserPass;
  static const loginMfa = _Paths.loginMfa;
  static const registerSummary = _Paths.registerSummary;
  static const holderType = _Paths.holderType;
  static const providerProfile = _Paths.providerProfile;
  static const enhancedRegistration = _Paths.enhancedRegistration;
  static const providerCoverage = _Paths.providerCoverage;

  // ══════════════════════════════════════════════════════════════════════════
  // CORE / HOME
  // ══════════════════════════════════════════════════════════════════════════

  /// Ruta inicial de la app. SplashBootstrapController decide el destino real.
  /// S0→welcome | S1→registerUsername | S2→createPortfolioStep1 | S3→WorkspaceShell
  static const splash = _Paths.splash;

  /// Re-routing post-workspace-delete (usado por SessionContextController).
  static const home = _Paths.home;
  static const orgSelect = _Paths.orgSelect;

  // ══════════════════════════════════════════════════════════════════════════
  // PROVIDER WORKSPACES
  // ══════════════════════════════════════════════════════════════════════════
  static const providerHomeArticles = _Paths.providerHomeArticles;
  static const providerHomeServices = _Paths.providerHomeServices;
  static const providerWorkspaceArticles = _Paths.providerWorkspaceArticles;
  static const providerWorkspaceServices = _Paths.providerWorkspaceServices;

  // ══════════════════════════════════════════════════════════════════════════
  // MÓDULOS OPERATIVOS
  // ══════════════════════════════════════════════════════════════════════════
  static const incidencia = _Paths.incidencia;
  static const purchase = _Paths.purchase;
  static const assets = _Paths.assets;
  static const tenantHome = _Paths.tenantHome;

  // ══════════════════════════════════════════════════════════════════════════
  // CONSULTAS EXTERNAS (RUNT / SIMIT / VRC)
  // ══════════════════════════════════════════════════════════════════════════
  static const runtPersonConsult = _Paths.runtPersonConsult;
  static const runtVehicleConsult = _Paths.runtVehicleConsult;
  static const simitConsult = _Paths.simitConsult;

  /// Formulario de consulta VRC Individual (placa + documento).
  /// CONTRACT: no requiere arguments — los datos se ingresan en el formulario.
  static const vrcConsult = _Paths.vrcConsult;

  /// Resultado de la consulta VRC Individual.
  /// CONTRACT: navegar desde VrcConsultPage; el resultado vive en VrcController.
  static const vrcResult = _Paths.vrcResult;

  /// Progreso y resultado de la consulta VRC Batch (multi-placa).
  /// CONTRACT: navegar desde AssetRegistrationPage tras llamar
  /// VrcBatchController.startBatch(). El estado vive en VrcBatchController.
  static const vrcBatchProgress = _Paths.vrcBatchProgress;

  // ══════════════════════════════════════════════════════════════════════════
  // PORTFOLIO / WIZARD
  // ══════════════════════════════════════════════════════════════════════════
  static const createPortfolioStep1 = _Paths.createPortfolioStep1;
  static const createPortfolioStep2 = _Paths.createPortfolioStep2;
  static const runtQueryProgress = _Paths.runtQueryProgress;
  static const runtQueryResult = _Paths.runtQueryResult;

  /// Detalle de un portafolio existente.
  /// CONTRACT: Get.toNamed(Routes.portfolioDetail, arguments: portfolioEntity)
  static const portfolioDetail = _Paths.portfolioDetail;

  /// Lista de activos de un portafolio específico.
  /// CONTRACT: Get.toNamed(Routes.portfolioAssets, arguments: portfolioEntity)
  static const portfolioAssets = _Paths.portfolioAssets;

  /// Vista unificada de activos registrados + batch VRC en progreso.
  /// CONTRACT: Get.offNamed(Routes.portfolioAssetLive, arguments: AssetRegistrationContext)
  static const portfolioAssetLive = _Paths.portfolioAssetLive;

  /// Detalle de un activo específico.
  /// CONTRACT: Get.toNamed(Routes.assetDetail, arguments: assetId)
  static const assetDetail = _Paths.assetDetail;

  /// Registro de un activo en un portafolio existente.
  /// CONTRACT: Get.toNamed(Routes.assetRegister, arguments: AssetRegistrationContext)
  static const assetRegister = _Paths.assetRegister;

  /// Detalle RTM v1 de un activo.
  /// CONTRACT: Get.toNamed(Routes.assetRtmDetail, arguments: assetId (String))
  static const assetRtmDetail = _Paths.assetRtmDetail;

  /// Detalle SOAT de un activo (historial + vigencia dinámica).
  /// CONTRACT: Get.toNamed(Routes.soatDetail, arguments: assetId (String))
  static const soatDetail = _Paths.soatDetail;

  /// Detalle agrupado de Seguros RC (RC Contractual + RC Extracontractual).
  /// CONTRACT: Get.toNamed(Routes.segurosRcDetail, arguments: assetId (String))
  static const segurosRcDetail = _Paths.segurosRcDetail;

  /// Detalle de Estado Jurídico (limitaciones + garantías y gravámenes).
  /// CONTRACT: Get.toNamed(Routes.legalStatus, arguments: assetId (String))
  static const legalStatus = _Paths.legalStatus;

  /// Alias canónico de [legalStatus]. Preferir este nombre en nuevos usos.
  /// CONTRACT: Get.toNamed(Routes.assetJuridicalStatus, arguments: assetId (String))
  static const assetJuridicalStatus = _Paths.legalStatus;

  /// Información completa del vehículo (identificación, técnicos, admin).
  /// CONTRACT: Get.toNamed(Routes.vehicleInfo, arguments: AssetVehiculoEntity)
  static const vehicleInfo = _Paths.vehicleInfo;

  /// Panel de documentos y estado oficial RUNT del vehículo.
  /// CONTRACT: Get.toNamed(Routes.runtConsult, arguments: AssetVehiculoEntity)
  static const runtConsult = _Paths.runtConsult;

  /// Detalle de licencia de conducción del propietario del vehículo.
  /// CONTRACT: Get.toNamed(Routes.driverLicenseDetail,
  ///   arguments: {'data': VrcDataModel, 'checkedAt': DateTime?})
  static const driverLicenseDetail = _Paths.driverLicenseDetail;

  /// Detalle SIMIT Persona del propietario del vehículo.
  /// CONTRACT: Get.toNamed(Routes.simitPersonDetail,
  ///   arguments: {'data': VrcDataModel, 'checkedAt': DateTime?})
  static const simitPersonDetail = _Paths.simitPersonDetail;

  /// Detalle de ítems individuales SIMIT filtrados por tipo.
  /// CONTRACT: Get.toNamed(Routes.simitFineDetail,
  ///   arguments: {'data': VrcDataModel, 'type': String, 'checkedAt': DateTime?})
  ///   type: 'comparendos' | 'multas' | 'acuerdosDePago'
  static const simitFineDetail = _Paths.simitFineDetail;

  // ══════════════════════════════════════════════════════════════════════════
  // ALERTAS
  // ══════════════════════════════════════════════════════════════════════════

  /// Vista global de alertas de la flota.
  /// CONTRACT: no requiere arguments — carga todas las alertas de la org activa.
  static const alertCenter = _Paths.alertCenter;

  // ══════════════════════════════════════════════════════════════════════════
  // FLUJO COTIZACIÓN SRCE (RC Extracontractual)
  // ══════════════════════════════════════════════════════════════════════════

  /// Formulario de solicitud de cotización SRCE.
  /// CONTRACT: Get.toNamed(Routes.rcQuoteRequest, arguments: Map{
  ///   'assetId': String,
  ///   'primaryLabel': String?,
  ///   'secondaryLabel': String?,
  ///   'vehicleSnapshot': VehicleSnapshot?,
  /// })
  static const rcQuoteRequest = _Paths.rcQuoteRequest;

  /// Estado del lead de cotización SRCE creado.
  /// CONTRACT: Get.offNamed(Routes.rcQuoteStatus, arguments: InsuranceOpportunityLead)
  static const rcQuoteStatus = _Paths.rcQuoteStatus;

  // ══════════════════════════════════════════════════════════════════════════
  // DEMO / DESARROLLO
  // ══════════════════════════════════════════════════════════════════════════
  static const bottomNavDemo = _Paths.bottomNavDemo;
  static const demoSoat = _Paths.demoSoat;
}

/// Paths internos - NO usar directamente, usar Routes.*
abstract class _Paths {
  _Paths._();

  // Auth
  static const welcome = '/auth/welcome';
  static const phone = '/auth/phone';
  static const otp = '/auth/otp';
  static const countryCity = '/auth/country-city';
  static const role = '/auth/role';
  static const profile = '/auth/profile';
  static const registerUsername = '/auth/register/username';
  static const registerEmail = '/auth/register/email';
  static const registerIdScan = '/auth/register/id-scan';
  static const loginUserPass = '/auth/login';
  static const loginMfa = '/auth/login/mfa';
  static const registerSummary = '/auth/register/summary';
  static const holderType = '/auth/holder-type';
  static const providerProfile = '/auth/provider/profile';
  static const enhancedRegistration = '/auth/enhanced-registration';
  static const providerCoverage = '/auth/provider/coverage';

  // Core
  static const splash = '/splash';
  static const home = '/home';
  static const orgSelect = '/org_select';

  // Provider
  static const providerHomeArticles = '/provider/home/articles';
  static const providerHomeServices = '/provider/home/services';
  static const providerWorkspaceArticles = '/provider/workspace/articles';
  static const providerWorkspaceServices = '/provider/workspace/services';

  // Módulos
  static const incidencia = '/incidencia';
  static const purchase = '/purchase';
  static const assets = '/assets';
  static const tenantHome = '/tenant/home';

  // Consultas
  static const runtPersonConsult = '/runt/person';
  static const runtVehicleConsult = '/runt/vehicle';
  static const simitConsult = '/simit/multas';
  static const vrcConsult = '/vrc/consult';
  static const vrcResult = '/vrc/result';
  static const vrcBatchProgress = '/vrc/batch/progress';

  // Portfolio / Wizard
  static const createPortfolioStep1 = '/portfolio/create/step1';
  static const createPortfolioStep2 = '/portfolio/create/step2';
  static const runtQueryProgress = '/portfolio/create/runt/progress';
  static const runtQueryResult = '/portfolio/create/runt/result';
  static const portfolioDetail = '/portfolio/detail';
  static const portfolioAssets = '/portfolio/assets';
  static const portfolioAssetLive = '/portfolio/asset/live';
  static const assetDetail = '/asset/detail';

  // Asset registration
  static const assetRegister = '/asset/register';

  // Asset detail modules
  static const assetRtmDetail = '/asset/rtm/detail';
  static const soatDetail = '/asset/insurance/soat';
  static const segurosRcDetail = '/asset/insurance/rc';
  static const legalStatus = '/asset/legal';

  // Asset detail modules (cont.)
  static const vehicleInfo = '/asset/vehicle/info';
  static const runtConsult = '/asset/runt/consult';

  // Owner detail pages
  static const driverLicenseDetail = '/asset/owner/license';
  static const simitPersonDetail = '/asset/owner/simit';
  static const simitFineDetail = '/asset/owner/simit/fines';

  // Alertas
  static const alertCenter = '/alerts/center';

  // Flujo cotización SRCE
  static const rcQuoteRequest = '/insurance/rc/quote/request';
  static const rcQuoteStatus = '/insurance/rc/quote/status';

  // Demo
  static const bottomNavDemo = '/demo/bottom-nav';
  static const demoSoat = '/campaign/soat';
}

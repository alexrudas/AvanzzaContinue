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
  static const registerTerms = _Paths.registerTerms;
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
  // CONSULTAS EXTERNAS (RUNT / SIMIT)
  // ══════════════════════════════════════════════════════════════════════════
  static const runtPersonConsult = _Paths.runtPersonConsult;
  static const runtVehicleConsult = _Paths.runtVehicleConsult;
  static const simitConsult = _Paths.simitConsult;

  // ══════════════════════════════════════════════════════════════════════════
  // PORTFOLIO / WIZARD
  // ══════════════════════════════════════════════════════════════════════════
  static const createPortfolioStep1 = _Paths.createPortfolioStep1;
  static const createPortfolioStep2 = _Paths.createPortfolioStep2;

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
  static const registerTerms = '/auth/register/terms';
  static const loginUserPass = '/auth/login';
  static const loginMfa = '/auth/login/mfa';
  static const registerSummary = '/auth/register/summary';
  static const holderType = '/auth/holder-type';
  static const providerProfile = '/auth/provider/profile';
  static const enhancedRegistration = '/auth/enhanced-registration';
  static const providerCoverage = '/auth/provider/coverage';

  // Core
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

  // Portfolio / Wizard
  static const createPortfolioStep1 = '/portfolio/create/step1';
  static const createPortfolioStep2 = '/portfolio/create/step2';

  // Demo
  static const bottomNavDemo = '/demo/bottom-nav';
  static const demoSoat = '/campaign/soat';
}

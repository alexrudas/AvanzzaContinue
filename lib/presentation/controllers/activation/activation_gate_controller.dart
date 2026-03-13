// ============================================================================
// lib/presentation/controllers/activation/activation_gate_controller.dart
// ACTIVATION GATE CONTROLLER — Enterprise Ultra Pro
//
// QUÉ HACE
// - Controla la visibilidad del ActivationGateOverlay.
// - Deriva el copy del overlay mediante ActivationGateConfig.forRole().
// - Expone las acciones del overlay (CTA principal y dismiss de sesión).
// - Evalúa si el usuario tiene activos registrados en el contexto actual.
//
// QUÉ NO HACE
// - No carga activos desde el repositorio.
// - No consulta repositorios directamente.
// - No contiene lógica de dominio de activos.
// - No persiste el descarte del gate entre sesiones.
//
// PRINCIPIOS
// - Controller puramente de presentación.
// - Reacciona a cambios de estado externos mediante workers GetX.
// - Anti-flicker: nunca mostrar gate durante loading.
// - Session-only dismiss: el descarte vive solo en memoria.
// - Single source of UI truth: showGate es el único estado que la vista consume.
//
// LIMITACIÓN ARQUITECTÓNICA ACTUAL
// Este controller consume AdminHomeController.assetsCount como fuente de
// conteo de activos. Esto es un adaptador temporal de UI, no la fuente de
// verdad final de dominio.
//
// Hoy funciona porque AdminHomeController ya hidrata el estado del Home y
// conoce el conteo de activos del contexto activo. Eso evita lecturas
// duplicadas y simplifica el MVP.
//
// La arquitectura objetivo debe migrar a una fuente de dominio reutilizable:
//
//     AssetRepository.countAssets(orgId)
//     CountUserAssetsUseCase
//
// para eliminar la dependencia con un controller de pantalla y permitir que
// el gate funcione en cualquier contexto sin AdminHomeController.
//
// DEPENDENCIAS EN EL BINDING
// ActivationGateController debe registrarse DESPUÉS de AdminHomeController
// en AdminHomeBinding, porque resuelve esa dependencia en onInit().
//
// DECISIÓN DE DISEÑO
// Se usan referencias `late final` a los controllers dependientes:
//
//     _homeCtrl
//     _sessionCtrl
//
// porque este controller asume un ciclo de vida estable dentro del binding
// del Home. Esto reduce ruido de Get.find() repetidos y deja el código más
// limpio. Si en el futuro el ciclo de vida de los controllers cambia, esta
// decisión debe re-evaluarse junto con la migración a un UseCase de dominio.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../widgets/activation/activation_gate_config.dart';
import '../admin/home/admin_home_controller.dart';
import '../session_context_controller.dart';

class ActivationGateController extends GetxController {
  // ── Dependencias resueltas desde DI ────────────────────────────────────────

  /// Controller del Home administrativo.
  ///
  /// Fuente temporal de:
  /// - assetsCount
  /// - loading
  ///
  /// Nota: esto es un adapter de UI. Ver "LIMITACIÓN ARQUITECTÓNICA ACTUAL".
  late final AdminHomeController _homeCtrl;

  /// Controller de sesión.
  ///
  /// Fuente de:
  /// - user
  /// - userRx
  /// - activeContext.rol
  ///
  /// Se usa únicamente para derivar el copy del ActivationGate.
  late final SessionContextController _sessionCtrl;

  // ── Estado público ─────────────────────────────────────────────────────────

  /// true → overlay visible y bloqueante.
  /// false → contenido accesible.
  ///
  /// Este es el único estado que la vista debe observar para decidir si monta
  /// el ActivationGateOverlay.
  ///
  /// El valor inicial es false para evitar flicker antes de la primera
  /// evaluación.
  final showGate = false.obs;

  /// Configuración visual y textual del overlay.
  ///
  /// Siempre debe tener un valor válido antes del primer frame visible para
  /// evitar estados intermedios sin copy.
  late final Rx<ActivationGateConfig> config;

  // ── Estado privado ─────────────────────────────────────────────────────────

  /// Flag session-only: true si el usuario descartó manualmente el gate.
  ///
  /// NO persiste en Isar, SharedPreferences ni backend.
  /// Se destruye con este controller (logout, cambio de ruta, dispose).
  bool _dismissedThisSession = false;

  /// Workers GetX que sincronizan el gate con el estado de sus dependencias.
  Worker? _assetsWorker;
  Worker? _loadingWorker;
  Worker? _userWorker;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    _homeCtrl = Get.find<AdminHomeController>();
    _sessionCtrl = Get.find<SessionContextController>();

    // Inicializar config ANTES de registrar workers garantiza que, si la vista
    // intenta leerla desde el primer frame, ya tenga copy válido y consistente.
    config = Rx<ActivationGateConfig>(_resolveConfig());

    _setupWorkers();

    // Evaluación inicial:
    // AdminHomeController puede ya venir con datos cargados o parcialmente
    // hidratados. Esto asegura que el gate quede en un estado correcto desde el
    // inicio de la pantalla.
    _evaluateGate();
  }

  @override
  void onClose() {
    _assetsWorker?.dispose();
    _loadingWorker?.dispose();
    _userWorker?.dispose();
    super.onClose();
  }

  // ── Workers reactivos ──────────────────────────────────────────────────────

  /// Registra los workers que mantienen el gate sincronizado con:
  /// - el conteo de activos
  /// - el estado de loading
  /// - el rol/contexto activo del usuario
  void _setupWorkers() {
    // TEMPORARY ADAPTER
    // AdminHomeController.assetsCount se usa como fuente de conteo
    // hasta que exista un AssetCountProvider o UseCase de dominio reutilizable.
    _assetsWorker = ever(_homeCtrl.assetsCount, (_) => _evaluateGate());

    // Anti-flicker:
    // sin este worker el gate podría mostrarse brevemente durante _loadLocal()
    // o mientras el Home aún no termina de hidratar assetsCount.
    _loadingWorker = ever(_homeCtrl.loading, (_) => _evaluateGate());

    // Si cambia el usuario o su activeContext, actualizamos el copy del gate.
    // Esto cubre cambios de workspace/rol dentro de la misma sesión.
    _userWorker = ever(_sessionCtrl.userRx, (_) {
      config.value = _resolveConfig();
      _evaluateGate();
    });
  }

  // ── Evaluación del gate ────────────────────────────────────────────────────

  /// Determina si el gate debe mostrarse según el estado actual.
  ///
  /// Orden de prioridad (intencional):
  ///
  /// 1. dismissed → false inmediato
  ///    Si el usuario ya descartó el gate en esta sesión, no debe reaparecer
  ///    mientras este controller siga vivo, incluso si assetsCount sigue en 0.
  ///
  /// 2. loading → false
  ///    Mientras el Home no termina de hidratar su estado, mostrar el gate
  ///    causaría parpadeos visuales y una mala UX.
  ///
  /// 3. assetsCount == 0 → true
  ///    Cuando el estado ya está cargado y no hay activos, se muestra el gate.
  void _evaluateGate() {
    if (_dismissedThisSession) {
      showGate.value = false;
      _debugLog('gate=false (dismissed this session)');
      return;
    }

    if (_homeCtrl.loading.value) {
      showGate.value = false;
      _debugLog('gate=false (loading)');
      return;
    }

    final shouldShow = _homeCtrl.assetsCount.value == 0;
    showGate.value = shouldShow;

    _debugLog(
      'gate=$shouldShow (assetsCount=${_homeCtrl.assetsCount.value})',
    );
  }

  // ── Derivación de config ───────────────────────────────────────────────────

  /// Retorna la config adecuada al rol activo del usuario.
  ///
  /// Actualmente delega en ActivationGateConfig.forRole().
  ///
  /// En Sprint 2 esto debe migrar a:
  ///     ActivationGateConfig.forWorkspaceMode()
  ///
  /// cuando WorkspaceMode sea la fuente de verdad del contexto UI.
  ActivationGateConfig _resolveConfig() {
    final role = _sessionCtrl.user?.activeContext?.rol;
    return ActivationGateConfig.forRole(role);
  }

  // ── Acciones públicas ──────────────────────────────────────────────────────

  /// CTA principal del overlay.
  ///
  /// Punto de entrada actual al flujo de activos. Desde Routes.assets el
  /// usuario puede iniciar el proceso de registro de su primer activo.
  ///
  /// TODO PRODUCT
  /// Idealmente esta acción debe navegar directamente al onboarding de creación
  /// de activos (ej. Routes.assetCreateStep1) cuando exista como ruta dedicada,
  /// evitando el paso intermedio por la lista de activos.
  void onCtaPressed() {
    _debugLog('onCtaPressed → ${Routes.assets}');
    Get.toNamed(Routes.assets);
  }

  /// Descarta el overlay para el resto de la sesión actual.
  ///
  /// El gate reaparecerá en la siguiente sesión si el usuario sigue sin
  /// activos registrados.
  ///
  /// Este método existe para permitir exploración limitada del producto sin
  /// bloquear completamente al usuario cuando todavía no desea crear activos.
  void dismissForSession() {
    _dismissedThisSession = true;
    showGate.value = false;
    _debugLog('gate dismissed for session');
  }

  // ── Debug ──────────────────────────────────────────────────────────────────

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[ActivationGateCtrl] $message');
    }
  }
}

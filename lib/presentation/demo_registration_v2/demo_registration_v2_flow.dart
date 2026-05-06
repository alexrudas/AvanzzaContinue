// ============================================================================
// DEMO REGISTRATION V2 — FLOW SHELL (TEMPORARY, SAFE TO DELETE)
//
// Punto único de entrada del demo. Mantiene el estado en memoria (DemoRegistrationState)
// y cambia entre las pantallas usando AnimatedSwitcher. Al salir/cerrar la app,
// todo el estado se descarta.
//
// Pasos lógicos del nuevo orden (registro corto → bienvenida → config negocio):
//   0 P1 Welcome + Phone + Terms             (Paso 1 de 5)
//   1 P2 OTP                                  (Paso 2 de 5)
//   2 P3 Role + Scope                         (Paso 3 de 5)
//   3 P4 Welcome (celebración, sin nombre)    (sin scaffold)
//   4 P5 Tu negocio (persona/empresa, ciudad) (Paso 4 de 5)
//   5 P6 Config específico de rol             (Paso 5 de 5, condicional)
//   6 P7 Workspace mock (final)               (sin scaffold)
//
// Routing post-P4 (welcome):
//   - Continuar → P5 (Tu negocio).
//   - Skip      → P7 con configSkipped=true (banner persistente).
//
// Routing post-P5 (Tu negocio):
//   - Continuar → P6 si roleNeedsConfig; si no, P7 directo.
//     Caso "Aseguradora empresa": titularType se conoce acá → salta P6.
//   - Skip      → P7 con configSkipped=true.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'demo_state.dart';
import 'screens/p1_welcome.dart';
import 'screens/p2_otp.dart';
import 'screens/p3_role.dart';
import 'screens/p4_welcome.dart';
import 'screens/p5_business.dart';
import 'screens/p6_asset_register.dart';
import 'screens/p6_config_mock.dart';
import 'screens/p7_workspace_mock.dart';

class DemoRegistrationV2Flow extends StatefulWidget {
  const DemoRegistrationV2Flow({super.key});

  @override
  State<DemoRegistrationV2Flow> createState() => _DemoRegistrationV2FlowState();
}

class _DemoRegistrationV2FlowState extends State<DemoRegistrationV2Flow> {
  late final DemoRegistrationState _state;

  // Constantes de pasos lógicos (índice del array de pantallas, no de UI).
  static const _stepP1 = 0; // phone
  static const _stepP2 = 1; // OTP
  static const _stepP3 = 2; // role
  static const _stepP4 = 3; // welcome
  static const _stepP5 = 4; // tu negocio
  static const _stepP6 = 5; // config específico
  static const _stepP7 = 6; // workspace mock

  @override
  void initState() {
    super.initState();
    _state = DemoRegistrationState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  // ── Routing actions ───────────────────────────────────────────────────────

  void _next() => _state.next();
  void _back() => _state.back();

  /// Desde P4 (welcome): el usuario quiere continuar a configurar su negocio.
  void _onWelcomeContinue() => _state.goTo(_stepP5);

  /// Desde P5 (Tu negocio): el usuario completó identidad/ubicación.
  /// Si su rol no necesita config específica, salta P6 → P7 directo.
  void _onBusinessContinue() {
    if (!_state.roleNeedsConfig) {
      _state.update(() {
        _state.configCompleted = true;
        _state.configSkipped = false;
      });
      _state.goTo(_stepP7);
    } else {
      _state.goTo(_stepP6);
    }
  }

  /// Skip universal: descarta el resto de configuración y va al workspace
  /// mock con banner persistente. Aplica desde P4 (welcome), P5 (Tu negocio)
  /// y P6 (Config específico).
  void _onSkip() {
    _state.update(() {
      _state.configSkipped = true;
      _state.configCompleted = false;
    });
    _state.goTo(_stepP7);
  }

  /// Desde P6: el usuario completó la configuración específica → P7.
  void _onConfigComplete() => _state.goTo(_stepP7);

  /// Desde P7 (banner): vuelve al primer paso pendiente (P5 si no hay nombre,
  /// o P6 si ya tiene nombre pero no completó config específica).
  void _onReconfigureFromP7() {
    _state.update(() {
      _state.configSkipped = false;
    });
    if (_state.fullNameOrCompany.trim().isEmpty || _state.city.trim().isEmpty) {
      _state.goTo(_stepP5);
    } else {
      _state.goTo(_stepP6);
    }
  }

  void _exit() => Get.back();

  void _reset() => _state.reset();

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final child = _buildStep();

    return PopScope(
      canPop: _state.step == _stepP1,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_state.step > _stepP1) _state.back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_state.step),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_state.step) {
      case _stepP1:
        return P1Welcome(state: _state, onNext: _next);
      case _stepP2:
        return P2Otp(state: _state, onNext: _next, onBack: _back);
      case _stepP3:
        return P3Role(state: _state, onNext: _next, onBack: _back);
      case _stepP4:
        return P4Welcome(
          state: _state,
          onContinue: _onWelcomeContinue,
          onSkip: _onSkip,
        );
      case _stepP5:
        return P5Business(
          state: _state,
          onContinue: _onBusinessContinue,
          onSkip: _onSkip,
          onBack: () => _state.goTo(_stepP4),
        );
      case _stepP6:
        // Owner / Admin: flujo real de registro de activo.
        if (_state.role == DemoRoleCode.owner ||
            _state.role == DemoRoleCode.assetAdmin) {
          return P6AssetRegister(
            state: _state,
            onComplete: _onConfigComplete,
            onSkip: _onSkip,
            onBack: () => _state.goTo(_stepP5),
          );
        }
        // Renter / Provider / Aseguradora-empresa no llegan acá (saltado vía
        // roleNeedsConfig=false). Insurer-persona / Legal: mock.
        return P6ConfigMock(
          state: _state,
          onComplete: _onConfigComplete,
          onSkip: _onSkip,
          onBack: () => _state.goTo(_stepP5),
        );
      case _stepP7:
      default:
        return P7WorkspaceMock(
          state: _state,
          onConfigure: _onReconfigureFromP7,
          onReset: _reset,
          onExit: _exit,
        );
    }
  }
}

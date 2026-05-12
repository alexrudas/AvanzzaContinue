// ============================================================================
// DEMO REGISTRATION V2 — P2: OTP
//
// CABLEADO Firebase Auth real (ítem 11.1):
//   El CTA "Verificar" llama a VerifyOtpUC (Get.find canónico) usando el
//   verificationId persistido en P1. En éxito marca firebaseAuthenticated=
//   true en el state demo y avanza. Errores se muestran inline con
//   mensajes claros mapeados.
//
// Auto-skip:
//   Si Firebase auto-verificó en P1 (state.firebaseAuthenticated == true),
//   esta pantalla salta directo a onNext en initState — el usuario ya está
//   autenticado y no debe ingresar código.
//
// Reusa `OtpInputWidget` de producción (lib/presentation/auth/widgets/).
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/load_initial_cache_uc.dart';
import '../../../domain/usecases/verify_otp_uc.dart';
import '../../auth/widgets/otp_input_widget.dart';
import '../../controllers/session_context_controller.dart';
import '../demo_state.dart';
import '../widgets/demo_step_scaffold.dart';

class P2Otp extends StatefulWidget {
  final DemoRegistrationState state;
  final VoidCallback onNext;
  final VoidCallback onBack;

  /// Total de pasos a mostrar en el indicador "Paso N de M".
  /// Default 5 = Demo 1 legacy. FusionadoFlow pasa 4 (Q5 fue eliminado).
  final int totalSteps;

  const P2Otp({
    super.key,
    required this.state,
    required this.onNext,
    required this.onBack,
    this.totalSteps = 5,
  });

  @override
  State<P2Otp> createState() => _P2OtpState();
}

/// Estados del CTA + del proceso de autenticación + hidratación:
/// - idle      → esperando input del código
/// - verifying → llamando VerifyOtpUC (Firebase signInWithCredential)
/// - hydrating → OTP OK, ahora cargando cache (LoadInitialCacheUC) + session.init
/// - verified  → todo listo, listo para avanzar a Q3
enum _VerifyState { idle, verifying, hydrating, verified }

class _P2OtpState extends State<P2Otp> {
  static const _resendSeconds = 30;

  Timer? _timer;
  int _remaining = _resendSeconds;

  String _code = '';
  _VerifyState _verifyState = _VerifyState.idle;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Auto-skip: si Firebase auto-verificó en P1 (Android Instant Verify
    // o emulator con número de prueba), el usuario ya está autenticado.
    // Saltamos esta pantalla sin esperar input del SMS.
    if (widget.state.firebaseAuthenticated &&
        FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onNext();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _remaining = _resendSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) {
          _remaining -= 1;
        } else {
          t.cancel();
        }
      });
    });
  }

  bool get _canVerify =>
      _code.length == 6 && _verifyState == _VerifyState.idle;

  Future<void> _onVerify() async {
    if (!_canVerify) return;
    setState(() {
      _verifyState = _VerifyState.verifying;
      _errorMsg = null;
    });

    // ── Path de retry tras fallo de hidratación ────────────────────────
    // Si Firebase ya autenticó (firebaseAuthenticated=true + currentUser
    // poblado), el código OTP ya se consumió. Re-llamar verifyOtp fallaría
    // con `invalid-verification-code`. Saltamos directo a re-hidratar.
    final preExistingUser = FirebaseAuth.instance.currentUser;
    if (widget.state.firebaseAuthenticated && preExistingUser != null) {
      await _hydrate(preExistingUser.uid);
      return;
    }

    final vid = widget.state.verificationId;
    if (vid == null) {
      // No deberíamos llegar aquí: P1 garantiza que verificationId esté
      // poblado antes de avanzar a P2 (excepto en auto-verify, que ya
      // habría disparado el skip de initState).
      setState(() {
        _verifyState = _VerifyState.idle;
        _errorMsg = 'Sesión expirada. Vuelve a P1 para reenviar el código.';
      });
      return;
    }

    final VerifyOtpUC verifyOtp;
    try {
      verifyOtp = Get.find<VerifyOtpUC>();
    } catch (_) {
      // Fallback: GetX no inicializado (test/preview). Mantén comportamiento
      // legacy demo para no romper builds sin Firebase.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      widget.state.update(() {
        widget.state.otp = _code;
        widget.state.otpVerified = true;
      });
      setState(() => _verifyState = _VerifyState.verified);
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      widget.onNext();
      return;
    }

    try {
      await verifyOtp(verificationId: vid, smsCode: _code);
      // Confirmamos que Firebase realmente autenticó. Si por alguna razón
      // currentUser sigue null, lo tratamos como error duro — no permitir
      // avanzar a Q6 con sesión inválida.
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _verifyState = _VerifyState.idle;
          _errorMsg = 'No se completó la autenticación. Intenta de nuevo.';
        });
        return;
      }
      if (!mounted) return;
      widget.state.update(() {
        widget.state.otp = _code;
        widget.state.otpVerified = true;
        widget.state.firebaseAuthenticated = true;
      });

      await _hydrate(user.uid);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _verifyState = _VerifyState.idle;
        _errorMsg = _mapVerifyError(e.code);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _verifyState = _VerifyState.idle;
        _errorMsg = 'Error inesperado al verificar el código.';
      });
    }
  }

  /// Hidrata sesión post-OTP: carga perfil + permisos en cache local
  /// (LoadInitialCacheUC) e inicializa SessionContextController con el uid.
  ///
  /// Diseño:
  /// - NO navega a home: permanecemos dentro de FusionadoFlow para que
  ///   Q3–Q6 continúen el onboarding del founder.
  /// - SessionContextController.init es single-flight, así que llamarlo
  ///   aquí explícitamente es seguro aunque AuthStateObserver también
  ///   reaccione al authStateChanges.
  /// - En error: dejamos firebaseAuthenticated=true (Firebase ya autenticó)
  ///   y volvemos a idle con mensaje claro. El siguiente tap en "Verificar"
  ///   detecta el estado y reintenta solo la hidratación (sin re-consumir
  ///   el OTP, que ya fue gastado).
  Future<void> _hydrate(String uid) async {
    if (!mounted) return;
    setState(() {
      _verifyState = _VerifyState.hydrating;
      _errorMsg = null;
    });

    try {
      final loadCache = Get.find<LoadInitialCacheUC>();
      await loadCache(uid);

      if (Get.isRegistered<SessionContextController>()) {
        await Get.find<SessionContextController>().init(uid);
      }

      if (!mounted) return;
      setState(() => _verifyState = _VerifyState.verified);

      // Pequeña pausa para que el usuario vea el estado "Verificado"
      // antes de avanzar a Q3.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      widget.onNext();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _verifyState = _VerifyState.idle;
        _errorMsg =
            'Tu teléfono se verificó, pero no pudimos cargar tu perfil. '
            'Toca "Verificar" para reintentar.';
      });
    }
  }

  String _mapVerifyError(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return 'Código inválido. Verifica los 6 dígitos.';
      case 'session-expired':
      case 'code-expired':
        return 'El código expiró. Reenvíalo desde el botón.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera unos minutos.';
      case 'network-request-failed':
        return 'Sin conexión. Revisa tu red e intenta de nuevo.';
      default:
        return 'No se pudo verificar el código. Intenta de nuevo.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fullPhone =
        '${widget.state.countryDialCode} ${widget.state.phone}';

    return DemoStepScaffold(
      currentStep: 1,
      totalSteps: widget.totalSteps,
      title: 'Ingresa el código',
      onBack: widget.onBack,
      primaryAction: _buildPrimaryAction(theme, cs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enviamos un código de 6 dígitos a $fullPhone',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          OtpInputWidget(
            length: 6,
            onChanged: (code) {
              setState(() => _code = code);
            },
            onCompleted: (code) {
              setState(() => _code = code);
            },
          ),
          if (_errorMsg != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.error.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded,
                      color: cs.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMsg!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Center(
            child: _remaining > 0
                ? Text(
                    'Reenviar en ${_remaining}s',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  )
                : TextButton(
                    onPressed: _startTimer,
                    child: const Text('Reenviar código'),
                  ),
          ),
        ],
      ),
    );
  }

  /// Construye el CTA según el estado de verificación.
  /// - idle      → FilledButton "Verificar" (disabled si código incompleto)
  /// - verifying → FilledButton disabled con spinner + "Verificando..."
  /// - hydrating → FilledButton disabled con spinner + "Cargando tu cuenta..."
  /// - verified  → Container con bg primaryContainer + ✓ + "Verificado"
  Widget _buildPrimaryAction(ThemeData theme, ColorScheme cs) {
    switch (_verifyState) {
      case _VerifyState.hydrating:
        return FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    cs.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Cargando tu cuenta...'),
            ],
          ),
        );

      case _VerifyState.verified:
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.primary, width: 1.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: cs.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Verificado',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );

      case _VerifyState.verifying:
        return FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    cs.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Verificando...'),
            ],
          ),
        );

      case _VerifyState.idle:
        return FilledButton(
          onPressed: _canVerify ? _onVerify : null,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text('Verificar'),
        );
    }
  }
}

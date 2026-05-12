// ============================================================================
// lib/presentation/auth/pages/desktop_login_page.dart
// DESKTOP LOGIN PAGE — entrypoint companion administrativo
// ============================================================================
// QUÉ HACE:
//   - Es la primera pantalla que ve un usuario sin sesión en Windows.
//   - UI mínima, enterprise: logo + título + usuario + contraseña + CTA.
//   - Reusa `LoginPasswordController` (cero duplicación de lógica auth).
//   - Tras login exitoso, el controller invoca `Routes.splash` que recalcula
//     el destino correcto (workspace / profile / countryCity).
//
// QUÉ NO HACE:
//   - NO ofrece OTP, providers federados, ni onboarding largo. Ese flujo
//     vive en `auth_welcome_page` y solo se sirve en móvil (gateado por
//     `SplashBootstrapController._runGates()` vía `PlatformCapabilities`).
//   - NO maneja registro. Para crear cuenta el usuario debe activar el
//     acceso de escritorio desde la app móvil (vía linkWithCredential,
//     planeado como feature de Phase 1+).
//   - NO duplica routing post-auth: delega en `Routes.splash`.
//
// UX REQUIREMENTS:
//   - Autofocus en el campo usuario al entrar.
//   - Enter en cualquiera de los campos dispara el login.
//   - Botón muestra "Ingresando..." durante `signing`.
//   - Errores se muestran inline, no como snackbar (mejor en desktop).
//   - Si por alguna razón se navega aquí en móvil, rebota a la welcome
//     canónica (defensa contra deep link o navegación accidental).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/platform/platform_capabilities.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_password_controller.dart';

class DesktopLoginPage extends StatefulWidget {
  const DesktopLoginPage({super.key});

  @override
  State<DesktopLoginPage> createState() => _DesktopLoginPageState();
}

class _DesktopLoginPageState extends State<DesktopLoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _userFocus = FocusNode();
  final _passFocus = FocusNode();
  late final LoginPasswordController _ctrl;

  @override
  void initState() {
    super.initState();

    // Defensa: si por deep link o navegación accidental aterrizamos aquí
    // en móvil, rebotamos a la welcome canónica. Mantiene el invariante
    // "desktop login solo en desktop" sin acoplar la decisión a la UI.
    if (!PlatformCapabilities.isDesktopCompanion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Get.offAllNamed(Routes.welcome);
      });
    }

    if (Get.isRegistered<LoginPasswordController>(tag: 'desktop_login')) {
      _ctrl = Get.find<LoginPasswordController>(tag: 'desktop_login');
    } else {
      _ctrl = LoginPasswordController(
        signInUC: Get.find(),
        sendMfaUC: Get.find(),
        verifyMfaUC: Get.find(),
      );
      Get.put<LoginPasswordController>(_ctrl, tag: 'desktop_login');
    }

    // Autofocus en usuario al primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _userFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    _userFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final user = _userCtrl.text.trim();
    final pass = _passCtrl.text;
    if (user.isEmpty || pass.isEmpty) {
      _ctrl.errorMessage.value = 'Usuario y contraseña requeridos.';
      return;
    }
    _ctrl.signIn(user, pass);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.dashboard_rounded, size: 48, color: cs.primary),
                const SizedBox(height: 20),
                Text(
                  'Avanzza',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Acceso desde escritorio',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                Obx(() {
                  final status = _ctrl.status.value;
                  final isBusy = status == 'signing';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _userCtrl,
                        focusNode: _userFocus,
                        enabled: !isBusy,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _passFocus.requestFocus(),
                      ),
                      const SizedBox(height: 14),
                      // CallbackShortcuts: Enter en password dispara login,
                      // sin depender de `onSubmitted` (que puede no firar en
                      // algunos hosts desktop con autofill).
                      CallbackShortcuts(
                        bindings: {
                          const SingleActivator(LogicalKeyboardKey.enter):
                              _submit,
                          const SingleActivator(
                                  LogicalKeyboardKey.numpadEnter): _submit,
                        },
                        child: TextField(
                          controller: _passCtrl,
                          focusNode: _passFocus,
                          enabled: !isBusy,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final err = _ctrl.errorMessage.value;
                        if (err == null || err.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline_rounded,
                                  size: 18, color: cs.onErrorContainer),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  err,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      FilledButton(
                        onPressed: isBusy ? null : _submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isBusy ? 'Ingresando...' : 'Iniciar sesión'),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.smartphone_rounded,
                          size: 18, color: cs.onSurfaceVariant),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Activa el acceso escritorio desde la app móvil. '
                          'El registro y la recuperación de cuenta se hacen '
                          'desde tu teléfono.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

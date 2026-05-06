// ============================================================================
// lib/presentation/auth/pages/auth_welcome_page.dart
// AUTH WELCOME PAGE — Enterprise Ultra Pro (Presentation / Auth / Pages)
//
// QUÉ HACE:
// - Punto de entrada principal al flujo de autenticación.
// - OTP teléfono como método primario (CTA principal).
// - Google, Apple, Microsoft, Facebook como opciones alternativas.
// - Apple / Microsoft / Facebook: "Próximamente" (placeholder sin romper UI).
//
// QUÉ NO HACE:
// - NO ofrece registro por email/password (eliminado del flujo principal).
// - NO navega a registerUsername ni a loginUserPass desde aquí.
// - No contiene lógica de autenticación; delega a AuthController.
//
// FLUJO POST-AUTENTICACIÓN:
// OTP verificado → AuthController → Routes.home → SplashBootstrapController:
//   S1 (nuevo usuario) → countryCity → profile → home → ActivationGate
//   S3 (usuario existente) → workspace directo
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AuthWelcomePage extends StatelessWidget {
  const AuthWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      // TEMPORARY — FAB del demo de registro v2 (solo en builds debug).
      // Abre un bottom sheet con dos opciones de demo:
      //   - Demo 1 (actual): el flujo validado.
      //   - Demo 2 (fusionado): variante experimental con RUNT temprano.
      // Borrar este `floatingActionButton` cuando se elimine la carpeta
      // `lib/presentation/demo_registration_v2/`.
      floatingActionButton: kDebugMode
          ? FloatingActionButton.extended(
              heroTag: 'demo_registration_v2_fab',
              onPressed: () => _showDemoMenu(context),
              icon: const Icon(Icons.science_rounded),
              label: const Text('Registro Demo'),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Marca ─────────────────────────────────────────────────
                  Icon(
                    Icons.dashboard_rounded,
                    size: 56,
                    color: cs.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Avanzza',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestiona tus activos con inteligencia.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // ── CTA primario: Onboarding canónico (FusionadoFlow) ─────
                  FilledButton.icon(
                    onPressed: () => Get.toNamed(Routes.registerOnboarding),
                    icon: const Icon(Icons.phone_android_rounded),
                    label: const Text('Continuar con teléfono'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  // ── Fallback al flujo legacy (link discreto) ──────────────
                  // Si el FusionadoFlow tiene un bug en producción, este link
                  // permite al usuario completar registro vía el flujo legacy
                  // (Routes.phone → otp_verify → countryCity → profile → ...).
                  // Mantener visible al menos hasta que el FusionadoFlow esté
                  // validado en producción durante 2 sprints completos.
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.phone),
                      child: Text(
                        '¿Problemas? Usar flujo clásico',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Google ────────────────────────────────────────────────
                  OutlinedButton.icon(
                    onPressed: () => Get.toNamed(Routes.enhancedRegistration),
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                    label: const Text('Continuar con Google'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Apple ─────────────────────────────────────────────────
                  _ComingSoonButton(
                    icon: Icons.apple_rounded,
                    label: 'Continuar con Apple',
                    colorScheme: cs,
                    theme: theme,
                  ),

                  const SizedBox(height: 12),

                  // ── Microsoft ─────────────────────────────────────────────
                  _ComingSoonButton(
                    icon: Icons.window_rounded,
                    label: 'Continuar con Microsoft',
                    colorScheme: cs,
                    theme: theme,
                  ),

                  const SizedBox(height: 12),

                  // ── Facebook ──────────────────────────────────────────────
                  _ComingSoonButton(
                    icon: Icons.facebook_rounded,
                    label: 'Continuar con Facebook',
                    colorScheme: cs,
                    theme: theme,
                  ),

                  const SizedBox(height: 40),

                  // ── Footer legal ──────────────────────────────────────────
                  Text(
                    'Al continuar, aceptas los Términos de uso y la\nPolítica de privacidad de Avanzza.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// TEMPORARY — Muestra el bottom sheet con las 2 variantes del demo.
  /// Borrar junto con la carpeta `demo_registration_v2/`.
  void _showDemoMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final cs = theme.colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Variantes del demo',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _DemoOption(
                  icon: Icons.fact_check_rounded,
                  title: 'Demo 1 (actual)',
                  subtitle:
                      'Flujo validado. Phone → OTP → Perfil → Bienvenida → Tu negocio → Activo → Workspace.',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.demoRegistrationV2);
                  },
                  colorScheme: cs,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                _DemoOption(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Demo 2 (fusionado)',
                  subtitle:
                      'Variante experimental. Phone → OTP → ¿Qué quieres hacer? → RUNT temprano → Relación → Tu negocio → Workspace.',
                  highlight: true,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.demoRegistrationV2Fusionado);
                  },
                  colorScheme: cs,
                  theme: theme,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// TEMPORARY — Card del menú de demos. Borrar junto con la carpeta del demo.
class _DemoOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlight;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _DemoOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.colorScheme,
    required this.theme,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlight
          ? colorScheme.primary.withValues(alpha: 0.08)
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: highlight
                  ? colorScheme.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: highlight
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón de método de auth aún no disponible.
/// Muestra un SnackBar de "Próximamente" al presionar; no navega ni rompe el flujo.
class _ComingSoonButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _ComingSoonButton({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Get.snackbar(
          'Próximamente',
          'Este método de acceso estará disponible pronto.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      },
      icon: Icon(icon, size: 22),
      label: Row(
        children: [
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Próximamente',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.5),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

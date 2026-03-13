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

                  // ── CTA primario: OTP ──────────────────────────────────────
                  FilledButton.icon(
                    onPressed: () => Get.toNamed(Routes.phone),
                    icon: const Icon(Icons.phone_android_rounded),
                    label: const Text('Continuar con teléfono'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/enhanced_registration_controller.dart';
import 'auth_method_button.dart';

/// FederatedAuthButtons - Grupo de botones para auth federada
///
/// Métodos disponibles:
/// - Google Sign-In (funcional)
/// - Apple / Facebook: placeholder "Próximamente"
///
/// Email/password eliminado del flujo principal (ver AuthWelcomePage → Routes.phone).
class FederatedAuthButtons extends StatelessWidget {
  const FederatedAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Google Sign-In (funcional)
        Obx(() => AuthMethodButton(
              label: 'Continuar con Google',
              icon: const Icon(
                Icons.g_mobiledata,
                color: Color(0xFF4285F4), // Google blue
                size: 32,
              ),
              onPressed: controller.signInWithGoogle,
              isLoading: controller.isLoading.value &&
                  controller.selectedAuthMethod.value == 'google',
            )),

        const SizedBox(height: 12),

        // Apple Sign-In (próximamente)
        _ComingSoonMethodButton(
          label: 'Continuar con Apple',
          icon: const Icon(Icons.apple, color: Colors.black, size: 24),
          theme: theme,
        ),

        const SizedBox(height: 12),

        // Facebook Sign-In (próximamente)
        _ComingSoonMethodButton(
          label: 'Continuar con Facebook',
          icon: const Icon(
            Icons.facebook,
            color: Color(0xFF1877F2), // Facebook blue
            size: 24,
          ),
          theme: theme,
        ),
      ],
    );
  }
}

/// Botón de método de auth no disponible aún.
/// Muestra badge "Próximamente" y SnackBar informativo al presionar.
class _ComingSoonMethodButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final ThemeData theme;

  const _ComingSoonMethodButton({
    required this.label,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

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
      icon: icon,
      label: Row(
        children: [
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Próximamente',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        foregroundColor: cs.onSurface.withValues(alpha: 0.5),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

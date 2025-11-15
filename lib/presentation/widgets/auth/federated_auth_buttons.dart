import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/enhanced_registration_controller.dart';
import 'auth_method_button.dart';

/// FederatedAuthButtons - Grupo de botones para auth federada
///
/// Incluye botones para:
/// - Google Sign-In
/// - Apple Sign-In
/// - Facebook Sign-In
/// - Email/Password (opcional)
///
/// Características UI PRO 2025:
/// - Layout vertical con spacing consistente
/// - Logos oficiales de cada proveedor
/// - Animaciones fluidas
/// - Feedback visual claro
class FederatedAuthButtons extends StatelessWidget {
  final bool showEmailPassword;
  final VoidCallback? onEmailPasswordTap;

  const FederatedAuthButtons({
    super.key,
    this.showEmailPassword = true,
    this.onEmailPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Google Sign-In
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

        // Apple Sign-In
        Obx(() => AuthMethodButton(
              label: 'Continuar con Apple',
              icon: const Icon(
                Icons.apple,
                color: Colors.black,
                size: 24,
              ),
              onPressed: controller.signInWithApple,
              isLoading: controller.isLoading.value &&
                  controller.selectedAuthMethod.value == 'apple',
            )),

        const SizedBox(height: 12),

        // Facebook Sign-In
        Obx(() => AuthMethodButton(
              label: 'Continuar con Facebook',
              icon: const Icon(
                Icons.facebook,
                color: Color(0xFF1877F2), // Facebook blue
                size: 24,
              ),
              onPressed: controller.signInWithFacebook,
              isLoading: controller.isLoading.value &&
                  controller.selectedAuthMethod.value == 'facebook',
            )),

        // Divider "O"
        if (showEmailPassword) ...[
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outlineVariant,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'O',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outlineVariant,
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Email/Password
          Obx(() => AuthMethodButton(
                label: 'Continuar con Email',
                icon: Icon(
                  Icons.email_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                onPressed: onEmailPasswordTap ?? () {},
                isLoading: controller.isLoading.value &&
                    controller.selectedAuthMethod.value == 'email-password',
                isOutlined: false,
                backgroundColor: theme.colorScheme.primaryContainer,
                textColor: theme.colorScheme.onPrimaryContainer,
              )),
        ],
      ],
    );
  }
}

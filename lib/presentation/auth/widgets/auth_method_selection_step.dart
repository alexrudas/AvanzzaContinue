import 'package:flutter/material.dart';

import '../../widgets/auth/federated_auth_buttons.dart';

/// AuthMethodSelectionStep - Paso 0: Selección de método de autenticación
///
/// Métodos disponibles:
/// - Google Sign-In (funcional)
/// - Apple / Facebook: placeholder "Próximamente"
///
/// Email/password eliminado del flujo principal.
/// El flujo OTP se inicia desde AuthWelcomePage (Routes.phone), no desde aquí.
class AuthMethodSelectionStep extends StatelessWidget {
  const AuthMethodSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título y descripción
          Text(
            '¿Cómo quieres registrarte?',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Elige tu método de autenticación preferido',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Botones de auth federada (sin opción email/password).
          // Apple y Facebook muestran "Próximamente" internamente.
          const FederatedAuthButtons(),
        ],
      ),
    );
  }
}

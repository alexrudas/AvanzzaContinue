import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/auth/federated_auth_buttons.dart';
import '../../widgets/auth/modern_text_field.dart';
import '../controllers/enhanced_registration_controller.dart';

/// AuthMethodSelectionStep - Paso 0: Selección de método de autenticación
///
/// Permite al usuario elegir entre:
/// - Google Sign-In
/// - Apple Sign-In
/// - Facebook Sign-In
/// - Email/Password tradicional
///
/// UI PRO 2025:
/// - Botones federados con logos
/// - Formulario de email/password con validación
/// - Feedback visual claro
class AuthMethodSelectionStep extends StatefulWidget {
  const AuthMethodSelectionStep({super.key});

  @override
  State<AuthMethodSelectionStep> createState() =>
      _AuthMethodSelectionStepState();
}

class _AuthMethodSelectionStepState extends State<AuthMethodSelectionStep> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showEmailForm = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
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

          // Botones de auth federada
          if (!_showEmailForm)
            FederatedAuthButtons(
              showEmailPassword: true,
              onEmailPasswordTap: () {
                setState(() {
                  _showEmailForm = true;
                });
              },
            ),

          // Formulario de email/password (si el usuario eligió esa opción)
          if (_showEmailForm) _buildEmailPasswordForm(controller, theme),
        ],
      ),
    );
  }

  /// Formulario de registro con email y password
  Widget _buildEmailPasswordForm(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Botón para volver atrás
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showEmailForm = false;
              });
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Volver a opciones'),
          ),

          const SizedBox(height: 16),

          // Email
          ModernTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'tu@email.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email es obligatorio';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Email inválido';
              }
              return null;
            },
            onChanged: (value) {
              controller.email.value = value;
            },
          ),

          const SizedBox(height: 16),

          // Password
          ModernTextField(
            controller: _passwordController,
            label: 'Contraseña',
            hint: 'Mínimo 6 caracteres',
            obscureText: true,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Contraseña es obligatoria';
              }
              if (value.length < 6) {
                return 'Mínimo 6 caracteres';
              }
              return null;
            },
            onChanged: (value) {
              controller.password.value = value;
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password
          ModernTextField(
            controller: _confirmPasswordController,
            label: 'Confirmar contraseña',
            hint: 'Repite tu contraseña',
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Confirma tu contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
            onEditingComplete: () => _submitEmailPassword(controller),
          ),

          const SizedBox(height: 24),

          // Botón de registro
          FilledButton(
            onPressed: () => _submitEmailPassword(controller),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Crear cuenta'),
          ),
        ],
      ),
    );
  }

  /// Enviar formulario de email/password
  Future<void> _submitEmailPassword(
    EnhancedRegistrationController controller,
  ) async {
    if (_formKey.currentState?.validate() ?? false) {
      await controller.signUpWithEmailPassword();
    }
  }
}

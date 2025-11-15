import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/auth/modern_text_field.dart';
import '../../widgets/auth/otp_input_widget.dart';
import '../controllers/enhanced_registration_controller.dart';

/// PhoneMfaStep - Paso 1: MFA obligatorio con teléfono + OTP
///
/// Flujo:
/// 1. Usuario ingresa número de teléfono
/// 2. Se envía código OTP por SMS
/// 3. Usuario ingresa código de 6 dígitos
/// 4. Se verifica el código
///
/// MFA es OBLIGATORIO para todos los métodos de autenticación.
///
/// UI PRO 2025:
/// - Input de teléfono con validación
/// - Widget OTP de 6 dígitos
/// - Timer de reenvío
/// - Feedback visual claro
class PhoneMfaStep extends StatefulWidget {
  const PhoneMfaStep({super.key});

  @override
  State<PhoneMfaStep> createState() => _PhoneMfaStepState();
}

class _PhoneMfaStepState extends State<PhoneMfaStep> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
    final theme = Theme.of(context);

    return Obx(() {
      final otpSent = controller.otpSent.value;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título y descripción
            Text(
              'Verifica tu número de teléfono',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              otpSent
                  ? 'Ingresa el código que enviamos a tu teléfono'
                  : 'Es obligatorio para proteger tu cuenta',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Icono de teléfono
            Icon(
              otpSent ? Icons.lock_clock : Icons.phone_android,
              size: 80,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 32),

            // Si NO se ha enviado OTP: mostrar input de teléfono
            if (!otpSent) _buildPhoneInput(controller, theme),

            // Si YA se envió OTP: mostrar input de código
            if (otpSent) _buildOtpInput(controller, theme),
          ],
        ),
      );
    });
  }

  /// Input de número de teléfono
  Widget _buildPhoneInput(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ModernTextField(
            controller: _phoneController,
            label: 'Número de teléfono',
            hint: '+57 300 123 4567',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.phone),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Número de teléfono es obligatorio';
              }
              if (value.length < 10) {
                return 'Número inválido (mínimo 10 dígitos)';
              }
              return null;
            },
            onChanged: (value) {
              controller.phoneNumber.value = value;
            },
            onEditingComplete: () => _sendOtp(controller),
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () => _sendOtp(controller),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Enviar código'),
          ),

          const SizedBox(height: 12),

          Text(
            'Te enviaremos un código de verificación por SMS',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Input de código OTP (6 dígitos)
  Widget _buildOtpInput(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Número de teléfono (read-only)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                controller.phoneNumber.value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Widget OTP de 6 dígitos
        OtpInputWidget(
          length: 6,
          autoFocus: true,
          onCompleted: (otp) async {
            await controller.verifyMfaOtp(otp);
          },
        ),

        const SizedBox(height: 24),

        // Botón de reenvío
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿No recibiste el código?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final canResend = controller.canResendOtp;
              final seconds = controller.secondsToResend.value;

              return TextButton(
                onPressed: canResend ? controller.resendMfaOtp : null,
                child: Text(
                  canResend ? 'Reenviar' : 'Reenviar ($seconds s)',
                  style: TextStyle(
                    color: canResend
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }),
          ],
        ),

        const SizedBox(height: 12),

        // Botón para cambiar número
        OutlinedButton(
          onPressed: () {
            controller.otpSent.value = false;
            controller.secondsToResend.value = 0;
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Cambiar número de teléfono'),
        ),
      ],
    );
  }

  /// Enviar código OTP
  Future<void> _sendOtp(EnhancedRegistrationController controller) async {
    if (_formKey.currentState?.validate() ?? false) {
      await controller.sendMfaOtp();
    }
  }
}

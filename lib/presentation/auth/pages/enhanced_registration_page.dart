import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/enhanced_registration_controller.dart';
import '../widgets/auth_method_selection_step.dart';
import '../widgets/phone_mfa_step.dart';
import '../widgets/id_scan_step.dart';
import '../widgets/location_company_terms_step.dart';

/// EnhancedRegistrationPage - Wizard de registro mejorado UI PRO 2025
///
/// Muestra un stepper de 4 pasos con diseño minimalista:
/// 1. Método de autenticación (email/password, Google, Apple, Facebook)
/// 2. MFA obligatorio con teléfono + OTP
/// 3. Escaneo de documento de identidad
/// 4. Ubicación + nombre empresa + términos
///
/// Características UI PRO 2025:
/// - Material 3 design
/// - Stepper minimalista con indicadores visuales
/// - Animaciones fluidas entre pasos
/// - Botones con bordes suaves
/// - Feedback visual claro
class EnhancedRegistrationPage extends StatelessWidget {
  const EnhancedRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Registro'),
        centerTitle: true,
        leading: Obx(() {
          // Solo mostrar botón atrás si no estamos en el primer paso
          return controller.currentStep.value > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: controller.previousStep,
                )
              : const SizedBox.shrink();
        }),
      ),
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              // Contenido principal
              Column(
                children: [
                  // Indicador de progreso (stepper minimalista)
                  _buildProgressIndicator(context, controller),

                  const SizedBox(height: 24),

                  // Contenido del paso actual
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildStepContent(context, controller),
                    ),
                  ),

                  // Mensaje de error
                  if (controller.errorMessage.value.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Botones de navegación
                  _buildNavigationButtons(context, controller),

                  const SizedBox(height: 20),
                ],
              ),

              // Overlay de carga
              if (controller.isLoading.value)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  /// Indicador de progreso minimalista (4 círculos)
  Widget _buildProgressIndicator(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          final isActive = index == controller.currentStep.value;
          final isCompleted = index < controller.currentStep.value;

          return Row(
            children: [
              // Círculo indicador
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isActive ? 40 : 32,
                height: isActive ? 40 : 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isActive
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 18,
                          color: colorScheme.onPrimary,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive || isCompleted
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: isActive ? 16 : 14,
                          ),
                        ),
                ),
              ),

              // Línea conectora (solo si no es el último paso)
              if (index < 3)
                Container(
                  width: 40,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  /// Contenido del paso actual
  Widget _buildStepContent(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    switch (controller.currentStep.value) {
      case 0:
        return _buildAuthMethodStep(context, controller);
      case 1:
        return _buildMfaStep(context, controller);
      case 2:
        return _buildDocumentScanStep(context, controller);
      case 3:
        return _buildLocationCompanyTermsStep(context, controller);
      default:
        return const SizedBox.shrink();
    }
  }

  /// STEP 0: Selección de método de autenticación
  Widget _buildAuthMethodStep(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    return const AuthMethodSelectionStep();
  }

  /// STEP 1: MFA con teléfono (obligatorio)
  Widget _buildMfaStep(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    return const PhoneMfaStep();
  }

  /// STEP 2: Escaneo de documento
  Widget _buildDocumentScanStep(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    return const IdScanStep();
  }

  /// STEP 3: Ubicación + empresa + términos
  Widget _buildLocationCompanyTermsStep(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    return const LocationCompanyTermsStep();
  }

  /// Botones de navegación (Anterior / Siguiente)
  Widget _buildNavigationButtons(
    BuildContext context,
    EnhancedRegistrationController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLastStep = controller.currentStep.value == 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Botón Anterior (solo visible si no estamos en el primer paso)
          if (controller.currentStep.value > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Anterior'),
              ),
            ),

          if (controller.currentStep.value > 0) const SizedBox(width: 12),

          // Botón Siguiente / Completar
          Expanded(
            flex: controller.currentStep.value == 0 ? 1 : 1,
            child: FilledButton(
              onPressed: controller.nextStep,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isLastStep ? 'Completar registro' : 'Siguiente',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

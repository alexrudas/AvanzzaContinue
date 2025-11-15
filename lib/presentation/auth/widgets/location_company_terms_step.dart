import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/auth/modern_text_field.dart';
import '../controllers/enhanced_registration_controller.dart';
import '../controllers/registration_controller.dart';

/// LocationCompanyTermsStep - Paso 3: Ubicación + empresa + términos
///
/// Flujo:
/// 1. Ubicación prellenada desde registrationController.progress (editable)
/// 2. Nombre de empresa (solo si titularType == 'empresa')
/// 3. Aceptación de términos y condiciones (obligatorio)
///
/// UI PRO 2025:
/// - Dropdowns para país/región/ciudad
/// - Input de empresa condicional
/// - Checkbox de términos con link
/// - Validación visual
class LocationCompanyTermsStep extends StatefulWidget {
  const LocationCompanyTermsStep({super.key});

  @override
  State<LocationCompanyTermsStep> createState() =>
      _LocationCompanyTermsStepState();
}

class _LocationCompanyTermsStepState extends State<LocationCompanyTermsStep> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<EnhancedRegistrationController>();
    _companyNameController.text = controller.companyName.value;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
    final registrationController = Get.find<RegistrationController>();
    final theme = Theme.of(context);

    return Obx(() {
      final progress = registrationController.progress.value;
      final isEmpresa = progress?.titularType == 'empresa';

      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título y descripción
              Text(
                '¡Últimos detalles!',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Confirma tu ubicación y acepta los términos',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Sección: Ubicación
              _buildSectionHeader('Ubicación', Icons.location_on, theme),
              const SizedBox(height: 16),

              // País (prellenado, editable)
              _buildCountryDropdown(controller, theme),
              const SizedBox(height: 16),

              // Región (prellenada, editable)
              _buildRegionField(controller, theme),
              const SizedBox(height: 16),

              // Ciudad (prellenada, editable)
              _buildCityField(controller, theme),

              const SizedBox(height: 32),

              // Sección: Empresa (solo si es empresa)
              if (isEmpresa) ...[
                _buildSectionHeader(
                  'Información de empresa',
                  Icons.business,
                  theme,
                ),
                const SizedBox(height: 16),

                ModernTextField(
                  controller: _companyNameController,
                  label: 'Nombre de la empresa *',
                  hint: 'Ej: Avanzza SAS',
                  prefixIcon: const Icon(Icons.business),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre de la empresa es obligatorio';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.companyName.value = value;
                  },
                ),

                const SizedBox(height: 32),
              ],

              // Sección: Términos y condiciones
              _buildSectionHeader(
                'Términos y condiciones',
                Icons.description,
                theme,
              ),
              const SizedBox(height: 16),

              _buildTermsCheckbox(controller, theme),

              const SizedBox(height: 32),

              // Info final
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '¡Todo listo! Presiona "Completar registro" para empezar',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Header de sección
  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// Dropdown de país (prellenado con CO por defecto)
  Widget _buildCountryDropdown(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: controller.countryId.value.isEmpty
            ? 'CO'
            : controller.countryId.value,
        decoration: InputDecoration(
          labelText: 'País *',
          prefixIcon: const Icon(Icons.public),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'CO', child: Text('Colombia')),
          DropdownMenuItem(value: 'MX', child: Text('México')),
          DropdownMenuItem(value: 'US', child: Text('Estados Unidos')),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.updateLocation(country: value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Selecciona un país';
          }
          return null;
        },
      );
    });
  }

  /// Campo de región (prellenado, editable)
  Widget _buildRegionField(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Obx(() {
      return ModernTextField(
        label: 'Región / Departamento',
        hint: 'Ej: Cundinamarca',
        initialValue: controller.regionId.value,
        prefixIcon: const Icon(Icons.map),
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          controller.updateLocation(region: value);
        },
      );
    });
  }

  /// Campo de ciudad (prellenado, editable)
  Widget _buildCityField(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Obx(() {
      return ModernTextField(
        label: 'Ciudad *',
        hint: 'Ej: Bogotá',
        initialValue: controller.cityId.value,
        prefixIcon: const Icon(Icons.location_city),
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'La ciudad es obligatoria';
          }
          return null;
        },
        onChanged: (value) {
          controller.updateLocation(city: value);
        },
      );
    });
  }

  /// Checkbox de términos y condiciones
  Widget _buildTermsCheckbox(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.termsAccepted.value
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: controller.termsAccepted.value ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: controller.termsAccepted.value,
              onChanged: (value) {
                controller.termsAccepted.value = value ?? false;
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.termsAccepted.value =
                      !controller.termsAccepted.value;
                },
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      const TextSpan(text: 'Acepto los '),
                      TextSpan(
                        text: 'términos y condiciones',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' y la '),
                      TextSpan(
                        text: 'política de privacidad',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' de Avanzza'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

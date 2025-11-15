import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/auth/modern_text_field.dart';
import '../controllers/enhanced_registration_controller.dart';
import '../scanners/escanner_document_model.dart';

/// IdScanStep - Paso 2: Escaneo de documento de identidad
///
/// Flujo:
/// 1. Usuario presiona botón para escanear documento
/// 2. Se abre scanner (cámara o galería)
/// 3. Se decodifica PDF417 barcode (cédula colombiana)
/// 4. Se muestra preview de datos escaneados
/// 5. Usuario puede editar datos antes de confirmar
///
/// UI PRO 2025:
/// - Botón grande para escanear
/// - Preview de datos con posibilidad de edición
/// - Opción de omitir (skip) para pruebas
class IdScanStep extends StatefulWidget {
  const IdScanStep({super.key});

  @override
  State<IdScanStep> createState() => _IdScanStepState();
}

class _IdScanStepState extends State<IdScanStep> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _docNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _docNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EnhancedRegistrationController>();
    final theme = Theme.of(context);

    return Obx(() {
      final scannedDoc = controller.scannedDocument.value;
      final hasScanned = scannedDoc != null;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título y descripción
            Text(
              hasScanned ? 'Confirma tus datos' : 'Escanea tu documento',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              hasScanned
                  ? 'Verifica que los datos sean correctos'
                  : 'Usaremos tu cédula para verificar tu identidad',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Si NO ha escaneado: mostrar botón de escaneo
            if (!hasScanned) _buildScanButton(controller, theme),

            // Si YA escaneó: mostrar preview de datos
            if (hasScanned) _buildScannedDataPreview(controller, scannedDoc, theme),
          ],
        ),
      );
    });
  }

  /// Botón para escanear documento
  Widget _buildScanButton(
    EnhancedRegistrationController controller,
    ThemeData theme,
  ) {
    return Column(
      children: [
        // Icono grande de documento
        Icon(
          Icons.credit_card,
          size: 120,
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),

        const SizedBox(height: 32),

        // Botón de escaneo
        FilledButton.icon(
          onPressed: () => controller.scanDocument(context),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Escanear documento'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Botón de skip (solo para desarrollo/pruebas)
        TextButton(
          onPressed: controller.skipDocumentScan,
          child: Text(
            'Omitir por ahora (datos de prueba)',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Instrucciones
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Instrucciones',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInstruction(
                '1. Coloca tu cédula sobre una superficie plana',
                theme,
              ),
              _buildInstruction(
                '2. Asegúrate de tener buena iluminación',
                theme,
              ),
              _buildInstruction(
                '3. Enfoca el código de barras PDF417',
                theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstruction(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Preview de datos escaneados (con posibilidad de editar)
  Widget _buildScannedDataPreview(
    EnhancedRegistrationController controller,
    ScannerDocumentModel scannedDoc,
    ThemeData theme,
  ) {
    // Pre-llenar controllers con datos escaneados
    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = scannedDoc.nombres.trim();
    }
    if (_lastNameController.text.isEmpty) {
      _lastNameController.text = scannedDoc.apellidos.trim();
    }
    if (_docNumberController.text.isEmpty) {
      _docNumberController.text = scannedDoc.numeroDocumento ?? '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icono de éxito
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 60,
            color: theme.colorScheme.primary,
          ),
        ),

        const SizedBox(height: 24),

        // Campos editables
        ModernTextField(
          controller: _firstNameController,
          label: 'Nombres',
          prefixIcon: const Icon(Icons.person_outline),
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 16),

        ModernTextField(
          controller: _lastNameController,
          label: 'Apellidos',
          prefixIcon: const Icon(Icons.person_outline),
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 16),

        ModernTextField(
          controller: _docNumberController,
          label: 'Número de documento',
          prefixIcon: const Icon(Icons.credit_card),
          keyboardType: TextInputType.number,
          enabled: false, // No editable
        ),

        const SizedBox(height: 24),

        // Botón para volver a escanear
        OutlinedButton.icon(
          onPressed: () {
            controller.scannedDocument.value = null;
            controller.documentScanCompleted.value = false;
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Escanear de nuevo'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

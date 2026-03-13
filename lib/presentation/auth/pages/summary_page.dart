// ============================================================================
// lib/presentation/auth/pages/summary_page.dart
//
// QUÉ HACE:
// Resumen de registro editable por bloques antes de finalizar el onboarding.
//
// ARQUITECTURA:
// - Lee ÚNICAMENTE de RegistrationController.progress (fuente de verdad).
// - Usa Obx para reconstruir automáticamente cuando el usuario vuelve de
//   editar ubicación o perfil.
// - Toda la transformación de datos vive en RegistrationSummaryMapper.
// - La navegación de edición usa Get.toNamed con arguments para que las
//   páginas intermedias sepan retornar aquí al presionar "Continuar".
//
// BLOQUES:
//   CONTACTO   → read-only (OTP = identidad primaria, no editable)
//   UBICACIÓN  → editable → Routes.countryCity
//   PERFIL     → editable → Routes.profile
//
// QUÉ NO HACE:
// - No almacena estado propio de los datos del usuario.
// - No replica lógica de transformación de datos (todo en el mapper).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/registration_controller.dart';
import '../mappers/registration_summary_mapper.dart';
import '../widgets/summary_section_card.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _loading = false;

  Future<void> _finalize(RegistrationController reg) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await reg.finalizeRegistration();
      if (mounted) Get.offAllNamed(Routes.home);
    } catch (e) {
      if (mounted) {
        final cs = Theme.of(context).colorScheme;
        Get.snackbar(
          'Error al finalizar',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: cs.errorContainer,
          colorText: cs.onErrorContainer,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Navega a edición de ubicación.
  /// Pasa {'returnTo': Routes.registerSummary} para que SelectCountryCityPage
  /// retorne aquí en lugar de avanzar al paso profile.
  void _editLocation() {
    Get.toNamed(
      Routes.countryCity,
      arguments: <String, String>{'returnTo': Routes.registerSummary},
    );
  }

  /// Navega a edición de perfil.
  /// SelectProfilePage ya interpreta Get.arguments como String para nextRoute:
  ///   passedNext = Get.arguments is String ? Get.arguments as String : null
  /// Al pasar Routes.registerSummary, usará esa ruta como destino tras continuar.
  void _editProfile() {
    Get.toNamed(Routes.profile, arguments: Routes.registerSummary);
  }

  @override
  Widget build(BuildContext context) {
    final reg = Get.find<RegistrationController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen de registro')),
      body: Obx(() {
        // Obx reacciona si progress.value cambia mientras la página está activa
        // (por ejemplo si el usuario navega hacia atrás en lugar de offAllNamed).
        final p = reg.progress.value;
        final data = p != null
            ? RegistrationSummaryMapper.buildGrouped(p)
            : const RegistrationSummaryData(
                contactItems: [],
                locationItems: [],
                profileItems: [],
              );

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // ── Encabezado ───────────────────────────────────────────────
            Text(
              '¿Todo correcto?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Puedes editar cualquier sección antes de finalizar.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // ── Bloque CONTACTO (read-only — OTP es identidad primaria) ──
            // El teléfono verificado por OTP es la credencial de autenticación.
            // Cambiarlo requeriría reiniciar el flujo OTP completo.
            if (data.hasContact) ...[
              SummarySectionCard(
                title: 'Contacto',
                items: data.contactItems,
                nonEditableHint: 'Verificado',
              ),
              const SizedBox(height: 12),
            ],

            // ── Bloque UBICACIÓN ──────────────────────────────────────────
            if (data.hasLocation) ...[
              SummarySectionCard(
                title: 'Ubicación',
                items: data.locationItems,
                onEdit: _editLocation,
              ),
              const SizedBox(height: 12),
            ],

            // ── Bloque PERFIL INICIAL ─────────────────────────────────────
            if (data.hasProfile) ...[
              SummarySectionCard(
                title: 'Perfil inicial',
                items: data.profileItems,
                onEdit: _editProfile,
              ),
              const SizedBox(height: 12),
            ],

            // Protección defensiva: progreso vacío
            if (!data.hasContact && !data.hasLocation && !data.hasProfile)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No hay datos de registro disponibles.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ── Botón Finalizar ───────────────────────────────────────────
            FilledButton(
              onPressed: _loading ? null : () => _finalize(reg),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: cs.onPrimary,
                      ),
                    )
                  : const Text(
                      'Finalizar y entrar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

// ============================================================================
// lib/presentation/pages/provider/bootstrap/provider_bootstrap_page.dart
// PROVIDER BOOTSTRAP PAGE — wizard de auto-onboarding (MF1).
//
// QUÉ HACE:
//   - Wizard 3 steps usando IndexedStack para preservar estado entre
//     transiciones sin reconstruir cada step.
//   - Step 0: TextField name + phone.
//   - Step 1: Multi-select de WorkspaceAssetType (lista activa).
//   - Step 2: Botón "Elegir especialidades" → navega a SelectSpecialtiesPage
//     (existente) anclado al primer assetType seleccionado.
//   - Footer fijo con botones [Atrás] [Siguiente / Crear].
//
// QUÉ NO HACE:
//   - NO duplica la pantalla SelectSpecialtiesPage.
//   - NO escribe al backend hasta el último step.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../domain/services/catalog/specialty_grouping.dart';
import '../../../../routes/app_routes.dart';
import '../../../controllers/provider/bootstrap/provider_bootstrap_controller.dart';
import '../../../controllers/provider/specialties/specialties_selection_result.dart';

class ProviderBootstrapPage extends GetView<ProviderBootstrapController> {
  const ProviderBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configura tu proveedor'),
      ),
      body: Obx(() {
        // Gate idempotente: mientras el controller verifica si el user ya
        // es proveedor (me()), mostramos un loader. Si ya lo es, el
        // controller ya disparó la navegación a /provider/me — nunca se
        // ve el wizard. Si no, sigue al flujo del wizard.
        if (controller.initializing.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            const _StepIndicator(),
            Expanded(
              child: Obx(() {
                switch (controller.step.value) {
                  case ProviderBootstrapStep.identity:
                    return _IdentityStep(controller: controller);
                  case ProviderBootstrapStep.assetTypes:
                    return _AssetTypesStep(controller: controller);
                  case ProviderBootstrapStep.specialties:
                    return _SpecialtiesStep(controller: controller);
                }
              }),
            ),
            _ErrorFooter(controller: controller),
            _NavFooter(controller: controller),
          ],
        );
      }),
    );
  }
}

// ─── Step indicator (1/3 · 2/3 · 3/3) ─────────────────────────────────

class _StepIndicator extends GetView<ProviderBootstrapController> {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Obx(() {
        final current = controller.step.value.index;
        return Row(
          children: List.generate(3, (i) {
            final active = i <= current;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ─── Step 0 — Identidad ──────────────────────────────────────────────

class _IdentityStep extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _IdentityStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos del proveedor',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ingresa el nombre comercial y un teléfono de contacto.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: controller.nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre comercial *',
              hintText: 'p. ej. AutoMotor SAS',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              // Refresh canSubmit/canAdvance — el getter es síncrono pero
              // los widgets que dependen de él deben rebuildear.
              controller.update();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller.phoneCtrl,
            decoration: const InputDecoration(
              labelText: 'Teléfono (opcional)',
              hintText: '+57 300 000 0000',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}

// ─── Step 1 — AssetTypes ─────────────────────────────────────────────

class _AssetTypesStep extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _AssetTypesStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Catálogo global cliente — siempre devuelve los 5 ids canónicos
      // (`vehicle`, `real_estate`, `machinery`, `equipment`, `other`).
      // No hay estado vacío ni dependencia del workspace.
      if (controller.loadingAssetTypes.value &&
          controller.availableAssetTypes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Selecciona los tipos de activos que atiende tu negocio',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Elige al menos uno. Define qué solicitudes de cotización podrán '
            'llegarte.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final at in controller.availableAssetTypes)
            Obx(() {
              final selected = controller.assetTypeIds.contains(at.id);
              return CheckboxListTile(
                value: selected,
                onChanged: (_) => controller.toggleAssetType(at.id),
                title: Text(at.name),
                subtitle: Text(
                  at.id,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
        ],
      );
    });
  }
}

// ─── Step 2 — Tipo de oferta + Especialidades ───────────────────────────
//
// Diseño (decisión de producto):
//   1. Card "Tipo de oferta" — botón que abre BottomSheet con
//      Producto / Servicio / Productos y servicios. Una vez elegido,
//      la card muestra el valor.
//   2. Card "¿Qué especialidades cubres?" — botón "Elegir especialidades"
//      deshabilitado mientras no haya tipo de oferta. Al tocarlo abre el
//      selector existente (`Routes.selectSpecialties`) ya cargado con el
//      pre-filtro `initialKind` derivado del tipo de oferta.

class _SpecialtiesStep extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _SpecialtiesStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card 1: Tipo de oferta ──────────────────────────────────
          _OfferTypeCard(controller: controller),
          const SizedBox(height: AppSpacing.md),
          // ── Card 2: Especialidades ──────────────────────────────────
          _SpecialtiesCard(controller: controller),
        ],
      ),
    );
  }
}

class _OfferTypeCard extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _OfferTypeCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de oferta',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Define qué solicitudes podrán llegarte.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Obx(() {
              final label = controller.offerTypeLabel;
              final hasValue = label.isNotEmpty;
              return SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: Icon(
                    hasValue ? Icons.check_circle_outline : Icons.tune,
                  ),
                  label: Text(
                    hasValue ? label : 'Seleccionar tipo de oferta',
                  ),
                  onPressed: () => _showOfferTypeSheet(context),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _showOfferTypeSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<SpecialtyOfferType>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => _OfferTypeSheet(current: controller.offerType.value),
    );
    if (selected != null) {
      controller.setOfferType(selected);
    }
  }
}

class _OfferTypeSheet extends StatelessWidget {
  final SpecialtyOfferType? current;
  const _OfferTypeSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(
              'Tipo de oferta',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          _OfferTypeOption(
            value: SpecialtyOfferType.product,
            current: current,
            label: 'Producto',
            subtitle: 'Solo productos',
            icon: Icons.inventory_2_outlined,
          ),
          _OfferTypeOption(
            value: SpecialtyOfferType.service,
            current: current,
            label: 'Servicio',
            subtitle: 'Solo servicios',
            icon: Icons.handyman_outlined,
          ),
          _OfferTypeOption(
            value: SpecialtyOfferType.both,
            current: current,
            label: 'Productos y servicios',
            subtitle: 'Ambas opciones',
            icon: Icons.compare_arrows_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _OfferTypeOption extends StatelessWidget {
  final SpecialtyOfferType value;
  final SpecialtyOfferType? current;
  final String label;
  final String subtitle;
  final IconData icon;

  const _OfferTypeOption({
    required this.value,
    required this.current,
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current == value;
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? theme.colorScheme.primary : theme.hintColor,
      ),
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: selected
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : null,
      onTap: () => Get.back<SpecialtyOfferType>(result: value),
    );
  }
}

class _SpecialtiesCard extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _SpecialtiesCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final hasAt = controller.specialtyPickerAssetType != null;
      final hasOffer = controller.canOpenSpecialtyPicker;
      final canOpen = hasAt && hasOffer;
      final selectedCount = controller.specialtyIds.length;

      // Hint priorizado: 1) sin tipo de oferta → forzar selección previa;
      // 2) sin assetType → mensaje del paso anterior.
      final String? hint;
      if (!hasOffer) {
        hint = 'Selecciona primero el tipo de oferta';
      } else if (!hasAt) {
        hint = 'Vuelve al paso anterior y elige al menos un tipo de activo.';
      } else {
        hint = null;
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué especialidades cubres?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Determinan qué solicitudes recibe tu equipo.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.checklist),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      selectedCount == 0
                          ? 'Sin especialidades elegidas'
                          : '$selectedCount '
                              'especialidad${selectedCount == 1 ? '' : 'es'} '
                              'seleccionada${selectedCount == 1 ? '' : 's'}',
                    ),
                  ),
                ],
              ),
              if (selectedCount > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final d in controller.specialtyDetails.take(8))
                      Chip(
                        label: Text(d.name),
                        visualDensity: VisualDensity.compact,
                      ),
                    if (controller.specialtyDetails.length > 8)
                      Chip(
                        label: Text(
                          '+${controller.specialtyDetails.length - 8} más',
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.edit),
                  label: Text(
                    selectedCount == 0
                        ? 'Elegir especialidades'
                        : 'Modificar selección',
                  ),
                  onPressed: canOpen ? () => _openSelector(context) : null,
                ),
              ),
              if (hint != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    hint,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _openSelector(BuildContext context) async {
    final at = controller.specialtyPickerAssetType;
    if (at == null) return;
    final raw = await Get.toNamed(
      Routes.selectSpecialties,
      arguments: <String, dynamic>{
        'assetType': at,
        'initialSelection': controller.specialtyIds.toSet(),
        'providerName': controller.nameCtrl.text.trim(),
        // Pre-filtro single-source-of-truth: el wizard decide el kind en
        // la card "Tipo de oferta". El selector aplica el filtro al
        // primer fetch sin mostrar toggle propio. `null` (caso "Ambos")
        // → selector hace fetch sin filter y agrupa en 2 secciones.
        'initialKind': controller.specialtyPickerInitialKindWire,
      },
    );
    if (raw is SpecialtiesSelectionResult) {
      controller.applySpecialtiesResult(raw);
    }
  }
}

// ─── Footer: error inline + nav ─────────────────────────────────────

class _ErrorFooter extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _ErrorFooter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final err = controller.error.value;
      if (err.isEmpty) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: Theme.of(context).colorScheme.errorContainer,
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                err,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _NavFooter extends StatelessWidget {
  final ProviderBootstrapController controller;
  const _NavFooter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Obx(() {
        final step = controller.step.value;
        final isLast = step == ProviderBootstrapStep.specialties;
        final submitting = controller.submitting.value;
        return Row(
          children: [
            if (step != ProviderBootstrapStep.identity)
              Expanded(
                child: OutlinedButton(
                  onPressed: submitting ? null : controller.back,
                  child: const Text('Atrás'),
                ),
              ),
            if (step != ProviderBootstrapStep.identity)
              const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton(
                onPressed: submitting
                    ? null
                    : (isLast
                        ? (controller.canSubmit ? controller.submit : null)
                        : controller.next),
                child: submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isLast ? 'Crear proveedor' : 'Siguiente'),
              ),
            ),
          ],
        );
      }),
    );
  }
}

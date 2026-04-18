// ============================================================================
// lib/presentation/pages/purchase_request_page.dart
// PURCHASE REQUEST PAGE — Formulario de creación (F5 Hito 18)
// ============================================================================
// QUÉ HACE:
// - Formulario con tres secciones explícitas: (1) datos, (2) destinatarios,
//   (3) enviar.
// - Destinatarios obligatorios: el botón Enviar permanece deshabilitado
//   hasta que haya al menos un target seleccionado. El error NO lo descubre
//   el backend.
// - Selector multiselect vía VendorTargetPickerSheet.
//
// QUÉ NO HACE:
// - No lista solicitudes existentes.
// - No selecciona assets.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/purchase_request_controller.dart';
import '../widgets/purchase/vendor_target_picker_sheet.dart';

class PurchaseRequestPage extends StatefulWidget {
  const PurchaseRequestPage({super.key});

  @override
  State<PurchaseRequestPage> createState() => _PurchaseRequestPageState();
}

class _PurchaseRequestPageState extends State<PurchaseRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _tipoRepuestoCtrl = TextEditingController();
  final _cantidadCtrl = TextEditingController(text: '1');
  final _ciudadCtrl = TextEditingController();
  final _specsCtrl = TextEditingController();

  late final PurchaseRequestController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PurchaseRequestController>();
    // Reflejamos los cambios de los TextFields al estado reactivo del
    // controller para que canSubmit derive en tiempo real.
    controller.tipoRepuesto.value = _tipoRepuestoCtrl.text;
    controller.cantidadText.value = _cantidadCtrl.text;
    controller.ciudadEntrega.value = _ciudadCtrl.text;
    _tipoRepuestoCtrl.addListener(
        () => controller.tipoRepuesto.value = _tipoRepuestoCtrl.text);
    _cantidadCtrl.addListener(
        () => controller.cantidadText.value = _cantidadCtrl.text);
    _ciudadCtrl.addListener(
        () => controller.ciudadEntrega.value = _ciudadCtrl.text);
  }

  @override
  void dispose() {
    _tipoRepuestoCtrl.dispose();
    _cantidadCtrl.dispose();
    _ciudadCtrl.dispose();
    _specsCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final error = controller.validate(
      tipoRepuesto: _tipoRepuestoCtrl.text,
      cantidad: _cantidadCtrl.text,
      ciudadEntrega: _ciudadCtrl.text,
    );
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    final success = await controller.submitRequest(
      tipoRepuesto: _tipoRepuestoCtrl.text,
      cantidad: int.parse(_cantidadCtrl.text.trim()),
      ciudadEntrega: _ciudadCtrl.text,
      specs: _specsCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud creada exitosamente')),
      );
      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear la solicitud. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud de compra')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _tipoRepuestoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de repuesto *',
                          hintText: 'Ej: Pastillas de freno, Filtro de aceite',
                          prefixIcon: Icon(Icons.build_outlined),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cantidadCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad *',
                          prefixIcon: Icon(Icons.numbers_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Campo obligatorio';
                          }
                          final n = int.tryParse(v.trim());
                          if (n == null || n < 1) return 'Debe ser mayor a 0';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ciudadCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Ciudad de entrega *',
                          hintText: 'Ej: Barranquilla',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _specsCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones',
                          hintText: 'Especificaciones adicionales (opcional)',
                          prefixIcon: Icon(Icons.notes_outlined),
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      _TargetsSection(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() {
                // Leer señales que componen canSubmit para que Obx rebuildee.
                final submitting = controller.isSubmitting.value;
                controller.selectedVendorIds.length;
                controller.tipoRepuesto.value;
                controller.cantidadText.value;
                controller.ciudadEntrega.value;
                final enabled = !submitting && controller.canSubmit;

                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    key: const Key('purchase_request_page.submit_button'),
                    onPressed: enabled ? _onSubmit : null,
                    icon: submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_outlined),
                    label: Text(submitting
                        ? 'Creando solicitud...'
                        : 'Crear solicitud'),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetsSection extends StatelessWidget {
  final PurchaseRequestController controller;
  const _TargetsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.group_outlined,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Destinatarios *',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona al menos un contacto del workspace para enviar la solicitud.',
            style:
                theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 10),
          Obx(() {
            final ids = controller.selectedVendorIds;
            final contactsById = {
              for (final c in controller.availableContacts) c.id: c,
            };
            if (ids.isEmpty) {
              return Text(
                'Sin destinatarios seleccionados',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              );
            }
            return Wrap(
              spacing: 6,
              runSpacing: 4,
              children: ids.map((id) {
                final c = contactsById[id];
                final label = c?.displayName ?? id;
                return InputChip(
                  key: Key('purchase_request_page.target_chip.$id'),
                  label: Text(label),
                  onDeleted: () => controller.toggleVendor(id),
                  deleteIconColor: theme.colorScheme.error,
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              key: const Key('purchase_request_page.pick_targets_button'),
              onPressed: () => VendorTargetPickerSheet.show(context),
              icon: const Icon(Icons.person_add_alt_outlined, size: 18),
              label: const Text('Seleccionar destinatarios'),
            ),
          ),
        ],
      ),
    );
  }
}

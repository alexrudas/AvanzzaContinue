// ============================================================================
// lib/presentation/widgets/purchase/vendor_target_picker_sheet.dart
// VENDOR TARGET PICKER — Selector multiselect de destinatarios (F5 Hito 18)
// ============================================================================
// QUÉ HACE:
//   - Bottom sheet modal que lista los contactos del workspace activo
//     (fuente: LocalContactRepository + Isar) y permite seleccionar 1..N.
//   - Estado de selección vive en PurchaseRequestController.selectedVendorIds
//     (reactivo). El sheet solo lee/modifica ese estado.
//   - Empty state explícito cuando no hay contactos elegibles, con mensaje
//     claro y CTA neutra (cerrar). El usuario entiende por qué no puede
//     enviar antes de llegar al backend.
//
// QUÉ NO HACE:
//   - No construye sus propios datos. Consume el RxList del controller.
//   - No persiste nada: la persistencia la hace el controller al submit.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../controllers/purchase_request_controller.dart';

class VendorTargetPickerSheet extends StatelessWidget {
  const VendorTargetPickerSheet({super.key});

  /// Abre el sheet. Devuelve al cerrar; la selección queda persistida en el
  /// controller.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const VendorTargetPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<PurchaseRequestController>();

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Seleccionar destinatarios',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                'Elige a qué contactos del workspace enviar esta solicitud. '
                'Debe haber al menos uno.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  final contacts = controller.availableContacts;
                  if (contacts.isEmpty) {
                    return _EmptyState();
                  }
                  return ListView.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 56),
                    itemBuilder: (_, i) => _ContactTile(
                      contact: contacts[i],
                      controller: controller,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final n = controller.selectedVendorIds.length;
                      return Text(
                        n == 0
                            ? 'Sin destinatarios seleccionados'
                            : '$n ${n == 1 ? "destinatario" : "destinatarios"} seleccionado${n == 1 ? "" : "s"}',
                        style: theme.textTheme.bodyMedium,
                      );
                    }),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Listo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final LocalContactEntity contact;
  final PurchaseRequestController controller;

  const _ContactTile({required this.contact, required this.controller});

  String? get _subtitle {
    final parts = <String>[];
    if (contact.primaryPhoneE164?.isNotEmpty == true) {
      parts.add(contact.primaryPhoneE164!);
    }
    if (contact.primaryEmail?.isNotEmpty == true) {
      parts.add(contact.primaryEmail!);
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.isSelected(contact.id);
      return CheckboxListTile(
        key: Key('vendor_picker.tile.${contact.id}'),
        value: selected,
        onChanged: (_) => controller.toggleVendor(contact.id),
        title: Text(contact.displayName),
        subtitle: _subtitle != null ? Text(_subtitle!) : null,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_add_outlined,
                size: 48, color: theme.hintColor),
            const SizedBox(height: 12),
            Text(
              'No tienes contactos en este workspace',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Primero debes vincular o crear contactos para poder enviarles '
              'solicitudes de compra. Vuelve cuando tengas al menos uno.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        ),
      ),
    );
  }
}

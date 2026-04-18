// ============================================================================
// lib/presentation/pages/purchase_request_page.dart
// PURCHASE REQUEST PAGE — Formulario canónico
// ============================================================================
// QUÉ HACE:
//   - Formulario en 5 secciones alineado al contrato backend canónico.
//   - Sección "Contexto" incluye picker real de activos (AssetPickerSheet)
//     cuando originType=ASSET. Prohibido escribir IDs técnicos a mano.
//   - Sección "Entrega" es un bloque activable con SwitchListTile: cuando
//     está apagado, delivery NO se envía; cuando está encendido, city y
//     address son obligatorios.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../domain/entities/purchase/create_purchase_request_input.dart';
import '../controllers/purchase_request_controller.dart';
import '../widgets/purchase/asset_picker_sheet.dart';
import '../widgets/purchase/vendor_target_picker_sheet.dart';

class PurchaseRequestPage extends StatefulWidget {
  const PurchaseRequestPage({super.key});

  @override
  State<PurchaseRequestPage> createState() => _PurchaseRequestPageState();
}

class _PurchaseRequestPageState extends State<PurchaseRequestPage> {
  late final PurchaseRequestController controller;

  // Encabezado
  final _titleCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();

  // Contexto (assetId gestionado por AssetPickerSheet)
  final _notesCtrl = TextEditingController();

  // Delivery
  final _deliveryDeptCtrl = TextEditingController();
  final _deliveryCityCtrl = TextEditingController();
  final _deliveryAddressCtrl = TextEditingController();
  final _deliveryInfoCtrl = TextEditingController();

  final Map<PurchaseRequestItemDraft, _ItemControllers> _itemCtrls = {};

  @override
  void initState() {
    super.initState();
    controller = Get.find<PurchaseRequestController>();
    _wireHeader();
    _wireContext();
    _wireDelivery();
  }

  void _wireHeader() {
    _titleCtrl.text = controller.title.value;
    _categoryCtrl.text = controller.category.value;
    _titleCtrl.addListener(() => controller.title.value = _titleCtrl.text);
    _categoryCtrl
        .addListener(() => controller.category.value = _categoryCtrl.text);
  }

  void _wireContext() {
    _notesCtrl.text = controller.notes.value;
    _notesCtrl.addListener(() => controller.notes.value = _notesCtrl.text);
  }

  void _wireDelivery() {
    _deliveryDeptCtrl.text = controller.deliveryDepartment.value;
    _deliveryCityCtrl.text = controller.deliveryCity.value;
    _deliveryAddressCtrl.text = controller.deliveryAddress.value;
    _deliveryInfoCtrl.text = controller.deliveryInfo.value;
    _deliveryDeptCtrl.addListener(
        () => controller.deliveryDepartment.value = _deliveryDeptCtrl.text);
    _deliveryCityCtrl.addListener(
        () => controller.deliveryCity.value = _deliveryCityCtrl.text);
    _deliveryAddressCtrl.addListener(() =>
        controller.deliveryAddress.value = _deliveryAddressCtrl.text);
    _deliveryInfoCtrl.addListener(
        () => controller.deliveryInfo.value = _deliveryInfoCtrl.text);
  }

  _ItemControllers _ctrlsFor(PurchaseRequestItemDraft draft) {
    return _itemCtrls.putIfAbsent(draft, () {
      final c = _ItemControllers(
        description: TextEditingController(text: draft.description),
        quantity: TextEditingController(text: draft.quantityText),
        unit: TextEditingController(text: draft.unit),
        notes: TextEditingController(text: draft.notes ?? ''),
      );
      c.description.addListener(() => controller.updateItem(
            controller.items.indexOf(draft).clamp(0, controller.items.length - 1),
            description: c.description.text,
          ));
      c.quantity.addListener(() => controller.updateItem(
            controller.items.indexOf(draft).clamp(0, controller.items.length - 1),
            quantityText: c.quantity.text,
          ));
      c.unit.addListener(() => controller.updateItem(
            controller.items.indexOf(draft).clamp(0, controller.items.length - 1),
            unit: c.unit.text,
          ));
      c.notes.addListener(() => controller.updateItem(
            controller.items.indexOf(draft).clamp(0, controller.items.length - 1),
            notes: c.notes.text,
          ));
      return c;
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    _notesCtrl.dispose();
    _deliveryDeptCtrl.dispose();
    _deliveryCityCtrl.dispose();
    _deliveryAddressCtrl.dispose();
    _deliveryInfoCtrl.dispose();
    for (final c in _itemCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final error = controller.validate();
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    final success = await controller.submitRequest();
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud enviada correctamente')),
      );
      Get.back();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al enviar la solicitud. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderSection(
                      titleCtrl: _titleCtrl,
                      categoryCtrl: _categoryCtrl,
                      controller: controller,
                    ),
                    const SizedBox(height: 20),
                    _ContextSection(
                      notesCtrl: _notesCtrl,
                      controller: controller,
                    ),
                    const SizedBox(height: 20),
                    _ItemsSection(
                      controller: controller,
                      ctrlsFor: _ctrlsFor,
                    ),
                    const SizedBox(height: 20),
                    _TargetsSection(controller: controller),
                    const SizedBox(height: 20),
                    _DeliverySection(
                      controller: controller,
                      deptCtrl: _deliveryDeptCtrl,
                      cityCtrl: _deliveryCityCtrl,
                      addressCtrl: _deliveryAddressCtrl,
                      infoCtrl: _deliveryInfoCtrl,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() {
                // Señales que componen canSubmit para que Obx rebuildee.
                controller.isSubmitting.value;
                controller.title.value;
                controller.originType.value;
                controller.assetId.value;
                controller.selectedVendorIds.length;
                controller.items.length;
                controller.deliveryEnabled.value;
                controller.deliveryCity.value;
                controller.deliveryAddress.value;

                final submitting = controller.isSubmitting.value;
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
                    label: Text(
                        submitting ? 'Enviando...' : 'Enviar solicitud'),
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

class _ItemControllers {
  final TextEditingController description;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController notes;

  _ItemControllers({
    required this.description,
    required this.quantity,
    required this.unit,
    required this.notes,
  });

  void dispose() {
    description.dispose();
    quantity.dispose();
    unit.dispose();
    notes.dispose();
  }
}

// ───────────────────────────────────────────────────────────────────────────
// SECCIÓN: Encabezado
// ───────────────────────────────────────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController categoryCtrl;
  final PurchaseRequestController controller;

  const _HeaderSection({
    required this.titleCtrl,
    required this.categoryCtrl,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Encabezado',
      icon: Icons.article_outlined,
      children: [
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: 'Título de la solicitud *',
            hintText: 'Ej: Insumos mensuales farmacia central',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<PurchaseRequestTypeInput>(
              initialValue: controller.type.value,
              decoration: const InputDecoration(
                labelText: 'Tipo *',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: PurchaseRequestTypeInput.product,
                  child: Text('Producto'),
                ),
                DropdownMenuItem(
                  value: PurchaseRequestTypeInput.service,
                  child: Text('Servicio'),
                ),
              ],
              onChanged: (v) {
                if (v != null) controller.type.value = v;
              },
            )),
        const SizedBox(height: 12),
        TextField(
          controller: categoryCtrl,
          decoration: const InputDecoration(
            labelText: 'Categoría',
            hintText: 'Ej: limpieza, medicamentos, transporte',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// SECCIÓN: Contexto (con picker real de activos)
// ───────────────────────────────────────────────────────────────────────────
class _ContextSection extends StatelessWidget {
  final TextEditingController notesCtrl;
  final PurchaseRequestController controller;

  const _ContextSection({
    required this.notesCtrl,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: 'Contexto',
      icon: Icons.info_outline,
      children: [
        Obx(() => DropdownButtonFormField<PurchaseRequestOriginInput>(
              initialValue: controller.originType.value,
              decoration: const InputDecoration(
                labelText: 'Origen de la necesidad *',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: PurchaseRequestOriginInput.asset,
                  child: Text('Activo específico'),
                ),
                DropdownMenuItem(
                  value: PurchaseRequestOriginInput.inventory,
                  child: Text('Inventario / stock'),
                ),
                DropdownMenuItem(
                  value: PurchaseRequestOriginInput.general,
                  child: Text('Necesidad general'),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                controller.originType.value = v;
                if (v != PurchaseRequestOriginInput.asset) {
                  controller.clearAsset();
                }
              },
            )),
        const SizedBox(height: 12),
        Obx(() {
          final show = controller.originType.value ==
              PurchaseRequestOriginInput.asset;
          if (!show) return const SizedBox.shrink();
          final selectedId = controller.assetId.value;
          final label = controller.assetLabel.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Activo relacionado *',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                if (selectedId.isNotEmpty)
                  InputChip(
                    key: const Key(
                        'purchase_request_page.selected_asset_chip'),
                    avatar: const Icon(
                        Icons.precision_manufacturing_outlined,
                        size: 18),
                    label: Text(label.isNotEmpty ? label : selectedId),
                    onDeleted: controller.clearAsset,
                    deleteIconColor: theme.colorScheme.error,
                  )
                else
                  Text(
                    'Sin activo seleccionado',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    key: const Key(
                        'purchase_request_page.pick_asset_button'),
                    onPressed: () => AssetPickerSheet.show(context),
                    icon: const Icon(
                        Icons.precision_manufacturing_outlined,
                        size: 18),
                    label: Text(selectedId.isEmpty
                        ? 'Seleccionar activo'
                        : 'Cambiar activo'),
                  ),
                ),
              ],
            ),
          );
        }),
        TextField(
          controller: notesCtrl,
          decoration: const InputDecoration(
            labelText: 'Observaciones generales',
            hintText: 'Contexto adicional (opcional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// SECCIÓN: Ítems
// ───────────────────────────────────────────────────────────────────────────
class _ItemsSection extends StatelessWidget {
  final PurchaseRequestController controller;
  final _ItemControllers Function(PurchaseRequestItemDraft) ctrlsFor;

  const _ItemsSection({required this.controller, required this.ctrlsFor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: 'Ítems solicitados',
      icon: Icons.list_alt_outlined,
      trailing: OutlinedButton.icon(
        key: const Key('purchase_request_page.add_item_button'),
        onPressed: controller.addItem,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Agregar'),
      ),
      children: [
        Obx(() {
          final items = controller.items;
          return Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _ItemTile(
                  index: i,
                  draft: items[i],
                  ctrls: ctrlsFor(items[i]),
                  canRemove: items.length > 1,
                  onRemove: () => controller.removeItemAt(i),
                ),
                if (i < items.length - 1)
                  Divider(color: theme.dividerColor, height: 24),
              ],
            ],
          );
        }),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  final int index;
  final PurchaseRequestItemDraft draft;
  final _ItemControllers ctrls;
  final bool canRemove;
  final VoidCallback onRemove;

  const _ItemTile({
    required this.index,
    required this.draft,
    required this.ctrls,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ítem ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (canRemove)
              IconButton(
                key: Key('purchase_request_page.remove_item.$index'),
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Quitar ítem',
              ),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrls.description,
          decoration: const InputDecoration(
            labelText: 'Descripción *',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: ctrls.quantity,
                decoration: const InputDecoration(
                  labelText: 'Cantidad *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: TextField(
                controller: ctrls.unit,
                decoration: const InputDecoration(
                  labelText: 'Unidad *',
                  hintText: 'und, kg, caja, hora...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrls.notes,
          decoration: const InputDecoration(
            labelText: 'Notas del ítem',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// SECCIÓN: Destinatarios
// ───────────────────────────────────────────────────────────────────────────
class _TargetsSection extends StatelessWidget {
  final PurchaseRequestController controller;
  const _TargetsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: 'Destinatarios',
      icon: Icons.group_outlined,
      children: [
        Text(
          'Selecciona al menos un contacto del workspace para enviar la solicitud.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
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
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// SECCIÓN: Entrega / Ejecución (bloque activable)
// ───────────────────────────────────────────────────────────────────────────
class _DeliverySection extends StatelessWidget {
  final PurchaseRequestController controller;
  final TextEditingController deptCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController infoCtrl;

  const _DeliverySection({
    required this.controller,
    required this.deptCtrl,
    required this.cityCtrl,
    required this.addressCtrl,
    required this.infoCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Entrega / ejecución',
      icon: Icons.local_shipping_outlined,
      children: [
        Obx(() {
          final enabled = controller.deliveryEnabled.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile.adaptive(
                key: const Key('purchase_request_page.delivery_switch'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Incluir datos de entrega / ejecución'),
                subtitle: const Text(
                    'Activa cuando exista lugar físico donde se entregará o '
                    'ejecutará. Ciudad y dirección serán obligatorias.'),
                value: enabled,
                onChanged: (v) {
                  controller.setDeliveryEnabled(v);
                  if (!v) {
                    // sincroniza text fields con la limpieza del controller
                    deptCtrl.clear();
                    cityCtrl.clear();
                    addressCtrl.clear();
                    infoCtrl.clear();
                  }
                },
              ),
              if (enabled) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad *',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección *',
                    hintText: 'Calle, número, punto de referencia',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Departamento / estado (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: infoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Información adicional (opcional)',
                    hintText: 'Horario, piso, contacto en sitio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ],
          );
        }),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Card contenedor de sección
// ───────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: theme.textTheme.titleSmall),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

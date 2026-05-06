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

import '../../domain/entities/asset/asset_entity.dart';
import '../../domain/entities/purchase/create_purchase_request_input.dart';
import '../controllers/purchase_request_controller.dart';
import '../widgets/purchase/asset_picker_sheet.dart';
import '../widgets/purchase/asset_type_precontext_sheet.dart';
import '../widgets/purchase/vehicle_spec_picker_sheet.dart';
import '../widgets/purchase/vendor_target_picker_sheet.dart';

class PurchaseRequestPage extends StatefulWidget {
  const PurchaseRequestPage({super.key});

  @override
  State<PurchaseRequestPage> createState() => _PurchaseRequestPageState();
}

class _PurchaseRequestPageState extends State<PurchaseRequestPage> {
  late final PurchaseRequestController controller;

  // Encabezado (el título fue eliminado del formulario: se auto-genera en
  // submit a partir del contexto — tipo de activo + categoría).

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
    // Título: auto-generado en submit a partir del contexto (tipo de activo
    // + categoría). Categoría: Dropdown reactivo, no requiere TextEditingCtrl.
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
      // El controller ya expuso un mensaje humano específico basado en la
      // causa real (401, red, 4xx con code canónico, 5xx). Si por alguna
      // razón no hay mensaje (bug), usamos el genérico como fallback.
      final msg = controller.lastSubmitError.value ??
          'Error al enviar la solicitud. Intenta de nuevo.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
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
                    // Sección 1 — Alcance del pedido (tipo de activo, tipo
                    // de solicitud, aplicar a, activo relacionado).
                    _ScopeSection(controller: controller),
                    const SizedBox(height: 20),
                    // Sección 2 — Clasificación (categoría dependiente del
                    // tipo de activo × tipo de solicitud) + observaciones.
                    _ClassificationSection(
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
                controller.selectedVehicleSpec.value;
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
// SECCIÓN 1 — Alcance del pedido
// ───────────────────────────────────────────────────────────────────────────
// Define el universo operativo: tipo de activo precontexto (chip read-only),
// naturaleza del pedido (Producto/Servicio) y destino (Aplicar a). Incluye el
// picker real de activos del workspace cuando el destino es un activo concreto.
class _ScopeSection extends StatelessWidget {
  final PurchaseRequestController controller;

  const _ScopeSection({required this.controller});

  /// Label contextual de "Pedido para un …" según el tipo de activo ya
  /// preseleccionado en el BottomSheet precontexto. Si no hay tipo definido,
  /// cae en una etiqueta neutra genérica.
  String _assetOrderLabel(AssetType? t) {
    switch (t) {
      case AssetType.vehicle:
        return 'Pedido para un vehículo';
      case AssetType.realEstate:
        return 'Pedido para un inmueble';
      case AssetType.machinery:
        return 'Pedido para una maquinaria';
      case AssetType.equipment:
        return 'Pedido para un equipo';
      case null:
        return 'Pedido para un activo';
    }
  }

  /// Label contextual del botón del picker, según el tipo de activo.
  String _pickAssetLabel(AssetType? t, bool alreadySelected) {
    final base = switch (t) {
      AssetType.vehicle => 'vehículo',
      AssetType.realEstate => 'inmueble',
      AssetType.machinery => 'maquinaria',
      AssetType.equipment => 'equipo',
      null => 'activo',
    };
    return alreadySelected ? 'Cambiar $base' : 'Seleccionar $base';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: 'Alcance del pedido',
      icon: Icons.flag_outlined,
      children: [
        // A) Tipo de activo (read-only, proviene del BottomSheet precontexto).
        Obx(() {
          final t = controller.selectedAssetType.value;
          return Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: Icon(
                t == null ? Icons.inventory_2_outlined : assetTypeIcon(t),
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                t == null
                    ? 'Tipo de activo: no definido'
                    : 'Tipo de activo: ${assetTypeLabel(t)}',
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        // B) "Aplica a" — PRIMERA decisión del usuario. Su valor determina si
        //    mostramos "Tipo de solicitud" y el picker de activo específico.
        Obx(() {
          final t = controller.selectedAssetType.value;
          final current = controller.originType.value;
          // Saneamos: el enum canónico tiene `general` por compat backend;
          // aquí solo son válidos `asset` o `inventory`.
          final safeCurrent = current == PurchaseRequestOriginInput.inventory
              ? current
              : PurchaseRequestOriginInput.asset;
          return DropdownButtonFormField<PurchaseRequestOriginInput>(
            key: const Key('purchase_request_page.apply_to_dropdown'),
            initialValue: safeCurrent,
            decoration: const InputDecoration(
              labelText: 'Aplica a *',
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: PurchaseRequestOriginInput.asset,
                child: Text(_assetOrderLabel(t)),
              ),
              const DropdownMenuItem(
                value: PurchaseRequestOriginInput.inventory,
                child: Text('Pedido para inventario / stock'),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              controller.originType.value = v;
              if (v == PurchaseRequestOriginInput.inventory) {
                // Inventario/stock no aplica a servicios: fijamos PRODUCTO
                // implícitamente, limpiamos activo y revalidamos categoría.
                controller.clearAsset();
                controller.forceProductNature();
              } else {
                // Volviendo a "activo": no arrastrar estado inválido, y si
                // la categoría ya no pertenece al nuevo catálogo (activo ×
                // tipo actual) la limpiamos. También limpiamos la spec —
                // no aplica cuando el pedido es a un activo específico.
                controller.clearVehicleSpec();
                controller.ensureCategoryValid();
              }
            },
          );
        }),
        // C) "Tipo de solicitud" — SOLO visible cuando Aplica a = activo.
        //    En inventario/stock el tipo queda implícito en PRODUCTO.
        Obx(() {
          final isAssetScope = controller.originType.value ==
              PurchaseRequestOriginInput.asset;
          if (!isAssetScope) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: DropdownButtonFormField<PurchaseRequestTypeInput>(
              key: const Key('purchase_request_page.request_type_dropdown'),
              initialValue: controller.type.value,
              decoration: const InputDecoration(
                labelText: 'Tipo de solicitud *',
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
                if (v == null) return;
                controller.type.value = v;
                controller.ensureCategoryValid();
              },
            ),
          );
        }),
        // D) Activo específico — SOLO cuando Aplica a = activo. Usa picker
        //    real del workspace, filtrado por el tipo de activo precontexto
        //    y con buscador interno.
        Obx(() {
          final isAssetScope = controller.originType.value ==
              PurchaseRequestOriginInput.asset;
          if (!isAssetScope) return const SizedBox.shrink();
          final t = controller.selectedAssetType.value;
          final selectedId = controller.assetId.value;
          final label = controller.assetLabel.value;
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t == null
                      ? 'Activo relacionado *'
                      : '${assetTypeSingular(t)} relacionado *',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                if (selectedId.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      key: const Key(
                          'purchase_request_page.selected_asset_chip'),
                      avatar: const Icon(
                          Icons.precision_manufacturing_outlined,
                          size: 18),
                      label: Text(label.isNotEmpty ? label : selectedId),
                      onDeleted: controller.clearAsset,
                      deleteIconColor: theme.colorScheme.error,
                    ),
                  )
                else
                  Text(
                    t == null
                        ? 'Sin activo seleccionado'
                        : 'Sin ${assetTypeSingular(t).toLowerCase()} seleccionado',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    key: const Key(
                        'purchase_request_page.pick_asset_button'),
                    onPressed: () => AssetPickerSheet.show(
                      context,
                      filterType: t,
                    ),
                    icon: const Icon(
                        Icons.precision_manufacturing_outlined,
                        size: 18),
                    label:
                        Text(_pickAssetLabel(t, selectedId.isNotEmpty)),
                  ),
                ),
                // Bloque de contexto comercial/técnico — solo para vehículos.
                if (t == AssetType.vehicle && selectedId.isNotEmpty)
                  _SelectedVehicleSummary(controller: controller),
              ],
            ),
          );
        }),
        // E) Inventario/Stock — bloque VehicleSpec (solo vehículos).
        //    Sustituye al selector de placa: el pedido se relaciona a una
        //    especificación derivada del parque, no a un activo puntual.
        Obx(() {
          final isInventoryScope = controller.originType.value ==
              PurchaseRequestOriginInput.inventory;
          if (!isInventoryScope) return const SizedBox.shrink();
          final t = controller.selectedAssetType.value;
          if (t != AssetType.vehicle) {
            // Fase 1: otros tipos de activo aún no tienen "spec" derivada.
            // El pedido de stock queda genérico sin target específico.
            return const SizedBox.shrink();
          }
          final spec = controller.selectedVehicleSpec.value;
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Especificación de vehículo *',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                if (spec != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      key: const Key(
                          'purchase_request_page.selected_vehicle_spec_chip'),
                      avatar: const Icon(
                          Icons.directions_car_filled_outlined,
                          size: 18),
                      label: Text(
                        spec.linkedAssetsCount > 0
                            ? '${spec.displayLabel} — ${spec.linkedAssetsCount} vehículo'
                                '${spec.linkedAssetsCount == 1 ? '' : 's'}'
                            : spec.displayLabel,
                      ),
                      onDeleted: controller.clearVehicleSpec,
                      deleteIconColor: theme.colorScheme.error,
                    ),
                  )
                else
                  Text(
                    'Sin especificación seleccionada',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    key: const Key(
                        'purchase_request_page.pick_vehicle_spec_button'),
                    onPressed: () => VehicleSpecPickerSheet.show(context),
                    icon: const Icon(
                        Icons.directions_car_filled_outlined,
                        size: 18),
                    label: Text(spec == null
                        ? 'Seleccionar especificación'
                        : 'Cambiar especificación'),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

/// Bloque compacto de contexto vehicular mostrado bajo el picker cuando el
/// pedido aplica a un vehículo específico. Reactivo a `selectedVehicle` del
/// controller — se oculta solo si los detalles aún no cargaron o si el tipo
/// de activo no es vehículo.
class _SelectedVehicleSummary extends StatelessWidget {
  final PurchaseRequestController controller;
  const _SelectedVehicleSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final v = controller.selectedVehicle.value;
      // Sin datos aún (fetch en curso) → no renderizamos ruido; el chip de
      // placa ya confirma al usuario que la selección quedó hecha.
      if (v == null) return const SizedBox.shrink();

      final lineLabel = _joinNonEmpty([v.marca, v.line ?? v.modelo], ' ');
      final yearLabel = v.anio > 0 ? 'Año ${v.anio}' : null;
      final serviceLabel = _prettyCase(v.serviceType);
      final chassis = v.vin?.trim().isNotEmpty == true
          ? v.vin!
          : (v.chassisNumber?.trim().isNotEmpty == true
              ? v.chassisNumber!
              : null);

      return Container(
        key: const Key('purchase_request_page.vehicle_summary'),
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehículo seleccionado',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            _SummaryRow(label: 'Placa', value: v.placa),
            if (lineLabel != null)
              _SummaryRow(label: 'Marca / línea', value: lineLabel),
            if (yearLabel != null) _SummaryRow(label: 'Año', value: '${v.anio}'),
            if (serviceLabel != null)
              _SummaryRow(label: 'Servicio', value: serviceLabel),
            if (chassis != null)
              _SummaryRow(label: 'Chasis / VIN', value: chassis),
          ],
        ),
      );
    });
  }

  static String? _joinNonEmpty(List<String?> parts, String sep) {
    final xs = parts
        .map((e) => e?.trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    if (xs.isEmpty) return null;
    return xs.join(sep);
  }

  /// Normaliza strings tipo "PARTICULAR" / "PÚBLICO" → "Particular".
  static String? _prettyCase(String? raw) {
    final s = raw?.trim();
    if (s == null || s.isEmpty) return null;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// SECCIÓN 2 — Clasificación
// ───────────────────────────────────────────────────────────────────────────
// Categoría dependiente de (tipo de activo × tipo de solicitud) + notas libres.
class _ClassificationSection extends StatelessWidget {
  final TextEditingController notesCtrl;
  final PurchaseRequestController controller;

  const _ClassificationSection({
    required this.notesCtrl,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Clasificación',
      icon: Icons.category_outlined,
      children: [
        Obx(() {
          // Las listas de PRODUCTO y SERVICIO son independientes y se
          // recomputan cuando cambia cualquiera de las dos dimensiones.
          final cats = controller.currentCategories;
          final current = controller.category.value.trim();
          final value = cats.contains(current) ? current : null;
          return DropdownButtonFormField<String>(
            key: const Key('purchase_request_page.category_dropdown'),
            initialValue: value,
            decoration: const InputDecoration(
              labelText: 'Categoría *',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final c in cats)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) => controller.category.value = v ?? '',
          );
        }),
        const SizedBox(height: 12),
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
      title: 'Proveedores',
      icon: Icons.add_business_outlined,
      children: [
        Text(
          'Selecciona hasta 3 proveedores de tu workspace para enviarles '
          'la solicitud.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final ids = controller.selectedVendorIds;
          // Mapa por id usando la lista cruda (no el getter filtrado) para
          // mostrar correctamente el displayName incluso si un proveedor ya
          // no cumple el filtro por algún cambio de roleLabel.
          final vendorsById = {
            for (final v in controller.availableContacts) v.id: v,
          };
          if (ids.isEmpty) {
            return Text(
              'Sin proveedores seleccionados',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            );
          }
          return Wrap(
            spacing: 6,
            runSpacing: 4,
            children: ids.map((id) {
              final v = vendorsById[id];
              final label = v?.displayName ?? id;
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
            icon: const Icon(Icons.add_business_outlined, size: 18),
            label: const Text('Seleccionar proveedores'),
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

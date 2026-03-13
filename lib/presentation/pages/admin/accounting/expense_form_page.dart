// ============================================================================
// lib/presentation/pages/admin/accounting/expense_form_page.dart
// NUEVO GASTO — Enterprise Ultra Pro (Presentation / Pages)
//
// QUÉ HACE:
// - Formulario de registro de gastos con items, métodos de pago y destinatario.
// - Usa ReactiveTextField para campos de texto con binding GetX (RxString).
//
// QUÉ NO HACE:
// - NO persiste datos (solo UI de captura).
// - NO define su propio widget de texto (usa ReactiveTextField compartido).
//
// NOTAS:
// - _ModernTextField eliminado: reemplazado por ReactiveTextField público.
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/presentation/widgets/forms/reactive_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

double _parseMoney(String input) {
  final digits = input.replaceAll(RegExp(r'[^\d]'), '');
  return digits.isEmpty ? 0 : (double.tryParse(digits) ?? 0);
}

// ------------------------------- MODELOS -------------------------------------
enum ExpenseType {
  operativo,
  mantenimiento,
  personal,
  impuesto,
  financiero,
  otros
}

enum PaymentMethod { efectivo, transferencia, debito, credito, cheque, otro }

//

class ExpenseItem {
  ExpenseItem({
    String? id, // <- NUEVO
    this.concepto = '',
    this.vrUnit = 0,
    this.cantidad = 1,
    this.deducible = true,
    this.capitalizable = false,
  }) : id = id ?? _uuid.v4();

  final String id;
  String concepto;
  double vrUnit;
  int cantidad;
  bool deducible;
  bool capitalizable;
  double get total => (vrUnit * cantidad).toDouble();
}

class PaymentSplit {
  PaymentSplit({
    String? id, // <- NUEVO
    this.method = PaymentMethod.efectivo,
    this.monto = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.cuotas,
    this.costoFinanciero,
    this.primerVencimiento,
    this.nota,
  }) : id = id ?? _uuid.v4();

  final String id;
  PaymentMethod method;
  double monto;
  String? banco;
  String? accountLast4;
  String? referencia;
  int? cuotas;
  double? costoFinanciero;
  DateTime? primerVencimiento;
  String? nota;
}

// ------------------------------ CONTROLLER -----------------------------------
class ExpenseFormController extends GetxController {
  // Identificación
  final fecha = DateTime.now().obs;
  final consecutivo = 'GAS-${DateTime.now().year}-00001'.obs;
  final assetType = AssetType.vehiculo.obs;
  final centroCosto = ''.obs;
  final expenseType = ExpenseType.mantenimiento.obs;

  // Destinatario
  final destinatario = ''.obs;
  final nit = ''.obs;
  final direccion = ''.obs;

  // Ítems
  final items = <ExpenseItem>[ExpenseItem()].obs;
  void addItem() {
    items.add(ExpenseItem());
  }

  void removeItem(int index) {
    if (items.length > 1) items.removeAt(index);
  }

  double get totalItems =>
      items.fold<double>(0, (s, e) => s + (e.total.isFinite ? e.total : 0));

  // Pagos
  final pagos = <PaymentSplit>[PaymentSplit()].obs;
  void addPago() {
    pagos.add(PaymentSplit());
  }

  void removePago(int index) {
    if (pagos.length > 1) pagos.removeAt(index);
  }

  double get totalPagos =>
      pagos.fold<double>(0, (s, p) => s + (p.monto.isFinite ? p.monto : 0));

  double get diferencia => (totalItems - totalPagos);
  final marcarComoCxP = false.obs;

  String? validate() {
    if (destinatario.value.trim().isEmpty) return 'Falta el destinatario.';
    if (centroCosto.value.trim().isEmpty) return 'Falta el centro de costo.';
    if (items.any((e) => e.concepto.trim().isEmpty)) {
      return 'Hay ítems sin concepto.';
    }
    if (items.any((e) => e.vrUnit <= 0 || e.cantidad <= 0)) {
      return 'Ítems con valores/cantidades inválidos.';
    }
    if (totalItems <= 0) return 'El total del gasto debe ser mayor a 0.';
    if (diferencia != 0 && !marcarComoCxP.value) {
      return 'El total de pagos no coincide. Marca diferencia como CxP o ajusta montos.';
    }
    for (final p in pagos) {
      if ((p.method == PaymentMethod.transferencia ||
              p.method == PaymentMethod.debito ||
              p.method == PaymentMethod.credito) &&
          (p.banco == null || p.banco!.trim().isEmpty)) {
        return 'Falta banco en un pago no en efectivo.';
      }
      if (p.method == PaymentMethod.credito &&
          (p.cuotas == null || p.cuotas! < 1)) {
        return 'Pago con crédito sin número de cuotas válido.';
      }
    }
    return null;
  }

  Future<void> save() async {
    final error = validate();
    if (error != null) {
      Get.snackbar(
        'Validación',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar(
      '✓ Éxito',
      'Gasto guardado correctamente',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}

// --------------------------------- PAGE --------------------------------------
class ExpenseFormPage extends StatelessWidget {
  const ExpenseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ExpenseFormController(), permanent: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Nuevo Gasto',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 12, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1A1A1A),
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.1),
                  const Color(0xFF764ba2).withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registra y gestiona tu gasto',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                    children: [
                      ModernSection(
                        title: '📋 Consecutivo',
                        headerExtra: Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF667eea)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                '#${c.consecutivo.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            )),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _ModernFechaField(c: c)),
                                const SizedBox(width: 12),
                                Expanded(child: _ModernSelectAssetType(c: c)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _ModernSelectExpenseType(c: c),
                            const SizedBox(height: 16),
                            _ModernCentroCostoField(c: c),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ModernSection(
                        title: '💰 Gasto Total',
                        trailing: Obx(() {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFB923C), Color(0xFFE11D48)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF667eea).withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              _money.format(c.totalItems),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          );
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Detalle del Gasto'),
                            const SizedBox(height: 16),
                            Obx(() {
                              return Column(
                                children: [
                                  for (int i = 0; i < c.items.length; i++)
                                    _ModernItemCard(
                                        key: ValueKey(c.items[i].id),
                                        itemId: c.items[i].id,
                                        visualIndex: i,
                                        c: c),
                                ],
                              );
                            }),
                            const SizedBox(height: 12),
                            ModernAddButton(
                              label: 'Agregar Ítem',
                              icon: Icons.add_circle_outline,
                              onPressed: c.addItem,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ModernSection(
                        title: '👤 Destinatario',
                        child: Column(
                          children: [
                            ReactiveTextField(
                              label: 'Persona / Organización',
                              hint: 'Ej. Transporte López',
                              value: c.destinatario,
                              icon: Icons.business_outlined,
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              label: 'NIT / CC',
                              hint: '123456789-0',
                              value: c.nit,
                              icon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(width: 12),
                            ReactiveTextField(
                              label: 'Dirección',
                              hint: 'Calle 123 #45-67',
                              value: c.direccion,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ModernSection(
                        title: '💳 Métodos de Pago',
                        trailing: Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _money.format(c.totalPagos),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }),
                        child: Column(
                          children: [
                            Obx(() {
                              return Column(
                                children: [
                                  for (int i = 0; i < c.pagos.length; i++)
                                    _ModernPagoCard(
                                        key: ValueKey(c.pagos[i].id),
                                        pagoId: c.pagos[i].id,
                                        visualIndex: i,
                                        c: c),
                                ],
                              );
                            }),
                            const SizedBox(height: 12),
                            ModernAddButton(
                              label: 'Agregar Método de Pago',
                              icon: Icons.payment,
                              onPressed: c.addPago,
                            ),
                            const SizedBox(height: 16),
                            Obx(() {
                              final diff = c.diferencia;
                              if (diff.abs() < 0.01) {
                                return const BalanceCard(
                                  label: '✓ Balanceado',
                                  amount: 0,
                                  isBalanced: true,
                                );
                              }
                              return Column(
                                children: [
                                  BalanceCard(
                                    label: diff > 0 ? 'Pendiente' : 'Excedente',
                                    amount: diff.abs(),
                                    isBalanced: false,
                                  ),
                                  const SizedBox(height: 12),
                                  ModernCheckbox(
                                    label: 'Marcar diferencia como CxP',
                                    value: c.marcarComoCxP,
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating Action Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ModernSubmitButton(onPressed: c.save),
          ),
        ],
      ),
    );
  }
}

// ========================= MODERN WIDGETS ====================================

class ModernSection extends StatelessWidget {
  const ModernSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.headerExtra, // <- nuevo
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final Widget? headerExtra; // <- nuevo

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    if (headerExtra != null) ...[
                      const SizedBox(width: 8),
                      headerExtra!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ModernFechaField extends StatelessWidget {
  const _ModernFechaField({required this.c});
  final ExpenseFormController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: c.fecha.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF667eea),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) c.fecha.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFF9CA3AF), size: 18),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd/MM/yyyy').format(c.fecha.value),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _ModernSelectAssetType extends StatelessWidget {
  const _ModernSelectAssetType({required this.c});
  final ExpenseFormController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Activo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AssetType>(
                  value: c.assetType.value,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color(0xFF9CA3AF)),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                  items: AssetType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(_assetTypeLabel(t)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) c.assetType.value = v;
                  },
                ),
              ),
            )),
      ],
    );
  }

  static String _assetTypeLabel(AssetType t) {
    switch (t) {
      case AssetType.vehiculo:
        return '🚗 Vehículo';
      case AssetType.inmueble:
        return '🏢 Inmueble';
      case AssetType.maquinaria:
        return '🏗️ Maquinaria';
      case AssetType.equipo:
        return '💼 Equipo';
      case AssetType.otro:
        return '✨ Otro';
    }
  }
}

class _ModernSelectExpenseType extends StatelessWidget {
  const _ModernSelectExpenseType({required this.c});
  final ExpenseFormController c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Gasto',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() =>

// Dentro del build:
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<ExpenseType>(
                  value: c.expenseType.value,
                  isExpanded: true,
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                  items: ExpenseType.values
                      .map((t) => DropdownMenuItem<ExpenseType>(
                            value: t,
                            child: Text(_expenseTypeLabel(t)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) c.expenseType.value = v;
                  },
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(
                          12), // bordes redondeados del menú
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                  ),
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  static String _expenseTypeLabel(ExpenseType t) {
    switch (t) {
      case ExpenseType.operativo:
        return '⚙️   Operativo';
      case ExpenseType.mantenimiento:
        return '🔧   Mantenimiento';
      case ExpenseType.personal:
        return '👥   Personal';
      case ExpenseType.impuesto:
        return '🏛️   Impuesto';
      case ExpenseType.financiero:
        return '💰   Financiero';
      case ExpenseType.otros:
        return '✨   Otros';
    }
  }
}

class _ModernCentroCostoField extends StatelessWidget {
  const _ModernCentroCostoField({required this.c});
  final ExpenseFormController c;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ReactiveTextField(
          label: 'Centro de Costo',
          hint: 'Ej. Operaciones',
          value: c.centroCosto,
          icon: c.assetType.value.icon,
        ));
  }
}

class _ModernItemCard extends StatefulWidget {
  const _ModernItemCard({
    super.key,
    required this.itemId,
    required this.visualIndex,
    required this.c,
  });
  final String itemId;
  final int visualIndex;
  final ExpenseFormController c;

  @override
  State<_ModernItemCard> createState() => _ModernItemCardState();
}

class _ModernItemCardState extends State<_ModernItemCard> {
  late TextEditingController conceptCtrl;
  late TextEditingController vrCtrl;
  late TextEditingController qtyCtrl;
  late final FocusNode conceptFocus;
  late final FocusNode vrFocus;
  late final FocusNode qtyFocus;

  ExpenseItem? get _itemOrNull {
    final i = widget.c.items.indexWhere((e) => e.id == widget.itemId);
    return i >= 0 ? widget.c.items[i] : null;
  }

  @override
  void initState() {
    super.initState();
    final item = _itemOrNull!; // seguro: widget creado con itemId válido
    conceptCtrl = TextEditingController(text: item.concepto);
    vrCtrl = TextEditingController(
        text: item.vrUnit > 0 ? item.vrUnit.toStringAsFixed(0) : '');
    qtyCtrl = TextEditingController(text: item.cantidad.toString());
    conceptFocus = FocusNode();
    vrFocus = FocusNode();
    qtyFocus = FocusNode();
  }

  @override
  void didUpdateWidget(_ModernItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final item = _itemOrNull;
    if (item == null) return;

    // ID cambió: el item referenciado es otro → reinicializa sin pisar foco.
    if (oldWidget.itemId != widget.itemId) {
      if (!conceptFocus.hasFocus) conceptCtrl.text = item.concepto;
      if (!vrFocus.hasFocus)
        vrCtrl.text = item.vrUnit > 0 ? item.vrUnit.toStringAsFixed(0) : '';
      if (!qtyFocus.hasFocus) qtyCtrl.text = item.cantidad.toString();
      return;
    }

    // Sync conservador: solo actualiza si el campo NO tiene foco.
    // Evita pisar cursor/selección mientras el usuario escribe.
    final newConcepto = item.concepto;
    if (!conceptFocus.hasFocus && conceptCtrl.text != newConcepto)
      conceptCtrl.text = newConcepto;

    final newVr = item.vrUnit > 0 ? item.vrUnit.toStringAsFixed(0) : '';
    if (!vrFocus.hasFocus && vrCtrl.text != newVr) vrCtrl.text = newVr;

    final newQty = item.cantidad.toString();
    if (!qtyFocus.hasFocus && qtyCtrl.text != newQty) qtyCtrl.text = newQty;
  }

  @override
  void dispose() {
    conceptCtrl.dispose();
    vrCtrl.dispose();
    qtyCtrl.dispose();
    conceptFocus.dispose();
    vrFocus.dispose();
    qtyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _itemOrNull;
    if (item == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667eea).withValues(alpha: 0.05),
            const Color(0xFF764ba2).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.visualIndex + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ítem ${widget.visualIndex + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (widget.c.items.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () {
                    final idx =
                        widget.c.items.indexWhere((e) => e.id == widget.itemId);
                    if (idx >= 0) widget.c.removeItem(idx);
                  },
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: conceptCtrl,
            focusNode: conceptFocus,
            onChanged: (v) {
              item.concepto = v;
              widget.c.items.refresh();
            },
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Concepto',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: vrCtrl,
                  focusNode: vrFocus,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    item.vrUnit = _parseMoney(v);
                    widget.c.items.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Vr. Unitario',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: qtyCtrl,
                  focusNode: qtyFocus,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    item.cantidad = int.tryParse(v) ?? 1;
                    widget.c.items.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Cant.',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      'Sub - Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _money.format(item.total),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernPagoCard extends StatefulWidget {
  const _ModernPagoCard({
    super.key,
    required this.pagoId,
    required this.visualIndex,
    required this.c,
  });
  final String pagoId;
  final int visualIndex;
  final ExpenseFormController c;

  @override
  State<_ModernPagoCard> createState() => _ModernPagoCardState();
}

class _ModernPagoCardState extends State<_ModernPagoCard> {
  late TextEditingController montoCtrl;
  late TextEditingController bancoCtrl;
  late TextEditingController refCtrl;
  late TextEditingController cuotasCtrl;
  late final FocusNode montoFocus;
  late final FocusNode bancoFocus;
  late final FocusNode refFocus;
  late final FocusNode cuotasFocus;

  PaymentSplit? get _pOrNull {
    final i = widget.c.pagos.indexWhere((e) => e.id == widget.pagoId);
    return i >= 0 ? widget.c.pagos[i] : null;
  }

  @override
  void initState() {
    super.initState();
    final p = _pOrNull!; // seguro: widget creado con pagoId válido
    montoCtrl = TextEditingController(
        text: p.monto > 0 ? p.monto.toStringAsFixed(0) : '');
    bancoCtrl = TextEditingController(text: p.banco ?? '');
    refCtrl = TextEditingController(text: p.referencia ?? '');
    cuotasCtrl = TextEditingController(text: p.cuotas?.toString() ?? '');
    montoFocus = FocusNode();
    bancoFocus = FocusNode();
    refFocus = FocusNode();
    cuotasFocus = FocusNode();
  }

  @override
  void didUpdateWidget(_ModernPagoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final p = _pOrNull;
    if (p == null) return;

    if (oldWidget.pagoId != widget.pagoId) {
      if (!montoFocus.hasFocus) {
        montoCtrl.text = p.monto > 0 ? p.monto.toStringAsFixed(0) : '';
      }
      if (!bancoFocus.hasFocus) {
        bancoCtrl.text = p.banco ?? '';
      }
      if (!refFocus.hasFocus) {
        refCtrl.text = p.referencia ?? '';
      }
      if (!cuotasFocus.hasFocus) {
        cuotasCtrl.text = p.cuotas?.toString() ?? '';
      }
      return;
    }

    final newMonto = p.monto > 0 ? p.monto.toStringAsFixed(0) : '';
    if (!montoFocus.hasFocus && montoCtrl.text != newMonto)
      montoCtrl.text = newMonto;

    final newBanco = p.banco ?? '';
    if (!bancoFocus.hasFocus && bancoCtrl.text != newBanco)
      bancoCtrl.text = newBanco;

    final newRef = p.referencia ?? '';
    if (!refFocus.hasFocus && refCtrl.text != newRef) refCtrl.text = newRef;

    final newCuotas = p.cuotas?.toString() ?? '';
    if (!cuotasFocus.hasFocus && cuotasCtrl.text != newCuotas)
      cuotasCtrl.text = newCuotas;
  }

  @override
  void dispose() {
    montoCtrl.dispose();
    bancoCtrl.dispose();
    refCtrl.dispose();
    cuotasCtrl.dispose();
    montoFocus.dispose();
    bancoFocus.dispose();
    refFocus.dispose();
    cuotasFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _pOrNull;
    if (p == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667eea).withValues(alpha: 0.05),
            const Color(0xFF764ba2).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payment, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pago ${widget.visualIndex + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (widget.c.pagos.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () {
                    final idx =
                        widget.c.pagos.indexWhere((e) => e.id == widget.pagoId);
                    if (idx >= 0) widget.c.removePago(idx);
                  },
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PaymentMethod>(
                value: p.method,
                isExpanded: true,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
                items: PaymentMethod.values
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(_pmLabel(m)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    p.method = v;
                    widget.c.pagos.refresh();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: montoCtrl,
                  focusNode: montoFocus,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    p.monto = _parseMoney(v);
                    widget.c.pagos.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              if (p.method != PaymentMethod.efectivo) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: bancoCtrl,
                    focusNode: bancoFocus,
                    onChanged: (v) {
                      p.banco = v;
                      widget.c.pagos.refresh();
                    },
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: 'Banco',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: refCtrl,
                  focusNode: refFocus,
                  onChanged: (v) {
                    p.referencia = v;
                    widget.c.pagos.refresh();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Referencia',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                ),
              ),
              if (p.method == PaymentMethod.credito) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: cuotasCtrl,
                    focusNode: cuotasFocus,
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      p.cuotas = int.tryParse(v);
                      widget.c.pagos.refresh();
                    },
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: 'Cuotas',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static String _pmLabel(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.efectivo:
        return '💵 Efectivo';
      case PaymentMethod.transferencia:
        return '🏦 Transferencia';
      case PaymentMethod.debito:
        return '💳 Débito';
      case PaymentMethod.credito:
        return '💳 Crédito';
      case PaymentMethod.cheque:
        return '📝 Cheque';
      case PaymentMethod.otro:
        return '✨ Otro';
    }
  }
}

class ModernAddButton extends StatelessWidget {
  const ModernAddButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF667eea), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF667eea), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF667eea),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernCheckbox extends StatelessWidget {
  const ModernCheckbox({super.key, required this.label, required this.value});

  final String label;
  final RxBool value;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () => value.value = !value.value,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: value.value
                  ? const Color(0xFF667eea).withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value.value
                    ? const Color(0xFF667eea)
                    : const Color(0xFFE5E7EB),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: value.value
                        ? const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          )
                        : null,
                    color: value.value ? null : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: value.value
                          ? Colors.transparent
                          : const Color(0xFFD1D5DB),
                      width: 2,
                    ),
                  ),
                  child: value.value
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: value.value
                          ? const Color(0xFF667eea)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.label,
    required this.amount,
    required this.isBalanced,
  });

  final String label;
  final double amount;
  final bool isBalanced;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBalanced
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                (isBalanced ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                    .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isBalanced ? Icons.check_circle : Icons.info,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isBalanced)
                  Text(
                    _money.format(amount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModernSubmitButton extends StatelessWidget {
  const ModernSubmitButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_rounded, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'Guardar Gasto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

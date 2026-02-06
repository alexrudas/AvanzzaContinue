// lib/presentation/accounting/expense_form_page.dart
// ============================================================================
// NUEVO GASTO — Avanzza 2.0 (UI PRO 2025 + lógica optimizada)
// ============================================================================

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

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
    this.concepto = '',
    this.vrUnit = 0,
    this.cantidad = 1,
    this.deducible = true,
    this.capitalizable = false,
  });
  String concepto;
  double vrUnit;
  int cantidad;
  bool deducible;
  bool capitalizable;
  double get total => (vrUnit * cantidad).toDouble();
}

class PaymentSplit {
  PaymentSplit({
    this.method = PaymentMethod.efectivo,
    this.monto = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.cuotas,
    this.costoFinanciero,
    this.primerVencimiento,
    this.nota,
  });
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
    update();
  }

  void removeItem(int index) {
    if (items.length > 1) items.removeAt(index);
    update();
  }

  double get totalItems =>
      items.fold<double>(0, (s, e) => s + (e.total.isFinite ? e.total : 0));

  // Pagos
  final pagos = <PaymentSplit>[PaymentSplit()].obs;
  void addPago() {
    pagos.add(PaymentSplit());
    update();
  }

  void removePago(int index) {
    if (pagos.length > 1) pagos.removeAt(index);
    update();
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
                color: Colors.black.withOpacity(0.05),
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
                  const Color(0xFF667eea).withOpacity(0.1),
                  const Color(0xFF764ba2).withOpacity(0.1),
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
                                        .withOpacity(0.3),
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
                          final touch = c.items.length;
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
                                      const Color(0xFF667eea).withOpacity(0.3),
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
                              final touch = c.items.length;
                              return Column(
                                children: [
                                  for (int i = 0; i < c.items.length; i++)
                                    _ModernItemCard(index: i, c: c),
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
                            _ModernTextField(
                              label: 'Persona / Organización',
                              hint: 'Ej. Transporte López',
                              value: c.destinatario,
                              icon: Icons.business_outlined,
                            ),
                            const SizedBox(height: 16),
                            _ModernTextField(
                              label: 'NIT / CC',
                              hint: '123456789-0',
                              value: c.nit,
                              icon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(width: 12),
                            _ModernTextField(
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
                          final touch = c.pagos.length;
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
                              final touch = c.pagos.length;
                              return Column(
                                children: [
                                  for (int i = 0; i < c.pagos.length; i++)
                                    _ModernPagoCard(index: i, c: c),
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
  const ModernSection({super.key, 
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
            color: Colors.black.withOpacity(0.04),
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

class _ModernTextField extends StatelessWidget {
  const _ModernTextField({
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final RxString value;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: value.value,
                  keyboardType: keyboardType,
                  onChanged: (v) => value.value = v,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
    return Obx(() => _ModernTextField(
          label: 'Centro de Costo',
          hint: 'Ej. Operaciones',
          value: c.centroCosto,
          icon: c.assetType.value.icon,
        ));
  }
}

class _ModernItemCard extends StatelessWidget {
  const _ModernItemCard({required this.index, required this.c});
  final int index;
  final ExpenseFormController c;

  @override
  Widget build(BuildContext context) {
    final item = c.items[index];
    final conceptCtrl = TextEditingController(text: item.concepto);
    final vrCtrl = TextEditingController(
        text: item.vrUnit > 0 ? item.vrUnit.toStringAsFixed(0) : '');
    final qtyCtrl = TextEditingController(text: item.cantidad.toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667eea).withOpacity(0.05),
            const Color(0xFF764ba2).withOpacity(0.05),
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
                  '${index + 1}',
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
                  'Ítem ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (c.items.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () => c.removeItem(index),
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: conceptCtrl,
            onChanged: (v) {
              item.concepto = v;
              c.update();
            },
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences, // <- clave
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
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    item.vrUnit = double.tryParse(
                            v.replaceAll('.', '').replaceAll(',', '')) ??
                        0;
                    c.update();
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
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    item.cantidad = int.tryParse(v) ?? 1;
                    c.update();
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
                        color: Colors.black.withOpacity(0.8),
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

class _ModernPagoCard extends StatelessWidget {
  const _ModernPagoCard({required this.index, required this.c});
  final int index;
  final ExpenseFormController c;

  @override
  Widget build(BuildContext context) {
    final p = c.pagos[index];
    final montoCtrl = TextEditingController(
        text: p.monto > 0 ? p.monto.toStringAsFixed(0) : '');
    final bancoCtrl = TextEditingController(text: p.banco ?? '');
    final refCtrl = TextEditingController(text: p.referencia ?? '');
    final last4Ctrl = TextEditingController(text: p.accountLast4 ?? '');
    final cuotasCtrl = TextEditingController(text: p.cuotas?.toString() ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667eea).withOpacity(0.05),
            const Color(0xFF764ba2).withOpacity(0.05),
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
                  'Pago ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (c.pagos.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () => c.removePago(index),
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
                    c.update();
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
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    p.monto = double.tryParse(
                            v.replaceAll('.', '').replaceAll(',', '')) ??
                        0;
                    c.update();
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
                    onChanged: (v) {
                      p.banco = v;
                      c.update();
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
                  onChanged: (v) {
                    p.referencia = v;
                    c.update();
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
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      p.cuotas = int.tryParse(v);
                      c.update();
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
  const ModernAddButton({super.key, 
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

class _ModernSwitch extends StatelessWidget {
  const _ModernSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF667eea).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value ? const Color(0xFF667eea) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    value ? const Color(0xFF667eea) : const Color(0xFF6B7280),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF667eea),
          ),
        ],
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
                  ? const Color(0xFF667eea).withOpacity(0.1)
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
  const BalanceCard({super.key, 
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
                    .withOpacity(0.3),
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
                    color: Colors.white.withOpacity(0.9),
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
            color: const Color(0xFF667eea).withOpacity(0.5),
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

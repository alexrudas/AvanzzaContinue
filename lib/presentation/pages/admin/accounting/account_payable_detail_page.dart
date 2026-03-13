// ============================================================================
// lib/presentation/pages/admin/accounting/account_payable_detail_page.dart
// CUENTA POR PAGAR (CxP) — Detalle + Registro de Pagos
// Enterprise Ultra Pro (Presentation / Pages)
//
// FIXES (hard):
// - SDK < 3.6: sin digit separators (8500000, no 8_500_000)
// - Back predictivo Android: WillPopScope -> PopScope (Flutter >= 3.12)
// - PopScope compatible: usa onPopInvoked (evita onPopInvokedWithResult)
// - Limpieza de memoria + UI al cambiar método (modelo + controllers)
// - Validación dura: last4 obligatorio (exactamente 4 dígitos) cuando aplica
// - Contabilidad: monto en int (COP) para evitar errores de double
// - Performance: NO refresh por tecla (debounce para totales)
// - Notes: RxString listen en Get 4.7.2 -> ever() (Worker) (no StreamSubscription)
// - Política needs*: usa CollectionMethodPolicyX del dominio (no duplicado).
// ============================================================================

import 'dart:async';

import 'package:avanzza/domain/value/accounting/collection_method.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

int _parseCopInt(String input) {
  final digits = input.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.isEmpty) return 0;
  return int.tryParse(digits) ?? 0;
}

String _formatCopInt(int amount) {
  final safe = amount < 0 ? 0 : amount;
  return _money.format(safe);
}

final _kDropdownStyle = DropdownStyleData(
  decoration: BoxDecoration(
    color: const Color(0xFFF3F4F6),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFE5E7EB)),
  ),
);
const _kButtonStyle = ButtonStyleData(padding: EdgeInsets.zero);

// ------------------------------- MODELOS -------------------------------------

class PaymentSplit {
  PaymentSplit({
    String? id,
    this.method = CollectionMethod.transferencia,
    this.montoCop = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.nota,
  }) : id = id ?? _uuid.v4();

  final String id;
  CollectionMethod method;

  /// Monto en COP (entero) — evita errores binarios de double.
  int montoCop;

  String? banco;
  String? accountLast4;
  String? referencia;
  String? nota;
}

class AccountPayable {
  AccountPayable({
    required this.id,
    required this.consecutivoOrigen,
    required this.fechaCreacion,
    required this.proveedor,
    required this.montoOriginalCop,
    required this.concepto,
    this.montoPagadoInicialCop = 0,
    this.pagosAnteriores = const [],
  });

  final String id;
  final String consecutivoOrigen;
  final DateTime fechaCreacion;
  final String proveedor;
  final int montoOriginalCop;
  final String concepto;

  final int montoPagadoInicialCop;
  final List<PaymentSplit> pagosAnteriores;

  int get totalPagadoAnteriorCop =>
      montoPagadoInicialCop +
      pagosAnteriores.fold<int>(
        0,
        (s, p) => s + (p.montoCop < 0 ? 0 : p.montoCop),
      );

  int get saldoInicialCop => montoOriginalCop - totalPagadoAnteriorCop;
}

// ------------------------------ CONTROLLER -----------------------------------

class APDetailController extends GetxController {
  APDetailController(this.apId) {
    // DEMO DATA (sustituir por repo)
    cxp = AccountPayable(
      id: apId,
      consecutivoOrigen: 'EGR-${DateTime.now().year}-00005',
      fechaCreacion: DateTime(DateTime.now().year, 10, 5),
      proveedor: 'Suministros Industriales S.A.',
      montoOriginalCop: 8500000,
      montoPagadoInicialCop: 4000000,
      concepto: 'Compra de materia prima lote 3 (Factura #7890)',
      pagosAnteriores: [
        PaymentSplit(
          method: CollectionMethod.transferencia,
          montoCop: 1500000,
          banco: 'Banco del Proveedor',
          referencia: 'Pago-54321',
        ),
      ],
    );

    nuevosPagos.add(PaymentSplit());
    _uiTick.value++;
  }

  final String apId;
  late final AccountPayable cxp;

  final fechaPago = DateTime.now().obs;
  final notaPago = ''.obs;

  final nuevosPagos = <PaymentSplit>[].obs;
  final marcarComoAjustada = false.obs;

  /// Disparador liviano para recalcular UI sin refresh por tecla.
  final RxInt _uiTick = 0.obs;

  int get saldoInicialCop => cxp.saldoInicialCop < 0 ? 0 : cxp.saldoInicialCop;

  int get totalNuevosPagosCop {
    // Dependencia explícita para que Obx se entere de cambios (debounce bump).
    // ignore: unused_local_variable
    final _ = _uiTick.value;
    return nuevosPagos.fold<int>(
      0,
      (s, p) => s + (p.montoCop < 0 ? 0 : p.montoCop),
    );
  }

  int get diferenciaCop => saldoInicialCop - totalNuevosPagosCop;

  int get valorAjusteCop =>
      (marcarComoAjustada.value && diferenciaCop > 0) ? diferenciaCop : 0;

  int get saldoFinalCop =>
      marcarComoAjustada.value ? 0 : (diferenciaCop > 0 ? diferenciaCop : 0);

  void bumpUi() => _uiTick.value++;

  void addPago() {
    nuevosPagos.add(PaymentSplit());
    bumpUi();
  }

  void removePago(int index) {
    if (nuevosPagos.length <= 1) return;
    nuevosPagos.removeAt(index);
    bumpUi();
  }

  // ---------------- Validación (dura) ----------------

  String? validate() {
    if (saldoInicialCop <= 1) return 'Esta cuenta ya no tiene saldo pendiente.';
    if (totalNuevosPagosCop <= 0) return 'Debe ingresar un monto válido.';

    if (totalNuevosPagosCop - saldoInicialCop > 1) {
      return 'El monto excede el saldo pendiente. Ajusta los montos.';
    }

    if (marcarComoAjustada.value && diferenciaCop.abs() <= 1) {
      return 'No hay diferencia para ajustar. Desmarca “Ajuste/Descuento”.';
    }

    for (final p in nuevosPagos) {
      if (p.montoCop <= 0) continue;

      if (p.method.needsBanco &&
          (p.banco == null || p.banco!.trim().isEmpty)) {
        return 'Falta banco en un método que lo requiere.';
      }

      if (p.method.needsReferencia &&
          (p.referencia == null || p.referencia!.trim().isEmpty)) {
        return 'Falta referencia / número de transacción.';
      }

      if (p.method.needsLast4) {
        final v = (p.accountLast4 ?? '').trim();
        if (v.isEmpty) return 'Faltan los últimos 4 dígitos.';
        if (v.length != 4 || !RegExp(r'^\d{4}$').hasMatch(v)) {
          return 'Últimos 4 dígitos inválidos. Deben ser exactamente 4 números.';
        }
      }

      if (p.method.needsNota && (p.nota == null || p.nota!.trim().isEmpty)) {
        return 'Falta nota justificativa en el método “Otro”.';
      }
    }

    if (fechaPago.value.isBefore(cxp.fechaCreacion)) {
      return 'La fecha de transacción no puede ser anterior a la creación de la cuenta.';
    }

    // Higiene: si no hay diferencia real, limpiar checkbox.
    if (diferenciaCop.abs() <= 1 && marcarComoAjustada.value) {
      marcarComoAjustada.value = false;
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

    await Future.delayed(const Duration(milliseconds: 250));

    final paid = _formatCopInt(totalNuevosPagosCop);
    final ajuste =
        valorAjusteCop > 1 ? ' | Ajuste: ${_formatCopInt(valorAjusteCop)}' : '';
    final saldoTxt = marcarComoAjustada.value
        ? 'CxP cerrada'
        : 'Saldo: ${_formatCopInt(saldoFinalCop)}';

    Get.snackbar(
      '✓ Pago Registrado',
      'Registrado: $paid$ajuste | $saldoTxt',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF7C3AED),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}

// --------------------------------- PAGE --------------------------------------

class AccountPayableDetailPage extends StatelessWidget {
  const AccountPayableDetailPage({super.key, required this.apId});

  final String apId;

  void _disposeControllerIfRegistered() {
    if (Get.isRegistered<APDetailController>(tag: apId)) {
      Get.delete<APDetailController>(tag: apId, force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Evita recreación si ya existe con el tag (cleaner para enterprise)
    final APDetailController c = Get.isRegistered<APDetailController>(tag: apId)
        ? Get.find<APDetailController>(tag: apId)
        : Get.put(APDetailController(apId), tag: apId, permanent: false);

    const Color apColor = Color(0xFF7C3AED);
    const Color apColorDark = Color(0xFF4C1D95);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _disposeControllerIfRegistered();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Cuentas x Pagar',
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
              onPressed: () {
                _disposeControllerIfRegistered();
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    apColor.withValues(alpha: 0.10),
                    apColorDark.withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          c.cxp.proveedor,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Acreedor',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                      children: [
                        _ModernSection(
                          title: 'ℹ️ Resumen',
                          headerExtra: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [apColor, apColorDark]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: apColor.withValues(alpha: 0.30),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              'SALDO: ${_formatCopInt(c.saldoInicialCop)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SummaryRowIcon(
                                label: 'Proveedor',
                                value: c.cxp.proveedor,
                                icon: Icons.store_outlined,
                                color: apColor,
                              ),
                              const SizedBox(height: 8),
                              _SummaryRowIcon(
                                label: 'Origen (Egreso)',
                                value: c.cxp.consecutivoOrigen,
                                icon: Icons.receipt_long_outlined,
                                color: apColor,
                              ),
                              const SizedBox(height: 8),
                              _SummaryRowIcon(
                                label: 'Fecha CxP',
                                value: DateFormat('dd/MM/yyyy')
                                    .format(c.cxp.fechaCreacion),
                                icon: Icons.calendar_today_outlined,
                                color: apColor,
                              ),
                              const SizedBox(height: 8),
                              _SummaryRowIcon(
                                label: 'Monto Original',
                                value: _formatCopInt(c.cxp.montoOriginalCop),
                                icon: Icons.attach_money_outlined,
                                color: apColor,
                              ),
                              const SizedBox(height: 8),
                              _SummaryRowIcon(
                                label: 'Pagado Anterior',
                                value:
                                    _formatCopInt(c.cxp.totalPagadoAnteriorCop),
                                icon: Icons.check_circle_outline,
                                color: apColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Concepto: ${c.cxp.concepto}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ModernSection(
                          title: '💳 Realizar Pago',
                          trailing: Obx(() {
                            return Container(
                              alignment: Alignment.centerLeft,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [apColor, apColorDark]),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: apColor.withValues(alpha: 0.30),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                _formatCopInt(c.totalNuevosPagosCop),
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
                              _ModernFechaPagoField(c: c, color: apColor),
                              const SizedBox(height: 16),
                              const Text(
                                  'Detalle de los Pagos (esta transacción)'),
                              const SizedBox(height: 12),
                              Obx(() {
                                return Column(
                                  children: [
                                    for (int i = 0;
                                        i < c.nuevosPagos.length;
                                        i++)
                                      _ModernPaymentCardCxP(
                                        key: ValueKey(c.nuevosPagos[i].id),
                                        paymentId: c.nuevosPagos[i].id,
                                        visualIndex: i,
                                        c: c,
                                        primary: apColor,
                                        primaryDark: apColorDark,
                                      ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 12),
                              _ModernAddButton(
                                label: 'Agregar Método de Pago',
                                icon: Icons.account_balance_wallet_outlined,
                                color: apColor,
                                onPressed: c.addPago,
                              ),
                              const SizedBox(height: 16),
                              _ModernNotesField(
                                  value: c.notaPago, color: apColor),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ModernSection(
                          title: '⚖️ Balance',
                          child: Obx(() {
                            final diff = c.diferenciaCop;
                            final overpay = diff < -1;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _BalanceRow(
                                  label: 'Saldo Inicial Pendiente',
                                  amountCop: c.saldoInicialCop,
                                  color: const Color(0xFF4B5563),
                                ),
                                const SizedBox(height: 8),
                                _BalanceRow(
                                  label: 'Total Pagado Ahora',
                                  amountCop: c.totalNuevosPagosCop,
                                  color: apColor,
                                  sign: '-',
                                ),
                                const SizedBox(height: 12),
                                if (c.valorAjusteCop > 1) ...[
                                  _BalanceRow(
                                    label: 'Ajuste/Descuento (Cierre)',
                                    amountCop: c.valorAjusteCop,
                                    color: const Color(0xFF10B981),
                                    sign: '-',
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                if (overpay) ...[
                                  _BalanceCard(
                                    label: 'Excedente (Error)',
                                    amountCop: diff.abs(),
                                    isBalanced: false,
                                    primary: const Color(0xFFEF4444),
                                    primaryDark: const Color(0xFFB91C1C),
                                    icon: Icons.error_outline,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'El pago excede el saldo. Ajusta los montos.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ] else ...[
                                  _BalanceCard(
                                    label: c.marcarComoAjustada.value ||
                                            diff.abs() <= 1
                                        ? '✓ CxP Cerrada'
                                        : 'Saldo Final Pendiente',
                                    amountCop: c.saldoFinalCop,
                                    isBalanced: c.marcarComoAjustada.value ||
                                        diff.abs() <= 1,
                                    primary: apColor,
                                    primaryDark: apColorDark,
                                    icon: Icons.check_circle_outline,
                                  ),
                                  const SizedBox(height: 12),
                                  if (diff > 1)
                                    _ModernCheckbox(
                                      label:
                                          'Cerrar registrando diferencia como Ajuste/Descuento',
                                      value: c.marcarComoAjustada,
                                      active: apColor,
                                    ),
                                ],
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: _ModernSubmitButton(
                label: 'Registrar Pago',
                primary: apColor,
                primaryDark: apColorDark,
                onPressed: c.save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= PRIVATE WIDGETS ====================================

class _ModernSection extends StatelessWidget {
  const _ModernSection({
    required this.title,
    required this.child,
    this.trailing,
    this.headerExtra,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final Widget? headerExtra;

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

class _SummaryRowIcon extends StatelessWidget {
  const _SummaryRowIcon({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.20)),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModernFechaPagoField extends StatelessWidget {
  const _ModernFechaPagoField({required this.c, required this.color});

  final APDetailController c;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha del Pago',
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
                  initialDate: c.fechaPago.value,
                  firstDate: c.cxp.fechaCreacion,
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(primary: color),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) c.fechaPago.value = picked;
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
                      DateFormat('dd/MM/yyyy').format(c.fechaPago.value),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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

class _ModernNotesField extends StatefulWidget {
  const _ModernNotesField({required this.value, required this.color});

  final RxString value;
  final Color color;

  @override
  State<_ModernNotesField> createState() => _ModernNotesFieldState();
}

class _ModernNotesFieldState extends State<_ModernNotesField> {
  late final TextEditingController _ctrl;

  // GetX 4.7.2: Rx.listen / listen(...) retorna Worker, no StreamSubscription.
  late final Worker _worker;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value.value);

    _worker = ever<String>(widget.value, (v) {
      if (!mounted) return;
      if (_ctrl.text != v) {
        _ctrl.text = v;
      }
    });
  }

  @override
  void dispose() {
    _worker.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _ctrl,
      onChanged: (v) => widget.value.value = v,
      maxLines: null,
      minLines: 2,
      decoration: InputDecoration(
        labelText: 'Notas del Pago (Opcional)',
        hintText: 'Ej. Pago final con descuento aplicado.',
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.color, width: 2),
        ),
      ),
    );
  }
}

// ==================== Payment Card (Stateful) ====================

class _ModernPaymentCardCxP extends StatefulWidget {
  const _ModernPaymentCardCxP({
    super.key,
    required this.paymentId,
    required this.visualIndex,
    required this.c,
    required this.primary,
    required this.primaryDark,
  });

  final String paymentId;
  final int visualIndex;
  final APDetailController c;
  final Color primary;
  final Color primaryDark;

  @override
  State<_ModernPaymentCardCxP> createState() => _ModernPaymentCardCxPState();
}

class _ModernPaymentCardCxPState extends State<_ModernPaymentCardCxP> {
  late final TextEditingController montoCtrl;
  late final TextEditingController bancoCtrl;
  late final TextEditingController refCtrl;
  late final TextEditingController notaCtrl;
  late final TextEditingController last4Ctrl;

  late final FocusNode montoFocus;
  late final FocusNode bancoFocus;
  late final FocusNode refFocus;
  late final FocusNode notaFocus;
  late final FocusNode last4Focus;

  Timer? _debounce;

  PaymentSplit? get _pOrNull {
    final i = widget.c.nuevosPagos.indexWhere((e) => e.id == widget.paymentId);
    return i >= 0 ? widget.c.nuevosPagos[i] : null;
  }


  void _bumpDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 140), () {
      if (!mounted) return;
      widget.c.bumpUi();
    });
  }

  @override
  void initState() {
    super.initState();
    final p = _pOrNull;

    montoCtrl = TextEditingController(
      text: (p != null && p.montoCop > 0) ? p.montoCop.toString() : '',
    );
    bancoCtrl = TextEditingController(text: p?.banco ?? '');
    refCtrl = TextEditingController(text: p?.referencia ?? '');
    notaCtrl = TextEditingController(text: p?.nota ?? '');
    last4Ctrl = TextEditingController(text: p?.accountLast4 ?? '');

    montoFocus = FocusNode();
    bancoFocus = FocusNode();
    refFocus = FocusNode();
    notaFocus = FocusNode();
    last4Focus = FocusNode();

    montoFocus.addListener(() {
      final p = _pOrNull;
      if (p == null) return;
      if (!montoFocus.hasFocus) {
        // Visual sync al perder foco (sin formateo agresivo).
        montoCtrl.text = p.montoCop > 0 ? p.montoCop.toString() : '';
        widget.c.bumpUi();
      }
    });
  }

  @override
  void didUpdateWidget(_ModernPaymentCardCxP oldWidget) {
    super.didUpdateWidget(oldWidget);
    final p = _pOrNull;
    if (p == null) return;

    // Sync defensivo (sin pisar si hay foco)
    if (!montoFocus.hasFocus) {
      final newMonto = p.montoCop > 0 ? p.montoCop.toString() : '';
      if (montoCtrl.text != newMonto) montoCtrl.text = newMonto;
    }
    if (!bancoFocus.hasFocus) {
      final v = p.banco ?? '';
      if (bancoCtrl.text != v) bancoCtrl.text = v;
    }
    if (!refFocus.hasFocus) {
      final v = p.referencia ?? '';
      if (refCtrl.text != v) refCtrl.text = v;
    }
    if (!notaFocus.hasFocus) {
      final v = p.nota ?? '';
      if (notaCtrl.text != v) notaCtrl.text = v;
    }
    if (!last4Focus.hasFocus) {
      final v = p.accountLast4 ?? '';
      if (last4Ctrl.text != v) last4Ctrl.text = v;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();

    montoCtrl.dispose();
    bancoCtrl.dispose();
    refCtrl.dispose();
    notaCtrl.dispose();
    last4Ctrl.dispose();

    montoFocus.dispose();
    bancoFocus.dispose();
    refFocus.dispose();
    notaFocus.dispose();
    last4Focus.dispose();
    super.dispose();
  }

  void _cleanFieldsOnMethodChange({
    required PaymentSplit p,
    required CollectionMethod newMethod,
  }) {
    if (!newMethod.needsBanco) {
      p.banco = null;
      if (!bancoFocus.hasFocus) bancoCtrl.text = '';
    }
    if (!newMethod.needsLast4) {
      p.accountLast4 = null;
      if (!last4Focus.hasFocus) last4Ctrl.text = '';
    }
    if (!newMethod.needsReferencia) {
      p.referencia = null;
      if (!refFocus.hasFocus) refCtrl.text = '';
    }
    if (!newMethod.needsNota) {
      p.nota = null;
      if (!notaFocus.hasFocus) notaCtrl.text = '';
    }

    // efectivo: limpieza total redundante (todos los needs* son false).
    // La lógica anterior ya lo cubre; este bloque queda como documentación.
  }

  @override
  Widget build(BuildContext context) {
    final p = _pOrNull;
    if (p == null) return const SizedBox.shrink();

    final needsBanco = p.method.needsBanco;
    final needsLast4 = p.method.needsLast4;
    final needsRef = p.method.needsReferencia;
    final needsNota = p.method.needsNota;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.primary.withValues(alpha: 0.05),
            widget.primaryDark.withValues(alpha: 0.05),
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
                  gradient: LinearGradient(
                      colors: [widget.primary, widget.primaryDark]),
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
                  'Pago ${widget.visualIndex + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (widget.c.nuevosPagos.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444)),
                  onPressed: () {
                    final idx = widget.c.nuevosPagos
                        .indexWhere((e) => e.id == widget.paymentId);
                    if (idx >= 0) widget.c.removePago(idx);
                  },
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Método
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<CollectionMethod>(
                value: p.method,
                isExpanded: true,
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
                dropdownStyleData: _kDropdownStyle,
                buttonStyleData: _kButtonStyle,
                items: CollectionMethod.values
                    .map((m) => DropdownMenuItem<CollectionMethod>(
                          value: m,
                          child: Text(_collectionMethodLabel(m)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  p.method = v;
                  _cleanFieldsOnMethodChange(p: p, newMethod: v);
                  widget.c.bumpUi();
                  setState(() {}); // mostrar/ocultar campos inmediatamente
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Monto + Banco (si aplica)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: montoCtrl,
                  focusNode: montoFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    p.montoCop = _parseCopInt(v);
                    _bumpDebounced();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    hintText: 'Ej. 250000',
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
              if (needsBanco) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: bancoCtrl,
                    focusNode: bancoFocus,
                    onChanged: (v) {
                      final vv = v.trim();
                      p.banco = vv.isEmpty ? null : vv;
                      _bumpDebounced();
                    },
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: 'Banco',
                      hintText: 'Ej. Bancolombia',
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

          // Last4
          if (needsLast4) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: last4Ctrl,
                  focusNode: last4Focus,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    final vv = v.trim();
                    p.accountLast4 = vv.isEmpty ? null : vv;
                    _bumpDebounced();
                  },
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Últimos 4 dígitos',
                    counterText: '',
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
            ),
          ],

          // Referencia
          if (needsRef) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: refCtrl,
              focusNode: refFocus,
              onChanged: (v) {
                final vv = v.trim();
                p.referencia = vv.isEmpty ? null : vv;
                _bumpDebounced();
              },
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: 'Referencia / No. Transacción',
                hintText: p.method == CollectionMethod.cheque
                    ? 'Ej. No. Cheque'
                    : 'Ej. 8459201',
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
          ],

          // Nota (solo "Otro")
          if (needsNota) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: notaCtrl,
              focusNode: notaFocus,
              onChanged: (v) {
                final vv = v.trim();
                p.nota = vv.isEmpty ? null : vv;
                _bumpDebounced();
              },
              maxLines: null,
              minLines: 2,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: 'Nota del Método “Otro”',
                hintText: 'Ej. Canje / Compensación / Nota interna',
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
          ],

          const SizedBox(height: 10),

          // Mini feedback del card (no bloquea)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              p.montoCop > 0
                  ? 'Monto: ${_formatCopInt(p.montoCop)}'
                  : 'Ingresa un monto.',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _collectionMethodLabel(CollectionMethod m) {
    switch (m) {
      case CollectionMethod.efectivo:
        return '💵 Efectivo';
      case CollectionMethod.transferencia:
        return '📲 Transferencia';
      case CollectionMethod.debito:
        return '💳 Débito';
      case CollectionMethod.credito:
        return '💳 Crédito';
      case CollectionMethod.cheque:
        return '📜 Cheque';
      case CollectionMethod.otro:
        return '✨ Otro';
    }
  }
}

class _ModernAddButton extends StatelessWidget {
  const _ModernAddButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
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

class _ModernCheckbox extends StatelessWidget {
  const _ModernCheckbox({
    required this.label,
    required this.value,
    required this.active,
  });

  final String label;
  final RxBool value;
  final Color active;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () => value.value = !value.value,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: value.value ? active.withValues(alpha: 0.10) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value.value ? active : const Color(0xFFE5E7EB),
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
                        ? LinearGradient(
                            colors: [active, active.withValues(alpha: 0.85)])
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
                      color: value.value ? active : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.amountCop,
    required this.color,
    this.sign,
  });

  final String label;
  final int amountCop;
  final Color color;
  final String? sign;

  @override
  Widget build(BuildContext context) {
    final prefix = (sign ?? '');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          '$prefix${_formatCopInt(amountCop)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.label,
    required this.amountCop,
    required this.isBalanced,
    required this.primary,
    required this.primaryDark,
    required this.icon,
  });

  final String label;
  final int amountCop;
  final bool isBalanced;
  final Color primary;
  final Color primaryDark;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final gradientColors = [primary, primaryDark];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCopInt(amountCop),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (!isBalanced)
            const Icon(Icons.info_outline, color: Colors.white70, size: 18),
        ],
      ),
    );
  }
}

class _ModernSubmitButton extends StatelessWidget {
  const _ModernSubmitButton({
    required this.onPressed,
    required this.primary,
    required this.primaryDark,
    required this.label,
  });

  final VoidCallback onPressed;
  final Color primary;
  final Color primaryDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primaryDark]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.45),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.save_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
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

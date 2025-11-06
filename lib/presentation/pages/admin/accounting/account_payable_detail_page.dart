// lib/presentation/accounting/ap_detail_page.dart
// ============================================================================
// CUENTA POR PAGAR (CxP) — Vista de Detalle y Pago
// Enfocado en el registro de pagos (egresos) a una cuenta pendiente.
// ============================================================================

import 'package:avanzza/presentation/pages/admin/accounting/account_receivable_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ------------------------- Utilidades formato (Reutilizado) ------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

// ------------------------------- MODELOS REUTILIZADOS/ADAPTADOS --------------------------

// Reutilizamos el enum CollectionMethod (Modalidad de Pago Realizado)
// Se mantiene CollectionMethod para no duplicar el enum
enum CollectionMethod {
  efectivo,
  transferencia,
  debito,
  credito,
  cheque,
  otro
} //

// Renombramos CollectionSplit a PaymentSplit (Desglose de Pago)
class PaymentSplit {
  PaymentSplit({
    this.method = CollectionMethod.transferencia,
    this.monto = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.nota,
  });
  CollectionMethod method; //
  double monto; //
  String? banco; //
  String? accountLast4; //
  String? referencia; //
  String? nota; //
}

// NUEVO: Modelo para la Cuenta por Pagar
class AccountPayable {
  final String id;
  final String consecutivoOrigen; // ID del Egreso/Factura que la generó
  final DateTime fechaCreacion;
  final String proveedor;
  final double montoOriginal;
  final String concepto;
  final double montoPagadoInicial;
  // Estos serían los pagos ya realizados y registrados.
  final List<PaymentSplit> pagosAnteriores;

  AccountPayable({
    required this.id,
    required this.consecutivoOrigen,
    required this.fechaCreacion,
    required this.proveedor,
    required this.montoOriginal,
    required this.concepto,
    this.montoPagadoInicial = 0,
    this.pagosAnteriores = const [],
  });

  // Se mantiene la lógica del saldo
  double get saldoPendiente =>
      montoOriginal -
      montoPagadoInicial -
      pagosAnteriores.fold<double>(0, (s, p) => s + p.monto);
}

// ------------------------------ CONTROLLER ADAPTADO -----------------------------------
class APDetailController extends GetxController {
  // Simulación de carga de una CxP existente
  late final AccountPayable cxp;
  // Pagos que se están registrando en ESTA transacción (nuevos pagos)
  final nuevosPagos = <PaymentSplit>[PaymentSplit()].obs;
  final fechaPago = DateTime.now().obs;
  final notaPago = ''.obs;
  final marcarComoAjustada =
      false.obs; // Para ajustar la CxP (por ejemplo, descuento)

  APDetailController(String apId) {
    // Simular la carga de datos de la CxP
    cxp = AccountPayable(
      id: apId,
      consecutivoOrigen: 'EGR-2025-00005',
      fechaCreacion: DateTime(2025, 10, 5),
      proveedor: 'Suministros Industriales S.A.',
      montoOriginal: 8500000,
      montoPagadoInicial: 4000000,
      concepto: 'Compra de materia prima lote 3 (Factura #7890)',

      // Simulamos un pago anterior que ya se registró en el sistema
      pagosAnteriores: [
        PaymentSplit(
          monto: 1500000,
          method: CollectionMethod.transferencia,
          banco: 'Banco del Proveedor',
          referencia: 'Pago-54321',
        ),
      ],
    );
    // Añadimos el primer pago vacío para empezar
    updateSaldo();
  }

  // Cálculos
  double get totalPagadoAnterior =>
      cxp.montoPagadoInicial +
      cxp.pagosAnteriores.fold<double>(0, (s, p) => s + p.monto); //
  double get saldoInicial => cxp.montoOriginal - totalPagadoAnterior; //

  double get totalNuevosPagos => nuevosPagos.fold<double>(
      0, (s, p) => s + (p.monto.isFinite ? p.monto : 0)); //
  double get saldoPendienteDespuesDePagos =>
      (saldoInicial - totalNuevosPagos).clamp(0, double.infinity); //

  double get valorAjustado => (marcarComoAjustada.value)
      ? saldoInicial - totalNuevosPagos
      : 0; // Adaptado de 'valorCastigado'

  // Actualiza la UI de GetX
  void updateSaldo() => update(); //

  // Métodos para Pagos
  void addPago() {
    nuevosPagos.add(PaymentSplit());
    update(); //
  }

  void removePago(int index) {
    if (nuevosPagos.length > 1) nuevosPagos.removeAt(index);
    update();
  }

  String? validate() {
    // Adaptación de la validación
    if (totalNuevosPagos > saldoInicial && !marcarComoAjustada.value) {
      return 'El monto del pago excede el saldo pendiente. Ajuste el monto o marque como Ajuste/Descuento para registrar la diferencia.';
    } //
    if (totalNuevosPagos <= 0 &&
        !marcarComoAjustada.value &&
        saldoInicial > 0) {
      return 'Debe ingresar un monto de pago válido.'; //
    }
    for (final p in nuevosPagos) {
      if (p.monto > 0 &&
          (p.method == CollectionMethod.transferencia ||
              p.method == CollectionMethod.debito ||
              p.method == CollectionMethod.credito) &&
          (p.banco == null || p.banco!.trim().isEmpty)) {
        return 'Falta banco en un pago no en efectivo con monto > 0.'; //
      }
    }
    return null; //
  }

  Future<void> save() async {
    final error = validate(); //
    if (error != null) {
      //
      Get.snackbar(
        'Validación',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444), // Rojo
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return; //
    }
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar(
      '✓ Pago Registrado',
      'Se registraron ${_money.format(totalNuevosPagos)} a la CxP. Saldo pendiente: ${_money.format(saldoPendienteDespuesDePagos)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981), // Verde
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    ); //
  }
}

// --------------------------------- PAGE ADAPTADO --------------------------------------
class APDetailPage extends StatelessWidget {
  // El ID de la CxP que se va a pagar/gestionar
  final String apId;
  const APDetailPage({super.key, required this.apId}); //

  @override
  Widget build(BuildContext context) {
    // Usamos Get.put con el ID para crear una instancia específica por CxP
    final c = Get.put(APDetailController(apId), tag: apId, permanent: false); //
    // Color principal para las CxP (Morado Oscuro)
    const Color apColor = Color(0xFF7C3AED); // Morado
    const Color apColorDark = Color(0xFF4C1D95); // Morado más oscuro

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), //
      extendBodyBehindAppBar: true, //
      appBar: AppBar(
        title: const Text(
          'Cuentas x Pagar',
          // 'CxP #${c.cxp.id}', // Adaptado
          style: TextStyle(
            fontSize: 34, //
            fontWeight: FontWeight.w800, //
            color: Color(0xFF1A1A1A), //
            letterSpacing: -0.5, //
          ),
        ),
        elevation: 0, //
        backgroundColor: Colors.transparent, //
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
        // ... (Leading Button, se mantiene igual)
      ),
      body: Stack(
        children: [
          // Fondo gradiente (color de CxP)
          Container(
            height: 250, //
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, //
                end: Alignment.bottomRight, //
                colors: [
                  apColor.withOpacity(0.1), // Morado tenue
                  apColorDark.withOpacity(0.1), // Morado más oscuro
                ],
              ),
            ),
          ),
          // Contenido
          SafeArea(
            child: Column(
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          c.cxp.proveedor,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Acreedor',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18), //
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 120), //
                    children: [
                      // 1. Resumen de la Cuenta por Pagar
                      ModernSection(
                        title: 'ℹ️ Resumen', // Adaptado
                        headerExtra: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6), //
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [apColor, apColorDark], // Morado
                            ), //
                            borderRadius: BorderRadius.circular(12), //
                            boxShadow: [
                              BoxShadow(
                                color: apColor.withOpacity(0.3), //
                                blurRadius: 15, //
                                offset: const Offset(0, 5), //
                              ),
                            ],
                          ),
                          child: Text(
                            'SALDO: ${_money.format(c.saldoInicial)}', // Saldo a pagar
                            style: const TextStyle(
                              color: Colors.white, //
                              fontWeight: FontWeight.w700, //
                              fontSize: 14, //
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SummaryRow(
                                label: 'Proveedor',
                                value: c.cxp.proveedor,
                                icon: Icons.store_outlined,
                                color: apColor), // Adaptado
                            const SizedBox(height: 8), //
                            SummaryRow(
                                label: 'Origen (Egreso)',
                                value: c.cxp.consecutivoOrigen,
                                icon: Icons.receipt_long_outlined,
                                color: apColor), // Adaptado
                            const SizedBox(height: 8), //
                            SummaryRow(
                                label: 'Fecha CxP',
                                value: DateFormat('dd/MM/yyyy')
                                    .format(c.cxp.fechaCreacion),
                                icon: Icons.calendar_today_outlined,
                                color: apColor), //
                            const SizedBox(height: 8), //
                            SummaryRow(
                                label: 'Monto Original',
                                value: _money.format(c.cxp.montoOriginal),
                                icon: Icons.attach_money_outlined,
                                color: apColor), //
                            const SizedBox(height: 8), //
                            SummaryRow(
                                label: 'Monto Pagado Anterior',
                                value: _money.format(c.totalPagadoAnterior),
                                icon: Icons.check_circle_outline,
                                color: apColor), // Adaptado
                            const SizedBox(height: 8), //
                            Text(
                              'Concepto: ${c.cxp.concepto}', //
                              style: const TextStyle(
                                fontSize: 13, //
                                color: Color(0xFF6B7280), //
                                fontStyle: FontStyle.italic, //
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), //

                      // 2. Registro de Nuevos Pagos
                      ModernSection(
                        title: '💳 Realizar Pago', // Adaptado
                        trailing: Obx(() {
                          final touch = c.nuevosPagos.length; //
                          return Container(
                            alignment: Alignment.centerLeft, //
                            height: 50, //
                            width: MediaQuery.of(context).size.width * 0.4, //
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14), //
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [apColor, apColorDark], // Morado
                              ), //
                              borderRadius: BorderRadius.circular(12), //
                              boxShadow: [
                                BoxShadow(
                                  color: apColor.withOpacity(0.3), //
                                  blurRadius: 15, //
                                  offset: const Offset(0, 5), //
                                ),
                              ],
                            ),
                            child: Text(
                              _money.format(c.totalNuevosPagos), //
                              style: const TextStyle(
                                color: Colors.white, //
                                fontWeight: FontWeight.w700, //
                                fontSize: 18, //
                              ),
                            ),
                          );
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ModernFechaPagoField(
                                c: c, color: apColor), // Adaptado
                            const SizedBox(height: 16), //
                            const Text(
                                'Detalle de los Pagos Realizados Ahora:'), // Adaptado
                            const SizedBox(height: 12), //
                            Obx(() {
                              final touch = c.nuevosPagos.length; //
                              return Column(
                                children: [
                                  for (int i = 0; i < c.nuevosPagos.length; i++)
                                    _ModernPagoCardCxP(
                                        index: i,
                                        c: c,
                                        color: apColor), // Adaptado
                                ],
                              );
                            }),
                            const SizedBox(height: 12), //
                            ModernAddButton(
                              label: 'Agregar Método de Pago', // Adaptado
                              icon: Icons.account_balance_wallet_outlined, //
                              onPressed: c.addPago, // Adaptado
                              // color: apColor, //
                            ),
                            const SizedBox(height: 16), //
                            ModernTextField(
                              label: 'Notas del Pago (Opcional)', // Adaptado
                              hint:
                                  'Ej. Pago final con descuento aplicado.', // Adaptado
                              value: c.notaPago, // Adaptado
                              icon: Icons.note_alt_outlined, //
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), //

                      // 3. Balance y Opción de Ajuste
                      ModernSection(
                        title: '⚖️ Balance', //
                        child: Obx(() {
                          final saldoFinal = c.saldoPendienteDespuesDePagos; //
                          final ajustado = c.valorAjustado; // Adaptado
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //
                            children: [
                              BalanceSummaryRow(
                                  label: 'Saldo Inicial Pendiente', //
                                  amount: c.saldoInicial, //
                                  color: const Color(0xFF4B5563) // Gris
                                  ),
                              const SizedBox(height: 8), //
                              BalanceSummaryRow(
                                  label: 'Total Pagado Ahora', // Adaptado
                                  amount: c.totalNuevosPagos, //
                                  color: apColor, // Morado
                                  sign: '-' //
                                  ),
                              const SizedBox(height: 16), //
                              if (ajustado > 0.01) // Adaptado
                                BalanceSummaryRow(
                                    label:
                                        'Valor Ajustado/Descuento', // Adaptado
                                    amount: ajustado, // Adaptado
                                    color: const Color(
                                        0xFF10B981) // Verde para beneficio
                                    ),
                              if (ajustado > 0.01)
                                const SizedBox(height: 16), // Adaptado
                              BalanceCard(
                                label: saldoFinal > 0.01
                                    ? 'Saldo Final Pendiente'
                                    : '✓ CxP Cerrada/Totalmente Pagada', // Adaptado
                                amount: saldoFinal, //
                                isBalanced: saldoFinal <= 0.01, //
                                // isRevenue: false, //
                                // color: saldoFinal > 0.01 ?
                                //  const Color(0xFFEF4444) : apColor, // Rojo si sigue pendiente, Morado si está pagada
                              ),
                              const SizedBox(height: 12), //
                              if (saldoFinal > 0.01 ||
                                  ajustado > 0.01) // Adaptado
                                ModernCheckbox(
                                  label:
                                      'Marcar diferencia como Ajuste/Descuento', // Adaptado
                                  value: c.marcarComoAjustada, // Adaptado
                                  // activeColor: const Color(0xFF10B981), // Verde para ajuste
                                ),
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
          // Botón de Guardar
          Positioned(
            bottom: 24, //
            left: 24, //
            right: 24, //
            child: ModernSubmitButton(
              onPressed: c.save, //
              //  color: apColor, // Morado para CxP
              //  label: 'Registrar Pago', // Adaptado
            ),
          ),
        ],
      ),
    );
  }
}

// ========================= WIDGETS AUXILIARES ADAPTADOS/NUEVOS =======================

// ADAPTACIÓN del campo de fecha para el Pago
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
          'Fecha del Pago', // Adaptado
          style: TextStyle(
            fontSize: 13, //
            fontWeight: FontWeight.w600, //
            color: Color(0xFF374151), //
          ),
        ),
        const SizedBox(height: 8), //
        GestureDetector(
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
            child: Obx(() => Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.black54, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd/MM/yyyy').format(c.fechaPago.value),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

// ADAPTACIÓN del Card para cada Pago Individual (asumiendo _ModernRecaudoCardCxC)
class _ModernPagoCardCxP extends StatelessWidget {
  const _ModernPagoCardCxP(
      {required this.index, required this.c, required this.color});
  final int index;
  final APDetailController c;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Lógica similar a _ModernRecaudoCardCxC pero para Pago
    final pago = c.nuevosPagos[index];
    // ... (El código completo de la tarjeta sería largo, se muestra la adaptación clave)

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo de Monto
          ModernTextField(
            label: 'Monto del Pago #${index + 1}', // Adaptado
            hint: '0',
            keyboardType: TextInputType.number,
            icon: Icons.money_outlined,
            initialValue: pago.monto > 0 ? pago.monto.toString() : null,
            value: (pago.monto.toString() ?? "").obs,
            // onChanged: (val) {
            //   pago.monto = double.tryParse(val) ?? 0;
            //   c.updateSaldo();
            // },
            // color: color,
          ),
          const SizedBox(height: 12),
          // Campo de Método de Pago (Dropdown)
          // Se asume un widget de Dropdown adaptado (similar a la vista original)
          // ... Dropdown para CollectionMethod ...

          if (pago.monto > 0 &&
              (pago.method == CollectionMethod.transferencia ||
                  pago.method == CollectionMethod.debito ||
                  pago.method == CollectionMethod.credito))
            const Column(
              children: [
                SizedBox(height: 12),
                // ModernTextField(
                //   label: 'Banco (Desde donde se paga)', // Adaptado
                //   hint: 'Ej. Banco Agrario',
                //   icon: Icons.account_balance,
                //   initialValue: pago.banco,
                //   // onChanged: (val) => pago.banco = val,
                //   // color: color,
                // ),
              ],
            ),

          // Botón de eliminar
          if (c.nuevosPagos.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => c.removePago(index),
                icon: Icon(Icons.delete, color: Colors.red[400], size: 18),
                label: Text('Eliminar Pago',
                    style: TextStyle(color: Colors.red[400])),
              ),
            ),
        ],
      ),
    );
  }
}

// ========================= WIDGETS AUXILIARES =======================

// ModernSection Widget
class ModernSection extends StatelessWidget {
  const ModernSection({
    super.key,
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
      margin: const EdgeInsets.only(bottom: 16),
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

// ModernAddButton Widget
class ModernAddButton extends StatelessWidget {
  const ModernAddButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF7C3AED), // Morado por defecto para CxP
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
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
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BalanceCard Widget
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.label,
    required this.amount,
    required this.isBalanced,
    this.color,
  });

  final String label;
  final double amount;
  final bool isBalanced;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const defaultColor = Color(0xFF7C3AED); // Morado para CxP

    final gradient = isBalanced
        ? [defaultColor, defaultColor.withOpacity(0.8)]
        : [color ?? defaultColor, (color ?? defaultColor).withOpacity(0.8)];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (color ?? defaultColor).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            _money.format(amount),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ModernCheckbox Widget
class ModernCheckbox extends StatelessWidget {
  const ModernCheckbox({
    super.key,
    required this.label,
    required this.value,
    this.activeColor,
  });

  final String label;
  final RxBool value;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value.value,
                onChanged: (v) => value.value = v ?? false,
                activeColor: activeColor ?? const Color(0xFF7C3AED), // Morado
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ));
  }
}

// ModernSubmitButton Widget
class ModernSubmitButton extends StatelessWidget {
  const ModernSubmitButton({
    super.key,
    required this.onPressed,
    this.color = const Color(0xFF7C3AED), // Morado por defecto para CxP
    this.label = 'Registrar Pago',
  });

  final VoidCallback onPressed;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

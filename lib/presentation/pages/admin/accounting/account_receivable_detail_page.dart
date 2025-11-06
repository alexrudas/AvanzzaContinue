// lib/presentation/accounting/ar_detail_page.dart
// ============================================================================
// CUENTA POR COBRAR (CxC) — Vista de Detalle y Recaudo
// Enfocado en el registro de pagos (recaudos) a una cuenta pendiente.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para TextInputFormatter
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

// ------------------------------- MODELOS REUTILIZADOS --------------------------

// Reutilizamos el enum CollectionMethod (Modalidad de Pago Recibido)
enum CollectionMethod { efectivo, transferencia, debito, credito, cheque, otro }

// Reutilizamos el modelo CollectionSplit (Desglose de Recaudo)
class CollectionSplit {
  CollectionSplit({
    this.method = CollectionMethod.transferencia,
    this.monto = 0,
    this.banco,
    this.accountLast4,
    this.referencia,
    this.nota,
  });
  CollectionMethod method;
  double monto;
  String? banco;
  String? accountLast4;
  String? referencia;
  String? nota;
}

// NUEVO: Modelo para la Cuenta por Cobrar (simulado para el ejemplo)
class AccountReceivable {
  final String id;
  final String consecutivoOrigen; // ID del Ingreso que la generó
  final DateTime fechaCreacion;
  final String cliente;
  final double montoOriginal;
  final String concepto;
  final double montoPagadoInicial;
  // Estos serían los pagos ya recibidos y registrados.
  final List<CollectionSplit> pagosAnteriores;

  AccountReceivable({
    required this.id,
    required this.consecutivoOrigen,
    required this.fechaCreacion,
    required this.cliente,
    required this.montoOriginal,
    required this.concepto,
    this.montoPagadoInicial = 0,
    this.pagosAnteriores = const [],
  });

  double get saldoPendiente =>
      montoOriginal -
      montoPagadoInicial -
      pagosAnteriores.fold<double>(0, (s, p) => s + p.monto);
}

// ------------------------------ CONTROLLER -----------------------------------
// NUEVO: Nombre del Controller
class ARDetailController extends GetxController {
  // Simulación de carga de una CxC existente
  late final AccountReceivable cxc;

  // Pagos que se están registrando en ESTA transacción (nuevos recaudos)
  final nuevosRecaudos = <CollectionSplit>[CollectionSplit()].obs;
  final fechaRecaudo = DateTime.now().obs;
  final notaRecaudo = ''.obs;
  final marcarComoCastigada = false.obs; // Para condonar o ajustar la CxC

  ARDetailController(String arId) {
    // Simular la carga de datos de la CxC
    cxc = AccountReceivable(
      id: arId,
      consecutivoOrigen: 'ING-2025-00001',
      fechaCreacion: DateTime(2025, 10, 1),
      cliente: 'Constructora XZY S.A.S.',
      montoOriginal: 5000000,
      montoPagadoInicial: 3000000,
      concepto: 'Arriendo de Grúa XJ-40 por 2 semanas (Factura #1002)',
      // Simulamos un pago anterior que ya se registró en el sistema
      pagosAnteriores: [
        CollectionSplit(
          monto: 1000000,
          method: CollectionMethod.transferencia,
          banco: 'Bancolombia',
          referencia: 'Trans-12345',
        ),
      ],
    );
    // Añadimos el primer recaudo vacío para empezar
    updateSaldo();
  }

  // Cálculos
  double get totalPagadoAnterior =>
      cxc.montoPagadoInicial +
      cxc.pagosAnteriores.fold<double>(0, (s, p) => s + p.monto);

  double get saldoInicial => cxc.montoOriginal - totalPagadoAnterior;

  double get totalNuevosRecaudos => nuevosRecaudos.fold<double>(
      0, (s, p) => s + (p.monto.isFinite ? p.monto : 0));

  double get saldoPendienteDespuesDeRecaudos =>
      (saldoInicial - totalNuevosRecaudos).clamp(0, double.infinity);

  double get valorCastigado =>
      (marcarComoCastigada.value) ? saldoInicial - totalNuevosRecaudos : 0;

  // Actualiza la UI de GetX
  void updateSaldo() => update();

  // Métodos para Recaudos
  void addRecaudo() {
    nuevosRecaudos.add(CollectionSplit());
    update();
  }

  void removeRecaudo(int index) {
    if (nuevosRecaudos.length > 1) nuevosRecaudos.removeAt(index);
    update();
  }

  String? validate() {
    if (totalNuevosRecaudos > saldoInicial && !marcarComoCastigada.value) {
      return 'El monto de recaudo excede el saldo pendiente. Ajuste el monto o marque como castigo para registrar un ajuste.';
    }
    if (totalNuevosRecaudos <= 0 && !marcarComoCastigada.value) {
      return 'Debe ingresar un monto de recaudo válido.';
    }
    for (final p in nuevosRecaudos) {
      if (p.monto > 0 &&
          (p.method == CollectionMethod.transferencia ||
              p.method == CollectionMethod.debito ||
              p.method == CollectionMethod.credito) &&
          (p.banco == null || p.banco!.trim().isEmpty)) {
        return 'Falta banco en un recaudo no en efectivo con monto > 0.';
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
        backgroundColor: const Color(0xFFEF4444), // Rojo
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar(
      '✓ Recaudo Registrado',
      'Se registraron ${_money.format(totalNuevosRecaudos)} a la CxC. Saldo pendiente: ${_money.format(saldoPendienteDespuesDeRecaudos)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981), // Verde
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}

// --------------------------------- PAGE --------------------------------------
// NUEVO: Nombre de la Clase
class ARDetailPage extends StatelessWidget {
  // El ID de la CxC que se va a pagar/gestionar
  final String arId;
  const ARDetailPage({super.key, required this.arId});

  @override
  Widget build(BuildContext context) {
    // Usamos Get.put con el ID para crear una instancia específica por CxC
    final c = Get.put(ARDetailController(arId), tag: arId, permanent: false);

    // Color principal para las CxC, usamos un azul corporativo
    const Color arColor = Color(0xFF3B82F6); // Azul

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Cuentas x Cobrar',
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
          // Fondo gradiente (color de CxC)
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  arColor.withOpacity(0.1), // Azul tenue
                  const Color(0xFF1D4ED8).withOpacity(0.1), // Azul más oscuro
                ],
              ),
            ),
          ),
          // Contenido
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Deudor:',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Alexander Rudas #${c.cxc.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'CxC#  ${c.cxc.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Detalle y Registro',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                    children: [
                      // 1. Resumen de la Cuenta por Cobrar
                      _ModernSection(
                        title: 'ℹ️ Resumen',
                        headerExtra: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [arColor, Color(0xFF1D4ED8)], // Azul
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: arColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            'SALDO: ${_money.format(c.saldoInicial)}', // Saldo a pagar
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
                            SummaryRow(
                                label: 'Cliente',
                                value: c.cxc.cliente,
                                icon: Icons.person_outlined,
                                color: arColor),
                            const SizedBox(height: 8),
                            SummaryRow(
                                label: 'Origen (Ingreso)',
                                value: c.cxc.consecutivoOrigen,
                                icon: Icons.receipt_long_outlined,
                                color: arColor),
                            const SizedBox(height: 8),
                            SummaryRow(
                                label: 'Fecha CxC',
                                value: DateFormat('dd/MM/yyyy')
                                    .format(c.cxc.fechaCreacion),
                                icon: Icons.calendar_today_outlined,
                                color: arColor),
                            const SizedBox(height: 8),
                            SummaryRow(
                                label: 'Monto Original',
                                value: _money.format(c.cxc.montoOriginal),
                                icon: Icons.attach_money_outlined,
                                color: arColor),
                            const SizedBox(height: 8),
                            SummaryRow(
                                label: 'Monto Recaudado Anterior',
                                value: _money.format(c.totalPagadoAnterior),
                                icon: Icons.check_circle_outline,
                                color: arColor),
                            const SizedBox(height: 8),
                            Text(
                              'Concepto: ${c.cxc.concepto}',
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

                      // 2. Registro de Nuevos Recaudos
                      _ModernSection(
                        title: '💸 Recaudar Pago',
                        trailing: Obx(() {
                          final touch = c.nuevosRecaudos.length;
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [arColor, Color(0xFF1D4ED8)], // Azul
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: arColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              _money.format(c.totalNuevosRecaudos),
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
                            _ModernFechaRecaudoField(c: c, color: arColor),
                            const SizedBox(height: 16),
                            const Text('Detalle de los Pagos Recibidos Ahora:'),
                            const SizedBox(height: 12),
                            Obx(() {
                              final touch = c.nuevosRecaudos.length;
                              return Column(
                                children: [
                                  for (int i = 0;
                                      i < c.nuevosRecaudos.length;
                                      i++)
                                    _ModernRecaudoCardCxC(
                                        index: i, c: c, color: arColor),
                                ],
                              );
                            }),
                            const SizedBox(height: 12),
                            _ModernAddButton(
                              label: 'Agregar Método de Pago',
                              icon: Icons.account_balance_wallet_outlined,
                              onPressed: c.addRecaudo,
                              color: arColor,
                            ),
                            const SizedBox(height: 16),
                            ModernTextField(
                              label: 'Notas del Recaudo (Opcional)',
                              hint: 'Ej. Pago final de saldo pendiente.',
                              value: c.notaRecaudo,
                              icon: Icons.note_alt_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Balance y Opción de Castigo
                      _ModernSection(
                        title: '⚖️ Balance',
                        child: Obx(() {
                          final saldoFinal = c.saldoPendienteDespuesDeRecaudos;
                          final castigado = c.valorCastigado;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BalanceSummaryRow(
                                  label: 'Saldo Inicial Pendiente',
                                  amount: c.saldoInicial,
                                  color: const Color(0xFF4B5563) // Gris
                                  ),
                              const SizedBox(height: 8),
                              BalanceSummaryRow(
                                  label: 'Total Recaudado Ahora',
                                  amount: c.totalNuevosRecaudos,
                                  color: arColor,
                                  sign: '-'),
                              const SizedBox(height: 16),
                              if (castigado > 0.01)
                                BalanceSummaryRow(
                                    label: 'Valor Castigado/Ajustado',
                                    amount: castigado,
                                    color: const Color(
                                        0xFFEF4444) // Rojo para pérdida
                                    ),
                              if (castigado > 0.01) const SizedBox(height: 16),
                              _BalanceCard(
                                label: saldoFinal > 0.01
                                    ? 'Saldo Final Pendiente'
                                    : '✓ CxC Cerrada/Totalmente Pagada',
                                amount: saldoFinal,
                                isBalanced: saldoFinal <= 0.01,
                                isRevenue: false, // Color principal de CxC
                                color: saldoFinal > 0.01
                                    ? const Color(0xFFFBBF24)
                                    : arColor, // Amarillo/Naranja si sigue pendiente
                              ),
                              const SizedBox(height: 12),
                              if (saldoFinal > 0.01 || castigado > 0.01)
                                _ModernCheckbox(
                                  label:
                                      'Marcar diferencia como Castigo/Ajuste',
                                  value: c.marcarComoCastigada,
                                  activeColor: const Color(0xFFEF4444),
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
            bottom: 24,
            left: 24,
            right: 24,
            child: _ModernSubmitButton(
              onPressed: c.save,
              color: arColor, // Azul para CxC
              label: 'Registrar Recaudo',
            ),
          ),
        ],
      ),
    );
  }
}

// ========================= WIDGETS AUXILIARES ADAPTADOS/NUEVOS =======================

// Adaptación de _ModernSection
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
    // Código de _ModernSection del formulario de gastos (se mantiene igual)
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

// Reutilizamos _ModernTextField
class ModernTextField extends StatelessWidget {
  const ModernTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    this.keyboardType,
    this.initialValue,
  });

  final String label;
  final String hint;
  final RxString value;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    // Código de _ModernTextField del formulario de gastos (se mantiene igual)
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
                  initialValue: initialValue ?? value.value,
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

// Adaptación del campo de fecha para el Recaudo
class _ModernFechaRecaudoField extends StatelessWidget {
  const _ModernFechaRecaudoField({required this.c, required this.color});
  final ARDetailController c;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha del Recaudo',
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
                  initialDate: c.fechaRecaudo.value,
                  firstDate: c.cxc.fechaCreacion,
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: color, // Color de CxC (Azul)
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) c.fechaRecaudo.value = picked;
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
                      DateFormat('dd/MM/yyyy').format(c.fechaRecaudo.value),
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

// NUEVO: Fila de resumen para mostrar datos estáticos de la CxC
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// NUEVO: Fila de resumen para el balance
class BalanceSummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String sign;

  const BalanceSummaryRow({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    this.sign = '+',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4B5563),
          ),
        ),
        const Spacer(),
        Text(
          '($sign) ${_money.format(amount)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Adaptación de _ModernRecaudoCard para CxC
class _ModernRecaudoCardCxC extends StatelessWidget {
  const _ModernRecaudoCardCxC({
    required this.index,
    required this.c,
    required this.color,
  });

  final int index;
  final ARDetailController c;
  final Color color;

  // Mapa para etiquetas y colores de CollectionMethod
  static String _methodLabel(CollectionMethod m) {
    switch (m) {
      case CollectionMethod.efectivo:
        return '💵 Efectivo';
      case CollectionMethod.transferencia:
        return '🏦 Transferencia';
      case CollectionMethod.debito:
        return '💳 Débito';
      case CollectionMethod.credito:
        return '💳 Crédito';
      case CollectionMethod.cheque:
        return '✍️ Cheque';
      case CollectionMethod.otro:
        return '💡 Otro';
    }
  }

  // Widget de Entrada de Monto (reutilizado de la versión de Ingreso)
  Widget _MontoField(CollectionSplit item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monto Recaudo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextFormField(
            initialValue: item.monto > 0 ? item.monto.toString() : '',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _money.currencySymbol,
              hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
            ),
            onChanged: (v) {
              item.monto = double.tryParse(v) ?? 0.0;
              c.updateSaldo();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = c.nuevosRecaudos[index];
    final showExtraFields = item.method != CollectionMethod.efectivo &&
        item.method != CollectionMethod.otro;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pago #${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (c.nuevosRecaudos.length > 1)
                IconButton(
                  icon: const Icon(Icons.close,
                      color: Color(0xFFEF4444), size: 20),
                  onPressed: () => c.removeRecaudo(index),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Selector de Método de Recaudo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Método',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CollectionMethod>(
                    value: item.method,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFF9CA3AF)),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                    items: CollectionMethod.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(_methodLabel(t)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        item.method = v;
                        c.updateSaldo(); // Trigger rebuild to show/hide fields
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Campo de Monto
          _MontoField(item),

          if (showExtraFields) ...[
            const SizedBox(height: 16),
            ModernTextField(
              label: 'Banco',
              hint: 'Ej. Bancolombia / Davivienda',
              value: (item.banco ?? "").obs,
              icon: Icons.account_balance_outlined,
              initialValue: item.banco,
            ),
            const SizedBox(height: 16),
            ModernTextField(
              label: 'Referencia/Número de Cheque (Opcional)',
              hint: 'Ej. Trans-5678 / Cheque #123',
              value: (item.referencia ?? "").obs,
              icon: Icons.local_activity_outlined,
              initialValue: item.referencia,
            ),
          ],
        ],
      ),
    );
  }
}

// Reutilizamos _ModernAddButton
class _ModernAddButton extends StatelessWidget {
  const _ModernAddButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF3B82F6), // Por defecto Azul para CxC
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

// Adaptación de _BalanceCard
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.label,
    required this.amount,
    required this.isBalanced,
    this.isRevenue = false,
    this.color,
  });

  final String label;
  final double amount;
  final bool isBalanced;
  final bool isRevenue;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final defaultColor = isRevenue
        ? const Color(0xFF10B981)
        : const Color(0xFF3B82F6); // Azul para CxC

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

// Reutilizamos _ModernCheckbox
class _ModernCheckbox extends StatelessWidget {
  const _ModernCheckbox({
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
                activeColor: activeColor ??
                    const Color(0xFF3B82F6), // Color de CxC (Azul)
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

// Reutilizamos _ModernSubmitButton
class _ModernSubmitButton extends StatelessWidget {
  const _ModernSubmitButton({
    required this.onPressed,
    required this.color,
    this.label = 'Guardar',
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

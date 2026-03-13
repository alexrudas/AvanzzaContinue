// ============================================================================
// lib/presentation/pages/admin/accounting/account_receivable_detail_page.dart
// CUENTA POR COBRAR (CxC) — Detalle y Recaudo — Enterprise Ultra Pro
//
// QUÉ HACE:
// - Vista de detalle y registro de pagos (recaudos) a una CxC pendiente.
// - Usa ReactiveTextField para campos RxString (notas del recaudo).
// - Cards de recaudo como StatefulWidget con FocusNode + TextEditingController.
// - Consume CollectionMethodPolicyX del dominio (needs*) — política canónica.
// - save() emite AccountingEvent(s) determinísticos al Event Store (P2-B):
//     ar_collection_recorded  → siempre
//     ar_adjustment_applied   → solo si marcarComoAjustada y diferencia > 0
// - P2-C: Sección "Historial" con timeline audit-grade (AccountingTimelineController).
//     Carga eventos en initState(); refresca tras save() exitoso.
//
// QUÉ NO HACE:
// - NO duplica reglas de negocio: validate() es guardrail UI, no autoridad final.
// - NO duplica reglas de política (importa desde domain/value/accounting).
// - NO usa double para montos (siempre int COP).
//
// NOTAS (CONTRATO UI):
// - uuid.v4() para IDs estables en CollectionSplit.
// - Cards dinámicas como StatefulWidget con FocusNode lifecycle completo.
// - Montos en int COP (sin coma flotante). _parseCopInt / _formatCopInt.
// - Debounce 140 ms en onChanged de monto → bumpUi() en lugar de refresh().
// - marcarComoAjustada (RxBool) reemplaza "Castigo" por "Ajuste/Descuento".
// - initState() usa fallback seguro (sin operador !).
// - Al cambiar método, _cleanFieldsOnMethodChange limpia modelo + controllers.
// ============================================================================

import 'dart:async';

import 'package:avanzza/domain/value/accounting/collection_method.dart';
import 'package:avanzza/presentation/widgets/forms/reactive_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:avanzza/domain/entities/accounting/accounting_event.dart';
import 'package:avanzza/infrastructure/isar/repositories/isar_accounting_event_repository.dart';
import 'package:avanzza/presentation/controllers/admin/accounting/accounting_timeline_controller.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ------------------------- Utilidades formato --------------------------------
final _money =
    NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0);

int _parseCopInt(String input) {
  final digits = input.replaceAll(RegExp(r'[^\d]'), '');
  return digits.isEmpty ? 0 : (int.tryParse(digits) ?? 0);
}

String _formatCopInt(int amount) => _money.format(amount);

// Dropdown styling reutilizable
final _kDropdownStyle = DropdownStyleData(
  decoration: BoxDecoration(
    color: const Color(0xFFF3F4F6),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFE5E7EB)),
  ),
);
const _kButtonStyle = ButtonStyleData(padding: EdgeInsets.zero);

// ------------------------------- MODELOS ------------------------------------

// Desglose de Recaudo con ID estable (uuid v4)
class CollectionSplit {
  CollectionSplit({
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
  int montoCop;
  String? banco;
  String? accountLast4;
  String? referencia;
  String? nota;
}

// Modelo para la Cuenta por Cobrar (simulado)
class AccountReceivable {
  final String id;
  final String consecutivoOrigen;
  final DateTime fechaCreacion;
  final String cliente;
  final int montoOriginalCop;
  final String concepto;
  final int montoPagadoCop;
  final List<CollectionSplit> pagosAnteriores;

  AccountReceivable({
    required this.id,
    required this.consecutivoOrigen,
    required this.fechaCreacion,
    required this.cliente,
    required this.montoOriginalCop,
    required this.concepto,
    this.montoPagadoCop = 0,
    this.pagosAnteriores = const [],
  });

  int get saldoPendiente =>
      montoOriginalCop -
      montoPagadoCop -
      pagosAnteriores.fold<int>(0, (s, p) => s + p.montoCop);
}

// ------------------------------ CONTROLLER ----------------------------------

class ARDetailController extends GetxController {
  late final AccountReceivable cxc;

  final nuevosRecaudos = <CollectionSplit>[CollectionSplit()].obs;
  final fechaRecaudo = DateTime.now().obs;
  final notaRecaudo = ''.obs;
  final marcarComoAjustada = false.obs;

  final _uiTick = 0.obs;
  void bumpUi() => _uiTick.value++;

  ARDetailController(String arId) {
    cxc = AccountReceivable(
      id: arId,
      consecutivoOrigen: 'ING-2025-00001',
      fechaCreacion: DateTime(2025, 10, 1),
      cliente: 'Constructora XZY S.A.S.',
      montoOriginalCop: 5000000,
      montoPagadoCop: 3000000,
      concepto: 'Arriendo de Grúa XJ-40 por 2 semanas (Factura #1002)',
      pagosAnteriores: [
        CollectionSplit(
          montoCop: 1000000,
          method: CollectionMethod.transferencia,
          banco: 'Bancolombia',
          referencia: 'Trans-12345',
        ),
      ],
    );
  }

  // Cálculos (int COP — determinísticos, sin coma flotante)
  int get totalPagadoAnteriorCop =>
      cxc.montoPagadoCop +
      cxc.pagosAnteriores.fold<int>(0, (s, p) => s + p.montoCop);

  int get saldoInicialCop => cxc.montoOriginalCop - totalPagadoAnteriorCop;

  int get totalNuevosRecaudosCop {
    _uiTick.value; // registra dependencia reactiva → bumpUi() dispara rebuild
    return nuevosRecaudos.fold<int>(0, (s, p) => s + p.montoCop);
  }

  /// diferenciaCop = saldo − recaudos actuales (negativo = sobrepago).
  int get diferenciaCop => saldoInicialCop - totalNuevosRecaudosCop;

  int get valorAjusteCop => marcarComoAjustada.value ? diferenciaCop : 0;

  // Métodos para Recaudos — sin update()
  void addRecaudo() => nuevosRecaudos.add(CollectionSplit());

  void removeRecaudo(int index) {
    if (nuevosRecaudos.length > 1) nuevosRecaudos.removeAt(index);
  }

  // Validación canónica §8 — orden obligatorio, comparaciones exactas int COP
  String? validate() {
    // §8-1
    if (saldoInicialCop <= 0) return 'Esta cuenta ya no tiene saldo pendiente.';
    // §8-2
    if (totalNuevosRecaudosCop <= 0 && !marcarComoAjustada.value) {
      return 'Debe ingresar un monto válido.';
    }
    // §8-3 — sobrepago bloqueado SIEMPRE, independiente del ajuste
    if (totalNuevosRecaudosCop > saldoInicialCop) {
      return 'El monto excede el saldo pendiente. Ajusta los montos.';
    }
    // §8-7 anticipado: coherencia antes de evaluar §8-4
    if (diferenciaCop == 0 && marcarComoAjustada.value) {
      marcarComoAjustada.value = false;
    }
    // §8-4
    if (marcarComoAjustada.value && valorAjusteCop <= 0) {
      return 'No hay diferencia para ajustar. Desmarca "Ajuste/Descuento".';
    }
    // §8-5
    for (final p in nuevosRecaudos) {
      if (p.montoCop <= 0) continue;
      if (p.method.needsBanco && (p.banco == null || p.banco!.trim().isEmpty)) {
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
        return 'Falta nota justificativa en el método "Otro".';
      }
    }
    // §8-6
    if (fechaRecaudo.value.isBefore(cxc.fechaCreacion)) {
      return 'La fecha de transacción no puede ser anterior a la creación de la cuenta.';
    }
    return null;
  }

  // IMPORTANTE:
  // validate() actúa como guardrail UI.
  // La fuente de verdad es el Event Store.
  // El backend debe validar nuevamente reglas críticas
  // al recibir estos eventos (defensa en profundidad).
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

    // ── Cálculos determinísticos (int COP — sin coma flotante) ───────────────
    final totalIngresado = totalNuevosRecaudosCop;
    final diferencia = diferenciaCop; // saldoInicial - totalIngresado
    // saldoFinal: saldo definitivo tras todos los eventos (display + snackbar).
    final saldoFinal = marcarComoAjustada.value ? 0 : diferencia;
    final ajusteCop = marcarComoAjustada.value ? diferencia : 0;

    try {
      // ── Resolver repositorio ─────────────────────────────────────────────
      if (!Get.isRegistered<IsarAccountingEventRepository>()) {
        throw StateError('IsarAccountingEventRepository not registered');
      }
      final repo = Get.find<IsarAccountingEventRepository>();

      // ── prevHash: último evento de esta entidad ──────────────────────────
      final last = await repo.getLastByEntity(
        entityType: 'account_receivable',
        entityId: cxc.id,
      );
      final prevHash = last?.hash;

      // ── Evento 1: ar_collection_recorded ────────────────────────────────
      // saldoFinalCop usa `diferencia` (saldo tras colección, antes de ajuste)
      // para satisfacer el invariante de proyección:
      //   projection.saldoActualCop - totalIngresadoCop == saldoFinalCop
      // El evento ar_adjustment_applied lleva el saldo restante a 0.
      final event1 = AccountingEvent(
        id: _uuid.v4(),
        entityType: 'account_receivable',
        entityId: cxc.id,
        eventType: 'ar_collection_recorded',
        occurredAt: fechaRecaudo.value,
        recordedAt: DateTime.now().toUtc(),
        actorId: 'admin',
        prevHash: prevHash,
        payload: {
          'splits': nuevosRecaudos
              .map((p) => {
                    'id': p.id,
                    'method': p.method.name,
                    'montoCop': p.montoCop,
                    'banco': p.banco,
                    'accountLast4': p.accountLast4,
                    'referencia': p.referencia,
                    'nota': p.nota,
                  })
              .toList(),
          'saldoInicialCop': saldoInicialCop,
          'totalIngresadoCop': totalIngresado,
          'diferenciaCop': diferencia,
          'saldoFinalCop': diferencia,
          'conAjuste': (marcarComoAjustada.value && ajusteCop > 0),
        },
      );
      await repo.appendAtomic(event1);

      // ── Evento 2: ar_adjustment_applied (si corresponde) ────────────────
      if (ajusteCop > 0) {
        final event2 = AccountingEvent(
          id: _uuid.v4(),
          entityType: 'account_receivable',
          entityId: cxc.id,
          eventType: 'ar_adjustment_applied',
          occurredAt: fechaRecaudo.value,
          recordedAt: DateTime.now().toUtc(),
          actorId: 'admin',
          prevHash: event1.hash,
          payload: {
            'valorAjusteCop': ajusteCop,
            'saldoFinalCop': 0,
          },
        );
        await repo.appendAtomic(event2);
      }

      Get.snackbar(
        'Audit Trail',
        '✓ Recaudo registrado. Saldo final: $saldoFinal COP',
        backgroundColor: Colors.green,
      );
      // P2-C: refrescar timeline inmediatamente tras save() exitoso
      final tlTag = 'timeline_${cxc.id}';
      if (Get.isRegistered<AccountingTimelineController>(tag: tlTag)) {
        Get.find<AccountingTimelineController>(tag: tlTag).refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error Audit Trail',
        '${e.runtimeType}: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }
}

// --------------------------------- PAGE -------------------------------------

class ARDetailPage extends StatefulWidget {
  final String arId;
  const ARDetailPage({super.key, required this.arId});

  @override
  State<ARDetailPage> createState() => _ARDetailPageState();
}

class _ARDetailPageState extends State<ARDetailPage> {
  late final ARDetailController c;
  late final AccountingTimelineController _tc;

  @override
  void initState() {
    super.initState();
    c = Get.put(
      ARDetailController(widget.arId),
      tag: widget.arId,
      permanent: false,
    );
    _tc = Get.put(
      AccountingTimelineController(),
      tag: 'timeline_${widget.arId}',
    );
    _tc.load(widget.arId);
  }

  @override
  void dispose() {
    Get.delete<AccountingTimelineController>(tag: 'timeline_${widget.arId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color arColor = Color(0xFF3B82F6);

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
          // Fondo gradiente
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  arColor.withValues(alpha: 0.1),
                  const Color(0xFF1D4ED8).withValues(alpha: 0.1),
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
                          const SizedBox(width: 10),
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
                              colors: [arColor, Color(0xFF1D4ED8)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: arColor.withValues(alpha: 0.3),
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
                                value: _formatCopInt(c.cxc.montoOriginalCop),
                                icon: Icons.attach_money_outlined,
                                color: arColor),
                            const SizedBox(height: 8),
                            SummaryRow(
                                label: 'Monto Recaudado Anterior',
                                value: _formatCopInt(c.totalPagadoAnteriorCop),
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
                        trailing: Obx(() => Container(
                              alignment: Alignment.centerLeft,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [arColor, Color(0xFF1D4ED8)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: arColor.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                _formatCopInt(c.totalNuevosRecaudosCop),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ModernFechaRecaudoField(c: c, color: arColor),
                            const SizedBox(height: 16),
                            const Text('Detalle de los Pagos Recibidos Ahora:'),
                            const SizedBox(height: 12),
                            Obx(() => Column(
                                  children: [
                                    for (int i = 0;
                                        i < c.nuevosRecaudos.length;
                                        i++)
                                      _ModernRecaudoCardCxC(
                                        key: ValueKey(c.nuevosRecaudos[i].id),
                                        recaudoId: c.nuevosRecaudos[i].id,
                                        visualIndex: i,
                                        c: c,
                                        color: arColor,
                                      ),
                                  ],
                                )),
                            const SizedBox(height: 12),
                            _ARAddButton(
                              label: 'Agregar Método de Pago',
                              icon: Icons.account_balance_wallet_outlined,
                              onPressed: c.addRecaudo,
                              color: arColor,
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              label: 'Notas del Recaudo (Opcional)',
                              hint: 'Ej. Pago final de saldo pendiente.',
                              value: c.notaRecaudo,
                              icon: Icons.note_alt_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Balance y Ajuste/Descuento
                      _ModernSection(
                        title: '⚖️ Balance',
                        child: Obx(() {
                          final diferencia = c.diferenciaCop;
                          // Blindaje: forzar ajuste=false cuando ya no aplica
                          if (diferencia <= 0 && c.marcarComoAjustada.value) {
                            Future.microtask(
                                () => c.marcarComoAjustada.value = false);
                          }
                          final ajusteCop = c.valorAjusteCop;
                          final esSobrepago = diferencia < 0;
                          // §6: saldoFinalCop determinístico
                          final saldoFinalCop = esSobrepago
                              ? diferencia
                              : (c.marcarComoAjustada.value
                                  ? 0
                                  : (diferencia > 0 ? diferencia : 0));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BalanceSummaryRow(
                                  label: 'Saldo Inicial Pendiente',
                                  amountCop: c.saldoInicialCop,
                                  color: const Color(0xFF4B5563)),
                              const SizedBox(height: 8),
                              BalanceSummaryRow(
                                  label: 'Total Recaudado Ahora',
                                  amountCop: c.totalNuevosRecaudosCop,
                                  color: arColor,
                                  sign: '-'),
                              const SizedBox(height: 16),
                              if (ajusteCop > 0)
                                BalanceSummaryRow(
                                    label: 'Valor Ajuste/Descuento',
                                    amountCop: ajusteCop,
                                    color: const Color(0xFFEF4444)),
                              if (ajusteCop > 0) const SizedBox(height: 16),
                              if (esSobrepago)
                                _ARBalanceCard(
                                  label: '⚠️ Sobre Pago',
                                  amountCop: diferencia,
                                  isBalanced: false,
                                  color: const Color(0xFFEF4444),
                                )
                              else
                                _ARBalanceCard(
                                  label: saldoFinalCop > 0
                                      ? 'Saldo Final Pendiente'
                                      : '✓ CxC Cerrada/Totalmente Pagada',
                                  amountCop: saldoFinalCop,
                                  isBalanced: saldoFinalCop <= 0,
                                  color: saldoFinalCop > 0
                                      ? const Color(0xFFFBBF24)
                                      : arColor,
                                ),
                              const SizedBox(height: 12),
                              if (diferencia > 0)
                                _ARCheckbox(
                                  label: 'Cerrar con Ajuste/Descuento',
                                  value: c.marcarComoAjustada,
                                  activeColor: const Color(0xFFEF4444),
                                ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // 4. Historial / Timeline (P2-C)
                      _TimelineSection(tc: _tc),
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
            child: _ARSubmitButton(
              onPressed: c.save,
              color: arColor,
              label: 'Registrar Recaudo',
            ),
          ),
        ],
      ),
    );
  }
}

// ========================= WIDGETS AUXILIARES ================================

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
      margin: const EdgeInsets.only(bottom: 16),
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

// Fecha del Recaudo
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
                        colorScheme: ColorScheme.light(primary: color),
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

// Fila de resumen estático de la CxC
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
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

// Fila de resumen para el balance
class BalanceSummaryRow extends StatelessWidget {
  const BalanceSummaryRow({
    super.key,
    required this.label,
    required this.amountCop,
    required this.color,
    this.sign = '+',
  });

  final String label;
  final int amountCop;
  final Color color;
  final String sign;

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
          amountCop < 0
              ? _formatCopInt(amountCop)
              : '($sign) ${_formatCopInt(amountCop)}',
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

// ==================== _ModernRecaudoCardCxC ====================

class _ModernRecaudoCardCxC extends StatefulWidget {
  const _ModernRecaudoCardCxC({
    super.key,
    required this.recaudoId,
    required this.visualIndex,
    required this.c,
    required this.color,
  });

  final String recaudoId;
  final int visualIndex;
  final ARDetailController c;
  final Color color;

  @override
  State<_ModernRecaudoCardCxC> createState() => _ModernRecaudoCardCxCState();
}

class _ModernRecaudoCardCxCState extends State<_ModernRecaudoCardCxC> {
  late TextEditingController montoCtrl;
  late TextEditingController bancoCtrl;
  late TextEditingController refCtrl;
  late TextEditingController last4Ctrl;
  late TextEditingController notaCtrl;

  late final FocusNode montoFocus;
  late final FocusNode bancoFocus;
  late final FocusNode refFocus;
  late final FocusNode last4Focus;
  late final FocusNode notaFocus;

  Timer? _debounce;

  void _bumpDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 140), widget.c.bumpUi);
  }

  CollectionSplit? get _recaudoOrNull {
    final i =
        widget.c.nuevosRecaudos.indexWhere((e) => e.id == widget.recaudoId);
    return i >= 0 ? widget.c.nuevosRecaudos[i] : null;
  }

  @override
  void initState() {
    super.initState();
    final r = _recaudoOrNull;

    montoCtrl = TextEditingController(
        text: (r != null && r.montoCop > 0) ? r.montoCop.toString() : '');
    bancoCtrl = TextEditingController(text: r?.banco ?? '');
    refCtrl = TextEditingController(text: r?.referencia ?? '');
    last4Ctrl = TextEditingController(text: r?.accountLast4 ?? '');
    notaCtrl = TextEditingController(text: r?.nota ?? '');

    montoFocus = FocusNode();
    bancoFocus = FocusNode();
    refFocus = FocusNode();
    last4Focus = FocusNode();
    notaFocus = FocusNode();
  }

  @override
  void didUpdateWidget(_ModernRecaudoCardCxC oldWidget) {
    super.didUpdateWidget(oldWidget);
    final r = _recaudoOrNull;
    if (r == null) return;

    if (oldWidget.recaudoId != widget.recaudoId) {
      if (!montoFocus.hasFocus) {
        montoCtrl.text = r.montoCop > 0 ? r.montoCop.toString() : '';
      }
      if (!bancoFocus.hasFocus) bancoCtrl.text = r.banco ?? '';
      if (!refFocus.hasFocus) refCtrl.text = r.referencia ?? '';
      return;
    }

    final newMonto = r.montoCop > 0 ? r.montoCop.toString() : '';
    if (!montoFocus.hasFocus && montoCtrl.text != newMonto) {
      montoCtrl.text = newMonto;
    }

    final newBanco = r.banco ?? '';
    if (!bancoFocus.hasFocus && bancoCtrl.text != newBanco) {
      bancoCtrl.text = newBanco;
    }

    final newRef = r.referencia ?? '';
    if (!refFocus.hasFocus && refCtrl.text != newRef) refCtrl.text = newRef;

    final newLast4 = r.accountLast4 ?? '';
    if (!last4Focus.hasFocus && last4Ctrl.text != newLast4) {
      last4Ctrl.text = newLast4;
    }

    final newNota = r.nota ?? '';
    if (!notaFocus.hasFocus && notaCtrl.text != newNota) {
      notaCtrl.text = newNota;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    montoCtrl.dispose();
    bancoCtrl.dispose();
    refCtrl.dispose();
    last4Ctrl.dispose();
    notaCtrl.dispose();

    montoFocus.dispose();
    bancoFocus.dispose();
    refFocus.dispose();
    last4Focus.dispose();
    notaFocus.dispose();
    super.dispose();
  }

  void _cleanFieldsOnMethodChange({
    required CollectionSplit r,
    required CollectionMethod newMethod,
  }) {
    if (!newMethod.needsBanco) {
      r.banco = null;
      if (!bancoFocus.hasFocus) bancoCtrl.text = '';
    }
    if (!newMethod.needsReferencia) {
      r.referencia = null;
      if (!refFocus.hasFocus) refCtrl.text = '';
    }
    if (!newMethod.needsLast4) {
      r.accountLast4 = null;
      if (!last4Focus.hasFocus) last4Ctrl.text = '';
    }
    if (!newMethod.needsNota) {
      r.nota = null;
      if (!notaFocus.hasFocus) notaCtrl.text = '';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final r = _recaudoOrNull;
    if (r == null) return const SizedBox.shrink();

    final needsBanco = r.method.needsBanco;
    final needsRef = r.method.needsReferencia;
    final needsLast4 = r.method.needsLast4;
    final needsNota = r.method.needsNota;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: widget.color.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color,
                      const Color(0xFF1D4ED8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pago #${widget.visualIndex + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: widget.color,
                  ),
                ),
              ),
              if (widget.c.nuevosRecaudos.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFFEF4444), size: 20),
                  onPressed: () {
                    final idx = widget.c.nuevosRecaudos
                        .indexWhere((e) => e.id == widget.recaudoId);
                    if (idx >= 0) widget.c.removeRecaudo(idx);
                  },
                  tooltip: 'Eliminar',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Método
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
              child: DropdownButton2<CollectionMethod>(
                value: r.method,
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
                          child: Text(_methodLabel(m)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  r.method = v;
                  _cleanFieldsOnMethodChange(r: r, newMethod: v);
                  widget.c.nuevosRecaudos.refresh();
                  setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Monto
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
              controller: montoCtrl,
              focusNode: montoFocus,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: _money.currencySymbol,
                hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
              ),
              onChanged: (v) {
                r.montoCop = _parseCopInt(v);
                _bumpDebounced();
              },
            ),
          ),

          if (needsBanco) ...[
            const SizedBox(height: 16),
            const Text(
              'Banco',
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
                controller: bancoCtrl,
                focusNode: bancoFocus,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ej. Bancolombia / Davivienda',
                  hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                ),
                onChanged: (v) {
                  r.banco = v.trim().isEmpty ? null : v.trim();
                },
              ),
            ),
          ],

          if (needsRef) ...[
            const SizedBox(height: 16),
            const Text(
              'Referencia / Número de Cheque',
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
                controller: refCtrl,
                focusNode: refFocus,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ej. Trans-5678 / Cheque #123',
                  hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                ),
                onChanged: (v) {
                  r.referencia = v.trim().isEmpty ? null : v.trim();
                },
              ),
            ),
          ],

          if (needsLast4) ...[
            const SizedBox(height: 16),
            const Text(
              'Últimos 4 dígitos de tarjeta',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextFormField(
                  controller: last4Ctrl,
                  focusNode: last4Focus,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: '1234',
                    hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                  ),
                  onChanged: (v) {
                    r.accountLast4 = v.trim().isEmpty ? null : v.trim();
                  },
                ),
              ),
            ),
          ],

          if (needsNota) ...[
            const SizedBox(height: 16),
            const Text(
              'Nota del Método "Otro"',
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
                controller: notaCtrl,
                focusNode: notaFocus,
                maxLines: null,
                minLines: 2,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ej. Canje / Compensación / Nota interna',
                  hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                ),
                onChanged: (v) {
                  r.nota = v.trim().isEmpty ? null : v.trim();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== AR-specific enterprise widgets ====================

class _ARAddButton extends StatelessWidget {
  const _ARAddButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF3B82F6),
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
        height: 50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
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

class _ARBalanceCard extends StatelessWidget {
  const _ARBalanceCard({
    required this.label,
    required this.amountCop,
    required this.isBalanced,
    this.color,
  });

  final String label;
  final int amountCop;
  final bool isBalanced;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const defaultColor = Color(0xFF3B82F6);
    final base = color ?? defaultColor;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [base, base.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: base.withValues(alpha: 0.3),
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
            _formatCopInt(amountCop),
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

class _ARCheckbox extends StatelessWidget {
  const _ARCheckbox({
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
                activeColor: activeColor ?? const Color(0xFF3B82F6),
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

class _ARSubmitButton extends StatelessWidget {
  const _ARSubmitButton({
    required this.onPressed,
    required this.color,
    this.label = 'Guardar',
  });

  final VoidCallback onPressed;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, const Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 60,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================= P2-C TIMELINE WIDGETS ============================

/// Sección "Historial" — lee del AccountingTimelineController (nunca de cálculos UI).
class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.tc});

  final AccountingTimelineController tc;

  @override
  Widget build(BuildContext context) {
    return _ModernSection(
      title: '🔎 Historial',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registro auditable (local-first)',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (tc.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (tc.errorMessage.value != null) {
              return Text(
                tc.errorMessage.value!,
                style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              );
            }
            if (tc.events.isEmpty) {
              return const Text(
                'Aún no hay eventos para esta cuenta.',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tc.events.length,
              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
              itemBuilder: (_, i) => _TimelineEventTile(event: tc.events[i]),
            );
          }),
        ],
      ),
    );
  }
}

/// Tile individual para un AccountingEvent en el timeline.
class _TimelineEventTile extends StatelessWidget {
  const _TimelineEventTile({required this.event});

  final AccountingEvent event;

  @override
  Widget build(BuildContext context) {
    final p = event.payload;
    final isCollection = event.eventType == 'ar_collection_recorded';
    final isAdjustment = event.eventType == 'ar_adjustment_applied';
    final conAjuste = p['conAjuste'] == true;

    final title = isCollection
        ? 'Recaudo registrado'
        : isAdjustment
            ? 'Ajuste aplicado'
            : event.eventType;

    final fecha =
        DateFormat('dd/MM/yyyy HH:mm').format(event.occurredAt.toLocal());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (conAjuste)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFFEF4444), width: 0.5),
                  ),
                  child: const Text(
                    'Cierre con ajuste',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '$fecha · ${event.actorId}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          if (isCollection) _CollectionPayloadView(payload: p),
          if (isAdjustment) _AdjustmentPayloadView(payload: p),
        ],
      ),
    );
  }
}

/// Vista de payload para ar_collection_recorded.
/// Incluye validación visual Σ splits == totalIngresadoCop.
class _CollectionPayloadView extends StatelessWidget {
  const _CollectionPayloadView({required this.payload});

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final totalIngresado = payload['totalIngresadoCop'];
    final splits = payload['splits'];

    // Validación visual: Σ splits.montoCop == totalIngresadoCop
    var sumaSplits = 0;
    if (splits is List) {
      for (final s in splits) {
        if (s is Map) {
          final m = s['montoCop'];
          if (m is int) sumaSplits += m;
        }
      }
    }
    final inconsistencia =
        totalIngresado is int && sumaSplits != totalIngresado;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PayloadRow('Saldo inicial', payload['saldoInicialCop']),
        _PayloadRow('Total recaudado', totalIngresado),
        _PayloadRow('Diferencia', payload['diferenciaCop']),
        _PayloadRow('Saldo final (colección)', payload['saldoFinalCop']),
        if (splits is List && splits.isNotEmpty) ...[
          const SizedBox(height: 6),
          const Text(
            'Splits:',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
          ),
          for (final s in splits)
            if (s is Map)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Text(
                  '• ${s['method'] ?? '?'}: '
                  '${s['montoCop'] is int ? _formatCopInt(s['montoCop'] as int) : s['montoCop']}',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF374151)),
                ),
              ),
        ],
        if (inconsistencia)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              '⚠️ Inconsistencia: Σ splits ≠ total recaudado',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Vista de payload para ar_adjustment_applied.
class _AdjustmentPayloadView extends StatelessWidget {
  const _AdjustmentPayloadView({required this.payload});

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PayloadRow('Ajuste aplicado', payload['valorAjusteCop']),
        _PayloadRow('Saldo final (debe ser 0)', payload['saldoFinalCop']),
      ],
    );
  }
}

/// Fila label: valor para el detalle de un evento.
class _PayloadRow extends StatelessWidget {
  const _PayloadRow(this.label, this.value);

  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final display = value is int
        ? _formatCopInt(value as int)
        : value?.toString() ?? '—';
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          Text(
            display,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}

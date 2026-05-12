// lib/presentation/pages/dev/integrations_diagnostics/simit_diagnostic_page.dart
// ============================================================================
// DEV-ONLY — Pantalla de diagnóstico SIMIT (Persona o Vehículo).
// Consulta directa a Integrations API. NO persiste.
//
// Mismo endpoint backend (/api/simit/multas/:license) para ambos modos —
// el path acepta cédula o placa. La diferencia es semántica/UI.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/simit/models/simit_models.dart';
import '../../../../data/simit/simit_detail_prefetch_service.dart';
import '../../../controllers/dev/simit_diagnostic_controller.dart';
import '../../../widgets/asset/simit_multa_detail_bottom_sheet.dart';
import 'widgets/diagnostic_state_view.dart';
import 'widgets/diagnostic_status_panel.dart';

class SimitDiagnosticPage extends StatelessWidget {
  final SimitQueryMode mode;

  const SimitDiagnosticPage({super.key, required this.mode});

  String get _title => mode == SimitQueryMode.person
      ? 'SIMIT Persona — Consulta'
      : 'SIMIT Vehículo — Consulta';

  String get _idleHint => mode == SimitQueryMode.person
      ? 'Ingresa el número de documento para consultar SIMIT.'
      : 'Ingresa la placa para consultar SIMIT.';

  @override
  Widget build(BuildContext context) {
    // Tag distinto por modo para que persona y vehículo no compartan estado.
    final tag = mode.name;
    final controller = Get.put(
      SimitDiagnosticController(mode: mode),
      tag: tag,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Text(
              'Diagnóstico DEV · sin caché · sin persistencia',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormCard(controller: controller),
            const SizedBox(height: 12),
            Obx(
              () => DiagnosticStateView(
                state: controller.state.value,
                idleMessage: _idleHint,
                emptyMessage: 'Sin datos.',
                failureMessage: controller.failureMessage.value,
                successBuilder: (_) => _SuccessView(controller: controller),
              ),
            ),
            Obx(() => DiagnosticStatusPanel(report: controller.report.value)),
          ],
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final SimitDiagnosticController controller;
  const _FormCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isVehicle = controller.mode == SimitQueryMode.vehicle;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          TextField(
            keyboardType:
                isVehicle ? TextInputType.text : TextInputType.number,
            textCapitalization: isVehicle
                ? TextCapitalization.characters
                : TextCapitalization.none,
            decoration: InputDecoration(
              labelText: controller.inputLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => controller.query.value = v,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => FilledButton.icon(
                onPressed:
                    controller.state.value == DiagnosticState.loading
                        ? null
                        : controller.consult,
                icon: const Icon(Icons.search),
                label: const Text('Consultar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final SimitDiagnosticController controller;
  const _SuccessView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = controller.data.value!;
    if (controller.successEmpty) {
      return _EmptySuccessBanner(query: controller.query.value);
    }
    return _ResultView(data: data);
  }
}

/// Render canónico SUCCESS_EMPTY (NO usar copy "Sin información").
class _EmptySuccessBanner extends StatelessWidget {
  final String query;
  const _EmptySuccessBanner({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'SIMIT consultado: sin comparendos ni multas pendientes.',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Valor a pagar: \$0',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Consulta realizada para: $query',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final SimitData data;
  const _ResultView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DiagnosticSectionCard(
          title: 'Resumen',
          icon: Icons.summarize_outlined,
          child: Column(
            children: [
              _CounterRow(
                  label: 'Comparendos', value: data.summary.comparendos),
              _CounterRow(label: 'Multas', value: data.summary.multas),
              _CounterRow(
                  label: 'Acuerdos de pago',
                  value: data.summary.paymentAgreementsCount),
              const SizedBox(height: 6),
              DiagnosticKvRow(
                  label: 'Total',
                  value: data.summary.formattedTotal ??
                      '\$${data.total.toStringAsFixed(0)}'),
              if (data.summary.maskedName != null)
                DiagnosticKvRow(
                    label: 'Nombre', value: data.summary.maskedName),
              DiagnosticKvRow(
                  label: 'Documento',
                  value: data.summary.document,
                  monospace: true),
            ],
          ),
        ),
        if (data.fines.isNotEmpty)
          DiagnosticSectionCard(
            title: 'Multas (${data.fines.length})',
            icon: Icons.receipt_long_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PrefetchProgressBanner(),
                ...data.fines
                    .map((f) =>
                        _FineTile(fine: f, document: data.summary.document)),
              ],
            ),
          ),
      ],
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;

  const _CounterRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isZero = value == 0;
    final color = isZero ? Colors.green.shade700 : cs.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$value',
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner discreto que muestra progreso del prefetch de detalles.
/// Se oculta cuando el prefetch está idle (cero pendientes y cero activos).
class _PrefetchProgressBanner extends StatelessWidget {
  const _PrefetchProgressBanner();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SimitDetailPrefetchService>()) {
      return const SizedBox.shrink();
    }
    final svc = Get.find<SimitDetailPrefetchService>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final active = svc.activeCount.value;
      final queued = svc.queuedCount.value;
      final completed = svc.completedCount.value;
      final failed = svc.failedCount.value;
      final total = active + queued + completed + failed;

      if (total == 0) return const SizedBox.shrink();
      final done = completed + failed;
      final isIdle = active == 0 && queued == 0;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            if (!isIdle)
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.primary,
                ),
              )
            else
              Icon(Icons.check_circle_outline_rounded,
                  size: 14, color: cs.primary),
            const SizedBox(width: 8),
            Text(
              isIdle
                  ? 'Detalles listos ($completed/$total)'
                  : 'Cargando detalles… ($done/$total)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _FineTile extends StatelessWidget {
  final SimitFine fine;
  final String? document;

  const _FineTile({required this.fine, required this.document});

  /// Tap → abre el BottomSheet con el detalle profundo de la multa.
  /// Si falta document o id, muestra Snackbar para feedback claro
  /// (caso defensivo — en el flujo normal ambos vienen poblados).
  void _openDetail(BuildContext context) {
    final doc = document?.trim();
    final comparendoId = fine.id.trim();
    if (doc == null || doc.isEmpty || comparendoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No se puede abrir el detalle: falta documento o id de comparendo'),
        ),
      );
      return;
    }
    showSimitMultaDetailBottomSheet(
      context: context,
      document: doc,
      comparendoId: comparendoId,
      infraccionLabel: fine.infractionCodeShort ?? fine.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => _openDetail(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fine.infractionCodeShort ?? fine.id,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace'),
                      ),
                    ),
                    Text(
                      '\$${fine.amountToPay.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: cs.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: cs.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 4),
                DiagnosticKvRow(label: 'Estado', value: fine.estado),
                DiagnosticKvRow(
                    label: 'Placa', value: fine.placa, monospace: true),
                DiagnosticKvRow(label: 'Fecha', value: fine.fecha),
                DiagnosticKvRow(label: 'Ciudad', value: fine.ciudad),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

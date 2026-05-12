// lib/presentation/pages/dev/integrations_diagnostics/runt_vehicle_diagnostic_page.dart
// ============================================================================
// DEV-ONLY — Pantalla de diagnóstico RUNT Vehículo.
// Consulta directa al endpoint individual de Integrations API. NO persiste.
// portalType fijo en 'GOV' (decisión arquitectónica).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/runt/models/runt_vehicle_models.dart';
import '../../../controllers/dev/runt_vehicle_diagnostic_controller.dart';
import 'widgets/diagnostic_state_view.dart';
import 'widgets/diagnostic_status_panel.dart';

class RuntVehicleDiagnosticPage extends StatelessWidget {
  const RuntVehicleDiagnosticPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RuntVehicleDiagnosticController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNT Vehículo — Consulta'),
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
                idleMessage:
                    'Ingresa documento del propietario validado y placa.',
                emptyMessage:
                    'Vehículo encontrado pero sin información detallada.',
                failureMessage: controller.failureMessage.value,
                successBuilder: (_) =>
                    _ResultView(data: controller.data.value!),
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
  final RuntVehicleDiagnosticController controller;
  const _FormCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 110,
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: controller.documentType.value,
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'C', child: Text('C.C.')),
                      DropdownMenuItem(value: 'E', child: Text('C.E.')),
                      DropdownMenuItem(value: 'P', child: Text('Pas.')),
                    ],
                    onChanged: (v) {
                      if (v != null) controller.documentType.value = v;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Documento del propietario',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.documentNumber.value = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Placa (única)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => controller.plate.value = v,
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

class _ResultView extends StatelessWidget {
  final RuntVehicleData data;
  const _ResultView({required this.data});

  @override
  Widget build(BuildContext context) {
    final basic = data.basicInfo;
    final general = data.generalInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DiagnosticSectionCard(
          title: 'Identificación',
          icon: Icons.directions_car_outlined,
          child: Column(
            children: [
              DiagnosticKvRow(
                  label: 'Placa', value: basic.plate, monospace: true),
              DiagnosticKvRow(label: 'Estado', value: basic.vehicleStatus),
              DiagnosticKvRow(label: 'Servicio', value: basic.serviceType),
              DiagnosticKvRow(label: 'Clase', value: basic.vehicleClass),
              if (basic.transitLicenseNumber != null)
                DiagnosticKvRow(
                    label: 'Licencia tránsito',
                    value: basic.transitLicenseNumber,
                    monospace: true),
              if (general != null) ...[
                DiagnosticKvRow(label: 'Marca', value: general.marca),
                DiagnosticKvRow(label: 'Línea', value: general.line),
                DiagnosticKvRow(
                    label: 'Modelo', value: general.modelo?.toString()),
                DiagnosticKvRow(label: 'Color', value: general.color),
                DiagnosticKvRow(
                    label: 'Carrocería', value: general.bodyType),
                DiagnosticKvRow(
                    label: 'Combustible', value: general.fuelType),
                DiagnosticKvRow(
                    label: 'Matrícula inicial',
                    value: general.initialRegistrationDate),
                DiagnosticKvRow(
                    label: 'Autoridad tránsito',
                    value: general.transitAuthority),
              ],
            ],
          ),
        ),
        if (data.soat.isNotEmpty)
          DiagnosticSectionCard(
            title: 'SOAT (${data.soat.length})',
            icon: Icons.shield_outlined,
            child: Column(
              children: data.soat
                  .map((s) => _PolicyTile(
                        title: s.insurer ?? 'SOAT',
                        policyNumber: s.policyNumber,
                        validityStart: s.validityStart,
                        validityEnd: s.validityEnd,
                        status: s.estado,
                      ))
                  .toList(),
            ),
          ),
        if (data.rcInsurances.isNotEmpty)
          DiagnosticSectionCard(
            title: 'Seguros RC (${data.rcInsurances.length})',
            icon: Icons.policy_outlined,
            child: Column(
              children: data.rcInsurances
                  .map((rc) => _PolicyTile(
                        title:
                            rc.insurer ?? rc.policyType ?? 'Seguro RC',
                        policyNumber: rc.policyNumber,
                        validityStart: rc.validityStart,
                        validityEnd: rc.validityEnd,
                        status: rc.estado,
                      ))
                  .toList(),
            ),
          ),
        if (data.rtmHistory.isNotEmpty)
          DiagnosticSectionCard(
            title: 'Revisión Técnica (${data.rtmHistory.length})',
            icon: Icons.fact_check_outlined,
            child: Column(
              children: data.rtmHistory.map(_buildRtmTile).toList(),
            ),
          ),
        if (data.ownershipLimitations.isNotEmpty)
          DiagnosticSectionCard(
            title:
                'Limitaciones de propiedad (${data.ownershipLimitations.length})',
            icon: Icons.gavel_outlined,
            child: Column(
              children: data.ownershipLimitations
                  .map(
                    (lim) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DiagnosticKvRow(
                              label: 'Tipo',
                              value: lim.limitationType),
                          DiagnosticKvRow(
                              label: 'Entidad',
                              value: lim.legalEntity),
                          DiagnosticKvRow(
                              label: 'Departamento',
                              value: lim.department),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildRtmTile(RuntRtmRecord r) {
    final isCurrent = (r.vigente ?? '').toUpperCase() == 'SI';
    final color = isCurrent ? Colors.green.shade700 : Colors.orange.shade800;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                  isCurrent
                      ? Icons.verified_outlined
                      : Icons.warning_amber_rounded,
                  size: 16,
                  color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  r.revisionType ?? 'Revisión',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                r.vigente ?? '—',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
          DiagnosticKvRow(label: 'Vigencia', value: r.validityDate),
          DiagnosticKvRow(label: 'Expedición', value: r.issueDate),
          DiagnosticKvRow(label: 'CDA', value: r.cda),
        ],
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  final String title;
  final String? policyNumber;
  final String? validityStart;
  final String? validityEnd;
  final String? status;

  const _PolicyTile({
    required this.title,
    this.policyNumber,
    this.validityStart,
    this.validityEnd,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = (status ?? '').toUpperCase().contains('VIGENTE');
    final color = isActive ? Colors.green.shade700 : cs.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status ?? '—',
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          DiagnosticKvRow(
              label: 'Póliza', value: policyNumber, monospace: true),
          DiagnosticKvRow(label: 'Vigencia desde', value: validityStart),
          DiagnosticKvRow(label: 'Vigencia hasta', value: validityEnd),
        ],
      ),
    );
  }
}

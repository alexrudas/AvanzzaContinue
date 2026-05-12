// lib/presentation/pages/dev/integrations_diagnostics/runt_person_diagnostic_page.dart
// ============================================================================
// DEV-ONLY — Pantalla de diagnóstico RUNT Persona.
// Consulta directa al endpoint individual de Integrations API. NO persiste.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/runt/models/runt_person_models.dart';
import '../../../controllers/dev/runt_person_diagnostic_controller.dart';
import 'widgets/diagnostic_state_view.dart';
import 'widgets/diagnostic_status_panel.dart';

class RuntPersonDiagnosticPage extends StatelessWidget {
  const RuntPersonDiagnosticPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RuntPersonDiagnosticController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNT Persona — Consulta'),
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
                    'Ingresa tipo y número de documento para consultar.',
                emptyMessage:
                    'Persona encontrada en el RUNT pero sin licencias activas.',
                failureMessage: controller.failureMessage.value,
                successBuilder: (_) => _ResultView(data: controller.data.value!),
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
  final RuntPersonDiagnosticController controller;
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
                    labelText: 'Número de documento',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.documentNumber.value = v,
                ),
              ),
            ],
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
  final RuntPersonData data;
  const _ResultView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DiagnosticSectionCard(
          title: 'Información de la persona',
          icon: Icons.person_outline,
          child: Column(
            children: [
              DiagnosticKvRow(label: 'Nombre completo', value: data.fullName),
              DiagnosticKvRow(
                  label: 'Documento',
                  value: '${data.documentType ?? ''} ${data.documentNumber}'
                      .trim()),
              DiagnosticKvRow(
                  label: 'Estado persona', value: data.personStatus),
              DiagnosticKvRow(
                  label: 'Estado conductor', value: data.driverStatus),
              DiagnosticKvRow(
                  label: 'Inscripción RUNT',
                  value: data.runtRegistrationNumber,
                  monospace: true),
              DiagnosticKvRow(
                  label: 'Fecha inscripción', value: data.registrationDate),
            ],
          ),
        ),
        if (data.licencias.isNotEmpty)
          DiagnosticSectionCard(
            title: 'Licencias (${data.licencias.length})',
            icon: Icons.badge_outlined,
            child: Column(
              children: data.licencias
                  .map((l) => _LicenseTile(license: l))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _LicenseTile extends StatelessWidget {
  final RuntLicense license;
  const _LicenseTile({required this.license});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isActive = (license.estado ?? '').toUpperCase().contains('ACTIVA');
    final stateColor =
        isActive ? Colors.green.shade700 : cs.onSurfaceVariant;

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
              Icon(Icons.credit_card, size: 16, color: stateColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  license.licenseNumber ?? 'Licencia sin número',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  license.estado ?? '—',
                  style: TextStyle(
                      fontSize: 11,
                      color: stateColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DiagnosticKvRow(
              label: 'Expedida', value: license.issueDate),
          DiagnosticKvRow(
              label: 'OT expide', value: license.issuingAuthority),
          if ((license.restricciones ?? '').isNotEmpty)
            DiagnosticKvRow(
                label: 'Restricciones', value: license.restricciones),
          if ((license.retention ?? '').isNotEmpty)
            DiagnosticKvRow(label: 'Retención', value: license.retention),
          if (license.detalles.isNotEmpty) ...[
            const SizedBox(height: 6),
            const Text(
              'Categorías:',
              style:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            ...license.detalles.map(
              (d) => Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  '• ${d.category ?? '—'}  · vence ${d.expiryDate ?? '—'}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

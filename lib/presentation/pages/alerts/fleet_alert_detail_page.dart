// ============================================================================
// lib/presentation/pages/alerts/fleet_alert_detail_page.dart
// FLEET ALERT DETAIL PAGE — Detalle de alerta individual + impacto + CTA
//
// QUÉ HACE:
// - Muestra el detalle completo de una alerta: identidad del activo, estado
//   documental, impacto operativo/legal y CTA de acción.
// - Nivel 3 del flujo de alertas de flota.
// - Recibe AlertCardVm por Get.arguments — sin controller propio.
//
// QUÉ NO HACE:
// - No re-evalúa ni re-fetcha datos — todo viene de Get.arguments.
// - No construye AlertCardVm manualmente.
// - No hardcodea textos de impacto — delega a AlertImpactMapper.
//
// PRINCIPIOS:
// - Stateless: recibe datos por Get.arguments, sin controller.
// - Guard al inicio del build: redirige a /alerts/fleet si arguments inválido.
// - CTA solo se renderiza si vm.actionRoute != null.
// - Contrato de CTA idéntico al de AlertCenterPage (mismos arguments).
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alerts/mappers/alert_impact_mapper.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';
import '../../alerts/viewmodels/alert_doc_status.dart';
import '../../alerts/widgets/alert_doc_status_badge.dart';
import '../../../routes/app_routes.dart';

class FleetAlertDetailPage extends StatelessWidget {
  const FleetAlertDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Guard: si arguments no es AlertCardVm, el stack está roto.
    final args = Get.arguments;
    if (args is! AlertCardVm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.fleetAlerts);
      });
      return const SizedBox.shrink();
    }

    final vm = args;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final sColor = severityColor(vm.severity, colors);
    final impactBody = AlertImpactMapper.resolveImpactBody(vm.code);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(vm.title),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Sección 1: Identidad del activo ──────────────────────────────
          _IdentityCard(vm: vm, severityColor: sColor),
          const SizedBox(height: 12),

          // ── Sección 2: Estado y contexto ─────────────────────────────────
          _StatusSection(vm: vm),
          const SizedBox(height: 12),

          // ── Sección 3: Impacto (solo si hay texto definido) ───────────────
          if (impactBody != null) ...[
            _ImpactSection(body: impactBody, severityColor: sColor),
            const SizedBox(height: 16),
          ],

          // ── Sección 4: CTA ────────────────────────────────────────────────
          if (vm.actionRoute != null && vm.actionLabel != null)
            _CtaButton(vm: vm),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _IdentityCard extends StatelessWidget {
  final AlertCardVm vm;
  final Color severityColor;

  const _IdentityCard({required this.vm, required this.severityColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Barra de color de severidad
            Container(
              width: 4,
              height: 44,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: severityColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vm.assetPrimaryLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (vm.assetSecondaryLabel != null)
                    Text(
                      vm.assetSecondaryLabel!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatusSection extends StatelessWidget {
  final AlertCardVm vm;

  const _StatusSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (vm.docStatus != AlertDocStatus.unknown)
                  AlertDocStatusBadge(status: vm.docStatus),
                if (vm.subtitle != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vm.subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ImpactSection extends StatelessWidget {
  final String body;
  final Color severityColor;

  const _ImpactSection({required this.body, required this.severityColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      color: severityColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: severityColor.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: severityColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Impacto',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _CtaButton extends StatelessWidget {
  final AlertCardVm vm;

  const _CtaButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => Get.toNamed(
          vm.actionRoute!,
          arguments: {
            'assetId': vm.sourceEntityId,
            'primaryLabel': vm.assetPrimaryLabel,
            'secondaryLabel': vm.assetSecondaryLabel,
          },
        ),
        child: Text(vm.actionLabel!),
      ),
    );
  }
}

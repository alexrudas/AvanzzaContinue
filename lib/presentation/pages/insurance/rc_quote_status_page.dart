// ============================================================================
// lib/presentation/pages/insurance/rc_quote_status_page.dart
// RC QUOTE STATUS PAGE — Estado del lead de cotización SRCE.
//
// QUÉ HACE:
// - Muestra el estado actual del lead de cotización RC Extracontractual.
// - Permite refrescar el estado manualmente via RcQuoteStatusController.
// - Muestra datos del vehículo del snapshot del lead.
// - Distingue entre error de args inválidos y error operativo de red/servidor.
// - Expone acciones de decisión (Interesado / Descartar) cuando el controller
//   las habilita via canPerformDecisionActions.
// - Navega hacia atrás con Get.back() en AppBar y en estado de error de args.
//
// QUÉ NO HACE:
// - No hace polling continuo — solo un refresh silencioso al init si procede.
// - No muestra IDs internos al usuario (assignedProviderId no se renderiza).
// - No gestiona la sesión directamente.
//
// PRINCIPIOS:
// - Obx en el body completo: las dependencias reactivas cubren lead, error y
//   refresh simultáneamente — split granular no reduce reconstrucciones aquí.
// - Spinner de refresh con prioridad sobre botón: isRefreshing se evalúa
//   antes que canRefresh para evitar que canRefresh (false durante refresh)
//   oculte el indicador de progreso.
// - Fallback ante lead == null sin hasInvalidArgs: estado de carga con botón
//   de reintento explícito. No se deja spinner sin salida.
// - Theme-only: cero colores hardcodeados.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE — destino post-creación del lead.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/spacing.dart';
import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../controllers/insurance/rc_quote_status_controller.dart';

class RcQuoteStatusPage extends StatelessWidget {
  const RcQuoteStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<RcQuoteStatusController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
          tooltip: 'Volver',
        ),
        title: Text(
          'Estado de cotización',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          // IMPORTANTE: isRefreshing se evalúa ANTES que canRefresh.
          // canRefresh es false mientras isRefreshing es true, por lo que
          // evaluar canRefresh primero ocultaría el spinner de progreso.
          Obx(() {
            if (ctrl.isRefreshing.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (!ctrl.canRefresh) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => ctrl.refreshLead(),
              tooltip: 'Actualizar',
            );
          }),
        ],
      ),
      body: Obx(() {
        // Error de args inválidos — pantalla terminal, no se puede operar.
        if (ctrl.hasInvalidArgs) {
          return _MessageState(
            icon: Icons.link_off_rounded,
            iconColor: cs.error,
            title: 'Solicitud no disponible',
            body: ctrl.errorMessage.value ??
                'No se encontró información de la solicitud.',
            cs: cs,
            theme: theme,
          );
        }

        final current = ctrl.lead.value;

        // lead == null sin hasInvalidArgs: el controller aún no lo cargó
        // o falló silenciosamente. Mostramos estado con reintento explícito.
        if (current == null) {
          return _NullLeadFallback(
            errorMessage: ctrl.errorMessage.value,
            isRefreshing: ctrl.isRefreshing.value,
            canRefresh: ctrl.canRefresh,
            onRetry: () => ctrl.refreshLead(),
            cs: cs,
            theme: theme,
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          children: [
            // ── Tarjeta de estado ────────────────────────────────────────
            _StatusCard(lead: current, cs: cs, theme: theme),
            const SizedBox(height: AppSpacing.md),

            // ── Error operativo (red/servidor) ───────────────────────────
            if (ctrl.errorMessage.value != null) ...[
              _ErrorBanner(
                message: ctrl.errorMessage.value!,
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // ── Datos del vehículo ───────────────────────────────────────
            _VehicleCard(
                snapshot: current.vehicleSnapshot, cs: cs, theme: theme),
            const SizedBox(height: AppSpacing.md),

            // ── Timestamps ───────────────────────────────────────────────
            _TimestampsCard(lead: current, cs: cs, theme: theme),

            // ── Acciones de decisión (solo si el controller las habilita) ─
            if (ctrl.canPerformDecisionActions) ...[
              const SizedBox(height: AppSpacing.lg),
              _DecisionActions(ctrl: ctrl, cs: cs, theme: theme),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NULL LEAD FALLBACK — evita spinner infinito cuando lead == null sin error
// ─────────────────────────────────────────────────────────────────────────────

class _NullLeadFallback extends StatelessWidget {
  final String? errorMessage;
  final bool isRefreshing;
  final bool canRefresh;
  final VoidCallback onRetry;
  final ColorScheme cs;
  final ThemeData theme;

  const _NullLeadFallback({
    required this.errorMessage,
    required this.isRefreshing,
    required this.canRefresh,
    required this.onRetry,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: cs.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No se pudo cargar la solicitud',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorMessage ??
                  'Verifica tu conexión e intenta de nuevo.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            if (canRefresh) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final InsuranceOpportunityLead lead;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatusCard({
    required this.lead,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final info = _StatusInfo.from(lead.status, cs);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: info.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: info.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(info.icon, size: 22, color: info.iconColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  info.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: info.iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            info.description,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  final VehicleSnapshot snapshot;
  final ColorScheme cs;
  final ThemeData theme;

  const _VehicleCard({
    required this.snapshot,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final plate = snapshot.plate.trim().toUpperCase();
    final brand = snapshot.brand.trim();
    final model = snapshot.model.trim();
    final year = snapshot.year > 0 ? snapshot.year.toString() : null;
    final vehicleClass = snapshot.vehicleClass.trim();
    final service = snapshot.service.trim();

    // Construir label secundario solo con los campos presentes.
    final secondaryParts = <String>[
      if (brand.isNotEmpty) brand,
      if (model.isNotEmpty) model,
      if (year != null) year,
    ];
    final secondaryLabel =
        secondaryParts.isEmpty ? null : secondaryParts.join(' ');

    // Clase y servicio — solo si hay al menos uno.
    final classServiceParts = <String>[
      if (vehicleClass.isNotEmpty) vehicleClass,
      if (service.isNotEmpty) service,
    ];
    final classServiceLabel =
        classServiceParts.isEmpty ? null : classServiceParts.join(' — ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car_rounded, size: 18, color: cs.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Vehículo',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            plate.isNotEmpty ? plate : '—',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (secondaryLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              secondaryLabel,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
          if (classServiceLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              classServiceLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIMESTAMPS CARD
// assignedProviderId no se expone: es un ID interno de sistema.
// Cuando el flujo tenga resolución de nombre de proveedor, se añade aquí.
// ─────────────────────────────────────────────────────────────────────────────

class _TimestampsCard extends StatelessWidget {
  final InsuranceOpportunityLead lead;
  final ColorScheme cs;
  final ThemeData theme;

  const _TimestampsCard({
    required this.lead,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // NOTA: DateFormat con 'es_CO' requiere que intl esté inicializado con
    // esa locale en el bootstrap de la app. Validar en dispositivo real.
    final fmt = DateFormat('d MMM yyyy, HH:mm', 'es_CO');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.10)),
      ),
      child: Column(
        children: [
          _TimestampRow(
            label: 'Solicitado',
            value: fmt.format(lead.createdAt.toLocal()),
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 8),
          _TimestampRow(
            label: 'Actualizado',
            value: fmt.format(lead.updatedAt.toLocal()),
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _TimestampRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  const _TimestampRow({
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DECISION ACTIONS — solo visible cuando canPerformDecisionActions es true
// ─────────────────────────────────────────────────────────────────────────────

class _DecisionActions extends StatelessWidget {
  final RcQuoteStatusController ctrl;
  final ColorScheme cs;
  final ThemeData theme;

  const _DecisionActions({
    required this.ctrl,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = ctrl.isActionLoading.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Qué deseas hacer con esta cotización?',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: loading
                      ? null
                      : () => ctrl.markAsInterested(),
                  icon: const Icon(Icons.thumb_up_outlined, size: 18),
                  label: const Text('Me interesa'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: loading
                      ? null
                      : () => ctrl.markAsRejected(),
                  icon: Icon(Icons.cancel_outlined,
                      size: 18, color: cs.error),
                  label: Text(
                    'Descartar',
                    style: TextStyle(color: cs.error),
                  ),
                ),
              ),
            ],
          ),
          if (loading) ...[
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: cs.primary),
            ),
          ],
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  final ColorScheme cs;
  final ThemeData theme;

  const _ErrorBanner({
    required this.message,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 18, color: cs.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MESSAGE STATE — error de args inválidos (pantalla terminal)
// ─────────────────────────────────────────────────────────────────────────────

class _MessageState extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final ColorScheme cs;
  final ThemeData theme;

  const _MessageState({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(
              onPressed: Get.back,
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS INFO — mapeado visual de InsuranceLeadStatus
// ─────────────────────────────────────────────────────────────────────────────

class _StatusInfo {
  final String label;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;

  const _StatusInfo({
    required this.label,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
  });

  factory _StatusInfo.from(InsuranceLeadStatus status, ColorScheme cs) {
    switch (status) {
      case InsuranceLeadStatus.requested:
        return _StatusInfo(
          label: 'Solicitud recibida',
          description:
              'Tu solicitud fue registrada. Un asesor la revisará pronto.',
          icon: Icons.hourglass_empty_rounded,
          iconColor: cs.primary,
          bgColor: cs.primaryContainer.withValues(alpha: 0.25),
          borderColor: cs.primary.withValues(alpha: 0.20),
        );
      case InsuranceLeadStatus.assigned:
        return _StatusInfo(
          label: 'Asignada a un asesor',
          description:
              'Un asesor ha tomado tu solicitud y está preparando la cotización.',
          icon: Icons.person_outline_rounded,
          iconColor: cs.secondary,
          bgColor: cs.secondaryContainer.withValues(alpha: 0.25),
          borderColor: cs.secondary.withValues(alpha: 0.20),
        );
      case InsuranceLeadStatus.quoted:
        return _StatusInfo(
          label: 'Cotización disponible',
          description:
              'Tu cotización está lista. El asesor se pondrá en contacto contigo.',
          icon: Icons.description_outlined,
          iconColor: cs.tertiary,
          bgColor: cs.tertiaryContainer.withValues(alpha: 0.25),
          borderColor: cs.tertiary.withValues(alpha: 0.20),
        );
      case InsuranceLeadStatus.accepted:
        return _StatusInfo(
          label: 'Cotización aceptada',
          description:
              'Aceptaste la cotización. El proceso de emisión está en curso.',
          icon: Icons.check_circle_outline_rounded,
          iconColor: cs.tertiary,
          bgColor: cs.tertiaryContainer.withValues(alpha: 0.25),
          borderColor: cs.tertiary.withValues(alpha: 0.20),
        );
      case InsuranceLeadStatus.issued:
        return _StatusInfo(
          label: 'Póliza emitida',
          description:
              'La póliza RC Extracontractual fue emitida exitosamente.',
          icon: Icons.verified_outlined,
          iconColor: cs.tertiary,
          bgColor: cs.tertiaryContainer.withValues(alpha: 0.35),
          borderColor: cs.tertiary.withValues(alpha: 0.30),
        );
      case InsuranceLeadStatus.interested:
        return _StatusInfo(
          label: 'Interesado',
          description:
              'Marcaste interés en la cotización. El asesor continuará el proceso.',
          icon: Icons.thumb_up_outlined,
          iconColor: cs.secondary,
          bgColor: cs.secondaryContainer.withValues(alpha: 0.25),
          borderColor: cs.secondary.withValues(alpha: 0.20),
        );
      case InsuranceLeadStatus.rejected:
      case InsuranceLeadStatus.rejectedByUser:
        return _StatusInfo(
          label: 'Solicitud descartada',
          description:
              'La solicitud fue descartada. Puedes generar una nueva desde el activo.',
          icon: Icons.cancel_outlined,
          iconColor: cs.error,
          bgColor: cs.errorContainer.withValues(alpha: 0.20),
          borderColor: cs.error.withValues(alpha: 0.15),
        );
      case InsuranceLeadStatus.expired:
        return _StatusInfo(
          label: 'Solicitud expirada',
          description:
              'La solicitud venció sin respuesta. Genera una nueva desde el activo.',
          icon: Icons.timer_off_outlined,
          iconColor: cs.error,
          bgColor: cs.errorContainer.withValues(alpha: 0.20),
          borderColor: cs.error.withValues(alpha: 0.15),
        );
      case InsuranceLeadStatus.unknown:
        return _StatusInfo(
          label: 'Estado desconocido',
          description:
              'No se pudo determinar el estado de la solicitud. Intenta actualizar.',
          icon: Icons.help_outline_rounded,
          iconColor: cs.onSurfaceVariant,
          bgColor: cs.surfaceContainerLow,
          borderColor: cs.outline.withValues(alpha: 0.20),
        );
    }
  }
}

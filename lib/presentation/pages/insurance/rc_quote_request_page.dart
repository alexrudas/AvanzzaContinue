// ============================================================================
// lib/presentation/pages/insurance/rc_quote_request_page.dart
// RC QUOTE REQUEST PAGE — Confirmación real y envío de solicitud SRCE.
//
// QUÉ HACE:
// - Resuelve un contrato de entrada tipado (RcQuoteRequestArgs).
// - Mantiene compatibilidad temporal con el contrato legacy basado en Map.
// - Configura el RcQuoteRequestController con datos ya resueltos y validados.
// - Muestra un resumen fiel del VehicleSnapshot que se enviará al backend.
// - Bloquea la acción si el contrato de entrada es inválido.
//
// QUÉ NO HACE:
// - No accede a repositorios ni servicios directamente.
// - No navega por sí misma tras el submit.
// - No administra el estado operativo interno del controller.
//
// DECISIONES CLAVE:
// - La pantalla confirma visualmente el snapshot real, no labels decorativos.
// - El error de contrato vive en la page; el error operativo vive en el controller.
// - La inicialización del flujo ocurre una sola vez en initState().
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/spacing.dart';
import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../controllers/insurance/rc_quote_request_controller.dart';

/// Contrato recomendado para abrir la pantalla de solicitud de cotización.
///
/// NOTA:
/// Cuando este contrato ya sea usado desde rutas, bindings y otros puntos
/// del flujo, conviene moverlo a un archivo compartido de args/contracts.
class RcQuoteRequestArgs {
  final String assetId;
  final VehicleSnapshot vehicleSnapshot;
  final String? primaryLabel;
  final String? secondaryLabel;

  const RcQuoteRequestArgs({
    required this.assetId,
    required this.vehicleSnapshot,
    this.primaryLabel,
    this.secondaryLabel,
  });
}

class RcQuoteRequestPage extends StatefulWidget {
  const RcQuoteRequestPage({super.key});

  @override
  State<RcQuoteRequestPage> createState() => _RcQuoteRequestPageState();
}

class _RcQuoteRequestPageState extends State<RcQuoteRequestPage> {
  late final RcQuoteRequestController _ctrl;

  RcQuoteRequestArgs? _args;
  String? _contractError;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<RcQuoteRequestController>();
    _bootstrap();
  }

  void _bootstrap() {
    final resolved = _resolveArgs(Get.arguments);

    if (resolved == null) {
      _contractError =
          'No se recibió información válida del vehículo para solicitar la cotización.';
      return;
    }

    _args = resolved;
    _contractError = null;

    _ctrl.configureResolvedData(
      assetId: resolved.assetId.trim(),
      primaryLabel: _buildPrimaryLabel(resolved),
      secondaryLabel: _buildSecondaryLabel(resolved),
      vehicleSnapshot: resolved.vehicleSnapshot,
    );
  }

  RcQuoteRequestArgs? _resolveArgs(dynamic raw) {
    if (raw is RcQuoteRequestArgs) {
      return _isArgsUsable(raw) ? raw : null;
    }

    // Compatibilidad temporal con contrato legacy basado en Map.
    if (raw is Map) {
      final assetId = raw['assetId']?.toString().trim() ?? '';
      final snapshot = raw['vehicleSnapshot'];

      if (snapshot is! VehicleSnapshot) return null;

      final args = RcQuoteRequestArgs(
        assetId: assetId,
        vehicleSnapshot: snapshot,
        primaryLabel: raw['primaryLabel']?.toString().trim(),
        secondaryLabel: raw['secondaryLabel']?.toString().trim(),
      );

      return _isArgsUsable(args) ? args : null;
    }

    return null;
  }

  bool _isArgsUsable(RcQuoteRequestArgs args) {
    return args.assetId.trim().isNotEmpty &&
        _isSnapshotUsable(args.vehicleSnapshot);
  }

  bool _isSnapshotUsable(VehicleSnapshot snapshot) {
    final maxAllowedYear = DateTime.now().year + 1;

    // vehicleClass y service son campos RUNT-enriquecidos opcionales.
    // No se validan aquí — el backend decide si los requiere.
    // Solo validamos los campos de identidad del vehículo.
    return snapshot.plate.trim().isNotEmpty &&
        snapshot.brand.trim().isNotEmpty &&
        snapshot.model.trim().isNotEmpty &&
        snapshot.year >= 1900 &&
        snapshot.year <= maxAllowedYear;
  }

  String _buildPrimaryLabel(RcQuoteRequestArgs args) {
    final custom = args.primaryLabel?.trim();
    if (custom != null && custom.isNotEmpty) return custom;

    final plate = args.vehicleSnapshot.plate.trim().toUpperCase();
    return plate.isNotEmpty ? plate : 'Vehículo';
  }

  String? _buildSecondaryLabel(RcQuoteRequestArgs args) {
    final custom = args.secondaryLabel?.trim();
    if (custom != null && custom.isNotEmpty) return custom;

    final snapshot = args.vehicleSnapshot;
    final parts = <String>[
      if (snapshot.brand.trim().isNotEmpty) snapshot.brand.trim(),
      if (snapshot.model.trim().isNotEmpty) snapshot.model.trim(),
      if (snapshot.year > 0) snapshot.year.toString(),
    ];

    return parts.isEmpty ? null : parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
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
          'Solicitar cotización',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_args != null) ...[
              _VehicleSnapshotCard(
                snapshot: _args!.vehicleSnapshot,
                primaryLabel: _buildPrimaryLabel(_args!),
                secondaryLabel: _buildSecondaryLabel(_args!),
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _InfoCard(cs: cs, theme: theme),
            const SizedBox(height: AppSpacing.xl),
            if (_contractError != null) ...[
              _ErrorBanner(
                message: _contractError!,
                cs: cs,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.md),
            ] else
              Obx(() {
                final runtimeError = _ctrl.errorMessage.value;

                if (runtimeError == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    _ErrorBanner(
                      message: runtimeError,
                      cs: cs,
                      theme: theme,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                );
              }),
            Obx(() {
              final loading = _ctrl.isLoading.value;
              final canSubmit =
                  _args != null && _contractError == null && !loading;

              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSubmit ? _ctrl.submitRequest : null,
                  child: loading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary,
                          ),
                        )
                      : const Text('Solicitar cotización'),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                'Un asesor revisará tu solicitud y te contactará.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VEHICLE SNAPSHOT CARD — Confirmación real del snapshot a enviar
// ─────────────────────────────────────────────────────────────────────────────

class _VehicleSnapshotCard extends StatelessWidget {
  final VehicleSnapshot snapshot;
  final String primaryLabel;
  final String? secondaryLabel;
  final ColorScheme cs;
  final ThemeData theme;

  const _VehicleSnapshotCard({
    required this.snapshot,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final plate = snapshot.plate.trim().toUpperCase();
    final brand = snapshot.brand.trim();
    final model = snapshot.model.trim();
    final year = snapshot.year > 0 ? snapshot.year.toString() : '—';
    final vehicleClass = snapshot.vehicleClass.trim();
    final service = snapshot.service.trim();

    final title = plate.isNotEmpty ? plate : primaryLabel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_car_rounded,
                size: 20,
                color: cs.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Vehículo a cotizar',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (secondaryLabel != null && secondaryLabel!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              secondaryLabel!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _DataRowItem(
            label: 'Marca',
            value: brand,
            theme: theme,
            cs: cs,
          ),
          _DataRowItem(
            label: 'Modelo',
            value: model,
            theme: theme,
            cs: cs,
          ),
          _DataRowItem(
            label: 'Año',
            value: year,
            theme: theme,
            cs: cs,
          ),
          _DataRowItem(
            label: 'Clase',
            value: vehicleClass,
            theme: theme,
            cs: cs,
          ),
          _DataRowItem(
            label: 'Servicio',
            value: service,
            theme: theme,
            cs: cs,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _DataRowItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final ColorScheme cs;
  final bool isLast;

  const _DataRowItem({
    required this.label,
    required this.value,
    required this.theme,
    required this.cs,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = value.trim().isNotEmpty ? value.trim() : '—';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: cs.outline.withValues(alpha: 0.10),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              safeValue,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO CARD
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final ColorScheme cs;
  final ThemeData theme;

  const _InfoCard({
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RC Extracontractual (SRCE)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _BulletItem(
            text: 'Cubre daños a terceros no contemplados en el SOAT.',
            cs: cs,
            theme: theme,
          ),
          _BulletItem(
            text: 'Cotización sin costo — un asesor te contactará.',
            cs: cs,
            theme: theme,
          ),
          _BulletItem(
            text: 'Proceso 100% digital desde la plataforma.',
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  final ThemeData theme;

  const _BulletItem({
    required this.text,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 14,
              color: cs.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
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
          Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: cs.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// lib/presentation/pages/asset/soat_detail_page.dart
// SOAT DETAIL PAGE — Detalle de pólizas SOAT de un activo vehicular
//
// QUÉ HACE:
// - Carga todas las pólizas InsurancePolicyEntity del activo filtrando por
//   policyType == InsurancePolicyType.soat.
// - Muestra la póliza con mayor fechaFin destacada en la parte superior
//   con su estado de vigencia calculado dinámicamente.
// - Muestra historial completo de pólizas SOAT ordenado por fechaFin desc.
// - Calcula vigencia por fecha calendario local (.toLocal()) para evitar
//   off-by-one por timezone/UTC.
//
// QUÉ NO HACE:
// - No accede al RUNT en tiempo real.
// - No modifica repositorios ni dominio.
// - No usa GetX controller propio (StatefulWidget con carga async, patrón
//   consistente con RtmDetailPage y AssetDetailPage).
// - No muestra datos de otros tipos de póliza (RC, Todo Riesgo, etc.).
// - No confía en policy.estado persistido (puede estar stale).
//
// PRINCIPIOS:
// - StatefulWidget con _loadData() en initState y try/catch explícito.
// - Estados discriminados: loading, invalidArg, loadError, noPolicies, ready.
// - Vigencia calculada desde fechaFin.toLocal() por fecha calendario local.
// - Theme-only: cero colores hardcodeados.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Track A — Detail page específica para SOAT. Parte del
//   saneamiento del modelo de seguros. Complementa los tiles del grid de
//   estado del vehículo en AssetDetailPage.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/di/container.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/insurance/insurance_policy_entity.dart';
import '../../controllers/asset/asset_detail_runt_controller.dart';
import '../../widgets/asset_document_context_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ESTADO INTERNO DE CARGA
// ─────────────────────────────────────────────────────────────────────────────

enum _PageState { loading, invalidArg, loadError, noPolicies, ready }

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class SoatDetailPage extends StatefulWidget {
  const SoatDetailPage({super.key});

  @override
  State<SoatDetailPage> createState() => _SoatDetailPageState();
}

class _SoatDetailPageState extends State<SoatDetailPage> {
  /// Pólizas SOAT del activo, ordenadas por fechaFin descendente.
  List<InsurancePolicyEntity> _policies = [];
  _PageState _state = _PageState.loading;
  String _assetPrimaryLabel = '';
  String? _assetSecondaryLabel;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    String? assetId;
    if (args is Map) {
      // Entry point: AlertCenter — labels viajan en el Map junto al assetId.
      assetId = args['assetId'] as String?;
      _assetPrimaryLabel = (args['primaryLabel'] as String?) ?? '';
      _assetSecondaryLabel = args['secondaryLabel'] as String?;
    } else if (args is String && args.isNotEmpty) {
      // Entry point: AssetDetailPage → labels desde AssetDetailRuntController.
      assetId = args;
      try {
        final runtCtrl = Get.find<AssetDetailRuntController>();
        _assetPrimaryLabel = runtCtrl.vehiclePrimaryLabel;
        _assetSecondaryLabel = runtCtrl.vehicleSecondaryLabel;
      } catch (_) {}
    }
    if (assetId != null && assetId.isNotEmpty) {
      _loadData(assetId);
    } else {
      _state = _PageState.invalidArg;
    }
  }

  /// Carga todas las pólizas del activo y filtra las de tipo SOAT.
  Future<void> _loadData(String assetId) async {
    try {
      final all = await DIContainer()
          .insuranceRepository
          .fetchPoliciesByAsset(assetId);

      if (!mounted) return;

      final soats = all
          .where((p) => p.policyType == InsurancePolicyType.soat)
          .toList()
        ..sort((a, b) => b.fechaFin.compareTo(a.fechaFin));

      setState(() {
        _policies = soats;
        _state =
            soats.isEmpty ? _PageState.noPolicies : _PageState.ready;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SOAT_DETAIL][_loadData] Error: $e');
      }
      if (!mounted) return;
      setState(() => _state = _PageState.loadError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
          'SOAT',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_assetPrimaryLabel.isNotEmpty)
            AssetDocumentContextHeader(
              primaryLabel: _assetPrimaryLabel,
              secondaryLabel: _assetSecondaryLabel,
              sectionTitle: 'SOAT',
            ),
          Expanded(
            child: switch (_state) {
              _PageState.loading => const _LoadingState(),
              _PageState.invalidArg => _MessageState(
                  icon: Icons.link_off_rounded,
                  iconColor: cs.error,
                  title: 'Navegación inválida',
                  body: 'No se recibió el identificador del activo. '
                      'Regresa e intenta de nuevo.',
                ),
              _PageState.loadError => _MessageState(
                  icon: Icons.error_outline_rounded,
                  iconColor: cs.error,
                  title: 'Error al cargar',
                  body: 'No fue posible obtener las pólizas SOAT. '
                      'Intenta volver e ingresar de nuevo.',
                ),
              _PageState.noPolicies => _MessageState(
                  icon: Icons.shield_outlined,
                  iconColor: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  title: 'Sin pólizas SOAT',
                  body: 'Este vehículo no tiene registros SOAT disponibles. '
                      'Los datos aparecen cuando el vehículo es consultado '
                      'en el RUNT durante el proceso de registro.',
                ),
              _PageState.ready => _SoatContent(
                  policies: _policies,
                  cs: cs,
                  theme: theme,
                ),
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENT — Lista de pólizas con póliza más reciente destacada
// ─────────────────────────────────────────────────────────────────────────────

class _SoatContent extends StatelessWidget {
  final List<InsurancePolicyEntity> policies;
  final ColorScheme cs;
  final ThemeData theme;

  const _SoatContent({
    required this.policies,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final latest = policies.first;
    final historial = policies.skip(1).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      children: [
        // La póliza con mayor fechaFin (puede o no estar vigente)
        _SectionLabel(label: 'Póliza más reciente', cs: cs, theme: theme),
        const SizedBox(height: AppSpacing.sm),
        _PolicyCard(policy: latest, isHighlighted: true, cs: cs, theme: theme),

        if (historial.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _SectionLabel(
              label: 'Historial (${historial.length})',
              cs: cs,
              theme: theme),
          const SizedBox(height: AppSpacing.sm),
          for (final p in historial) ...[
            _PolicyCard(
                policy: p,
                isHighlighted: false,
                cs: cs,
                theme: theme),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POLICY CARD — Tarjeta individual de póliza SOAT
// ─────────────────────────────────────────────────────────────────────────────

class _PolicyCard extends StatelessWidget {
  final InsurancePolicyEntity policy;
  final bool isHighlighted;
  final ColorScheme cs;
  final ThemeData theme;

  const _PolicyCard({
    required this.policy,
    required this.isHighlighted,
    required this.cs,
    required this.theme,
  });

  /// Calcula vigencia por fecha calendario local.
  ///
  /// Ambas fechas se normalizan a medianoche local con .toLocal() para evitar
  /// off-by-one por timezone/UTC (especialmente en dispositivos configurados
  /// en zonas horarias negativas respecto a la fecha UTC del registro).
  _VigenciaInfo _resolveVigencia() {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);
    final finLocal = policy.fechaFin.toLocal();
    final fin = DateTime(finLocal.year, finLocal.month, finLocal.day);
    final days = fin.difference(hoy).inDays;

    if (days < 0) {
      return _VigenciaInfo(
        label:
            'Vencida hace ${days.abs()} día${days.abs() == 1 ? '' : 's'}',
        badgeText: 'Vencida',
        color: cs.error,
      );
    }
    if (days == 0) {
      return _VigenciaInfo(
        label: 'Vence hoy',
        badgeText: 'Por vencer',
        color: cs.secondary,
      );
    }
    if (days <= 30) {
      return _VigenciaInfo(
        label: 'Vence en $days día${days == 1 ? '' : 's'}',
        badgeText: 'Por vencer',
        color: cs.secondary,
      );
    }
    return _VigenciaInfo(
      label: 'Vence en $days días',
      badgeText: 'Vigente',
      color: cs.tertiary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy', 'es_CO');
    final vigencia = _resolveVigencia();
    final aseguradoraDisplay = policy.aseguradora.trim().isNotEmpty
        ? policy.aseguradora.trim()
        : 'Sin datos de aseguradora';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isHighlighted
            ? cs.surfaceContainerLow
            : cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? vigencia.color.withValues(alpha: 0.25)
              : cs.outline.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aseguradora + badge de estado
          Row(
            children: [
              Expanded(
                child: Text(
                  aseguradoraDisplay,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              _StatusBadge(
                  label: vigencia.badgeText,
                  color: vigencia.color,
                  theme: theme),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Días restantes / vencida
          Text(
            vigencia.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: vigencia.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Fechas — .toLocal() para evitar corrimiento por UTC
          _DateRow(
            icon: Icons.event_available_outlined,
            label: 'Inicio',
            value: fmt.format(policy.fechaInicio.toLocal()),
            cs: cs,
            theme: theme,
          ),
          const SizedBox(height: 4),
          _DateRow(
            icon: Icons.event_outlined,
            label: 'Vencimiento',
            value: fmt.format(policy.fechaFin.toLocal()),
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  const _SectionLabel(
      {required this.label, required this.cs, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final ThemeData theme;

  const _StatusBadge(
      {required this.label, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 14, color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: theme.textTheme.labelSmall
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _MessageState({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
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
// VALUE OBJECT INTERNO — datos de vigencia calculada
// ─────────────────────────────────────────────────────────────────────────────

class _VigenciaInfo {
  final String label;
  final String badgeText;
  final Color color;

  const _VigenciaInfo({
    required this.label,
    required this.badgeText,
    required this.color,
  });
}

// ============================================================================
// lib/presentation/pages/asset/simit_fine_detail_page.dart
// SIMIT FINE DETAIL PAGE — Ítems individuales SIMIT filtrados por tipo
//
// QUÉ HACE:
// - Muestra los ítems individuales de simit.fines[] filtrados por tipo
//   (comparendos, multas o acuerdosDePago), con id y valorAPagar de cada uno.
// - Muestra el resumen del tipo seleccionado (count + total) desde byType.
// - Distingue el estado vacío explícitamente: "sin registros de este tipo".
//
// QUÉ NO HACE:
// - No hace HTTP. No accede a repositorio.
// - No tiene controller propio — todos los datos vienen de Get.arguments.
//
// PRINCIPIOS:
// - StatelessWidget: datos read-only desde Get.arguments Map.
// - checkedAt fallback a DateTime.now() si llega null (navegación directa).
// - Filtro de tipo usa toLowerCase() para resiliencia a variaciones del backend.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase SIMIT-2 — Desglose por tipo con ítems individuales.
// CONTRACT: Get.toNamed(Routes.simitFineDetail,
//   arguments: {'data': VrcDataModel, 'type': String, 'checkedAt': DateTime?})
//   type: 'comparendos' | 'multas' | 'acuerdosDePago'
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/vrc/models/vrc_models.dart';

class SimitFineDetailPage extends StatelessWidget {
  const SimitFineDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final data = args?['data'] as VrcDataModel?;
    final type = args?['type'] as String? ?? 'comparendos';

    if (data == null) {
      return _ErrorScaffold(
        title: _labelFor(type),
        message: 'No se pudo obtener los datos del propietario.',
      );
    }

    final owner = data.owner;
    final simit = owner?.simit;
    final summary = simit?.summary;
    final byTypeEntry = _byTypeFor(type, summary?.byType);
    final fines = _filteredFines(type, simit?.fines ?? const []);

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
          _labelFor(type),
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        children: [
          // Header: nombre y documento del propietario
          _OwnerBlock(owner: owner, theme: theme, cs: cs),
          const SizedBox(height: AppSpacing.md),

          // Resumen del tipo seleccionado
          _TypeSummaryCard(
            type: type,
            byTypeEntry: byTypeEntry,
            theme: theme,
            cs: cs,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Lista de ítems individuales
          if (fines.isEmpty) ...[
            _EmptyState(type: type, theme: theme, cs: cs),
          ] else ...[
            Text(
              'Detalle',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...fines.map((fine) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _FineItemCard(fine: fine, type: type, theme: theme, cs: cs),
                )),
          ],
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Etiqueta de pantalla para cada tipo.
  static String _labelFor(String type) => switch (type) {
        'multas' => 'Multas',
        'acuerdosDePago' => 'Acuerdos de pago',
        _ => 'Comparendos',
      };

  /// Extrae el VrcSimitTypeCountModel correspondiente al tipo seleccionado.
  static VrcSimitTypeCountModel? _byTypeFor(
      String type, VrcSimitByTypeModel? byType) {
    if (byType == null) return null;
    return switch (type) {
      'multas' => byType.multas,
      'acuerdosDePago' => byType.acuerdosDePago,
      _ => byType.comparendos,
    };
  }

  /// Filtra la lista global de fines[] por tipo.
  ///
  /// FALLBACK cuando tipo es null en todos los ítems (backend aún no lo envía):
  /// Se asigna la lista completa a 'comparendos' (tipo mayoritario en la práctica)
  /// y vacío a 'multas' y 'acuerdosDePago'.
  /// Una vez el backend envíe 'tipo', el filtro por string tomará precedencia.
  static List<VrcSimitFineModel> _filteredFines(
      String type, List<VrcSimitFineModel> all) {
    if (all.isEmpty) return const [];

    // Si ningún ítem tiene tipo, el backend no lo envía aún — usar fallback.
    final hasTipoData = all.any((f) => f.tipo != null && f.tipo!.isNotEmpty);
    if (!hasTipoData) {
      // Sin campo tipo: todos los ítems van a comparendos (tipo predominante real).
      return type == 'comparendos' ? List.unmodifiable(all) : const [];
    }

    return all.where((f) {
      final t = f.tipo?.toLowerCase() ?? '';
      return switch (type) {
        'multas' => t.contains('multa'),
        'acuerdosDePago' => t.contains('acuerdo'),
        _ => t.contains('comparendo'),
      };
    }).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OWNER BLOCK
// ─────────────────────────────────────────────────────────────────────────────

class _OwnerBlock extends StatelessWidget {
  final VrcOwnerModel? owner;
  final ThemeData theme;
  final ColorScheme cs;

  const _OwnerBlock({required this.owner, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final name = owner?.name ?? 'Propietario';
    final type = owner?.documentType?.trim().toUpperCase();
    final number = owner?.document?.trim();
    final doc = (type != null && type.isNotEmpty && number != null && number.isNotEmpty)
        ? '$type $number'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (doc != null)
          Text(
            doc,
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPE SUMMARY CARD — resumen del tipo seleccionado (count + total)
// ─────────────────────────────────────────────────────────────────────────────

class _TypeSummaryCard extends StatelessWidget {
  final String type;
  final VrcSimitTypeCountModel? byTypeEntry;
  final ThemeData theme;
  final ColorScheme cs;

  const _TypeSummaryCard({
    required this.type,
    required this.byTypeEntry,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final count = byTypeEntry?.count ?? 0;
    final total = byTypeEntry?.total;
    final hasItems = count > 0;
    final icon = _iconFor(type);

    return Card(
      elevation: 1,
      color: hasItems
          ? cs.errorContainer.withValues(alpha: 0.35)
          : cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36,
              color: hasItems ? cs.error : cs.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasItems ? '$count registro${count != 1 ? 's' : ''}' : 'Sin registros',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: hasItems ? cs.error : Colors.green.shade600,
                    ),
                  ),
                  if (hasItems && total != null && total > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatCop(total),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  Text(
                    hasItems
                        ? 'Valor total de ${SimitFineDetailPage._labelFor(type).toLowerCase()}'
                        : 'No hay ${SimitFineDetailPage._labelFor(type).toLowerCase()} registradas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: hasItems
                          ? cs.onSurface.withValues(alpha: 0.7)
                          : Colors.green.shade700,
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

  IconData _iconFor(String type) => switch (type) {
        'multas' => Icons.monetization_on_outlined,
        'acuerdosDePago' => Icons.handshake_outlined,
        _ => Icons.receipt_long_outlined,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// FINE ITEM CARD — ítem individual de multa/comparendo/acuerdo
// ─────────────────────────────────────────────────────────────────────────────

class _FineItemCard extends StatelessWidget {
  final VrcSimitFineModel fine;
  final String type;
  final ThemeData theme;
  final ColorScheme cs;

  const _FineItemCard({
    required this.fine,
    required this.type,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final id = fine.id ?? '—';
    final valor = fine.valorAPagar;
    final hasSeverityHigh = fine.severity?.toUpperCase() == 'HIGH' ||
        fine.severity?.toUpperCase() == 'CRITICAL';
    final severityColor = _severityColor(context, fine.severity);

    return Card(
      elevation: 0,
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: hasSeverityHigh
            ? BorderSide(color: cs.error.withValues(alpha: 0.3))
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: ID + valor a pagar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ID de la infracción
                      Text(
                        id,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: 0.3,
                        ),
                      ),
                      // Código de infracción + severity
                      if (fine.infraccion != null || fine.severity != null)
                        Row(
                          children: [
                            if (fine.infraccion != null)
                              Container(
                                margin: const EdgeInsets.only(top: 3, right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: severityColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  fine.infraccion!,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: severityColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            if (fine.severity != null)
                              Text(
                                _severityLabel(fine.severity),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: severityColor,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (valor != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _formatCop(valor),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.error,
                    ),
                  ),
                ],
              ],
            ),

            // Separador
            if (fine.ciudad != null || fine.fecha != null || fine.estado != null) ...[
              const SizedBox(height: AppSpacing.xs),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.xs),
            ],

            // Metadata: fecha, ciudad, estado
            if (fine.fecha != null || fine.ciudad != null)
              Row(
                children: [
                  if (fine.fecha != null) ...[
                    Icon(Icons.calendar_today_outlined,
                        size: 11, color: cs.onSurfaceVariant),
                    const SizedBox(width: 3),
                    Text(
                      fine.fecha!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant),
                    ),
                  ],
                  if (fine.ciudad != null) ...[
                    if (fine.fecha != null) const SizedBox(width: 8),
                    Icon(Icons.location_on_outlined,
                        size: 11, color: cs.onSurfaceVariant),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        fine.ciudad!,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            if (fine.estado != null) ...[
              const SizedBox(height: 2),
              Text(
                fine.estado!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _severityColor(BuildContext context, String? severity) {
    final cs = Theme.of(context).colorScheme;
    return switch (severity?.toUpperCase()) {
      'CRITICAL' => cs.error,
      'HIGH' => cs.error.withValues(alpha: 0.8),
      'MEDIUM' => Colors.orange.shade700,
      'LOW' => Colors.amber.shade700,
      _ => cs.onSurfaceVariant,
    };
  }

  String _severityLabel(String? severity) => switch (severity?.toUpperCase()) {
        'CRITICAL' => 'Crítico',
        'HIGH' => 'Alto',
        'MEDIUM' => 'Medio',
        'LOW' => 'Bajo',
        _ => '',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE — sin registros de este tipo
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String type;
  final ThemeData theme;
  final ColorScheme cs;

  const _EmptyState({required this.type, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 48,
            color: Colors.green.shade400,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Sin ${SimitFineDetailPage._labelFor(type).toLowerCase()}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No se encontraron registros de este tipo para este propietario.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR SCAFFOLD — navegación inválida
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  final String title;
  final String message;

  const _ErrorScaffold({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.link_off_rounded, size: 48, color: cs.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

/// Formato monetario colombiano (COP): $1.787.641
String _formatCop(num amount) {
  final str = amount.toInt().abs().toString();
  final formatted = str.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  return '\$$formatted';
}

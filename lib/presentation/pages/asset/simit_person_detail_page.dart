// ============================================================================
// lib/presentation/pages/asset/simit_person_detail_page.dart
// SIMIT PERSON DETAIL PAGE — Estado de cuenta SIMIT Persona del propietario
//
// QUÉ HACE:
// - Muestra el total consolidado + lista unificada de fines[] con filtro por tipo.
// - Tabs: Todos | Comparendos | Multas | Acuerdos de pago (con conteos).
// - Cada ítem muestra tipo-badge coloreado, ID, ciudad, infraccion, estado, valor.
// - Badge de frescura (shouldRefreshSimit) en el header de resumen.
//
// QUÉ NO HACE:
// - No hace HTTP. No accede a repositorio.
// - No tiene controller propio — todos los datos vienen de Get.arguments.
//
// PRINCIPIOS:
// - StatefulWidget para el estado del tab activo (índice de filtro).
// - checkedAt fallback a DateTime.now() si llega null (navegación directa).
// - Filtrado de tipo usa toLowerCase() + fallback cuando tipo es null.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase SIMIT-1 — Visualización mejorada.
// REDISEÑADO (2026-04): Fase SIMIT-2 — Lista unificada con tabs de filtro.
// CONTRACT: Get.toNamed(Routes.simitPersonDetail,
//   arguments: {'data': VrcDataModel, 'checkedAt': DateTime?})
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../core/platform/owner_refresh_service.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/simit_freshness_policy.dart';
import '../../../data/vrc/models/vrc_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

class SimitPersonDetailPage extends StatefulWidget {
  const SimitPersonDetailPage({super.key});

  @override
  State<SimitPersonDetailPage> createState() => _SimitPersonDetailPageState();
}

class _SimitPersonDetailPageState extends State<SimitPersonDetailPage> {
  // 0 = Todos, 1 = Comparendos, 2 = Multas, 3 = Acuerdos
  int _tabIndex = 0;

  // Estado mutable para refresh — se inicializa desde Get.arguments,
  // se actualiza in-place tras refresh exitoso.
  VrcDataModel? _data;
  DateTime _checkedAt = DateTime.now();
  String? _portfolioId;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _data = args?['data'] as VrcDataModel?;
    _checkedAt = args?['checkedAt'] as DateTime? ?? DateTime.now();
    _portfolioId = args?['portfolioId'] as String?;
  }

  /// Refresh manual: invalida cache → consulta API fresca → persiste → rebuild.
  ///
  /// El OwnerRefreshService se ejecuta como singleton en DIContainer —
  /// si el usuario navega fuera, la persistencia completa igualmente.
  /// Al volver, los datos frescos se leen desde el portfolio snapshot.
  Future<void> _handleRefresh() async {
    final document = _data?.owner?.document;
    if (document == null || document.isEmpty || _portfolioId == null) return;

    setState(() => _isRefreshing = true);

    final result = await DIContainer().ownerRefreshService.refreshSimit(
          portfolioId: _portfolioId!,
          document: document,
        );

    if (!mounted) return; // Widget destruido — datos ya persistidos.

    setState(() {
      _isRefreshing = false;
      if (result is RefreshSuccess<VrcOwnerSimitModel>) {
        // Actualizar datos locales para rebuild inmediato.
        _checkedAt = result.refreshedAt;
        final currentOwner = _data?.owner;
        _data = VrcDataModel(
          owner: VrcOwnerModel(
            name: currentOwner?.name,
            document: currentOwner?.document,
            documentType: currentOwner?.documentType,
            runt: currentOwner?.runt,
            simit: result.data,
          ),
        );
      }
    });

    if (result is RefreshError) {
      final err = result as RefreshError;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.isExternal
                  ? 'No se pudo conectar con SIMIT. Intenta más tarde.'
                  : 'Error al actualizar datos SIMIT.',
            ),
          ),
        );
      }
    } else if (result is RefreshSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos SIMIT actualizados')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;

    if (data == null) {
      return const _ErrorScaffold(
        message: 'No se pudo obtener los datos del propietario.',
      );
    }

    final owner = data.owner;
    final simit = owner?.simit;
    final summary = simit?.summary;
    final allFines = simit?.fines ?? const [];

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Conteos por tipo desde byType (fuente de verdad)
    final countComp =
        summary?.byType?.comparendos?.count ?? summary?.comparendos ?? 0;
    final countMultas =
        summary?.byType?.multas?.count ?? summary?.multas ?? 0;
    final countAcuerdos = summary?.byType?.acuerdosDePago?.count ??
        summary?.paymentAgreementsCount ??
        0;
    final countTotal = summary?.finesCount ??
        (countComp + countMultas + countAcuerdos);

    final filteredFines = _filterFines(_tabIndex, allFines);

    // Escenario "solo resumen" — registro legacy sin simitDetailJson blob:
    // summary existe con hasFines=true pero fines[] vacío porque el blob
    // no fue persistido (portfolio creado antes del campo simitDetailJson).
    // Portfolios nuevos tienen blob → fines[] rehidratado → nunca llegan aquí.
    final isSummaryOnly =
        summary != null && (summary.hasFines ?? false) && allFines.isEmpty;

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
          'SIMIT — Estado de cuenta',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          // Botón de refresh manual — usa identidad ya conocida del propietario.
          if (owner?.document != null)
            IconButton(
              onPressed: _isRefreshing ? null : _handleRefresh,
              icon: _isRefreshing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
              tooltip: 'Actualizar datos SIMIT',
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header fijo: owner + resumen total ─────────────────────────────
          _SummaryHeader(
            owner: owner,
            summary: summary,
            checkedAt: _checkedAt,
            theme: theme,
            cs: cs,
          ),

          // ── Timestamp de última actualización ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 4),
            child: Text(
              'Última actualización: ${_formatTimestamp(_checkedAt)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),

          // ── Tabs de filtro ─────────────────────────────────────────────────
          // En modo summary-only (legacy sin blob) los tabs muestran conteos
          // reales pero no son interactivos (no hay lista que filtrar).
          if (summary != null) ...[
            _FilterTabBar(
              selected: isSummaryOnly ? -1 : _tabIndex,
              countTotal: countTotal,
              countComp: countComp,
              countMultas: countMultas,
              countAcuerdos: countAcuerdos,
              onSelected: isSummaryOnly
                  ? (_) {}
                  : (i) => setState(() => _tabIndex = i),
              theme: theme,
              cs: cs,
            ),
            const Divider(height: 1),
          ],

          // ── Body ───────────────────────────────────────────────────────────
          Expanded(
            child: summary == null
                ? _NoDataState(theme: theme, cs: cs)
                : isSummaryOnly
                    ? _SummaryOnlyState(theme: theme, cs: cs)
                    : filteredFines.isEmpty
                        ? _EmptyFilter(
                            tabIndex: _tabIndex, theme: theme, cs: cs)
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.md,
                            ),
                            itemCount:
                                filteredFines.length + 1, // +1 for CTA
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, i) {
                              if (i == filteredFines.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppSpacing.md),
                                  child: _SimitCta(theme: theme, cs: cs),
                                );
                              }
                              return _FineItemCard(
                                fine: filteredFines[i],
                                theme: theme,
                                cs: cs,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  /// Formato amigable 12h: "16/04/2026, 12:52 p. m."
  String _formatTimestamp(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    final h = d.hour == 0
        ? 12
        : d.hour > 12
            ? d.hour - 12
            : d.hour;
    final min = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour < 12 ? 'a. m.' : 'p. m.';
    return '$dd/$mm/$yyyy, $h:$min $ampm';
  }

  // ── Filtro de fines por tab ───────────────────────────────────────────────

  List<VrcSimitFineModel> _filterFines(
      int tabIndex, List<VrcSimitFineModel> all) {
    if (tabIndex == 0) return all; // Todos

    // Si ningún ítem tiene tipo, backend aún no lo envía → todo en Comparendos
    final hasTipo = all.any((f) => f.tipo != null && f.tipo!.isNotEmpty);
    if (!hasTipo) {
      return tabIndex == 1 ? all : const [];
    }

    return all.where((f) {
      final t = f.tipo?.toLowerCase() ?? '';
      return switch (tabIndex) {
        2 => t.contains('multa'),
        3 => t.contains('acuerdo'),
        _ => t.contains('comparendo'),
      };
    }).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUMMARY HEADER — owner + total consolidado + frescura
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryHeader extends StatelessWidget {
  final VrcOwnerModel? owner;
  final VrcSimitSummaryModel? summary;
  final DateTime checkedAt;
  final ThemeData theme;
  final ColorScheme cs;

  const _SummaryHeader({
    required this.owner,
    required this.summary,
    required this.checkedAt,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final name = owner?.name ?? 'Propietario';
    final docType = owner?.documentType?.trim().toUpperCase();
    final docNumber = owner?.document?.trim();
    final doc = (docType != null &&
            docType.isNotEmpty &&
            docNumber != null &&
            docNumber.isNotEmpty)
        ? '$docType $docNumber'
        : null;

    final hasFines = summary?.hasFines ?? false;
    final totalText = summary == null
        ? '—'
        : (summary!.formattedTotal ??
            (summary!.total != null ? _formatCop(summary!.total!) : '—'));

    SimitFreshnessResult? freshness;
    if (summary != null) {
      freshness = shouldRefreshSimit(
        ownerVehicleCount: 0,
        comparendosCount:
            summary!.byType?.comparendos?.count ?? summary!.comparendos ?? 0,
        multasCount:
            summary!.byType?.multas?.count ?? summary!.multas ?? 0,
        lastCheckedAt: checkedAt,
      );
    }

    return Container(
      color: cs.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (doc != null)
                  Text(
                    doc,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                const SizedBox(height: 4),
                // Total consolidado
                Text(
                  totalText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: hasFines ? cs.error : Colors.green.shade600,
                  ),
                ),
                Text(
                  hasFines ? 'Total a pagar' : 'Sin obligaciones registradas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: hasFines ? cs.onSurfaceVariant : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                hasFines
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                size: 24,
                color: hasFines ? cs.error : Colors.green.shade600,
              ),
              if (freshness != null) ...[
                const SizedBox(height: 4),
                _FreshnessBadge(level: freshness.level),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER TAB BAR — chips horizontales con conteo por tipo
// ─────────────────────────────────────────────────────────────────────────────

class _FilterTabBar extends StatelessWidget {
  final int selected;
  final int countTotal;
  final int countComp;
  final int countMultas;
  final int countAcuerdos;
  final ValueChanged<int> onSelected;
  final ThemeData theme;
  final ColorScheme cs;

  const _FilterTabBar({
    required this.selected,
    required this.countTotal,
    required this.countComp,
    required this.countMultas,
    required this.countAcuerdos,
    required this.onSelected,
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('Todos', countTotal),
      ('Comp.', countComp),
      ('Multas', countMultas),
      ('Acuerdos', countAcuerdos),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final (label, count) = tabs[i];
          final isActive = selected == i;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? cs.primary : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$label ($count)',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FINE ITEM CARD — ítem individual con badge de tipo, detalles y valor
// ─────────────────────────────────────────────────────────────────────────────

class _FineItemCard extends StatelessWidget {
  final VrcSimitFineModel fine;
  final ThemeData theme;
  final ColorScheme cs;

  const _FineItemCard(
      {required this.fine, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final (typeLabel, typeBg, typeFg) = _typeStyle(context, fine.tipo);
    final valor = fine.valorAPagar ?? fine.valor;

    return Card(
      elevation: 0,
      color: cs.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: badge tipo + valor
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: typeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    typeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: typeFg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                if (valor != null)
                  Text(
                    _formatCop(valor),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Fila 2: ID + ciudad
            Row(
              children: [
                Expanded(
                  child: Text(
                    fine.id ?? '—',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (fine.ciudad != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.location_on_outlined,
                      size: 12, color: cs.onSurfaceVariant),
                  const SizedBox(width: 2),
                  Text(
                    fine.ciudad!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ],
            ),

            // Fila 3: infraccion · estado
            if (fine.infraccion != null || fine.estado != null) ...[
              const SizedBox(height: 2),
              Text(
                [
                  if (fine.infraccion != null) fine.infraccion!,
                  if (fine.estado != null) fine.estado!,
                ].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Badge de tipo: label + colores según tipo de infracción.
  (String, Color, Color) _typeStyle(BuildContext context, String? tipo) {
    final cs = Theme.of(context).colorScheme;
    final t = tipo?.toLowerCase() ?? '';
    if (t.contains('multa')) {
      return ('MULTA', cs.errorContainer, cs.onErrorContainer);
    }
    if (t.contains('acuerdo')) {
      return (
        'ACUERDO DE PAGO',
        Colors.green.shade100,
        Colors.green.shade800,
      );
    }
    // Comparendo o sin tipo
    return (
      'COMPARENDO',
      Colors.orange.shade100,
      Colors.orange.shade800,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FRESHNESS BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _FreshnessBadge extends StatelessWidget {
  final SimitFreshnessLevel level;
  const _FreshnessBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (color, label) = switch (level) {
      SimitFreshnessLevel.fresh => (Colors.green.shade600, 'Actualizado'),
      SimitFreshnessLevel.stale => (Colors.orange.shade600, 'Por actualizar'),
      SimitFreshnessLevel.expired => (cs.error, 'Desactualizado'),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATES
// ─────────────────────────────────────────────────────────────────────────────

class _NoDataState extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _NoDataState({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 48, color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: AppSpacing.md),
            Text('Sin datos SIMIT',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'No fue posible obtener información SIMIT para este propietario.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUMMARY ONLY — snapshot Isar con agregados pero sin detalle itemizado
// ─────────────────────────────────────────────────────────────────────────────
//
// Escenario: el usuario navega al detalle SIMIT desde un snapshot persistido
// en Isar (OwnerSnapshotBand). Isar solo guarda resumen (hasFines, conteos,
// formattedTotal) — NO el array fines[]. El header ya muestra el total/conteos
// correctamente; este widget reemplaza la zona de lista con un desglose por
// tipo coherente con los datos disponibles, sin pretender mostrar detalle
// itemizado que no existe.

class _SummaryOnlyState extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;

  const _SummaryOnlyState({
    required this.theme,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    // Zona de lista reemplazada por nota informativa. El header ya muestra
    // total/conteos y los tabs/chips arriba muestran desglose por tipo.
    // No hay datos itemizados que renderizar — solo se deja claro que el
    // desglose individual requiere una nueva consulta.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 48, color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Detalle itemizado no disponible',
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'El resumen y los conteos por tipo se muestran arriba. '
              'Para ver el desglose individual de cada infracción, '
              'realiza una nueva consulta desde el portafolio.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFilter extends StatelessWidget {
  final int tabIndex;
  final ThemeData theme;
  final ColorScheme cs;
  const _EmptyFilter(
      {required this.tabIndex, required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    final labels = ['', 'comparendos', 'multas', 'acuerdos de pago'];
    final label = tabIndex < labels.length ? labels[tabIndex] : '';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded,
                size: 40, color: Colors.green.shade400),
            const SizedBox(height: AppSpacing.md),
            Text(
              label.isNotEmpty ? 'Sin $label registrados' : 'Sin registros',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA CARD
// ─────────────────────────────────────────────────────────────────────────────

class _SimitCta extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme cs;
  const _SimitCta({required this.theme, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cs.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent_outlined,
                    size: 20, color: cs.onPrimaryContainer),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Actúa antes de que el problema crezca',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Recibe orientación para entender tu situación y tomar decisiones '
              'informadas sobre tus comparendos o multas.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onPrimaryContainer.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Un asesor te contactará para orientarte en tu situación.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                    child: const Text('Recibir orientación'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Pronto estaremos conectando este servicio.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                    child: const Text('Solicitar información'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR SCAFFOLD
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  final String message;
  const _ErrorScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: const Text('SIMIT — Estado de cuenta'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.link_off_rounded, size: 48, color: cs.error),
              const SizedBox(height: AppSpacing.md),
              Text(message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
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

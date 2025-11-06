import 'package:flutter/material.dart';
import 'kpi_row.dart';
import 'status_chip.dart';

/// Item de lista para activos individuales con KPIs compactos.
/// SIN imágenes, usa iconografía + chips.
class AssetListItem extends StatelessWidget {
  final String identifier;
  final String subtitle;
  final IconData icon;
  final String status;
  final List<KpiData> kpis;
  final List<ActionData> actions;
  final VoidCallback? onTap;

  const AssetListItem({
    super.key,
    required this.identifier,
    required this.subtitle,
    required this.icon,
    required this.status,
    required this.kpis,
    this.actions = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: ícono + identificador + estado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, size: 20, color: cs.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          identifier,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.65),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const StatusChip(label: 'En uso', type: StatusType.inUse, isCompact: true),
                ],
              ),
              const SizedBox(height: 8),
              // KPIs en 2 columnas responsivas
              LayoutBuilder(
                builder: (context, constraints) {
                  final w = (constraints.maxWidth - 8) / 2;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: kpis.map((k) {
                      return SizedBox(
                        width: w,
                        child: KpiRow(
                          icon: k.icon,
                          value: k.value,
                          label: k.label,
                          isAlert: k.isAlert,
                          onTap: k.onTap,
                          statusChip: k.statusChip, // opcional
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Divider(height: 1, color: cs.outline.withOpacity(0.2)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                      .map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextButton(
                            onPressed: a.onPressed,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: const Size(0, 44),
                            ),
                            child: Text(a.label),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KpiData {
  final IconData icon;
  final String value;
  final String label;
  final bool isAlert;
  final VoidCallback? onTap;
  /// Chip opcional a la derecha del KPI (ej. "Al día").
  final Widget? statusChip;

  const KpiData({
    required this.icon,
    required this.value,
    required this.label,
    this.isAlert = false,
    this.onTap,
    this.statusChip,
  });
}

class ActionData {
  final String label;
  final VoidCallback onPressed;

  const ActionData({required this.label, required this.onPressed});
}

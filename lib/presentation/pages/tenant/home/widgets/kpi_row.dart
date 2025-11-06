import 'package:flutter/material.dart';

/// Fila KPI: icono + (valor/label) + chip opcional.
class KpiRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isAlert;
  final VoidCallback? onTap;
  final Widget? statusChip; // opcional

  const KpiRow({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.isAlert = false,
    this.onTap,
    this.statusChip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final iconColor = isAlert
        ? (cs.brightness == Brightness.dark ? Colors.amber.shade300 : Colors.amber.shade700)
        : cs.primary;
    final valueColor = isAlert
        ? (cs.brightness == Brightness.dark ? Colors.amber.shade300 : Colors.amber.shade700)
        : cs.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: valueColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (statusChip != null) ...[
              const SizedBox(width: 6),
              statusChip!,
            ],
          ],
        ),
      ),
    );
  }
}

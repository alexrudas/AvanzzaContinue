// lib/presentation/tenant/widgets/vehicle_card.dart
import 'package:avanzza/presentation/themes/components/material/icon_sizes_pro.dart';
import 'package:avanzza/presentation/themes/foundations/theme_extensions.dart';
import 'package:avanzza/presentation/themes/foundations/typography.dart';
import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String plate;
  final String model;
  final String year;
  final bool inUse;
  final String paymentLabel; // p.ej. "POR PAGAR" | "PAGADO" | "PAGO INMEDIATO"
  final String amountLabel; // p.ej. "\$450.000"
  final VoidCallback? onViewDetails;
  final VoidCallback? onPay;

  const VehicleCard({
    super.key,
    required this.plate,
    required this.model,
    required this.year,
    required this.inUse,
    required this.paymentLabel,
    required this.amountLabel,
    this.onViewDetails,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final numberStyle =
        (theme.extension<NumberTypographyExtension>()?.numberXL ??
                AppTypography.numberLG)
            .copyWith(color: cs.primary);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.commute, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Vehículo',
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A))),
            ),
            _StatusPill(
              label: inUse ? 'En uso' : 'Inactivo',
              color: inUse ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              icon: inUse ? Icons.check : Icons.pause_circle_filled,
              iconColor:
                  inUse ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
              textColor:
                  inUse ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
            ),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(plate, style: Theme.of(context).textTheme.titleLarge),
          ]),
          // const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(model, style: Theme.of(context).textTheme.titleSmall),
            Text(year,
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575))),
          ]),
          //const SizedBox(height: 12),
          const Divider(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Fecha límite de pago',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            Text(paymentLabel,
                style:
                    theme.textTheme.titleSmall?.copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
          Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                    child: Text('Valor a pagar',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 12),
                Text(amountLabel,
                    textAlign: TextAlign.right, style: numberStyle),
              ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: const AppIcon.button(Icons.visibility),
                label: const Text('Ver Detalles'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onPay,
                icon: const Icon(Icons.credit_card),
                label: const Text('Pagar'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const _StatusPill({
    required this.label,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
      ]),
    );
  }
}

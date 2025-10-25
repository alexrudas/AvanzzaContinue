/// Tarjeta destacada que muestra el porcentaje de ahorro del mes.
library;

import 'package:flutter/material.dart';

class SavingsHeroCard extends StatelessWidget {
  final double savingsPct;
  const SavingsHeroCard({super.key, required this.savingsPct});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            t.colorScheme.primary.withOpacity(0.16),
            t.colorScheme.secondary.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.colorScheme.primary.withOpacity(0.22)),
      ),
      child: Row(children: [
        Icon(Icons.trending_down, color: t.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ahorro del mes',
                  style: t.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              Text('Por pedidos optimizados', style: t.textTheme.bodySmall),
            ],
          ),
        ),
        Text('${savingsPct.toStringAsFixed(1)}%',
            style: t.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900)),
      ]),
    );
  }
}

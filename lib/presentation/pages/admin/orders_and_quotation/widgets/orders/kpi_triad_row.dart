/// Fila de tres KPIs: Total órdenes, Abiertas, Procesando.
library;

import 'package:flutter/material.dart';

class KpiTriadRow extends StatelessWidget {
  final int total;
  final int open;
  final int processing;
  const KpiTriadRow({
    super.key,
    required this.total,
    required this.open,
    required this.processing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: KpiCard(label: 'Total órdenes', value: '$total')),
      const SizedBox(width: 12),
      Expanded(child: KpiCard(label: 'Abiertas', value: '$open')),
      const SizedBox(width: 12),
      Expanded(child: KpiCard(label: 'Procesando', value: '$processing')),
    ]);
  }
}

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  const KpiCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(children: [
        Text(value,
            style:
                t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label,
            style: t.textTheme.bodySmall?.copyWith(color: Colors.black54))
      ]),
    );
  }
}

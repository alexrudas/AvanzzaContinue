/// Chips de estado para filtrar pedidos: Recientes, Procesando, Enviados, Entregados, Devoluciones.
library;

import 'package:flutter/material.dart';

class OrdersStatusChips extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const OrdersStatusChips({
    super.key,
    required this.index,
    required this.onChanged,
  });

  static const _entries = <(String, IconData)>[
    ('Recientes', Icons.all_inbox_outlined),
    ('Procesando', Icons.hourglass_top_outlined),
    ('Enviados', Icons.local_shipping_outlined),
    ('Entregados', Icons.task_alt_outlined),
    ('Devoluciones', Icons.assignment_return_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_entries.length, (i) {
          final e = _entries[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              selected: i == index,
              label: Row(children: [
                Icon(e.$2, size: 16),
                const SizedBox(width: 6),
                Text(e.$1),
              ]),
              onSelected: (_) => onChanged(i),
            ),
          );
        }),
      ),
    );
  }
}

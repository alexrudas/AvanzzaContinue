/// Chips de estado para filtrar solicitudes de compra.
///
/// Fase 1: estados reales de PurchaseRequestEntity (abierta/asignada/cerrada).
/// Reemplaza los estados de "pedido cumplido" (shipped/delivered/returned)
/// que no tienen correspondencia en el modelo de dominio actual.
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

  /// Entries corresponden a los estados reales de PurchaseRequestEntity.
  /// Índice 0 = sin filtro (todas).
  static const _entries = <(String, IconData)>[
    ('Todas', Icons.all_inbox_outlined),
    ('Abiertas', Icons.pending_outlined),
    ('Asignadas', Icons.assignment_ind_outlined),
    ('Cerradas', Icons.task_alt_outlined),
  ];

  /// Retorna el valor de estado para filtrar, o null para "Todas".
  static String? estadoForIndex(int index) => switch (index) {
        1 => 'abierta',
        2 => 'asignada',
        3 => 'cerrada',
        _ => null,
      };

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

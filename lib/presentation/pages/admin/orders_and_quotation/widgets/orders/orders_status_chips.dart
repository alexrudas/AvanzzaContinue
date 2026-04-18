// ============================================================================
// widgets/orders/orders_status_chips.dart
// Chips de estado para filtrar solicitudes de compra.
//
// QUÉ HACE:
//   - Filtra por el `status` wire-stable del contrato backend:
//     sent | partially_responded | responded | closed.
//   - Agrupa 'sent' + 'partially_responded' bajo "Abiertas" (aún hay targets
//     pendientes). 'responded' = "Respondidas" (todos los proveedores cerraron
//     su respuesta). 'closed' = "Cerradas".
//
// PRINCIPIOS:
//   - Coherencia semántica real con el status del backend. Cero mapeos falsos
//     a estados inventados (abierta/asignada/cerrada legacy).
// ============================================================================

import 'package:flutter/material.dart';

/// Filtro aplicable a PurchaseRequestEntity.status. Devuelve lista de status
/// aceptados o null para "Todas".
class OrdersStatusFilter {
  final List<String>? statuses;
  const OrdersStatusFilter._(this.statuses);

  bool matches(String status) {
    if (statuses == null) return true;
    return statuses!.contains(status);
  }
}

class OrdersStatusChips extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const OrdersStatusChips({
    super.key,
    required this.index,
    required this.onChanged,
  });

  static const _entries = <(String, IconData)>[
    ('Todas', Icons.all_inbox_outlined),
    ('Abiertas', Icons.pending_outlined),
    ('Respondidas', Icons.mark_chat_read_outlined),
    ('Cerradas', Icons.task_alt_outlined),
  ];

  /// Filtro por índice. 0=todas, 1=abiertas (sent|partially_responded),
  /// 2=responded, 3=closed.
  static OrdersStatusFilter filterForIndex(int index) => switch (index) {
        1 => const OrdersStatusFilter._(['sent', 'partially_responded']),
        2 => const OrdersStatusFilter._(['responded']),
        3 => const OrdersStatusFilter._(['closed']),
        _ => const OrdersStatusFilter._(null),
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

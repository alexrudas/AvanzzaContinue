/// Tarjeta de pedido con items, pagos, estado y acciones.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/format_helpers.dart';

enum OrderStatus { processing, shipped, delivered, returned }

class OrderCard extends StatelessWidget {
  final String orderSeq;
  final String assetType;
  final String assetID;
  final String assetDescription;
  final OrderStatus status;
  final int total;
  final String vendor;
  final DateTime receivedAt;
  final List<OrderItem> items;
  final List<Payment> payments;

  const OrderCard({
    super.key,
    required this.orderSeq,
    required this.assetType,
    required this.assetID,
    required this.assetDescription,
    required this.status,
    required this.total,
    required this.vendor,
    required this.receivedAt,
    required this.items,
    required this.payments,
  });

  int get paid => payments.fold<int>(0, (a, p) => a + p.amount);
  int get balance => total - paid;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final paidAll = balance <= 0;
    final orderSeries = 'P${assetKindCode(assetType)}-$orderSeq';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.colorScheme.outlineVariant),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Pedido',
              style: t.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          const SizedBox(width: 12),
          Text(orderSeries,
              textAlign: TextAlign.left,
              style: t.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          if (!paidAll)
            FilledButton.icon(
              onPressed: () => Get.snackbar('Pago', 'Pagar ahora'),
              icon: const Icon(Icons.credit_card),
              label: const Text('Pagar ahora'),
            ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Text('Valor Factura', style: t.textTheme.bodyMedium),
          const Spacer(),
          Text('\$${fmt(total)}',
              style: t.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(paidAll ? 'Saldo: \$0' : 'Saldo por pagar',
              style: t.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Text(paidAll ? 'Pagado' : '\$${fmt(balance)}',
              style: t.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ]),
        const Divider(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: t.colorScheme.surfaceContainerHighest.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(assetType,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text(assetID,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 4),
              Text(assetDescription),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Badge(
            text: _orderStatusLabel(status),
            color: _orderStatusColor(status),
          ),
        ]),
        const SizedBox(height: 12),
        Text('Ítems',
            style:
                t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        ...items.toList().asMap().entries.map((e) {
          if (e.key >= 3) return const SizedBox.shrink();
          final i = e.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              SizedBox(width: 16, child: Text('${e.key + 1}')),
              Expanded(child: Text(i.desc)),
              SizedBox(width: 48, child: Text('x${i.qty}')),
              SizedBox(
                width: 110,
                child: Text('\$${fmt(i.unitPrice)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontFeatures: [FontFeature.tabularFigures()])),
              ),
            ]),
          );
        }),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () => Get.snackbar('Devolución de artículos', 'Ítems'),
              icon: const Icon(Icons.undo),
              label: const Text('Devoluciones'),
            ),
            if (items.length > 3)
              OutlinedButton.icon(
                onPressed: () => Get.snackbar('Ver todo', 'Ítems'),
                icon: const Icon(Icons.visibility),
                label: const Text('Ver todo'),
              ),
          ],
        ),
        const Divider(),
        Row(children: [
          const Icon(Icons.store_mall_directory_outlined, size: 18),
          const SizedBox(width: 6),
          Text(vendor),
          const Spacer(),
          const Icon(Icons.event_available_outlined, size: 18),
          const SizedBox(width: 6),
          Text(fmtDateTime(receivedAt)),
        ]),
        const SizedBox(height: 12),
        Text('Pagos',
            style:
                t.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        ...payments.map((p) => Row(
              children: [
                const Icon(Icons.payments_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text('\$${fmt(p.amount)}')),
                Text(p.date),
              ],
            )),
        const SizedBox(height: 6),
        Row(children: [
          Text(paidAll ? 'Saldo: \$0' : 'Saldo: \$${fmt(balance)}',
              style: t.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ]),
      ]),
    );
  }

  String _orderStatusLabel(OrderStatus s) => switch (s) {
        OrderStatus.processing => 'Procesando',
        OrderStatus.shipped => 'Enviado',
        OrderStatus.delivered => 'Entregado',
        OrderStatus.returned => 'Devuelto',
      };

  Color _orderStatusColor(OrderStatus s) => switch (s) {
        OrderStatus.processing => const Color(0xFF9AA0A6),
        OrderStatus.shipped => const Color(0xFF2F5AFF),
        OrderStatus.delivered => const Color(0xFF1E8E3E),
        OrderStatus.returned => const Color(0xFFD32F2F),
      };

  IconData _orderStatusIcon(OrderStatus s) => switch (s) {
        OrderStatus.processing => Icons.hourglass_top_outlined,
        OrderStatus.shipped => Icons.local_shipping_outlined,
        OrderStatus.delivered => Icons.check_circle_outline,
        OrderStatus.returned => Icons.replay_outlined,
      };
}

class OrderItem {
  final String desc;
  final int qty;
  final int unitPrice;
  const OrderItem(this.desc, this.qty, this.unitPrice);
}

class Payment {
  final int amount;
  final String date;
  const Payment({required this.amount, required this.date});
}

class Badge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const Badge({
    required this.text,
    required this.color,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );
}

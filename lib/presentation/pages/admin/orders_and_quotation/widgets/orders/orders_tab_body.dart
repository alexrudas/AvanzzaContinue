/// Tab de pedidos con KPIs, chips de estado, historial y FAB.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avanzza/presentation/controllers/admin/purchase/admin_purchase_controller.dart';
import 'savings_hero_card.dart';
import 'kpi_triad_row.dart';
import 'orders_status_chips.dart';
import 'order_card.dart';

class OrdersTabBody extends StatefulWidget {
  final AdminPurchaseController controller;
  const OrdersTabBody({required this.controller, super.key});

  @override
  State<OrdersTabBody> createState() => _OrdersTabBodyState();
}

class _OrdersTabBodyState extends State<OrdersTabBody> {
  int _statusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const SavingsHeroCard(savingsPct: 8.4),
          const SizedBox(height: 12),
          const KpiTriadRow(total: 12, open: 3, processing: 5),
          const SizedBox(height: 16),
          OrdersStatusChips(
            index: _statusIndex,
            onChanged: (i) => setState(() => _statusIndex = i),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('Historial',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900)),
              ),
              IconButton(
                tooltip: 'Filtro',
                icon: const Icon(Icons.filter_list),
                onPressed: () => Get.snackbar('Filtro', 'En desarrollo'),
              ),
              TextButton(
                onPressed: () => Get.snackbar('Historial', 'Ver todo'),
                child: const Text('Ver todo'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OrderCard(
            orderSeq: '240103',
            assetType: 'Vehículo',
            assetID: 'WPV584',
            assetDescription: 'Hyundai Grand i10 · 2025',
            status: OrderStatus.delivered,
            total: 1980000,
            vendor: 'PartesYa',
            receivedAt: DateTime(2025, 10, 23, 16, 19),
            items: const [
              OrderItem('Punta semieje lado rueda - izq.', 1, 650000),
              OrderItem('Brazo axial derecho', 1, 720000),
              OrderItem('Buje puño tijera izquierda', 1, 610000),
              OrderItem('Arandela seguridad', 2, 5000),
            ],
            payments: const [
              Payment(amount: 980000, date: '2025-10-24 09:20'),
            ],
          ),
          const SizedBox(height: 12),
          OrderCard(
            orderSeq: '240104',
            assetType: 'Vehículo',
            assetID: 'KPV412',
            assetDescription: 'Kia Picanto · 2024',
            status: OrderStatus.delivered,
            total: 450000,
            vendor: 'AutoMax',
            receivedAt: DateTime(2025, 10, 25, 11, 5),
            items: const [
              OrderItem('Filtro de aire motor', 1, 120000),
              OrderItem('Pastillas de freno', 1, 180000),
              OrderItem('Servicio montaje', 1, 150000),
            ],
            payments: const [
              Payment(amount: 450000, date: '2025-10-25 12:15'),
            ],
          ),
        ],
      ),
      Positioned(
        right: 16,
        bottom: 16,
        child: FloatingActionButton.extended(
          onPressed: () => Get.snackbar('Nueva compra', 'Abrir wizard'),
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Nueva compra'),
        ),
      )
    ]);
  }
}

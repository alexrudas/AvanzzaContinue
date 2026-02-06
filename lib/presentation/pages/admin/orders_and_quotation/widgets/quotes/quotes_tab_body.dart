/// Tab de cotizaciones con lista de solicitudes y FAB.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avanzza/presentation/controllers/admin/purchase/admin_purchase_controller.dart';
import '../shared/section_header.dart';
import 'quote_request_card.dart';

class QuotesTabBody extends StatelessWidget {
  final AdminPurchaseController controller;
  const QuotesTabBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: const [
          SectionHeader(
              title: 'Cotizaciones',
              subtitle: 'Solicitadas / Respuestas recibidas'),
          SizedBox(height: 12),
          QuoteRequestCard(
            quoteId: 123,
            assetType: 'Vehículo',
            assetID: 'WPV584',
            assetDescription: 'Hyundai Grand i10 · 2025',
            subtitle: 'Oct. 23 / 2025 · 4:19 a.m. · Barranquilla → Soledad',
            items: [
              'Punta semieje lado rueda - izquierda',
              'Brazo axial derecho',
              'Buje puño tijera izquierda',
            ],
            stores: [
              StoreReply(
                  name: 'Autokorea',
                  status: StoreStatus.pending,
                  delivery: DeliveryType.home),
              StoreReply(
                  name: 'RepuCar',
                  status: StoreStatus.pending,
                  delivery: DeliveryType.pickup),
              StoreReply(
                  name: 'PartesYa',
                  status: StoreStatus.answered,
                  delivery: DeliveryType.home,
                  price: 1980000,
                  etaDays: 2),
            ],
          ),
          SizedBox(height: 16),
          QuoteRequestCard(
            quoteId: 124,
            assetType: 'Vehículo',
            assetID: 'KPV412',
            assetDescription: 'Kia Picanto · 2024',
            subtitle: 'Oct. 23 / 2025 · 5:12 a.m. · Barranquilla → Galapa',
            items: [
              'Filtro de aire motor',
              'Juego de pastillas de freno',
              'Amortiguador delantero derecho',
            ],
            stores: [
              StoreReply(
                  name: 'AutoMax',
                  status: StoreStatus.answered,
                  delivery: DeliveryType.home,
                  price: 450000,
                  etaDays: 1),
              StoreReply(
                  name: 'RepuCenter',
                  status: StoreStatus.answered,
                  delivery: DeliveryType.pickup,
                  price: 470000,
                  etaDays: 3),
              StoreReply(
                  name: 'PartesYa',
                  status: StoreStatus.pending,
                  delivery: DeliveryType.home),
            ],
          ),
        ],
      ),
      Positioned(
        right: 16,
        bottom: 16,
        child: FloatingActionButton.extended(
          onPressed: () => Get.snackbar('Nueva cotización', 'Abrir wizard'),
          icon: const Icon(Icons.request_quote_outlined),
          label: const Text('Nueva cotización'),
        ),
      ),
    ]);
  }
}

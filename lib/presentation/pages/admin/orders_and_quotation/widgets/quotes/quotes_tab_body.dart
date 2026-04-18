/// Tab de cotizaciones — solicitudes canónicas filtradas por respuestas.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:avanzza/presentation/controllers/admin/purchase/admin_purchase_controller.dart';
import '../shared/section_header.dart';
import '../orders/purchase_request_card.dart';
import 'supplier_responses_sheet.dart';

class QuotesTabBody extends StatelessWidget {
  final AdminPurchaseController controller;
  const QuotesTabBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final all = controller.requests.toList();
      final withResponsesCount =
          all.where((r) => r.respuestasCount > 0).length;

      return Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            SectionHeader(
              title: 'Cotizaciones',
              subtitle: all.isEmpty
                  ? 'Sin solicitudes de cotización'
                  : '$withResponsesCount de ${all.length} con respuestas',
            ),
            const SizedBox(height: 12),

            if (all.isEmpty)
              const _EmptyQuotes()
            else
              ...all.map((r) => PurchaseRequestCard(
                    id: r.id,
                    title: r.title,
                    type: r.type,
                    category: r.category,
                    itemsCount: r.itemsCount,
                    status: r.status,
                    deliveryCity: r.delivery?.city,
                    respuestasCount: r.respuestasCount,
                    assetId: r.assetId,
                    createdAt: r.createdAt,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SupplierResponsesSheet(
                        requestId: r.id,
                        title: r.title,
                      ),
                    ),
                  )),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () => controller.createRequest(),
            icon: const Icon(Icons.request_quote_outlined),
            label: const Text('Nueva cotización'),
          ),
        ),
      ]);
    });
  }
}

class _EmptyQuotes extends StatelessWidget {
  const _EmptyQuotes();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.forum_outlined,
              size: 56, color: t.hintColor.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'Sin cotizaciones recibidas',
            style: t.textTheme.bodyMedium?.copyWith(color: t.hintColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Las respuestas de proveedores aparecerán aquí',
            style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
          ),
        ],
      ),
    );
  }
}

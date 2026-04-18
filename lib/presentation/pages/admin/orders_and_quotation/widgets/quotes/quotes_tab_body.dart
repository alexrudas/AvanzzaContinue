/// Tab de cotizaciones — solicitudes con respuestas de proveedores.
///
/// Fase 1: muestra solicitudes que tienen respuestasCount > 0.
/// Usa PurchaseRequestCard (misma tarjeta que el tab de solicitudes)
/// filtrada a las que ya recibieron al menos una cotización.
/// El detalle de cada respuesta (precios, proveedores) es Fase 2.
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
      // ── Loading ──────────────────────────────────────────────────────────
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // ── Todas las solicitudes — cada una ES una solicitud de cotización ──
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
                    tipoRepuesto: r.tipoRepuesto,
                    cantidad: r.cantidad,
                    estado: r.estado,
                    ciudadEntrega: r.ciudadEntrega,
                    respuestasCount: r.respuestasCount,
                    assetId: r.assetId,
                    createdAt: r.createdAt,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SupplierResponsesSheet(
                        requestId: r.id,
                        tipoRepuesto: r.tipoRepuesto,
                      ),
                    ),
                  )),
          ],
        ),

        // FAB — reutiliza el mismo formulario de creación de solicitud.
        // Una cotización y una solicitud crean la misma PurchaseRequestEntity.
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

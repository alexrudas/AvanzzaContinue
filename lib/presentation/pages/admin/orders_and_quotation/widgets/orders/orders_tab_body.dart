/// Tab de solicitudes de compra con KPIs, filtros y listado real.
///
/// Fase 1: conectado a AdminPurchaseController.requests (datos reales).
/// Reemplaza la versión mock anterior que usaba OrderCard con datos hardcoded.
/// SavingsHeroCard se oculta — no hay dato de ahorro disponible en la entidad.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:avanzza/presentation/controllers/admin/purchase/admin_purchase_controller.dart';
import 'kpi_triad_row.dart';
import 'orders_status_chips.dart';
import 'purchase_request_card.dart';
import 'purchase_request_detail_sheet.dart';

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
    final c = widget.controller;

    return Obx(() {
      // ── Loading ──────────────────────────────────────────────────────────
      if (c.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // ── Error ────────────────────────────────────────────────────────────
      if (c.error.value != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.black38),
              const SizedBox(height: 12),
              Text(c.error.value!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      }

      // ── Filtrar por estado seleccionado ───────────────────────────────
      final estadoFilter = OrdersStatusChips.estadoForIndex(_statusIndex);
      final filtered = estadoFilter == null
          ? c.requests.toList()
          : c.requests.where((r) => r.estado == estadoFilter).toList();

      return Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            // KPIs reales desde el controller
            KpiTriadRow(
              total: c.totalCount,
              open: c.openCount,
              processing: c.withResponsesCount,
              totalLabel: 'Total solicitudes',
              openLabel: 'Abiertas',
              processingLabel: 'Con respuestas',
            ),
            const SizedBox(height: 16),
            OrdersStatusChips(
              index: _statusIndex,
              onChanged: (i) => setState(() => _statusIndex = i),
            ),
            const SizedBox(height: 12),

            // ── Lista o empty state ────────────────────────────────────────
            if (filtered.isEmpty)
              _EmptyState(hasFilter: estadoFilter != null)
            else
              ...filtered.map((r) => PurchaseRequestCard(
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
                      builder: (_) => PurchaseRequestDetailSheet(request: r),
                    ),
                  )),
          ],
        ),

        // FAB — creación diferida a Fase 2.
        // bottom: 16 estándar. El Scaffold del shell ya posiciona el body ARRIBA
        // del bottomNavigationBar (SafeArea + CustomFloatingNavBar), así que no
        // hace falta compensar manualmente la altura del nav bar.
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () => c.createRequest(),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Nueva solicitud'),
          ),
        ),
      ]);
    });
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilter;
  const _EmptyState({required this.hasFilter});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined,
              size: 56, color: t.hintColor.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            hasFilter
                ? 'Sin solicitudes con este estado'
                : 'Sin solicitudes de compra',
            style: t.textTheme.bodyMedium?.copyWith(color: t.hintColor),
          ),
          if (!hasFilter) ...[
            const SizedBox(height: 4),
            Text(
              'Crea tu primera solicitud con el botón +',
              style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
            ),
          ],
        ],
      ),
    );
  }
}

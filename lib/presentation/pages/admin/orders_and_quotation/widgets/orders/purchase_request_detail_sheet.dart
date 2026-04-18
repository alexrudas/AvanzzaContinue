// ============================================================================
// widgets/orders/purchase_request_detail_sheet.dart
// PURCHASE REQUEST DETAIL SHEET — Detalle canónico
//
// QUÉ HACE:
//   - Muestra el detalle de una PurchaseRequestEntity canónica:
//     title, type, category, originType, assetId, notes, delivery estructurada,
//     itemsCount, lista de ítems si vino embebida, respuestasCount.
//   - Botón "Ver cotizaciones" si respuestasCount > 0.
//
// QUÉ NO HACE:
//   - No edita la solicitud.
//   - No carga items on-demand si la cache no los trae (muestra solo itemsCount
//     y un aviso). Carga bajo demanda queda para tarea futura.
// ============================================================================

import 'package:flutter/material.dart';

import 'package:avanzza/domain/entities/purchase/create_purchase_request_input.dart';
import 'package:avanzza/domain/entities/purchase/purchase_request_entity.dart';
import '../shared/format_helpers.dart';
import '../quotes/supplier_responses_sheet.dart';

class PurchaseRequestDetailSheet extends StatelessWidget {
  final PurchaseRequestEntity request;

  const PurchaseRequestDetailSheet({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final idShort =
        request.id.length > 8 ? request.id.substring(0, 8) : request.id;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Solicitud #$idShort',
                    style: t.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                _StatusBadge(status: request.status),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            if (request.createdAt != null)
              Text(
                fmtDateTime(request.createdAt!),
                style: t.textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),

            const Divider(height: 24),

            // Encabezado canónico
            const _SectionTitle('Encabezado'),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.article_outlined,
              label: 'Título',
              value: request.title,
            ),
            _DetailRow(
              icon: Icons.label_outline,
              label: 'Tipo',
              value: _typeLabel(request.type),
            ),
            if (request.category != null && request.category!.isNotEmpty)
              _DetailRow(
                icon: Icons.category_outlined,
                label: 'Categoría',
                value: request.category!,
              ),

            const Divider(height: 24),

            // Contexto
            const _SectionTitle('Contexto'),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.info_outline,
              label: 'Origen',
              value: _originLabel(request.originType),
            ),
            if (request.assetId != null && request.assetId!.isNotEmpty)
              _DetailRow(
                icon: Icons.precision_manufacturing_outlined,
                label: 'Activo',
                value: request.assetId!,
              ),
            if (request.notes != null && request.notes!.isNotEmpty)
              _DetailRow(
                icon: Icons.notes_outlined,
                label: 'Observaciones',
                value: request.notes!,
              ),

            const Divider(height: 24),

            // Ítems
            _SectionTitle('Ítems (${request.itemsCount})'),
            const SizedBox(height: 8),
            if (request.items.isEmpty)
              Text(
                'Detalle de ítems no disponible en cache. Recarga desde el '
                'backend para verlos.',
                style:
                    t.textTheme.bodySmall?.copyWith(color: Colors.black54),
              )
            else
              ...request.items.map((it) => _ItemTile(item: it)),

            // Entrega
            if (request.delivery != null) ...[
              const Divider(height: 24),
              const _SectionTitle('Entrega'),
              const SizedBox(height: 8),
              _DetailRow(
                icon: Icons.location_city_outlined,
                label: 'Ciudad',
                value: request.delivery!.city,
              ),
              _DetailRow(
                icon: Icons.place_outlined,
                label: 'Dirección',
                value: request.delivery!.address,
              ),
              if (request.delivery!.department != null &&
                  request.delivery!.department!.isNotEmpty)
                _DetailRow(
                  icon: Icons.map_outlined,
                  label: 'Departamento',
                  value: request.delivery!.department!,
                ),
              if (request.delivery!.info != null &&
                  request.delivery!.info!.isNotEmpty)
                _DetailRow(
                  icon: Icons.info_outline,
                  label: 'Info adicional',
                  value: request.delivery!.info!,
                ),
            ],

            const Divider(height: 24),

            // Cotizaciones
            const _SectionTitle('Cotizaciones'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 20,
                  color: request.respuestasCount > 0
                      ? t.colorScheme.primary
                      : Colors.black38,
                ),
                const SizedBox(width: 8),
                Text(
                  '${request.respuestasCount} '
                  '${request.respuestasCount == 1 ? 'respuesta recibida' : 'respuestas recibidas'}',
                  style: t.textTheme.bodyMedium?.copyWith(
                    fontWeight: request.respuestasCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (request.respuestasCount > 0) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => SupplierResponsesSheet(
                        requestId: request.id,
                        title: request.title,
                      ),
                    );
                  },
                  icon: const Icon(Icons.compare_arrows),
                  label: const Text('Ver cotizaciones'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _typeLabel(PurchaseRequestTypeInput t) =>
      t == PurchaseRequestTypeInput.product ? 'Producto' : 'Servicio';

  static String _originLabel(PurchaseRequestOriginInput o) => switch (o) {
        PurchaseRequestOriginInput.asset => 'Activo específico',
        PurchaseRequestOriginInput.inventory => 'Inventario / stock',
        PurchaseRequestOriginInput.general => 'Necesidad general',
      };
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final PurchaseRequestItemEntity item;
  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
            t.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.description,
              style: t.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('${item.quantity} ${item.unit}',
              style: t.textTheme.bodySmall?.copyWith(color: Colors.black54)),
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(item.notes!,
                style:
                    t.textTheme.bodySmall?.copyWith(color: Colors.black54)),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'sent' => ('Enviada', const Color(0xFF2F5AFF)),
      'partially_responded' =>
        ('Parcial', const Color(0xFFE67E22)),
      'responded' => ('Respondida', const Color(0xFF7E57C2)),
      'closed' => ('Cerrada', const Color(0xFF1E8E3E)),
      _ => (status, const Color(0xFF9AA0A6)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.black45),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black54)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// widgets/orders/purchase_request_card.dart
// PURCHASE REQUEST CARD — Representación canónica de una solicitud
//
// QUÉ HACE:
//   - Muestra PurchaseRequestEntity (modelo canónico): title, type badge,
//     itemsCount, city de entrega si existe, assetId si existe, status,
//     respuestasCount y fecha.
//
// QUÉ NO HACE:
//   - NO muestra "tipoRepuesto" ni "cantidad global" ni "ciudadEntrega" como
//     eje: ese modelo legacy fue retirado del dominio.
//   - NO resuelve assetId a nombre de activo (UI futura con AssetRepository).
// ============================================================================

import 'package:flutter/material.dart';

import 'package:avanzza/domain/entities/purchase/create_purchase_request_input.dart';
import '../shared/format_helpers.dart';

class PurchaseRequestCard extends StatelessWidget {
  final String id;
  final String title;
  final PurchaseRequestTypeInput type;
  final String? category;
  final int itemsCount;
  final String status; // sent | partially_responded | responded | closed
  final String? deliveryCity;
  final int respuestasCount;
  final String? assetId;
  final DateTime? createdAt;
  final VoidCallback? onTap;

  const PurchaseRequestCard({
    super.key,
    required this.id,
    required this.title,
    required this.type,
    this.category,
    required this.itemsCount,
    required this.status,
    this.deliveryCity,
    required this.respuestasCount,
    this.assetId,
    this.createdAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final idShort = id.length > 8 ? id.substring(0, 8) : id;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: t.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: id + status
            Row(
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 20, color: t.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Solicitud #$idShort',
                  style: t.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                _StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 10),

            // Body: title + type/category + itemsCount + asset
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: t.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _TypePill(type: type),
                      if (category != null && category!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          '· $category',
                          style: t.textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$itemsCount ${itemsCount == 1 ? "ítem" : "ítems"}',
                    style: t.textTheme.bodySmall
                        ?.copyWith(color: Colors.black54),
                  ),
                  if (assetId != null && assetId!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Activo: $assetId',
                      style: t.textTheme.bodySmall
                          ?.copyWith(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Footer: delivery city (si existe), respuestas, fecha
            Row(
              children: [
                if (deliveryCity != null && deliveryCity!.isNotEmpty) ...[
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.black45),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      deliveryCity!,
                      style: t.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else
                  const Spacer(),
                const SizedBox(width: 12),
                Icon(
                  Icons.forum_outlined,
                  size: 16,
                  color: respuestasCount > 0
                      ? t.colorScheme.primary
                      : Colors.black38,
                ),
                const SizedBox(width: 4),
                Text(
                  '$respuestasCount ${respuestasCount == 1 ? 'respuesta' : 'respuestas'}',
                  style: t.textTheme.bodySmall?.copyWith(
                    fontWeight: respuestasCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: respuestasCount > 0
                        ? t.colorScheme.primary
                        : Colors.black54,
                  ),
                ),
              ],
            ),
            if (createdAt != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.schedule_outlined,
                      size: 16, color: Colors.black38),
                  const SizedBox(width: 4),
                  Text(
                    fmtDateTime(createdAt!),
                    style: t.textTheme.bodySmall
                        ?.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final PurchaseRequestTypeInput type;
  const _TypePill({required this.type});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type) {
      PurchaseRequestTypeInput.product => ('Producto', const Color(0xFF1E8E3E)),
      PurchaseRequestTypeInput.service => ('Servicio', const Color(0xFF2F5AFF)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    // Status wire backend: sent | partially_responded | responded | closed.
    final (label, color) = switch (status) {
      'sent' => ('Enviada', const Color(0xFF2F5AFF)),
      'partially_responded' =>
        ('Parcialmente respondida', const Color(0xFFE67E22)),
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
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================================
// widgets/orders/purchase_request_card.dart
// PURCHASE REQUEST CARD — Representación honesta de una solicitud de compra
//
// QUÉ HACE:
// - Muestra una PurchaseRequestEntity tal cual es: solicitud, no pedido cumplido.
// - Expone: id corto, tipoRepuesto, cantidad, estado real (abierta/asignada/cerrada),
//   ciudad de entrega, cantidad de respuestas, fecha de creación.
//
// QUÉ NO HACE:
// - NO muestra total, vendor, items[], payments[] — esos campos no existen en la entidad.
// - NO inventa semántica de "order fulfilled" ni mapea estados falsos.
// - NO resuelve assetId a nombre de activo (responsabilidad de Fase 2).
//
// PRINCIPIOS:
// - Honestidad: solo muestra lo que la entidad realmente tiene.
// - Reutilizable: acepta datos puros, no controller ni Get.find().
// - Fase 1: card de solicitud. OrderCard (pedido cumplido) se reserva para Fase 2.
// ============================================================================

import 'package:flutter/material.dart';

import '../shared/format_helpers.dart';

/// Tarjeta de solicitud de compra (PurchaseRequestEntity).
///
/// Representa honestamente una solicitud: qué se pidió, cuánto,
/// en qué estado está, y cuántas respuestas de proveedores tiene.
class PurchaseRequestCard extends StatelessWidget {
  final String id;
  final String tipoRepuesto;
  final int cantidad;
  final String estado; // 'abierta' | 'asignada' | 'cerrada'
  final String ciudadEntrega;
  final int respuestasCount;
  final String? assetId;
  final DateTime? createdAt;
  final VoidCallback? onTap;

  const PurchaseRequestCard({
    super.key,
    required this.id,
    required this.tipoRepuesto,
    required this.cantidad,
    required this.estado,
    required this.ciudadEntrega,
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
            // ── Header: ID + Estado ──────────────────────────────────────
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
                _EstadoBadge(estado: estado),
              ],
            ),
            const SizedBox(height: 10),

            // ── Item solicitado ───────────────────────────────────────────
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
                    tipoRepuesto,
                    style: t.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Cantidad: $cantidad',
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

            // ── Footer: ciudad, respuestas, fecha ─────────────────────────
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.black45),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ciudadEntrega,
                    style: t.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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

/// Badge de estado con color honesto según el estado real de la entidad.
class _EstadoBadge extends StatelessWidget {
  final String estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (estado.toLowerCase().trim()) {
      'abierta' => ('Abierta', const Color(0xFF2F5AFF)),
      'asignada' => ('Asignada', const Color(0xFFE67E22)),
      'cerrada' => ('Cerrada', const Color(0xFF1E8E3E)),
      _ => (estado, const Color(0xFF9AA0A6)),
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

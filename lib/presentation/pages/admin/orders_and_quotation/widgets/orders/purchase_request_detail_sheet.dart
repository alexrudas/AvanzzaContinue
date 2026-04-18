// ============================================================================
// widgets/orders/purchase_request_detail_sheet.dart
// PURCHASE REQUEST DETAIL SHEET — Detalle de una solicitud de compra
//
// QUÉ HACE:
// - Muestra el detalle completo de una PurchaseRequestEntity en bottom sheet.
// - Secciones: cabecera, item solicitado, metadatos, estado de cotizaciones.
// - Botón "Ver cotizaciones" si respuestasCount > 0 → abre SupplierResponsesSheet.
//
// QUÉ NO HACE:
// - NO edita la solicitud (Fase futura).
// - NO carga datos remotos — recibe la entidad ya cargada.
// - NO usa Get.snackbar (riesgo de Overlay crash en este contexto).
//
// PRINCIPIOS:
// - Honestidad: solo muestra campos que existen en la entidad.
// - Reutiliza patrón de quote_details_sheet.dart (SafeArea + Container + ListView).
// ============================================================================

import 'package:flutter/material.dart';

import 'package:avanzza/domain/entities/purchase/purchase_request_entity.dart';
import '../shared/format_helpers.dart';
import '../quotes/supplier_responses_sheet.dart';

/// Bottom sheet con el detalle completo de una solicitud de compra.
///
/// Abrir con:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => PurchaseRequestDetailSheet(request: entity),
/// );
/// ```
class PurchaseRequestDetailSheet extends StatelessWidget {
  final PurchaseRequestEntity request;

  const PurchaseRequestDetailSheet({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final idShort = request.id.length > 8
        ? request.id.substring(0, 8)
        : request.id;

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
            // ── Cabecera ─────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Solicitud #$idShort',
                    style: t.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                _EstadoBadge(estado: request.estado),
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

            // ── Item solicitado ──────────────────────────────────────
            Text('Item solicitado',
                style: t.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: t.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request.tipoRepuesto,
                      style: t.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Cantidad: ${request.cantidad}',
                      style: t.textTheme.bodyMedium),
                  if (request.specs != null && request.specs!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Specs: ${request.specs}',
                        style: t.textTheme.bodySmall
                            ?.copyWith(color: Colors.black54)),
                  ],
                ],
              ),
            ),

            const Divider(height: 24),

            // ── Detalles ─────────────────────────────────────────────
            Text('Detalles',
                style: t.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Ciudad de entrega',
              value: request.ciudadEntrega,
            ),
            if (request.assetId != null && request.assetId!.isNotEmpty)
              _DetailRow(
                icon: Icons.precision_manufacturing_outlined,
                label: 'Activo',
                value: request.assetId!,
              ),
            if (request.expectedDate != null)
              _DetailRow(
                icon: Icons.event_outlined,
                label: 'Fecha esperada',
                value: fmtDateTime(request.expectedDate!),
              ),
            _DetailRow(
              icon: Icons.monetization_on_outlined,
              label: 'Moneda',
              value: request.currencyCode,
            ),

            const Divider(height: 24),

            // ── Estado de cotizaciones ───────────────────────────────
            Text('Cotizaciones',
                style: t.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
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
                        tipoRepuesto: request.tipoRepuesto,
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
}

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
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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

// ============================================================================
// lib/data/sources/remote/purchase/purchase_api_mapper.dart
// PURCHASE API MAPPER — Adaptador entre el contrato Core API y los modelos
// de dominio cliente (F5 Hito 17).
// ============================================================================
// QUÉ HACE:
//   Traduce la representación server-side de PurchaseRequest / Quote al shape
//   que el cliente Flutter ya modela en PurchaseRequestEntity y
//   SupplierResponseEntity, más el PurchaseRequestModel de Isar.
//
// GAP DE DOMINIO (documentado, no corregido aquí):
//   El modelo cliente nació diseñado para Firestore con campos planos
//   (tipoRepuesto/cantidad/ciudadEntrega). El backend usa items[] + targets[].
//   Este mapper hace la mejor reducción razonable:
//     - cliente.tipoRepuesto ← server.title
//     - cliente.cantidad     ← server.items[0].quantity (primer item)
//     - cliente.specs        ← server.notes
//     - cliente.ciudadEntrega ← "" (no existe en backend)
//     - cliente.proveedorIdsInvitados ← server.targets[].vendorContactId
//     - cliente.estado       ← mapeo backend↔cliente
//     - cliente.respuestasCount ← server.quotes.length
//   Cerrar este gap implica migrar PurchaseRequestEntity al shape items[]+
//   targets[]; fuera de alcance de este hito (no rediseñar dominio).
// ============================================================================

import '../../../../domain/entities/purchase/purchase_request_entity.dart';
import '../../../../domain/entities/purchase/supplier_response_entity.dart';
import '../../../models/purchase/purchase_request_model.dart';
import '../../../models/purchase/supplier_response_model.dart';

class PurchaseApiMapper {
  const PurchaseApiMapper._();

  // ───────────────────────────────────────────────────────────────────────────
  // PurchaseRequest (server → cliente)
  // ───────────────────────────────────────────────────────────────────────────

  static String _mapStatus(String? serverStatus) {
    switch (serverStatus) {
      case 'closed':
        return 'cerrada';
      case 'sent':
      case 'partially_responded':
      case 'responded':
      default:
        return 'abierta';
    }
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  static PurchaseRequestEntity entityFromServerJson(
    Map<String, dynamic> json,
  ) {
    final items = (json['items'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final targets = (json['targets'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final quotes = (json['quotes'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];

    final firstItem =
        items.isNotEmpty ? items.first : const <String, dynamic>{};
    final qty = firstItem['quantity'];
    final cantidad = qty is int
        ? qty
        : qty is num
            ? qty.toInt()
            : qty is String
                ? (num.tryParse(qty)?.toInt() ?? 1)
                : 1;

    return PurchaseRequestEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: null,
      tipoRepuesto: (json['title'] as String?) ??
          (firstItem['description'] as String? ?? ''),
      specs: json['notes'] as String?,
      cantidad: cantidad,
      ciudadEntrega: '',
      proveedorIdsInvitados: targets
          .map((t) => t['vendorContactId'] as String?)
          .whereType<String>()
          .toList(growable: false),
      estado: _mapStatus(json['status'] as String?),
      respuestasCount: quotes.length,
      currencyCode: 'COP',
      expectedDate: null,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static PurchaseRequestModel modelFromServerJson(
    Map<String, dynamic> json,
  ) =>
      PurchaseRequestModel.fromEntity(entityFromServerJson(json));

  // ───────────────────────────────────────────────────────────────────────────
  // SupplierResponse (Quote server → cliente)
  // ───────────────────────────────────────────────────────────────────────────

  static double _toDouble(dynamic raw) {
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is String) return double.tryParse(raw) ?? 0;
    if (raw is num) return raw.toDouble();
    return 0;
  }

  static SupplierResponseEntity supplierResponseFromQuoteJson(
    Map<String, dynamic> quote,
  ) =>
      SupplierResponseEntity(
        id: quote['id'] as String,
        purchaseRequestId: quote['purchaseRequestId'] as String,
        proveedorId: quote['vendorContactId'] as String,
        precio: _toDouble(quote['total']),
        disponibilidad: 'cotizado',
        currencyCode: (quote['currency'] as String?) ?? 'COP',
        catalogoUrl: null,
        notas: quote['notes'] as String?,
        leadTimeDays: null,
        createdAt: _parseDate(quote['createdAt']),
        updatedAt: _parseDate(quote['updatedAt']),
      );

  static SupplierResponseModel supplierResponseModelFromQuoteJson(
    Map<String, dynamic> quote,
  ) =>
      SupplierResponseModel.fromEntity(supplierResponseFromQuoteJson(quote));
}

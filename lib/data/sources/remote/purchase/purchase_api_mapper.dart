// ============================================================================
// lib/data/sources/remote/purchase/purchase_api_mapper.dart
// PURCHASE API MAPPER — server response → dominio/modelo canónico
// ============================================================================
// QUÉ HACE:
//   Traduce el JSON del Core API al shape canónico del cliente
//   (PurchaseRequestEntity + PurchaseRequestModel Isar).
//   Sin hacks: los campos estructurados llegan desde el backend como campos
//   reales (title, type, category, originType, assetId, deliveryCity…,
//   items[], targets[]).
//
// QUÉ NO HACE:
//   - No inventa enums que el backend no envíe: tolera valores desconocidos
//     cayendo a default (PRODUCT / GENERAL).
// ============================================================================

import '../../../../domain/entities/purchase/create_purchase_request_input.dart';
import '../../../../domain/entities/purchase/purchase_request_entity.dart';
import '../../../../domain/entities/purchase/supplier_response_entity.dart';
import '../../../models/purchase/purchase_request_model.dart';
import '../../../models/purchase/supplier_response_model.dart';

class PurchaseApiMapper {
  const PurchaseApiMapper._();

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers
  // ───────────────────────────────────────────────────────────────────────────

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  static num _num(dynamic raw, {num fallback = 0}) {
    if (raw is num) return raw;
    if (raw is String) return num.tryParse(raw) ?? fallback;
    return fallback;
  }

  static String? _strOrNull(dynamic raw) {
    if (raw is String && raw.isNotEmpty) return raw;
    return null;
  }

  static PurchaseRequestTypeInput _typeFromJson(dynamic raw) {
    for (final t in PurchaseRequestTypeInput.values) {
      if (t.wireName == raw) return t;
    }
    return PurchaseRequestTypeInput.product;
  }

  static PurchaseRequestOriginInput _originFromJson(dynamic raw) {
    for (final o in PurchaseRequestOriginInput.values) {
      if (o.wireName == raw) return o;
    }
    return PurchaseRequestOriginInput.general;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PurchaseRequest (server → cliente)
  // ───────────────────────────────────────────────────────────────────────────

  static PurchaseRequestEntity entityFromServerJson(
    Map<String, dynamic> json,
  ) {
    final itemsRaw =
        (json['items'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final targetsRaw =
        (json['targets'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final quotesRaw =
        (json['quotes'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

    final items = itemsRaw
        .map((it) => PurchaseRequestItemEntity(
              id: it['id'] as String? ?? '',
              description: it['description'] as String? ?? '',
              quantity: _num(it['quantity'], fallback: 1),
              unit: it['unit'] as String? ?? 'und',
              notes: _strOrNull(it['notes']),
            ))
        .toList(growable: false);

    final vendorContactIds = targetsRaw
        .map((t) => _strOrNull(t['vendorContactId']))
        .whereType<String>()
        .toList(growable: false);

    final deliveryCity = _strOrNull(json['deliveryCity']);
    final deliveryAddress = _strOrNull(json['deliveryAddress']);
    final delivery = (deliveryCity != null && deliveryAddress != null)
        ? PurchaseRequestDeliveryEntity(
            city: deliveryCity,
            address: deliveryAddress,
            department: _strOrNull(json['deliveryDepartment']),
            info: _strOrNull(json['deliveryInfo']),
          )
        : null;

    return PurchaseRequestEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      title: json['title'] as String? ?? '',
      type: _typeFromJson(json['type']),
      category: _strOrNull(json['category']),
      originType: _originFromJson(json['originType']),
      assetId: _strOrNull(json['assetId']),
      notes: _strOrNull(json['notes']),
      delivery: delivery,
      itemsCount: items.length,
      items: items,
      vendorContactIds: vendorContactIds,
      status: json['status'] as String? ?? 'sent',
      respuestasCount: quotesRaw.length,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static PurchaseRequestModel modelFromServerJson(
    Map<String, dynamic> json,
  ) {
    final entity = entityFromServerJson(json);
    return PurchaseRequestModel(
      id: entity.id,
      orgId: entity.orgId,
      title: entity.title,
      typeWire: entity.type.wireName,
      category: entity.category,
      originTypeWire: entity.originType.wireName,
      assetId: entity.assetId,
      notes: entity.notes,
      deliveryCity: entity.delivery?.city,
      deliveryDepartment: entity.delivery?.department,
      deliveryAddress: entity.delivery?.address,
      deliveryInfo: entity.delivery?.info,
      itemsCount: entity.itemsCount,
      status: entity.status,
      respuestasCount: entity.respuestasCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

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
        notas: _strOrNull(quote['notes']),
        leadTimeDays: null,
        createdAt: _parseDate(quote['createdAt']),
        updatedAt: _parseDate(quote['updatedAt']),
      );

  static SupplierResponseModel supplierResponseModelFromQuoteJson(
    Map<String, dynamic> quote,
  ) =>
      SupplierResponseModel.fromEntity(supplierResponseFromQuoteJson(quote));
}

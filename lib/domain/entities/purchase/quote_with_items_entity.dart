// ============================================================================
// lib/domain/entities/purchase/quote_with_items_entity.dart
// QUOTE WITH ITEMS ENTITY — Cotización completa con items (read-only)
// ============================================================================
// QUÉ HACE:
//   - Representa una cotización recibida con el detalle de precios por ítem,
//     tal como la devuelve el backend en:
//       - POST /v1/purchase-requests/:id/quotes  → QuoteWithItems
//       - GET  /v1/purchase-requests/:id/comparison  → { quotes: QuoteWithItems[], best }
//   - Es el shape canónico de lectura; sustituye funcionalmente a
//     SupplierResponseEntity para la UI de detalle del PR (register + compare).
//
// QUÉ NO HACE:
//   - No persiste en Isar: es DTO de lectura efímera desde backend.
//   - No modela vendorContactId como identidad — es el mismo id opaco del
//     target (LocalContact.id para ActorRef.local).
//   - No define estado de aceptación/rechazo: la aceptación canónica es
//     `SourcingAward.CONFIRMED`, no un campo en Quote.
//
// PRINCIPIOS:
//   - Clase plana inmutable (const). Sin freezed para evitar build_runner.
//   - Migrable a @freezed en refactor futuro sin cambios de API.
//
// ENTERPRISE NOTES:
//   - `total` viene como string o number desde backend (Prisma.Decimal); el
//     fromJson normaliza a double para UI.
// ============================================================================

class QuoteItemEntity {
  /// ID del PurchaseRequestItem al que este precio responde.
  final String purchaseRequestItemId;

  /// Precio unitario cotizado por el proveedor (>=0).
  final double unitPrice;

  /// Notas específicas del ítem (ej: "sujeto a disponibilidad").
  final String? notes;

  const QuoteItemEntity({
    required this.purchaseRequestItemId,
    required this.unitPrice,
    this.notes,
  });

  factory QuoteItemEntity.fromJson(Map<String, dynamic> json) =>
      QuoteItemEntity(
        purchaseRequestItemId: json['purchaseRequestItemId'] as String,
        unitPrice: _toDouble(json['unitPrice']),
        notes: (json['notes'] as String?)?.trim().isEmpty == true
            ? null
            : json['notes'] as String?,
      );
}

/// Cotización (Quote) con el detalle de items que la componen.
class QuoteWithItemsEntity {
  /// UUID del Quote.
  final String id;

  /// UUID del PurchaseRequest al que pertenece.
  final String purchaseRequestId;

  /// ID opaco del proveedor/vendor (≡ LocalContact.id para ActorRef.local,
  /// ≡ PlatformActor.id para ActorRef.platform). El backend lo copia desde
  /// `PurchaseRequestTarget.vendorContactId`.
  final String vendorContactId;

  /// Total agregado de la cotización (suma de unitPrice * quantity del PR).
  final double total;

  /// Código ISO-4217 (default backend: "COP").
  final String currency;

  /// Fecha límite de validez (ISO-8601 en wire, DateTime en dominio).
  final DateTime? validUntil;

  /// Notas generales de la cotización.
  final String? notes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Detalle de precios por ítem del PR. Cubre todos los items (validación
  /// server-side al registrar).
  final List<QuoteItemEntity> items;

  const QuoteWithItemsEntity({
    required this.id,
    required this.purchaseRequestId,
    required this.vendorContactId,
    required this.total,
    required this.currency,
    this.validUntil,
    this.notes,
    this.createdAt,
    this.updatedAt,
    required this.items,
  });

  factory QuoteWithItemsEntity.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return QuoteWithItemsEntity(
      id: json['id'] as String,
      purchaseRequestId: json['purchaseRequestId'] as String,
      vendorContactId: json['vendorContactId'] as String,
      total: _toDouble(json['total']),
      currency: (json['currency'] as String?) ?? 'COP',
      validUntil: _parseDate(json['validUntil']),
      notes: (json['notes'] as String?)?.trim().isEmpty == true
          ? null
          : json['notes'] as String?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      items: rawItems
          .map((raw) => QuoteItemEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers internos
// ─────────────────────────────────────────────────────────────────────────────

double _toDouble(dynamic raw) {
  if (raw is double) return raw;
  if (raw is int) return raw.toDouble();
  if (raw is num) return raw.toDouble();
  if (raw is String) return double.tryParse(raw) ?? 0;
  return 0;
}

DateTime? _parseDate(dynamic raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}

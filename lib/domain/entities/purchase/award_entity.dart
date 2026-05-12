// ============================================================================
// lib/domain/entities/purchase/award_entity.dart
// SOURCING AWARD ENTITY — Adjudicación confirmada + líneas (read-only)
// ============================================================================
// QUÉ HACE:
//   - Representa la adjudicación de un PurchaseRequest tal como la devuelve el
//     backend en:
//       - POST /v1/purchase-requests/:id/award  → AwardWithLines
//       - GET  /v1/purchase-requests/:id/award  → AwardWithLines
//   - Contiene la decisión por línea: qué item, qué target gana, cuánto y
//     qué documento se generará (OC | OT | OC_AND_OT).
//
// QUÉ NO HACE:
//   - No persiste en Isar: read-only desde backend.
//   - No crea el award por sí misma: la creación es vía PurchaseRepository.
//   - No hace transiciones de estado: el service es single-shot (CONFIRMED).
//
// PRINCIPIOS:
//   - Espejo exacto de los tipos de retorno del backend (AwardService).
//   - Clase plana inmutable. Migrable a @freezed en refactor futuro.
//
// ENTERPRISE NOTES:
//   - `conversionType` viene como string wire-stable ('OC' | 'OT' | 'OC_AND_OT').
//   - `fulfillmentType` viene como string wire-stable ('GOODS' | 'SERVICE' | 'BOTH').
//   - `awardedQuantity` llega como string (Prisma.Decimal) o number; normalizado
//     a num en dominio.
// ============================================================================

/// Tipo de documento que se generará desde la línea al emitir.
enum AwardConversionType {
  oc('OC'),
  ot('OT'),
  ocAndOt('OC_AND_OT');

  final String wireName;
  const AwardConversionType(this.wireName);

  static AwardConversionType fromWire(String? raw) {
    for (final v in AwardConversionType.values) {
      if (v.wireName == raw) return v;
    }
    // Default seguro: OC (bienes). Si llega algo inesperado no rompemos UI.
    return AwardConversionType.oc;
  }
}

/// Naturaleza del ítem adjudicado, snapshot tomado en el award.
enum AwardFulfillmentType {
  goods('GOODS'),
  service('SERVICE'),
  both('BOTH');

  final String wireName;
  const AwardFulfillmentType(this.wireName);

  static AwardFulfillmentType fromWire(String? raw) {
    for (final v in AwardFulfillmentType.values) {
      if (v.wireName == raw) return v;
    }
    return AwardFulfillmentType.goods;
  }
}

class AwardLineEntity {
  final String id;
  final String awardId;
  final String purchaseRequestItemId;
  final String targetId;
  final String vendorContactId;
  final num awardedQuantity;
  final AwardFulfillmentType fulfillmentType;
  final AwardConversionType conversionType;
  final String? poDescription;
  final String? otDescription;
  final String? notes;

  const AwardLineEntity({
    required this.id,
    required this.awardId,
    required this.purchaseRequestItemId,
    required this.targetId,
    required this.vendorContactId,
    required this.awardedQuantity,
    required this.fulfillmentType,
    required this.conversionType,
    this.poDescription,
    this.otDescription,
    this.notes,
  });

  factory AwardLineEntity.fromJson(Map<String, dynamic> json) =>
      AwardLineEntity(
        id: json['id'] as String,
        awardId: json['awardId'] as String,
        purchaseRequestItemId: json['purchaseRequestItemId'] as String,
        targetId: json['targetId'] as String,
        vendorContactId: json['vendorContactId'] as String,
        awardedQuantity: _toNum(json['awardedQuantity']),
        fulfillmentType: AwardFulfillmentType.fromWire(
            json['fulfillmentType'] as String?),
        conversionType: AwardConversionType.fromWire(
            json['conversionType'] as String?),
        poDescription: _nonEmpty(json['poDescription']),
        otDescription: _nonEmpty(json['otDescription']),
        notes: _nonEmpty(json['notes']),
      );
}

class AwardEntity {
  final String id;
  final String orgId;
  final String purchaseRequestId;

  /// Wire-stable: 'DRAFT' | 'CONFIRMED' | 'CANCELLED'. Hoy el backend solo
  /// crea CONFIRMED en un paso.
  final String status;
  final String awardedBy;
  final DateTime awardedAt;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AwardLineEntity> lines;

  const AwardEntity({
    required this.id,
    required this.orgId,
    required this.purchaseRequestId,
    required this.status,
    required this.awardedBy,
    required this.awardedAt,
    this.notes,
    this.createdAt,
    this.updatedAt,
    required this.lines,
  });

  factory AwardEntity.fromJson(Map<String, dynamic> json) {
    final rawLines = (json['lines'] as List?) ?? const [];
    return AwardEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      purchaseRequestId: json['purchaseRequestId'] as String,
      status: json['status'] as String? ?? 'CONFIRMED',
      awardedBy: json['awardedBy'] as String,
      awardedAt: DateTime.tryParse(json['awardedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      notes: _nonEmpty(json['notes']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      lines: rawLines
          .map((raw) => AwardLineEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers internos
// ─────────────────────────────────────────────────────────────────────────────

num _toNum(dynamic raw) {
  if (raw is num) return raw;
  if (raw is String) return num.tryParse(raw) ?? 0;
  return 0;
}

String? _nonEmpty(dynamic raw) {
  if (raw is String && raw.trim().isNotEmpty) return raw;
  return null;
}

DateTime? _parseDate(dynamic raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}

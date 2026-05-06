// ============================================================================
// lib/domain/entities/purchase/purchase_document_entities.dart
// PURCHASE ORDER + WORK ORDER ENTITIES — Documentos emitidos (read-only)
// ============================================================================
// QUÉ HACE:
//   - Representa las Órdenes de Compra (OC) y Órdenes de Trabajo (OT)
//     generadas desde un SourcingAward CONFIRMED, tal como las devuelve:
//       - POST /v1/sourcing-awards/:id/generate-documents
//         → GenerateDocumentsResult { awardId, purchaseOrders[], workOrders[] }
//     y como aparecen en:
//       - GET  /v1/purchase-requests/:id/summary → { purchaseOrders[], workOrders[] }
//
// QUÉ NO HACE:
//   - No persiste en Isar: read-only desde backend.
//   - No modela recepciones ni precio real: ese detalle es Fase 9 backend y
//     se consulta por separado si aplica.
//
// PRINCIPIOS:
//   - Clases planas inmutables. Migrables a @freezed en refactor futuro.
//   - Números como `num` (backend envía Decimal como string o number).
// ============================================================================

class PurchaseOrderLineEntity {
  final String id;
  final String purchaseOrderId;
  final String awardLineId;
  final String purchaseRequestItemId;
  final String description;
  final num quantity;
  final String unit;
  final String fulfillmentType;
  final double? unitPrice;
  final double? actualUnitPrice;
  final num receivedQuantity;
  final String? notes;

  const PurchaseOrderLineEntity({
    required this.id,
    required this.purchaseOrderId,
    required this.awardLineId,
    required this.purchaseRequestItemId,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.fulfillmentType,
    this.unitPrice,
    this.actualUnitPrice,
    required this.receivedQuantity,
    this.notes,
  });

  factory PurchaseOrderLineEntity.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderLineEntity(
        id: json['id'] as String,
        purchaseOrderId: json['purchaseOrderId'] as String,
        awardLineId: json['awardLineId'] as String,
        purchaseRequestItemId: json['purchaseRequestItemId'] as String,
        description: json['description'] as String? ?? '',
        quantity: _toNum(json['quantity']),
        unit: json['unit'] as String? ?? 'und',
        fulfillmentType: json['fulfillmentType'] as String? ?? 'GOODS',
        unitPrice: _toDoubleOrNull(json['unitPrice']),
        actualUnitPrice: _toDoubleOrNull(json['actualUnitPrice']),
        receivedQuantity: _toNum(json['receivedQuantity']),
        notes: _nonEmpty(json['notes']),
      );
}

class PurchaseOrderEntity {
  final String id;
  final String orgId;

  /// Número legible: PO-YYYYMMDD-XXXXX (único).
  final String number;

  /// Wire-stable: 'ISSUED' | 'PARTIALLY_RECEIVED' | 'RECEIVED' | 'CANCELLED'.
  final String status;
  final String vendorContactId;
  final String purchaseRequestId;
  final String awardId;
  final String issuedBy;
  final DateTime issuedAt;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PurchaseOrderLineEntity> lines;

  const PurchaseOrderEntity({
    required this.id,
    required this.orgId,
    required this.number,
    required this.status,
    required this.vendorContactId,
    required this.purchaseRequestId,
    required this.awardId,
    required this.issuedBy,
    required this.issuedAt,
    this.notes,
    this.createdAt,
    this.updatedAt,
    required this.lines,
  });

  factory PurchaseOrderEntity.fromJson(Map<String, dynamic> json) {
    final rawLines = (json['lines'] as List?) ?? const [];
    return PurchaseOrderEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      number: json['number'] as String? ?? '',
      status: json['status'] as String? ?? 'ISSUED',
      vendorContactId: json['vendorContactId'] as String,
      purchaseRequestId: json['purchaseRequestId'] as String,
      awardId: json['awardId'] as String,
      issuedBy: json['issuedBy'] as String,
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      notes: _nonEmpty(json['notes']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      lines: rawLines
          .map((raw) =>
              PurchaseOrderLineEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class WorkOrderLineEntity {
  final String id;
  final String workOrderId;
  final String awardLineId;
  final String purchaseRequestItemId;
  final String description;
  final num quantity;
  final String unit;
  final String fulfillmentType;
  final String? notes;

  const WorkOrderLineEntity({
    required this.id,
    required this.workOrderId,
    required this.awardLineId,
    required this.purchaseRequestItemId,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.fulfillmentType,
    this.notes,
  });

  factory WorkOrderLineEntity.fromJson(Map<String, dynamic> json) =>
      WorkOrderLineEntity(
        id: json['id'] as String,
        workOrderId: json['workOrderId'] as String,
        awardLineId: json['awardLineId'] as String,
        purchaseRequestItemId: json['purchaseRequestItemId'] as String,
        description: json['description'] as String? ?? '',
        quantity: _toNum(json['quantity']),
        unit: json['unit'] as String? ?? 'und',
        fulfillmentType: json['fulfillmentType'] as String? ?? 'SERVICE',
        notes: _nonEmpty(json['notes']),
      );
}

class WorkOrderEntity {
  final String id;
  final String orgId;

  /// Número legible: WO-YYYYMMDD-XXXXX (único).
  final String number;

  /// Wire-stable: 'OPEN' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED'.
  final String status;
  final String vendorContactId;
  final String purchaseRequestId;
  final String awardId;
  final String createdBy;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<WorkOrderLineEntity> lines;

  const WorkOrderEntity({
    required this.id,
    required this.orgId,
    required this.number,
    required this.status,
    required this.vendorContactId,
    required this.purchaseRequestId,
    required this.awardId,
    required this.createdBy,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.notes,
    this.createdAt,
    this.updatedAt,
    required this.lines,
  });

  factory WorkOrderEntity.fromJson(Map<String, dynamic> json) {
    final rawLines = (json['lines'] as List?) ?? const [];
    return WorkOrderEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      number: json['number'] as String? ?? '',
      status: json['status'] as String? ?? 'OPEN',
      vendorContactId: json['vendorContactId'] as String,
      purchaseRequestId: json['purchaseRequestId'] as String,
      awardId: json['awardId'] as String,
      createdBy: json['createdBy'] as String,
      startedAt: _parseDate(json['startedAt']),
      completedAt: _parseDate(json['completedAt']),
      cancelledAt: _parseDate(json['cancelledAt']),
      notes: _nonEmpty(json['notes']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      lines: rawLines
          .map((raw) =>
              WorkOrderLineEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

/// Response del endpoint `generate-documents`. Agrupa OC y OT emitidas desde
/// un award. Es el artefacto que demuestra el cierre operativo del loop.
class GenerateDocumentsResultEntity {
  final String awardId;
  final List<PurchaseOrderEntity> purchaseOrders;
  final List<WorkOrderEntity> workOrders;

  const GenerateDocumentsResultEntity({
    required this.awardId,
    required this.purchaseOrders,
    required this.workOrders,
  });

  factory GenerateDocumentsResultEntity.fromJson(Map<String, dynamic> json) {
    final pos = (json['purchaseOrders'] as List?) ?? const [];
    final wos = (json['workOrders'] as List?) ?? const [];
    return GenerateDocumentsResultEntity(
      awardId: json['awardId'] as String,
      purchaseOrders: pos
          .map((raw) =>
              PurchaseOrderEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
      workOrders: wos
          .map((raw) => WorkOrderEntity.fromJson(raw as Map<String, dynamic>))
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

double? _toDoubleOrNull(dynamic raw) {
  if (raw == null) return null;
  if (raw is double) return raw;
  if (raw is int) return raw.toDouble();
  if (raw is num) return raw.toDouble();
  if (raw is String) {
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }
  return null;
}

String? _nonEmpty(dynamic raw) {
  if (raw is String && raw.trim().isNotEmpty) return raw;
  return null;
}

DateTime? _parseDate(dynamic raw) {
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}

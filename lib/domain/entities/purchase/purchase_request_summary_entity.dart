// ============================================================================
// lib/domain/entities/purchase/purchase_request_summary_entity.dart
// PURCHASE REQUEST SUMMARY ENTITY — Estado operativo + canClose
// ============================================================================
// QUÉ HACE:
//   - Representa el resumen operativo completo de un PurchaseRequest que
//     devuelve el backend en GET /v1/purchase-requests/:id/summary.
//   - Incluye items, awards, purchaseOrders, workOrders y el bloque
//     `completion` con `canClose`, `isOperationallyComplete`, `missingActions[]`.
//   - Es la ÚNICA fuente de verdad para decidir si el botón "Cerrar PR" de la
//     UI puede habilitarse. Backend exige `canClose=true` para `POST /close`.
//
// QUÉ NO HACE:
//   - No persiste en Isar: read-only desde backend.
//   - No calcula canClose en cliente: la lógica vive en backend
//     (purchase-request-summary.service.ts).
//
// PRINCIPIOS:
//   - Espejo exacto del DTO `PurchaseRequestSummaryResult` del backend.
//   - Códigos de `missingActions` se conservan wire-stable (string) para que
//     la UI pueda mapear a labels localizables sin acoplarse a enums Dart.
//
// ENTERPRISE NOTES:
//   - Posibles `missingActions`:
//       REQUEST_NOT_AWARDED, DOCUMENTS_NOT_GENERATED,
//       PURCHASE_ORDERS_PENDING_RECEIPT, PURCHASE_ORDERS_CANCELLED,
//       WORK_ORDERS_PENDING_EXECUTION, WORK_ORDERS_CANCELLED.
// ============================================================================

class SummaryRequestEntity {
  final String id;
  final String orgId;
  final String title;
  final String status;
  final String requestedBy;
  final String? notes;
  final DateTime? closedAt;
  final String? closedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SummaryRequestEntity({
    required this.id,
    required this.orgId,
    required this.title,
    required this.status,
    required this.requestedBy,
    this.notes,
    this.closedAt,
    this.closedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SummaryRequestEntity.fromJson(Map<String, dynamic> json) =>
      SummaryRequestEntity(
        id: json['id'] as String,
        orgId: json['orgId'] as String,
        title: json['title'] as String? ?? '',
        status: json['status'] as String? ?? 'sent',
        requestedBy: json['requestedBy'] as String,
        notes: _nonEmpty(json['notes']),
        closedAt: _parseDate(json['closedAt']),
        closedBy: _nonEmpty(json['closedBy']),
        createdAt: _parseDate(json['createdAt']),
        updatedAt: _parseDate(json['updatedAt']),
      );
}

class SummaryItemEntity {
  final String id;
  final String description;
  final num quantity;
  final String unit;
  final String fulfillmentType;
  final String coverageStatus;

  const SummaryItemEntity({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.fulfillmentType,
    required this.coverageStatus,
  });

  factory SummaryItemEntity.fromJson(Map<String, dynamic> json) =>
      SummaryItemEntity(
        id: json['id'] as String,
        description: json['description'] as String? ?? '',
        quantity: _toNum(json['quantity']),
        unit: json['unit'] as String? ?? 'und',
        fulfillmentType: json['fulfillmentType'] as String? ?? 'GOODS',
        coverageStatus: json['coverageStatus'] as String? ?? 'uncovered',
      );
}

class SummaryAwardEntity {
  final String id;
  final String status;
  final String awardedBy;
  final DateTime awardedAt;
  final int lineCount;

  const SummaryAwardEntity({
    required this.id,
    required this.status,
    required this.awardedBy,
    required this.awardedAt,
    required this.lineCount,
  });

  factory SummaryAwardEntity.fromJson(Map<String, dynamic> json) =>
      SummaryAwardEntity(
        id: json['id'] as String,
        status: json['status'] as String? ?? 'CONFIRMED',
        awardedBy: json['awardedBy'] as String,
        awardedAt: DateTime.tryParse(json['awardedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        lineCount: (json['lineCount'] as num?)?.toInt() ?? 0,
      );
}

class SummaryDocumentRefEntity {
  final String id;
  final String number;
  final String status;
  final String vendorContactId;

  const SummaryDocumentRefEntity({
    required this.id,
    required this.number,
    required this.status,
    required this.vendorContactId,
  });

  factory SummaryDocumentRefEntity.fromJson(Map<String, dynamic> json) =>
      SummaryDocumentRefEntity(
        id: json['id'] as String,
        number: json['number'] as String? ?? '',
        status: json['status'] as String? ?? '',
        vendorContactId: json['vendorContactId'] as String,
      );
}

class CompletionSummaryEntity {
  final bool hasAwards;
  final bool hasDocuments;
  final bool isOperationallyComplete;
  final bool canClose;
  final List<String> missingActions;

  const CompletionSummaryEntity({
    required this.hasAwards,
    required this.hasDocuments,
    required this.isOperationallyComplete,
    required this.canClose,
    required this.missingActions,
  });

  factory CompletionSummaryEntity.fromJson(Map<String, dynamic> json) {
    final rawMissing = (json['missingActions'] as List?) ?? const [];
    return CompletionSummaryEntity(
      hasAwards: json['hasAwards'] as bool? ?? false,
      hasDocuments: json['hasDocuments'] as bool? ?? false,
      isOperationallyComplete:
          json['isOperationallyComplete'] as bool? ?? false,
      canClose: json['canClose'] as bool? ?? false,
      missingActions: rawMissing.whereType<String>().toList(growable: false),
    );
  }
}

class PurchaseRequestSummaryEntity {
  final SummaryRequestEntity request;
  final List<SummaryItemEntity> items;
  final int itemsCount;
  final int awardsCount;
  final int purchaseOrdersCount;
  final int workOrdersCount;
  final List<SummaryAwardEntity> awards;
  final List<SummaryDocumentRefEntity> purchaseOrders;
  final List<SummaryDocumentRefEntity> workOrders;
  final CompletionSummaryEntity completion;

  const PurchaseRequestSummaryEntity({
    required this.request,
    required this.items,
    required this.itemsCount,
    required this.awardsCount,
    required this.purchaseOrdersCount,
    required this.workOrdersCount,
    required this.awards,
    required this.purchaseOrders,
    required this.workOrders,
    required this.completion,
  });

  factory PurchaseRequestSummaryEntity.fromJson(Map<String, dynamic> json) {
    final counts = (json['counts'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final rawItems = (json['items'] as List?) ?? const [];
    final rawAwards = (json['awards'] as List?) ?? const [];
    final rawPos = (json['purchaseOrders'] as List?) ?? const [];
    final rawWos = (json['workOrders'] as List?) ?? const [];
    return PurchaseRequestSummaryEntity(
      request: SummaryRequestEntity.fromJson(
          json['request'] as Map<String, dynamic>),
      items: rawItems
          .map((raw) => SummaryItemEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
      itemsCount: (counts['items'] as num?)?.toInt() ?? rawItems.length,
      awardsCount: (counts['awards'] as num?)?.toInt() ?? rawAwards.length,
      purchaseOrdersCount:
          (counts['purchaseOrders'] as num?)?.toInt() ?? rawPos.length,
      workOrdersCount: (counts['workOrders'] as num?)?.toInt() ?? rawWos.length,
      awards: rawAwards
          .map((raw) =>
              SummaryAwardEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
      purchaseOrders: rawPos
          .map((raw) =>
              SummaryDocumentRefEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
      workOrders: rawWos
          .map((raw) =>
              SummaryDocumentRefEntity.fromJson(raw as Map<String, dynamic>))
          .toList(growable: false),
      completion: CompletionSummaryEntity.fromJson(
          json['completion'] as Map<String, dynamic>),
    );
  }
}

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

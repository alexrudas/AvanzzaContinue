// ============================================================================
// lib/domain/entities/purchase/purchase_request_detail_entity.dart
// PURCHASE REQUEST DETAIL — header + items + targets (read-only)
// ============================================================================
// QUÉ HACE:
//   - Representa la respuesta completa de GET /v1/purchase-requests/:id del
//     backend. A diferencia de PurchaseRequestEntity (usado en list/cache
//     Isar con `vendorContactIds: List<String>`), aquí expone `targets[]` con
//     su UUID, actorRefKind y vendorContactId; estos datos son indispensables
//     para crear cotizaciones y awards (cada award line referencia targetId).
//
// QUÉ NO HACE:
//   - No persiste en Isar: read-only desde backend. El PR resumido sigue
//     viviendo en cache como PurchaseRequestModel/PurchaseRequestEntity.
//   - No duplica lógica de estado: el estado `canClose` vive en Summary.
//
// PRINCIPIOS:
//   - Espejo 1:1 de `PurchaseRequestWithRelations` del backend
//     (purchase-request.service.ts — include: items + targets + quotes).
//   - Clases planas inmutables; migrables a @freezed en refactor futuro.
//
// ENTERPRISE NOTES:
//   - Cuando `actorRefKind='local'`, `localKind/localId` vienen populados y
//     `platformActorId` queda null. Cuando `actorRefKind='platform'`, al revés.
//   - `vendorContactId` es compat-column: para `local`, vale `localId`; para
//     `platform`, vale `platformActorId`. Se usa como identificador estable
//     en submit-quote y create-award.
// ============================================================================

class PurchaseRequestTargetEntity {
  /// UUID del PurchaseRequestTarget (necesario para adjudicar).
  final String id;

  final String purchaseRequestId;

  /// Wire-stable: 'local' | 'platform'.
  final String actorRefKind;

  final String? platformActorId;

  /// Wire-stable: 'contact' | 'organization'.
  final String? localKind;
  final String? localId;

  /// Compat column — coincide con localId o platformActorId según actorRefKind.
  final String vendorContactId;

  /// (PF1, 2026-04-27) Workspace destino del proveedor real.
  /// Backend lo persiste cuando el target nace vía matching canónico
  /// (`useProviderMatching=true`) — NUNCA equivale al workspace solicitante
  /// (multi-actor invariant). Null en filas legacy o cuando el matching no
  /// resolvió ProviderProfile.
  final String? targetWorkspaceId;

  /// (PF1, 2026-04-27) ProviderProfile asociado al target. Backend lo
  /// hidrata cuando el matching corrió. Null en camino legacy.
  final String? providerProfileId;

  /// Wire-stable: 'pending' | 'responded' | 'rejected'.
  final String status;

  /// Ronda de invitación (si aplica re-envío; en v1 siempre 0).
  final int round;

  final DateTime? sentAt;
  final DateTime? respondedAt;

  const PurchaseRequestTargetEntity({
    required this.id,
    required this.purchaseRequestId,
    required this.actorRefKind,
    this.platformActorId,
    this.localKind,
    this.localId,
    required this.vendorContactId,
    this.targetWorkspaceId,
    this.providerProfileId,
    required this.status,
    this.round = 0,
    this.sentAt,
    this.respondedAt,
  });

  factory PurchaseRequestTargetEntity.fromJson(Map<String, dynamic> json) =>
      PurchaseRequestTargetEntity(
        id: json['id'] as String,
        purchaseRequestId: json['purchaseRequestId'] as String,
        actorRefKind: json['actorRefKind'] as String? ?? 'local',
        platformActorId: _nonEmpty(json['platformActorId']),
        localKind: _nonEmpty(json['localKind']),
        localId: _nonEmpty(json['localId']),
        vendorContactId: json['vendorContactId'] as String? ?? '',
        targetWorkspaceId: _nonEmpty(json['targetWorkspaceId']),
        providerProfileId: _nonEmpty(json['providerProfileId']),
        status: json['status'] as String? ?? 'pending',
        round: (json['round'] as num?)?.toInt() ?? 0,
        sentAt: _parseDate(json['sentAt']),
        respondedAt: _parseDate(json['respondedAt']),
      );
}

class PurchaseRequestDetailItemEntity {
  final String id;
  final String description;
  final num quantity;
  final String unit;
  final String? notes;

  /// Wire-stable: 'GOODS' | 'SERVICE' | 'BOTH'. Guía el award.conversionType.
  final String fulfillmentType;

  /// Wire-stable: 'uncovered' | 'partially_covered' | 'covered'. Lo mantiene
  /// backend por BI; la UI no decide nada crítico con este campo.
  final String coverageStatus;

  const PurchaseRequestDetailItemEntity({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    this.notes,
    required this.fulfillmentType,
    required this.coverageStatus,
  });

  factory PurchaseRequestDetailItemEntity.fromJson(Map<String, dynamic> json) =>
      PurchaseRequestDetailItemEntity(
        id: json['id'] as String,
        description: json['description'] as String? ?? '',
        quantity: _toNum(json['quantity']),
        unit: json['unit'] as String? ?? 'und',
        notes: _nonEmpty(json['notes']),
        fulfillmentType: json['fulfillmentType'] as String? ?? 'GOODS',
        coverageStatus: json['coverageStatus'] as String? ?? 'uncovered',
      );
}

class PurchaseRequestDetailEntity {
  final String id;
  final String orgId;
  final String title;

  /// Wire-stable: 'PRODUCT' | 'SERVICE'.
  final String type;
  final String? category;

  /// Wire-stable: 'ASSET' | 'INVENTORY' | 'GENERAL'.
  final String originType;
  final String? assetId;
  final String? notes;

  /// Wire-stable: 'sent' | 'partially_responded' | 'responded' | 'closed'.
  final String status;

  final String? deliveryCity;
  final String? deliveryDepartment;
  final String? deliveryAddress;
  final String? deliveryInfo;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final String? closedBy;

  final List<PurchaseRequestDetailItemEntity> items;
  final List<PurchaseRequestTargetEntity> targets;

  const PurchaseRequestDetailEntity({
    required this.id,
    required this.orgId,
    required this.title,
    required this.type,
    this.category,
    required this.originType,
    this.assetId,
    this.notes,
    required this.status,
    this.deliveryCity,
    this.deliveryDepartment,
    this.deliveryAddress,
    this.deliveryInfo,
    this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.closedBy,
    required this.items,
    required this.targets,
  });

  factory PurchaseRequestDetailEntity.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    final rawTargets = (json['targets'] as List?) ?? const [];
    return PurchaseRequestDetailEntity(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'PRODUCT',
      category: _nonEmpty(json['category']),
      originType: json['originType'] as String? ?? 'GENERAL',
      assetId: _nonEmpty(json['assetId']),
      notes: _nonEmpty(json['notes']),
      status: json['status'] as String? ?? 'sent',
      deliveryCity: _nonEmpty(json['deliveryCity']),
      deliveryDepartment: _nonEmpty(json['deliveryDepartment']),
      deliveryAddress: _nonEmpty(json['deliveryAddress']),
      deliveryInfo: _nonEmpty(json['deliveryInfo']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      closedAt: _parseDate(json['closedAt']),
      closedBy: _nonEmpty(json['closedBy']),
      items: rawItems
          .map((raw) => PurchaseRequestDetailItemEntity.fromJson(
              raw as Map<String, dynamic>))
          .toList(growable: false),
      targets: rawTargets
          .map((raw) => PurchaseRequestTargetEntity.fromJson(
              raw as Map<String, dynamic>))
          .toList(growable: false),
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

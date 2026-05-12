// ============================================================================
// lib/domain/entities/purchase/purchase_request_entity.dart
// PURCHASE REQUEST ENTITY — Representación canónica de lectura
// ============================================================================
// QUÉ HACE:
//   - Representa una PurchaseRequest alineada al contrato backend canónico:
//     title, type, category, originType, assetId, notes, delivery{flat},
//     items[], vendorContactIds[], status, respuestasCount, createdAt/updatedAt.
//   - Sustituye al entity legacy (tipoRepuesto/cantidad/ciudadEntrega/specs).
//
// QUÉ NO HACE:
//   - No contiene quotes/awards/PO/WO; eso se consulta on-demand al backend.
//   - No incluye lógica de persistencia (eso vive en data/models).
//
// ENTERPRISE NOTES:
//   - `items` puede venir vacío en la representación leída desde cache Isar
//     (la cache persiste header + itemsCount; los ítems detallados viajan
//     solo cuando vienen de la respuesta directa del backend).
//   - `status` se mantiene como string wire-stable (sent | partially_responded
//     | responded | closed) para no acoplar lecturas a un enum TS→Dart.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_purchase_request_input.dart';

part 'purchase_request_entity.freezed.dart';
part 'purchase_request_entity.g.dart';

/// Ítem individual de una solicitud.
@freezed
abstract class PurchaseRequestItemEntity with _$PurchaseRequestItemEntity {
  const factory PurchaseRequestItemEntity({
    required String id,
    required String description,
    required num quantity,
    required String unit,
    String? notes,
  }) = _PurchaseRequestItemEntity;

  factory PurchaseRequestItemEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestItemEntityFromJson(json);
}

/// Dirección estructurada de entrega (flat en persistencia, anidada aquí).
@freezed
abstract class PurchaseRequestDeliveryEntity
    with _$PurchaseRequestDeliveryEntity {
  const factory PurchaseRequestDeliveryEntity({
    String? department,
    required String city,
    required String address,
    String? info,
  }) = _PurchaseRequestDeliveryEntity;

  factory PurchaseRequestDeliveryEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestDeliveryEntityFromJson(json);
}

/// Snapshot de VehicleSpec dentro de una PurchaseRequest leída.
///
/// Este bloque solo se puebla para pedidos de inventario/stock cuyo target es
/// una especificación de vehículo derivada del parque real del workspace.
/// Vive solo en la cache local (el backend canónico aún no lo conoce); sirve
/// para que la UI de detalle pueda seguir mostrando contexto offline.
@freezed
abstract class PurchaseRequestVehicleSpecSnapshot
    with _$PurchaseRequestVehicleSpecSnapshot {
  const factory PurchaseRequestVehicleSpecSnapshot({
    required String vehicleSpecId,
    required String displayLabel,
    required String make,
    required String model,
    required int year,
    String? version,
    String? motorization,
    int? engineDisplacementCc,
    String? transmission,
    int? linkedAssetsCountSnapshot,
  }) = _PurchaseRequestVehicleSpecSnapshot;

  factory PurchaseRequestVehicleSpecSnapshot.fromJson(
          Map<String, dynamic> json) =>
      _$PurchaseRequestVehicleSpecSnapshotFromJson(json);
}

@freezed
abstract class PurchaseRequestEntity with _$PurchaseRequestEntity {
  const factory PurchaseRequestEntity({
    required String id,
    required String orgId,
    required String title,
    required PurchaseRequestTypeInput type,
    String? category,
    required PurchaseRequestOriginInput originType,
    String? assetId,
    String? notes,
    PurchaseRequestDeliveryEntity? delivery,

    /// Cuenta de ítems (útil para list/detail sin cargar ítems detallados).
    @Default(0) int itemsCount,

    /// Ítems detallados. Puede venir vacío cuando la entidad nace de cache.
    @Default(<PurchaseRequestItemEntity>[])
    List<PurchaseRequestItemEntity> items,
    @Default(<String>[]) List<String> vendorContactIds,

    /// Estado wire-stable: sent | partially_responded | responded | closed.
    required String status,
    @Default(0) int respuestasCount,
    DateTime? createdAt,
    DateTime? updatedAt,

    /// Target opcional: VehicleSpec snapshot cuando el pedido fue para
    /// inventario/stock de un grupo marca/modelo/año.
    PurchaseRequestVehicleSpecSnapshot? vehicleSpec,
  }) = _PurchaseRequestEntity;

  factory PurchaseRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestEntityFromJson(json);
}

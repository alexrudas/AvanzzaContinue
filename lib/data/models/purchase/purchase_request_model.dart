// ============================================================================
// lib/data/models/purchase/purchase_request_model.dart
// PURCHASE REQUEST MODEL (Isar cache) — alineado al contrato canónico
// ============================================================================
// QUÉ HACE:
//   - Persiste en Isar el header canónico de una PurchaseRequest (title, type
//     wire-string, category, originType wire-string, assetId, notes, delivery
//     flat, status, counts, timestamps).
//   - NO persiste la lista detallada de ítems ni vendorContactIds — esas se
//     cargan on-demand desde backend cuando el caller las necesite.
//
// QUÉ NO HACE:
//   - No acopla el contrato persistente a enums Dart: persiste strings wire
//     para ser tolerante a renames del enum en dominio.
//
// PRINCIPIOS:
//   - Isar cache es para listados (admin), no source of truth.
//   - El mapper server→model traduce enums a wire-string y cuenta items.
// ============================================================================

import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/purchase/create_purchase_request_input.dart';
import '../../../domain/entities/purchase/purchase_request_entity.dart'
    as domain;

part 'purchase_request_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class PurchaseRequestModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String orgId;

  final String title;
  final String typeWire; // 'PRODUCT' | 'SERVICE'
  final String? category;
  final String originTypeWire; // 'ASSET' | 'INVENTORY' | 'GENERAL'
  @Index()
  final String? assetId;
  final String? notes;

  // Delivery flat (nullable en bloque)
  final String? deliveryCity;
  final String? deliveryDepartment;
  final String? deliveryAddress;
  final String? deliveryInfo;

  final int itemsCount;

  @Index()
  final String status; // sent | partially_responded | responded | closed
  final int respuestasCount;

  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  PurchaseRequestModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.title,
    required this.typeWire,
    this.category,
    required this.originTypeWire,
    this.assetId,
    this.notes,
    this.deliveryCity,
    this.deliveryDepartment,
    this.deliveryAddress,
    this.deliveryInfo,
    this.itemsCount = 0,
    required this.status,
    this.respuestasCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseRequestModelToJson(this);

  // ───────────────────────────────────────────────────────────────────────────
  // Mapping to domain
  // ───────────────────────────────────────────────────────────────────────────

  domain.PurchaseRequestEntity toEntity() {
    final hasDelivery = (deliveryCity ?? '').isNotEmpty &&
        (deliveryAddress ?? '').isNotEmpty;
    return domain.PurchaseRequestEntity(
      id: id,
      orgId: orgId,
      title: title,
      type: _typeFromWire(typeWire),
      category: category,
      originType: _originFromWire(originTypeWire),
      assetId: assetId,
      notes: notes,
      delivery: hasDelivery
          ? domain.PurchaseRequestDeliveryEntity(
              department: deliveryDepartment,
              city: deliveryCity!,
              address: deliveryAddress!,
              info: deliveryInfo,
            )
          : null,
      itemsCount: itemsCount,
      items: const <domain.PurchaseRequestItemEntity>[],
      vendorContactIds: const <String>[],
      status: status,
      respuestasCount: respuestasCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PurchaseRequestTypeInput _typeFromWire(String wire) {
    for (final t in PurchaseRequestTypeInput.values) {
      if (t.wireName == wire) return t;
    }
    return PurchaseRequestTypeInput.product;
  }

  static PurchaseRequestOriginInput _originFromWire(String wire) {
    for (final o in PurchaseRequestOriginInput.values) {
      if (o.wireName == wire) return o;
    }
    return PurchaseRequestOriginInput.general;
  }
}

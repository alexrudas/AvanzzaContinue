// ============================================================================
// lib/data/models/insurance/insurance_policy_model.dart
// INSURANCE POLICY MODEL — Modelo Isar + Firestore para pólizas de seguro
//
// QUÉ HACE:
// - Define InsurancePolicyModel con anotaciones Isar (@Collection) y
//   json_serializable para persistencia local y remota.
// - Mapea hacia/desde InsurancePolicyEntity del dominio.
// - Expone fromFirestore, fromEntity y toEntity.
// - `policyId`: UUID por póliza para AssetPolicyMerger. @Index aditivo.
//   Nullable en Isar para compatibilidad con registros legacy.
//   Fallback '' en toEntity() — el data source genera y persiste el UUID
//   antes de retornar si policyId == null.
// - `overrideJson`: estado de bloqueo serializado como JSON string en Isar.
//   Getter @ignore `override` deserializa al vuelo. No persistido en Firestore
//   directamente — el campo `override` en Firestore lo lee el merger desde el
//   Map<String, dynamic> del documento.
//
// QUÉ NO HACE:
// - No calcula vigencia; el campo estado puede estar stale — calcular desde fechaFin.
// - No implementa lógica de negocio.
// - No cambia el tipo de tipo de String a enum (evita migración destructiva Isar).
// - No genera UUID; la generación es responsabilidad del data source.
//
// PRINCIPIOS:
// - El campo tipo permanece String en Isar para compatibilidad de esquema.
// - @Index() en tipo (aditivo, seguro) habilita queries .tipoEqualTo() eficientes.
// - Wire values de tipo deben coincidir con InsurancePolicyType.toWireString().
// - Cambios en policyId y overrideJson son ADITIVOS — no destruyen esquema Isar.
//
// ENTERPRISE NOTES:
// CREADO   (2026-03): Modelo Isar/Firestore original sin índice en tipo.
// ADAPTADO (2026-03): Track A — Se añade @Index() en tipo para queries
//   eficientes por tipo de póliza (latestPolicyByTipo). Cambio aditivo, no
//   destructivo del esquema Isar. Requiere build_runner para regenerar .g.dart.
// ADAPTADO (2026-03): Fase 2 — Asset Schema v1.3.4. Campos policyId y overrideJson.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/asset/asset_policy_override.dart';
import '../../../domain/entities/insurance/insurance_policy_entity.dart'
    as domain;

part 'insurance_policy_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class InsurancePolicyModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String assetId;

  /// Wire value del tipo de póliza. Ver InsurancePolicyType para valores válidos.
  /// @Index() añadido en Track A para soportar queries eficientes por tipo.
  @Index()
  final String tipo;
  final String aseguradora;
  final double tarifaBase;
  final String currencyCode;
  @Index()
  final String countryId;
  @Index()
  final String? cityId;
  @DateTimeTimestampConverter()
  final DateTime fechaInicio;
  @DateTimeTimestampConverter()
  final DateTime fechaFin;
  @Index()
  final String estado;

  /// UUID único por póliza para AssetPolicyMerger.
  ///
  /// Nullable en Isar para compatibilidad con registros pre-v1.3.4.
  /// El data source (InsuranceLocalDataSource) genera y persiste el UUID
  /// antes de retornar si este campo es null.
  @Index()
  final String? policyId;

  /// Estado de bloqueo de la póliza serializado como JSON string.
  ///
  /// Usar el getter [override] para acceder al valor deserializado.
  /// Si es null → póliza no bloqueada (AssetPolicyOverride.unlocked).
  final String? overrideJson;

  /// Estado de bloqueo de la póliza deserializado desde [overrideJson].
  ///
  /// @ignore: campo calculado, no persistido por Isar.
  @ignore
  AssetPolicyOverride get override {
    if (overrideJson == null) return AssetPolicyOverride.unlocked;
    try {
      return AssetPolicyOverride.fromJson(
        jsonDecode(overrideJson!) as Map<String, dynamic>,
      );
    } catch (_) {
      return AssetPolicyOverride.unlocked;
    }
  }

  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  InsurancePolicyModel({
    this.isarId,
    required this.id,
    required this.assetId,
    required this.tipo,
    required this.aseguradora,
    required this.tarifaBase,
    required this.currencyCode,
    required this.countryId,
    this.cityId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    this.policyId,
    this.overrideJson,
    this.createdAt,
    this.updatedAt,
  });

  factory InsurancePolicyModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyModelFromJson(json);
  Map<String, dynamic> toJson() => _$InsurancePolicyModelToJson(this);
  factory InsurancePolicyModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      InsurancePolicyModel.fromJson({...json, 'id': docId});

  factory InsurancePolicyModel.fromEntity(domain.InsurancePolicyEntity e) =>
      InsurancePolicyModel(
        id: e.id,
        assetId: e.assetId,
        tipo: e.tipo,
        aseguradora: e.aseguradora,
        tarifaBase: e.tarifaBase,
        currencyCode: e.currencyCode,
        countryId: e.countryId,
        cityId: e.cityId,
        fechaInicio: e.fechaInicio,
        fechaFin: e.fechaFin,
        estado: e.estado,
        // policyId '' → null en Isar para que el data source lo genere si es vacío.
        policyId: e.policyId.isEmpty ? null : e.policyId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.InsurancePolicyEntity toEntity() => domain.InsurancePolicyEntity(
        id: id,
        assetId: assetId,
        tipo: tipo,
        aseguradora: aseguradora,
        tarifaBase: tarifaBase,
        currencyCode: currencyCode,
        countryId: countryId,
        cityId: cityId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        estado: estado,
        // policyId null (pre-v1.3.4) → '' en entidad. El data source genera
        // y persiste el UUID antes de llamar toEntity().
        policyId: policyId ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

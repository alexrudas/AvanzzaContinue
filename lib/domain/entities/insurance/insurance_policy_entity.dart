// ============================================================================
// lib/domain/entities/insurance/insurance_policy_entity.dart
// INSURANCE POLICY ENTITY — Entidad de dominio para pólizas de seguro
//
// QUÉ HACE:
// - Define InsurancePolicyEntity (freezed) con todos los campos de una póliza.
// - Define InsurancePolicyType enum con wire-values estables para discriminar
//   el tipo de póliza: soat, rc_contractual, rc_extracontractual, todo_riesgo,
//   inmueble, unknown.
// - Expone acceso tipado a policyType mediante una extension sobre
//   InsurancePolicyEntity, evitando usar const ._() en la clase freezed.
// - `policyId`: UUID único por póliza para fusión determinista en el merger.
//   Distinto de `id` (PK Isar/Firestore). Default '' para compat. legacy.
//
// QUÉ NO HACE:
// - No accede a Isar, Firestore ni repositorios.
// - No calcula vigencia actual.
// - No cambia el tipo del campo tipo en Isar.
// - No define `override` (AssetPolicyOverride): es una concern de infraestructura
//   de sync. Vive en InsurancePolicyModel.overrideJson, no en la entidad de dominio.
// - No genera UUID; la generación y persistencia es responsabilidad del
//   data source (InsuranceLocalDataSource).
//
// PRINCIPIOS:
// - Wire values estables: NO cambiar sin migración de datos.
// - fromWireString tolera mayúsculas ('SOAT' → soat) para compatibilidad legacy.
// - policyType se resuelve de forma pura vía extension.
// - policyId == '' indica registro pre-v1.3.4 sin UUID asignado aún.
//   El data source genera y persiste el UUID antes de retornar el modelo.
//
// ENTERPRISE NOTES:
// ADAPTADO (2026-03): Track A — InsurancePolicyType enum + extension policyType
//   para soportar lógica tipada sin usar constructor privado en freezed.
// ADAPTADO (2026-03): Fase 2 — Asset Schema v1.3.4. Campos policyId y override.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurance_policy_entity.freezed.dart';
part 'insurance_policy_entity.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUM — InsurancePolicyType
// ─────────────────────────────────────────────────────────────────────────────

/// Discriminador tipado de tipo de póliza de seguro.
///
/// Wire values estables: NO cambiar sin migración de datos.
///
/// Fuente de cada tipo:
/// - [soat] / [rcContractual] / [rcExtracontractual] → flujo RUNT
/// - [todoRiesgo] / [inmueble]                       → flujo manual Avanzza
/// - [unknown]                                      → fallback seguro
enum InsurancePolicyType {
  /// Seguro Obligatorio de Accidentes de Tránsito.
  /// Wire value: `soat`.
  soat,

  /// Responsabilidad Civil Contractual.
  /// Wire value: `rc_contractual`.
  rcContractual,

  /// Responsabilidad Civil Extracontractual.
  /// Wire value: `rc_extracontractual`.
  rcExtracontractual,

  /// Todo Riesgo (flujo manual).
  /// Wire value: `todo_riesgo`.
  ///
  /// NUNCA debe originarse desde RUNT.
  todoRiesgo,

  /// Seguro de inmueble (futuro).
  /// Wire value: `inmueble`.
  inmueble,

  /// Fallback para tipos no reconocidos.
  /// Wire value: `unknown`.
  unknown;

  static const Map<String, InsurancePolicyType> _byWire =
      <String, InsurancePolicyType>{
    'soat': InsurancePolicyType.soat,
    'rc_contractual': InsurancePolicyType.rcContractual,
    'rc_extracontractual': InsurancePolicyType.rcExtracontractual,
    'todo_riesgo': InsurancePolicyType.todoRiesgo,
    'inmueble': InsurancePolicyType.inmueble,
    'unknown': InsurancePolicyType.unknown,
  };

  /// Construye el enum desde un wire string.
  ///
  /// Tolera valores legacy en mayúsculas, por ejemplo:
  /// - `'SOAT'` → [InsurancePolicyType.soat]
  static InsurancePolicyType fromWireString(String? value) =>
      _byWire[value?.toLowerCase()] ?? InsurancePolicyType.unknown;

  /// Retorna el wire value estable de este tipo.
  String toWireString() => switch (this) {
        InsurancePolicyType.soat => 'soat',
        InsurancePolicyType.rcContractual => 'rc_contractual',
        InsurancePolicyType.rcExtracontractual => 'rc_extracontractual',
        InsurancePolicyType.todoRiesgo => 'todo_riesgo',
        InsurancePolicyType.inmueble => 'inmueble',
        InsurancePolicyType.unknown => 'unknown',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// ENTITY — InsurancePolicyEntity
// ─────────────────────────────────────────────────────────────────────────────

@freezed
abstract class InsurancePolicyEntity with _$InsurancePolicyEntity {
  const factory InsurancePolicyEntity({
    required String id,
    required String assetId,

    /// UUID único por póliza para fusión determinista en AssetPolicyMerger.
    ///
    /// DISTINTO de [id] (PK Isar/Firestore). No usar [id] como policyId.
    ///
    /// - Default `''`: registro pre-v1.3.4 sin UUID asignado.
    /// - El data source genera y persiste el UUID antes de retornar la entidad.
    @Default('') String policyId,

    /// Wire value del tipo de póliza.
    ///
    /// Para lógica tipada usar la extension [InsurancePolicyEntityX.policyType].
    ///
    /// Valores válidos:
    /// - `soat`
    /// - `rc_contractual`
    /// - `rc_extracontractual`
    /// - `todo_riesgo`
    /// - `inmueble`
    /// - `unknown`
    required String tipo,
    required String aseguradora,
    required double tarifaBase,
    required String currencyCode,
    required String countryId,
    String? cityId,
    required DateTime fechaInicio,
    required DateTime fechaFin,

    /// Estado calculado al momento de persistencia.
    ///
    /// Puede quedar stale con el tiempo. Para UI y vigencia actual,
    /// calcular dinámicamente desde [fechaFin].
    ///
    /// Valores esperados:
    /// - `vigente`
    /// - `vencido`
    /// - `por_vencer`
    required String estado,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InsurancePolicyEntity;

  factory InsurancePolicyEntity.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyEntityFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────
// EXTENSION — policyType tipado sin usar const ._()
// ─────────────────────────────────────────────────────────────────────────────

extension InsurancePolicyEntityX on InsurancePolicyEntity {
  /// Tipo de póliza tipado derivado del wire value [tipo].
  ///
  /// Tolera legacy `'SOAT'` gracias a [InsurancePolicyType.fromWireString].
  InsurancePolicyType get policyType =>
      InsurancePolicyType.fromWireString(tipo);
}

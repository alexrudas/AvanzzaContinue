// ============================================================================
// lib/domain/services/alerts/asset_alert_snapshot.dart
// ASSET ALERT SNAPSHOT — Foto coherente de un activo para evaluación de alertas
//
// QUÉ HACE:
// - Define AssetAlertSnapshot: value object inmutable con todos los datos
//   necesarios para que los evaluadores de alertas tomen decisiones.
// - Consolida pólizas SOAT, RC, RTM, datos jurídicos y metadata del activo
//   en una única estructura coherente.
// - Expone identidad del activo y clasificación canónica de servicio vehicular
//   ya resueltas desde el assembler.
//
// QUÉ NO HACE:
// - No accede a repositorios ni a Isar/Firebase (solo datos).
// - No calcula alertas.
// - No depende de Flutter ni GetX.
// - No resuelve identidad del activo dinámicamente (viene del assembler).
// - No interpreta strings crudos del RUNT en evaluadores.
//
// PRINCIPIOS:
// - Snapshot coherente: TODOS los datos provienen del mismo objeto de activo.
// - Sin refetch: el evaluador NO consulta repositorios.
// - Identidad del activo incluida desde el origen (no en mapper/UI).
// - Campos nullable = ausencia de dato, no error.
// - Inmutabilidad total.
// - vehicleServiceCategory es la fuente canónica para lógica de alertas.
// - vehicleServiceType raw se conserva solo por compatibilidad/contexto.
//
// REGLAS CRÍTICAS:
// - assetId, orgId y assetPrimaryLabel son obligatorios y no deben venir vacíos.
// - Nunca resolver labels en mapper o UI.
// - Nunca re-consultar activo en evaluadores.
// - El assembler debe poblar vehicleServiceCategory explícitamente.
//   Si el valor fuente no existe o no es reconocible, debe pasar
//   VehicleServiceCategory.unknown de forma explícita.
// - Los evaluadores NO deben interpretar vehicleServiceType raw.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Productor contextual v1.
// ACTUALIZADO (2026-03): Fase 5.5 — identidad del activo integrada en snapshot.
// ACTUALIZADO (2026-03): V5 — vehicleServiceCategory añadido como clasificación
// canónica normalizada por el assembler.
// ============================================================================

import '../../entities/alerts/vehicle_service_category.dart';
import '../../entities/insurance/insurance_policy_entity.dart';

class AssetAlertSnapshot {
  // ── Identificadores ───────────────────────────────────────────────────────

  /// ID del activo evaluado.
  final String assetId;

  /// ID de la organización propietaria.
  final String orgId;

  /// Placa legacy del activo.
  ///
  /// Mantener solo por compatibilidad con flujos antiguos.
  /// No usar como fuente principal de identidad en UI nueva.
  final String? placa;

  // ── Identidad del activo (CRÍTICO) ────────────────────────────────────────

  /// Label primario del activo.
  ///
  /// Ejemplos:
  /// - Vehículo: placa
  /// - Inmueble: matrícula o dirección corta
  /// - Maquinaria: serial o nombre
  ///
  /// Nunca debe venir vacío.
  final String assetPrimaryLabel;

  /// Label secundario del activo.
  ///
  /// Ejemplos:
  /// - Vehículo: "Toyota Hilux"
  /// - Inmueble: "Edificio Torre Norte"
  /// - Maquinaria: "CAT 320"
  final String? assetSecondaryLabel;

  /// Tipo de activo en formato wire-stable.
  ///
  /// Ejemplos esperados:
  /// - vehicle
  /// - real_estate
  /// - machinery
  /// - equipment
  final String? assetType;

  // ── Pólizas ──────────────────────────────────────────────────────────────

  final InsurancePolicyEntity? soatPolicy;
  final InsurancePolicyEntity? rcContractualPolicy;
  final InsurancePolicyEntity? rcExtracontractualPolicy;

  // ── RTM ──────────────────────────────────────────────────────────────────

  final DateTime? rtmVigencia;
  final String? rtmCertificado;
  final DateTime? rtmExemptUntil;

  // ── Jurídico ─────────────────────────────────────────────────────────────

  final bool hasLegalLimitations;
  final String? propertyLiensText;
  final String? primaryLimitationType;
  final String? primaryLegalEntity;

  // ── Vehículo ─────────────────────────────────────────────────────────────

  /// Tipo de servicio del vehículo como string crudo del RUNT.
  ///
  /// Se conserva solo por compatibilidad y trazabilidad.
  /// Para lógica de alertas, usar siempre [vehicleServiceCategory].
  final String? vehicleServiceType;

  /// Clasificación canónica del tipo de servicio del vehículo.
  ///
  /// Este valor debe ser poblado explícitamente por el assembler.
  /// Los evaluadores deben usar este campo y nunca interpretar
  /// [vehicleServiceType] directamente.
  final VehicleServiceCategory vehicleServiceCategory;

  // ── Metadata ─────────────────────────────────────────────────────────────

  final DateTime sourceUpdatedAt;

  AssetAlertSnapshot({
    required this.assetId,
    required this.orgId,
    this.placa,
    required this.assetPrimaryLabel,
    this.assetSecondaryLabel,
    this.assetType,
    this.soatPolicy,
    this.rcContractualPolicy,
    this.rcExtracontractualPolicy,
    this.rtmVigencia,
    this.rtmCertificado,
    this.rtmExemptUntil,
    required this.hasLegalLimitations,
    this.propertyLiensText,
    this.primaryLimitationType,
    this.primaryLegalEntity,
    this.vehicleServiceType,
    required this.vehicleServiceCategory,
    required this.sourceUpdatedAt,
  })  : assert(assetId.trim().isNotEmpty, 'assetId no puede estar vacío'),
        assert(orgId.trim().isNotEmpty, 'orgId no puede estar vacío'),
        assert(
          assetPrimaryLabel.trim().isNotEmpty,
          'assetPrimaryLabel no puede estar vacío',
        );
}

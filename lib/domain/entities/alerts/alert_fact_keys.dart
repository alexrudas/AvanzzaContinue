// ============================================================================
// lib/domain/entities/alerts/alert_fact_keys.dart
// ALERT FACT KEYS — Keys canónicas para el mapa facts de DomainAlert
//
// QUÉ HACE:
// - Centraliza todas las keys permitidas en DomainAlert.facts.
// - Garantiza consistencia entre productores (evaluadores) y capas consumidoras.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni infraestructura.
// - No define los valores — solo las keys.
// - No valida el tipo del valor (esa responsabilidad es del evaluador productor).
//
// PRINCIPIOS:
// - REGLA: nadie puede usar keys de facts que no estén definidas aquí.
// - Toda key nueva requiere agregarse aquí primero (antes de usarla).
// - Keys en camelCase para consistencia con Dart.
// - Los valores asociados a estas keys deben ser serializables y estables
//   (String, num, bool, null). No insertar objetos arbitrarios.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Estándar canónico v1. Ver ALERTS_SYSTEM_V4.md §7.1.
// MOVIDO (2026-03): de lib/core/alerts/support/ → lib/domain/entities/alerts/
//   Razón: AlertFactKeys es contrato de dominio puro (keys de DomainAlert.facts).
//   Domain no puede importar core; moverlo aquí elimina la violación de dependencias.
// ============================================================================

/// Keys canónicas para [DomainAlert.facts].
///
/// Uso: `facts: {AlertFactKeys.daysRemaining: 5, AlertFactKeys.expirationDate: '...'}`
abstract final class AlertFactKeys {
  AlertFactKeys._();

  /// Fecha de vencimiento del documento/póliza fuente.
  ///
  /// Tipo: String ISO 8601 (YYYY-MM-DD). Contrato único — no usar DateTime.toString().
  static const String expirationDate = 'expirationDate';

  /// Días restantes hasta el vencimiento.
  ///
  /// Tipo: int. Negativo si ya venció.
  static const String daysRemaining = 'daysRemaining';

  /// Tipo de póliza que originó la alerta.
  ///
  /// Tipo: String — wire value de InsurancePolicyType
  /// (ej: 'soat', 'rc_contractual', 'rc_extracontractual').
  static const String policyType = 'policyType';

  /// Tipo de restricción jurídica que originó la alerta.
  ///
  /// Tipo: String — ej: 'Embargo', 'Prenda', 'Limitación'.
  static const String legalRestrictionType = 'legalRestrictionType';

  /// Nombre de la fuente o entidad que emitió el documento.
  ///
  /// Tipo: String — ej: nombre de la aseguradora, entidad jurídica.
  static const String sourceName = 'sourceName';

  /// Tipo de servicio del vehículo proveniente de RUNT (VehicleContent.serviceType).
  ///
  /// Tipo: String — uppercase, ej: 'PÚBLICO', 'PUBLICO', 'PARTICULAR'.
  /// Null si el activo no es vehículo o no tiene dato de servicio.
  /// Conservado por compatibilidad/trazabilidad. Para lógica de negocio, usar
  /// [vehicleServiceCategory].
  static const String vehicleServiceType = 'vehicleServiceType';

  /// Clasificación canónica del tipo de servicio del vehículo.
  ///
  /// Tipo: String — wire value de VehicleServiceCategory
  /// (ej: 'public_transport', 'private_use', 'unknown').
  /// Null si el activo no es vehículo.
  /// Fuente canónica para decisiones de negocio — preferir sobre [vehicleServiceType].
  static const String vehicleServiceCategory = 'vehicleServiceCategory';

  // ── Identidad del activo ───────────────────────────────────────────────────

  /// Label primario de identificación del activo.
  ///
  /// Tipo: String — obligatorio. Todos los evaluadores deben poblar este campo.
  /// Valores por tipo: placa (vehículo), matrícula (inmueble), serial (maquinaria/equipo).
  /// Corresponde a [AssetContent.assetKeyValue].
  /// Fallback en DomainAlertMapper: 'Activo sin identificar'.
  static const String assetPrimaryLabel = 'assetPrimaryLabel';

  /// Label secundario de identificación del activo.
  ///
  /// Tipo: String? — opcional.
  /// Valores por tipo: '$brand $model' (vehículo), dirección (inmueble),
  /// '$brand $model' (maquinaria), nombre descriptivo (equipo).
  /// Null si el activo no tiene información de apoyo disponible.
  static const String assetSecondaryLabel = 'assetSecondaryLabel';

  /// Tipo de activo (discriminador canónico wire-stable).
  ///
  /// Tipo: String? — opcional. Wire values: 'vehicle', 'real_estate',
  /// 'machinery', 'equipment'. Corresponde a [AssetContent.typeDiscriminator].
  /// Permite filtros por tipo en AlertCenterPage sin queries adicionales.
  static const String assetType = 'assetType';
}

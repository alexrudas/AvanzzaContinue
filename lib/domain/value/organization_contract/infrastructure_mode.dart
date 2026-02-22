// ============================================================================
// lib/domain/value/organization_contract/infrastructure_mode.dart
// INFRASTRUCTURE MODE — Enterprise Ultra Pro (Domain / Value Object)
//
// QUÉ HACE:
// - Define el modo de infraestructura/conectividad de una organización.
// - Enum puro con serialización estable vía @JsonValue (wire canonical).
// - Expone helpers declarativos: requiresCloud, isLocal, supportsRealTimeSync.
// - Expone parse robusto desde wire canonical (y alias legacy opcionales).
//
// QUÉ NO HACE:
// - No decide qué features se habilitan (eso es StructuralCapabilities).
// - No ejecuta enforcement (eso es ProductAccessContext / policies).
// - No persiste por sí mismo (OrganizationAccessContract lo compone).
//
// SERIALIZACIÓN (CANONICAL):
// - Wire estable: 'local_only' | 'cloud_lite' | 'cloud_full' | 'enterprise'.
// - NO cambiar estos strings sin una migración explícita.
// ============================================================================

import 'package:json_annotation/json_annotation.dart';

/// Modo de infraestructura de la organización.
///
/// Define conectividad y persistencia base del sistema.
///
/// - [localOnly]: solo persistencia local (Isar). Sin sync. Guest/offline puro.
/// - [cloudLite]: nube básica (sync manual o periódico). Starter/personal.
/// - [cloudFull]: nube completa (sync real-time, backups, multi-device). Pro/Team.
/// - [enterprise]: nube enterprise (SLA, regiones dedicadas, compliance). Enterprise.
enum InfrastructureMode {
  /// Solo local. Sin sincronización. Guest / offline puro.
  @JsonValue('local_only')
  localOnly,

  /// Nube básica. Sync manual o periódico. Starter / personal.
  @JsonValue('cloud_lite')
  cloudLite,

  /// Nube completa. Sync real-time, backups, multi-device. Pro / Team.
  @JsonValue('cloud_full')
  cloudFull,

  /// Enterprise. SLA, regiones dedicadas, compliance.
  @JsonValue('enterprise')
  enterprise;

  // --------------------------------------------------------------------------
  // CAPABILITIES (helpers)
  // --------------------------------------------------------------------------

  /// True si el modo requiere conectividad cloud.
  bool get requiresCloud => this != InfrastructureMode.localOnly;

  /// True si el modo es exclusivamente local.
  bool get isLocal => this == InfrastructureMode.localOnly;

  /// True si soporta sync real-time (o equivalente).
  bool get supportsRealTimeSync =>
      this == InfrastructureMode.cloudFull ||
      this == InfrastructureMode.enterprise;

  /// True si soporta backup cloud (implícito si requiereCloud).
  bool get supportsCloudBackup => requiresCloud;

  /// True si está en “tier enterprise” de infraestructura (SLA/compliance).
  bool get isEnterpriseInfra => this == InfrastructureMode.enterprise;

  // --------------------------------------------------------------------------
  // WIRE (canonical)
  // --------------------------------------------------------------------------

  /// Wire canonical estable (UPPER_SNAKE). Estándar del repo.
  String get wireName => switch (this) {
        InfrastructureMode.localOnly => 'LOCAL_ONLY',
        InfrastructureMode.cloudLite => 'CLOUD_LITE',
        InfrastructureMode.cloudFull => 'CLOUD_FULL',
        InfrastructureMode.enterprise => 'ENTERPRISE',
      };

  /// Alias de [wireName] (lowercase). Mantiene compatibilidad.
  @Deprecated(
    'Violation of DOMAIN_CONTRACTS.md (ENUM SERIALIZATION STANDARD). '
    'Do NOT use wire for persistence or payloads. '
    'Use wireName for logs/debug only. '
    'JSON must use @JsonValue (codegen).',
  )
  String get wire => wireName;

  /// Parse seguro desde wireName canonical.
  ///
  /// - Case-insensitive.
  /// - Tolera separadores '-' y espacios.
  /// - Incluye alias legacy comunes para evitar migraciones dolorosas.
  ///
  /// Default: [InfrastructureMode.localOnly].
  static InfrastructureMode fromWireName(String? wireName) {
    final raw = (wireName ?? '').trim();
    if (raw.isEmpty) return InfrastructureMode.localOnly;

    final normalized =
        raw.trim().toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');

    // Canonical
    switch (normalized) {
      case 'local_only':
        return InfrastructureMode.localOnly;
      case 'cloud_lite':
        return InfrastructureMode.cloudLite;
      case 'cloud_full':
        return InfrastructureMode.cloudFull;
      case 'enterprise':
        return InfrastructureMode.enterprise;
    }

    // Legacy aliases (NO serializar; solo aceptar lectura)
    // Esto evita romper si algún JSON viejo trae otros formatos.
    switch (normalized) {
      case 'local':
      case 'offline':
      case 'offline_only':
      case 'isar_only':
        return InfrastructureMode.localOnly;

      case 'cloud':
      case 'lite':
      case 'basic_cloud':
      case 'starter_cloud':
        return InfrastructureMode.cloudLite;

      case 'pro':
      case 'full_cloud':
      case 'realtime':
      case 'real_time':
      case 'real_time_sync':
        return InfrastructureMode.cloudFull;

      case 'enterprise_cloud':
      case 'sla':
      case 'compliance':
        return InfrastructureMode.enterprise;

      default:
        return InfrastructureMode.localOnly;
    }
  }

  /// Alias de [fromWireName]. Mantiene compatibilidad.
  static InfrastructureMode fromWire(String? wire) => fromWireName(wire);

  // --------------------------------------------------------------------------
  // PRESENTATION (NO wire)
  // --------------------------------------------------------------------------

  /// Label humano (UI/logs). NO usar como wire.
  String get label => switch (this) {
        InfrastructureMode.localOnly => 'Solo Local',
        InfrastructureMode.cloudLite => 'Nube Básica',
        InfrastructureMode.cloudFull => 'Nube Completa',
        InfrastructureMode.enterprise => 'Enterprise',
      };

  /// Debug string estable para logs. NO usar como wire.
  String toDebugString() => 'InfrastructureMode($wireName)';
}

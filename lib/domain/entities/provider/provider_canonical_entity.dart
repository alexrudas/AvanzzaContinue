// ============================================================================
// lib/domain/entities/provider/provider_canonical_entity.dart
// PROVIDER CANONICAL ENTITY — Domain Entity (Hito 1 - Provider Provisioning)
//
// QUÉ HACE:
// - Modela la respuesta canónica de `POST /v1/providers` y
//   `GET /v1/providers/:providerProfileId` del Avanzza Core API.
// - Representa al proveedor canónico per-tenant: un `ProviderProfile`
//   (Postgres) atado a un `PlatformActor` cross-workspace.
// - Expone `specialties` activas (lista filtrada por backend, soft-delete
//   transparente).
//
// QUÉ NO HACE:
// - NO expone campos diagnósticos (`resolution`, `identityConfidence`)
//   del response — esos son telemetría server-side, NO contractuales.
//   La UI NO debe ramificar lógica sobre ellos. Si se necesitan en debug,
//   se loguean en data layer y se descartan antes de cruzar a domain.
// - NO expone `linkedUserId` ni otros internals de PlatformActor.
// - NO modela `ProviderAgent` (Hito 2).
// - NO toca catálogo global de Specialty (eso vive en
//   `specialty_entity.dart`); aquí solo aparece la sub-vista de specialties
//   ASIGNADAS al proveedor.
//
// PRINCIPIOS / INVARIANTES:
// - Inmutable. Igualdad estructural por `providerProfileId`.
// - `specialties` viene del backend ya filtrada (`isActive=true`) y
//   ordenada por `name` ASC. La UI NO reordena ni filtra.
// - `actorKind`, kind de specialty, etc. usan enums wire-stable
//   (`fromWire`) para fallar duro ante drift de contrato.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): Hito 1 — integración Flutter del flujo canónico
//   `LocalContact → POST /v1/providers → PUT /:id/specialties`.
// ============================================================================

import '../catalog/specialty_entity.dart' show SpecialtyKind;

/// Discriminador `actorKind` del PlatformActor subyacente.
///
/// Wire-stable: alineado con enum `ActorKind` de Prisma backend.
enum ProviderActorKind {
  person('person'),
  organization('organization');

  const ProviderActorKind(this.wireName);

  final String wireName;

  /// Resuelve un `ProviderActorKind` desde wire. Lanza [ArgumentError]
  /// ante valores desconocidos — no devuelve default silencioso.
  static ProviderActorKind fromWire(String value) {
    for (final k in ProviderActorKind.values) {
      if (k.wireName == value) return k;
    }
    throw ArgumentError.value(
      value,
      'value',
      'ProviderActorKind wire desconocido. Esperado: person | organization.',
    );
  }
}

/// Specialty asignada al proveedor — sub-vista de la respuesta canónica.
///
/// Reusa `SpecialtyKind` (`PRODUCT | SERVICE | BOTH`) ya definido en el
/// dominio del catálogo global.
class ProviderCanonicalSpecialty {
  /// ID estable de la specialty (mismo del catálogo global).
  final String id;

  /// Key semántica del catálogo (e.g. `vehicle.engine_repair`). NO se
  /// muestra en UI: usar `name`. Se preserva para debugging y futuras
  /// integraciones.
  final String key;

  /// Nombre en español, listo para mostrar.
  final String name;

  final SpecialtyKind kind;

  const ProviderCanonicalSpecialty({
    required this.id,
    required this.key,
    required this.name,
    required this.kind,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderCanonicalSpecialty && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Proveedor canónico per-tenant.
///
/// Es el "Provider" de la red comercial: lo que el endpoint canónico
/// retorna, NO la libreta local del workspace (`LocalContactEntity`).
class ProviderCanonicalEntity {
  /// ID estable del `ProviderProfile` (Postgres). Token de cache local
  /// en `LocalContactEntity.linkedProviderProfileId`.
  final String providerProfileId;

  /// Workspace dueño de este profile.
  final String workspaceId;

  /// Identidad cross-workspace subyacente.
  final String platformActorId;

  /// Nombre mostrado en UI. Wire-stable.
  final String displayName;

  final ProviderActorKind actorKind;

  /// Razón social cuando `actorKind=organization`. Null si person.
  final String? legalName;

  /// Nombre legal completo cuando `actorKind=person`. Null si organization.
  final String? fullLegalName;

  /// Soft-active flag del profile. `false` = profile archivado en backend.
  final bool isActive;

  /// Métrica off-band (0..1). Hoy siempre null en Hito 1.
  final double? responseRateAvg;

  /// Notas del workspace sobre el proveedor. Hoy siempre null en Hito 1.
  final String? notes;

  /// Specialties activas asignadas al proveedor (ya filtradas y ordenadas).
  final List<ProviderCanonicalSpecialty> specialties;

  final DateTime createdAt;

  /// Token de optimistic concurrency. El cliente lo envía verbatim al
  /// `PUT /v1/providers/:id/specialties` para detectar modificaciones
  /// concurrentes (409 `CONCURRENT_MODIFICATION`).
  final DateTime updatedAt;

  const ProviderCanonicalEntity({
    required this.providerProfileId,
    required this.workspaceId,
    required this.platformActorId,
    required this.displayName,
    required this.actorKind,
    required this.legalName,
    required this.fullLegalName,
    required this.isActive,
    required this.responseRateAvg,
    required this.notes,
    required this.specialties,
    required this.createdAt,
    required this.updatedAt,
  });

  ProviderCanonicalEntity copyWith({
    List<ProviderCanonicalSpecialty>? specialties,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ProviderCanonicalEntity(
      providerProfileId: providerProfileId,
      workspaceId: workspaceId,
      platformActorId: platformActorId,
      displayName: displayName,
      actorKind: actorKind,
      legalName: legalName,
      fullLegalName: fullLegalName,
      isActive: isActive ?? this.isActive,
      responseRateAvg: responseRateAvg,
      notes: notes,
      specialties: specialties ?? this.specialties,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderCanonicalEntity &&
          other.providerProfileId == providerProfileId);

  @override
  int get hashCode => providerProfileId.hashCode;
}

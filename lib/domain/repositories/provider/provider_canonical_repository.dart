// ============================================================================
// lib/domain/repositories/provider/provider_canonical_repository.dart
// PROVIDER CANONICAL REPOSITORY — Contrato (Domain)
//
// QUÉ HACE:
// - Define el contrato del proveedor canónico contra Avanzza Core API:
//   - `provision()` → POST /v1/providers (idempotente por unique
//     `(workspaceId, platformActorId)`).
//   - `getById()` → GET /v1/providers/:id (validación de tenancy en backend).
//   - `replaceSpecialties()` → PUT /v1/providers/:id/specialties
//     (REPLACE-style con optimistic concurrency).
//
// QUÉ NO HACE:
// - NO cachea localmente. La SSOT es Postgres via Core API. Mientras el
//   producto requiera cache de specialties, ese cache vive en el response
//   del último call (no en una colección Isar paralela).
// - NO orquesta el `match-candidate.probe` previo al POST. Ese paso vive
//   en el caller (controller del form) usando el datasource canónico
//   `MatchCandidateNestJsDataSource.probe(...)` ya existente.
// - NO toca `LocalContact`. El `linkedProviderProfileId` del entity local
//   se cachea fuera de este contrato (responsabilidad del controller).
//
// PRINCIPIOS / INVARIANTES:
// - `provision()` es idempotente: si `(workspaceId, platformActorId)` ya
//   tiene profile activo, devuelve el existente sin tocar updatedAt. Si
//   estaba inactivo, lo reactiva.
// - Errores se distinguen por `code` (no por mensaje). Excepciones tipadas
//   se propagan tal cual (`AmbiguousPlatformActorException`,
//   `LocalRefNotFoundException`, etc.).
// - `replaceSpecialties` exige `providerProfileUpdatedAt` como token de
//   optimistic concurrency — el caller debe pasar el `updatedAt` del
//   último response que tuvo (de `provision` o `getById`).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): Hito 1 — integración Flutter canónica.
// ============================================================================

import '../../entities/provider/provider_canonical_entity.dart';

/// Discriminador del `source` para `provision()`. Wire-stable, alineado
/// con `ProvisionSourceKind` del backend.
enum ProvisionProviderSourceKind {
  localContact('LOCAL_CONTACT'),
  localOrganization('LOCAL_ORGANIZATION'),
  existingPlatformActor('EXISTING_PLATFORM_ACTOR');

  const ProvisionProviderSourceKind(this.wireName);

  final String wireName;
}

/// Probe de identidad: par `(keyType, normalizedValue)` ya normalizado por
/// el cliente. El servidor consulta `VerifiedKey.find` con estas probes
/// para resolver o crear un PlatformActor.
///
/// Reusa `VerifiedKeyType` ya existente en core_common — wire-stable:
/// `phoneE164 | email | docId`.
class ProvisionProviderProbe {
  /// `'phoneE164' | 'email' | 'docId'` — wireName del enum
  /// `VerifiedKeyType` de core_common.
  final String keyTypeWire;

  /// Valor ya normalizado:
  ///   - phoneE164: E.164 con `+`.
  ///   - email: lowercase trimmed.
  ///   - docId: alphanumeric sin puntuación.
  final String normalizedValue;

  const ProvisionProviderProbe({
    required this.keyTypeWire,
    required this.normalizedValue,
  });
}

/// Identidad descriptiva del proveedor.
///
/// Coherencia obligatoria (validada por backend; el caller debería
/// validarla antes para evitar 400 INVALID_ACTOR_IDENTITY):
///   - actorKind=person       → fullLegalName? (legalName debe ser null).
///   - actorKind=organization → legalName?     (fullLegalName debe ser null).
class ProvisionProviderIdentity {
  final String displayName;
  final ProviderActorKind actorKind;
  final String? legalName;
  final String? fullLegalName;

  const ProvisionProviderIdentity({
    required this.displayName,
    required this.actorKind,
    this.legalName,
    this.fullLegalName,
  });
}

/// Source del provisioning. Sealed-style con factories explícitos para
/// que el caller no pueda construir un source incoherente.
class ProvisionProviderSource {
  final ProvisionProviderSourceKind kind;
  final String? localKind; // 'contact' | 'organization' (si LOCAL_*)
  final String? localId;
  final String? platformActorId;

  const ProvisionProviderSource._({
    required this.kind,
    this.localKind,
    this.localId,
    this.platformActorId,
  });

  /// `LOCAL_CONTACT` — el proveedor proviene de un LocalContact del
  /// workspace. Requiere `localId` (ID del contacto en libreta).
  factory ProvisionProviderSource.localContact({required String localId}) {
    return ProvisionProviderSource._(
      kind: ProvisionProviderSourceKind.localContact,
      localKind: 'contact',
      localId: localId,
    );
  }

  /// `LOCAL_ORGANIZATION` — el proveedor proviene de una LocalOrganization.
  factory ProvisionProviderSource.localOrganization({required String localId}) {
    return ProvisionProviderSource._(
      kind: ProvisionProviderSourceKind.localOrganization,
      localKind: 'organization',
      localId: localId,
    );
  }

  /// `EXISTING_PLATFORM_ACTOR` — el proveedor ya tiene PlatformActor
  /// resuelto (e.g. tras desambiguación manual del usuario en un 409
  /// AMBIGUOUS).
  factory ProvisionProviderSource.existingPlatformActor({
    required String platformActorId,
  }) {
    return ProvisionProviderSource._(
      kind: ProvisionProviderSourceKind.existingPlatformActor,
      platformActorId: platformActorId,
    );
  }
}

/// Input completo para `provision()`.
class ProvisionProviderInput {
  final ProvisionProviderSource source;
  final ProvisionProviderIdentity identity;

  /// Probes para lookup de identidad. Si vacío y `source` es LOCAL_*,
  /// el backend creará un PlatformActor con `identityConfidence=low`
  /// y emitirá un audit log obligatorio.
  final List<ProvisionProviderProbe> probes;

  const ProvisionProviderInput({
    required this.source,
    required this.identity,
    this.probes = const [],
  });
}

/// Contrato del repositorio canónico de proveedor.
abstract class ProviderCanonicalRepository {
  /// `POST /v1/providers` — provisiona o reusa un ProviderProfile.
  ///
  /// Idempotente: misma `(workspaceId, platformActorId)` retorna el mismo
  /// profile sin tocar `updatedAt` si ya estaba activo.
  ///
  /// Throws:
  /// - `BadRequestException` (code=`INVALID_*`) ante input inválido.
  /// - `WorkspaceNotFoundException` si el orgId del JWT no tiene Workspace.
  /// - `LocalRefNotFoundException` si `source.kind=LOCAL_*` y el `localId`
  ///   no tiene attestation previa (cliente debe disparar probe primero).
  /// - `PlatformActorNotFoundException` si `EXISTING_PLATFORM_ACTOR` y el
  ///   id no existe.
  /// - `BadRequestException` (code=`PLATFORM_ACTOR_INACTIVE`) si el actor
  ///   existente está soft-deleted.
  /// - `AmbiguousPlatformActorException` si las probes matchean >1
  ///   PlatformActors. Body trae `candidates` para desambiguar.
  /// - `UnauthorizedException`, `NetworkException`, `ServerException`,
  ///   `RequestCancelledException` según el caso.
  Future<ProviderCanonicalEntity> provision(ProvisionProviderInput input);

  /// `GET /v1/providers/:providerProfileId` — lectura canónica.
  ///
  /// Throws:
  /// - `ProviderProfileNotFoundException` si no existe.
  /// - `UnauthorizedException` si el profile pertenece a otro workspace
  ///   (mapeo de 403 FORBIDDEN del backend).
  /// - Network/Server según el caso.
  Future<ProviderCanonicalEntity> getById(String providerProfileId);

  /// `PUT /v1/providers/:providerProfileId/specialties` — REPLACE-style.
  ///
  /// Cualquier link no incluido en `specialtyIds` se desactiva (soft).
  /// Cualquier link nuevo se activa o se crea.
  ///
  /// Throws:
  /// - `BadRequestException` (code=`EMPTY_SPECIALTY_LIST`) si la lista
  ///   está vacía tras deduplicación.
  /// - `BadRequestException` (code=`CONCURRENT_MODIFICATION`) si el
  ///   `providerProfileUpdatedAt` no coincide con el del backend.
  /// - `ProviderProfileNotFoundException`, `UnauthorizedException`,
  ///   Network/Server según el caso.
  Future<ProviderCanonicalEntity> replaceSpecialties({
    required String providerProfileId,
    required Set<String> specialtyIds,
    required DateTime providerProfileUpdatedAt,
  });
}

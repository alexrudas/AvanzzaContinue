// ============================================================================
// lib/data/models/access/access_context_snapshot_model.dart
// AccessContextSnapshotModel — caché Isar del estado de acceso del caller
// para un (userId, workspaceId) específico.
// ============================================================================
// QUÉ HACE:
//   Persiste UNA fila por par (userId, workspaceId) con la última verdad
//   conocida sobre identidad multi-actor + permisos + capabilities en ese
//   workspace. Sobrevive a kills, hot restarts y cold starts offline.
//
//   Avanzza es multi-workspace y multi-actor por diseño:
//     · Un mismo userId puede pertenecer a varios workspaces con permisos
//       distintos (composite key). NO es 1 snapshot por usuario.
//     · User ≠ PlatformActor ≠ ProviderProfile ≠ Workspace son entidades
//       separadas. El snapshot consolida sus IDs cuando aplican, sin mezclar
//       semántica.
//
//   Dos vías de escritura ortogonales:
//     · `source` — de dónde vino el dato (LOCAL_BOOTSTRAP / SERVER_REFRESH).
//     · `syncStatus` — confirmación con backend (CONFIRMED / PENDING_SYNC /
//       SYNC_FAILED). Independiente de source: un LOCAL_BOOTSTRAP recién
//       creado en onboarding es PENDING_SYNC hasta que el siguiente refresh
//       remoto exitoso lo eleve a CONFIRMED. Un OWNER local NO confirmado
//       NO es lo mismo que un OWNER local confirmado.
//
// QUÉ NO HACE:
//   - NO se sincroniza a Firestore. Caché puramente local.
//   - NO contiene Platform Entitlements (límites de plan, módulos premium).
//     Esos viven en otra colección/servicio.
//   - NO mezcla "rol legacy" string libre. `role` es enum cerrado / wire-stable.
//   - NO clasifica acciones (`localSafe` vs `networkCritical`). Esa policy
//     vive en `domain/policy/access/` (V2.2). El modelo solo guarda datos.
//
// REGLAS:
//   - Composite unique: `compositeKey = "$userId:$workspaceId"` indexada
//     `unique:true, replace:true`. Garantiza N filas por user (una por
//     workspace), pero una sola por par.
//   - `userId` y `workspaceId` también indexados (no-unique) para queries
//     de purge por workspace o por user.
//   - `staleAt` / `expiresAt` se computan al escribir (denormalizados) para
//     que el inspector Isar permita auditar staleness sin recomputar.
//   - Enums desconocidos en lectura → degradar a defaults seguros
//     (`source=serverRefresh`, `syncStatus=syncFailed`) — preferimos NO
//     promocionar permisos sin evidencia.
// ============================================================================

import 'package:isar_community/isar.dart';

part 'access_context_snapshot_model.g.dart';

/// Origen del dato del snapshot. Wire-stable (Isar serializa por nombre).
enum AccessSnapshotSource {
  /// Inferido localmente al crear el workspace (CompleteOnboardingUC).
  /// Las capabilities son las default del rol bootstrap del backend
  /// (mirror local en `OwnerDefaultCapabilities`).
  localBootstrap,

  /// Recibido como respuesta exitosa de Core API (`/access/me/context` o
  /// `/auth/bootstrap`). Es la verdad canónica del servidor.
  serverRefresh,
}

/// Confirmación con backend. Ortogonal a `source`. Ej.: un snapshot
/// LOCAL_BOOTSTRAP recién creado offline está PENDING_SYNC; el mismo
/// snapshot tras un /context exitoso pasa a CONFIRMED. Un SERVER_REFRESH
/// está CONFIRMED por construcción.
enum AccessSyncStatus {
  /// Backend validó este contexto (o el flujo local fue confirmado en este
  /// arranque). Las capabilities son fiables.
  confirmed,

  /// Contexto nacido de acción local aún no confirmada por backend (típico
  /// de onboarding offline). Operaciones localSafe permitidas; operaciones
  /// networkCritical deben restringirse hasta `confirmed` (gating en V2.2).
  pendingSync,

  /// Hubo intento de sincronización fallido (5xx, red caída persistente).
  /// El snapshot sigue usable para lectura local pero networkCritical
  /// debe bloquearse hasta el próximo refresh exitoso. NO usar para
  /// 401/403 — esos invalidan el snapshot completamente vía
  /// `clearForWorkspace()`.
  syncFailed,
}

@Collection(inheritance: false)
class AccessContextSnapshotModel {
  Id? isarId;

  /// Composite unique key `"$userId:$workspaceId"`. Reemplaza al índice
  /// unique sobre `userId` solo (V1) que rompía el modelo multi-workspace.
  ///
  /// Construir SIEMPRE vía `makeCompositeKey()` para garantizar formato.
  @Index(unique: true, replace: true)
  late String compositeKey;

  /// `FirebaseAuth.currentUser.uid`. Indexado no-unique para `clearForUser()`.
  @Index()
  late String userId;

  /// Workspace bridge legacy (`Organization.id` / `orgId`). Partition key
  /// de los datos de negocio. Indexado no-unique para `clearForWorkspace()`.
  @Index()
  late String workspaceId;

  /// Shadow workspace local cuando aplique (LocalOrganization, ej. clientes
  /// importados sin sync remoto). Null cuando el workspace es canónico
  /// (Organization sincronizada).
  String? localWorkspaceId;

  /// UUID canónico del PlatformActor que representa al user en este
  /// workspace. PlatformActor ≠ User: un mismo User puede tener distintos
  /// PlatformActorId en distintos workspaces. Null hasta primer SERVER_REFRESH.
  String? platformActorId;

  /// UUID canónico de la membership en Core API. Null cuando el snapshot
  /// fue creado vía LOCAL_BOOTSTRAP y aún no hay sync remoto.
  String? membershipId;

  /// Rol canónico del user en este workspace. Wire-stable string
  /// ('OWNER' | 'ADMIN' | 'MEMBER' | 'PROVIDER_AGENT' | ...). Null si el
  /// backend aún no lo emite o el snapshot es LOCAL_BOOTSTRAP sin claim de
  /// rol. NO usar este campo para gates de policy — esos consultan
  /// `MembershipPolicy` y `capabilities`. Aquí es para observabilidad y
  /// para futuros consumidores de UI.
  String? role;

  /// True si el usuario es propietario del workspace. Persistido explícito
  /// para acelerar el bypass de la `MembershipPolicy` sin recomputar.
  late bool isOwner;

  /// True si el usuario tiene `ProviderProfile` activo en este workspace.
  /// En LOCAL_BOOTSTRAP se infiere de `Organization.capabilityProfiles`
  /// (kind=provider). En SERVER_REFRESH viene de `/providers/me`.
  late bool isProvider;

  /// UUID del ProviderProfile cuando isProvider=true. Distinto del
  /// providerWorkspaceId — un ProviderProfile pertenece a un workspace
  /// específico (puede no ser el `workspaceId` de este snapshot si el user
  /// es agente de un provider externo). Null cuando isProvider=false.
  String? providerProfileId;

  /// Workspace canónico del ProviderProfile activo (devuelto por
  /// `/v1/providers/me`). Vacío hasta el primer SERVER_REFRESH con
  /// isProvider=true.
  String? providerWorkspaceId;

  /// Capability ids semánticos resueltos. En LOCAL_BOOTSTRAP es
  /// `OwnerDefaultCapabilities.set`; en SERVER_REFRESH es el
  /// `capabilities[]` retornado por backend. Cada string DEBE coincidir
  /// con una constante de `domain/services/access/capabilities.dart`.
  late List<String> capabilities;

  /// Origen del dato del snapshot.
  @Enumerated(EnumType.name)
  late AccessSnapshotSource source;

  /// Confirmación con backend (ortogonal a source).
  @Enumerated(EnumType.name)
  late AccessSyncStatus syncStatus;

  /// Hash/versionTag opcional emitido por backend para detectar drift sin
  /// comparar capabilities[] elemento a elemento. Null si el backend aún
  /// no lo emite o si el snapshot es LOCAL_BOOTSTRAP.
  String? versionTag;

  /// Mensaje humano del último error de sync (cuando `syncStatus=syncFailed`).
  /// Útil para banner UX y debug. Null en confirmed/pendingSync.
  String? lastError;

  /// UTC de creación de la fila.
  late DateTime createdAt;

  /// UTC de la última escritura exitosa (cualquier source). El reloj
  /// canónico de "qué tan viejo es este snapshot".
  late DateTime fetchedAt;

  /// `fetchedAt + AccessSnapshotPolicy.freshUntil`. Más allá de aquí el
  /// snapshot es stale (operar normal con warning suave).
  late DateTime staleAt;

  /// `fetchedAt + AccessSnapshotPolicy.criticallyStaleAfter`. Más allá de
  /// aquí el snapshot es críticamente stale (lectura local OK; acciones
  /// networkCritical bloqueadas hasta refresh exitoso).
  late DateTime expiresAt;

  AccessContextSnapshotModel();

  /// Composite key canónico. Usar SIEMPRE este helper, nunca concatenar
  /// directo en call sites — un cambio futuro de formato (ej. agregar un
  /// nivel de scope) debe propagarse desde un solo lugar.
  static String makeCompositeKey(String userId, String workspaceId) =>
      '$userId:$workspaceId';
}

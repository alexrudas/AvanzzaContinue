// ============================================================================
// lib/data/models/network/team_actor_cache_model.dart
// TeamActorCacheModel — caché Isar local-first para sección "team" de Mi Red.
// ============================================================================
// QUÉ HACE:
//   Persiste UNA fila por (workspaceId, membershipId) de la sección "team".
//   Mismos invariantes que NetworkActorCacheModel — ver doc allí.
//
// DIFERENCIAS vs Network:
//   - Sin categorías (`primaryCategoryKey`/`categoriesAllKeys`).
//   - Sin `relationshipState` ni `isRestricted` (no aplican al equipo interno).
//   - PK alternativo: `membershipId` (no `actorRefRaw`) porque el contrato
//     /v1/team garantiza ref=`user:<userId>` único + membershipId estable.
//   - `teamRoleKeys` opcionalmente filtrable en V2; no indexado en V1.
// ============================================================================

import 'package:isar_community/isar.dart';

import 'network_cache_enums.dart';

part 'team_actor_cache_model.g.dart';

@Collection(inheritance: false)
class TeamActorCacheModel {
  Id? isarId;

  /// Composite unique key `"$workspaceId|team|$membershipId"`.
  @Index(unique: true, replace: true)
  late String compositeKey;

  @Index()
  late String workspaceId;

  /// Wire-stable raw del ref (siempre "user:<userId>" por contrato).
  late String actorRefRaw;

  /// userId extraído del ref.
  late String userId;

  /// Identificador de la membresía workspace↔user. Indexado para resolver
  /// el current membership rápidamente y decidir el render condicional
  /// "ocultar sección si solo está el owner".
  @Index()
  late String membershipId;

  late String displayName;

  @Index(type: IndexType.value, caseSensitive: false)
  late String displayNameNormalized;

  late String projectionJson;

  late DateTime updatedAt;
  late DateTime syncedAt;

  @Index()
  late bool missingInLastSync;

  DateTime? lastSeenAt;

  // ───────────── Reservados V2 ─────────────

  String? clientGeneratedId;
  DateTime? serverConfirmedAt;
  String? failedSyncReason;

  @Enumerated(EnumType.name)
  late NetworkCacheSource source;

  @Enumerated(EnumType.name)
  late NetworkCacheSyncState syncState;

  late int projectionSchemaVersion;

  TeamActorCacheModel();

  static const String sectionKey = 'team';

  static String makeCompositeKey({
    required String workspaceId,
    required String membershipId,
  }) =>
      '$workspaceId|$sectionKey|$membershipId';
}

// ============================================================================
// lib/data/models/network/team_actor_projection.dart
// ============================================================================
// INVARIANTE DE ARQUITECTURA — NO MODIFICAR SIN APROBACIÓN
// ============================================================================
// Proyección LIVIANA para la sección "team" de Mi Red.
// Mismas prohibiciones que NetworkActorProjection:
//   - NO DetailDTOs.
//   - NO entidades de dominio completas.
//   - NO arrays de objetos anidados.
//   - NO Map<String, dynamic>.
//
// `availableActions` NO se cachea; se recalcula en runtime.
// `teamRoleKeys` SÍ se preserva (lista de strings opacos del backend).
// ============================================================================

import 'team_member_summary_dto.dart';

/// Proyección liviana de un miembro del equipo interno.
class TeamActorProjection {
  /// Wire-stable raw del ref (siempre "user:<userId>" por contrato de /v1/team).
  final String actorRefRaw;

  /// Id del user extraído del ref.
  final String userId;

  /// Identificador de la membresía workspace↔user.
  final String membershipId;

  final String displayName;
  final String displayNameNormalized;

  final String? avatarRef;

  /// Claves de rol opacas (catálogo backend). Lista posiblemente vacía.
  final List<String> teamRoleKeys;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final bool hasWhatsApp;

  final DateTime updatedAt;

  const TeamActorProjection({
    required this.actorRefRaw,
    required this.userId,
    required this.membershipId,
    required this.displayName,
    required this.displayNameNormalized,
    required this.avatarRef,
    required this.teamRoleKeys,
    required this.primaryPhoneE164,
    required this.primaryEmail,
    required this.hasWhatsApp,
    required this.updatedAt,
  });

  /// Construye desde el DTO wire. Drop explícito de `availableActions[]`.
  factory TeamActorProjection.fromSummaryDto(
    TeamMemberSummaryDto dto, {
    required String displayNameNormalized,
  }) {
    return TeamActorProjection(
      actorRefRaw: dto.ref.raw,
      userId: dto.ref.id,
      membershipId: dto.membershipId,
      displayName: dto.displayName ?? '',
      displayNameNormalized: displayNameNormalized,
      avatarRef: dto.avatarRef,
      teamRoleKeys: List<String>.unmodifiable(dto.teamRoleKeys),
      primaryPhoneE164: dto.primaryPhoneE164,
      primaryEmail: dto.primaryEmail,
      hasWhatsApp: dto.hasWhatsApp,
      updatedAt: dto.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'actorRefRaw': actorRefRaw,
        'userId': userId,
        'membershipId': membershipId,
        'displayName': displayName,
        'displayNameNormalized': displayNameNormalized,
        'avatarRef': avatarRef,
        'teamRoleKeys': teamRoleKeys,
        'primaryPhoneE164': primaryPhoneE164,
        'primaryEmail': primaryEmail,
        'hasWhatsApp': hasWhatsApp,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory TeamActorProjection.fromJson(Map<String, dynamic> json) {
    final roles = (json['teamRoleKeys'] as List<dynamic>?) ?? const [];
    return TeamActorProjection(
      actorRefRaw: json['actorRefRaw'] as String,
      userId: json['userId'] as String,
      membershipId: json['membershipId'] as String,
      displayName: json['displayName'] as String,
      displayNameNormalized: json['displayNameNormalized'] as String,
      avatarRef: json['avatarRef'] as String?,
      teamRoleKeys: roles.map((e) => e as String).toList(growable: false),
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      hasWhatsApp: json['hasWhatsApp'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

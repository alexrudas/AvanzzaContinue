// ============================================================================
// lib/data/models/network/team_member_summary_dto.dart
// TEAM MEMBER SUMMARY DTO — Item de GET /v1/team (equipo interno v1)
// ============================================================================
// QUÉ HACE:
//   - Modela cada miembro del equipo interno que retorna Core API en
//     GET /v1/team.
//   - Aplica las invariantes del contrato congelado durante el parse:
//       · ref siempre es user:<userId>.
//       · /v1/team retorna solo Membership ACTIVE (garantía documentada
//         del backend; no testeable aquí, solo confiamos en el contrato).
//
// QUÉ NO HACE:
//   - No expone categories, primaryCategory, providerProfileId,
//     relationshipState, isRestricted ni restrictionReason: el equipo interno
//     vive en otro dominio y mezclarlos sería violar la separación
//     /network vs /team.
//   - No infiere roles: `teamRoleKeys[]` viene del backend con catálogo real
//     del sistema; Flutter NO inventa claves.
//
// PRINCIPIOS:
//   - teamRoleKeys[] como List<String> opaco: el catálogo es definido por
//     backend (capabilities/roles del sistema). Si el backend no lo emite,
//     viene como lista vacía (no se infiere).
// ============================================================================

import 'network_action_dto.dart';
import 'network_actor_ref.dart';

/// Item de GET /v1/team.
class TeamMemberSummaryDto {
  /// Referencia parseada. Garantizado: kind=user.
  final NetworkActorRef ref;

  /// Identificador de la membresía workspace↔user.
  final String membershipId;

  final String? displayName;
  final String? avatarRef;

  /// Claves de rol asignadas a la membresía. Lista opaca emitida por backend
  /// usando claves reales del sistema (no inventadas por Flutter). Puede
  /// venir vacía si el backend aún no expone roles para Hito 5b — la UI
  /// debe manejar lista vacía sin asumir catálogo.
  final List<String> teamRoleKeys;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final bool hasWhatsApp;

  /// Acciones operativas para contacto. Subset esperado: call, whatsapp, email.
  /// Si backend emite más, el parser las acepta (forward-compat) — la UI
  /// decide qué renderizar según `type`.
  final List<NetworkActionDto> availableActions;

  final DateTime updatedAt;

  const TeamMemberSummaryDto({
    required this.ref,
    required this.membershipId,
    required this.displayName,
    required this.avatarRef,
    required this.teamRoleKeys,
    required this.primaryPhoneE164,
    required this.primaryEmail,
    required this.hasWhatsApp,
    required this.availableActions,
    required this.updatedAt,
  });

  factory TeamMemberSummaryDto.fromJson(Map<String, dynamic> json) {
    final refRaw = json['ref'] as String;
    final ref = NetworkActorRef.parse(refRaw);
    if (!ref.isUser) {
      throw FormatException(
        'TeamMemberSummaryDto requiere ref user:*, recibido "$refRaw"',
      );
    }

    final teamRoleKeysRaw = (json['teamRoleKeys'] as List<dynamic>?) ?? const [];
    final teamRoleKeys =
        teamRoleKeysRaw.map((e) => e as String).toList(growable: false);

    final actionsRaw = (json['availableActions'] as List<dynamic>?) ?? const [];
    final availableActions = actionsRaw
        .map((e) => NetworkActionDto.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    return TeamMemberSummaryDto(
      ref: ref,
      membershipId: json['membershipId'] as String,
      displayName: json['displayName'] as String?,
      avatarRef: json['avatarRef'] as String?,
      teamRoleKeys: teamRoleKeys,
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      hasWhatsApp: json['hasWhatsApp'] as bool,
      availableActions: availableActions,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'ref': ref.raw,
        'membershipId': membershipId,
        'displayName': displayName,
        'avatarRef': avatarRef,
        'teamRoleKeys': teamRoleKeys,
        'primaryPhoneE164': primaryPhoneE164,
        'primaryEmail': primaryEmail,
        'hasWhatsApp': hasWhatsApp,
        'availableActions': availableActions.map((a) => a.toJson()).toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

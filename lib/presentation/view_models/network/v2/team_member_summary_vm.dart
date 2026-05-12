// ============================================================================
// lib/presentation/view_models/network/v2/team_member_summary_vm.dart
// TEAM MEMBER SUMMARY VM — Adaptador UI de TeamMemberSummaryDto
// ============================================================================
// QUÉ HACE:
//   - Adapta TeamMemberSummaryDto a un modelo consumible por la UI.
//   - Expone `groupKey` opcional para agrupamiento por rol cuando el backend
//     emite teamRoleKeys[]. Si la lista viene vacía, groupKey=null y la UI
//     debe renderizar lista plana sin agrupar.
//
// QUÉ NO HACE:
//   - NO inventa rol si teamRoleKeys=[]: la UI maneja "sin rol" sin asumir
//     catálogo paralelo.
//   - NO contiene labels en español. Las claves de teamRoleKeys son opacas
//     para Flutter (catálogo del sistema backend); la UI las renderiza via
//     un mapeo separado cuando exista, o como fallback.
// ============================================================================

import '../../../../data/models/network/network_actor_ref.dart';
import '../../../../data/models/network/team_actor_projection.dart';
import '../../../../data/models/network/team_member_summary_dto.dart';
import 'network_action_vm.dart';

class TeamMemberSummaryVM {
  /// Referencia parseada. Garantizado: kind=user.
  final NetworkActorRef ref;

  final String membershipId;

  final String? displayName;
  final String? avatarRef;

  /// Claves de rol opacas emitidas por backend. Lista posiblemente vacía si
  /// el backend aún no expone roles.
  final List<String> teamRoleKeys;

  final String? primaryPhoneE164;
  final String? primaryEmail;
  final bool hasWhatsApp;

  /// Acciones de contacto (call/whatsapp/email típicamente).
  final List<NetworkActionVM> actions;

  final DateTime updatedAt;

  const TeamMemberSummaryVM({
    required this.ref,
    required this.membershipId,
    required this.displayName,
    required this.avatarRef,
    required this.teamRoleKeys,
    required this.primaryPhoneE164,
    required this.primaryEmail,
    required this.hasWhatsApp,
    required this.actions,
    required this.updatedAt,
  });

  factory TeamMemberSummaryVM.fromDto(TeamMemberSummaryDto dto) =>
      TeamMemberSummaryVM(
        ref: dto.ref,
        membershipId: dto.membershipId,
        displayName: dto.displayName,
        avatarRef: dto.avatarRef,
        teamRoleKeys: dto.teamRoleKeys,
        primaryPhoneE164: dto.primaryPhoneE164,
        primaryEmail: dto.primaryEmail,
        hasWhatsApp: dto.hasWhatsApp,
        actions: dto.availableActions
            .map(NetworkActionVM.fromDto)
            .toList(growable: false),
        updatedAt: dto.updatedAt,
      );

  /// Construye un VM desde una `TeamActorProjection` rehidratada del cache
  /// local Isar. Fields que la projection NO preserva (availableActions)
  /// se rellenan con empty list (V1 no recalcula acciones offline).
  factory TeamMemberSummaryVM.fromProjection(TeamActorProjection p) {
    return TeamMemberSummaryVM(
      ref: NetworkActorRef.parse(p.actorRefRaw),
      membershipId: p.membershipId,
      displayName: p.displayName.isEmpty ? null : p.displayName,
      avatarRef: p.avatarRef,
      teamRoleKeys: List<String>.unmodifiable(p.teamRoleKeys),
      primaryPhoneE164: p.primaryPhoneE164,
      primaryEmail: p.primaryEmail,
      hasWhatsApp: p.hasWhatsApp,
      // V1: empty list. V2: NetworkActionResolver recalcula desde capabilities.
      actions: const <NetworkActionVM>[],
      updatedAt: p.updatedAt,
    );
  }

  // ── Helpers UI ────────────────────────────────────────────────────────

  /// Clave para agrupamiento UI. Usa el primer teamRoleKey si hay; null si
  /// la membresía no expone roles (UI debe caer a lista plana).
  ///
  /// Si en el futuro se quiere agrupar por TODOS los roles (un miembro en
  /// múltiples grupos), esa decisión vive en el controller, no acá.
  String? get groupKey =>
      teamRoleKeys.isNotEmpty ? teamRoleKeys.first : null;

  bool get hasContactChannel =>
      primaryPhoneE164 != null || primaryEmail != null;
}

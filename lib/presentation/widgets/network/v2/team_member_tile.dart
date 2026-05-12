// ============================================================================
// lib/presentation/widgets/network/v2/team_member_tile.dart
// TEAM MEMBER TILE — Fila densa del equipo interno (V1)
// ============================================================================
// QUÉ HACE:
//   - Renderiza un miembro del equipo con copy humano:
//       · Si es el current user: title="Administrador (Tú)" + subtitle
//         "Administrador de cuenta".
//       · Si no es current user y tiene displayName real: ese displayName
//         como title + label humano del rol como subtitle (mapeo
//         MiRedLabels.humanTeamRoleLabel).
//       · Si no es current user y no tiene displayName: title
//         "Administrador" + subtitle "Cuenta Avanzza".
//   - NUNCA muestra strings técnicos: "Sin nombre", "bootstrap_default_role",
//     "Administrador / Administrador" están prohibidos.
//
// QUÉ NO HACE:
//   - No decide si la sección Equipo se muestra. Esa decisión vive en
//     `bucketize` (regla: ocultar si solo está el admin bootstrap).
//   - No hace lookup directo a SessionContextController. El `currentUserId`
//     se pasa por parámetro desde la página, manteniendo el tile testeable
//     sin Get setup.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../view_models/network/v2/mi_red_labels.dart';
import '../../../view_models/network/v2/team_member_summary_vm.dart';

class TeamMemberTile extends StatelessWidget {
  final TeamMemberSummaryVM member;
  final VoidCallback onTap;

  /// ID del usuario actual. Si coincide con `member.ref.id`, el tile
  /// renderiza la variante "(Tú)". Puede ser null si la sesión aún no
  /// resuelve el currentUser — los fallbacks no-current se aplican.
  final String? currentUserId;

  const TeamMemberTile({
    super.key,
    required this.member,
    required this.onTap,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
        currentUserId != null && member.ref.id == currentUserId;
    final hasRealName =
        member.displayName != null && member.displayName!.trim().isNotEmpty;

    late final String title;
    late final String subtitle;
    if (isCurrentUser) {
      title = MiRedLabels.teamTitleCurrentUser;
      subtitle = MiRedLabels.teamSubtitleCurrentUser;
    } else if (hasRealName) {
      title = member.displayName!.trim();
      subtitle = _resolveSubtitleFromRoles(member.teamRoleKeys);
    } else {
      title = MiRedLabels.teamTitleAnonymousFallback;
      subtitle = MiRedLabels.teamSubtitleAnonymousFallback;
    }

    final initial = title.characters.isEmpty
        ? '?'
        : title.characters.first.toUpperCase();

    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }

  /// Resuelve el subtitle a partir de `teamRoleKeys`. Usa el primer rol
  /// con label humano disponible en el catálogo. Si ninguno mapea, cae
  /// a "Cuenta Avanzza" (NUNCA expone el wire key crudo al usuario).
  String _resolveSubtitleFromRoles(List<String> roleKeys) {
    for (final key in roleKeys) {
      final human = MiRedLabels.humanTeamRoleLabel(key);
      if (human != null && human.isNotEmpty) return human;
    }
    return MiRedLabels.teamSubtitleAnonymousFallback;
  }
}

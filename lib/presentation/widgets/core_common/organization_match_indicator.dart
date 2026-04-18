// ============================================================================
// lib/presentation/widgets/core_common/organization_match_indicator.dart
// ORGANIZATION MATCH INDICATOR — F5 Hito 2/3/4
// ============================================================================
// QUÉ HACE:
//   - Badge de precedencia para una LocalOrganization del workspace:
//       1. Si existe OperationalRelationship para (workspaceId, organization,
//          localId) → "Vinculado" (no clickable).
//       2. Si NO hay relación pero sí MatchCandidate en exposedToWorkspace
//          → "Canal disponible" (tap abre MatchResolutionSheet).
//       3. Si ninguno aplica → SizedBox.shrink().
//
// QUÉ NO HACE:
//   - NO consulta Isar directamente; consume repos vía DIContainer.
//   - NO dispara probe ni resolve; delega en ResolveMatchCandidate (use case).
//   - NO navega a pantallas nuevas.
//
// PRINCIPIOS:
//   - StreamBuilder anidado: relación (precedencia) → candidato fallback.
//   - Reactividad Isar: watchByTarget / watchExposedByWorkspace.
//
// ENTERPRISE NOTES:
//   - El badge "Vinculado" en v1 no abre detalle; la Relación aún no tiene
//     pantalla propia. Cuando exista, reemplazar por tap → detalle.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/core_common/match_candidate_entity.dart';
import '../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import 'match_resolution_sheet.dart';
import 'relationship_actions_sheet.dart';

class OrganizationMatchIndicator extends StatelessWidget {
  final String localOrganizationId;
  final String workspaceId;

  const OrganizationMatchIndicator({
    super.key,
    required this.localOrganizationId,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context) {
    final matchRepo = DIContainer().matchCandidateRepository;
    final relationshipRepo = DIContainer().operationalRelationshipRepository;

    return StreamBuilder<OperationalRelationshipEntity?>(
      stream: relationshipRepo.watchByTarget(
        workspaceId,
        TargetLocalKind.organization,
        localOrganizationId,
      ),
      builder: (ctx, relSnap) {
        final relationship = relSnap.data;
        if (relationship != null) {
          return _LinkedBadge(
            onTap: () =>
                RelationshipActionsSheet.show(context, relationship),
          );
        }
        return StreamBuilder<List<MatchCandidateEntity>>(
          stream: matchRepo.watchExposedByWorkspace(workspaceId),
          builder: (ctx, mcSnap) {
            final list = mcSnap.data ?? const <MatchCandidateEntity>[];
            MatchCandidateEntity? exposed;
            for (final mc in list) {
              if (mc.localKind == TargetLocalKind.organization &&
                  mc.localId == localOrganizationId) {
                exposed = mc;
                break;
              }
            }
            if (exposed == null) return const SizedBox.shrink();
            final candidate = exposed;
            return _ChannelBadge(
              onTap: () => MatchResolutionSheet.show(context, candidate),
            );
          },
        );
      },
    );
  }
}

class _ChannelBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _ChannelBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              'Canal disponible',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkedBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _LinkedBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Colors.green.shade700;
    return InkWell(
      key: const Key('organization_match_indicator.linked_badge'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              'Vinculado',
              style: theme.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

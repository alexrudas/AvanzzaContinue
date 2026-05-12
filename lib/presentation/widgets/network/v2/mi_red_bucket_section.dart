// ============================================================================
// lib/presentation/widgets/network/v2/mi_red_bucket_section.dart
// MI RED BUCKET SECTION — Header + counts + tiles + CTA opcional
// ============================================================================
// QUÉ HACE:
//   - Renderiza una sección vertical de Mi Red V1:
//       · Row de header: label largo del bucket + count + CTA "+ Agregar"
//         (solo si el bucket es creable en V1: productos / servicios).
//       · Lista inline de tiles (todos los items — sin "Ver todos" en V1).
//   - Acepta callbacks puros para tap de tile y tap de CTA. No conoce
//     navegación ni controller: el caller decide qué hacer.
//
// QUÉ NO HACE:
//   - No paginación visible. (loadMore queda en controller para V2.)
//   - No filtros ni búsqueda.
//   - No agrupamiento adicional dentro del bucket.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../view_models/network/v2/mi_red_buckets.dart';
import '../../../view_models/network/v2/mi_red_labels.dart';
import '../../../view_models/network/v2/network_actor_summary_vm.dart';
import '../../../view_models/network/v2/team_member_summary_vm.dart';
import 'network_actor_tile.dart';
import 'team_member_tile.dart';

class MiRedBucketSection extends StatelessWidget {
  /// Bucket que esta sección representa.
  final MiRedBucket bucket;

  /// Items de network — null si [bucket] == [MiRedBucket.equipo].
  final List<NetworkActorSummaryVM>? networkItems;

  /// Items de team — null si [bucket] != [MiRedBucket.equipo].
  final List<TeamMemberSummaryVM>? teamItems;

  /// Counts pre-computados (vienen de [MiRedBuckets.counts]).
  final BucketCounts counts;

  /// Tap en tile de network. Solo invocado cuando [bucket] no es equipo.
  final void Function(NetworkActorSummaryVM actor)? onTapNetworkActor;

  /// Tap en tile de team. Solo invocado cuando [bucket] == equipo.
  final void Function(TeamMemberSummaryVM member)? onTapTeamMember;

  /// Tap en "+ Agregar". Si es null, el CTA no se renderiza. Solo se
  /// pasa no-null para buckets creables en V1 (productos / servicios).
  final VoidCallback? onTapAgregar;

  /// ID del usuario actual. Propagado a `TeamMemberTile` para que pueda
  /// renderizar la variante "(Tú)". Null aceptable si no se conoce.
  final String? currentUserId;

  const MiRedBucketSection({
    super.key,
    required this.bucket,
    required this.counts,
    this.networkItems,
    this.teamItems,
    this.onTapNetworkActor,
    this.onTapTeamMember,
    this.onTapAgregar,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isEquipo = bucket == MiRedBucket.equipo;
    final countText = isEquipo
        ? MiRedLabels.teamCount(counts.total)
        : MiRedLabels.networkCount(
            contactos: counts.contactos,
            aliados: counts.aliados,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MiRedLabels.sectionHeader(bucket),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (countText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          countText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (onTapAgregar != null)
                TextButton.icon(
                  onPressed: onTapAgregar,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ),
        // ── Tiles ─────────────────────────────────────────────────────
        if (isEquipo)
          ..._buildTeamTiles()
        else
          ..._buildNetworkTiles(),
        const SizedBox(height: 8),
      ],
    );
  }

  Iterable<Widget> _buildNetworkTiles() {
    final items = networkItems ?? const <NetworkActorSummaryVM>[];
    return items.map((actor) => NetworkActorTile(
          // visualStableKey ancla el tile a la identidad operacional del actor.
          // Durante la transición synth (`local:contact:X`) → real
          // (`platform:Y`) para el MISMO actor (mismo LocalContact.id), el
          // key NO cambia, Flutter preserva el Element y no destruye el tile.
          // Sin este ancla, ref.raw cambia → key cambia → micro-flicker.
          key: ValueKey('mi_red.${bucket.name}.${actor.visualStableKey}'),
          actor: actor,
          onTap: () => onTapNetworkActor?.call(actor),
        ));
  }

  Iterable<Widget> _buildTeamTiles() {
    final items = teamItems ?? const <TeamMemberSummaryVM>[];
    return items.map((member) => TeamMemberTile(
          key: ValueKey('mi_red.equipo.${member.ref.raw}'),
          member: member,
          currentUserId: currentUserId,
          onTap: () => onTapTeamMember?.call(member),
        ));
  }
}

// ============================================================================
// lib/presentation/widgets/network/v2/network_actor_tile.dart
// NETWORK ACTOR TILE — Fila de actor de Mi Red V1 (actor-centric)
// ============================================================================
// QUÉ HACE:
//   - Tile compacto: avatar + nombre + badges secundarios (cuando el actor
//     pertenece a >1 bucket V1) + badge trailing Contacto/Aliado.
//   - Si está restringido (suspendido/cerrado) reemplaza el badge de
//     contacto por un badge de restricción.
//   - onTap delega al caller (típicamente ActionsBottomSheet).
//
// QUÉ NO HACE:
//   - No muestra categoría técnica como subtitle (decisión V1: actor-centric,
//     sin taxonomía de backend en UI).
//   - No deriva agrupamiento — eso vive en bucketize() del controller.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../data/models/network/network_actor_summary_dto.dart'
    show NetworkRestrictionReason;
import '../../../view_models/network/v2/mi_red_buckets.dart';
import '../../../view_models/network/v2/mi_red_labels.dart';
import '../../../view_models/network/v2/network_actor_summary_vm.dart';
import '../../../view_models/network/v2/network_labels.dart';

class NetworkActorTile extends StatelessWidget {
  final NetworkActorSummaryVM actor;
  final VoidCallback onTap;

  const NetworkActorTile({
    super.key,
    required this.actor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = actor.displayName?.trim().isNotEmpty == true
        ? actor.displayName!
        : 'Sin nombre';
    final initial = displayName.characters.isEmpty
        ? '?'
        : displayName.characters.first.toUpperCase();

    // Badges secundarios cuando el actor pertenece a >1 bucket V1.
    // Si solo pertenece a 1 (caso normal en V1), la línea queda vacía y
    // no se imprime un subtitle redundante.
    final badgeLine =
        MiRedLabels.secondaryBadgeLine(bucketsForActor(actor));

    return ListTile(
      leading: CircleAvatar(child: Text(initial)),
      title: Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: badgeLine.isEmpty
          ? null
          : Text(
              badgeLine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: actor.isRestricted && actor.restrictionReason != null
          ? _RestrictionBadge(reason: actor.restrictionReason!)
          // V1: SIEMPRE "Contacto". El contrato actual no expone una señal
          // confiable de "Aliado" (vínculo bilateral / adopción global).
          // `actor.isAliado` solo refleja si el ref es platform-resuelto,
          // lo cual NO califica como aliado real. Cuando backend exponga
          // el signal, recuperar la rama con `actor.isAliado`.
          // TODO(backend): activar Aliado cuando exista contrato.
          : const _ContactStatusBadge(isAliado: false),
      onTap: onTap,
    );
  }
}

class _ContactStatusBadge extends StatelessWidget {
  final bool isAliado;
  const _ContactStatusBadge({required this.isAliado});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Aliado = verde-tertiary (verificado en plataforma).
    // Contacto = neutro (registro local).
    final bg = isAliado
        ? scheme.tertiaryContainer
        : scheme.surfaceContainerHighest;
    final fg = isAliado
        ? scheme.onTertiaryContainer
        : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAliado ? MiRedLabels.aliadoLabel : MiRedLabels.contactoLabel,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RestrictionBadge extends StatelessWidget {
  final NetworkRestrictionReason reason;
  const _RestrictionBadge({required this.reason});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        NetworkLabels.restrictionBadge(reason),
        style: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

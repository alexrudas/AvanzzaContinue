// ============================================================================
// lib/presentation/pages/admin/network/actor_detail_page.dart
// ACTOR DETAIL PAGE v2 — ficha útil (ADR §10 + §11 + §13 + §14)
// ============================================================================
// QUÉ HACE:
//   - Consume [ActorDetailController] para mostrar información REAL del
//     actor, no solo identidad técnica:
//       * Datos de contacto hidratados desde la libreta (phone, email, doc).
//       * Vínculo actual con rol, estado, fuente y timestamp.
//       * Otros vínculos del mismo actor en el workspace (multi-activo).
//       * Estado de la relación operativa cuando aplica.
//   - Estados: loading / error / data / guard (argument faltante).
//
// QUÉ NO HACE:
//   - NO lee PortfolioEntity (ADR §11 — guardrail activo).
//   - NO muestra riskFlags retirados en §14 (hasFines, licenseStatus):
//     esos datos volverán por un flujo server-side dedicado, no por aquí.
//   - NO permite mutaciones (suspend/reactivate/close) — fuera del alcance
//     del hito 5 según §13.2.
//
// See docs/adr/0001-actor-canon.md §10, §11, §13, §14.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/core_common/asset_actor_link_entity.dart';
import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/entities/core_common/local_organization_entity.dart';
import '../../../../domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import '../../../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../../../domain/entities/core_common/value_objects/relationship_state.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../controllers/admin/network/actor_detail_controller.dart';
import '../../../view_models/network/network_actor_vm.dart';

class ActorDetailPage extends StatelessWidget {
  const ActorDetailPage({super.key});

  /// Clave canónica del argument map: `Get.arguments = {'actor': NetworkActorVm}`.
  static const argKey = 'actor';

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final actor = args?[argKey] as NetworkActorVm?;

    if (actor == null) {
      // Guard: navegación mal formada. No hay controller registrado.
      return Scaffold(
        appBar: AppBar(title: const Text('Actor no disponible')),
        body: const Center(
          child: Text('No se pudo abrir la ficha del actor.'),
        ),
      );
    }

    return _ActorDetailView(seed: actor);
  }
}

// ─── Vista con controller inyectado por binding ────────────────────────────

class _ActorDetailView extends StatelessWidget {
  final NetworkActorVm seed;
  const _ActorDetailView({required this.seed});

  @override
  Widget build(BuildContext context) {
    final ctl = Get.find<ActorDetailController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          seed.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: ctl.reload,
          ),
        ],
      ),
      body: Obx(() {
        if (ctl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctl.error.value != null) {
          return _ErrorBody(message: ctl.error.value!, onRetry: ctl.reload);
        }

        return RefreshIndicator(
          onRefresh: ctl.reload,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _Header(seed: seed),

              const Divider(height: 1),
              _CurrentLinkSection(seed: seed, relationshipState: ctl.relationshipState.value),

              if (ctl.localContact.value != null) ...[
                const Divider(height: 1),
                _ContactProfileSection(contact: ctl.localContact.value!),
              ],
              if (ctl.localOrganization.value != null) ...[
                const Divider(height: 1),
                _OrganizationProfileSection(org: ctl.localOrganization.value!),
              ],

              const Divider(height: 1),
              _IdentitySection(seed: seed),

              if (ctl.otherLinks.isNotEmpty) ...[
                const Divider(height: 1),
                _OtherLinksSection(links: ctl.otherLinks),
              ],

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final NetworkActorVm seed;
  const _Header({required this.seed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final initials = _initials(seed.displayName);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: cs.primaryContainer,
            child: Text(
              initials,
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seed.displayName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _roleLabel(seed.role),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.elementAt(1)[0]).toUpperCase();
  }
}

// ─── Sección: vínculo actual ───────────────────────────────────────────────

class _CurrentLinkSection extends StatelessWidget {
  final NetworkActorVm seed;
  final RelationshipState? relationshipState;
  const _CurrentLinkSection({
    required this.seed,
    required this.relationshipState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final chips = <Widget>[
      _chip(context, _roleLabel(seed.role), cs.primary),
      _chip(context, 'Vínculo · ${seed.linkStatus}', cs.secondary),
      _chip(context, 'Origen · ${seed.linkSource}', cs.tertiary),
      if (relationshipState != null)
        _chip(context, 'Relación · ${_relLabel(relationshipState!)}', cs.primary),
    ];

    return _SectionCard(
      title: 'Vínculo actual',
      children: [
        Wrap(spacing: 8, runSpacing: 6, children: chips),
        const SizedBox(height: 12),
        _KeyValue(label: 'Activo', value: seed.assetId),
        _KeyValue(label: 'ID del vínculo', value: seed.assetActorLinkId, dim: true),
      ],
    );
  }

  Widget _chip(BuildContext ctx, String label, Color color) {
    final theme = Theme.of(ctx);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Sección: perfil de contacto (libreta local) ──────────────────────────

class _ContactProfileSection extends StatelessWidget {
  final LocalContactEntity contact;
  const _ContactProfileSection({required this.contact});

  @override
  Widget build(BuildContext context) {
    final rows = <_KeyValue>[];
    if (contact.roleLabel != null && contact.roleLabel!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Etiqueta', value: contact.roleLabel!));
    }
    if (contact.primaryPhoneE164 != null &&
        contact.primaryPhoneE164!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Teléfono', value: contact.primaryPhoneE164!));
    }
    if (contact.primaryEmail != null && contact.primaryEmail!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Email', value: contact.primaryEmail!));
    }
    if (contact.docId != null && contact.docId!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Documento', value: contact.docId!));
    }

    return _SectionCard(
      title: 'Datos de contacto',
      children: rows.isEmpty
          ? [const _EmptyNote('Sin datos de contacto registrados en la libreta.')]
          : rows,
    );
  }
}

// ─── Sección: perfil de organización ──────────────────────────────────────

class _OrganizationProfileSection extends StatelessWidget {
  final LocalOrganizationEntity org;
  const _OrganizationProfileSection({required this.org});

  @override
  Widget build(BuildContext context) {
    final rows = <_KeyValue>[];
    if (org.legalName != null && org.legalName!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Razón social', value: org.legalName!));
    }
    if (org.taxId != null && org.taxId!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'NIT', value: org.taxId!));
    }
    if (org.primaryPhoneE164 != null &&
        org.primaryPhoneE164!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Teléfono', value: org.primaryPhoneE164!));
    }
    if (org.primaryEmail != null && org.primaryEmail!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Email', value: org.primaryEmail!));
    }
    if (org.website != null && org.website!.trim().isNotEmpty) {
      rows.add(_KeyValue(label: 'Sitio', value: org.website!));
    }

    return _SectionCard(
      title: 'Datos de la organización',
      children: rows.isEmpty
          ? [const _EmptyNote('Sin datos adicionales en la libreta.')]
          : rows,
    );
  }
}

// ─── Sección: identidad (ActorRef) ─────────────────────────────────────────

class _IdentitySection extends StatelessWidget {
  final NetworkActorVm seed;
  const _IdentitySection({required this.seed});

  @override
  Widget build(BuildContext context) {
    final rows = <_KeyValue>[
      _KeyValue(label: 'Tipo', value: _refKindLabel(seed.actorRefKind)),
    ];
    if (seed.platformActorId != null) {
      rows.add(_KeyValue(
        label: 'PlatformActor',
        value: seed.platformActorId!,
        dim: true,
      ));
    }
    if (seed.localKind != null && seed.localId != null) {
      rows.add(_KeyValue(
        label: 'Ref local',
        value: '${seed.localKind!.wireName} · ${seed.localId}',
        dim: true,
      ));
    }

    return _SectionCard(title: 'Identidad', children: rows);
  }
}

// ─── Sección: otros vínculos del mismo actor ──────────────────────────────

class _OtherLinksSection extends StatelessWidget {
  final List<AssetActorLinkEntity> links;
  const _OtherLinksSection({required this.links});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _SectionCard(
      title: 'Otros vínculos en tu red (${links.length})',
      children: [
        for (final l in links)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.link_rounded, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_roleLabel(l.role)} · ${l.assetId}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Desde ${_formatDate(l.startedAt)} · ${l.status}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    final local = d.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}

// ─── Primitivos reutilizables ──────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  final bool dim;
  const _KeyValue({
    required this.label,
    required this.value,
    this.dim = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: dim ? cs.onSurfaceVariant : cs.onSurface,
                fontWeight: dim ? FontWeight.w400 : FontWeight.w500,
                fontFamily: dim ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  final String text;
  const _EmptyNote(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: cs.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: cs.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Labels ────────────────────────────────────────────────────────────────

String _roleLabel(AssetActorRole r) {
  switch (r) {
    case AssetActorRole.owner:
      return 'Propietario';
    case AssetActorRole.tenant:
      return 'Arrendatario';
    case AssetActorRole.operator:
      return 'Operador';
    case AssetActorRole.driver:
      return 'Conductor';
    case AssetActorRole.technician:
      return 'Técnico';
    case AssetActorRole.workshop:
      return 'Taller';
    case AssetActorRole.legal:
      return 'Legal';
    case AssetActorRole.manager:
      return 'Administrador';
  }
}

String _refKindLabel(ActorRefKindValue k) {
  switch (k) {
    case ActorRefKindValue.platform:
      return 'Plataforma';
    case ActorRefKindValue.local:
      return 'Libreta local';
  }
}

String _relLabel(RelationshipState s) {
  switch (s) {
    case RelationshipState.referenciada:
      return 'referenciada';
    case RelationshipState.detectable:
      return 'detectable';
    case RelationshipState.activadaUnilateral:
      return 'activada unilateral';
    case RelationshipState.vinculada:
      return 'vinculada';
    case RelationshipState.suspendida:
      return 'suspendida';
    case RelationshipState.cerrada:
      return 'cerrada';
  }
}

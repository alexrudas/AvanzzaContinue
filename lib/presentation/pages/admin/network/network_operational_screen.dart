// ============================================================================
// lib/presentation/pages/admin/network/network_operational_screen.dart
// NETWORK OPERATIONAL SCREEN v2 — ADR actor-canon §10 + §11
// ============================================================================
// QUÉ HACE:
//   - Lista actores de la red operativa (cualquier rol) a partir de
//     `NetworkOperationalController` v2.
//   - Filtro por rol con chips horizontales (solo los roles realmente
//     presentes en la carga actual).
//   - Búsqueda por displayName (case-insensitive).
//   - Navega a ActorDetailPage con el VM seleccionado.
//
// QUÉ NO HACE:
//   - NO tiene clases OwnerListTile / TenantListTile / DriverListTile. Un
//     solo tile genérico para cualquier actor. La UI se especializa por
//     rol (tabs, label, color) solo cuando hay divergencia real.
//   - NO asume portfolio/SIMIT/licencia (retirados en 5c por §11).
//
// See docs/adr/0001-actor-canon.md §10 + §11.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/core_common/value_objects/asset_actor_role.dart';
import '../../../../routes/app_routes.dart';
import '../../../controllers/admin/network/network_operational_controller.dart';
import '../../../view_models/network/network_actor_vm.dart';
import 'actor_detail_page.dart';

class NetworkOperationalScreen extends StatefulWidget {
  const NetworkOperationalScreen({super.key});

  @override
  State<NetworkOperationalScreen> createState() =>
      _NetworkOperationalScreenState();
}

class _NetworkOperationalScreenState extends State<NetworkOperationalScreen> {
  late final NetworkOperationalController _controller;
  bool _searchActive = false;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<NetworkOperationalController>();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;
      if (!_searchActive) {
        _searchCtrl.clear();
        _controller.setSearchQuery('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: _searchActive
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre…',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _controller.setSearchQuery,
              )
            : const Text('Mi red operativa'),
        actions: [
          IconButton(
            icon: Icon(_searchActive ? Icons.close : Icons.search_rounded),
            tooltip: _searchActive ? 'Cerrar búsqueda' : 'Buscar',
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => _RoleFilterBar(
                present: _controller.rolesPresent,
                selected: _controller.roleFilter.value,
                onSelect: _controller.setRoleFilter,
              )),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_controller.error.value != null) {
                return _ErrorState(message: _controller.error.value!);
              }
              final list = _controller.filteredActors;
              if (list.isEmpty) {
                if (_controller.searchQuery.value.isNotEmpty) {
                  return _EmptySearch(query: _controller.searchQuery.value);
                }
                return const _EmptyState();
              }
              return RefreshIndicator(
                onRefresh: _controller.reload,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (_, i) => _ActorTile(actor: list[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Filtro por rol (chips) ──────────────────────────────────────────────────

class _RoleFilterBar extends StatelessWidget {
  final Set<AssetActorRole> present;
  final AssetActorRole? selected;
  final void Function(AssetActorRole? role) onSelect;

  const _RoleFilterBar({
    required this.present,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (present.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Orden estable: siguiendo el orden del enum AssetActorRole.
    final ordered = AssetActorRole.values.where(present.contains).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      color: cs.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chip(
              context,
              label: 'Todos',
              active: selected == null,
              onTap: () => onSelect(null),
            ),
            const SizedBox(width: 8),
            for (final r in ordered) ...[
              _chip(
                context,
                label: _roleLabel(r),
                active: selected == r,
                onTap: () => onSelect(r),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext ctx, {
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(ctx);
    final cs = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? cs.primary : cs.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: active ? cs.onPrimary : cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Tile genérico ──────────────────────────────────────────────────────────

class _ActorTile extends StatelessWidget {
  final NetworkActorVm actor;
  const _ActorTile({required this.actor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: cs.primaryContainer,
        child: Text(
          _initials(actor.displayName),
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        actor.displayName,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _roleLabel(actor.role),
        style: theme.textTheme.bodySmall?.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      onTap: () => Get.toNamed(
        Routes.actorDetail,
        arguments: {ActorDetailPage.argKey: actor},
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

// ── Estados vacíos/error ───────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
              Icons.people_outline_rounded,
              size: 64,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay actores en tu red aún.',
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Los actores aparecen cuando se registra un vínculo con alguno de tus activos (propietario, conductor, taller, etc.).',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

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
              Icons.search_off_rounded,
              size: 56,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin resultados para "$query"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

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
            const SizedBox(height: 16),
            Text(
              'No se pudo cargar la red operativa',
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper de labels (local al módulo) ─────────────────────────────────────

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

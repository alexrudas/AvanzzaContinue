// ============================================================================
// lib/presentation/pages/admin/network/network_operational_screen.dart
// NETWORK OPERATIONAL SCREEN — "Mi red operativa" / Propietarios
//
// QUÉ HACE:
// - Muestra la lista de propietarios deduplicados y agregados de la org activa.
// - Gestiona 4 estados: loading, error, empty y data.
// - Permite búsqueda por nombre o documento con SearchBar colapsable.
// - Navega a [OwnerDetailPage] al tocar un propietario.
//
// QUÉ NO HACE:
// - No muestra UI para actores futuros (Arrendatarios, Conductores, etc.).
//   La estructura interna es multi-actor preparada; la UI solo expone lo que
//   tiene datos reales.
// - No persiste datos ni accede directamente a repositorios.
// - No contiene lógica de agregación — delega a [NetworkOperationalController].
//
// PRINCIPIOS:
// - Theme-first: todos los colores y estilos desde ColorScheme y TextTheme.
// - Stateless: el estado vive completamente en [NetworkOperationalController].
// - La métrica visible es "N portafolios" — no "N activos" (Sprint 1).
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Sprint 1 módulo "Mi red operativa" — Propietarios.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../controllers/admin/network/network_operational_controller.dart';
import '../../../view_models/network/owner_network_vm.dart';

class NetworkOperationalScreen extends StatefulWidget {
  const NetworkOperationalScreen({super.key});

  @override
  State<NetworkOperationalScreen> createState() =>
      _NetworkOperationalScreenState();
}

class _NetworkOperationalScreenState extends State<NetworkOperationalScreen> {
  late final NetworkOperationalController _controller;

  /// Controla si el SearchBar está expandido en el AppBar.
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
        _controller.searchQuery.value = '';
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
                  hintText: 'Buscar por nombre o documento…',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (v) => _controller.searchQuery.value = v,
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
      body: Obx(() {
        // ── Estado: cargando ─────────────────────────────────────────────
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Estado: error ────────────────────────────────────────────────
        if (_controller.error.value != null) {
          return _NetworkErrorState(message: _controller.error.value!);
        }

        // ── Estado: vacío ────────────────────────────────────────────────
        if (_controller.filteredOwners.isEmpty) {
          // Si hay búsqueda activa y no hay resultados, mostrar mensaje específico.
          if (_controller.searchQuery.value.isNotEmpty) {
            return _NetworkEmptySearch(query: _controller.searchQuery.value);
          }
          return const _NetworkEmptyState();
        }

        // ── Estado: con datos ────────────────────────────────────────────
        return _OwnerList(owners: _controller.filteredOwners);
      }),
    );
  }
}

// ── Lista de propietarios ─────────────────────────────────────────────────────

class _OwnerList extends StatelessWidget {
  final List<OwnerNetworkVm> owners;

  const _OwnerList({required this.owners});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: owners.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (_, i) => _OwnerListTile(owner: owners[i]),
    );
  }
}

// ── Tile de propietario ───────────────────────────────────────────────────────

class _OwnerListTile extends StatelessWidget {
  final OwnerNetworkVm owner;

  const _OwnerListTile({required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final docText = _formatDoc(owner);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: _OwnerAvatar(name: owner.name, cs: cs),
      title: Text(
        owner.name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (docText != null)
            Text(
              docText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            _portfolioCountText(owner.portfolioCount),
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          if (owner.riskFlags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: owner.riskFlags
                  .map((f) => _OwnerRiskChip(flag: f, owner: owner))
                  .toList(),
            ),
          ],
        ],
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: cs.onSurfaceVariant,
      ),
      onTap: () => Get.toNamed(
        Routes.ownerDetail,
        arguments: {'owner': owner},
      ),
    );
  }

  String? _formatDoc(OwnerNetworkVm o) {
    final type = o.documentType?.trim().toUpperCase();
    final doc = o.document.trim();
    if (doc.isEmpty) return null;
    if (type != null && type.isNotEmpty) return '$type · $doc';
    return doc;
  }

  String _portfolioCountText(int count) {
    return '$count ${count == 1 ? 'portafolio asociado' : 'portafolios asociados'}';
  }
}

// ── Avatar de iniciales ────────────────────────────────────────────────────────

class _OwnerAvatar extends StatelessWidget {
  final String name;
  final ColorScheme cs;

  const _OwnerAvatar({required this.name, required this.cs});

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.elementAt(1)[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: cs.primaryContainer,
      child: Text(
        _initials,
        style: TextStyle(
          color: cs.onPrimaryContainer,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

// ── Chip de riesgo ────────────────────────────────────────────────────────────

class _OwnerRiskChip extends StatelessWidget {
  final OwnerRiskFlag flag;
  final OwnerNetworkVm owner;

  const _OwnerRiskChip({required this.flag, required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    switch (flag) {
      case OwnerRiskFlag.hasFines:
        final label = owner.simitFormattedTotal != null
            ? 'Multas ${owner.simitFormattedTotal}'
            : 'Multas activas';
        return _chip(context, label, cs.error, cs.onError);

      case OwnerRiskFlag.licenseNotVigent:
        final label = owner.licenseStatus ?? 'Lic. no vigente';
        return _chip(context, label, Colors.amber.shade700, Colors.white);
    }
  }

  Widget _chip(BuildContext ctx, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bg.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
          color: bg,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ── Estados de la pantalla ────────────────────────────────────────────────────

class _NetworkEmptyState extends StatelessWidget {
  const _NetworkEmptyState();

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
              'Ningún propietario registrado aún.',
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Los propietarios aparecen cuando completas una consulta VRC en tus portafolios.',
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

class _NetworkEmptySearch extends StatelessWidget {
  final String query;

  const _NetworkEmptySearch({required this.query});

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

class _NetworkErrorState extends StatelessWidget {
  final String message;

  const _NetworkErrorState({required this.message});

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

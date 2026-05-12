// ============================================================================
// lib/presentation/pages/admin/network/providers_directory_page.dart
// PROVIDERS DIRECTORY PAGE — Listado serio de proveedores del workspace
// ============================================================================
// QUÉ HACE:
//   - Listado dedicado de proveedores del workspace (SSOT = LocalContact con
//     `roleLabel='proveedor'`), compartida con el selector de Pedidos.
//   - UN SOLO chip de filtro en el header: muestra icono + filtro activo +
//     conteo entre paréntesis. Al tocarlo abre un BottomSheet con las
//     opciones Todos / Completos / Incompletos como RadioListTile.
//   - Cada tarjeta muestra solo nombre + dato secundario útil + (condicional)
//     subtítulo "Completa su registro" cuando el perfil está incompleto.
//     Si está completo NO se muestra badge, chip ni ruido.
//   - Tap en la tarjeta o chevron-right → abre detalle del proveedor CORRECTO
//     (`Routes.providerDetail` con `{'providerId': <id>}`).
//   - FAB "Agregar proveedor" navega al formulario completo
//     (`Routes.providerForm`).
//   - Long-press conserva un atajo de eliminación (acción secundaria); las
//     acciones no se esconden detrás de "tres puntitos" como patrón principal.
//
// QUÉ NO HACE:
//   - NO repinta pills/chips de estado en cada tarjeta.
//   - NO crea otra fuente de verdad: el stream sale del mismo repo que
//     consume el picker de pedidos.
//   - NO depende del probe remoto para nada.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../routes/app_routes.dart';
import '../../../controllers/admin/network/providers_directory_controller.dart';

class ProvidersDirectoryPage extends StatefulWidget {
  const ProvidersDirectoryPage({super.key});

  @override
  State<ProvidersDirectoryPage> createState() => _ProvidersDirectoryPageState();
}

class _ProvidersDirectoryPageState extends State<ProvidersDirectoryPage> {
  late final ProvidersDirectoryController _controller;
  bool _searchActive = false;
  final _searchCtrl = TextEditingController();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _activeSnack;
  Timer? _snackDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProvidersDirectoryController>();
  }

  @override
  void dispose() {
    _snackDismissTimer?.cancel();
    try {
      _activeSnack?.close();
    } catch (_) {}
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

  // ── BUILD ───────────────────────────────────────────────────────────────

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
                  hintText: 'Buscar proveedor por nombre…',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _controller.setSearchQuery,
              )
            : const Text('Proveedores'),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _FilterChip(controller: _controller, onTap: _openFilters),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_controller.error.value != null) {
                return _ErrorState(message: _controller.error.value!);
              }
              final list = _controller.filteredProviders;
              if (list.isEmpty) {
                if (_controller.searchQuery.value.trim().isNotEmpty) {
                  return _EmptySearch(query: _controller.searchQuery.value);
                }
                if (_controller.completenessFilter.value != null) {
                  return _EmptyFilter(
                    wantComplete:
                        _controller.completenessFilter.value == true,
                    onClear: () => _controller.setCompletenessFilter(null),
                  );
                }
                return _EmptyState(onCreate: _goToCreate);
              }
              return ListView.separated(
                padding: const EdgeInsets.only(top: 8, bottom: 96),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 72),
                itemBuilder: (_, i) => _ProviderTile(
                  provider: list[i],
                  complete: _controller.isProviderComplete(list[i]),
                  onTap: () => _openDetail(list[i]),
                  onLongPress: () => _confirmAndDelete(list[i]),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('providers_directory.fab.add'),
        icon: const Icon(Icons.add_business_outlined),
        label: const Text('Agregar proveedor'),
        onPressed: _goToCreate,
      ),
    );
  }

  // ── ACCIONES ────────────────────────────────────────────────────────────

  Future<void> _openFilters() async {
    final cs = Theme.of(context).colorScheme;
    final current = _controller.completenessFilter.value;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filtrar proveedores',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _FilterOption(
                label: 'Todos',
                icon: Icons.list_alt_rounded,
                count: _controller.completenessCounts.total,
                selected: current == null,
                onTap: () {
                  _controller.setCompletenessFilter(null);
                  Navigator.of(ctx).pop();
                },
              ),
              _FilterOption(
                label: 'Completos',
                icon: Icons.verified_rounded,
                count: _controller.completenessCounts.complete,
                selected: current == true,
                onTap: () {
                  _controller.setCompletenessFilter(true);
                  Navigator.of(ctx).pop();
                },
              ),
              _FilterOption(
                label: 'Incompletos',
                icon: Icons.info_outline_rounded,
                count: _controller.completenessCounts.incomplete,
                selected: current == false,
                onTap: () {
                  _controller.setCompletenessFilter(false);
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToCreate() async {
    await Get.toNamed(Routes.providerForm);
  }

  Future<void> _openDetail(LocalContactEntity provider) async {
    await Get.toNamed(
      Routes.providerDetail,
      arguments: {'providerId': provider.id},
    );
  }

  Future<void> _confirmAndDelete(LocalContactEntity provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: Text(
          '¿Eliminar "${provider.displayName}" del directorio? '
          'Podrás deshacer esta acción desde el aviso que aparecerá.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (!mounted || confirm != true) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final err = await _controller.softDeleteProvider(provider.id);
    if (!mounted) return;
    if (err != null) {
      _showSnack(err);
      return;
    }
    if (messenger == null) return;
    _snackDismissTimer?.cancel();
    messenger.hideCurrentSnackBar();
    const duration = Duration(seconds: 5);
    _activeSnack = messenger.showSnackBar(
      SnackBar(
        content: Text('"${provider.displayName}" eliminado del directorio.'),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () async {
            _snackDismissTimer?.cancel();
            try {
              _activeSnack?.close();
            } catch (_) {}
            final restoreErr =
                await _controller.restoreProvider(provider.id);
            if (!mounted) return;
            if (restoreErr != null) _showSnack(restoreErr);
          },
        ),
      ),
    );
    _snackDismissTimer = Timer(duration, () {
      try {
        _activeSnack?.close();
      } catch (_) {}
      _activeSnack = null;
    });
  }

  void _showSnack(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CHIP ÚNICO DE FILTRO
// ═══════════════════════════════════════════════════════════════════════════

class _FilterChip extends StatelessWidget {
  final ProvidersDirectoryController controller;
  final VoidCallback onTap;
  const _FilterChip({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filter = controller.completenessFilter.value;
      final counts = controller.completenessCounts;
      late final String label;
      late final IconData icon;
      late final int count;
      if (filter == null) {
        label = 'Todos';
        icon = Icons.list_alt_rounded;
        count = counts.total;
      } else if (filter == true) {
        label = 'Completos';
        icon = Icons.verified_rounded;
        count = counts.complete;
      } else {
        label = 'Incompletos';
        icon = Icons.info_outline_rounded;
        count = counts.incomplete;
      }
      return ActionChip(
        key: const Key('providers_directory.filterChip'),
        avatar: Icon(icon, size: 18),
        label: Text('$label ($count)'),
        onPressed: onTap,
      );
    });
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  const _FilterOption({
    required this.label,
    required this.icon,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon,
          color: selected ? theme.colorScheme.primary : theme.hintColor),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.hintColor)),
          const SizedBox(width: 8),
          if (selected)
            Icon(Icons.check_rounded, color: theme.colorScheme.primary)
          else
            const SizedBox(width: 24),
        ],
      ),
      onTap: onTap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TILE
// ═══════════════════════════════════════════════════════════════════════════

class _ProviderTile extends StatelessWidget {
  final LocalContactEntity provider;
  final bool complete;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ProviderTile({
    required this.provider,
    required this.complete,
    required this.onTap,
    required this.onLongPress,
  });

  /// Dato secundario útil y breve: primero teléfono; si no hay, email; si no
  /// hay, nada. Es UN solo dato para respetar la regla "subtítulo corto".
  /// Los campos legacy `supplierType` y `categories` quedaron fuera de la
  /// gobernanza canónica (ProviderProfile + ProviderSpecialty) y ya no
  /// alimentan este fallback.
  String? _secondaryLine() {
    if ((provider.primaryPhoneE164 ?? '').isNotEmpty) {
      return provider.primaryPhoneE164!;
    }
    if ((provider.primaryEmail ?? '').isNotEmpty) return provider.primaryEmail!;
    return null;
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.elementAt(1)[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final secondary = _secondaryLine();
    // Para tiles INCOMPLETOS, el subtítulo principal lleva "Completa su
    // registro" (regla de UX explícita). El dato secundario queda como
    // línea menor debajo solo si hay espacio — para mantener la tarjeta
    // limpia, solo mostramos una línea secundaria.
    final subtitle = !complete
        ? 'Completa su registro'
        : secondary;
    final subtitleColor = !complete
        ? cs.tertiary
        : cs.onSurfaceVariant;
    return ListTile(
      key: Key('providers_directory.tile.${provider.id}'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: cs.primaryContainer,
        child: Text(
          _initials(provider.displayName),
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        provider.displayName,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: subtitleColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing:
          Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY / ERROR STATES
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

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
              Icons.add_business_outlined,
              size: 64,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes proveedores',
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega el primer proveedor de tu workspace. Podrás completar '
              'su perfil con tipo, categorías, ubicación y cobertura.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const Key('providers_directory.empty.create'),
              icon: const Icon(Icons.add_business_outlined),
              label: const Text('Agregar proveedor'),
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFilter extends StatelessWidget {
  final bool wantComplete;
  final VoidCallback onClear;
  const _EmptyFilter({required this.wantComplete, required this.onClear});

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
              wantComplete
                  ? Icons.verified_rounded
                  : Icons.info_outline_rounded,
              size: 48,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              wantComplete
                  ? 'No hay proveedores con perfil completo todavía.'
                  : 'Todos tus proveedores tienen el perfil completo.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onClear,
              child: const Text('Quitar filtro'),
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
              'Sin proveedores para "$query"',
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
              'No se pudo cargar el directorio',
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// lib/presentation/pages/provider/specialties/select_specialties_page.dart
// SELECT SPECIALTIES PAGE — Pantalla "¿Qué ofreces?"
//
// QUÉ HACE:
// - Selector multi-select de specialties para proveedores, consumiendo
//   `GET /v1/catalog/specialties` vía `SelectSpecialtiesController`.
// - Layout:
//     1. Toggle [Productos] [Servicios] (estado inicial: ninguno).
//     2. Banner discreto "X seleccionadas fuera del filtro" cuando aplica.
//     3. Indicador de refetch INLINE (LinearProgressIndicator delgado bajo
//        el toggle) cuando ya hay datos visibles y se está recargando.
//     4. Cuerpo: lista (ListView.builder, tile ~56 dp con hit area completa)
//        / loading inicial / empty diferenciado por filtro / error con retry.
//     5. Botón fijo inferior "Continuar" — habilitado solo si hay selección.
// - Devuelve el resultado al caller via `Get.back<Set<String>>(result: ids)`.
//
// QUÉ NO HACE:
// - NO ordena, deduplica ni filtra en cliente.
// - NO muestra texto libre (sin search, regla del prompt).
// - NO agrupa: la lista del backend ya está en un solo eje.
// - NO persiste la selección: el caller decide qué hacer con los IDs.
// - NO bloquea la lista durante un refetch — solo durante la primera carga.
//
// SCROLL POLICY (CAMBIO 4):
// - El `ScrollController` vive en `_SpecialtiesList` (StatefulWidget).
// - Al cambiar el filtro `selectedKind`, animamos el scroll a 0 (220 ms,
//   easeOut) para que la lista renovada se lea desde el principio.
//   Es la opción "reset explícito y consistente" que preserva la coherencia
//   espacial: dataset distinto → estado de scroll distinto.
// - Refetches que NO cambian el filtro (retry, recargas) NO tocan el
//   scroll: el dataset es el mismo y mover la posición sería intrusivo.
//
// REFINAMIENTOS (2026-04-25):
// - Empty state diferenciado por kind seleccionado (CAMBIO 3).
// - Loading inline durante refetch — full-screen solo en primera carga
//   (CAMBIO 4 — original).
// - Banner "fuera del filtro" + reset animado de scroll (ronda 2).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/catalog/specialty_entity.dart';
import '../../../../domain/services/catalog/specialty_grouping.dart';
import '../../../controllers/provider/specialties/select_specialties_controller.dart';
import 'widgets/specialty_list_tile.dart';

class SelectSpecialtiesPage extends GetView<SelectSpecialtiesController> {
  const SelectSpecialtiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // AppBar dinámico: si el caller pasó `providerName` ("Autokorea"),
    // el usuario ve el contexto del proveedor que está editando. Si no,
    // fallback genérico "Especialidades". `providerName` ya viene
    // trimmed/non-empty desde el binding — aquí solo decidimos qué
    // mostrar.
    final providerName = controller.providerName;
    final appBarTitle = (providerName != null && providerName.isNotEmpty)
        ? providerName
        : 'Especialidades';
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Texto contextual debajo del AppBar.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Selecciona una o más especialidades de este proveedor.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ),

            // El toggle interno fue retirado. El tipo de oferta es
            // single-source-of-truth en el caller (provider bootstrap
            // wizard / provider form), que pasa `initialKind` al binding.
            // Cuando `initialKind == null` (= "Productos y servicios"),
            // la lista se agrupa visualmente en dos secciones (`_SpecialtiesList`).

            // Banner discreto cuando hay selección oculta por el filtro.
            // AnimatedSwitcher para que aparezca/desaparezca sin saltos.
            const _HiddenSelectionBanner(),

            // Indicador inline de refetch (solo cuando ya hay datos visibles).
            // Reserva la altura SIEMPRE para evitar saltos de layout al
            // alternar entre estado quieto y cargando.
            Obx(
              () => SizedBox(
                height: 2,
                child: controller.isRefetching
                    ? const LinearProgressIndicator(minHeight: 2)
                    : const SizedBox.shrink(),
              ),
            ),

            const Divider(height: 1),

            // Cuerpo: lista / loading / empty / error según fase.
            Expanded(
              child: Obx(() {
                switch (controller.phase) {
                  case SelectSpecialtiesPhase.idle:
                  case SelectSpecialtiesPhase.loading:
                    // Full-screen ÚNICAMENTE en la primera carga (sin datos
                    // previos). Refetches con datos visibles entran a la
                    // rama `data` y muestran solo el indicador inline.
                    return const _LoadingView();
                  case SelectSpecialtiesPhase.empty:
                    return _EmptyView(kind: controller.selectedKind);
                  case SelectSpecialtiesPhase.error:
                    return _ErrorView(
                      code: controller.errorCode,
                      message: controller.errorMessage,
                      onRetry: controller.retry,
                    );
                  case SelectSpecialtiesPhase.data:
                    return const _SpecialtiesList();
                }
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _ContinueBar(),
    );
  }
}

// ─── Banner "X seleccionadas fuera del filtro" ─────────────────────────────

class _HiddenSelectionBanner extends GetView<SelectSpecialtiesController> {
  const _HiddenSelectionBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final hidden = controller.hiddenSelectedCount;
      // AnimatedSwitcher con SizeTransition para entrada/salida fluida.
      return AnimatedSize(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        child: hidden == 0
            ? const SizedBox(width: double.infinity)
            : Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _copy(hidden),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  /// Copy en español con concordancia singular/plural.
  static String _copy(int hidden) {
    if (hidden == 1) return '1 seleccionada fuera del filtro';
    return '$hidden seleccionadas fuera del filtro';
  }
}

// ─── Lista con scroll policy ───────────────────────────────────────────────

class _SpecialtiesList extends StatefulWidget {
  const _SpecialtiesList();

  @override
  State<_SpecialtiesList> createState() => _SpecialtiesListState();
}

class _SpecialtiesListState extends State<_SpecialtiesList> {
  late final SelectSpecialtiesController _controller;
  late final ScrollController _scroll;
  Worker? _kindListener;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SelectSpecialtiesController>();
    _scroll = ScrollController();
    // Reset animado al cambiar el filtro (CAMBIO 4 — ronda 2).
    // Usamos `ever` sobre un getter Rx — simple y desacopla la regla de
    // scroll del controller.
    _kindListener = ever<SpecialtyKind?>(
      _controller.selectedKindRx,
      (_) => _animateToTop(),
    );
  }

  @override
  void dispose() {
    _kindListener?.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _animateToTop() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels == 0) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = _controller.specialties;
      // REACTIVIDAD CRÍTICA: `toSet()` itera el RxSet en el closure síncrono
      // del Obx para que GetX registre la suscripción y los toggles
      // disparen rebuild de los tiles.
      final selected = _controller.selectedIds.toSet();
      final offerType = SpecialtyOfferTypeX.fromKind(_controller.selectedKind);
      final grouping = SpecialtyGrouping.group(
        specialties: items,
        offerType: offerType,
      );

      // Construir una lista plana de "renderizables" — tiles e headers —
      // para que un solo ListView.builder maneje scroll + reciclaje. El
      // header de sección es necesario sólo cuando `offerType == both`.
      final rows = <_RowSpec>[];
      switch (grouping) {
        case SpecialtyGroupingFlat(items: final flat):
          for (final s in flat) {
            rows.add(_RowTile(s));
          }
          break;
        case SpecialtyGroupingGrouped(
            products: final products,
            services: final services
          ):
          if (products.isNotEmpty) {
            rows.add(const _RowHeader('Productos'));
            for (final s in products) {
              rows.add(_RowTile(s, sectionTag: 'product'));
            }
          }
          if (services.isNotEmpty) {
            rows.add(const _RowHeader('Servicios'));
            for (final s in services) {
              rows.add(_RowTile(s, sectionTag: 'service'));
            }
          }
          break;
      }

      return ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final row = rows[index];
          if (row is _RowHeader) {
            return _SectionHeader(label: row.label);
          }
          if (row is _RowTile) {
            final s = row.specialty;
            return SpecialtyListTile(
              // Una specialty BOTH aparece en ambas secciones: usamos un
              // ValueKey compuesto para que Flutter no recicle el mismo
              // widget entre secciones (evita glitches de animación al
              // toggle).
              key: ValueKey('${s.id}_${row.sectionTag ?? 'flat'}'),
              specialty: s,
              selected: selected.contains(s.id),
              onTap: () => _controller.toggleSelection(s.id),
            );
          }
          return const SizedBox.shrink();
        },
      );
    });
  }
}

// ─── Items renderizables (header + tile) para el ListView agrupado ────────

sealed class _RowSpec {
  const _RowSpec();
}

class _RowHeader extends _RowSpec {
  final String label;
  const _RowHeader(this.label);
}

class _RowTile extends _RowSpec {
  final Specialty specialty;
  final String? sectionTag;
  const _RowTile(this.specialty, {this.sectionTag});
}

/// Header sticky-ligero para separar las secciones "Productos" y
/// "Servicios" cuando el offerType activo es BOTH. Mantiene la densidad de
/// la lista (no es card pesada) — solo un label resaltado con fondo
/// sutil del theme.
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: double.infinity,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Estados ───────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  /// Filtro vigente — determina el copy del empty state (CAMBIO 3).
  final SpecialtyKind? kind;

  const _EmptyView({required this.kind});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          _copyForKind(kind),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Copy diferenciado por filtro (regla del prompt):
  /// - sin filtro     → "No hay opciones disponibles"
  /// - PRODUCT        → "No hay productos disponibles para este tipo"
  /// - SERVICE        → "No hay servicios disponibles para este tipo"
  /// - BOTH           → mismo que sin filtro (no es alcanzable desde el
  ///   toggle de la UI hoy, pero se preserva el contrato del enum).
  static String _copyForKind(SpecialtyKind? kind) {
    switch (kind) {
      case SpecialtyKind.product:
        return 'No hay productos disponibles para este tipo';
      case SpecialtyKind.service:
        return 'No hay servicios disponibles para este tipo';
      case SpecialtyKind.both:
      case null:
        return 'No hay opciones disponibles';
    }
  }
}

class _ErrorView extends StatelessWidget {
  final String? code;
  final String? message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.code,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final humanMessage = _humanize(code, message);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 36,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              humanMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Mapea `code` canónico del backend a copy en español.
  /// El `message` se preserva como fallback para códigos no mapeados.
  String _humanize(String? code, String? message) {
    switch (code) {
      case 'NETWORK':
        return 'Sin conexión. Revisa tu red e intenta de nuevo.';
      case 'UNAUTHORIZED':
        return 'Tu sesión expiró. Vuelve a iniciar sesión.';
      case 'INVALID_ASSET_TYPE':
        return 'Tipo de activo no válido para este selector.';
      case 'INVALID_SPECIALTY_TYPE':
        return 'Filtro de tipo no válido.';
      case 'SERVER':
        return 'Hubo un problema en el servidor. Intenta más tarde.';
      default:
        return message?.isNotEmpty == true
            ? message!
            : 'Ocurrió un error al cargar las opciones.';
    }
  }
}

// ─── Botón "Continuar" fijo ────────────────────────────────────────────────

class _ContinueBar extends GetView<SelectSpecialtiesController> {
  const _ContinueBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Obx(() {
          final enabled = controller.canContinue;
          final count = controller.selectedIds.length;
          return SizedBox(
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: enabled ? controller.submit : null,
              child: Text(
                enabled && count > 0
                    ? 'Continuar ($count)'
                    : 'Continuar',
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// lib/presentation/pages/portfolio/portfolio_detail_page.dart
// PORTFOLIO DETAIL PAGE — Enterprise Ultra Pro
//
// QUÉ HACE:
// - Muestra el detalle completo de un portafolio existente:
//     • Nombre, tipo, estado, contador de activos, país/ciudad.
// - Permite renombrar el portafolio vía modal bottom sheet.
// - Expone CTAs: "Ver activos", "Registrar nuevo activo".
// - Reactiva: usa Obx para reflejar cambios del controller.
//
// QUÉ NO HACE:
// - No crea portafolios (flujo del wizard).
// - No gestiona activos individuales.
// - No implementa lógica de negocio (delegada al controller).
//
// PRINCIPIOS:
// - StatelessWidget puro; el estado reactivo vive en PortfolioDetailController.
// - Side-effects de UI (modals, snackbars) disparados desde la vista.
// - Widgets 100% presentacionales, sin lógica de negocio inline.
//
// ENTERPRISE NOTES:
// - Si el argumento de navegación es inválido (portfolio == null),
//   muestra pantalla de error con botón de regreso.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../routes/app_pages.dart';
import 'controllers/portfolio_detail_controller.dart';

class PortfolioDetailPage extends StatelessWidget {
  const PortfolioDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioDetailController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final p = controller.portfolio.value;
          return Text(
            p?.portfolioName ?? 'Portafolio',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          );
        }),
        actions: [
          // Botón de editar nombre en AppBar
          Obx(() {
            final p = controller.portfolio.value;
            if (p == null) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.edit_outlined, color: cs.onSurfaceVariant),
              tooltip: 'Editar nombre',
              onPressed: () => _showRenameSheet(context, controller, p),
            );
          }),
        ],
      ),
      body: Obx(() {
        final p = controller.portfolio.value;

        // Argumento inválido: mostrar error con back
        if (p == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: cs.error),
                  const SizedBox(height: 16),
                  Text(
                    'No se pudo cargar el portafolio.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: Get.back,
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          );
        }

        return _PortfolioDetailBody(
          portfolio: p,
          controller: controller,
          onRename: () => _showRenameSheet(context, controller, p),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Modal: Renombrar portafolio
  // ---------------------------------------------------------------------------

  void _showRenameSheet(
    BuildContext context,
    PortfolioDetailController controller,
    PortfolioEntity portfolio,
  ) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textController = TextEditingController(text: portfolio.portfolioName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        // Subir el sheet cuando aparece el teclado
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título
                  Text(
                    'Renombrar portafolio',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'El nombre aparece en tu panel principal.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo de texto
                  TextField(
                    controller: textController,
                    autofocus: true,
                    maxLength: 60,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nombre del portafolio',
                      hintText: 'Ej. Flota de transporte 2024',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                    ),
                    onSubmitted: (v) {
                      Navigator.of(ctx).pop();
                      controller.updatePortfolioName(v);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() => FilledButton(
                              onPressed: controller.isUpdating.value
                                  ? null
                                  : () {
                                      Navigator.of(ctx).pop();
                                      controller.updatePortfolioName(
                                        textController.text,
                                      );
                                    },
                              child: controller.isUpdating.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Guardar'),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Body: Contenido principal del detalle
// ============================================================================

class _PortfolioDetailBody extends StatelessWidget {
  final PortfolioEntity portfolio;
  final PortfolioDetailController controller;
  final VoidCallback onRename;

  const _PortfolioDetailBody({
    required this.portfolio,
    required this.controller,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero card ────────────────────────────────────────────────────
          _HeroCard(portfolio: portfolio, cs: cs, theme: theme),
          const SizedBox(height: 20),

          // ── Estadísticas ─────────────────────────────────────────────────
          _SectionTitle(title: 'Resumen', theme: theme),
          const SizedBox(height: 12),
          _StatsRow(portfolio: portfolio, cs: cs, theme: theme),
          const SizedBox(height: 24),

          // ── Información general ──────────────────────────────────────────
          _SectionTitle(title: 'Información', theme: theme),
          const SizedBox(height: 12),
          _InfoCard(portfolio: portfolio, cs: cs, theme: theme),
          const SizedBox(height: 24),

          // ── Acciones ────────────────────────────────────────────────────
          _SectionTitle(title: 'Acciones', theme: theme),
          const SizedBox(height: 12),

          // Editar nombre
          _ActionTile(
            icon: Icons.edit_outlined,
            title: 'Editar nombre',
            subtitle: 'Cambia el nombre de este portafolio',
            color: cs.primary,
            onTap: onRename,
          ),
          const SizedBox(height: 8),

          // Ver activos del portafolio (filtrado por portfolioId)
          _ActionTile(
            icon: Icons.inventory_2_outlined,
            title: 'Ver activos',
            subtitle: 'Activos registrados en este portafolio',
            color: cs.tertiary,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(Routes.portfolioAssets, arguments: portfolio);
            },
          ),
          const SizedBox(height: 8),

          // Registrar nuevo activo en este portafolio (RUNT → Step2)
          _ActionTile(
            icon: Icons.add_circle_outline_rounded,
            title: 'Registrar nuevo activo',
            subtitle: 'Consulta RUNT y vincula al portafolio',
            color: cs.secondary,
            onTap: () => controller.goToRegisterAsset(),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Subwidgets presentacionales
// ============================================================================

/// Tarjeta hero con ícono, nombre y tipo del portafolio.
class _HeroCard extends StatelessWidget {
  final PortfolioEntity portfolio;
  final ColorScheme cs;
  final ThemeData theme;

  const _HeroCard({
    required this.portfolio,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _typeColor(cs).withValues(alpha: 0.15),
            _typeColor(cs).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _typeColor(cs).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _typeColor(cs).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _typeIcon(),
              color: _typeColor(cs),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  portfolio.portfolioName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _TypeBadge(label: _typeLabel(), color: _typeColor(cs)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _typeIcon() {
    switch (portfolio.portfolioType) {
      case PortfolioType.vehiculos:
        return Icons.directions_car_outlined;
      case PortfolioType.inmuebles:
        return Icons.home_outlined;
      case PortfolioType.operacionGeneral:
        return Icons.work_outline;
    }
  }

  Color _typeColor(ColorScheme cs) {
    switch (portfolio.portfolioType) {
      case PortfolioType.vehiculos:
        return cs.primary;
      case PortfolioType.inmuebles:
        return cs.tertiary;
      case PortfolioType.operacionGeneral:
        return cs.secondary;
    }
  }

  String _typeLabel() {
    switch (portfolio.portfolioType) {
      case PortfolioType.vehiculos:
        return 'Flota vehicular';
      case PortfolioType.inmuebles:
        return 'Bienes inmuebles';
      case PortfolioType.operacionGeneral:
        return 'Operación general';
    }
  }
}

/// Badge de tipo de portafolio.
class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TypeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Fila de estadísticas: activos, estado.
class _StatsRow extends StatelessWidget {
  final PortfolioEntity portfolio;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatsRow({
    required this.portfolio,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            label: 'Activos registrados',
            value: portfolio.assetsCount.toString(),
            icon: Icons.inventory_2_outlined,
            color: cs.primary,
            cs: cs,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            label: 'Estado',
            value: portfolio.status == PortfolioStatus.active
                ? 'Activo'
                : 'Borrador',
            icon: portfolio.status == PortfolioStatus.active
                ? Icons.check_circle_outline
                : Icons.hourglass_empty_outlined,
            color: portfolio.status == PortfolioStatus.active
                ? Colors.green.shade600
                : cs.onSurfaceVariant,
            cs: cs,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

/// Chip individual de estadística.
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ColorScheme cs;
  final ThemeData theme;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de información general (país, ciudad, fechas).
class _InfoCard extends StatelessWidget {
  final PortfolioEntity portfolio;
  final ColorScheme cs;
  final ThemeData theme;

  const _InfoCard({
    required this.portfolio,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.flag_outlined,
            label: 'País',
            value: portfolio.countryId.toUpperCase(),
            cs: cs,
            theme: theme,
          ),
          if (portfolio.cityId.isNotEmpty) ...[
            Divider(height: 20, color: cs.outline.withValues(alpha: 0.1)),
            _InfoRow(
              icon: Icons.location_city_outlined,
              label: 'Ciudad',
              value: portfolio.cityId,
              cs: cs,
              theme: theme,
            ),
          ],
          if (portfolio.createdAt != null) ...[
            Divider(height: 20, color: cs.outline.withValues(alpha: 0.1)),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Creado',
              value: _formatDate(portfolio.createdAt!),
              cs: cs,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }
}

/// Fila de dato informativo (ícono + label + valor).
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Tile de acción tappable (editar, ver activos, registrar).
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Título de sección.
class _SectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionTitle({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}

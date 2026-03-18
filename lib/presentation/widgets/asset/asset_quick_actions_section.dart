// ============================================================================
// lib/presentation/widgets/asset/asset_quick_actions_section.dart
// ASSET QUICK ACTIONS SECTION — Accesos rápidos a módulos del activo
//
// QUÉ HACE:
// - Renderiza un grid 2×4 de acciones rápidas del activo.
// - Cada tile muestra un icono, una etiqueta y un badge "Próximamente".
// - Todas las acciones están deshabilitadas hasta que los módulos estén listos.
//
// QUÉ NO HACE:
// - No navega a ninguna ruta: todos los módulos están pendientes de implementar.
// - No depende de controladores ni repositorios.
//
// PRINCIPIOS:
// - StatelessWidget puro: sin estado ni side-effects.
// - Usa exclusivamente Theme.of(context) para colores y estilos.
// - Grid fijo 2 columnas con aspect ratio 1:1 para densidad visual uniforme.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Placeholder de navegación para los 8 módulos operativos.
// Activar módulo: pasar onTap no-nulo + quitar el badge "Próximamente".
// ============================================================================

import 'package:flutter/material.dart';

/// Acción individual de la grilla.
class _ActionDef {
  final IconData icon;
  final String label;

  const _ActionDef({required this.icon, required this.label});
}

/// Grid 2×4 de accesos rápidos a módulos del activo.
///
/// Todas las acciones están deshabilitadas actualmente.
/// Cuando un módulo esté disponible, pasar [onTap] al tile correspondiente
/// y retirar el badge "Próximamente".
class AssetQuickActionsSection extends StatelessWidget {
  const AssetQuickActionsSection({super.key});

  static const _actions = [
    _ActionDef(icon: Icons.build_outlined,        label: 'Mantenimientos'),
    _ActionDef(icon: Icons.description_outlined,  label: 'Documentos'),
    _ActionDef(icon: Icons.warning_amber_outlined, label: 'Incidencias'),
    _ActionDef(icon: Icons.shield_outlined,       label: 'Seguros'),
    _ActionDef(icon: Icons.account_balance_outlined, label: 'Contabilidad'),
    _ActionDef(icon: Icons.person_outlined,       label: 'Conductor'),
    _ActionDef(icon: Icons.location_on_outlined,  label: 'GPS / Ubicación'),
    _ActionDef(icon: Icons.attach_money_rounded,  label: 'Costos'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Título de sección ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Módulos del activo',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.4,
              ),
            ),
          ),

          // ── Grid 2 columnas ───────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: _actions.length,
            itemBuilder: (_, i) => _ActionTile(def: _actions[i], cs: cs, theme: theme),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION TILE
// ─────────────────────────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final _ActionDef def;
  final ColorScheme cs;
  final ThemeData theme;

  const _ActionTile({
    required this.def,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // Deshabilitado visualmente hasta que el módulo esté disponible.
      opacity: 0.55,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
        ),
        child: Stack(
          children: [
            // ── Contenido principal ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(def.icon, color: cs.primary, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    def.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Badge "Próximamente" ────────────────────────────────────────
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Próximo',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

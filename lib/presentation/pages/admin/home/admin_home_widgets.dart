// lib/presentation/pages/admin/home/admin_home_widgets.dart
// ============================================================================
// AdminHome Widgets — UI Governance v1.0.5 (Production)
// ============================================================================
// Widgets 100% presentacionales. Sin GetX, sin navegación, sin lógica.
// Theme-first: usa ColorScheme/TextTheme para dark mode y consistencia M3.
// ============================================================================

import 'package:flutter/material.dart';

// ============================================================================
// DESIGN SYSTEM (solo gradiente brand y colores semánticos de red operativa)
// ============================================================================

abstract final class AdminHomeDS {
  // Gradiente principal (brand)
  static const Color accentStart = Color(0xFF4F5CFF);
  static const Color accentEnd = Color(0xFF8E54E9);

  // Red operativa (colores semánticos específicos del dominio)
  static const Color networkOwners = Color(0xFF2563EB);
  static const Color networkTenants = Color(0xFF059669);
  static const Color networkContacts = Color(0xFFF59E0B);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [accentStart, accentEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ============================================================================
// SECTION TITLE
// ============================================================================

class AdminSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const AdminSectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Fallback robusto: respeta tamaño del theme, solo fuerza weight
    final baseStyle = theme.textTheme.titleMedium ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w800);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: baseStyle.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ============================================================================
// NOTIFICATION BADGE
// ============================================================================

class AdminNotificationBadge extends StatelessWidget {
  final int count;
  final bool announceChanges;

  const AdminNotificationBadge({
    super.key,
    required this.count,
    this.announceChanges = false,
  });

  @override
  Widget build(BuildContext context) {
    // No mostrar badge si count <= 0
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;

    return Semantics(
      label: '$count notificaciones pendientes',
      liveRegion: announceChanges,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: cs.errorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$count Pendientes",
          style: TextStyle(
            color: cs.onErrorContainer,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HEADER SECTION
// ============================================================================

class AdminHeaderSection extends StatelessWidget {
  final String greeting;
  final String shortDate;
  final String userName;
  final String activeWorkspace;
  final bool hasMultipleWorkspaces;
  final VoidCallback? onWorkspaceTap;

  const AdminHeaderSection({
    super.key,
    required this.greeting,
    required this.shortDate,
    required this.userName,
    required this.activeWorkspace,
    required this.hasMultipleWorkspaces,
    this.onWorkspaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: Saludo + Fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                greeting,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface,
                ),
              ),
              Text(
                shortDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Fila 2: Nombre + Workspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  userName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _WorkspaceChip(
                label: activeWorkspace,
                showChevron: hasMultipleWorkspaces,
                onTap: hasMultipleWorkspaces ? onWorkspaceTap : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chip privado para selección de workspace
class _WorkspaceChip extends StatelessWidget {
  final String label;
  final bool showChevron;
  final VoidCallback? onTap;

  const _WorkspaceChip({
    required this.label,
    required this.showChevron,
    this.onTap,
  });

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      label:
          'Espacio de trabajo: $label${showChevron ? ', toca para cambiar' : ''}',
      button: _isEnabled,
      enabled: _isEnabled,
      child: Opacity(
        opacity: _isEnabled ? 1.0 : 0.5,
        child: Material(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: _isEnabled ? null : Colors.transparent,
            highlightColor: _isEnabled ? null : Colors.transparent,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (showChevron) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
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
// QUICK ACTIONS ROW
// ============================================================================

class AdminQuickActionsRow extends StatelessWidget {
  final VoidCallback? onGpsTap;
  final VoidCallback? onPublicarTap;
  final VoidCallback? onSolicitudesTap;
  final VoidCallback? onEmergenciasTap;

  const AdminQuickActionsRow({
    super.key,
    this.onGpsTap,
    this.onPublicarTap,
    this.onSolicitudesTap,
    this.onEmergenciasTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: AdminQuickActionBtn(
            icon: Icons.map_outlined,
            label: "GPS",
            semanticLabel: "GPS, control operativo",
            iconColor: cs.primary,
            onTap: onGpsTap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminQuickActionBtn(
            icon: Icons.campaign_outlined,
            label: "Publicar",
            semanticLabel: "Publicar activos disponibles",
            iconColor: cs.tertiary,
            onTap: onPublicarTap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminQuickActionBtn(
            icon: Icons.assignment_turned_in_outlined,
            label: "Solicitudes",
            semanticLabel: "Ver y gestionar solicitudes",
            iconColor: cs.secondary,
            onTap: onSolicitudesTap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminQuickActionBtn(
            icon: Icons.sos,
            label: "Emergencias",
            semanticLabel: "Emergencias, acción crítica",
            iconColor: cs.error,
            isEmergency: true,
            onTap: onEmergenciasTap,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// QUICK ACTION BUTTON
// ============================================================================

class AdminQuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? semanticLabel;
  final Color iconColor;
  final bool isEmergency;
  final VoidCallback? onTap;

  const AdminQuickActionBtn({
    super.key,
    required this.icon,
    required this.label,
    this.semanticLabel,
    required this.iconColor,
    this.isEmergency = false,
    this.onTap,
  });

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      label: semanticLabel ?? label,
      button: _isEnabled,
      enabled: _isEnabled,
      child: Tooltip(
        message: semanticLabel ?? label,
        child: Opacity(
          opacity: _isEnabled ? 1.0 : 0.45,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              splashColor: _isEnabled ? null : Colors.transparent,
              highlightColor: _isEnabled ? null : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Material(
                          color: isEmergency
                              ? cs.errorContainer
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                          elevation: 1,
                          shadowColor: cs.shadow,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isEmergency
                                    ? cs.error.withValues(alpha: 0.3)
                                    : cs.outlineVariant,
                                width: 1,
                              ),
                            ),
                            child: Icon(icon, size: 28, color: iconColor),
                          ),
                        ),
                        if (isEmergency)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: cs.error,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cs.surface,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ASSET CATEGORY CARD
// ============================================================================

class AdminAssetCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final IconData? trendIcon;
  final Color? trendColor;
  final VoidCallback? onTap;

  const AdminAssetCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendIcon,
    this.trendColor,
    this.onTap,
  });

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final effectiveTrendColor = trendColor ?? cs.primary;

    return Semantics(
      label:
          '$title, $subtitle, valor: $value${trend != null ? ', tendencia: $trend' : ''}',
      button: _isEnabled,
      enabled: _isEnabled,
      child: Tooltip(
        message: title,
        child: Opacity(
          opacity: _isEnabled ? 1.0 : 0.5,
          child: Material(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            elevation: 1,
            shadowColor: cs.shadow,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: _isEnabled ? null : Colors.transparent,
              highlightColor: _isEnabled ? null : Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (trend != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (trendIcon != null)
                                Icon(trendIcon,
                                    size: 14, color: effectiveTrendColor),
                              if (trendIcon != null) const SizedBox(width: 2),
                              Text(
                                trend!,
                                style: TextStyle(
                                  color: effectiveTrendColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// OPERATIONAL NETWORK CARD
// ============================================================================

class AdminOperationalNetworkCard extends StatelessWidget {
  final IconData icon;
  final Color borderColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AdminOperationalNetworkCard({
    super.key,
    required this.icon,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      label: '$title, $subtitle',
      button: _isEnabled,
      enabled: _isEnabled,
      child: Tooltip(
        message: title,
        child: Opacity(
          opacity: _isEnabled ? 1.0 : 0.5,
          child: Material(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            elevation: 1,
            shadowColor: cs.shadow,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: _isEnabled ? null : Colors.transparent,
              highlightColor: _isEnabled ? null : Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: borderColor, size: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PERSONAS DASHBOARD
// ============================================================================

class AdminPersonasDashboard extends StatelessWidget {
  final VoidCallback? onPropietariosTap;
  final VoidCallback? onArrendatariosTap;
  final VoidCallback? onDirectorioTap;

  const AdminPersonasDashboard({
    super.key,
    this.onPropietariosTap,
    this.onArrendatariosTap,
    this.onDirectorioTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminOperationalNetworkCard(
            icon: Icons.person_outline_rounded,
            borderColor: AdminHomeDS.networkOwners,
            title: 'Propietarios',
            subtitle: '12 registrados',
            onTap: onPropietariosTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AdminOperationalNetworkCard(
            icon: Icons.home_outlined,
            borderColor: AdminHomeDS.networkTenants,
            title: 'Arrendatarios',
            subtitle: '8 activos',
            onTap: onArrendatariosTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AdminOperationalNetworkCard(
            icon: Icons.contacts_outlined,
            borderColor: AdminHomeDS.networkContacts,
            title: 'Directorio',
            subtitle: '24 contactos',
            onTap: onDirectorioTap,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// OPERATIONAL STATUS CARD (Estado operativo)
// ============================================================================

/// Variantes visuales para la tarjeta de estado operativo
enum AdminStatusCardVariant {
  /// Hay alertas pendientes (rojo/error)
  alert,

  /// Estado neutral/informativo (gris)
  neutral,

  /// Todo está OK (verde/primary)
  ok,
}

/// Tarjeta de "Estado operativo" — 100% presentacional, Theme-first.
/// Soporta variantes: alert, neutral, ok. La vista decide cuál usar.
class AdminOperationalStatusCard extends StatelessWidget {
  final int pendingCount;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final AdminStatusCardVariant variant;

  const AdminOperationalStatusCard({
    super.key,
    required this.pendingCount,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.variant = AdminStatusCardVariant.alert,
  });

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Colores según variante (Theme-first)
    final (borderColor, containerColor, iconColor, icon) = switch (variant) {
      AdminStatusCardVariant.alert => (
          cs.error.withValues(alpha: 0.3),
          cs.errorContainer,
          cs.error,
          Icons.warning_amber_rounded,
        ),
      AdminStatusCardVariant.neutral => (
          cs.outline.withValues(alpha: 0.3),
          cs.surfaceContainerHighest,
          cs.onSurfaceVariant,
          Icons.info_outline_rounded,
        ),
      AdminStatusCardVariant.ok => (
          cs.primary.withValues(alpha: 0.3),
          cs.primaryContainer,
          cs.primary,
          Icons.check_circle_rounded,
        ),
    };

    // Semantics label según estado
    final semanticsLabel = _isEnabled
        ? 'Estado operativo: $title, $subtitle. $pendingCount pendientes. Toca para ver.'
        : 'Estado operativo: $title, $subtitle.';

    return Semantics(
      label: semanticsLabel,
      button: _isEnabled,
      enabled: _isEnabled,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        elevation: _isEnabled ? 2 : 1,
        shadowColor: cs.shadow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: _isEnabled ? null : Colors.transparent,
          highlightColor: _isEnabled ? null : Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                // Icono según variante
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Indicador de estado (solo si hay alertas)
                          if (variant == AdminStatusCardVariant.alert) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: iconColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Badge + Chevron (solo si interactivo)
                if (_isEnabled) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Badge de pendientes (solo si > 0)
                      if (pendingCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$pendingCount',
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (pendingCount > 0) const SizedBox(height: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: cs.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE ACTION SHEET CONTENT
// ============================================================================

/// Contenido de bottom sheet para estados vacíos — 100% presentacional.
/// Muestra icono + título + subtítulo + 2 CTAs (primario y secundario).
/// Incluye botón X para cerrar (UX obligatoria).
class AdminEmptyStateActionSheetContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String primaryCta;
  final String secondaryCta;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final VoidCallback? onClose;
  final IconData icon;

  const AdminEmptyStateActionSheetContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryCta,
    required this.secondaryCta,
    required this.onPrimary,
    required this.onSecondary,
    this.onClose,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // onClose usa callback explícito o fallback a onSecondary
    final closeAction = onClose ?? onSecondary;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Handle + Botón X
              Stack(
                alignment: Alignment.center,
                children: [
                  // Handle centrado
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Botón X a la derecha
                  Positioned(
                    right: -8,
                    child: Semantics(
                      label: 'Cerrar',
                      button: true,
                      child: Tooltip(
                        message: 'Cerrar',
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: cs.onSurfaceVariant,
                            size: 24,
                          ),
                          onPressed: closeAction,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Icono grande
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Título
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Subtítulo
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // CTAs
              Row(
                children: [
                  // Botón secundario
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondary,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(secondaryCta),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botón primario
                  Expanded(
                    child: FilledButton(
                      onPressed: onPrimary,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(primaryCta),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PREMIUM FAB
// ============================================================================

class AdminPremiumFAB extends StatelessWidget {
  final VoidCallback? onTap;

  const AdminPremiumFAB({super.key, this.onTap});

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Crear nuevo elemento',
      button: _isEnabled,
      enabled: _isEnabled,
      child: Tooltip(
        message: 'Nuevo',
        child: Opacity(
          opacity: _isEnabled ? 1.0 : 0.5,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            elevation: 4,
            shadowColor: cs.shadow,
            child: Ink(
              decoration: BoxDecoration(
                gradient: AdminHomeDS.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(30),
                splashColor: _isEnabled ? null : Colors.transparent,
                highlightColor: _isEnabled ? null : Colors.transparent,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: cs.onPrimary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Nuevo',
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

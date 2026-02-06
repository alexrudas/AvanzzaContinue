// ============================================================================
// lib/presentation/pages/admin/home/ai_alerts_page.dart
// ============================================================================
//
// PÁGINA DEDICADA: Alertas IA con filtros single-select
//
// MODELO MENTAL:
//   - DOS MODOS EXCLUYENTES: "Por Prioridad" (default) | "Por Tipo"
//   - Solo se muestra un conjunto de chips secundarios a la vez
//   - Chips secundarios = single-select
//   - Chips solo se muestran si EXISTEN alertas para esa categoría
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:avanzza/presentation/widgets/ai_banner/ai_banner.dart';

enum _FilterMode { byPriority, byType }

/// Página de Alertas IA con filtros
class AiAlertsPage extends StatefulWidget {
  final List<AIBannerMessage> messages;

  const AiAlertsPage({
    super.key,
    required this.messages,
  });

  @override
  State<AiAlertsPage> createState() => _AiAlertsPageState();
}

class _AiAlertsPageState extends State<AiAlertsPage> {
  // Modo activo (Por Prioridad = default)
  _FilterMode _mode = _FilterMode.byPriority;

  // Filtro de prioridad (null = "Todas")
  AIAlertPriority? _selectedPriority;

  // Filtro de tipo
  AIAlertDomain? _selectedDomain;

  @override
  void initState() {
    super.initState();
    _initializeDefaultSelection();
  }

  /// Inicializa la selección por defecto según data disponible
  void _initializeDefaultSelection() {
    if (widget.messages.isEmpty) return;

    // Modo Por Prioridad: seleccionar "Todas" (null)
    _selectedPriority = null;

    // Modo Por Tipo: seleccionar el tipo con prioridad más alta
    _selectedDomain = _getHighestPriorityDomain();
  }

  /// Obtiene el dominio con la prioridad más alta
  AIAlertDomain? _getHighestPriorityDomain() {
    if (widget.messages.isEmpty) return null;

    // Agrupar por dominio y encontrar la prioridad más alta de cada uno
    final domainPriorities = <AIAlertDomain, int>{};

    for (final msg in widget.messages) {
      final currentMax = domainPriorities[msg.domain] ?? 999;
      final newPriority = msg.priority.index;
      if (newPriority < currentMax) {
        domainPriorities[msg.domain] = newPriority;
      }
    }

    if (domainPriorities.isEmpty) return null;

    // Ordenar por prioridad más alta (índice más bajo)
    final sorted = domainPriorities.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted.first.key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Filtrar mensajes según modo activo
    final filteredMessages = _filterMessages();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Alertas IA',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: cs.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      body: widget.messages.isEmpty
          ? _buildEmptyState(theme, cs)
          : Column(
              children: [
                // Chips principales (nivel 1)
                _buildMainModeChips(theme, cs),

                // Chips secundarios (nivel 2)
                _buildSecondaryChips(theme, cs),

                // Lista de alertas
                Expanded(
                  child: filteredMessages.isEmpty
                      ? _buildEmptyState(theme, cs)
                      : _buildAlertsList(theme, cs, filteredMessages),
                ),
              ],
            ),
    );
  }

  /// Chips principales: Por Prioridad | Por Tipo
  Widget _buildMainModeChips(ThemeData theme, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(
            color: cs.outline.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildMainChip(
            theme,
            cs,
            _FilterMode.byPriority,
            'Por Prioridad',
            Icons.priority_high_rounded,
          ),
          const SizedBox(width: 12),
          _buildMainChip(
            theme,
            cs,
            _FilterMode.byType,
            'Por Tipo',
            Icons.category_rounded,
          ),
        ],
      ),
    );
  }

  /// Chip principal individual
  Widget _buildMainChip(
    ThemeData theme,
    ColorScheme cs,
    _FilterMode mode,
    String label,
    IconData icon,
  ) {
    final isSelected = _mode == mode;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_mode == mode) return; // Ya está seleccionado
            HapticFeedback.mediumImpact();
            setState(() {
              _mode = mode;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Chips secundarios según modo activo
  Widget _buildSecondaryChips(ThemeData theme, ColorScheme cs) {
    return _mode == _FilterMode.byPriority
        ? _buildPriorityChips(theme, cs)
        : _buildTypeChips(theme, cs);
  }

  /// Chips de Prioridad (Modo 1)
  Widget _buildPriorityChips(ThemeData theme, ColorScheme cs) {
    // Obtener prioridades que tienen alertas
    final availablePriorities = _getAvailablePriorities();

    if (availablePriorities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // "Todas" siempre se muestra si hay alertas
            _buildPriorityChip(theme, cs, null, 'Todas', widget.messages.length),
            ...availablePriorities.map((priority) {
              final count = widget.messages.where((m) => m.priority == priority).length;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildPriorityChip(
                  theme,
                  cs,
                  priority,
                  _getPriorityLabel(priority).toUpperCase(),
                  count,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Chips de Tipo (Modo 2) - Ordenados por prioridad interna
  Widget _buildTypeChips(ThemeData theme, ColorScheme cs) {
    // Obtener tipos ordenados por prioridad interna más alta
    final availableTypes = _getAvailableTypesSortedByPriority();

    if (availableTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: availableTypes.map((domain) {
          final count = widget.messages.where((m) => m.domain == domain).length;
          return _buildTypeChip(theme, cs, domain, count);
        }).toList(),
      ),
    );
  }

  /// Chip de prioridad individual
  Widget _buildPriorityChip(
    ThemeData theme,
    ColorScheme cs,
    AIAlertPriority? priority,
    String label,
    int count,
  ) {
    final isSelected = _selectedPriority == priority;
    final color = _getPriorityColor(cs, priority);

    return FilterChip(
      selected: isSelected,
      label: Text('$label ($count)'),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: isSelected ? Colors.white : cs.onSurface,
        letterSpacing: 0.3,
      ),
      backgroundColor: cs.surfaceContainerHigh,
      selectedColor: color,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? color : cs.outline.withValues(alpha: 0.25),
        width: isSelected ? 1.5 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onSelected: (selected) {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedPriority = selected ? priority : null;
        });
      },
    );
  }

  /// Chip de tipo individual (color neutro, sin semáforo)
  Widget _buildTypeChip(
    ThemeData theme,
    ColorScheme cs,
    AIAlertDomain domain,
    int count,
  ) {
    final isSelected = _selectedDomain == domain;

    return FilterChip(
      selected: isSelected,
      label: Text('${_getDomainLabel(domain)} ($count)'),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: isSelected ? cs.onPrimary : cs.onSurface,
      ),
      backgroundColor: cs.surfaceContainerHigh,
      selectedColor: cs.primary,
      checkmarkColor: cs.onPrimary,
      side: BorderSide(
        color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.25),
        width: isSelected ? 1.5 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onSelected: (selected) {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedDomain = selected ? domain : null;
        });
      },
    );
  }

  /// Construye la lista de alertas (agrupada o plana según selección)
  Widget _buildAlertsList(
    ThemeData theme,
    ColorScheme cs,
    List<AIBannerMessage> messages,
  ) {
    // AJUSTE 1: Si estamos en modo "Por Prioridad" y "Todas" está seleccionado,
    // mostrar alertas agrupadas por bloques de prioridad
    if (_mode == _FilterMode.byPriority && _selectedPriority == null) {
      return _buildGroupedByPriorityList(theme, cs, messages);
    }

    // En cualquier otro caso, mostrar lista plana
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: cs.outline.withValues(alpha: 0.08),
      ),
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _buildAlertItem(theme, cs, msg);
      },
    );
  }

  /// Construye lista agrupada por bloques de prioridad
  Widget _buildGroupedByPriorityList(
    ThemeData theme,
    ColorScheme cs,
    List<AIBannerMessage> messages,
  ) {
    // Agrupar mensajes por prioridad
    final groups = <AIAlertPriority, List<AIBannerMessage>>{};
    for (final msg in messages) {
      groups.putIfAbsent(msg.priority, () => []).add(msg);
    }

    // Orden fijo: CRÍTICAS → ALTAS → MEDIAS → OPORTUNIDADES
    final orderedPriorities = [
      AIAlertPriority.critica,
      AIAlertPriority.alta,
      AIAlertPriority.media,
      AIAlertPriority.oportunidad,
    ].where((p) => groups.containsKey(p)).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: orderedPriorities.length,
      itemBuilder: (context, index) {
        final priority = orderedPriorities[index];
        final priorityMessages = groups[priority]!;
        final isLast = index == orderedPriorities.length - 1;

        return _buildPriorityBlock(
          theme,
          cs,
          priority,
          priorityMessages,
          isLast,
        );
      },
    );
  }

  /// Construye un bloque de prioridad con header y alertas
  Widget _buildPriorityBlock(
    ThemeData theme,
    ColorScheme cs,
    AIAlertPriority priority,
    List<AIBannerMessage> messages,
    bool isLast,
  ) {
    final priorityColor = _getPriorityColor(cs, priority);
    final priorityLabel = _getPriorityLabel(priority);

    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: isLast ? 8 : 16,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del bloque
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    priorityLabel.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${messages.length} ${messages.length == 1 ? 'alerta' : 'alertas'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Lista de alertas del bloque
          ...messages.asMap().entries.map((entry) {
            final index = entry.key;
            final msg = entry.value;
            final isLastInBlock = index == messages.length - 1;

            return Column(
              children: [
                _buildAlertItem(theme, cs, msg),
                if (!isLastInBlock)
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: cs.outline.withValues(alpha: 0.08),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Construye un item de alerta
  Widget _buildAlertItem(
    ThemeData theme,
    ColorScheme cs,
    AIBannerMessage message,
  ) {
    final colors = _typeColors(message.type, cs);

    return Material(
      color: cs.surface,
      child: InkWell(
        onTap: () => _showAlertDetail(context, message),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icono
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.fg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  message.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge de prioridad
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(cs, message.priority).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _getPriorityColor(cs, message.priority).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getPriorityLabel(message.priority).toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: _getPriorityColor(cs, message.priority),
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (message.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        message.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
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

  /// Estado vacío
  Widget _buildEmptyState(ThemeData theme, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin alertas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay alertas para mostrar',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el detalle de una alerta en modal
  void _showAlertDetail(BuildContext context, AIBannerMessage message) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = _typeColors(message.type, cs);

    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colors.fg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          message.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getPriorityLabel(message.priority).toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.fg,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getDomainLabel(message.domain),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),

                // Contenido
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        if (message.subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            message.subtitle!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Placeholder: Información adicional
                        _buildDetailRow(
                          theme,
                          cs,
                          Icons.calendar_today_rounded,
                          'Fecha',
                          'Pendiente',
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          theme,
                          cs,
                          Icons.business_rounded,
                          'Activo afectado',
                          'Pendiente',
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          theme,
                          cs,
                          Icons.access_time_rounded,
                          'Vigencia',
                          'Pendiente',
                        ),
                      ],
                    ),
                  ),
                ),

                // CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: Acción contextual
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.fg,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Ver detalles',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    ColorScheme cs,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // HELPERS - FILTRADO Y AGRUPACIÓN
  // ============================================================================

  /// Filtra mensajes según modo activo
  List<AIBannerMessage> _filterMessages() {
    var filtered = widget.messages;

    if (_mode == _FilterMode.byPriority) {
      // Filtro por prioridad
      if (_selectedPriority != null) {
        filtered = filtered.where((msg) => msg.priority == _selectedPriority).toList();
      }
      // Ordenar por prioridad
      filtered.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    } else {
      // Filtro por tipo
      if (_selectedDomain != null) {
        filtered = filtered.where((msg) => msg.domain == _selectedDomain).toList();
      }
      // Ordenar internamente por prioridad
      filtered.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }

    return filtered;
  }

  /// Obtiene las prioridades que tienen alertas
  List<AIAlertPriority> _getAvailablePriorities() {
    final priorities = <AIAlertPriority>{};
    for (final msg in widget.messages) {
      priorities.add(msg.priority);
    }

    // Ordenar por índice (Crítica primero)
    final sorted = priorities.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return sorted;
  }

  /// Obtiene los tipos ordenados por prioridad interna más alta
  List<AIAlertDomain> _getAvailableTypesSortedByPriority() {
    // Agrupar por dominio y encontrar la prioridad más alta de cada uno
    final domainPriorities = <AIAlertDomain, int>{};

    for (final msg in widget.messages) {
      final currentMax = domainPriorities[msg.domain] ?? 999;
      final newPriority = msg.priority.index;
      if (newPriority < currentMax) {
        domainPriorities[msg.domain] = newPriority;
      }
    }

    // Ordenar por prioridad más alta (índice más bajo)
    final sorted = domainPriorities.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted.map((e) => e.key).toList();
  }


  // ============================================================================
  // HELPERS - LABELS Y COLORES
  // ============================================================================

  /// Color por prioridad
  Color _getPriorityColor(ColorScheme cs, AIAlertPriority? priority) {
    if (priority == null) return cs.primary;

    return switch (priority) {
      AIAlertPriority.critica => const Color(0xFFEF4444),
      AIAlertPriority.alta => const Color(0xFFF59E0B),
      AIAlertPriority.media => const Color(0xFF3B82F6),
      AIAlertPriority.oportunidad => const Color(0xFF10B981),
    };
  }

  /// Label por prioridad
  String _getPriorityLabel(AIAlertPriority priority) {
    return switch (priority) {
      AIAlertPriority.critica => 'Crítica',
      AIAlertPriority.alta => 'Alta',
      AIAlertPriority.media => 'Media',
      AIAlertPriority.oportunidad => 'Oportunidad',
    };
  }

  /// Label por dominio
  String _getDomainLabel(AIAlertDomain domain) {
    return switch (domain) {
      AIAlertDomain.documentos => 'Documentos',
      AIAlertDomain.financiero => 'Financiero',
      AIAlertDomain.operativo => 'Operativo',
      AIAlertDomain.comercial => 'Comercial',
      AIAlertDomain.multas => 'Multas',
      AIAlertDomain.legal => 'Legal',
    };
  }

  /// Colores por tipo (reutiliza lógica de ai_banner.dart)
  _AITypeColors _typeColors(AIMessageType type, ColorScheme cs) {
    return switch (type) {
      AIMessageType.success => const _AITypeColors(Color(0xFFD1FAE5), Color(0xFF10B981)),
      AIMessageType.warning => const _AITypeColors(Color(0xFFFEF3C7), Color(0xFFF59E0B)),
      AIMessageType.critical => const _AITypeColors(Color(0xFFFEE2E2), Color(0xFFEF4444)),
      AIMessageType.info => _AITypeColors(cs.primaryContainer.withValues(alpha: 0.35), cs.primary),
    };
  }
}

/// Paleta semántica (duplicada de ai_banner.dart para evitar exposición)
class _AITypeColors {
  final Color bg;
  final Color fg;
  const _AITypeColors(this.bg, this.fg);
}

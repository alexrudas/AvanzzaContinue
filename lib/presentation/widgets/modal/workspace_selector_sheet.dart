// lib/presentation/widgets/modal/workspace_selector_sheet.dart
// Selector de workspace para eliminar, basado en action_sheet_pro.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Item de workspace seleccionable
class WorkspaceSelectItem {
  final String label;
  final String? subtitle;
  final IconData icon;
  final bool isActive;

  const WorkspaceSelectItem({
    required this.label,
    this.subtitle,
    required this.icon,
    this.isActive = false,
  });
}

/// Selector de workspace
class WorkspaceSelectorSheet {
  static Future<WorkspaceSelectItem?> show(
    BuildContext context, {
    required String title,
    required List<WorkspaceSelectItem> workspaces,
  }) async {
    if (workspaces.isEmpty) return null;

    HapticFeedback.selectionClick();

    final result = await showModalBottomSheet<WorkspaceSelectItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      elevation: 0,
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        final maxWidth = mq.size.width > 520 ? 520.0 : double.infinity;
        final bottomGap = mq.padding.bottom + 24;

        return Stack(
          children: [
            // Backdrop dismissible
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ),

            // Sheet content
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, bottomGap + 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: _WorkspaceSelectorContent(
                        title: title,
                        workspaces: workspaces,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return result;
  }
}

/// Contenido del selector
class _WorkspaceSelectorContent extends StatelessWidget {
  final String title;
  final List<WorkspaceSelectItem> workspaces;

  const _WorkspaceSelectorContent({
    required this.title,
    required this.workspaces,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = Colors.white.withValues(alpha: 0.94);
    final border = Colors.black.withValues(alpha: 0.1);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.13),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Lista de workspaces
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: workspaces.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 56,
                ),
                itemBuilder: (ctx, index) {
                  final workspace = workspaces[index];
                  return _WorkspaceSelectTile(
                    workspace: workspace,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(ctx).pop(workspace);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile individual de workspace
class _WorkspaceSelectTile extends StatelessWidget {
  final WorkspaceSelectItem workspace;
  final VoidCallback onTap;

  const _WorkspaceSelectTile({
    required this.workspace,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Icon(
              workspace.icon,
              color: workspace.isActive
                  ? theme.colorScheme.primary
                  : theme.hintColor,
              size: 24,
            ),
            const SizedBox(width: 16),

            // Label y subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          workspace.label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (workspace.isActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Activo',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (workspace.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      workspace.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: theme.hintColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
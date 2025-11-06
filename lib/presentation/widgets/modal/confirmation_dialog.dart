// lib/presentation/widgets/modal/confirmation_dialog.dart
// Diálogo de confirmación basado en action_sheet_pro.dart
// Mantiene el estilo visual glass/blur pero simplificado para confirmaciones

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Resultado de la confirmación
enum ConfirmationResult { confirmed, cancelled }

/// Configuración del diálogo de confirmación
class ConfirmationDialogConfig {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final IconData? icon;

  const ConfirmationDialogConfig({
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.isDestructive = false,
    this.icon,
  });
}

/// API para mostrar el diálogo de confirmación
class ConfirmationDialog {
  static Future<ConfirmationResult> show(
    BuildContext context,
    ConfirmationDialogConfig config,
  ) async {
    HapticFeedback.selectionClick();

    final result = await showModalBottomSheet<ConfirmationResult>(
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
                onTap: () => Navigator.of(ctx).pop(ConfirmationResult.cancelled),
              ),
            ),

            // Dialog content
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
                      child: _ConfirmationContent(config: config),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? ConfirmationResult.cancelled;
  }
}

/// Contenido del diálogo
class _ConfirmationContent extends StatelessWidget {
  final ConfirmationDialogConfig config;

  const _ConfirmationContent({required this.config});

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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 20),

            // Icon (opcional)
            if (config.icon != null) ...[
              Icon(
                config.icon,
                size: 48,
                color: config.isDestructive
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
            ],

            // Title
            Text(
              config.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              config.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop(ConfirmationResult.cancelled);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(config.cancelText),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm button
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop(ConfirmationResult.confirmed);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: config.isDestructive
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      foregroundColor: config.isDestructive
                          ? theme.colorScheme.onError
                          : theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(config.confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
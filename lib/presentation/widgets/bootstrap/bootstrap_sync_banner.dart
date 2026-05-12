// ============================================================================
// lib/presentation/widgets/bootstrap/bootstrap_sync_banner.dart
// BOOTSTRAP SYNC BANNER — UI no bloqueante del sync de fondo.
//
// QUÉ HACE:
//   Reactivamente observa `BootstrapSyncController.status` y renderiza:
//     · pendingSync / syncing → "Preparando tu cuenta…" con spinner.
//     · failed                → "Error al completar configuración"
//                                + botón "Reintentar".
//     · synced / idle         → SizedBox.shrink (oculto).
//
//   Diseñado para insertar como child directo del `body` del Scaffold del
//   workspace (no en AppBar, para no comer altura cuando está oculto).
//
// QUÉ NO HACE:
//   - NO maneja sus propios timers ni retries: delega al controller.
//   - NO bloquea interacción con el resto del shell.
//   - NO se persiste — es UI puro reactivo.
//
// USO:
//   Column(children: [
//     const BootstrapSyncBanner(),
//     Expanded(child: ...mi contenido...),
//   ])
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bootstrap/bootstrap_sync_controller.dart';

class BootstrapSyncBanner extends StatefulWidget {
  const BootstrapSyncBanner({super.key});

  @override
  State<BootstrapSyncBanner> createState() => _BootstrapSyncBannerState();
}

class _BootstrapSyncBannerState extends State<BootstrapSyncBanner> {
  @override
  void initState() {
    super.initState();
    // Cumple con la regla §5 "onWorkspaceEnter → si retryable, retry()".
    // Diferido al post-frame para no chocar con el rebuild inicial del shell.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Get.isRegistered<BootstrapSyncController>()) {
        Get.find<BootstrapSyncController>().kickIfRetryable();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<BootstrapSyncController>()) {
      return const SizedBox.shrink();
    }
    final ctrl = Get.find<BootstrapSyncController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final s = ctrl.status.value;
      switch (s) {
        case BootstrapSyncStatus.idle:
        case BootstrapSyncStatus.synced:
          return const SizedBox.shrink();

        case BootstrapSyncStatus.pendingSync:
        case BootstrapSyncStatus.syncing:
          return _BannerShell(
            color: cs.primaryContainer.withValues(alpha: 0.55),
            border: cs.primary.withValues(alpha: 0.35),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Preparando tu cuenta…',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );

        case BootstrapSyncStatus.failed:
          return _BannerShell(
            color: cs.errorContainer.withValues(alpha: 0.55),
            border: cs.error.withValues(alpha: 0.5),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 18, color: cs.error),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error al completar configuración',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if ((ctrl.lastError.value ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            ctrl.lastError.value!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onErrorContainer,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => ctrl.retry(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
      }
    });
  }
}

class _BannerShell extends StatelessWidget {
  final Color color;
  final Color border;
  final Widget child;

  const _BannerShell({
    required this.color,
    required this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

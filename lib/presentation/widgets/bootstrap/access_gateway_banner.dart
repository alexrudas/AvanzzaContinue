// ============================================================================
// lib/presentation/widgets/bootstrap/access_gateway_banner.dart
// ACCESS GATEWAY BANNER — proyección UI del estado del subsistema de Access.
//
// QUÉ HACE:
//   Combina dos fuentes reactivas para decidir qué mostrar:
//     · `AccessGateway.state` (ValueListenable) — estado del refresh remoto.
//     · `AccessSnapshotService.currentSnapshot` (Rxn) — caché local activa.
//
//   Regla canónica V2.1 final (cierre UX):
//     Local-first puro — si el cache local es usable y FRESCO (<24h), el
//     banner permanece OCULTO sin importar el estado del refresh remoto ni
//     el syncStatus. Mostrar "verificación falló" o "sincronización
//     pendiente" cuando el usuario puede operar con normalidad es ruido y
//     contradice la promesa local-first. Solo cuando el cache empieza a
//     envejecer (stale 24-72h) Y el gateway está fallando, se muestra señal
//     suave. >72h se eleva a warning claro porque las acciones críticas
//     empiezan a no ser confiables.
//
//   Matriz de decisión:
//
//   Snapshot      │ Freshness        │ Gateway          │ Banner
//   ──────────────┼──────────────────┼──────────────────┼─────────────────────
//   no existe     │ —                │ Error            │ HARD error
//   no existe     │ —                │ Ready/Loading    │ HIDDEN
//   existe        │ fresh (<24h)     │ cualquiera       │ HIDDEN  ← regla clave
//   existe        │ stale (24-72h)   │ Ready/Idle       │ HIDDEN
//   existe        │ stale (24-72h)   │ Error/Loading    │ SOFT pending|failed
//                 │                  │                  │ (según syncStatus)
//   existe        │ crit-stale (>72h)│ cualquiera       │ SOFT critically stale
//                 │                  │                  │ (advertir limitar críticas)
//   —             │ —                │ ReqWorkspace     │ INFO selector
//   —             │ —                │ Blocked          │ (overlay aparte)
//
// QUÉ NO HACE:
//   - NO dispara refresh por sí mismo (excepto botón Reintentar manual).
//   - NO navega.
//   - NO bloquea acciones críticas — eso es responsabilidad de V2.2
//     (`canPerform(action, snapshot)` en domain policy). El banner solo
//     proyecta estado.
//   - NO toca `Blocked` — eso es overlay full-screen `AccessGatewayBlockingOverlay`.
//
// LOGS:
//   `[ACCESS_BANNER] decision=<...> reason=<...>` — emitido SOLO cuando la
//   decisión cambia respecto a la última render para no inundar logs.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../application/services/access/access_gateway.dart';
import '../../../application/services/access/access_snapshot_service.dart';
import '../../../data/models/access/access_context_snapshot_model.dart';

/// Bucket de freshness derivado del snapshot. Se calcula una sola vez por
/// render y se pasa a la función pura de decisión para mantenerla testeable
/// sin requerir reloj inyectado.
enum AccessBannerFreshness {
  /// No hay snapshot persistido para `(uid, workspaceId)`.
  none,

  /// `fetchedAt` < 24h. Operar normal, NO mostrar banner aunque el refresh
  /// remoto esté fallando (regla canónica local-first).
  fresh,

  /// 24h <= `fetchedAt` < 72h. Aún operativo pero el refresh empieza a ser
  /// importante. Mostrar señal suave si gateway falla.
  stale,

  /// `fetchedAt` >= 72h. Cache muy viejo; las acciones críticas pueden
  /// fallar. Mostrar warning claro siempre.
  criticallyStale,
}

/// Decisión interna del banner. Cada valor mapea 1:1 a un `case` del build.
@visibleForTesting
enum AccessBannerDecision {
  hidden,
  hardError,
  softPending,
  softFailed,
  softCriticallyStale,
  infoSelect,
}

/// Política pura de decisión del banner. Sin side effects, sin acceso a
/// stores ni a clock — toda la entrada viene parametrizada.
///
/// Pública (`@visibleForTesting`) para que el test unitario pueda barrer
/// la matriz completa sin instanciar widgets.
@visibleForTesting
AccessBannerDecision decideAccessBanner({
  required AccessGatewayState gatewayState,
  required AccessBannerFreshness freshness,
  required AccessSyncStatus? syncStatus,
}) {
  // ── Estados terminales/especiales del gateway que no dependen de freshness.
  if (gatewayState is AccessGatewayBlocked) {
    return AccessBannerDecision.hidden; // overlay aparte
  }
  if (gatewayState is AccessGatewayRequiresWorkspaceSelection) {
    return AccessBannerDecision.infoSelect;
  }

  // ── Snapshot críticamente vencido: warning claro siempre, sin importar
  //    el estado del gateway. La política de bloqueo de acciones críticas
  //    vive en domain (V2.2 canPerform); aquí solo señalamos.
  if (freshness == AccessBannerFreshness.criticallyStale) {
    return AccessBannerDecision.softCriticallyStale;
  }

  // ── Sin snapshot: depende del gateway.
  if (freshness == AccessBannerFreshness.none) {
    if (gatewayState is AccessGatewayError) {
      return AccessBannerDecision.hardError;
    }
    return AccessBannerDecision.hidden;
  }

  // ── Snapshot fresco: silencio absoluto. Local-first puro.
  if (freshness == AccessBannerFreshness.fresh) {
    return AccessBannerDecision.hidden;
  }

  // ── Snapshot stale (24-72h): solo señalar si el gateway está fallando o
  //    el refresh aún está en curso. Si el gateway resolvió Ready, no hay
  //    que molestar al usuario.
  if (gatewayState is AccessGatewayReady ||
      gatewayState is AccessGatewayIdle) {
    return AccessBannerDecision.hidden;
  }
  // gateway = Error o Loading sobre snapshot stale.
  if (syncStatus == AccessSyncStatus.pendingSync) {
    return AccessBannerDecision.softPending;
  }
  if (syncStatus == AccessSyncStatus.syncFailed) {
    return AccessBannerDecision.softFailed;
  }
  // syncStatus = confirmed pero el refresh actual está fallando/cargando
  // sobre un snapshot stale. Señalamos suave como failed (la última
  // confirmación está envejeciendo y el intento actual no progresa).
  return AccessBannerDecision.softFailed;
}

/// Helper para clasificar un snapshot en su bucket de freshness usando el
/// servicio (tiene el clock canónico). Aislado para que tests del decisor
/// no requieran AccessSnapshotService real.
AccessBannerFreshness _classifyFreshness(
  AccessContextSnapshotModel? snapshot,
  AccessSnapshotService? svc,
) {
  if (snapshot == null || svc == null) return AccessBannerFreshness.none;
  if (svc.isCriticallyStale(snapshot)) {
    return AccessBannerFreshness.criticallyStale;
  }
  if (svc.isFresh(snapshot)) return AccessBannerFreshness.fresh;
  return AccessBannerFreshness.stale;
}

class AccessGatewayBanner extends StatefulWidget {
  const AccessGatewayBanner({super.key});

  @override
  State<AccessGatewayBanner> createState() => _AccessGatewayBannerState();
}

class _AccessGatewayBannerState extends State<AccessGatewayBanner> {
  static AccessBannerDecision? _lastLoggedDecision;
  static String _lastReason = '';

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AccessGateway>()) {
      return const SizedBox.shrink();
    }
    final gateway = Get.find<AccessGateway>();
    final svc = Get.isRegistered<AccessSnapshotService>()
        ? Get.find<AccessSnapshotService>()
        : null;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ValueListenableBuilder<AccessGatewayState>(
      valueListenable: gateway.state,
      builder: (_, gatewayState, __) {
        // Wrap con Obx para observar también el snapshot reactivo.
        return Obx(() {
          final snapshot = svc?.currentSnapshot.value;
          final freshness = _classifyFreshness(snapshot, svc);
          final decision = decideAccessBanner(
            gatewayState: gatewayState,
            freshness: freshness,
            syncStatus: snapshot?.syncStatus,
          );
          _logIfChanged(decision, gatewayState, snapshot, freshness);
          return _renderDecision(decision, gateway, theme, cs);
        });
      },
    );
  }

  void _logIfChanged(
    AccessBannerDecision decision,
    AccessGatewayState gatewayState,
    AccessContextSnapshotModel? snapshot,
    AccessBannerFreshness freshness,
  ) {
    final reason = _reasonFor(gatewayState, snapshot, freshness);
    if (decision == _lastLoggedDecision && reason == _lastReason) return;
    _lastLoggedDecision = decision;
    _lastReason = reason;
    debugPrint('[ACCESS_BANNER] decision=${decision.name} reason=$reason');
  }

  String _reasonFor(
    AccessGatewayState gatewayState,
    AccessContextSnapshotModel? snapshot,
    AccessBannerFreshness freshness,
  ) {
    final gw = gatewayState.runtimeType.toString();
    final sync = snapshot?.syncStatus.name ?? 'none';
    return 'gateway=$gw freshness=${freshness.name} syncStatus=$sync';
  }

  Widget _renderDecision(
    AccessBannerDecision decision,
    AccessGateway gateway,
    ThemeData theme,
    ColorScheme cs,
  ) {
    switch (decision) {
      case AccessBannerDecision.hidden:
        return const SizedBox.shrink();

      case AccessBannerDecision.infoSelect:
        return _BannerShell(
          color: cs.tertiaryContainer.withValues(alpha: 0.55),
          border: cs.tertiary.withValues(alpha: 0.4),
          child: Row(
            children: [
              Icon(Icons.workspaces_outline, size: 18, color: cs.tertiary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Selecciona un workspace para sincronizar tus permisos.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );

      case AccessBannerDecision.softPending:
        return _BannerShell(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
          border: cs.outlineVariant,
          child: Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: cs.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sincronización pendiente — operando con caché local.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );

      case AccessBannerDecision.softFailed:
        return _BannerShell(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
          border: cs.outline.withValues(alpha: 0.4),
          child: Row(
            children: [
              Icon(Icons.cloud_off_rounded, size: 16, color: cs.outline),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Última sincronización falló — usando caché local.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => gateway.ensureAccessReady(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );

      case AccessBannerDecision.hardError:
        return _BannerShell(
          color: cs.errorContainer.withValues(alpha: 0.55),
          border: cs.error.withValues(alpha: 0.5),
          child: Row(
            children: [
              Icon(Icons.error_outline_rounded, size: 18, color: cs.error),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No se pudo verificar permisos. Reintentando…',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onErrorContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => gateway.ensureAccessReady(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );

      case AccessBannerDecision.softCriticallyStale:
        // Snapshot >72h. El cache local sigue siendo legible pero las
        // decisiones canónicas (acciones críticas, gates de policy) deben
        // depender de un refresh exitoso. El bloqueo per-acción vive en
        // V2.2 (`canPerform`); aquí solo señalamos visualmente.
        return _BannerShell(
          color: cs.tertiaryContainer.withValues(alpha: 0.55),
          border: cs.tertiary.withValues(alpha: 0.5),
          child: Row(
            children: [
              Icon(Icons.history_toggle_off_rounded,
                  size: 18, color: cs.tertiary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Contexto local muy desactualizado. '
                  'Algunas acciones requieren conexión.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onTertiaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => gateway.ensureAccessReady(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Sincronizar'),
              ),
            ],
          ),
        );
    }
  }
}

/// Overlay full-screen para estado terminal `AccessGatewayBlocked`
/// (CONTACT_SUPPORT). Bloquea cualquier interacción con el shell hasta que
/// el equipo de soporte resuelva el caso.
class AccessGatewayBlockingOverlay extends StatelessWidget {
  const AccessGatewayBlockingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AccessGateway>()) {
      return const SizedBox.shrink();
    }
    final gateway = Get.find<AccessGateway>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ValueListenableBuilder<AccessGatewayState>(
      valueListenable: gateway.state,
      builder: (_, state, __) {
        if (state is! AccessGatewayBlocked) {
          return const SizedBox.shrink();
        }
        return Positioned.fill(
          child: AbsorbPointer(
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Material(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            size: 48, color: cs.error),
                        const SizedBox(height: 16),
                        Text(
                          'Cuenta bloqueada',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tu cuenta requiere asistencia. Contacta soporte '
                          'para continuar usando Avanzza.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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

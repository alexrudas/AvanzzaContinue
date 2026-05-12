// ============================================================================
// lib/presentation/workspace/workspace_shell_bootstrap_layer.dart
// WorkspaceShellBootstrapLayer — capa fina que compone los banners V2.1
// (Access + Bootstrap) y el overlay terminal sobre cualquier `child`.
// ============================================================================
// QUÉ HACE:
//   - Envuelve un `child` (típicamente el `IndexedStack` de tabs del shell)
//     con los dos banners inline V2.1 arriba y el `AccessGatewayBlockingOverlay`
//     encima del Stack.
//   - Composición pura: no navega, no observa lifecycle, no resuelve roles.
//
// QUÉ NO HACE:
//   - NO orquesta retry / sync (eso vive en `BootstrapSyncController`).
//   - NO instancia controllers, no inyecta deps.
//   - NO conoce de tabs, índices, `IndexedStack` ni navegación. Sólo recibe
//     un `child` y lo presenta.
//
// MOTIVACIÓN:
//   Antes de extraer, `WorkspaceShell` componía el `Stack`/`Column` de los
//   banners + overlay inline en su `build()`. Eso mezclaba dos
//   responsabilidades: (a) layout de navegación (drawer, app bar, bottom
//   nav, IndexedStack) y (b) presentación de estado de bootstrap/access.
//   Extraer (b) deja al shell como composición pura — la capa V2.1 queda
//   localizada y testeable sin levantar el shell completo.
// ============================================================================

import 'package:flutter/widgets.dart';

import '../widgets/bootstrap/access_gateway_banner.dart';
import '../widgets/bootstrap/bootstrap_sync_banner.dart';

/// Capa de composición V2.1 sobre cualquier shell.
///
/// Render structure:
///
/// ```
/// Stack
///  ├─ Column
///  │    ├─ AccessGatewayBanner       ← inline, auto-oculto en Ready/Idle
///  │    ├─ BootstrapSyncBanner       ← inline, auto-oculto en synced/idle
///  │    └─ Expanded(child: child)
///  └─ AccessGatewayBlockingOverlay   ← visible solo en CONTACT_SUPPORT
/// ```
///
/// El overlay se monta SIEMPRE; en estados no-terminales se renderiza
/// como `SizedBox.shrink` (sin coste de pintura ni interacción).
class WorkspaceShellBootstrapLayer extends StatelessWidget {
  const WorkspaceShellBootstrapLayer({
    super.key,
    required this.child,
  });

  /// Contenido del shell (típicamente el `IndexedStack` de tabs).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Banner inline del subsistema de Access. Oculto cuando el
            // gateway está Ready/Idle/Loading. Visible para
            // SELECT_WORKSPACE y errores transitorios.
            const AccessGatewayBanner(),
            // Banner del sync de fondo (POST /v1/bootstrap). Auto-oculto
            // cuando `BootstrapSyncStatus.synced/idle`. Reactivo vía Obx.
            // Se inyecta SOLO aquí para que aparezca en cualquier shell
            // (admin, owner, provider, etc.) sin duplicar wiring.
            const BootstrapSyncBanner(),
            Expanded(child: child),
          ],
        ),
        // Overlay terminal: cuando AccessGateway reporta CONTACT_SUPPORT
        // bloquea cualquier interacción con el shell. En el resto de
        // estados se renderiza como SizedBox.shrink (sin coste visual).
        const AccessGatewayBlockingOverlay(),
      ],
    );
  }
}

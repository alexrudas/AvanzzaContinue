// ============================================================================
// lib/presentation/widgets/provider/provider_bootstrap_gate.dart
// PROVIDER BOOTSTRAP GATE — pass-through (LOCAL-FIRST).
//
// QUÉ HACE HOY:
//   Pass-through. Renderiza directamente `child` (el workspace shell del
//   proveedor) sin esperar a `GET /v1/providers/me`.
//
// QUÉ NO HACE (ANTI-LEGACY-WIZARD):
//   - NO redirige a `Routes.providerBootstrap`. JAMÁS. Esa ruta es el
//     wizard legacy muerto; cualquier redirección reanima un flujo zombie
//     que NO debe existir.
//   - NO bloquea entrada al workspace por estado del backend. La provisión
//     de `ProviderProfile` corre en `BootstrapSyncController` (POST
//     /v1/bootstrap) en background; el `BootstrapSyncBanner` del
//     `WorkspaceShell` muestra "Preparando tu cuenta…" mientras converge.
//
// POR QUÉ:
//   El user ya completó el onboarding canónico (FusionadoFlow Q4 →
//   "Ingresar a mi cuenta"). En ese punto el sistema YA decidió que es
//   proveedor. Cualquier check `isProvider==false` aquí es un race con el
//   sync de fondo, NO una señal de que el user no es proveedor. Rebotar al
//   wizard legacy ante un race rompe la UX y reintroduce el flujo muerto.
//
//   Las acciones críticas que requieren provider profile real en backend
//   (crear cotización, replace specialties, etc.) se gatean con
//   `BootstrapSyncController.isProviderReady` en sus respectivos botones.
//   El shell se ve, pero las acciones quedan disabled hasta SYNCED.
// ============================================================================

import 'package:flutter/material.dart';

class ProviderBootstrapGate extends StatelessWidget {
  /// Widget a mostrar (workspace shell del proveedor).
  final Widget child;

  const ProviderBootstrapGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Pass-through deliberado. Ver header de archivo.
    return child;
  }
}

// ============================================================================
// lib/presentation/widgets/network/v2/empty_states.dart
// EMPTY STATES — Vistas mínimas para Empty / Forbidden / Error de SectionState
// ============================================================================
// QUÉ HACE:
//   - Tres widgets puros sin estado, listos para componer dentro de un
//     pattern matching sobre SectionState.
//   - SectionEmptyView, SectionForbiddenView, SectionErrorView.
//
// QUÉ NO HACE:
//   - No mapean el `Object error` a un humano específico: solo muestran un
//     mensaje genérico y exponen el botón "Reintentar". El mapeo fino se
//     hará en Fase 5 (polish) con un helper que clasifique
//     UnauthorizedException / NetworkException / UnsupportedSchemaVersion /
//     etc. en strings i18n.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SectionEmptyView extends StatelessWidget {
  final String message;
  const SectionEmptyView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 56),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class SectionForbiddenView extends StatelessWidget {
  final String message;

  /// DEV-ONLY. Capability esperada por el endpoint que devolvió 403. Si se
  /// provee y `kDebugMode=true`, se renderiza un banner amber debajo del
  /// mensaje principal mostrando la capability faltante. En release builds
  /// el flag `kDebugMode=false` elimina la rama por tree-shaking.
  final String? debugCapabilityHint;

  /// DEV-ONLY. Mensaje crudo del backend (típicamente "Access denied." o
  /// equivalente). Útil para diferenciar 403 reales de 403 sintéticos.
  final String? debugBackendMessage;

  const SectionForbiddenView({
    super.key,
    required this.message,
    this.debugCapabilityHint,
    this.debugBackendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final showDebug = kDebugMode &&
        (debugCapabilityHint != null || debugBackendMessage != null);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 56),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (showDebug)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _DebugCapabilityBanner(
                  capabilityHint: debugCapabilityHint,
                  backendMessage: debugBackendMessage,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Banner DEV-ONLY (gated por `kDebugMode`). Muestra capability faltante y
/// mensaje crudo del backend para acelerar el ciclo "agregar capability →
/// hot restart → validar". No se renderiza en release builds.
class _DebugCapabilityBanner extends StatelessWidget {
  final String? capabilityHint;
  final String? backendMessage;

  const _DebugCapabilityBanner({this.capabilityHint, this.backendMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        border: Border.all(color: Colors.amber.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEBUG (oculto en release)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.amber.shade900,
              letterSpacing: 0.5,
            ),
          ),
          if (capabilityHint != null) ...[
            const SizedBox(height: 6),
            Text(
              'Capability requerida: $capabilityHint',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ],
          if (backendMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              'Backend: $backendMessage',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SectionErrorView extends StatelessWidget {
  final Object error;
  final Future<void> Function() onRetry;

  const SectionErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56),
            const SizedBox(height: 12),
            const Text(
              'No se pudo cargar la información.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// lib/core/startup/bootstrap.dart
// BOOTSTRAP — Enterprise Ultra Pro (Core / Startup)
//
// QUÉ HACE:
// - Inicializa Firebase, Isar, DI, observers y bindings.
// - Devuelve un BootstrapResult con los recursos created/owned.
//
// IDEMPOTENCIA (PRODUCCIÓN):
// - Single-flight: si init() se llama concurrentemente, todos esperan el mismo Future.
// - No re-init: si init() ya completó, devuelve el resultado cacheado.
//
// DISPOSE (PRODUCCIÓN):
// - Idempotente: llamar dispose() múltiples veces es seguro.
// - NO soporta re-init después de dispose() (DIContainer no es re-entrante).
//   Si necesitas re-init real para tests, debes implementar un reset explícito
//   en DI (no se hace aquí).
// ============================================================================

import 'dart:async';

import 'package:avanzza/core/di/app_bindings.dart';
import 'package:avanzza/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isar_community/isar.dart';

import '../auth/auth_state_observer.dart';
import '../db/isar_instance.dart';
import '../db/migrations.dart';
import '../di/container.dart';
import '../network/connectivity_service.dart';
import '../sync/sync_lifecycle_observer.dart';
import '../sync/sync_observer.dart';

class Bootstrap {
  static Completer<BootstrapResult>? _inflight;
  static BootstrapResult? _result;

  static bool _disposed = false;

  /// Inicializa la app. Idempotente + single-flight.
  static Future<BootstrapResult> init() async {
    if (_disposed) {
      throw StateError(
        'Bootstrap.init() llamado después de dispose(). '
        'DIContainer no soporta re-init en producción.',
      );
    }

    // Fast path: ya inicializado.
    final cached = _result;
    if (cached != null) return cached;

    // Single-flight: si hay init en curso, esperar.
    final inflight = _inflight;
    if (inflight != null) return inflight.future;

    final completer = Completer<BootstrapResult>();
    _inflight = completer;

    try {
      final result = await _doInit();
      _result = result;
      completer.complete(result);
      return result;
    } catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      _inflight = null;
    }
  }

  /// Libera recursos owned por Bootstrap. Idempotente.
  ///
  /// Nota PRO: no soporta re-init después de dispose() (ver header).
  static Future<void> dispose() async {
    // Si hay un init en curso, esperamos a que termine (o falle) para evitar
    // estado parcialmente inicializado.
    final inflight = _inflight;
    if (inflight != null) {
      try {
        await inflight.future;
      } catch (_) {
        // Si falló el init, igual permitimos dispose best-effort.
      }
    }

    final r = _result;
    if (r == null) {
      _disposed = true;
      return;
    }

    // Marcar disposed primero para bloquear re-entradas peligrosas.
    _disposed = true;

    // Orden: primero desregistrar lifecycle observer (evita re-start por eventos),
    // luego detener engine y observers, y por último liberar connectivity.
    r.syncLifecycleObserver.dispose();

    // Best-effort: engine stop idempotente.
    await DIContainer().syncEngineService.stop(graceful: true);

    // Observers core (si existen sus APIs, se usan tal cual).
    // Si alguno no tuviera estos métodos en tu proyecto, AJUSTA aquí a su API real.
    r.authStateObserver.stop();
    r.syncObserver.dispose();

    // ConnectivityService.dispose() ES void en tu implementación actual.
    r.connectivity.dispose();

    // No nullificamos _result para evitar que alguien llame init() otra vez
    // y dispare re-init (DIContainer no lo soporta). Se mantiene cacheado.
  }

  // --------------------------------------------------------------------------
  // PRIVATE
  // --------------------------------------------------------------------------

  static Future<BootstrapResult> _doInit() async {
    // Firebase initialize: seguro ante múltiples llamadas en el mismo proceso.
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app(); // asegura app default disponible
    }

    final isar = await openIsar();
    await runMigrations(isar);

    final firestore = FirebaseFirestore.instance;

    final connectivity = ConnectivityService();
    final syncObserver = SyncObserver(connectivityService: connectivity);

    await initDI(
      isar: isar,
      firestore: firestore,
      connectivity: connectivity,
    );

    syncObserver.start();

    final authStateObserver = AuthStateObserver();
    authStateObserver.start();

    final syncLifecycleObserver = SyncLifecycleObserver(
      engine: DIContainer().syncEngineService,
    );
    syncLifecycleObserver.register();
    syncLifecycleObserver.startIfResumed();

    final result = BootstrapResult(
      isar: isar,
      firestore: firestore,
      connectivity: connectivity,
      syncObserver: syncObserver,
      authStateObserver: authStateObserver,
      syncLifecycleObserver: syncLifecycleObserver,
    );

    final appBinding = AppBindings(result);
    appBinding.dependencies();

    return result;
  }
}

class BootstrapResult {
  final Isar isar;
  final FirebaseFirestore firestore;
  final ConnectivityService connectivity;
  final SyncObserver syncObserver;
  final AuthStateObserver authStateObserver;
  final SyncLifecycleObserver syncLifecycleObserver;

  BootstrapResult({
    required this.isar,
    required this.firestore,
    required this.connectivity,
    required this.syncObserver,
    required this.authStateObserver,
    required this.syncLifecycleObserver,
  });
}

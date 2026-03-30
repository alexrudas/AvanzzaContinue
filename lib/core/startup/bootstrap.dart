// ============================================================================
// lib/core/startup/bootstrap.dart
//
// QUÉ HACE:
// - Inicialización segura de la app: Firebase, Isar, DI, observers, sync stack.
// - Single-flight + idempotente: llamadas concurrentes a init() esperan el mismo
//   Future; una vez completado, retorna el resultado cacheado.
// - Control EXPLÍCITO del Sync Stack con separación entre vehicle-specific
//   (AssetSyncLifecycleObserver) y genérico (SyncLifecycleObserver — legacy).
//
// QUÉ NO HACE:
// - No soporta re-init después de dispose() — DIContainer no es re-entrante.
// - No inicia SyncEngineService genérico en el lifecycle principal.
// - No re-inicia automáticamente si el init falla (el caller debe reintentar).
//
// PRINCIPIOS:
// - Lifecycle principal del stack vehicular: AssetSyncLifecycleObserver.
// - SyncLifecycleObserver se mantiene instanciado (legacy compat) pero NO
//   recibe startIfResumed() — evita reactivar el engine genérico en resume.
// - Orden de start: dispatcher (consumer) → engine (producer).
// - Orden de dispose: AssetSync observer → legacy observer → infra.
//
// ENTERPRISE NOTES:
// - BootstrapResult expone ambos observers:
//     assetSyncLifecycleObserver — nuevo, lifecycle principal
//     syncLifecycleObserver      — legacy, no debe llamar startIfResumed()
// - startSyncInfrastructure() / stopSyncInfrastructure() en container.dart
//   quedan disponibles para reintentos explícitos (tests, hot-restart).
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
import '../sync/asset_sync_lifecycle_observer.dart';
import '../sync/sync_lifecycle_observer.dart';
import '../sync/sync_observer.dart';

class Bootstrap {
  static Completer<BootstrapResult>? _inflight;
  static BootstrapResult? _result;
  static bool _disposed = false;

  // ==========================================================================
  // INIT
  // ==========================================================================

  /// Inicializa la app. Idempotente + single-flight.
  static Future<BootstrapResult> init() async {
    if (_disposed) {
      throw StateError(
        'Bootstrap.init() llamado después de dispose(). '
        'No se permite re-init en producción.',
      );
    }

    final cached = _result;
    if (cached != null) return cached;

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

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  /// Libera todos los recursos. Idempotente.
  ///
  /// Orden de dispose:
  /// 1. AssetSyncLifecycleObserver (nuevo — lifecycle principal)
  /// 2. SyncLifecycleObserver (legacy — best-effort cleanup)
  /// 3. SyncEngineService genérico (por si llegó a estar activo)
  /// 4. Core observers (auth, sync, connectivity)
  static Future<void> dispose() async {
    // Si hay init en curso, esperamos para evitar estado parcial.
    final inflight = _inflight;
    if (inflight != null) {
      try {
        await inflight.future;
      } catch (_) {}
    }

    final r = _result;
    if (r == null) {
      _disposed = true;
      return;
    }

    _disposed = true;

    final di = DIContainer();

    // 1. Lifecycle observers (desregistra y detiene cada stack).
    r.assetSyncLifecycleObserver.dispose();
    r.syncLifecycleObserver
        .dispose(); // legacy — su dispose() llama stop() interno

    // 2. Guardrail: asegurar que el engine genérico queda detenido.
    await di.syncEngineService.stop(graceful: true);

    // 3. Core observers.
    r.authStateObserver.stop();
    r.syncObserver.dispose();

    // 4. Infra.
    r.connectivity.dispose();
  }

  // ==========================================================================
  // INTERNAL INIT
  // ==========================================================================

  static Future<BootstrapResult> _doInit() async {
    // ─────────────────────────────────────────────────────────────────────────
    // FIREBASE
    // ─────────────────────────────────────────────────────────────────────────
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DATABASE
    // ─────────────────────────────────────────────────────────────────────────
    final isar = await openIsar();
    await runMigrations(isar);

    final firestore = FirebaseFirestore.instance;

    // ─────────────────────────────────────────────────────────────────────────
    // CONNECTIVITY + SYNC OBSERVER BASE
    // ─────────────────────────────────────────────────────────────────────────
    final connectivity = ConnectivityService();
    final syncObserver = SyncObserver(connectivityService: connectivity);

    // ─────────────────────────────────────────────────────────────────────────
    // DI CONTAINER
    // ─────────────────────────────────────────────────────────────────────────
    await initDI(
      isar: isar,
      firestore: firestore,
      connectivity: connectivity,
    );

    final di = DIContainer();

    // ─────────────────────────────────────────────────────────────────────────
    // OBSERVERS BASE
    // ─────────────────────────────────────────────────────────────────────────
    syncObserver.start();
    final authStateObserver = AuthStateObserver();

    // ─────────────────────────────────────────────────────────────────────────
    // SYNC LIFECYCLE — LEGACY (SyncEngineService genérico)
    //
    // Se mantiene instanciado y registrado por compatibilidad con AppBindings
    // y cualquier otra dependencia que espere este objeto en BootstrapResult.
    //
    // REGLA: NO llamar startIfResumed() aquí.
    // Llamar startIfResumed() activaría syncEngineService en resume, lo cual
    // contradice la estrategia "vehicle sync especializado manda".
    // El lifecycle del engine genérico queda en manos del owner que lo active
    // explícitamente en el futuro (cuando existan entidades no-vehículo reales
    // en el outbox).
    // ─────────────────────────────────────────────────────────────────────────
    final syncLifecycleObserver = SyncLifecycleObserver(
      engine: di.syncEngineService,
    );
    syncLifecycleObserver.register();
    // ⚠️ NO llamar syncLifecycleObserver.startIfResumed()

    // ─────────────────────────────────────────────────────────────────────────
    // SYNC LIFECYCLE — ASSET SYNC STACK (lifecycle principal vehicle-specific)
    //
    // Este observer es el dueño real del lifecycle del stack vehicular.
    // startIfResumed() garantiza el arranque correcto en el primer frame
    // y en cada app resume posterior.
    // ─────────────────────────────────────────────────────────────────────────
    final assetSyncLifecycleObserver = AssetSyncLifecycleObserver(
      engine: di.assetSyncEngine,
      dispatcher: di.assetSyncDispatcher,
    );
    assetSyncLifecycleObserver.register();
    await assetSyncLifecycleObserver.startIfResumed();

    // Guardrail: asegurar que el engine genérico no compita con vehicle:* en
    // este ciclo de init. El syncLifecycleObserver.register() ya está hecho,
    // así que este stop solo aplica al arranque inicial.
    await di.syncEngineService.stop(graceful: true);

    // ─────────────────────────────────────────────────────────────────────────
    // RESULT + BINDINGS UI
    // ─────────────────────────────────────────────────────────────────────────
    final result = BootstrapResult(
      isar: isar,
      firestore: firestore,
      connectivity: connectivity,
      syncObserver: syncObserver,
      authStateObserver: authStateObserver,
      syncLifecycleObserver: syncLifecycleObserver,
      assetSyncLifecycleObserver: assetSyncLifecycleObserver,
    );

    final appBinding = AppBindings(result);
    appBinding.dependencies();

    return result;
  }
}

// ============================================================================
// RESULT OBJECT
// ============================================================================

class BootstrapResult {
  final Isar isar;
  final FirebaseFirestore firestore;
  final ConnectivityService connectivity;
  final SyncObserver syncObserver;
  final AuthStateObserver authStateObserver;

  /// Legacy — mantiene compatibilidad con AppBindings y dependencias existentes.
  /// NO es el lifecycle principal del sync vehicular.
  final SyncLifecycleObserver syncLifecycleObserver;

  /// Nuevo — lifecycle principal del Asset Sync Stack (vehicle-specific).
  final AssetSyncLifecycleObserver assetSyncLifecycleObserver;

  BootstrapResult({
    required this.isar,
    required this.firestore,
    required this.connectivity,
    required this.syncObserver,
    required this.authStateObserver,
    required this.syncLifecycleObserver,
    required this.assetSyncLifecycleObserver,
  });
}

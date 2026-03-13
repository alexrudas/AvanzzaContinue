// ============================================================================
// lib/core/auth/auth_state_observer.dart
// AUTH STATE OBSERVER — Enterprise Ultra Pro (Core / Auth)
//
// QUÉ HACE:
// - Observa FirebaseAuth.authStateChanges() y gestiona el ciclo de sesión.
// - Inicializa SessionContextController al autenticarse.
// - Limpia SessionContextController al hacer logout.
// - Arranca/detiene AccountingOutboxSyncService por sesión (tag único).
// - Maneja casos edge: sesión expirada, logout forzado, re-autenticación.
//
// QUÉ NO HACE:
// - NO registra dependencias en GetX (responsabilidad de AppBindings).
// - NO crashea si deps del worker no están registrados (WARN + return).
//
// NOTAS:
// - Single-flight por tag: nunca crea un segundo worker en la misma sesión.
// - workerId = uid (estable por sesión de Firebase).
// - Todos los debugPrint gateados con kDebugMode (higiene release).
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../application/gateways/accounting/accounting_event_remote_gateway.dart';
import '../../application/services/accounting/accounting_outbox_sync_service.dart';
import '../../infrastructure/isar/repositories/isar_accounting_event_repository.dart';
import '../../presentation/controllers/session_context_controller.dart';

const _kSyncWorkerTag = 'accounting_outbox_sync';

/// AuthStateObserver - Observador de cambios en el estado de autenticación de Firebase
///
/// Responsabilidades:
/// 1. Observar cambios en FirebaseAuth.authStateChanges()
/// 2. Inicializar SessionContextController cuando hay usuario autenticado
/// 3. Limpiar SessionContextController cuando el usuario hace logout
/// 4. Manejar casos edge: sesión expirada, logout forzado, re-autenticación
/// 5. Arrancar/detener AccountingOutboxSyncService por sesión (tag único)
///
/// Patrón offline-first:
/// - Al detectar usuario autenticado, inmediatamente inicializar SessionController
/// - SessionController se encargará de cargar datos desde Isar (local) primero
/// - Luego sincronizar con Firestore en segundo plano
///
/// Uso:
/// ```dart
/// final observer = AuthStateObserver();
/// observer.start();
/// ```
class AuthStateObserver {
  final FirebaseAuth firebaseAuth;

  AuthStateObserver({FirebaseAuth? firebaseAuth})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    if (kDebugMode) {
      debugPrint('[P2D][Auth] AuthStateObserver created hash=$hashCode');
    }
  }

  StreamSubscription<User?>? _authStateSubscription;
  String? _lastUid;

  /// Iniciar la observación de cambios de estado de autenticación
  void start() {
    if (kDebugMode) {
      debugPrint('[P2D][Auth] start() subscribed hash=$hashCode');
    }

    _authStateSubscription?.cancel();
    _authStateSubscription = firebaseAuth.authStateChanges().listen(
      _onAuthStateChanged,
      onError: (error) {
        if (kDebugMode) {
          debugPrint('[AuthStateObserver] Error en authStateChanges: $error');
        }
      },
    );
  }

  /// Detener la observación
  void stop() {
    if (kDebugMode) {
      debugPrint('[AuthStateObserver] Deteniendo observación de auth state...');
    }
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
  }

  /// Callback cuando cambia el estado de autenticación
  Future<void> _onAuthStateChanged(User? user) async {
    if (kDebugMode) {
      debugPrint('[P2D][Auth] state user=${user?.uid ?? 'null'}');
    }

    // Caso 1: Usuario se autenticó o cambió
    if (user != null) {
      final isNewUser = _lastUid != user.uid;
      _lastUid = user.uid;

      // Worker se arranca AQUÍ, independientemente de SessionContextController.
      // El guard single-flight dentro de _startOutboxWorker previene doble-start.
      // CRÍTICO: no mover esto dentro de _initializeSession — SessionContextController
      // no está registrado durante el bootstrap (solo se registra en HomeBinding/AdminShellBinding).
      await _startOutboxWorker(user.uid);

      if (isNewUser) {
        if (kDebugMode) {
          debugPrint(
              '[AuthStateObserver] Usuario nuevo o diferente detectado. Inicializando sesión...');
        }
        await _initializeSession(user.uid);
      } else {
        if (kDebugMode) {
          debugPrint(
              '[AuthStateObserver] Mismo usuario, verificando si SessionController necesita inicialización...');
        }

        if (Get.isRegistered<SessionContextController>()) {
          final session = Get.find<SessionContextController>();
          if (session.user == null) {
            if (kDebugMode) {
              debugPrint(
                  '[AuthStateObserver] SessionController registrado pero user es null. Reinicializando...');
            }
            await _initializeSession(user.uid);
          }
        } else {
          if (kDebugMode) {
            debugPrint(
                '[AuthStateObserver] SessionController no registrado. Inicializando...');
          }
          await _initializeSession(user.uid);
        }
      }
    }
    // Caso 2: Usuario hizo logout
    else {
      if (kDebugMode) {
        debugPrint('[AuthStateObserver] Usuario hizo logout. Limpiando sesión...');
      }
      // Worker muere SIEMPRE en logout, independientemente de SessionContextController.
      await _stopOutboxWorker();
      await _clearSession();
      _lastUid = null;
    }
  }

  /// Inicializar SessionContextController con el usuario autenticado
  Future<void> _initializeSession(String uid) async {
    try {
      if (!Get.isRegistered<SessionContextController>()) {
        if (kDebugMode) {
          debugPrint(
              '[AuthStateObserver] SessionContextController no está registrado. Esperando que HomeBinding lo registre...');
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (Get.isRegistered<SessionContextController>()) {
        final session = Get.find<SessionContextController>();

        if (kDebugMode) {
          debugPrint(
              '[AuthStateObserver] Llamando a SessionController.init($uid)...');
        }

        await session.init(uid);

        if (kDebugMode) {
          debugPrint(
              '[AuthStateObserver] SessionController inicializado exitosamente');
        }
      } else {
        if (kDebugMode) {
          debugPrint(
              '[AuthStateObserver] WARN: SessionContextController aún no está registrado');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthStateObserver] Error al inicializar sesión: $e');
      }
    }
  }

  /// Limpiar SessionContextController cuando el usuario hace logout
  Future<void> _clearSession() async {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final session = Get.find<SessionContextController>();

        if (kDebugMode) {
          debugPrint('[AuthStateObserver] Limpiando SessionController...');
        }

        // resetForLogout limpia streams y estado sin remover del DI (permanent: true).
        session.resetForLogout();

        if (kDebugMode) {
          debugPrint('[AuthStateObserver] SessionController limpiado');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthStateObserver] Error al limpiar sesión: $e');
      }
    }
  }

  // ==========================================================================
  // OUTBOX SYNC WORKER — lifecycle helpers
  // ==========================================================================

  /// Arranca el AccountingOutboxSyncService para esta sesión.
  /// Single-flight: si ya existe (tag), retorna sin crear uno nuevo.
  /// Si los deps no están registrados en GetX, loguea WARN y retorna.
  Future<void> _startOutboxWorker(String uid) async {
    if (kDebugMode) {
      final tagReg = Get.isRegistered<AccountingOutboxSyncService>(
          tag: _kSyncWorkerTag);
      final repoReg = Get.isRegistered<IsarAccountingEventRepository>();
      final gatewayReg = Get.isRegistered<AccountingEventRemoteGateway>();
      debugPrint(
        '[P2D][Auth] _startOutboxWorker uid=$uid '
        'isRegistered(tag)=$tagReg '
        'repoRegistered=$repoReg '
        'gatewayRegistered=$gatewayReg',
      );
    }

    if (Get.isRegistered<AccountingOutboxSyncService>(tag: _kSyncWorkerTag)) {
      return; // single-flight: worker ya activo
    }

    if (!Get.isRegistered<IsarAccountingEventRepository>() ||
        !Get.isRegistered<AccountingEventRemoteGateway>()) {
      if (kDebugMode) {
        debugPrint(
            '[P2D][Auth] _startOutboxWorker WARN: deps not registered — worker NOT started');
      }
      return;
    }

    final worker = AccountingOutboxSyncService(
      Get.find<IsarAccountingEventRepository>(),
      Get.find<AccountingEventRemoteGateway>(),
      workerId: uid,
    );
    // permanent: true — evita que GetX elimine el worker en navegación de rutas.
    // Se elimina manualmente en _stopOutboxWorker() con Get.delete().
    Get.put<AccountingOutboxSyncService>(
      worker,
      tag: _kSyncWorkerTag,
      permanent: true,
    );
    worker.start();

    if (kDebugMode) {
      debugPrint('[P2D][Auth] worker.start() invoked workerId=$uid');
    }
  }

  /// Detiene y elimina del DI el AccountingOutboxSyncService.
  /// Si no existe (tag), retorna sin crashear.
  Future<void> _stopOutboxWorker() async {
    if (!Get.isRegistered<AccountingOutboxSyncService>(
        tag: _kSyncWorkerTag)) {
      return;
    }

    Get.find<AccountingOutboxSyncService>(tag: _kSyncWorkerTag).stop();
    await Get.delete<AccountingOutboxSyncService>(tag: _kSyncWorkerTag);

    if (kDebugMode) {
      debugPrint('[AuthStateObserver] OutboxSyncWorker stopped');
    }
  }

  /// Liberar recursos cuando el observer ya no se necesite
  void dispose() {
    stop();
  }
}

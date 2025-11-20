import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/session_context_controller.dart';

/// AuthStateObserver - Observador de cambios en el estado de autenticación de Firebase
///
/// Responsabilidades:
/// 1. Observar cambios en FirebaseAuth.authStateChanges()
/// 2. Inicializar SessionContextController cuando hay usuario autenticado
/// 3. Limpiar SessionContextController cuando el usuario hace logout
/// 4. Manejar casos edge: sesión expirada, logout forzado, re-autenticación
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
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  StreamSubscription<User?>? _authStateSubscription;
  String? _lastUid;

  /// Iniciar la observación de cambios de estado de autenticación
  void start() {
    debugPrint('[AuthStateObserver] Iniciando observación de auth state...');

    _authStateSubscription?.cancel();
    _authStateSubscription = firebaseAuth.authStateChanges().listen(
      _onAuthStateChanged,
      onError: (error) {
        debugPrint('[AuthStateObserver] Error en authStateChanges: $error');
      },
    );
  }

  /// Detener la observación
  void stop() {
    debugPrint('[AuthStateObserver] Deteniendo observación de auth state...');
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
  }

  /// Callback cuando cambia el estado de autenticación
  Future<void> _onAuthStateChanged(User? user) async {
    debugPrint(
        '[AuthStateObserver] Auth state cambió: ${user != null ? "Usuario autenticado (${user.uid})" : "No autenticado"}');

    // Caso 1: Usuario se autenticó o cambió
    if (user != null) {
      // Verificar si es un usuario diferente al anterior
      final isNewUser = _lastUid != user.uid;
      _lastUid = user.uid;

      if (isNewUser) {
        debugPrint(
            '[AuthStateObserver] Usuario nuevo o diferente detectado. Inicializando sesión...');
        await _initializeSession(user.uid);
      } else {
        debugPrint(
            '[AuthStateObserver] Mismo usuario, verificando si SessionController necesita inicialización...');

        // Verificar si SessionController ya tiene el usuario cargado
        if (Get.isRegistered<SessionContextController>()) {
          final session = Get.find<SessionContextController>();
          if (session.user == null) {
            debugPrint(
                '[AuthStateObserver] SessionController registrado pero user es null. Reinicializando...');
            await _initializeSession(user.uid);
          }
        } else {
          debugPrint(
              '[AuthStateObserver] SessionController no registrado. Inicializando...');
          await _initializeSession(user.uid);
        }
      }
    }
    // Caso 2: Usuario hizo logout
    else {
      debugPrint('[AuthStateObserver] Usuario hizo logout. Limpiando sesión...');
      await _clearSession();
      _lastUid = null;
    }
  }

  /// Inicializar SessionContextController con el usuario autenticado
  Future<void> _initializeSession(String uid) async {
    try {
      // Verificar si SessionContextController está registrado
      if (!Get.isRegistered<SessionContextController>()) {
        debugPrint(
            '[AuthStateObserver] SessionContextController no está registrado. Esperando que HomeBinding lo registre...');
        // Esperar un momento para que HomeBinding registre el controlador
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (Get.isRegistered<SessionContextController>()) {
        final session = Get.find<SessionContextController>();

        debugPrint(
            '[AuthStateObserver] Llamando a SessionController.init($uid)...');

        // Inicializar con el uid del usuario autenticado
        await session.init(uid);

        debugPrint(
            '[AuthStateObserver] SessionController inicializado exitosamente');
      } else {
        debugPrint(
            '[AuthStateObserver] WARN: SessionContextController aún no está registrado');
      }
    } catch (e) {
      debugPrint('[AuthStateObserver] Error al inicializar sesión: $e');
    }
  }

  /// Limpiar SessionContextController cuando el usuario hace logout
  Future<void> _clearSession() async {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final session = Get.find<SessionContextController>();

        debugPrint('[AuthStateObserver] Limpiando SessionController...');

        // Cancelar subscripciones del controlador
        session.onClose();

        debugPrint('[AuthStateObserver] SessionController limpiado');
      }
    } catch (e) {
      debugPrint('[AuthStateObserver] Error al limpiar sesión: $e');
    }
  }

  /// Liberar recursos cuando el observer ya no se necesite
  void dispose() {
    stop();
  }
}

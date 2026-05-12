// ============================================================================
// lib/core/auth/id_token_cache.dart
// ID TOKEN CACHE — single-flight + TTL para reducir presión sobre el
// canal `firebase_auth_plugin/id-token`.
// ============================================================================
// QUÉ HACE:
//   - Cachea el Firebase ID token actual con TTL conservador (50 min de los
//     60 min de vida real del JWT).
//   - Deduplica llamadas concurrentes a `user.getIdToken()`: cuando hay un
//     fetch en vuelo, los callers paralelos esperan al mismo Future en
//     lugar de disparar N invocaciones nativas.
//   - Invalida automáticamente cuando cambia el `uid` (login/logout) sin
//     necesidad de suscribirse a `idTokenChanges()` (canal que en Windows
//     tiene un bug de threading conocido).
//   - Expone `forceRefresh` para callers que sí necesitan token nuevo
//     (interceptor 401 INVALID_AUTH_TOKEN, post-bootstrap si lo pide).
//
// QUÉ NO HACE:
//   - NO se suscribe a `idTokenChanges()` (problema de threading en
//     firebase_auth Windows ^5.7.0). La invalidación es por TTL + cambio
//     de uid observado al fetch.
//   - NO refresca proactivamente. La política es lazy: si el token aún
//     está fresco, lo devuelve sin contactar el plugin.
//   - NO maneja errores del SDK más allá de propagarlos al caller. Los
//     fallos durante `getIdToken()` no se cachean — el próximo intento
//     volverá a llamar al plugin.
//
// MOTIVACIÓN:
//   El provider_form y otros flujos hacen fan-out de 4-8 requests HTTP en
//   paralelo. Sin cache, cada request invoca `getIdToken()` por su cuenta
//   y bajo carga concurrente eso es exactamente el patrón que dispara el
//   bug de threading del plugin Windows → abort() en C++ side. Con
//   single-flight, las N requests comparten una sola invocación al plugin.
//
//   Móvil también gana: menos invocaciones al canal nativo, menos latencia,
//   menor riesgo de race en el SDK.
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class IdTokenCache {
  IdTokenCache(this._auth);

  /// Instancia compartida — se setea en `initDI()` después de crear el
  /// cache, y la consumen interceptores Dio que se construyen ANTES de
  /// initDI (`_CoreBearerInterceptor` en `_buildCoreDio()`). Es el único
  /// punto donde aceptamos un singleton; el resto del código recibe la
  /// instancia por DI.
  static IdTokenCache? _instance;
  static IdTokenCache get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'IdTokenCache.instance accedido antes de initDI(). '
        'Setea IdTokenCache.instance al crear la cache en el contenedor.',
      );
    }
    return i;
  }

  /// Lo setea `initDI()` una sola vez. Visible para tests que necesiten
  /// inyectar un fake (con `setFakeForTesting(...)`).
  static void registerInstance(IdTokenCache cache) {
    _instance = cache;
  }

  final FirebaseAuth _auth;

  /// TTL conservador. JWTs de Firebase viven 60 min; usar 50 min deja un
  /// colchón de seguridad razonable antes de la expiración real.
  static const Duration _ttl = Duration(minutes: 50);

  String? _cachedToken;
  DateTime? _cachedAt;
  String? _cachedUid;
  Future<String?>? _inFlight;

  /// Devuelve el ID token. Si hay uno en cache y aún está fresco, lo
  /// retorna sin tocar el plugin. Si hay un fetch en vuelo, los callers
  /// paralelos comparten ese Future (single-flight).
  ///
  /// [forceRefresh] omite la cache y fuerza un nuevo `getIdToken(true)`.
  /// Solo usar desde paths que realmente lo necesiten (interceptor 401).
  Future<String?> get({bool forceRefresh = false}) {
    final user = _auth.currentUser;
    if (user == null) {
      _reset();
      return Future<String?>.value(null);
    }

    // Cache hit válida: mismo uid, dentro del TTL y no se forzó refresh.
    if (!forceRefresh && _isFreshFor(user.uid)) {
      return Future<String?>.value(_cachedToken);
    }

    // Single-flight: si ya hay un fetch en curso y no nos piden refresh
    // forzado, reusarlo. Si piden forceRefresh, deja al caller disparar uno
    // nuevo en paralelo — su semántica exige token "recién emitido".
    final inFlight = _inFlight;
    if (inFlight != null && !forceRefresh) {
      return inFlight;
    }

    final future = _fetch(user, forceRefresh: forceRefresh);
    _inFlight = future;
    future.whenComplete(() {
      // Limpiar solo si seguimos siendo el future activo: un forceRefresh
      // paralelo puede haber reemplazado `_inFlight` después.
      if (identical(_inFlight, future)) _inFlight = null;
    });
    return future;
  }

  /// Limpia la cache. Llamar en logout o ante cualquier evento que
  /// invalide la sesión.
  void invalidate() {
    _reset();
  }

  Future<String?> _fetch(User user, {required bool forceRefresh}) async {
    final token = await user.getIdToken(forceRefresh);
    // Si el uid actual cambió mid-fetch (caso raro: login/logout en medio
    // de un fetch), no contaminamos la cache con un token que ya no aplica.
    if (_auth.currentUser?.uid != user.uid) {
      _reset();
      return token;
    }
    _cachedToken = token;
    _cachedAt = DateTime.now();
    _cachedUid = user.uid;
    return token;
  }

  bool _isFreshFor(String uid) {
    if (_cachedToken == null || _cachedAt == null) return false;
    if (_cachedUid != uid) return false;
    return DateTime.now().difference(_cachedAt!) < _ttl;
  }

  void _reset() {
    _cachedToken = null;
    _cachedAt = null;
    _cachedUid = null;
  }
}

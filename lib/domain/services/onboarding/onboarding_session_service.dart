// ============================================================================
// lib/domain/services/onboarding/onboarding_session_service.dart
// OnboardingSessionService — owner único del estado de reanudación del
// onboarding canónico (FusionadoFlow).
// ============================================================================
// QUÉ HACE:
//   - Persiste, lee y limpia el snapshot del `DemoRegistrationState` ligado
//     a un userId. Es la ÚNICA pieza autorizada a manipular el estado de
//     `OnboardingSessionModel`.
//   - Aplica reglas de aislamiento (un userId = una sesión), expiración
//     (TTL 7 días) y recuperación ante corrupción (parse fail → borrar).
//   - El servicio NO navega ni decide rutas; solo entrega/borra estado.
//
// QUÉ NO HACE:
//   - NO toca `RegistrationProgress` (legacy del wizard antiguo). El
//     onboarding canónico vive enteramente sobre este servicio.
//   - NO persiste estado pre-auth (Q1: phone + terms). Antes de que
//     Firebase emita un uid, no hay sujeto al cual aislar.
//
// CONTRATO:
//   - `save(userId, state)`         → upsert del snapshot.
//   - `restore(userId)`             → snapshot rehidratado o null.
//   - `markCompletedAndClear(uid)`  → idempotente: borra la sesión.
//   - `clearForUser(userId)`        → cleanup explícito (logout, etc.).
//   - `clearAll()`                  → saneamiento global (solo emergencia).
//
// EXPIRACIÓN:
//   Si `now - updatedAt > 7 días`, `restore` borra la fila y retorna null.
//   Esto previene que catálogos/datos obsoletos sobrevivan a actualizaciones
//   del flow.
//
// CORRUPCIÓN:
//   Cualquier excepción durante decodificación (jsonDecode, applyJson) se
//   trata como "estado corrupto": borrar la fila y retornar null. Nunca
//   propagar el throw — el caller debe poder reiniciar el onboarding sin
//   crashear.
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../data/datasources/local/onboarding_session_local_ds.dart';
import '../../../data/models/auth/onboarding_session_model.dart';
import '../../../presentation/demo_registration_v2/demo_state.dart';

class OnboardingSessionService {
  final OnboardingSessionLocalDataSource _local;

  /// TTL de la sesión. Si el snapshot supera esta antigüedad, se descarta.
  /// Inyectable para tests.
  final Duration ttl;

  /// Reloj inyectable para tests deterministas.
  final DateTime Function() _clock;

  OnboardingSessionService({
    required OnboardingSessionLocalDataSource local,
    this.ttl = const Duration(days: 7),
    DateTime Function()? clock,
  })  : _local = local,
        _clock = clock ?? _defaultClock;

  static DateTime _defaultClock() => DateTime.now().toUtc();

  // ─────────────────────────────────────────────────────────────────────────
  // SAVE
  // ─────────────────────────────────────────────────────────────────────────

  /// Persiste el snapshot del [state] asociado a [userId]. No-op silencioso
  /// si [userId] está vacío: se considera "pre-auth" (Q1) y no debe
  /// generar fila huérfana.
  Future<void> save({
    required String userId,
    required DemoRegistrationState state,
  }) async {
    if (userId.isEmpty) return;
    try {
      final json = state.toJson();
      final encoded = jsonEncode(json);
      final row = OnboardingSessionModel()
        ..userId = userId
        ..currentStep = state.step
        ..stateJson = encoded
        ..updatedAt = _clock()
        ..isCompleted = false;
      await _local.upsert(row);
    } catch (e, st) {
      // Persistencia es best-effort: nunca propagar para no abortar la UI.
      if (kDebugMode) {
        debugPrint('[OnboardingSessionService] save error (non-fatal): $e\n$st');
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RESTORE
  // ─────────────────────────────────────────────────────────────────────────

  /// Rehidrata el [DemoRegistrationState] persistido para [userId].
  ///
  /// Retorna null cuando:
  ///   - no hay sesión almacenada,
  ///   - la sesión está marcada `isCompleted` (caso defensivo),
  ///   - la sesión expiró (TTL),
  ///   - el blob JSON está corrupto / hay schema drift.
  ///
  /// En los últimos tres casos la fila se borra antes de retornar.
  Future<RestoredOnboardingSession?> restore(String userId) async {
    if (userId.isEmpty) return null;

    final OnboardingSessionModel? row;
    try {
      row = await _local.getByUserId(userId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OnboardingSessionService] read error (non-fatal): $e');
      }
      // Lectura rota: intentar saneamiento y reportar "sin sesión".
      await _safeDelete(userId);
      return null;
    }

    if (row == null) return null;

    if (row.isCompleted) {
      // Defensa: una sesión completed nunca debería sobrevivir, pero si
      // quedó por algún path incompleto, limpiar y reiniciar.
      await _safeDelete(userId);
      return null;
    }

    final age = _clock().difference(row.updatedAt);
    if (age > ttl) {
      if (kDebugMode) {
        debugPrint('[OnboardingSessionService] expired session for '
            '$userId (age=${age.inHours}h, ttl=${ttl.inHours}h) — clearing');
      }
      await _safeDelete(userId);
      return null;
    }

    final state = DemoRegistrationState();
    try {
      final decoded = jsonDecode(row.stateJson);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('stateJson root no es un Map');
      }
      state.applyJson(decoded);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint(
            '[OnboardingSessionService] corrupt session for $userId: $e\n$st');
      }
      await _safeDelete(userId);
      return null;
    }

    return RestoredOnboardingSession(
      state: state,
      currentStep: row.currentStep,
      updatedAt: row.updatedAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CLEAR
  // ─────────────────────────────────────────────────────────────────────────

  /// Idempotente. Llamar tras `CompleteOnboardingUC` exitoso.
  Future<void> markCompletedAndClear(String userId) => clearForUser(userId);

  /// Borra la sesión del usuario. Idempotente. Lo invoca:
  ///   - el commit final del flow,
  ///   - el observer de logout (`AuthStateObserver._clearSession`),
  ///   - el helper interno cuando detecta corrupción/expiración.
  Future<void> clearForUser(String userId) async {
    if (userId.isEmpty) return;
    await _safeDelete(userId);
  }

  /// Borra TODAS las filas. No usar en flujo normal — solo recovery global.
  Future<void> clearAll() async {
    try {
      await _local.deleteAll();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OnboardingSessionService] clearAll error (non-fatal): $e');
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // INTERNAL
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _safeDelete(String userId) async {
    try {
      await _local.deleteByUserId(userId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[OnboardingSessionService] delete error (non-fatal): $e');
      }
    }
  }
}

/// Bundle inmutable que retorna `restore`. Empaqueta el state ya hidratado
/// junto con metadata útil para el caller (splash) sin volver a tocar Isar.
class RestoredOnboardingSession {
  final DemoRegistrationState state;
  final int currentStep;
  final DateTime updatedAt;

  const RestoredOnboardingSession({
    required this.state,
    required this.currentStep,
    required this.updatedAt,
  });
}

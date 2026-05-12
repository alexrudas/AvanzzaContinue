// ============================================================================
// lib/application/core_common/actor_canon_telemetry.dart
// ActorCanonTelemetry — seam mínimo para observabilidad del ADR actor-canon
// ============================================================================
// QUÉ HACE:
//   - Define un contrato para reportar eventos críticos del canon ActorRef.
//   - Los verticales (repositorios) consumen la interfaz y son agnósticos
//     sobre el backend real de logging/telemetry.
//   - El DI inyecta la implementación concreta. Hoy: DebugPrintActorCanonTelemetry
//     (guardrail operativo local, provisional). Mañana: una impl contra
//     telemetry pipeline / crash reporting / log sink persistente sin tocar
//     los callers.
//
// QUÉ NO HACE:
//   - NO es un logger de propósito general. Solo eventos del ADR.
//   - NO es observabilidad enterprise hoy. Ver ADR §8.3 para el límite
//     explícito y el plan de reemplazo.
//
// See docs/adr/0001-actor-canon.md §8.3 (límites de observabilidad).
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../domain/entities/core_common/actor_ref.dart';

/// Contrato de emisión de eventos críticos del canon ActorRef.
///
/// Cualquier impl debe ser side-effect-only, sin relanzar excepciones: los
/// callers ya propagan el error de dominio. Un fallo en la telemetry jamás
/// debe enmascarar ni alterar el flujo de negocio.
abstract class ActorCanonTelemetry {
  /// Evento: el backend rechazó un `ActorRef.local` con `409 ACTOR_REF_UNKNOWN`
  /// porque no existe attestation server-side para ese par.
  ///
  /// Consumir este evento permite detectar call sites aguas arriba que usaron
  /// `fromKnownLocalContactIds` cuando debían usar `fromFreshlyCreated...`.
  /// No es para alerta de error genérico; el repo ya re-lanza al caller.
  void actorRefUnknownDetected({
    required int statusCode,
    required String callerHint,
    required List<ActorRef> refs,
    required bool attestSelf,
    required String message,
  });
}

/// Implementación PROVISIONAL: emite a `debugPrint` con formato consistente.
///
/// LÍMITE EXPLÍCITO (ADR §8.3):
///   - `debugPrint` es guardrail operativo local apto para dev y QA.
///   - NO es observabilidad enterprise: no persiste, no agrega, no alerta,
///     no cruza procesos, no sobrevive al reinicio del binario.
///   - En producción real debe reemplazarse por una impl que emita a un
///     telemetry sink real (Firebase Crashlytics, Sentry, PostHog, BigQuery
///     via event collector, etc.).
///   - El código productivo NO debe inspeccionar el stdout esperando este
///     formato; los tests sí pueden, usando un fake.
class DebugPrintActorCanonTelemetry implements ActorCanonTelemetry {
  const DebugPrintActorCanonTelemetry();

  @override
  void actorRefUnknownDetected({
    required int statusCode,
    required String callerHint,
    required List<ActorRef> refs,
    required bool attestSelf,
    required String message,
  }) {
    final refsSummary = refs.map((r) => r.toJson()).toList(growable: false);
    debugPrint(
      '[ActorCanonTelemetry] actor_ref.unknown.detected '
      'status=$statusCode code=ACTOR_REF_UNKNOWN '
      'caller=$callerHint '
      'refs=$refsSummary '
      'attestSelf=$attestSelf '
      'message=$message',
    );
  }
}

/// Singleton default del módulo: úsalo en DI cuando no tengas otra impl.
/// Trivialmente reemplazable: `DIContainer().actorCanonTelemetry = MyImpl();`.
const ActorCanonTelemetry kDefaultActorCanonTelemetry =
    DebugPrintActorCanonTelemetry();

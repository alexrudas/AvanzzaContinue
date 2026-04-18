// ============================================================================
// lib/core/utils/simit_freshness_policy.dart
// SIMIT FRESHNESS POLICY — Política de reutilización de datos SIMIT Persona
//
// QUÉ HACE:
// - Define shouldRefreshSimit(): función pura que determina si los datos SIMIT
//   de un propietario deben consultarse de nuevo según su antigüedad y contexto.
// - Define SimitFreshnessResult y SimitFreshnessLevel para comunicar el resultado.
//
// QUÉ NO HACE:
// - No hace HTTP. No accede a ningún repositorio.
// - No depende de Flutter ni GetX.
//
// PRINCIPIOS:
// - Función pura: mismo input → mismo output. Testable sin mocks.
// - ownerVehicleCount: si no está disponible en VRC, pasar 0 → política 24h
//   (más conservadora). Nunca asume un propietario liviano.
// - lastCheckedAt: session-only (capturado localmente en la página).
//   No persiste entre sesiones — diferido a siguiente fase.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase SIMIT-1 — Visualización mejorada y política de frescura.
// ============================================================================

enum SimitFreshnessLevel { fresh, stale, expired }

/// Resultado de la evaluación de frescura de datos SIMIT.
class SimitFreshnessResult {
  final bool isFresh;
  final bool shouldRefresh;
  final SimitFreshnessLevel level;

  const SimitFreshnessResult({
    required this.isFresh,
    required this.shouldRefresh,
    required this.level,
  });
}

/// Determina si los datos SIMIT de un propietario deben actualizarse.
///
/// Reglas de vigencia (más infracciones o más vehículos → ventana más corta):
/// - comparendosCount > 0 ó multasCount > 0 → válido 24h
/// - ownerVehicleCount == 0 (desconocido) → válido 24h (conservador)
/// - ownerVehicleCount >= 10 → válido 24h
/// - ownerVehicleCount 3–9 → válido 4 días
/// - ownerVehicleCount 1–2 → válido 7 días
///
/// [ownerVehicleCount]: Número de vehículos del propietario. Pasar 0 si no
/// está disponible en el modelo VRC actual (campo no existe en VrcDataModel).
SimitFreshnessResult shouldRefreshSimit({
  required int ownerVehicleCount,
  required int comparendosCount,
  required int multasCount,
  required DateTime lastCheckedAt,
}) {
  final Duration validFor;
  if (multasCount > 0 || comparendosCount > 0) {
    validFor = const Duration(hours: 24);
  } else if (ownerVehicleCount >= 10 || ownerVehicleCount == 0) {
    validFor = const Duration(hours: 24);
  } else if (ownerVehicleCount >= 3) {
    validFor = const Duration(days: 4);
  } else {
    // 1–2 vehículos
    validFor = const Duration(days: 7);
  }

  final age = DateTime.now().difference(lastCheckedAt);
  final isFresh = age < validFor;

  final SimitFreshnessLevel level;
  if (age < validFor * 0.5) {
    level = SimitFreshnessLevel.fresh;
  } else if (isFresh) {
    level = SimitFreshnessLevel.stale;
  } else {
    level = SimitFreshnessLevel.expired;
  }

  return SimitFreshnessResult(
    isFresh: isFresh,
    shouldRefresh: !isFresh,
    level: level,
  );
}

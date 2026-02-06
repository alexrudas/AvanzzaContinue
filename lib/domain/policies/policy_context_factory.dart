/// Policy Context Factory - Fábrica para obtener el contexto de políticas
///
/// Define cómo se resuelve el PolicyContext para evaluación de políticas.
/// FASE 1: Retorna siempre failSafe (sin sesión real).
/// FASE 2: Leerá sesión/usuario real (Open/Closed: solo cambia el Factory).
///
/// PRINCIPIO FUNDAMENTAL (NO NEGOCIABLE):
/// La informalidad NO afecta el registro financiero (ledger).
/// La informalidad SOLO afecta automatización, ejecución y visibilidad.
library;

import 'policy_context.dart';

/// Contrato abstracto para la fábrica de contexto de políticas
///
/// Las implementaciones deben resolver el contexto actual
/// sin exponer detalles de cómo se obtiene (sesión, cache, etc).
abstract class PolicyContextFactory {
  /// Obtiene el contexto de políticas desde la sesión actual
  PolicyContext fromCurrentSession();
}

/// Implementación por defecto del PolicyContextFactory
///
/// FASE 1 (Foundation): Retorna SIEMPRE PolicyContext.failSafe()
/// - NO lee sesión real
/// - NO lee usuario real
/// - NO accede a Firestore/Isar
/// - NO depende de UI
///
/// Esto garantiza comportamiento seguro por defecto:
/// - Automatización bloqueada
/// - Visibilidad restringida
class DefaultPolicyContextFactory implements PolicyContextFactory {
  const DefaultPolicyContextFactory();

  /// Retorna el contexto fail-safe para FASE 1.
  ///
  /// NOTA ARQUITECTÓNICA:
  /// `PolicyContext.failSafe()` es un constructor factory que retorna
  /// una instancia creada en runtime (no un valor `const`).
  /// Esta decisión es intencional en FASE 1.
  /// NO "optimizar" esto sin cambiar explícitamente el contrato de PolicyContext.
  @override
  PolicyContext fromCurrentSession() {
    return PolicyContext.failSafe();
  }
}

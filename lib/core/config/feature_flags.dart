// ============================================================================
// lib/core/config/feature_flags.dart
// FEATURE FLAGS — Banderas de release (compile-time)
// ============================================================================
// QUÉ HACE:
//   - Centraliza banderas de funcionalidades nuevas que conviven con código
//     legacy mientras se valida el reemplazo.
//   - Constantes `static const bool`: el compilador puede elidir ramas
//     muertas sin overhead en runtime.
//
// QUÉ NO HACE:
//   - NO persiste valores (no hay SharedPreferences ni remote config). Los
//     cambios requieren rebuild/reinstall — apropiado para fase de
//     validación interna donde queremos previsibilidad.
//   - NO mezcla con `AppConfig` (que es kitchen sink de constantes). Las
//     flags evolucionan rápido y conviene un archivo dedicado para reverts.
// ============================================================================

abstract final class FeatureFlags {
  /// Activa el reemplazo del tab "Chat" del workspace Admin por la nueva
  /// pantalla "Mi Red Operativa" (consume Core API /v1/network y /v1/team).
  ///
  /// REVERSIBLE: cuando esta flag es `false` (default), AdminChatPage y
  /// AdminChatBinding se mantienen activos sin cambios. Cuando es `true`,
  /// el tab muestra MiRedPage con MiRedBinding y los repos de network/team.
  ///
  /// Alcance Hito 5b: solo Admin workspace. Los otros workspaces (owner,
  /// provider×2, renter) NO se ven afectados independientemente del valor.
  ///
  /// El módulo Chat NO se elimina mientras esta flag exista: poner la flag
  /// en `false` debe restaurar el behavior previo sin migración de datos.
  static const bool useMiRedInsteadOfChat = true;

  /// Activa el reemplazo de `_LazyIndexedStack` por `PageView.builder` en el
  /// `WorkspaceShell` para habilitar swipe horizontal entre las tabs del
  /// NavigationBar.
  ///
  /// REVERSIBLE: cuando esta flag es `false` (default), el shell sigue
  /// montando tabs con `_LazyIndexedStack` (comportamiento histórico).
  /// Cuando es `true`, el body usa `PageView.builder` con `KeepAlive` por
  /// tab; el `_LazyIndexedStack` permanece en el archivo como rollback.
  ///
  /// Intencionalmente NO es `const`: permite a QA togglear vía debugger /
  /// hot-reload sin recompilar. El precio es perder dead-branch elision,
  /// aceptado mientras la flag esté en validación. Tras 2 sprints sin
  /// incidentes se promoverá a `const true` y luego se eliminará junto al
  /// `_LazyIndexedStack`.
  // ignore: prefer_const_declarations
  static bool useSwipeableShell = true;
}

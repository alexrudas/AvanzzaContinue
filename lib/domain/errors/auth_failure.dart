// ============================================================================
// lib/domain/errors/auth_failure.dart
// AUTH FAILURE — Enterprise Ultra Pro (Domain / Errors)
//
// QUÉ HACE:
// - Excepción de dominio controlada para fallos de autenticación.
// - Aísla FirebaseAuthException del dominio y la presentación.
//
// QUÉ NO HACE:
// - No expone códigos de Firebase ni mensajes técnicos al usuario.
// ============================================================================

/// Excepción de dominio para fallos de autenticación username/password.
/// Lanzada por AuthRepositoryImpl; capturada en LoginPasswordController.
class AuthFailure implements Exception {
  final String code;
  final String message;

  const AuthFailure(this.code, this.message);

  @override
  String toString() => 'AuthFailure($code): $message';
}

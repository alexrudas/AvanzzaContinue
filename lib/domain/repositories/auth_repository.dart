// domain/repositories/auth_repository.dart

/// Resultado idempotente de verificación de username.
/// available          → username libre, puede crearse.
/// ownedByCurrentUser → el doc ya existe con el uid del usuario actual, continuar.
/// takenByOtherUser   → tomado por otro uid, mostrar error.
enum UsernameCheckResult { available, ownedByCurrentUser, takenByOtherUser }

abstract class AuthRepository {
  // OTP (existente)
  Future<SendOtpResult> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String verificationId, String smsCode);
  Future<String?> ensureIdToken({bool forceRefresh});
  Future<void> signOut();

  // Username + Password + MFA (nuevo)
  Future<bool> checkUsernameAvailable(String username);

  /// Verificación idempotente: distingue username libre / propio / ajeno.
  Future<UsernameCheckResult> checkUsernameAvailability(
      String username, String currentUid);

  /// Obtiene el username ya registrado en Firestore para [uid] (one-shot).
  /// Usado para detectar registros incompletos y reanudar el flujo.
  Future<String?> fetchUsernameForUid(String uid);
  Future<String> signUpUsernamePassword({
    required String username,
    required String password,
    required String phoneNumber,
  });

  Future<SignInResult> signInWithUsernamePassword({
    required String username,
    required String password,
  });

  Future<void> sendMfaCode(SignInMfaResolver resolver);
  Future<String> verifyMfaCode(SignInMfaResolver resolver, String code);
}

class SendOtpResult {
  final String? verificationId; // null si hubo auto-verify y ya hay uid
  final bool autoVerified;
  final String? uid; // uid si auto-verify completó
  final bool timeout;

  const SendOtpResult({
    this.verificationId,
    this.autoVerified = false,
    this.uid,
    this.timeout = false,
  });
}

class SignInResult {
  final String? uid;
  final SignInMfaResolver? mfaResolver;
  const SignInResult({this.uid, this.mfaResolver});
}

abstract class SignInMfaResolver {}

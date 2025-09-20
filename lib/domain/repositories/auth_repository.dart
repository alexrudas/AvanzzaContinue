// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  // OTP (existente)
  Future<SendOtpResult> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String verificationId, String smsCode);
  Future<String?> ensureIdToken({bool forceRefresh});
  Future<void> signOut();

  // Username + Password + MFA (nuevo)
  Future<bool> checkUsernameAvailable(String username);
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

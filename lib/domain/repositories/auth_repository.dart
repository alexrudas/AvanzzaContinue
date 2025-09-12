// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<SendOtpResult> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String verificationId, String smsCode);
  Future<String?> ensureIdToken({bool forceRefresh});
  Future<void> signOut();
}

class SendOtpResult {
  final String? verificationId; // null si hubo auto-verify y ya hay uid
  final bool autoVerified;
  final String? uid;            // uid si auto-verify completó
  final bool timeout;

  const SendOtpResult({
    this.verificationId,
    this.autoVerified = false,
    this.uid,
    this.timeout = false,
  });
}

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDS {
  final FirebaseAuth _auth;

  FirebaseAuthDS(this._auth);

  // OTP por teléfono (existente)
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String verificationId) onCodeTimeout,
    required void Function(String uid) onAutoVerified,
    required void Function(FirebaseAuthException e) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final result = await _auth.signInWithCredential(credential);
          final uid = result.user?.uid;
          if (uid != null) onAutoVerified(uid);
        } on FirebaseAuthException catch (e) {
          onFailed(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) => onFailed(e),
      codeSent: (String verificationId, int? forceResendingToken) =>
          onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (String verificationId) =>
          onCodeTimeout(verificationId),
      timeout: const Duration(seconds: 60),
      forceResendingToken: null,
    );
  }

  Future<String> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.user!.uid;
  }

  // Username + Password vía email alias
  Future<UserCredential> signUpWithAliasEmail({
    required String aliasEmail,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: aliasEmail,
      password: password,
    );
  }

  Future<UserCredential> signInWithAliasEmail({
    required String aliasEmail,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: aliasEmail,
      password: password,
    );
  }

  // MFA (wrappers básicos). Existe en FirebaseAuth User (no en FirebaseAuth global)
  MultiFactor? get userMultiFactor => _auth.currentUser?.multiFactor;

  Future<void> sendMfaOtp({
    required MultiFactorResolver resolver,
    required PhoneMultiFactorInfo hint,
    required void Function(String verificationId) onCodeSent,
    required void Function(String verificationId) onCodeTimeout,
    required void Function(FirebaseAuthException e) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      multiFactorSession: resolver.session,
      multiFactorInfo: hint,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // En MFA, exigimos ingresar código explícitamente
      },
      verificationFailed: (FirebaseAuthException e) => onFailed(e),
      codeSent: (String verificationId, int? forceResendingToken) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (String verificationId) => onCodeTimeout(verificationId),
      timeout: const Duration(seconds: 60),
      forceResendingToken: null,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? currentUser() => _auth.currentUser;

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }
}

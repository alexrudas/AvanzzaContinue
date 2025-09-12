import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDS {
  final FirebaseAuth _auth;

  FirebaseAuthDS(this._auth);

  Future<void> sendOtp(
      {required String phoneNumber,
      required void Function(String verificationId) onCodeSent,
      required void Function(String verificationId) onCodeTimeout,
      required void Function(String uid) onAutoVerified,
      required void Function(FirebaseAuthException e) onFailed}) async {
    print("FirebaseAuthDS [sendOtp] [init] $phoneNumber");
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("FirebaseAuthDS [sendOtp] [verificationCompleted]");

        try {
          final result = await _auth.signInWithCredential(credential);
          final uid = result.user?.uid;
          if (uid != null) onAutoVerified(uid);
        } on FirebaseAuthException catch (e) {
          onFailed(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("FirebaseAuthDS [sendOtp] [verificationFailed]");

        onFailed(e);
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        print("FirebaseAuthDS [sendOtp] [codeSent]");
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("FirebaseAuthDS [sendOtp] [codeAutoRetrievalTimeout]");
        onCodeTimeout(verificationId);
      },
      timeout: const Duration(seconds: 60),
      forceResendingToken: null,
    );
  }

  Future<String> verifyOtp(
      {required String verificationId, required String smsCode}) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    final result = await _auth.signInWithCredential(credential);
    return result.user!.uid;
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

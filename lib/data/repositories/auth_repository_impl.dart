// data/repositories/auth_repository_impl.dart
import 'dart:async';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/firebase_auth_ds.dart';
import '../datasources/firestore/user_firestore_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDS authDS;
  final UserFirestoreDS userFS;

  AuthRepositoryImpl(this.authDS, this.userFS);

  @override
  Future<SendOtpResult> sendOtp(String phoneNumber) async {
    final completer = Completer<SendOtpResult>();

    await authDS.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (vid) {
        if (!completer.isCompleted) {
          completer.complete(SendOtpResult(
            verificationId: vid,
            autoVerified: false,
            uid: null,
            timeout: false,
          ));
        }
      },
      onCodeTimeout: (vid) {
        if (!completer.isCompleted) {
          completer.complete(SendOtpResult(
            verificationId: vid,
            autoVerified: false,
            uid: null,
            timeout: true,
          ));
        }
      },
      onAutoVerified: (String uid) {
        if (!completer.isCompleted) {
          completer.complete(SendOtpResult(
            verificationId: null,
            autoVerified: true,
            uid: uid,
            timeout: false,
          ));
        }
      },
      onFailed: (e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
    );

    return completer.future;
  }

  @override
  Future<String> verifyOtp(String verificationId, String smsCode) {
    return authDS.verifyOtp(verificationId: verificationId, smsCode: smsCode);
  }

  @override
  Future<String?> ensureIdToken({bool forceRefresh = false}) {
    return authDS.getIdToken(forceRefresh: forceRefresh);
  }

  @override
  Future<void> signOut() => authDS.signOut();
}

// data/repositories/auth_repository_impl.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/firebase_auth_ds.dart';
import '../datasources/firestore/user_firestore_ds.dart';
import '../models/user_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDS authDS;
  final UserFirestoreDS userFS;

  AuthRepositoryImpl(this.authDS, this.userFS);

  String _aliasFromUsername(String username) =>
      '${username.toLowerCase()}@avz.local';

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

  // NUEVO: disponibilidad de username (legacy — solo bool)
  @override
  Future<bool> checkUsernameAvailable(String username) async {
    final col = userFS.db.collection('usernames');
    final doc = await col.doc(username.toLowerCase()).get();
    return !doc.exists;
  }

  // NUEVO: verificación idempotente — distingue propio/libre/ajeno
  @override
  Future<UsernameCheckResult> checkUsernameAvailability(
      String username, String currentUid) async {
    final doc = await userFS.db
        .collection('usernames')
        .doc(username.toLowerCase())
        .get();
    if (!doc.exists) return UsernameCheckResult.available;
    if (doc.data()?['uid'] == currentUid) {
      return UsernameCheckResult.ownedByCurrentUser;
    }
    return UsernameCheckResult.takenByOtherUser;
  }

  // NUEVO: fetch one-shot del username registrado en Firestore para un uid
  @override
  Future<String?> fetchUsernameForUid(String uid) async {
    final profile = await userFS.getProfile(uid);
    return profile?.username;
  }

  // NUEVO: signUp username+password
  @override
  Future<String> signUpUsernamePassword({
    required String username,
    required String password,
    required String phoneNumber,
  }) async {
    final alias = _aliasFromUsername(username);
    final cred = await authDS.signUpWithAliasEmail(
        aliasEmail: alias, password: password);
    final uid = cred.user!.uid;

    // Registrar username → uid (unicidad simple)
    await userFS.db.runTransaction((txn) async {
      final docRef =
          userFS.db.collection('usernames').doc(username.toLowerCase());
      final snap = await txn.get(docRef);
      if (snap.exists) {
        throw FirebaseException(plugin: 'auth', message: 'username_taken');
      }
      txn.set(docRef, {'uid': uid, 'createdAt': FieldValue.serverTimestamp()});
    });

    // Crear perfil mínimo si no existe
    final profileModel = UserProfileModel(
      uid: uid,
      phone: phoneNumber,
      username: username,
      email: null,
      countryId: null,
      regionId: null,
      cityId: null,
      roles: const [],
      orgIds: const [],
      docType: null,
      docNumber: null,
      identityRaw: null,
      termsVersion: null,
      termsAcceptedAt: null,
      status: 'active',
      createdAt: null,
      updatedAt: null,
    );
    await userFS.createProfile(uid, profileModel);

    return uid;
  }

  // NUEVO: signIn con password; si requiere MFA, devolvemos resolver
  @override
  Future<SignInResult> signInWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    final alias = _aliasFromUsername(username);
    try {
      final cred = await authDS.signInWithAliasEmail(
          aliasEmail: alias, password: password);
      return SignInResult(uid: cred.user?.uid);
    } on FirebaseAuthMultiFactorException catch (e) {
      // MFA requerida — exponer resolver (wrapper minimalista)
      return SignInResult(mfaResolver: _FirebaseMfaResolver(e.resolver));
    } on FirebaseAuthException catch (e) {
      // Credenciales inválidas u otro error de Firebase → error de dominio.
      // NUNCA propagar FirebaseAuthException sin manejar.
      throw AuthFailure(e.code, _mapFirebaseMessage(e.code));
    }
  }

  static String _mapFirebaseMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Usuario o contraseña incorrectos.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'network-request-failed':
        return 'Sin conexión a internet.';
      default:
        return 'No se pudo iniciar sesión.';
    }
  }

  @override
  Future<void> sendMfaCode(SignInMfaResolver resolver) async {
    if (resolver is _FirebaseMfaResolver) {
      final hints = resolver._resolver.hints;
      final phoneInfo = hints.whereType<PhoneMultiFactorInfo>().first;
      await authDS.sendMfaOtp(
        resolver: resolver._resolver,
        hint: phoneInfo,
        onCodeSent: (vid) => resolver.verificationId = vid,
        onCodeTimeout: (vid) => resolver.verificationId = vid,
        onFailed: (e) => throw e,
      );
    }
  }

  @override
  Future<String> verifyMfaCode(SignInMfaResolver resolver, String code) async {
    if (resolver is _FirebaseMfaResolver) {
      final vid = resolver.verificationId;
      if (vid == null) throw StateError('Falta verificationId para MFA');
      final assertion = PhoneMultiFactorGenerator.getAssertion(
        PhoneAuthProvider.credential(verificationId: vid, smsCode: code),
      );
      final cred = await resolver._resolver.resolveSignIn(assertion);
      return cred.user!.uid;
    }
    throw StateError('Resolver inválido');
  }
}

class _FirebaseMfaResolver implements SignInMfaResolver {
  final MultiFactorResolver _resolver;
  String? verificationId;
  _FirebaseMfaResolver(this._resolver);
}

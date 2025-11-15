import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// FirebaseAuthDS - Data Source para autenticación con Firebase
///
/// Versiones de paquetes soportadas:
/// - google_sign_in: ^7.2.0
/// - sign_in_with_apple: ^7.0.1
/// - flutter_facebook_auth: ^7.1.2
/// - firebase_auth: (latest compatible)
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

  // ============================================================================
  // AUTENTICACIÓN FEDERADA
  // ============================================================================

  /// Autenticación con Google Sign-In
  /// Retorna UserCredential con el usuario autenticado
  /// Lanza FirebaseAuthException si falla la autenticación
  ///
  /// Compatible con google_sign_in: ^7.2.0
  /// API estable: GoogleSignIn().signIn() → GoogleSignInAccount
  /// Propiedades: googleAuth.accessToken, googleAuth.idToken (sin cambios en v7.x)
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Iniciar flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Usuario canceló el flujo
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      // Obtener detalles de autenticación del request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crear credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar con Firebase usando la credencial de Google
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) rethrow;
      throw FirebaseAuthException(
        code: 'ERROR_GOOGLE_SIGN_IN',
        message: e.toString(),
      );
    }
  }

  /// Autenticación con Apple Sign-In
  /// Solo disponible en iOS 13+ y macOS 10.15+
  /// Retorna UserCredential con el usuario autenticado
  ///
  /// Compatible con sign_in_with_apple: ^7.0.1
  /// API: SignInWithApple.getAppleIDCredential() → AuthorizationCredentialAppleID
  /// Scopes: AppleIDAuthorizationScopes.email, .fullName (enum estable en v7.x)
  /// Credencial: identityToken (idToken), authorizationCode (accessToken)
  Future<UserCredential> signInWithApple() async {
    try {
      // Solicitar credencial de Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Crear credencial de OAuth para Firebase
      // OAuthProvider("apple.com") es la API de Firebase (no del plugin)
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Autenticar con Firebase
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      if (e is FirebaseAuthException) rethrow;
      throw FirebaseAuthException(
        code: 'ERROR_APPLE_SIGN_IN',
        message: e.toString(),
      );
    }
  }

  /// Autenticación con Facebook
  /// Requiere configuración de Facebook App ID en Firebase Console
  /// Retorna UserCredential con el usuario autenticado
  ///
  /// IMPORTANTE (v7.1.2+): AccessToken.token fue renombrado a AccessToken.tokenString
  Future<UserCredential> signInWithFacebook() async {
    try {
      // Iniciar flujo de login de Facebook
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // Verificar resultado
      if (result.status != LoginStatus.success) {
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: 'Facebook login failed: ${result.status}',
        );
      }

      if (result.accessToken == null) {
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_NO_TOKEN',
          message: 'Facebook access token is null',
        );
      }

      // Crear credencial de Facebook para Firebase
      // CAMBIO v7.x: .token → .tokenString
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      // Autenticar con Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) rethrow;
      throw FirebaseAuthException(
        code: 'ERROR_FACEBOOK_SIGN_IN',
        message: e.toString(),
      );
    }
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  Future<void> signOut() async {
    await _auth.signOut();

    // También cerrar sesión de proveedores federados
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  User? currentUser() => _auth.currentUser;

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }
}

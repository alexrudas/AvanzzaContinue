import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../domain/errors/auth_failure.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  // OTP por teléfono
  // onFailed recibe AuthFailure (dominio) en lugar de FirebaseAuthException.
  // FirebaseAuthException NUNCA sale de esta clase.
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String verificationId) onCodeTimeout,
    required void Function(String uid) onAutoVerified,
    required void Function(AuthFailure failure) onFailed,
  }) async {
    final masked = phoneNumber.length > 4
        ? '*' * (phoneNumber.length - 4) +
            phoneNumber.substring(phoneNumber.length - 4)
        : '****';
    if (kDebugMode) debugPrint('[PhoneAuth] verifyPhoneNumber → $masked');

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (kDebugMode) debugPrint('[PhoneAuth] verificationCompleted (auto-verify)');
        try {
          final result = await _auth.signInWithCredential(credential);
          final uid = result.user?.uid;
          if (uid != null) onAutoVerified(uid);
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            debugPrint('[PhoneAuth] autoVerify signIn failed: ${e.code}');
          }
          onFailed(AuthFailure(e.code, _mapPhoneError(e.code)));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          debugPrint('[PhoneAuth] verificationFailed: code=${e.code}');
        }
        // Mapear a error de dominio; NUNCA propagar FirebaseAuthException.
        onFailed(AuthFailure(e.code, _mapPhoneError(e.code)));
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        if (kDebugMode) debugPrint('[PhoneAuth] codeSent — SMS dispatched');
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (kDebugMode) debugPrint('[PhoneAuth] codeAutoRetrievalTimeout');
        onCodeTimeout(verificationId);
      },
      timeout: const Duration(seconds: 60),
      forceResendingToken: null,
    );
  }

  static String _mapPhoneError(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'Número inválido. Revisa el formato.';
      case 'app-not-authorized':
      case 'missing-client-identifier':
      case 'captcha-check-failed':
        return 'La app no está autorizada para OTP (revisar SHA en Firebase).';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'quota-exceeded':
        return 'Límite de SMS alcanzado. Intenta luego.';
      case 'network-request-failed':
        return 'Sin conexión. Verifica internet.';
      case 'operation-not-allowed':
        return 'Proveedor Teléfono deshabilitado en Firebase.';
      default:
        return 'No se pudo enviar el código. Intenta de nuevo.';
    }
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
      codeSent: (String verificationId, int? forceResendingToken) =>
          onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (String verificationId) =>
          onCodeTimeout(verificationId),
      timeout: const Duration(seconds: 60),
      forceResendingToken: null,
    );
  }
  // ---------------------------------------------------------------------------
  // CONFIG GOOGLE SIGN-IN (v7.x)
  // ---------------------------------------------------------------------------

  /// Web client ID (serverClientId) requerido por google_sign_in 7.x en Android
  /// para poder emitir idToken válido que luego usa FirebaseAuth.
  ///
  /// Debe ser el "Client ID" que aparece en:
  /// Firebase Console → Authentication → Método de inicio de sesión → Google →
  /// Configuración del SDK web.
  static const String _googleServerClientId =
      '778457383096-jr1jn89kdp30stdif9i8jpd0ue8j0eps.apps.googleusercontent.com';

  /// Flag para evitar inicializar GoogleSignIn más de una vez.
  static bool _googleInitialized = false;

  /// Inicializa GoogleSignIn.instance con la configuración correcta.
  /// Debe llamarse ANTES de usar authenticate() o cualquier flujo con Google.
  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;

    await GoogleSignIn.instance.initialize(
      serverClientId: _googleServerClientId,
      // clientId: opcional; normalmente no es necesario en Android
    );

    _googleInitialized = true;
  }
  // ============================================================================
  // AUTENTICACIÓN FEDERADA
  // ============================================================================

  /// Autenticación con Google Sign-In
  /// Retorna UserCredential con el usuario autenticado
  /// Lanza FirebaseAuthException si falla la autenticación
  ///
  /// Compatible con google_sign_in: ^7.2.0
  /// CAMBIOS v7.x:
  /// - GoogleSignIn ahora es singleton: GoogleSignIn.instance
  /// - signIn() reemplazado por authenticate(scopeHint: [...])
  /// - GoogleSignInAuthentication solo expone idToken (NO accessToken)
  /// - Para FirebaseAuth solo se necesita idToken
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Asegurar que GoogleSignIn esté inicializado con serverClientId
      await _ensureGoogleInitialized();

      // v7.x: GoogleSignIn es singleton, no se instancia con constructor
      final googleSignIn = GoogleSignIn.instance;

      // Iniciar flujo de autenticación interactivo de Google
      // authenticate() reemplaza al antiguo signIn()
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(
        scopeHint: const <String>[
          'email',
          'profile',
        ],
      );

      // Obtener token de autenticación (solo idToken en v7.x)
      // GoogleSignInAuthentication ya NO tiene accessToken
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Crear credencial para Firebase usando SOLO idToken
      // En v7.x, accessToken ya no está disponible en GoogleSignInAuthentication
      // Para FirebaseAuth, idToken es suficiente para autenticar
      final credential = GoogleAuthProvider.credential(
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
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  User? currentUser() => _auth.currentUser;

  /// Obtiene el JWT string del usuario actual.
  ///
  /// Usar para inyectar como Bearer en headers HTTP (Authorization: Bearer <token>).
  /// Si [forceRefresh] es true, el SDK contacta a Firebase Auth servers para obtener
  /// un token nuevo, invalidando el token anterior en cache.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }

  /// Obtiene el [IdTokenResult] del usuario actual, que incluye los custom claims
  /// decodificados en el map [IdTokenResult.claims].
  ///
  /// Diferencia clave respecto a [getIdToken]:
  /// - [getIdToken]: retorna el JWT string opaco para enviar como Bearer header.
  /// - [getIdTokenResult]: retorna el resultado decodificado para LEER campos
  ///   como activeContext.organizationId, role, membershipStatus.
  ///
  /// Usar [forceRefresh: true] obligatoriamente después de llamar al backend
  /// switchActiveOrganization, para garantizar que los claims reflejen el nuevo
  /// orgId escrito por Firebase Admin setCustomUserClaims().
  ///
  /// Sin [forceRefresh], el SDK puede devolver claims del token cacheado (viejo).
  Future<IdTokenResult?> getIdTokenResult({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdTokenResult(forceRefresh);
  }
}

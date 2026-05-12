// ============================================================================
// lib/core/services/auth/federated_auth_service.dart
// FEDERATED AUTH SERVICE — Interfaz cross-platform
// ============================================================================
// QUÉ HACE:
//   - Define el contrato para login federado (Google/Apple/Facebook).
//   - Permite ocultar los proveedores no soportados sin que el llamador
//     toque `Platform.isXxx`. El gate vive en `PlatformCapabilities` y
//     la ejecución vive en la impl concreta.
//
// PHASE 0:
//   - Mobile impl delega en `FirebaseAuthDS` (que ya integra google_sign_in,
//     sign_in_with_apple, flutter_facebook_auth).
//   - Desktop stub: todos los métodos retornan `FederatedAuthResult.unsupported`.
//     La UI debe esconder los botones consultando `availableProviders` o
//     `PlatformCapabilities.supportsFederatedAuth`.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';

enum FederatedProvider { google, apple, facebook }

class FederatedAuthResult {
  final UserCredential? credential;
  final _FederatedKind _kind;
  final String? errorCode;
  final String? errorMessage;

  const FederatedAuthResult._(this._kind,
      {this.credential, this.errorCode, this.errorMessage});

  factory FederatedAuthResult.success(UserCredential credential) =>
      FederatedAuthResult._(_FederatedKind.success, credential: credential);

  factory FederatedAuthResult.cancelled() =>
      const FederatedAuthResult._(_FederatedKind.cancelled);

  factory FederatedAuthResult.failure(String code, String message) =>
      FederatedAuthResult._(_FederatedKind.failure,
          errorCode: code, errorMessage: message);

  factory FederatedAuthResult.unsupported() =>
      const FederatedAuthResult._(_FederatedKind.unsupported);

  bool get isSuccess => _kind == _FederatedKind.success;
  bool get isCancelled => _kind == _FederatedKind.cancelled;
  bool get isFailure => _kind == _FederatedKind.failure;
  bool get isUnsupported => _kind == _FederatedKind.unsupported;
}

enum _FederatedKind { success, cancelled, failure, unsupported }

abstract class FederatedAuthService {
  /// Conjunto de proveedores que esta build puede ejecutar.
  Set<FederatedProvider> get availableProviders;

  Future<FederatedAuthResult> signIn(FederatedProvider provider);
}

/// Stub para plataformas sin auth federada nativa (Windows en Phase 0).
class UnsupportedFederatedAuthService implements FederatedAuthService {
  const UnsupportedFederatedAuthService();

  @override
  Set<FederatedProvider> get availableProviders => const {};

  @override
  Future<FederatedAuthResult> signIn(FederatedProvider provider) async =>
      FederatedAuthResult.unsupported();
}

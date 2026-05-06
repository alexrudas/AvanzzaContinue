// ============================================================================
// lib/domain/entities/access/access_bootstrap_result.dart
// ACCESS BOOTSTRAP RESULT — resultado de POST /v1/auth/bootstrap.
// ============================================================================
// QUÉ HACE:
// - Modela el 200 de bootstrap: ids creados/reusados + flag de refresh.
// - Expone `orgIdSource` como señal de telemetría.
//
// QUÉ NO HACE:
// - No orquesta el retry del request original. Eso es responsabilidad de
//   `AccessInterceptor` + `AccessGateway`.
// - No persiste. Bootstrap es idempotente; volver a llamarlo retorna los
//   mismos IDs.
//
// PRINCIPIOS:
// - Inmutabilidad + campos explícitos.
// - Solo plain Dart.
//
// ENTERPRISE NOTES:
// - Fuente: "Contrato de integración — Flutter ↔ Core API Access" §4.
// - `requiresTokenRefresh` actualmente es siempre `true` en servidor. El
//   cliente DEBE respetarlo (forward-compat con futura Cloud Function de
//   custom claims).
// ============================================================================

import 'access_enums.dart';

/// Resultado canónico de POST /v1/auth/bootstrap cuando retorna 200.
class AccessBootstrapResult {
  /// UUID del user en Postgres (recién creado o reutilizado).
  final String userId;

  /// UUID del workspace canónico.
  final String workspaceId;

  /// `orgId` legacy string resuelto por el servidor.
  final String activeOrgId;

  /// Origen del `activeOrgId` (token claim vs. body fallback). Telemetría.
  final BootstrapOrgIdSource orgIdSource;

  /// UUID de la membership activa entre user y workspace.
  final String membershipId;

  /// Capabilities resueltas tras bootstrap. Útil para pre-habilitar UI.
  final List<String> capabilities;

  /// Flag de forward-compatibility. Si true, el cliente DEBE
  /// `getIdToken(forceRefresh: true)` antes de continuar.
  final bool requiresTokenRefresh;

  const AccessBootstrapResult({
    required this.userId,
    required this.workspaceId,
    required this.activeOrgId,
    required this.orgIdSource,
    required this.membershipId,
    required this.capabilities,
    required this.requiresTokenRefresh,
  });

  @override
  String toString() => 'AccessBootstrapResult('
      'userId=$userId, '
      'workspaceId=$workspaceId, '
      'activeOrgId=$activeOrgId, '
      'orgIdSource=${orgIdSource.name}, '
      'capabilities=${capabilities.length}, '
      'requiresTokenRefresh=$requiresTokenRefresh)';
}

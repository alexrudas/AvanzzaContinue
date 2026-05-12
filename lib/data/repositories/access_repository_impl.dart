// ============================================================================
// lib/data/repositories/access_repository_impl.dart
// ACCESS REPOSITORY IMPL — adaptador HTTP del contrato de acceso.
// ============================================================================
// QUÉ HACE:
// - Implementa `AccessRepository` delegando en `AccessApiClient`.
// - Capa thin: no transforma ni cachea. Preserva excepciones del cliente HTTP.
//
// QUÉ NO HACE:
// - No decide política. Bootstrap/refresh/retry viven en interceptor+gateway.
// - No persiste. `AccessContext` es snapshot runtime; la durabilidad es
//   responsabilidad del caller (p. ej. `SessionCapabilitiesStore`).
//
// PRINCIPIOS:
// - Clean Architecture: domain expone contrato, data aporta impl.
// - Sin lógica añadida aquí hoy; si mañana se necesita cache de context (p.
//   ej. para splash), se agrega aquí, no en el cliente HTTP ni en el gateway.
//
// ENTERPRISE NOTES:
// - Hoy es passthrough. Documentado para que futuras extensiones (cache,
//   mirror en Isar, retry por red-flake) se mantengan en este punto.
// ============================================================================

import '../../domain/entities/access/access_bootstrap_result.dart';
import '../../domain/entities/access/access_context.dart';
import '../../domain/repositories/access_repository.dart';
import '../sources/remote/access/access_api_client.dart';

class AccessRepositoryImpl implements AccessRepository {
  final AccessApiClient _client;

  AccessRepositoryImpl({required AccessApiClient client}) : _client = client;

  @override
  Future<AccessContext> getContext() => _client.getContext();

  @override
  Future<AccessBootstrapResult> bootstrap({
    String? orgId,
    String? workspaceName,
  }) =>
      _client.bootstrap(orgId: orgId, workspaceName: workspaceName);
}

// ============================================================================
// lib/data/repositories/provider/provider_canonical_repository_impl.dart
// PROVIDER CANONICAL REPOSITORY IMPL — Thin wrapper sobre el ApiClient
//
// QUÉ HACE:
// - Implementa `ProviderCanonicalRepository` delegando en
//   `ProviderCanonicalApiClient`.
// - Sin cache local. La SSOT es Postgres via Core API.
//
// QUÉ NO HACE:
// - NO captura excepciones del client: las propaga tal cual para que el
//   controller pueda ramificar UX por excepción tipada.
// - NO orquesta `match-candidate.probe`. Eso vive en el controller.
// - NO toca `LocalContact`. El cache de `linkedProviderProfileId` vive
//   fuera de este contrato.
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26): Hito 1 — integración Flutter canónica.
// ============================================================================

import '../../../domain/entities/provider/provider_canonical_entity.dart';
import '../../../domain/repositories/provider/provider_canonical_repository.dart';
import '../../sources/remote/provider/provider_canonical_api_client.dart';

class ProviderCanonicalRepositoryImpl implements ProviderCanonicalRepository {
  final ProviderCanonicalApiClient _client;

  const ProviderCanonicalRepositoryImpl({
    required ProviderCanonicalApiClient client,
  }) : _client = client;

  @override
  Future<ProviderCanonicalEntity> provision(
    ProvisionProviderInput input,
  ) {
    return _client.provision(input);
  }

  @override
  Future<ProviderCanonicalEntity> getById(String providerProfileId) {
    return _client.getById(providerProfileId);
  }

  @override
  Future<ProviderCanonicalEntity> replaceSpecialties({
    required String providerProfileId,
    required Set<String> specialtyIds,
    required DateTime providerProfileUpdatedAt,
  }) {
    return _client.replaceSpecialties(
      providerProfileId: providerProfileId,
      specialtyIds: specialtyIds,
      providerProfileUpdatedAt: providerProfileUpdatedAt,
    );
  }
}

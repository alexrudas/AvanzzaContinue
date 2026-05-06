// ============================================================================
// lib/data/repositories/provider/provider_self_repository_impl.dart
// PROVIDER SELF REPOSITORY IMPL — adapter HTTP del contrato domain.
//
// QUÉ HACE:
//   Implementación trivial de `ProviderSelfRepository` que delega en
//   `ProviderSelfApiClient`. No mantiene estado.
//
// QUÉ NO HACE:
//   - NO cachea: M2 introducirá una capa Isar para offline-first.
//   - NO controla activeOrgId: viene del JWT vía interceptor.
// ============================================================================

import '../../../domain/entities/provider/bootstrap_provider_result_entity.dart';
import '../../../domain/entities/provider/provider_me_entity.dart';
import '../../../domain/repositories/provider/provider_self_repository.dart';
import '../../sources/remote/provider/provider_self_api_client.dart';

class ProviderSelfRepositoryImpl implements ProviderSelfRepository {
  final ProviderSelfApiClient _api;

  const ProviderSelfRepositoryImpl({required ProviderSelfApiClient api})
      : _api = api;

  @override
  Future<BootstrapProviderResultEntity> bootstrap({
    required String name,
    String? phone,
    required List<String> specialtyIds,
    List<String>? assetTypeIds,
  }) {
    return _api.bootstrap(
      name: name,
      phone: phone,
      specialtyIds: specialtyIds,
      assetTypeIds: assetTypeIds,
    );
  }

  @override
  Future<ProviderMeEntity> me() => _api.me();
}

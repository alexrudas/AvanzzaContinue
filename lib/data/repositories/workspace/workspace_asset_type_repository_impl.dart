// ============================================================================
// lib/data/repositories/workspace/workspace_asset_type_repository_impl.dart
// WORKSPACE ASSET TYPE REPOSITORY IMPL — Thin wrapper sobre el ApiClient
//
// QUÉ HACE:
// - Implementa `WorkspaceAssetTypeRepository` delegando en
//   `WorkspaceAssetTypeApiClient`. Sin cache local ni transformaciones.
//
// QUÉ NO HACE:
// - NO captura excepciones: las propaga al caller para que el controller
//   pueda razonar sobre estados (loading / vacío / error).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-26).
// ============================================================================

import '../../../domain/entities/workspace/workspace_asset_type_entity.dart';
import '../../../domain/repositories/workspace/workspace_asset_type_repository.dart';
import '../../sources/remote/workspace/workspace_asset_type_api_client.dart';

class WorkspaceAssetTypeRepositoryImpl
    implements WorkspaceAssetTypeRepository {
  final WorkspaceAssetTypeApiClient _client;

  const WorkspaceAssetTypeRepositoryImpl({
    required WorkspaceAssetTypeApiClient client,
  }) : _client = client;

  @override
  Future<List<WorkspaceAssetTypeEntity>> listActive() {
    return _client.listActive();
  }
}

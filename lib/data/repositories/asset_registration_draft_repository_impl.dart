// ============================================================================
// lib/data/repositories/asset_registration_draft_repository_impl.dart
//
// ASSET REGISTRATION DRAFT REPOSITORY IMPL — Enterprise Ultra Pro
//
// PROPÓSITO
// Implementación concreta del repositorio de draft del wizard de registro
// de activos.
//
// RESPONSABILIDAD
// - Implementar el contrato de dominio:
//     AssetRegistrationDraftRepository
// - Exponer únicamente AssetRegistrationDraftEntity hacia capas superiores
// - Delegar persistencia local a AssetRegistrationDraftLocalDataSource
// - Convertir Entity ↔ Model mediante AssetRegistrationDraftMapper
//
// NO RESPONSABILIDAD
// - No contiene lógica de negocio del wizard
// - No contiene lógica de UI
// - No contiene reglas de navegación
// - No contiene detalles de Isar fuera del mapper/local data source
//
// ESTRATEGIA DE DEPENDENCIAS
//   Domain:
//     - AssetRegistrationDraftRepository
//     - AssetRegistrationDraftEntity
//
//   Data:
//     - AssetRegistrationDraftLocalDataSource
//     - AssetRegistrationDraftMapper
//
// FLUJO DE DATOS
//   Presentation / Controller
//       ↓
//   Repository (Entity)
//       ↓
//   RepositoryImpl
//       ↓
//   Mapper
//       ↓
//   LocalDataSource (Model)
//       ↓
//   Isar
//
// ESTRATEGIA DE ERRORES
// Este repositorio deja propagar intencionalmente los errores de infraestructura
// del LocalDataSource. La capa superior (use case / controller) decide cómo
// capturarlos, traducirlos o mostrarlos.
//
// ESTRATEGIA DE UPSERT
// La preservación de `isarId` es responsabilidad del LocalDataSource.
// Este repositorio NO intenta resolver `isarId` ni hacer merges de persistencia.
// Su responsabilidad aquí es convertir Entity → Model y delegar.
//
// ============================================================================

import 'package:avanzza/data/models/asset/asset_registration_draft_mapper.dart';

import '../../domain/entities/asset/asset_registration_draft_entity.dart';
import '../../domain/repositories/asset_registration_draft_repository.dart';
import '../sources/local/asset_registration_draft_local_ds.dart';

class AssetRegistrationDraftRepositoryImpl
    implements AssetRegistrationDraftRepository {
  final AssetRegistrationDraftLocalDataSource _localDs;

  AssetRegistrationDraftRepositoryImpl(this._localDs);

  // ───────────────────────────────────────────────────────────────────────────
  // LECTURA
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<AssetRegistrationDraftEntity?> getDraft(String draftId) async {
    final model = await _localDs.getDraft(draftId);
    if (model == null) return null;
    return AssetRegistrationDraftMapper.toEntity(model);
  }

  @override
  Future<bool> hasDraft(String draftId) {
    return _localDs.hasDraft(draftId);
  }

  @override
  Future<AssetRegistrationDraftEntity?> getLatestDraftForOrg(
    String orgId,
  ) async {
    final model = await _localDs.getLatestDraftForOrg(orgId);
    if (model == null) return null;
    return AssetRegistrationDraftMapper.toEntity(model);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // ESCRITURA
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> saveDraft(AssetRegistrationDraftEntity draft) async {
    final model = AssetRegistrationDraftMapper.toModel(draft);
    await _localDs.saveDraft(model);
  }

  @override
  Future<void> deleteDraft(String draftId) {
    return _localDs.deleteDraft(draftId);
  }

  @override
  Future<int> deleteDraftsByOrg(String orgId) {
    return _localDs.deleteDraftsByOrg(orgId);
  }

  @override
  Future<void> clearAll() {
    return _localDs.clearAll();
  }
}

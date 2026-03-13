// ============================================================================
// lib/data/mappers/asset/asset_registration_draft_mapper.dart
//
// ASSET REGISTRATION DRAFT MAPPER — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Convertir entre la entidad de dominio (AssetRegistrationDraftEntity)
// y el modelo de persistencia Isar (AssetRegistrationDraftModel).
//
// ARQUITECTURA
// Este mapper vive exclusivamente en la capa DATA.
//
// Dependencias permitidas:
//
//   DATA → Domain Entity
//   DATA → Persistence Model
//
// Domain NUNCA depende de este archivo.
//
// FLUJO CORRECTO
//
//   UI
//     ↓
//   Controller
//     ↓
//   UseCase
//     ↓
//   Repository (Domain Entity)
//     ↓
//   RepositoryImpl (usa Mapper)
//     ↓
//   LocalDataSource (Isar)
//     ↓
//   AssetRegistrationDraftModel
//
// RESPONSABILIDAD
// - Conversión Entity ↔ Model
// - Preservar invariantes de mapeo
// - Nunca introducir lógica de negocio
//
// NOTA SOBRE isarId
// El dominio NO conoce el identificador interno de Isar.
// Por tanto:
//
//   Entity → Model no incluye isarId
//
// Cuando se requiere preservar isarId (upsert),
// RepositoryImpl debe usar el método:
//
//   toModelPreservingId(...)
//
// ============================================================================

import '../../../domain/entities/asset/asset_registration_draft_entity.dart';
import '../../models/asset/asset_registration_draft_model.dart';

/// Mapper utilitario para convertir:
///
/// AssetRegistrationDraftEntity ↔ AssetRegistrationDraftModel
///
/// No es instanciable.
class AssetRegistrationDraftMapper {
  AssetRegistrationDraftMapper._();

  // ─────────────────────────────────────────────────────────────────────────
  // Entity → Model
  // ─────────────────────────────────────────────────────────────────────────

  /// Convierte una entidad de dominio en un modelo Isar.
  ///
  /// Este método NO preserva `isarId`.
  /// Úsalo cuando se crea un registro nuevo.
  static AssetRegistrationDraftModel toModel(
    AssetRegistrationDraftEntity entity,
  ) {
    _validateEntity(entity);

    return AssetRegistrationDraftModel()
      ..draftId = entity.draftId
      ..orgId = entity.orgId

      // Step 1
      ..assetType = entity.assetType
      ..portfolioName = entity.portfolioName
      ..countryId = entity.countryId
      ..regionId = entity.regionId
      ..cityId = entity.cityId

      // Step 2 input
      ..documentType = entity.documentType
      ..documentNumber = entity.documentNumber
      ..plate = entity.plate

      // RUNT job state
      ..runtJobId = entity.runtJobId
      ..runtStatus = entity.runtStatus
      ..runtProgressPercent = entity.runtProgressPercent
      ..runtErrorMessage = entity.runtErrorMessage
      ..runtProgressJson = entity.runtProgressJson
      ..runtPartialDataJson = entity.runtPartialDataJson
      ..runtVehicleDataJson = entity.runtVehicleDataJson
      ..runtUpdatedAt = entity.runtUpdatedAt
      ..runtCompletedAt = entity.runtCompletedAt

      // Control
      ..updatedAt = entity.updatedAt;
  }

  /// Convierte una entidad a modelo preservando el `isarId`.
  ///
  /// Usado en actualizaciones (upsert) donde el registro ya existe.
  static AssetRegistrationDraftModel toModelPreservingId(
    AssetRegistrationDraftEntity entity,
    AssetRegistrationDraftModel existingModel,
  ) {
    final model = toModel(entity);
    model.isarId = existingModel.isarId;
    return model;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Model → Entity
  // ─────────────────────────────────────────────────────────────────────────

  /// Convierte un modelo Isar en entidad de dominio.
  ///
  /// El `isarId` se descarta intencionalmente porque el dominio
  /// no debe conocer detalles de infraestructura.
  static AssetRegistrationDraftEntity toEntity(
    AssetRegistrationDraftModel model,
  ) {
    return AssetRegistrationDraftEntity(
      draftId: model.draftId,
      orgId: model.orgId,

      // Step 1
      assetType: model.assetType,
      portfolioName: model.portfolioName,
      countryId: model.countryId,
      regionId: model.regionId,
      cityId: model.cityId,

      // Step 2 input
      documentType: model.documentType,
      documentNumber: model.documentNumber,
      plate: model.plate,

      // RUNT job state
      runtJobId: model.runtJobId,
      runtStatus: model.runtStatus,
      runtProgressPercent: model.runtProgressPercent,
      runtErrorMessage: model.runtErrorMessage,
      runtProgressJson: model.runtProgressJson,
      runtPartialDataJson: model.runtPartialDataJson,
      runtVehicleDataJson: model.runtVehicleDataJson,
      runtUpdatedAt: model.runtUpdatedAt,
      runtCompletedAt: model.runtCompletedAt,

      // Control
      updatedAt: model.updatedAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Batch helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Convierte una lista de modelos a entidades.
  static List<AssetRegistrationDraftEntity> toEntityList(
    List<AssetRegistrationDraftModel> models,
  ) {
    return models.map(toEntity).toList(growable: false);
  }

  /// Convierte una lista de entidades a modelos.
  static List<AssetRegistrationDraftModel> toModelList(
    List<AssetRegistrationDraftEntity> entities,
  ) {
    return entities.map(toModel).toList(growable: false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Validación interna
  // ─────────────────────────────────────────────────────────────────────────

  /// Validaciones defensivas mínimas para evitar persistencia corrupta.
  static void _validateEntity(AssetRegistrationDraftEntity entity) {
    assert(
      entity.draftId.trim().isNotEmpty,
      'AssetRegistrationDraftEntity.draftId no puede estar vacío',
    );

    assert(
      entity.orgId.trim().isNotEmpty,
      'AssetRegistrationDraftEntity.orgId no puede estar vacío',
    );

    assert(
      entity.assetType.trim().isNotEmpty,
      'AssetRegistrationDraftEntity.assetType no puede estar vacío',
    );
  }
}

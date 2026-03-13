// ============================================================================
// lib/domain/repositories/asset_registration_draft_repository.dart
//
// Contrato de dominio para persistir y recuperar el draft del wizard de
// registro de activos.
//
// PRINCIPIOS
// - El dominio NO depende de la capa data.
// - El repositorio trabaja exclusivamente con entidades de dominio.
// - La implementación concreta puede usar Isar, SQLite, API, etc.
// ============================================================================

import '../entities/asset/asset_registration_draft_entity.dart';

abstract class AssetRegistrationDraftRepository {
  /// Obtiene el draft por su identificador funcional.
  ///
  /// Devuelve null si no existe.
  Future<AssetRegistrationDraftEntity?> getDraft(String draftId);

  /// Guarda o actualiza el draft.
  ///
  /// La estrategia exacta de persistencia queda a cargo de la implementación.
  Future<void> saveDraft(AssetRegistrationDraftEntity draft);

  /// Elimina el draft asociado al [draftId].
  Future<void> deleteDraft(String draftId);

  /// Indica si existe un draft para ese identificador.
  Future<bool> hasDraft(String draftId);

  /// Obtiene el draft más reciente para una organización.
  Future<AssetRegistrationDraftEntity?> getLatestDraftForOrg(String orgId);

  /// Elimina todos los drafts asociados a una organización.
  Future<int> deleteDraftsByOrg(String orgId);

  /// Limpia todos los drafts persistidos.
  Future<void> clearAll();
}

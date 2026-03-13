// ============================================================================
// lib/data/sources/local/asset_registration_draft_local_ds.dart
//
// ASSET REGISTRATION DRAFT LOCAL DATA SOURCE — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Fuente de datos local (Isar) para persistir el draft del wizard de registro
// de activos.
//
// RESPONSABILIDAD
// - CRUD sobre AssetRegistrationDraftModel
// - búsquedas por draftId / orgId
// - upsert seguro por draftId lógico
//
// NO RESPONSABILIDAD
// - No contiene lógica de negocio
// - No decide reglas del wizard
// - No transforma modelos de dominio
// - No contiene lógica de UI
//
// ESTRATEGIA DE ERRORES
// Este data source deja propagar errores de Isar deliberadamente.
// La capa repositorio / use case es responsable de capturarlos, traducirlos
// o enriquecerlos según la política de infraestructura del proyecto.
//
// DECISIÓN IMPORTANTE
// Aunque AssetRegistrationDraftModel tiene:
//
//   @Index(unique: true, replace: true) sobre draftId
//
// este data source implementa un upsert EXPLÍCITO por draftId para:
//
// - preservar isarId correctamente
// - hacer el comportamiento más obvio al leer el código
// - evitar ambigüedad semántica en mantenimiento futuro
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../../models/asset/asset_registration_draft_model.dart';

class AssetRegistrationDraftLocalDataSource {
  final Isar _isar;

  AssetRegistrationDraftLocalDataSource(this._isar);

  // ───────────────────────────────────────────────────────────────────────────
  // LECTURA
  // ───────────────────────────────────────────────────────────────────────────

  /// Obtiene un draft por [draftId].
  ///
  /// Devuelve null si no existe.
  Future<AssetRegistrationDraftModel?> getDraft(String draftId) async {
    final normalizedDraftId = _normalizeDraftId(draftId);
    if (normalizedDraftId == null) return null;

    return _isar.assetRegistrationDraftModels
        .where()
        .draftIdEqualTo(normalizedDraftId)
        .findFirst();
  }

  /// Indica si existe un draft para [draftId].
  Future<bool> hasDraft(String draftId) async {
    final normalizedDraftId = _normalizeDraftId(draftId);
    if (normalizedDraftId == null) return false;

    final count = await _isar.assetRegistrationDraftModels
        .where()
        .draftIdEqualTo(normalizedDraftId)
        .count();

    return count > 0;
  }

  /// Retorna todos los drafts guardados.
  ///
  /// Útil para debugging, soporte o estrategias de limpieza.
  Future<List<AssetRegistrationDraftModel>> getAllDrafts() async {
    return _isar.assetRegistrationDraftModels.where().findAll();
  }

  /// Obtiene el draft más reciente para una organización.
  ///
  /// Ordenado por [updatedAt] descendente.
  /// Devuelve null si no existe ninguno.
  Future<AssetRegistrationDraftModel?> getLatestDraftForOrg(
      String orgId) async {
    final normalizedOrgId = _normalizeRequiredValue(
      orgId,
      fieldName: 'orgId',
    );
    if (normalizedOrgId == null) return null;

    final drafts = await _isar.assetRegistrationDraftModels
        .filter()
        .orgIdEqualTo(normalizedOrgId)
        .sortByUpdatedAtDesc()
        .findAll();

    if (drafts.isEmpty) return null;
    return drafts.first;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // ESCRITURA
  // ───────────────────────────────────────────────────────────────────────────

  /// Guarda o actualiza un draft usando [draftId] como clave lógica.
  ///
  /// Comportamiento:
  /// - si no existe draft con ese draftId → crea uno nuevo
  /// - si ya existe → preserva el isarId existente y actualiza el registro
  ///
  /// Esto hace explícito el upsert por draftId.
  Future<void> saveDraft(AssetRegistrationDraftModel draft) async {
    final normalizedDraftId = _normalizeRequiredValue(
      draft.draftId,
      fieldName: 'draftId',
    );
    if (normalizedDraftId == null) {
      throw ArgumentError('draftId no puede estar vacío.');
    }

    await _isar.writeTxn(() async {
      final existing = await _isar.assetRegistrationDraftModels
          .where()
          .draftIdEqualTo(normalizedDraftId)
          .findFirst();

      if (existing != null) {
        draft.isarId = existing.isarId;
      }

      await _isar.assetRegistrationDraftModels.put(draft);
    });

    _debugLog(
      'saveDraft',
      'draftId=${draft.draftId} '
          'orgId=${draft.orgId} '
          'status=${draft.runtStatus} '
          'updatedAt=${draft.updatedAt.toIso8601String()}',
    );
  }

  /// Elimina el draft asociado a [draftId].
  ///
  /// No falla si no existe.
  Future<void> deleteDraft(String draftId) async {
    final normalizedDraftId = _normalizeDraftId(draftId);
    if (normalizedDraftId == null) return;

    await _isar.writeTxn(() async {
      final existing = await _isar.assetRegistrationDraftModels
          .where()
          .draftIdEqualTo(normalizedDraftId)
          .findFirst();

      if (existing != null) {
        await _isar.assetRegistrationDraftModels.delete(existing.isarId);
      }
    });

    _debugLog('deleteDraft', 'draftId=$normalizedDraftId');
  }

  /// Elimina todos los drafts de una organización.
  ///
  /// Útil para limpieza controlada por contexto.
  Future<int> deleteDraftsByOrg(String orgId) async {
    final normalizedOrgId = _normalizeRequiredValue(
      orgId,
      fieldName: 'orgId',
    );
    if (normalizedOrgId == null) return 0;

    late int deletedCount;

    await _isar.writeTxn(() async {
      final drafts = await _isar.assetRegistrationDraftModels
          .filter()
          .orgIdEqualTo(normalizedOrgId)
          .findAll();

      deletedCount = drafts.length;

      for (final draft in drafts) {
        await _isar.assetRegistrationDraftModels.delete(draft.isarId);
      }
    });

    _debugLog(
      'deleteDraftsByOrg',
      'orgId=$normalizedOrgId deleted=$deletedCount',
    );

    return deletedCount;
  }

  /// Elimina TODOS los drafts guardados.
  ///
  /// Útil para logout, reset de sesión o limpieza administrativa.
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.assetRegistrationDraftModels.clear();
    });

    _debugLog('clearAll', 'all drafts deleted');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HELPERS PRIVADOS
  // ───────────────────────────────────────────────────────────────────────────

  String? _normalizeDraftId(String draftId) {
    final value = draftId.trim();
    return value.isEmpty ? null : value;
  }

  String? _normalizeRequiredValue(
    String value, {
    required String fieldName,
  }) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      _debugLog('validation', '$fieldName vacío');
      return null;
    }
    return normalized;
  }

  void _debugLog(String action, String message) {
    if (kDebugMode) {
      debugPrint('[AssetDraftLocalDS][$action] $message');
    }
  }
}

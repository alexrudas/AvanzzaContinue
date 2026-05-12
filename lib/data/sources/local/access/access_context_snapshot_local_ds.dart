// ============================================================================
// lib/data/sources/local/access/access_context_snapshot_local_ds.dart
// LocalAccessSnapshotDS — CRUD de AccessContextSnapshotModel sobre Isar.
// ============================================================================
// QUÉ HACE:
//   API mínima de lectura/escritura/borrado del snapshot keyed por el par
//   (userId, workspaceId). Es el ÚNICO punto que toca Isar para esta
//   colección — `AccessSnapshotService` lo usa exclusivamente.
//
// QUÉ NO HACE:
//   - No aplica políticas de staleness (eso vive en `AccessSnapshotService`).
//   - No conoce `AccessContext` (entidad de dominio). Trabaja con el modelo
//     Isar directo.
//   - No emite streams (lectura puntual en cold start es suficiente).
//   - No conoce composite key formatting — recibe (userId, workspaceId)
//     y delega a `AccessContextSnapshotModel.makeCompositeKey`.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/access/access_context_snapshot_model.dart';

class LocalAccessSnapshotDS {
  final Isar _isar;

  const LocalAccessSnapshotDS(this._isar);

  /// Lee la fila para `(userId, workspaceId)`. Retorna null si no existe
  /// o si Isar arroja (corrupción / schema drift). El caller debe tratar
  /// null como "sin snapshot local".
  Future<AccessContextSnapshotModel?> read(
    String userId,
    String workspaceId,
  ) async {
    try {
      final key =
          AccessContextSnapshotModel.makeCompositeKey(userId, workspaceId);
      return await _isar.accessContextSnapshotModels
          .filter()
          .compositeKeyEqualTo(key)
          .findFirst();
    } catch (_) {
      return null;
    }
  }

  /// Lee TODAS las filas para `userId` — útil para listar workspaces con
  /// snapshot local en pickers de workspace switching.
  Future<List<AccessContextSnapshotModel>> readAllForUser(
    String userId,
  ) async {
    try {
      return await _isar.accessContextSnapshotModels
          .filter()
          .userIdEqualTo(userId)
          .findAll();
    } catch (_) {
      return const [];
    }
  }

  /// Upsert atómico. El índice unique-replace sobre `compositeKey` garantiza
  /// que una segunda escritura para el mismo (userId, workspaceId)
  /// sobrescribe en lugar de duplicar.
  Future<void> upsert(AccessContextSnapshotModel snapshot) async {
    await _isar.writeTxn(() async {
      await _isar.accessContextSnapshotModels.put(snapshot);
    });
  }

  /// Borra UNA fila — la del par `(userId, workspaceId)`. Idempotente.
  /// Usado en workspace switch (el snapshot del workspace abandonado se
  /// invalida) y en 401/403 sobre ese workspace específico.
  Future<void> deleteByWorkspace(String userId, String workspaceId) async {
    final key =
        AccessContextSnapshotModel.makeCompositeKey(userId, workspaceId);
    await _isar.writeTxn(() async {
      await _isar.accessContextSnapshotModels
          .filter()
          .compositeKeyEqualTo(key)
          .deleteAll();
    });
  }

  /// Borra TODAS las filas de `userId` — todos sus workspaces. Usado en
  /// logout. Idempotente (no-op si no existían).
  Future<void> deleteByUser(String userId) async {
    await _isar.writeTxn(() async {
      await _isar.accessContextSnapshotModels
          .filter()
          .userIdEqualTo(userId)
          .deleteAll();
    });
  }

  /// Borra TODAS las filas. Útil para tests y para reset total de cache
  /// (factory reset en-app, debug menu).
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.accessContextSnapshotModels.clear();
    });
  }
}

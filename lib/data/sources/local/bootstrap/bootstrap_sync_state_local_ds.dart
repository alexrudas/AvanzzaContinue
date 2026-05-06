// ============================================================================
// lib/data/sources/local/bootstrap/bootstrap_sync_state_local_ds.dart
// BOOTSTRAP SYNC STATE — Isar data source. Acceso CRUD por userId.
// ============================================================================
// QUÉ HACE:
//   - Lee/escribe la fila única `BootstrapSyncStateModel` por `userId`.
//   - Provee primitivas que el `BootstrapSyncController` usa para hidratar
//     y persistir transiciones del state machine.
//
// QUÉ NO HACE:
//   - NO conoce la lógica de retry/backoff. Solo persiste lo que el
//     controller le pide.
//   - NO observa cambios reactivos (el controller mantiene el Rx en
//     memoria; Isar es solo persistencia).
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../models/bootstrap/bootstrap_sync_state_model.dart';

class BootstrapSyncStateLocalDS {
  final Isar _isar;

  /// TTL por defecto del `payloadJson` persistido. Se evalúa contra
  /// `updatedAt` durante la rehidratación: si la fila lleva más de este
  /// tiempo sin ninguna transición, el payload se considera obsoleto y
  /// se limpia (write-back) para no reanimar un retry contra un cuerpo
  /// que el backend pudo haber cambiado de contrato.
  ///
  /// Diseño aditivo: no requiere campo nuevo en el modelo (usa el
  /// `updatedAt` existente). Una fila con retries activos (transiciones
  /// frecuentes) refresca `updatedAt` y mantiene el payload "vivo"; una
  /// fila atascada sin retries durante más de [defaultPayloadTtl]
  /// pierde el payload y queda inerte hasta el próximo `start()` con
  /// payload fresco.
  static const Duration defaultPayloadTtl = Duration(days: 7);

  const BootstrapSyncStateLocalDS(this._isar);

  /// Lee la fila por userId. Null si no existe.
  ///
  /// **Pure read**: no escribe ni evalúa staleness. Para rehidratación
  /// con limpieza automática, usar [getByUserIdEvictingStalePayload].
  Future<BootstrapSyncStateModel?> getByUserId(String userId) async {
    if (userId.isEmpty) return null;
    return _isar.bootstrapSyncStateModels
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
  }

  /// Lee la fila por userId limpiando `payloadJson` si excede [ttl].
  ///
  /// Comportamiento:
  ///   - Si la fila no existe ⇒ retorna `null` (sin escritura).
  ///   - Si la fila no tiene `payloadJson` ⇒ retorna tal cual.
  ///   - Si `now - updatedAt <= ttl` ⇒ retorna tal cual.
  ///   - Si `now - updatedAt > ttl` ⇒ limpia `payloadJson` con
  ///     `upsert(clearPayload: true)` y retorna un snapshot in-memory
  ///     con `payloadJson = null`.
  ///
  /// El reloj inyectable en [now] permite tests deterministas; default
  /// es `DateTime.now().toUtc()`.
  Future<BootstrapSyncStateModel?> getByUserIdEvictingStalePayload(
    String userId, {
    Duration ttl = defaultPayloadTtl,
    DateTime Function()? now,
  }) async {
    if (userId.isEmpty) return null;
    final row = await _isar.bootstrapSyncStateModels
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    if (row == null || row.payloadJson == null) return row;

    final clock = now ?? () => DateTime.now().toUtc();
    final age = clock().difference(row.updatedAt);
    if (age <= ttl) return row;

    // Stale: limpiamos el payload y retornamos snapshot in-memory.
    await upsert(userId: userId, clearPayload: true);
    row.payloadJson = null;
    return row;
  }

  /// Upsert de la fila. Si no existe, la crea con `createdAt=updatedAt=now`.
  /// Si existe, mergea los cambios provistos (campos null no sobrescriben,
  /// salvo los explícitos `clear*` flags).
  ///
  /// **CONTRATO DE TRANSICIÓN ÚNICA**: el caller (`BootstrapSyncController`)
  /// invoca esta función UNA SOLA VEZ por cada cambio de estado válido,
  /// agrupando en un único upsert todos los campos que cambian juntos
  /// (status + attempts + lastAttemptAt + lastError + requiresTokenRefresh
  /// + payloadJson). Evita doble-write y deja el storage consistente
  /// siempre — si el proceso muere a mitad de transacción, Isar revierte.
  Future<void> upsert({
    required String userId,
    BootstrapSyncStatusModel? status,
    int? attempts,
    DateTime? lastAttemptAt,
    String? lastError,
    bool? requiresTokenRefresh,
    String? payloadJson,
    /// Cuando es `true`, fuerza `lastError = null` (limpia errores previos).
    /// Necesario porque pasar `null` directo se interpreta como "no tocar".
    bool clearLastError = false,
    /// Cuando es `true`, fuerza `payloadJson = null` (logout / reset).
    bool clearPayload = false,
  }) async {
    final now = DateTime.now().toUtc();
    await _isar.writeTxn(() async {
      final existing = await _isar.bootstrapSyncStateModels
          .filter()
          .userIdEqualTo(userId)
          .findFirst();
      final row = existing ?? (BootstrapSyncStateModel()
        ..userId = userId
        ..status = BootstrapSyncStatusModel.idle
        ..attempts = 0
        ..requiresTokenRefresh = false
        ..createdAt = now
        ..updatedAt = now);

      if (status != null) row.status = status;
      if (attempts != null) row.attempts = attempts;
      if (lastAttemptAt != null) row.lastAttemptAt = lastAttemptAt;
      if (clearLastError) {
        row.lastError = null;
      } else if (lastError != null) {
        row.lastError = lastError;
      }
      if (requiresTokenRefresh != null) {
        row.requiresTokenRefresh = requiresTokenRefresh;
      }
      if (clearPayload) {
        row.payloadJson = null;
      } else if (payloadJson != null) {
        row.payloadJson = payloadJson;
      }
      row.updatedAt = now;

      await _isar.bootstrapSyncStateModels.put(row);
    });
  }

  /// Borra la fila. Útil en logout / reset por debug. No lanza si no existe.
  Future<void> deleteByUserId(String userId) async {
    if (userId.isEmpty) return;
    await _isar.writeTxn(() async {
      await _isar.bootstrapSyncStateModels
          .filter()
          .userIdEqualTo(userId)
          .deleteFirst();
    });
  }
}

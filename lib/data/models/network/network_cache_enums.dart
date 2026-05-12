// ============================================================================
// lib/data/models/network/network_cache_enums.dart
// Enums wire-stable para cache local de "Mi Red" (Isar).
// ============================================================================
// Persistencia: Isar serializa por nombre (`EnumType.name`). Mantener orden y
// nombres estables. Agregar valores nuevos al FINAL del enum, nunca renombrar
// ni eliminar — un valor desconocido al deserializar degrada a default seguro
// vía `tryFromName`.
// ============================================================================

/// Origen del registro cacheado.
///
/// V1: todos los registros que entran a cache se escriben con
/// `serverRefresh` (no se ejecuta creación optimista en V1).
/// V2+ (preparado, no implementado): `localOptimistic` se usará cuando el
/// usuario registre un actor offline antes de confirmación del backend.
enum NetworkCacheSource {
  /// Vino de una respuesta exitosa de Core API.
  serverRefresh,

  /// Creado/editado localmente, aún sin confirmación del backend.
  localOptimistic,
}

/// Estado de sincronización del registro individual.
///
/// V1: todos los registros se persisten con `confirmed` (refresh trae datos
/// ya confirmados por backend). V2+: estados pending/failed se usan para
/// optimistic writes.
enum NetworkCacheSyncState {
  /// Backend confirmó este registro (o fue traído por refresh exitoso).
  confirmed,

  /// Creado localmente, push pendiente.
  pendingCreate,

  /// Editado localmente, push pendiente.
  pendingUpdate,

  /// Marcado para eliminación local, push pendiente.
  pendingDelete,

  /// Último intento de push falló (4xx/5xx/red). Reintentos en sync engine.
  syncFailed,
}

/// Estado de la última sincronización a nivel de SECCIÓN
/// (NetworkSectionMetaModel). Independiente del estado por-actor.
enum NetworkSectionSyncStatus {
  /// Último refresh remoto fue exitoso (2xx + datos consistentes).
  confirmed,

  /// Último refresh falló (timeout, 5xx, red caída, etc.). La cache local
  /// sigue siendo válida para render; el banner UX informa al usuario.
  syncFailed,
}

/// Degradación segura ante valor desconocido al deserializar.
NetworkCacheSource networkCacheSourceFromName(String? name) {
  for (final v in NetworkCacheSource.values) {
    if (v.name == name) return v;
  }
  return NetworkCacheSource.serverRefresh;
}

NetworkCacheSyncState networkCacheSyncStateFromName(String? name) {
  for (final v in NetworkCacheSyncState.values) {
    if (v.name == name) return v;
  }
  return NetworkCacheSyncState.confirmed;
}

NetworkSectionSyncStatus networkSectionSyncStatusFromName(String? name) {
  for (final v in NetworkSectionSyncStatus.values) {
    if (v.name == name) return v;
  }
  return NetworkSectionSyncStatus.syncFailed;
}

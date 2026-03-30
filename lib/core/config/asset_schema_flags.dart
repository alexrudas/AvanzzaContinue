// ============================================================================
// lib/core/config/asset_schema_flags.dart
// ASSET SCHEMA FLAGS — Feature flag para schema v1.3.4
//
// QUÉ HACE:
// - Controla qué builder de escritura usa AssetSyncDispatcher por asset.
// - Fuente: Firestore `feature_flags/{assetId}` o `feature_flags/global`.
// - Cache en memoria con TTL de 5 minutos por assetId.
// - Fallback seguro: `false` (legacy) si Firestore falla o el flag no existe.
// - Invalida caché activamente en dos momentos:
//   (a) App resume → via AssetSyncLifecycleObserver.startIfResumed().
//   (b) Dispatcher detecta mismatch de schema → forceRefresh(assetId).
//
// QUÉ NO HACE:
// - No controla la LECTURA desde Firestore (esa lógica vive en el adapter).
// - No toma decisiones de negocio — solo reporta el valor del flag.
// - No lanza excepciones al caller (fallback silencioso a `false`).
//
// PRINCIPIOS:
// - El flag decide ÚNICAMENTE qué builder usar en la escritura.
// - `metadata.schemaVersion` en el outbox entry es solo informativo.
// - Flag desactivado = rollback inmediato sin redeploy.
// - Un flag asset-specific con campo explícito sobreescribe el flag global.
// - Si el doc asset-specific existe PERO no contiene el campo del flag,
//   se hace fallback al global.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// WIRING: registrar en lib/core/di/container.dart — Fase 6.
// INVALIDACIÓN:
//   - AssetSyncLifecycleObserver.startIfResumed() → invalidateAll()
//   - AssetSyncDispatcher._processEntry() al detectar mismatch → forceRefresh(id)
//
// NOTA DE FRESCURA:
// - `Source.serverAndCache` es best-effort freshness, no garantía dura.
// - La frescura real se refuerza con invalidateAll() en resume y forceRefresh().
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONSTANTES
// ─────────────────────────────────────────────────────────────────────────────

const _kTtl = Duration(minutes: 5);
const _kGlobalDocId = 'global';
const _kFlagField = 'schema_v2_enabled';
const _kCollection = 'feature_flags';

// ─────────────────────────────────────────────────────────────────────────────
// CACHE ENTRY
// ─────────────────────────────────────────────────────────────────────────────

final class _CacheEntry {
  final bool value;
  final DateTime fetchedAt;

  const _CacheEntry({required this.value, required this.fetchedAt});

  bool get isExpired => DateTime.now().difference(fetchedAt) > _kTtl;
}

// ─────────────────────────────────────────────────────────────────────────────
// SERVICE
// ─────────────────────────────────────────────────────────────────────────────

/// Proveedor de feature flags para el schema de activos.
///
/// Inyectar vía DIContainer. Nunca instanciar directamente en controllers.
class AssetSchemaFlags {
  final FirebaseFirestore _firestore;

  /// Cache en memoria: assetId → CacheEntry.
  final _cache = <String, _CacheEntry>{};

  /// Cache de flag global (documento `feature_flags/global`).
  _CacheEntry? _globalCache;

  AssetSchemaFlags({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ==========================================================================
  // API PÚBLICA
  // ==========================================================================

  /// Retorna `true` si el schema v1.3.4 está habilitado para [assetId].
  ///
  /// Prioridad:
  /// 1. Cache asset-specific (si no expirado).
  /// 2. Firestore `feature_flags/{assetId}` — si existe Y contiene el campo.
  /// 3. Firestore `feature_flags/global` — fallback por defecto.
  /// 4. Fallback `false` (legacy) si Firestore falla.
  ///
  /// Nunca lanza excepción — retorna `false` en cualquier error.
  Future<bool> isSchemaV2Enabled(String assetId) async {
    final cached = _cache[assetId];
    if (cached != null && !cached.isExpired) return cached.value;

    try {
      final assetDoc = await _firestore
          .collection(_kCollection)
          .doc(assetId)
          .get(const GetOptions(source: Source.serverAndCache));

      final assetData = assetDoc.data();

      // El doc asset-specific solo manda si contiene el campo explícitamente.
      if (assetDoc.exists &&
          assetData != null &&
          assetData.containsKey(_kFlagField)) {
        final now = DateTime.now();
        final value = assetData[_kFlagField] as bool? ?? false;
        _cache[assetId] = _CacheEntry(value: value, fetchedAt: now);
        return value;
      }

      // Si no existe o no contiene el campo, cae al global.
      return _fetchGlobal();
    } catch (e) {
      _debugLog('isSchemaV2Enabled($assetId) error: $e — fallback false');
      return false;
    }
  }

  /// Invalida el caché de [assetId] forzando un re-fetch en la próxima llamada.
  ///
  /// Llamar cuando el dispatcher detecta un mismatch de schema en Firestore.
  void forceRefresh(String assetId) {
    _cache.remove(assetId);
    _debugLog('forceRefresh: cache invalidado para $assetId');
  }

  /// Invalida todo el caché (asset-specific y global).
  ///
  /// Llamar desde AssetSyncLifecycleObserver.startIfResumed().
  void invalidateAll() {
    _cache.clear();
    _globalCache = null;
    _debugLog('invalidateAll: caché completo invalidado');
  }

  // ==========================================================================
  // PRIVADOS
  // ==========================================================================

  Future<bool> _fetchGlobal() async {
    final globalCached = _globalCache;
    if (globalCached != null && !globalCached.isExpired) {
      return globalCached.value;
    }

    try {
      final globalDoc = await _firestore
          .collection(_kCollection)
          .doc(_kGlobalDocId)
          .get(const GetOptions(source: Source.serverAndCache));

      final now = DateTime.now();
      final value = globalDoc.data()?[_kFlagField] as bool? ?? false;
      _globalCache = _CacheEntry(value: value, fetchedAt: now);
      return value;
    } catch (e) {
      _debugLog('_fetchGlobal error: $e — fallback false');
      return false;
    }
  }

  void _debugLog(String message) {
    if (kDebugMode) debugPrint('[AssetSchemaFlags] $message');
  }
}

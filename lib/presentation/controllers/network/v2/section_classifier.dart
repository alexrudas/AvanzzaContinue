// ============================================================================
// lib/presentation/controllers/network/v2/section_classifier.dart
// FUNCIÓN PURA — clasifica (cache + meta + último intento remoto) en un
// SectionUiState. Single-source-of-truth de Freshness para Mi Red.
// ============================================================================
// REGLA DURA:
//   Este archivo es el ÚNICO lugar del codebase que deriva `Freshness` a
//   partir de umbrales (Duration). Cualquier código que necesite freshness
//   debe llamar `classifyFreshness(...)` o leer `SectionLoaded.freshness`.
//   PROHIBIDO duplicar `Duration(minutes: 5)`, `Duration(days: 3)`,
//   `Duration(days: 30)` juntos en otro archivo de `lib/`.
//
//   Enforce: ver `test/architecture/freshness_single_source_test.dart`.
//
// CONTRATO DE classifySection:
//   - Sin efectos. Sin Isar. Sin Dio. Sin Rx.
//   - Determinístico para un input dado.
//   - Garantiza que ConnectionError NUNCA se renderiza como EmptyReal.
//   - Garantiza que un fallo remoto con cache presente NO descarta la cache:
//     devuelve SectionLoaded con SyncFailedBanner.
//   - Es seguro pasar `meta == null` con `items.isNotEmpty`: defaultea
//     freshness a longUnsynced (conservador).
// ============================================================================

import 'package:avanzza/data/models/network/network_cache_enums.dart';
import 'package:avanzza/data/models/network/network_section_meta_model.dart';
import 'package:avanzza/data/repositories/network/refresh_network_outcome.dart';
import 'package:avanzza/presentation/controllers/network/v2/section_ui_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UMBRALES DE FRESHNESS — ÚNICA DEFINICIÓN AUTORIZADA EN EL CODEBASE.
// ─────────────────────────────────────────────────────────────────────────────
const _kFreshUpper = Duration(minutes: 5);
const _kStaleUpper = Duration(days: 3);
const _kVeryStaleUpper = Duration(days: 30);

/// Deriva la freshness de la cache para una sección. Single-source-of-truth.
///
/// El llamador típicamente solo invoca esta función cuando hay items
/// presentes (freshness no es relevante cuando la sección está en
/// Bootstrap, EmptyReal o Error).
///
/// Política de defaults:
///   - `meta.lastSyncedAt == null` → `longUnsynced` (no podemos verificar
///     edad, conservador).
///   - `meta.projectionSchemaVersion < kCurrent` → `longUnsynced` (schema
///     desfasado).
///   - resto: por edad calculada vía `now.difference(lastSyncedAt)`.
Freshness classifyFreshness({
  required NetworkSectionMetaModel? meta,
  required DateTime now,
}) {
  if (meta == null || meta.lastSyncedAt == null) {
    return Freshness.longUnsynced;
  }
  if (meta.projectionSchemaVersion <
      NetworkSectionMetaModel.kCurrentProjectionSchemaVersion) {
    return Freshness.longUnsynced;
  }
  final age = now.difference(meta.lastSyncedAt!);
  if (age <= _kFreshUpper) return Freshness.fresh;
  if (age <= _kStaleUpper) return Freshness.stale;
  if (age <= _kVeryStaleUpper) return Freshness.veryStale;
  return Freshness.longUnsynced;
}

/// Función PURA — Reduce (workspaceId, items, meta, lastRefreshOutcome, now)
/// a un `SectionUiState`. Esta es la barrera principal contra "empty falso":
/// nunca devuelve `SectionEmptyReal` si hay fallo remoto.
///
/// Parámetros:
///   - [items] lista de proyecciones leídas de Isar. Puede estar vacía.
///   - [meta] meta de la sección. `null` si nunca se intentó refresh.
///   - [lastRefreshOutcome] resultado del último refresh remoto en esta
///     sesión. `null` si aún no se ha intentado.
///   - [extraBanners] banners adicionales producidos por capas externas
///     (ej. `UnmappedCategoriesBanner` del bucketizer).
SectionUiState<T> classifySection<T>({
  required String workspaceId,
  required List<T> items,
  required NetworkSectionMetaModel? meta,
  required RefreshNetworkOutcome? lastRefreshOutcome,
  required DateTime now,
  List<SectionBanner> extraBanners = const [],
}) {
  // ── 1. HAY ITEMS → siempre Loaded, con banners según contexto.
  if (items.isNotEmpty) {
    final freshness = classifyFreshness(meta: meta, now: now);
    final banners = <SectionBanner>[];

    // SyncFailedBanner: el último intento remoto falló, o meta refleja fallo
    // pendiente desde una sesión anterior.
    final outcomeFailed = lastRefreshOutcome != null &&
        lastRefreshOutcome != RefreshNetworkOutcome.success;
    final metaFailed = meta?.syncStatus == NetworkSectionSyncStatus.syncFailed;

    if (outcomeFailed) {
      banners.add(SyncFailedBanner(
        underlyingError: _mapOutcomeToErrorReason(lastRefreshOutcome),
      ));
    } else if (lastRefreshOutcome == null && metaFailed) {
      banners.add(SyncFailedBanner(
        underlyingError: _mapErrorCodeToReason(meta?.lastErrorCode),
      ));
    }

    // StaleContentBanner: solo niveles altos de obsolescencia.
    if (freshness == Freshness.veryStale ||
        freshness == Freshness.longUnsynced) {
      final age = meta?.lastSyncedAt != null
          ? now.difference(meta!.lastSyncedAt!)
          : Duration.zero;
      banners.add(StaleContentBanner(level: freshness, age: age));
    }

    // Banners inyectados por capas superiores (ej. unmapped del bucketizer).
    banners.addAll(extraBanners);

    return SectionLoaded<T>(
      workspaceId: workspaceId,
      items: List<T>.unmodifiable(items),
      freshness: freshness,
      banners: List<SectionBanner>.unmodifiable(banners),
    );
  }

  // ── 2. SIN ITEMS — distinguir 4 sub-casos. Orden de precedencia.

  // 2a. Refresh remoto explícito en esta sesión falló → Error con razón.
  //     PRECEDENCIA SOBRE EmptyReal. Garantía dura: timeout/red nunca cae
  //     en "Aún no tienes registros".
  if (lastRefreshOutcome != null &&
      lastRefreshOutcome != RefreshNetworkOutcome.success) {
    return SectionError<T>(
      workspaceId: workspaceId,
      reason: _mapOutcomeToErrorReason(lastRefreshOutcome),
    );
  }

  // 2b. Refresh remoto fue success Y server devolvió vacío → EmptyReal genuino.
  if (lastRefreshOutcome == RefreshNetworkOutcome.success &&
      meta?.syncStatus == NetworkSectionSyncStatus.confirmed) {
    return SectionEmptyReal<T>(workspaceId: workspaceId);
  }

  // 2c. Sin intento esta sesión PERO meta persistida marca syncFailed →
  //     Error según lastErrorCode persistido.
  if (lastRefreshOutcome == null &&
      meta?.syncStatus == NetworkSectionSyncStatus.syncFailed) {
    return SectionError<T>(
      workspaceId: workspaceId,
      reason: _mapErrorCodeToReason(meta!.lastErrorCode),
    );
  }

  // 2d. Sin items, sin intento, sin meta o meta confirmada sin lastSyncedAt:
  //     primer arranque — Bootstrap.
  return SectionBootstrap<T>(workspaceId: workspaceId);
}

// ─────────────────────────────────────────────────────────────────────────────
// Mappers internos.
// ─────────────────────────────────────────────────────────────────────────────

SectionErrorReason _mapOutcomeToErrorReason(RefreshNetworkOutcome? o) {
  switch (o) {
    case RefreshNetworkOutcome.success:
    case null:
      return SectionErrorReason.unknownError;
    case RefreshNetworkOutcome.networkError:
    case RefreshNetworkOutcome.serverError:
      return SectionErrorReason.connectionError;
    case RefreshNetworkOutcome.authError:
      return SectionErrorReason.authError;
    case RefreshNetworkOutcome.forbidden:
      return SectionErrorReason.forbiddenError;
    case RefreshNetworkOutcome.unknownError:
      return SectionErrorReason.unknownError;
  }
}

SectionErrorReason _mapErrorCodeToReason(String? code) {
  switch (code) {
    case 'timeout':
    case 'networkError':
    case '5xx':
    case 'serverError':
      return SectionErrorReason.connectionError;
    case 'authExpired':
    case 'authError':
    case '401':
      return SectionErrorReason.authError;
    case 'forbidden':
    case '403':
      return SectionErrorReason.forbiddenError;
    case 'schemaIncompatible':
      return SectionErrorReason.schemaIncompatible;
    case null:
    case '':
    default:
      return SectionErrorReason.unknownError;
  }
}

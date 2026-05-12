// ============================================================================
// lib/presentation/controllers/network/v2/section_ui_state.dart
// Estado UI de una sección de Mi Red (network o team). Tipos cerrados.
// ============================================================================
// DISEÑO:
//   - `kind` (Bootstrap | Loaded | EmptyReal | Error) decide LAYOUT.
//   - `freshness` (Fresh | Stale | VeryStale | LongUnsynced) es METADATA de
//     contenido, NO un kind separado. Solo significativa cuando kind == loaded.
//   - `banners: List<SectionBanner>` lleva indicadores ortogonales (sync
//     failed, contenido stale, categorías unmapped). La UI decide orden/stack.
//
// INVARIANTES:
//   - `workspaceId` SIEMPRE presente — todo consumidor puede validar
//     pertenencia antes de aplicar al árbol de widgets.
//   - `EmptyReal` SOLO se construye cuando items==0 && refresh.success &&
//     remote.items==0. NUNCA por timeout/red. Garantizado en
//     section_classifier.dart.
//   - `Error` lleva razón específica para que la UI decida copy y CTA.
//
// ESTOS TIPOS NO HACEN:
//   - No tienen lógica de transición — esa vive en section_classifier.
//   - No leen Isar ni HTTP — son value objects puros.
//   - No conocen umbrales de freshness — esos viven en section_classifier.
// ============================================================================

/// Edad relativa de la cache local. Single-source-of-truth en
/// `section_classifier.dart`. Otros archivos solo CONSUMEN, no DERIVAN.
enum Freshness {
  fresh,
  stale,
  veryStale,

  /// > 30 días o `projectionSchemaVersion < kCurrent`. El dato sigue siendo
  /// útil para lectura (es operacional, no financiero), pero la UI muestra
  /// banner persistente sugiriendo verificación.
  longUnsynced,
}

/// Razón estructurada por la que la sección está en estado Error o por la
/// que el último refresh falló.
enum SectionErrorReason {
  /// Timeout, DNS, red caída, 5xx.
  connectionError,

  /// 401 — sesión expirada.
  authError,

  /// 403 — sin acceso al workspace actual.
  forbiddenError,

  /// Schema del backend incompatible con la proyección local actual.
  schemaIncompatible,

  /// Cualquier otro fallo no categorizado.
  unknownError,
}

// ─────────────────────────────────────────────────────────────────────────────
// SectionBanner — sealed hierarchy.
// ─────────────────────────────────────────────────────────────────────────────

sealed class SectionBanner {
  const SectionBanner();
}

/// El último refresh remoto falló. Hay cache local visible.
final class SyncFailedBanner extends SectionBanner {
  final SectionErrorReason underlyingError;
  const SyncFailedBanner({required this.underlyingError});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncFailedBanner && other.underlyingError == underlyingError);

  @override
  int get hashCode => underlyingError.hashCode;
}

/// La cache cumple un umbral de antigüedad relevante (veryStale o longUnsynced).
/// `age` viaja para el copy específico ("hace X días").
final class StaleContentBanner extends SectionBanner {
  final Freshness level;
  final Duration age;
  const StaleContentBanner({required this.level, required this.age});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaleContentBanner &&
          other.level == level &&
          other.age == age);

  @override
  int get hashCode => Object.hash(level, age);
}

/// Hay actores con `sectionKeys` no reconocidas por esta versión de la app.
/// Aparecen en el bucket "Categorías no soportadas aún".
final class UnmappedCategoriesBanner extends SectionBanner {
  final int unmappedCount;
  const UnmappedCategoriesBanner({required this.unmappedCount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnmappedCategoriesBanner &&
          other.unmappedCount == unmappedCount);

  @override
  int get hashCode => unmappedCount.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// SectionUiState — sealed hierarchy.
// ─────────────────────────────────────────────────────────────────────────────

sealed class SectionUiState<T> {
  final String workspaceId;
  const SectionUiState({required this.workspaceId});
}

/// Carga inicial: aún no hay cache local NI intento de refresh para este
/// workspace. UI renderiza skeleton. Estado transitorio — no puede quedar
/// indefinidamente: el controller debe garantizar que un fallo de stream
/// transiciona a SectionError, no se queda aquí.
final class SectionBootstrap<T> extends SectionUiState<T> {
  const SectionBootstrap({required super.workspaceId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionBootstrap<T> && other.workspaceId == workspaceId);

  @override
  int get hashCode => Object.hash(runtimeType, workspaceId);
}

/// Hay items para renderizar. `freshness` es metadata. `banners` lleva
/// indicadores ortogonales (sync failed, stale, unmapped).
final class SectionLoaded<T> extends SectionUiState<T> {
  final List<T> items;
  final Freshness freshness;
  final List<SectionBanner> banners;

  SectionLoaded({
    required super.workspaceId,
    required this.items,
    required this.freshness,
    required this.banners,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SectionLoaded<T>) return false;
    if (other.workspaceId != workspaceId) return false;
    if (other.freshness != freshness) return false;
    if (other.items.length != items.length) return false;
    if (other.banners.length != banners.length) return false;
    for (var i = 0; i < items.length; i++) {
      if (other.items[i] != items[i]) return false;
    }
    for (var i = 0; i < banners.length; i++) {
      if (other.banners[i] != banners[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        workspaceId,
        freshness,
        Object.hashAll(items),
        Object.hashAll(banners),
      );
}

/// items==0 + último refresh fue success + el servidor confirmó vacío.
/// Único path por el cual se renderiza "Aún no tienes registros…".
final class SectionEmptyReal<T> extends SectionUiState<T> {
  const SectionEmptyReal({required super.workspaceId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionEmptyReal<T> && other.workspaceId == workspaceId);

  @override
  int get hashCode => Object.hash(runtimeType, workspaceId);
}

/// items==0 + fallo remoto (o meta.syncStatus==syncFailed). NUNCA debe
/// renderizarse como EmptyReal. La UI muestra copy de error + CTA Reintentar.
final class SectionError<T> extends SectionUiState<T> {
  final SectionErrorReason reason;
  const SectionError({required super.workspaceId, required this.reason});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionError<T> &&
          other.workspaceId == workspaceId &&
          other.reason == reason);

  @override
  int get hashCode => Object.hash(runtimeType, workspaceId, reason);
}

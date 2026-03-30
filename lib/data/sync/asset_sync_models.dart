// ============================================================================
// lib/data/sync/asset_sync_models.dart
// ASSET SYNC MODELS — Modelos internos de sincronización para activos vehiculares
//
// QUÉ HACE:
// - Define el estado volátil de sync por asset dentro del motor local↔remoto.
// - Formaliza el mecanismo anti-ping-pong mediante fingerprint/hash semántico.
// - Expone resultados tipificados para operaciones PUSH y PULL.
// - Introduce origen del último cambio procesado para trazabilidad.
//
// QUÉ NO HACE:
// - No persiste nada en Isar ni en Firestore.
// - No ejecuta lógica de sync.
// - No calcula hashes (solo define el contrato).
//
// PRINCIPIOS:
// - Estado en memoria (reconstruible).
// - Inmutabilidad.
// - Determinismo.
// - Anti-loop explícito.
//
// REGLA ARQUITECTÓNICA:
// El fingerprint representa el snapshot COMPLETO del activo.
//
// CHECKLIST CRÍTICO PARA EL ENGINE:
//
// 1. NORMALIZACIÓN DEL FINGERPRINT (OBLIGATORIO)
//    - El hash debe generarse sobre un mapa ORDENADO (keys alfabéticas).
//    - Ejemplo: {"a":1,"b":2} == {"b":2,"a":1}
//    - No cumplir esto rompe el anti-ping-pong.
//
// 2. USO DE UTC (OBLIGATORIO)
//    - touchedAt SIEMPRE en UTC (.toUtc())
//    - Evita inconsistencias entre cliente y Firebase.
//
// ============================================================================

// ─────────────────────────────────────────────────────────────────────────────
// ENUM — ORIGEN DEL CAMBIO
// ─────────────────────────────────────────────────────────────────────────────

enum SyncOrigin {
  local,
  remote,
  unknown,
}

// ─────────────────────────────────────────────────────────────────────────────
// VALUE OBJECT — FINGERPRINT
// ─────────────────────────────────────────────────────────────────────────────

class AssetPayloadFingerprint {
  final String value;

  const AssetPayloadFingerprint(this.value);

  bool get isValid => value.trim().isNotEmpty;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetPayloadFingerprint &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE — VEHICLE SYNC STATE
// ─────────────────────────────────────────────────────────────────────────────

class VehicleSyncState {
  final String assetId;
  final AssetPayloadFingerprint? lastAcceptedFingerprint;
  final SyncOrigin lastOrigin;
  final DateTime? lastAcceptedUpdatedAt;
  final DateTime touchedAt;

  const VehicleSyncState({
    required this.assetId,
    this.lastAcceptedFingerprint,
    this.lastOrigin = SyncOrigin.unknown,
    this.lastAcceptedUpdatedAt,
    required this.touchedAt,
  });

  /// Estado inicial limpio
  factory VehicleSyncState.initial(String assetId) => VehicleSyncState(
        assetId: assetId,
        touchedAt: DateTime.now().toUtc(), // 🔥 SIEMPRE UTC
      );

  bool get hasAcceptedFingerprint => lastAcceptedFingerprint != null;

  /// Anti ping-pong
  bool matchesFingerprint(AssetPayloadFingerprint fingerprint) {
    final accepted = lastAcceptedFingerprint;
    if (accepted == null) return false;
    return accepted == fingerprint;
  }

  /// Aceptar snapshot (core del engine)
  VehicleSyncState acceptSnapshot({
    required AssetPayloadFingerprint fingerprint,
    required SyncOrigin origin,
    required DateTime? updatedAt,
    DateTime? touchedAt,
  }) {
    return VehicleSyncState(
      assetId: assetId,
      lastAcceptedFingerprint: fingerprint,
      lastOrigin: origin,
      lastAcceptedUpdatedAt: updatedAt,
      touchedAt: (touchedAt ?? DateTime.now()).toUtc(), // 🔥 FORZAR UTC
    );
  }

  VehicleSyncState copyWith({
    String? assetId,
    AssetPayloadFingerprint? lastAcceptedFingerprint,
    bool clearFingerprint = false,
    SyncOrigin? lastOrigin,
    DateTime? lastAcceptedUpdatedAt,
    bool clearUpdatedAt = false,
    DateTime? touchedAt,
  }) {
    return VehicleSyncState(
      assetId: assetId ?? this.assetId,
      lastAcceptedFingerprint: clearFingerprint
          ? null
          : (lastAcceptedFingerprint ?? this.lastAcceptedFingerprint),
      lastOrigin: lastOrigin ?? this.lastOrigin,
      lastAcceptedUpdatedAt: clearUpdatedAt
          ? null
          : (lastAcceptedUpdatedAt ?? this.lastAcceptedUpdatedAt),
      touchedAt: (touchedAt ?? this.touchedAt).toUtc(), // 🔥 FORZAR UTC
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PUSH RESULT
// ─────────────────────────────────────────────────────────────────────────────

sealed class PushResult {
  const PushResult();
}

class PushResultPushed extends PushResult {
  const PushResultPushed();
}

class PushResultSkipped extends PushResult {
  const PushResultSkipped();
}

class PushResultDeferred extends PushResult {
  final String message;
  const PushResultDeferred(this.message);
}

class PushResultError extends PushResult {
  final String message;
  const PushResultError(this.message);
}

// ─────────────────────────────────────────────────────────────────────────────
// PULL RESULT
// ─────────────────────────────────────────────────────────────────────────────

sealed class PullResult {
  const PullResult();
}

class PullResultApplied extends PullResult {
  const PullResultApplied();
}

class PullResultUpToDate extends PullResult {
  const PullResultUpToDate();
}

class PullResultNotFound extends PullResult {
  const PullResultNotFound();
}

class PullResultSkipped extends PullResult {
  const PullResultSkipped();
}

class PullResultError extends PullResult {
  final String message;
  const PullResultError(this.message);
}

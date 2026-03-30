// ============================================================================
// lib/domain/entities/asset/asset_policy_override.dart
// ASSET POLICY OVERRIDE — Value object de control de sobreescritura de póliza
//
// QUÉ HACE:
// - Modela el estado de bloqueo de una póliza de seguro.
// - Cuando isLocked == true, fuentes externas (RUNT, APIs) NO pueden
//   sobreescribir los datos de la póliza.
// - Serializable a/desde JSON para persistencia en Firestore y en Isar
//   (via overrideJson en InsurancePolicyModel).
//
// QUÉ NO HACE:
// - No aplica el bloqueo por sí mismo (esa lógica vive en AssetPolicyMerger).
// - No accede a Isar ni Firestore.
// - No usa code generation (intencional en Fase 1 — se migra a freezed en Fase 2
//   si el contrato de InsurancePolicyEntity lo requiere).
//
// PRINCIPIOS:
// - Inmutable: todos los campos son final.
// - `unlocked` es la constante canónica para el estado desbloqueado.
// - fromJson tolerante: isLocked = false si el campo está ausente.
// - Si isLocked == false, no debe existir metadata de bloqueo.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// ============================================================================

/// Control de sobreescritura de una póliza de cumplimiento.
///
/// Cuando [isLocked] es `true`, ninguna fuente externa (RUNT, sync remoto)
/// puede modificar los datos de la póliza sin intervención humana explícita.
final class AssetPolicyOverride {
  static const Object _unset = Object();

  final bool isLocked;

  /// Motivo del bloqueo (para auditoría y UI).
  final String? reason;

  /// Identificador de quien aplicó el bloqueo (userId o systemId).
  final String? lockedBy;

  /// Timestamp UTC en que se aplicó el bloqueo.
  final DateTime? lockedAt;

  const AssetPolicyOverride({
    required this.isLocked,
    this.reason,
    this.lockedBy,
    this.lockedAt,
  }) : assert(
          isLocked || (reason == null && lockedBy == null && lockedAt == null),
          'Unlocked override cannot contain lock metadata.',
        );

  // ==========================================================================
  // CONSTRUCTORES DE FÁBRICA
  // ==========================================================================

  /// Estado desbloqueado canónico. Usar como valor por defecto.
  static const AssetPolicyOverride unlocked = AssetPolicyOverride(
    isLocked: false,
  );

  /// Deserializa desde JSON.
  ///
  /// Tolerancias:
  /// - Si `isLocked` no existe, asume `false`.
  /// - Si `lockedAt` no puede parsearse, queda en `null`.
  /// - Si `isLocked == false`, se normaliza a estado desbloqueado canónico.
  factory AssetPolicyOverride.fromJson(Map<String, dynamic> json) {
    final isLocked = json['isLocked'] as bool? ?? false;

    final rawLockedAt = json['lockedAt'];
    DateTime? parsedLockedAt;

    if (rawLockedAt is String) {
      parsedLockedAt = DateTime.tryParse(rawLockedAt);
    } else if (rawLockedAt is int) {
      parsedLockedAt = DateTime.fromMillisecondsSinceEpoch(rawLockedAt);
    }

    if (!isLocked) {
      return unlocked;
    }

    return AssetPolicyOverride(
      isLocked: true,
      reason: json['reason'] as String?,
      lockedBy: json['lockedBy'] as String?,
      lockedAt: parsedLockedAt,
    );
  }

  // ==========================================================================
  // SERIALIZACIÓN
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isLocked': isLocked,
      if (reason != null) 'reason': reason,
      if (lockedBy != null) 'lockedBy': lockedBy,
      if (lockedAt != null) 'lockedAt': lockedAt!.toIso8601String(),
    };
  }

  // ==========================================================================
  // COPYWITH
  // ==========================================================================

  AssetPolicyOverride copyWith({
    Object? isLocked = _unset,
    Object? reason = _unset,
    Object? lockedBy = _unset,
    Object? lockedAt = _unset,
  }) {
    final nextIsLocked = isLocked == _unset ? this.isLocked : isLocked as bool;
    final nextReason = reason == _unset ? this.reason : reason as String?;
    final nextLockedBy =
        lockedBy == _unset ? this.lockedBy : lockedBy as String?;
    final nextLockedAt =
        lockedAt == _unset ? this.lockedAt : lockedAt as DateTime?;

    if (!nextIsLocked) {
      return unlocked;
    }

    return AssetPolicyOverride(
      isLocked: true,
      reason: nextReason,
      lockedBy: nextLockedBy,
      lockedAt: nextLockedAt,
    );
  }

  // ==========================================================================
  // IGUALDAD
  // ==========================================================================

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetPolicyOverride &&
          runtimeType == other.runtimeType &&
          isLocked == other.isLocked &&
          reason == other.reason &&
          lockedBy == other.lockedBy &&
          lockedAt == other.lockedAt;

  @override
  int get hashCode => Object.hash(isLocked, reason, lockedBy, lockedAt);

  @override
  String toString() =>
      'AssetPolicyOverride(isLocked: $isLocked, reason: $reason, '
      'lockedBy: $lockedBy, lockedAt: $lockedAt)';
}

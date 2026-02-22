// ============================================================================
// lib/domain/value/organization_contract/quantitative_limit.dart
// QUANTITATIVE LIMIT — Enterprise Ultra Pro (Domain / Value Object)
//
// QUÉ HACE:
// - Modela límites cuantitativos TIPADOS (Freezed sealed union).
// - Distingue explícitamente Unlimited (infinito lógico) vs Limited(int value).
// - Expone API de negocio estable y determinística:
//   - canAdd(currentCount): ¿puedo agregar 1 unidad más?
//   - isExceeded(currentCount): ¿ya alcancé/excedí el límite?
//   - remaining(currentCount): cupos restantes (null si unlimited)
//   - clampDesired(desired, currentCount): cuántas unidades se pueden agregar ahora
// - Fail-fast ante corrupción: currentCount negativo lanza ArgumentError.
// - Prohíbe números mágicos (0 / -1) para representar infinito.
//
// QUÉ NO HACE:
// - No aplica enforcement en repositorios/UI (eso va en policies/usecases).
// - No decide QUÉ recurso está limitado (eso lo define OrganizationAccessContract).
// - No interpreta pricing, billing ni planes.
//
// INVARIANTES:
// - Limited.value >= 0 (no se permiten límites negativos).
//
// SERIALIZACIÓN:
// - JSON con discriminador 'runtimeType' (default de Freezed).
//
// REQUISITOS:
// - Debes ejecutar build_runner para generar:
//   - quantitative_limit.freezed.dart
//   - quantitative_limit.g.dart
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quantitative_limit.freezed.dart';
part 'quantitative_limit.g.dart';

@freezed
sealed class QuantitativeLimit with _$QuantitativeLimit {
  const QuantitativeLimit._();

  /// Sin límite de cantidad (infinito lógico).
  const factory QuantitativeLimit.unlimited() = QuantitativeLimitUnlimited;

  /// Límite estricto de [value] unidades.
  ///
  /// Invariante: value >= 0.
  @Assert('value >= 0', 'El límite no puede ser negativo.')
  const factory QuantitativeLimit.limited(int value) = QuantitativeLimitLimited;

  factory QuantitativeLimit.fromJson(Map<String, dynamic> json) =>
      _$QuantitativeLimitFromJson(json);

  // --------------------------------------------------------------------------
  // VALIDACIÓN (Fail-fast)
  // --------------------------------------------------------------------------

  static void _assertValidCurrentCount(int currentCount) {
    if (currentCount < 0) {
      throw ArgumentError.value(
        currentCount,
        'currentCount',
        'currentCount no puede ser negativo.',
      );
    }
  }

  static void _assertValidDesiredAdd(int desiredToAdd) {
    if (desiredToAdd < 0) {
      throw ArgumentError.value(
        desiredToAdd,
        'desiredToAdd',
        'desiredToAdd no puede ser negativo.',
      );
    }
  }

  // --------------------------------------------------------------------------
  // API DE NEGOCIO
  // --------------------------------------------------------------------------

  /// ¿Se puede agregar 1 unidad más dado el conteo actual?
  ///
  /// - Unlimited => siempre true.
  /// - Limited(n) => true si currentCount < n.
  bool canAdd(int currentCount) {
    _assertValidCurrentCount(currentCount);
    return switch (this) {
      QuantitativeLimitUnlimited() => true,
      QuantitativeLimitLimited(:final value) => currentCount < value,
    };
  }

  /// ¿Se alcanzó o excedió el límite?
  ///
  /// - Unlimited => false (nunca excede).
  /// - Limited(n) => true si currentCount >= n.
  bool isExceeded(int currentCount) {
    _assertValidCurrentCount(currentCount);
    return switch (this) {
      QuantitativeLimitUnlimited() => false,
      QuantitativeLimitLimited(:final value) => currentCount >= value,
    };
  }

  /// Cupos restantes.
  ///
  /// - Unlimited => null (infinito).
  /// - Limited(n) => max(0, n - currentCount).
  int? remaining(int currentCount) {
    _assertValidCurrentCount(currentCount);
    return switch (this) {
      QuantitativeLimitUnlimited() => null,
      QuantitativeLimitLimited(:final value) =>
        (value - currentCount) <= 0 ? 0 : (value - currentCount),
    };
  }

  /// Determina cuántas unidades de [desiredToAdd] es posible agregar ahora,
  /// respetando el límite.
  ///
  /// - Unlimited => retorna desiredToAdd.
  /// - Limited(n) => retorna min(desiredToAdd, remaining(currentCount)).
  ///
  /// Útil para operaciones batch (ej: invitar N miembros, crear N activos, etc.).
  int clampDesired({required int desiredToAdd, required int currentCount}) {
    _assertValidDesiredAdd(desiredToAdd);
    _assertValidCurrentCount(currentCount);

    final r = remaining(currentCount) ?? desiredToAdd;
    return switch (this) {
      QuantitativeLimitUnlimited() => desiredToAdd,
      QuantitativeLimitLimited() => desiredToAdd <= r ? desiredToAdd : r,
    };
  }

  // --------------------------------------------------------------------------
  // HELPERS (UI / telemetría / logs) — NO enforcement
  // --------------------------------------------------------------------------

  bool get isUnlimited => this is QuantitativeLimitUnlimited;
  bool get isLimited => this is QuantitativeLimitLimited;

  /// Valor numérico si es limited; null si unlimited.
  int? get valueOrNull => switch (this) {
        QuantitativeLimitUnlimited() => null,
        QuantitativeLimitLimited(:final value) => value,
      };

  /// String estable para logs/telemetría (NO wire de persistencia).
  String toDebugString() => switch (this) {
        QuantitativeLimitUnlimited() => 'Unlimited',
        QuantitativeLimitLimited(:final value) => 'Limited($value)',
      };
}

// ============================================================================
// lib/domain/services/purchase/vehicle_spec_derivation.dart
// VEHICLE SPEC DERIVATION — servicio puro (Domain)
//
// QUÉ HACE:
// - Agrupa vehículos reales (AssetVehiculoEntity) por (make, model, year) y
//   produce la lista canónica de VehicleSpec con labels humanos, count y
//   opcionales únicos por grupo.
//
// QUÉ NO HACE:
// - No lee Isar ni red. Recibe la lista ya materializada.
// - No mezcla ciudad/proveedor ni métricas BI.
// - No inventa datos: un opcional solo se expone si TODOS los elementos del
//   grupo coinciden en ese valor.
//
// PRINCIPIOS:
// - Normalización defensiva: trim, colapso de espacios, comparación case-
//   insensitive para el grouping key; preserva un label legible Title Case.
// - Determinista: el ID es `makeKey|modelKey|year` — estable entre cargas.
// - Null-safe: vehículos sin marca/modelo/año válidos se descartan sin romper.
// ============================================================================

import '../../entities/asset/special/asset_vehiculo_entity.dart';
import '../../value/purchase/vehicle_spec.dart';

abstract final class VehicleSpecDerivation {
  /// Deriva la lista de [VehicleSpec] desde un conjunto de vehículos reales.
  ///
  /// Requisitos mínimos por vehículo para entrar al resultado:
  /// - marca no vacía (tras normalización)
  /// - modelo no vacío (tras normalización)
  /// - anio > 0
  ///
  /// Orden de salida: primero por marca (label), luego modelo, luego año desc.
  static List<VehicleSpec> fromVehicles(Iterable<AssetVehiculoEntity> vehicles) {
    final groups = <String, _SpecAccumulator>{};

    for (final v in vehicles) {
      final makeKey = _normalizeKey(v.marca);
      final modelKey = _normalizeKey(v.modelo);
      final year = v.anio;
      if (makeKey.isEmpty || modelKey.isEmpty || year <= 0) continue;

      final id = '$makeKey|$modelKey|$year';
      final acc = groups.putIfAbsent(
        id,
        () => _SpecAccumulator(
          id: id,
          makeKey: makeKey,
          modelKey: modelKey,
          year: year,
          makeLabel: _prettyLabel(v.marca),
          modelLabel: _prettyLabel(v.modelo),
        ),
      );
      acc.absorb(v);
    }

    final result = groups.values.map((a) => a.build()).toList();
    result.sort((a, b) {
      final byMake = a.makeLabel.toLowerCase().compareTo(b.makeLabel.toLowerCase());
      if (byMake != 0) return byMake;
      final byModel =
          a.modelLabel.toLowerCase().compareTo(b.modelLabel.toLowerCase());
      if (byModel != 0) return byModel;
      return b.year.compareTo(a.year); // año descendente
    });
    return result;
  }

  // ── Normalización ─────────────────────────────────────────────────────────

  /// Clave de agrupación: minúscula, trim, colapso de espacios internos.
  /// "  Toyota   " → "toyota" ; "grand  I10" → "grand i10".
  static String _normalizeKey(String? raw) {
    if (raw == null) return '';
    final s = raw.trim();
    if (s.isEmpty) return '';
    return s.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).join(' ');
  }

  /// Label "humano" preservando tokens legibles. Evita destruir siglas válidas
  /// (ej: "VW", "SUV") manteniendo Title Case en palabras largas y dejando los
  /// tokens cortos tal cual.
  static String _prettyLabel(String? raw) {
    if (raw == null) return '';
    final s = raw.trim();
    if (s.isEmpty) return '';
    final words = s.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    return words.map(_capitalizeToken).join(' ');
  }

  static String _capitalizeToken(String token) {
    // Tokens cortos (≤3) se normalizan a MAYÚSCULAS: cubre siglas comunes en
    // marcas y líneas (VW, BMW, GNC, SUV, RS, SR) y alfanuméricos como "i10",
    // "x3" que los importadores suelen mostrar en mayúsculas. Es un criterio
    // determinista y aceptable para UI; no rompe nombres largos.
    if (token.length <= 3) {
      return token.toUpperCase();
    }
    final lower = token.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}

/// Acumulador interno por grupo — mantiene los opcionales unánimes y cuenta.
class _SpecAccumulator {
  final String id;
  final String makeKey;
  final String modelKey;
  final int year;
  final String makeLabel;
  final String modelLabel;

  int _count = 0;
  _Optional<String> _version = const _Optional.unset();
  _Optional<int> _displacement = const _Optional.unset();
  // Motorization y transmission hoy no existen como campos de primer nivel en
  // AssetVehiculoEntity; se mantienen unset y se expondrán null. Dejamos el
  // slot reservado para cuando el modelo vehicular los persista sin tener que
  // romper el contrato de VehicleSpec.
  static const _Optional<String> _motorization = _Optional.unset();
  static const _Optional<String> _transmission = _Optional.unset();

  _SpecAccumulator({
    required this.id,
    required this.makeKey,
    required this.modelKey,
    required this.year,
    required this.makeLabel,
    required this.modelLabel,
  });

  void absorb(AssetVehiculoEntity v) {
    _count++;
    // Los opcionales fase 1 que HOY están en AssetVehiculoEntity:
    //   line (se usa como "version" proxy cuando existe — no es estricto)
    //   engineDisplacement (cc) → displacement
    // Motorization y transmission NO existen como campos de primer nivel; se
    // dejan unset. Si más adelante el modelo los expone, sumarán aquí.
    _version = _version.merge(_trimOrNull(v.line));
    _displacement = _displacement.merge(v.engineDisplacement?.round());
  }

  VehicleSpec build() => VehicleSpec(
        id: id,
        makeKey: makeKey,
        modelKey: modelKey,
        year: year,
        makeLabel: makeLabel,
        modelLabel: modelLabel,
        linkedAssetsCount: _count,
        version: _version.valueOrNull,
        motorization: _motorization.valueOrNull,
        engineDisplacementCc: _displacement.valueOrNull,
        transmission: _transmission.valueOrNull,
      );

  static String? _trimOrNull(String? raw) {
    final s = raw?.trim();
    return (s == null || s.isEmpty) ? null : s;
  }
}

/// Tiny helper que distingue "aún no he visto valor" vs "valores contradictorios".
///
/// - unset + X        → X
/// - X    + X         → X
/// - X    + Y (X≠Y)   → conflict (null final)
/// - conflict + *     → conflict
class _Optional<T> {
  final bool isSet;
  final bool isConflict;
  final T? value;

  const _Optional.unset()
      : isSet = false,
        isConflict = false,
        value = null;

  const _Optional._set(this.value)
      : isSet = true,
        isConflict = false;

  const _Optional._conflict()
      : isSet = true,
        isConflict = true,
        value = null;

  T? get valueOrNull => isConflict ? null : value;

  _Optional<T> merge(T? incoming) {
    if (isConflict) return this;
    if (incoming == null) return this; // null no contradice
    if (!isSet) return _Optional._set(incoming);
    if (value == incoming) return this;
    return const _Optional._conflict();
  }
}

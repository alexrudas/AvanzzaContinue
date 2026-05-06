// ============================================================================
// lib/domain/value/capability/refs/coverage_city_path.dart
// CoverageCityPath — value object para representar cobertura geográfica
// de una capability como path estable PAIS/REGION/CIUDAD.
// ============================================================================
// QUÉ HACE:
//   - Encapsula un path geográfico canónico de 3 segmentos:
//     countryId / regionId / cityId.
//   - Aplica validación SINTÁCTICA en construcción: cada segmento debe ser
//     no-vacío, alfanumérico ASCII + guion + underscore, 1-32 chars.
//   - Provee construcción por named params y por string parseado (fromString).
//   - Inmutable, comparable por valor, serializable como string plano.
//
// QUÉ NO HACE:
//   - NO valida la EXISTENCIA del countryId/regionId/cityId en los catálogos
//     geográficos del proyecto. Esa validación semántica vive en la capa
//     que persiste/consume (puede consultar el GeoRepository).
//   - NO normaliza case (los IDs geográficos del repo mezclan 'CO' uppercase
//     con 'col-ant' lowercase). Se preserva el case original.
//
// FORMATO ACEPTADO:
//   - String: '<countryId>/<regionId>/<cityId>'
//   - Cada segmento: ^[A-Za-z0-9_-]{1,32}$
//   - Exactamente 2 separadores '/' (3 segmentos).
//
// EJEMPLOS:
//   ✓ 'CO/col-ant/col-ant-med'
//   ✓ 'US/ny/nyc'
//   ✓ 'BR/sp/sp-saopaulo'
//   ✗ 'CO/col-ant'           (faltan segmentos)
//   ✗ 'CO//col-ant-med'       (segmento vacío)
//   ✗ 'CO/col ant/col-med'    (espacio interno)
//   ✗ 'CO/col-ant/col-med/x'  (segmentos extra)
// ============================================================================

class CoverageCityPath {
  /// Identificador del país (ISO-like). Ej: 'CO', 'US'.
  final String countryId;

  /// Identificador de la región/estado. Ej: 'col-ant', 'us-ny'.
  final String regionId;

  /// Identificador de la ciudad. Ej: 'col-ant-med', 'us-ny-nyc'.
  final String cityId;

  CoverageCityPath({
    required String countryId,
    required String regionId,
    required String cityId,
  })  : countryId = _validateSegment(countryId, 'countryId'),
        regionId = _validateSegment(regionId, 'regionId'),
        cityId = _validateSegment(cityId, 'cityId');

  /// Construye desde string formato 'PAIS/REGION/CIUDAD'.
  /// Throws [ArgumentError] si el formato o los segmentos son inválidos.
  factory CoverageCityPath.fromString(String raw) {
    final parts = raw.split('/');
    if (parts.length != 3) {
      throw ArgumentError(
        'CoverageCityPath: formato esperado "<countryId>/<regionId>/<cityId>", '
        'recibido: "$raw"',
      );
    }
    return CoverageCityPath(
      countryId: parts[0],
      regionId: parts[1],
      cityId: parts[2],
    );
  }

  /// Variante no-throw: retorna null si [raw] es null o no cumple sintaxis.
  static CoverageCityPath? tryParse(String? raw) {
    if (raw == null) return null;
    try {
      return CoverageCityPath.fromString(raw);
    } on ArgumentError {
      return null;
    }
  }

  /// Path canónico: '<countryId>/<regionId>/<cityId>'.
  String get value => '$countryId/$regionId/$cityId';

  /// Serializa al wire como string plano.
  String toJson() => value;

  factory CoverageCityPath.fromJson(String raw) =>
      CoverageCityPath.fromString(raw);

  static final RegExp _segmentPattern = RegExp(r'^[A-Za-z0-9_-]{1,32}$');

  static String _validateSegment(String raw, String fieldName) {
    if (raw.isEmpty) {
      throw ArgumentError('CoverageCityPath: $fieldName no puede ser vacío');
    }
    if (!_segmentPattern.hasMatch(raw)) {
      throw ArgumentError(
        'CoverageCityPath: $fieldName debe ser alfanumérico ASCII + "_" + "-", '
        '1-32 chars. Recibido: "$raw"',
      );
    }
    return raw;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoverageCityPath &&
          other.countryId == countryId &&
          other.regionId == regionId &&
          other.cityId == cityId);

  @override
  int get hashCode => Object.hash(countryId, regionId, cityId);

  @override
  String toString() => 'CoverageCityPath($value)';
}

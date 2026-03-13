// ============================================================================
// lib/data/models/integrations/simit_result_model.dart
//
// SIMIT RESULT MODEL — DTO
//
// Data Transfer Object para la respuesta de la API SIMIT Multas.
// Parsea la respuesta del endpoint:
//   GET /simit/multas/:query
//
// NO tiene dependencias de dominio ni de frameworks.
// El mapper a entidad vive en IntegrationsRepositoryImpl.
// ============================================================================

/// DTO para el bloque `data` de la respuesta SIMIT.
class SimitDataModel {
  final bool tieneMultas;
  final double total;
  final Map<String, dynamic> resumen;
  final List<dynamic> multas;

  const SimitDataModel({
    required this.tieneMultas,
    required this.total,
    required this.resumen,
    required this.multas,
  });

  factory SimitDataModel.fromJson(Map<String, dynamic> json) {
    // Normaliza el total: puede venir como int, double o string.
    final rawTotal = json['total'];
    final double total;
    if (rawTotal is num) {
      total = rawTotal.toDouble();
    } else if (rawTotal is String) {
      total = double.tryParse(rawTotal) ?? 0.0;
    } else {
      total = 0.0;
    }

    return SimitDataModel(
      tieneMultas: (json['tieneMultas'] as bool?) ?? false,
      total: total,
      resumen: (json['resumen'] is Map<String, dynamic>)
          ? json['resumen'] as Map<String, dynamic>
          : {},
      multas: (json['multas'] is List) ? json['multas'] as List<dynamic> : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'tieneMultas': tieneMultas,
        'total': total,
        'resumen': resumen,
        'multas': multas,
      };
}

/// DTO raíz para la respuesta completa del endpoint SIMIT Multas.
class SimitResultResponseModel {
  final bool ok;
  final String source;
  final SimitDataModel data;

  const SimitResultResponseModel({
    required this.ok,
    required this.source,
    required this.data,
  });

  factory SimitResultResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const FormatException(
        'SimitResultResponseModel: campo "data" ausente o inválido.',
      );
    }

    return SimitResultResponseModel(
      ok: (json['ok'] as bool?) ?? false,
      source: (json['source'] as String?) ?? 'SIMIT',
      data: SimitDataModel.fromJson(rawData),
    );
  }

  Map<String, dynamic> toJson() => {
        'ok': ok,
        'source': source,
        'data': data.toJson(),
      };
}

// ===================== lib/core/utils/json_converters.dart =====================

import 'package:json_annotation/json_annotation.dart';

/// Converter flexible para parsear números que pueden venir como int, String o null.
///
/// El scraping de APIs externas (RUNT/SIMIT) puede devolver números en formatos sucios:
/// - Como String: "2024", "125 cc", "$ 50.000"
/// - Como int directo: 2024
/// - Como null
///
/// Este converter limpia la cadena de caracteres no numéricos y parsea de forma defensiva.
///
/// Uso: @IntFlexibleConverter() en campos numéricos dudosos.
class IntFlexibleConverter implements JsonConverter<int?, dynamic> {
  const IntFlexibleConverter();

  @override
  int? fromJson(dynamic json) {
    // Si es null, retornar null
    if (json == null) return null;

    // Si ya es int, retornar directamente
    if (json is int) return json;

    // Si es String, limpiar y parsear
    if (json is String) {
      // Remover todo excepto dígitos
      final clean = json.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isEmpty) return null;
      return int.tryParse(clean);
    }

    // Para cualquier otro tipo, retornar null (defensivo)
    return null;
  }

  @override
  dynamic toJson(int? object) => object;
}

/// Converter para parsear el campo "multas" de SIMIT que puede venir como String o int.
///
/// En la API de SIMIT, el campo resumen.multas puede venir como:
/// - String: "3", "0", "10"
/// - int: 3, 0, 10
///
/// Este converter normaliza ambos casos a int.
class MultasCountConverter implements JsonConverter<int, dynamic> {
  const MultasCountConverter();

  @override
  int fromJson(dynamic json) {
    if (json == null) return 0;
    if (json is int) return json;
    if (json is String) {
      return int.tryParse(json) ?? 0;
    }
    return 0;
  }

  @override
  dynamic toJson(int object) => object;
}
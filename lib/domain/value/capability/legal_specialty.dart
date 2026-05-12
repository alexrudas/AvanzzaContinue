// ============================================================================
// lib/domain/value/capability/legal_specialty.dart
// LegalSpecialty — catálogo cerrado de especialidades legales
// ============================================================================
// QUÉ HACE:
//   - Especialidad de un Workspace con CapabilityProfile.kind == legal.
//   - Wire-stable.
//
// QUÉ NO HACE:
//   - NO modela jurisdicciones, tarifas ni casos. Solo la especialidad
//     declarada por el workspace para efectos de matching.
//
// EXTENSIBILIDAD:
//   Añadir una especialidad (laboral, comercial, tributario, ...) requiere
//   bump de enum + wireName/fromWire + migrator.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum LegalSpecialty {
  /// Derecho civil (familia, contratos, propiedad, sucesiones).
  @JsonValue('civil')
  civil,

  /// Derecho penal.
  @JsonValue('penal')
  penal,

  /// Atiende ambas especialidades (civil y penal).
  @JsonValue('ambas')
  ambas,
}

extension LegalSpecialtyX on LegalSpecialty {
  String get wireName {
    switch (this) {
      case LegalSpecialty.civil:
        return 'civil';
      case LegalSpecialty.penal:
        return 'penal';
      case LegalSpecialty.ambas:
        return 'ambas';
    }
  }

  static LegalSpecialty fromWire(String raw) {
    final parsed = tryFromWire(raw);
    if (parsed == null) {
      throw ArgumentError('LegalSpecialty desconocida: $raw');
    }
    return parsed;
  }

  static LegalSpecialty? tryFromWire(String raw) {
    switch (raw) {
      case 'civil':
        return LegalSpecialty.civil;
      case 'penal':
        return LegalSpecialty.penal;
      case 'ambas':
        return LegalSpecialty.ambas;
      default:
        return null;
    }
  }

  static bool isValidWireName(String raw) => tryFromWire(raw) != null;

  static List<String> get allWireNames =>
      LegalSpecialty.values.map((s) => s.wireName).toList(growable: false);
}

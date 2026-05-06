// ============================================================================
// lib/domain/value/capability/insurance_line.dart
// InsuranceLine — catálogo cerrado de ramos de seguro
// ============================================================================
// QUÉ HACE:
//   - Define los ramos de seguro que una InsurerSpec puede declarar.
//   - Wire-stable: snake_case en wireName.
//
// QUÉ NO HACE:
//   - NO valida combinaciones (ej: vida + auto en la misma línea); eso es
//     responsabilidad del flujo que construye InsurerSpec.
//   - NO modela coberturas finas (sub-ramos, deducibles, etc.); ese detalle
//     vive en la póliza, no en la capability del workspace.
//
// EXTENSIBILIDAD:
//   Añadir una nueva línea requiere bump de este enum + actualización de
//   wireName/fromWire + bump de schema/migrator de Firestore/Isar donde
//   se persista. NO aceptar strings libres.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum InsuranceLine {
  /// Seguro Obligatorio de Accidentes de Tránsito (CO).
  @JsonValue('soat')
  soat,

  /// Auto / vehículos (todo riesgo, daños, terceros).
  @JsonValue('auto')
  auto,

  /// Hogar / propiedad residencial.
  @JsonValue('hogar')
  hogar,

  /// Vida.
  @JsonValue('vida')
  vida,

  /// Salud / accidentes personales.
  @JsonValue('salud')
  salud,

  /// Empresarial (multirriesgo corporativo, lucro cesante, etc.).
  @JsonValue('empresarial')
  empresarial,

  /// Responsabilidad civil (general, profesional, directores).
  @JsonValue('responsabilidad_civil')
  responsabilidadCivil,

  /// Transporte de mercancías.
  @JsonValue('transporte')
  transporte,
}

extension InsuranceLineX on InsuranceLine {
  String get wireName {
    switch (this) {
      case InsuranceLine.soat:
        return 'soat';
      case InsuranceLine.auto:
        return 'auto';
      case InsuranceLine.hogar:
        return 'hogar';
      case InsuranceLine.vida:
        return 'vida';
      case InsuranceLine.salud:
        return 'salud';
      case InsuranceLine.empresarial:
        return 'empresarial';
      case InsuranceLine.responsabilidadCivil:
        return 'responsabilidad_civil';
      case InsuranceLine.transporte:
        return 'transporte';
    }
  }

  static InsuranceLine fromWire(String raw) {
    final parsed = tryFromWire(raw);
    if (parsed == null) {
      throw ArgumentError('InsuranceLine desconocida: $raw');
    }
    return parsed;
  }

  static InsuranceLine? tryFromWire(String raw) {
    switch (raw) {
      case 'soat':
        return InsuranceLine.soat;
      case 'auto':
        return InsuranceLine.auto;
      case 'hogar':
        return InsuranceLine.hogar;
      case 'vida':
        return InsuranceLine.vida;
      case 'salud':
        return InsuranceLine.salud;
      case 'empresarial':
        return InsuranceLine.empresarial;
      case 'responsabilidad_civil':
        return InsuranceLine.responsabilidadCivil;
      case 'transporte':
        return InsuranceLine.transporte;
      default:
        return null;
    }
  }

  static bool isValidWireName(String raw) => tryFromWire(raw) != null;

  static List<String> get allWireNames =>
      InsuranceLine.values.map((l) => l.wireName).toList(growable: false);
}

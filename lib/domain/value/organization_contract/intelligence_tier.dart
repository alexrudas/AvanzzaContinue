// ============================================================================
// lib/domain/value/organization_contract/intelligence_tier.dart
// INTELLIGENCE TIER — Enterprise Ultra Pro (Domain / Value Object)
//
// QUÉ HACE:
// - Define niveles de inteligencia/IA disponibles para una organización.
// - Enum puro con serialización estable vía @JsonValue (wire canonical).
// - Expone helpers declarativos: isAvailable, isAdvanced, label.
//
// QUÉ NO HACE:
// - No contiene lógica de IA ni algoritmos.
// - No define qué features de IA existen (eso va en use cases/policies).
//
// SERIALIZACIÓN (CANONICAL):
// - Wire estable: 'none' | 'basic' | 'advanced' (lowercase).
// - NO introducir formatos alternos (ej: 'NONE') para evitar deuda y migraciones.
// ============================================================================

import 'package:json_annotation/json_annotation.dart';

/// Nivel de inteligencia/IA disponible para la organización.
///
/// - [none]: sin capacidades de IA.
/// - [basic]: sugerencias, autocompletado, alertas simples.
/// - [advanced]: análisis predictivo, optimización, reportes inteligentes.
enum IntelligenceTier {
  @JsonValue('none')
  none,

  @JsonValue('basic')
  basic,

  @JsonValue('advanced')
  advanced;

  // --------------------------------------------------------------------------
  // CAPABILITIES (helpers)
  // --------------------------------------------------------------------------

  /// True si tiene al menos capacidades básicas de IA.
  bool get isAvailable => this != IntelligenceTier.none;

  /// True si soporta capacidades avanzadas.
  bool get isAdvanced => this == IntelligenceTier.advanced;

  // --------------------------------------------------------------------------
  // PRESENTATION (NO wire)
  // --------------------------------------------------------------------------

  /// Label humano (UI / logs). NO usar como wire.
  String get label => switch (this) {
        IntelligenceTier.none => 'Sin IA',
        IntelligenceTier.basic => 'IA Básica',
        IntelligenceTier.advanced => 'IA Avanzada',
      };

  // --------------------------------------------------------------------------
  // WIRE (canonical)
  // --------------------------------------------------------------------------

  /// Wire canonical estable (lowercase). Estándar del repo.
  String get wireName => switch (this) {
        IntelligenceTier.none => 'none',
        IntelligenceTier.basic => 'basic',
        IntelligenceTier.advanced => 'advanced',
      };

  /// Alias de [wireName]. Mantiene compatibilidad.
  @Deprecated(
    'Violation of DOMAIN_CONTRACTS.md (ENUM SERIALIZATION STANDARD). '
    'Do NOT use wire for persistence or payloads. '
    'Use wireName for logs/debug only. '
    'JSON must use @JsonValue (codegen).',
  )
  String get wire => wireName;

  /// Parse seguro desde wireName canonical (case-insensitive).
  /// Default: none.
  static IntelligenceTier fromWireName(String? wireName) {
    final normalized = (wireName ?? '').trim().toLowerCase();
    return switch (normalized) {
      'basic' => IntelligenceTier.basic,
      'advanced' => IntelligenceTier.advanced,
      _ => IntelligenceTier.none,
    };
  }

  /// Alias de [fromWireName]. Mantiene compatibilidad.
  static IntelligenceTier fromWire(String? wire) => fromWireName(wire);
}

// ============================================================================
// lib/domain/value/capability/legal_spec.dart
// LegalSpec — spec de un CapabilityProfile con kind == legal
// ============================================================================
// QUÉ HACE:
//   - Describe a un Workspace que ofrece servicios legales.
//   - El campo discriminante es la especialidad (civil | penal | ambas).
//   - Tipado fuerte (LegalSpecialty, no string libre).
// ============================================================================

import 'legal_specialty.dart';

class LegalSpec {
  /// Especialidad legal del workspace.
  final LegalSpecialty specialty;

  const LegalSpec({required this.specialty});

  LegalSpec copyWith({LegalSpecialty? specialty}) =>
      LegalSpec(specialty: specialty ?? this.specialty);

  Map<String, dynamic> toJson() => {
        'specialty': specialty.wireName,
      };

  factory LegalSpec.fromJson(Map<String, dynamic> json) {
    final specialtyRaw = json['specialty'];
    if (specialtyRaw is! String) {
      throw ArgumentError(
        'LegalSpec.fromJson: specialty requerida (String wire name)',
      );
    }
    return LegalSpec(
      specialty: LegalSpecialtyX.fromWire(specialtyRaw),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalSpec && other.specialty == specialty);

  @override
  int get hashCode => specialty.hashCode;

  @override
  String toString() => 'LegalSpec(specialty: ${specialty.wireName})';
}

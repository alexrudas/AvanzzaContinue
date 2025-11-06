// lib/domain/shared/enums/lease_duration.dart
// Enum para duración de contrato con serialización wire-stable.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: enum para duración de contrato con mapeo a wire names estables.
enum LeaseDuration {
  cortoPlazo,
  largoPlazo,
  flexible,
  otro,
}

// Comentarios en el código: extensión para serialización y parseo de LeaseDuration.
extension LeaseDurationWire on LeaseDuration {
  String get wireName {
    switch (this) {
      case LeaseDuration.cortoPlazo:
        return 'corto_plazo';
      case LeaseDuration.largoPlazo:
        return 'largo_plazo';
      case LeaseDuration.flexible:
        return 'flexible';
      case LeaseDuration.otro:
        return 'otro';
    }
  }

  static LeaseDuration fromWire(String? raw) {
    if (raw == null) return LeaseDuration.otro;
    switch (raw.trim().toLowerCase()) {
      case 'corto_plazo':
      case 'cortoplazo':
        return LeaseDuration.cortoPlazo;
      case 'largo_plazo':
      case 'largoplazo':
        return LeaseDuration.largoPlazo;
      case 'flexible':
        return LeaseDuration.flexible;
      default:
        return LeaseDuration.otro;
    }
  }
}

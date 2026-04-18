// ============================================================================
// lib/domain/entities/core_common/value_objects/match_trust_level.dart
// Nivel de confianza de un MatchCandidate (Core Common v1).
// ============================================================================
// Qué hace:
//   - Clasifica la evidencia de un match en tres niveles: alto, medio, bajo.
//   - Expone la regla de promoción a exposición (solo 'alto' se expone).
//
// Qué NO hace:
//   - No contiene scoring probabilístico ni ML (fuera de v1).
//   - No decide qué llave aplica: eso es del matcher en F4.
//   - No toca privacidad: la exposición se realiza en el servicio de matching,
//     aquí solo vive la semántica del nivel.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Regla crítica: solo 'alto' promueve Relación → detectable y
//     MatchCandidate → exposedToWorkspace. Otros niveles se quedan internos.
//
// Enterprise Notes:
//   - 'alto': llave fuerte (docId/NIT verificado o phoneE164+OTP) coincide exacto.
//   - 'medio': llave media verificada coincide (email verificado, docId sin fuerza).
//   - 'bajo': coincidencia única sin verificación fuerte; nunca expuesta.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Nivel de confianza asignado por el matcher a un MatchCandidate.
enum MatchTrustLevel {
  /// Evidencia fuerte: llave principal verificada coincide exactamente.
  /// Única que promueve a exposición al workspace dueño del registro local.
  @JsonValue('alto')
  alto,

  /// Evidencia intermedia: llave secundaria verificada coincide.
  /// Se guarda como detectado interno, sin exposición en v1.
  @JsonValue('medio')
  medio,

  /// Evidencia débil: coincidencia sin verificación fuerte.
  /// Persiste solo para auditoría; nunca expuesta, nunca activa nada.
  @JsonValue('bajo')
  bajo,
}

/// Extensión con wire names estables y reglas de promoción.
extension MatchTrustLevelX on MatchTrustLevel {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case MatchTrustLevel.alto:
        return 'alto';
      case MatchTrustLevel.medio:
        return 'medio';
      case MatchTrustLevel.bajo:
        return 'bajo';
    }
  }

  /// Parse estricto desde wire.
  static MatchTrustLevel fromWire(String raw) {
    switch (raw) {
      case 'alto':
        return MatchTrustLevel.alto;
      case 'medio':
        return MatchTrustLevel.medio;
      case 'bajo':
        return MatchTrustLevel.bajo;
      default:
        throw ArgumentError('MatchTrustLevel desconocido: $raw');
    }
  }

  /// Si este nivel promueve la Relación a 'detectable' y expone al workspace.
  /// Regla crítica v1: solo 'alto'.
  bool get promotesToExposure => this == MatchTrustLevel.alto;
}

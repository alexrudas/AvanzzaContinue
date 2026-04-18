// ============================================================================
// lib/domain/entities/core_common/value_objects/request_kind.dart
// Tipología semántica de la OperationalRequest (placeholder Core Common v1).
// ============================================================================
// Qué hace:
//   - Declara el placeholder tipado del tipo de Solicitud Estructurada.
//   - En v1 existe un único valor: 'generic'. Extensiones futuras (rfq,
//     serviceOrder, settlement, etc.) añaden nuevos wireNames.
//
// Qué NO hace:
//   - No define el payload: el payload JSON es opaco en Core Common v1.
//   - No fija plantillas de mensaje externo (futuro: por requestKind).
//   - No condiciona la máquina de estados: el motor es el mismo para todos los kinds.
//
// Principios:
//   - Dominio puro.
//   - Wire name estable + @JsonValue sincronizado.
//   - Extensible por adición: nuevos kinds se suman sin romper compatibilidad.
//
// Enterprise Notes:
//   - Al agregar un nuevo requestKind, cerrar en paralelo:
//       (a) esquema del payloadJson asociado,
//       (b) plantilla de texto para canales externos asistidos,
//       (c) políticas de expiración (si aplica).
//   - No agregar valores aquí sin los tres puntos anteriores.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// Tipología de una OperationalRequest. Placeholder v1.
enum RequestKind {
  /// Solicitud genérica sin semántica vertical declarada. Único valor en v1.
  @JsonValue('generic')
  generic,
}

/// Extensión con wire names estables.
extension RequestKindX on RequestKind {
  /// Wire name estable para persistencia externa.
  String get wireName {
    switch (this) {
      case RequestKind.generic:
        return 'generic';
    }
  }

  /// Parse estricto desde wire.
  static RequestKind fromWire(String raw) {
    switch (raw) {
      case 'generic':
        return RequestKind.generic;
      default:
        throw ArgumentError(
          'RequestKind desconocido (¿versión cliente desactualizada?): $raw',
        );
    }
  }
}

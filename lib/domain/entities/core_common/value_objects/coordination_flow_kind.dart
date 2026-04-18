// ============================================================================
// lib/domain/entities/core_common/value_objects/coordination_flow_kind.dart
// Tipología del CoordinationFlow (wire-stable).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

/// En v1 solo existe 'generic'. Punto de extensión para verticales.
enum CoordinationFlowKind {
  @JsonValue('generic')
  generic,
}

extension CoordinationFlowKindX on CoordinationFlowKind {
  String get wireName {
    switch (this) {
      case CoordinationFlowKind.generic:
        return 'generic';
    }
  }

  static CoordinationFlowKind fromWire(String raw) {
    switch (raw) {
      case 'generic':
        return CoordinationFlowKind.generic;
      default:
        throw ArgumentError('CoordinationFlowKind desconocido: $raw');
    }
  }
}

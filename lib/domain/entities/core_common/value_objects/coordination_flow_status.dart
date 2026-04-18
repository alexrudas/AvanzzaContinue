// ============================================================================
// lib/domain/entities/core_common/value_objects/coordination_flow_status.dart
// Estados del CoordinationFlow (Core Common v1 / F5 Hito 8+).
// ============================================================================
// QUÉ HACE:
//   - Declara el enum wire-stable del lifecycle de CoordinationFlow.
//   - wireName + @JsonValue sincronizados con el backend Prisma
//     (enum CoordinationFlowStatus).
//
// QUÉ NO HACE:
//   - No gobierna transiciones: Core API es la fuente de verdad.
//   - No expone allowedNext en v1 (el motor F2.c vive server-side).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

enum CoordinationFlowStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

extension CoordinationFlowStatusX on CoordinationFlowStatus {
  String get wireName {
    switch (this) {
      case CoordinationFlowStatus.draft:
        return 'draft';
      case CoordinationFlowStatus.active:
        return 'active';
      case CoordinationFlowStatus.completed:
        return 'completed';
      case CoordinationFlowStatus.cancelled:
        return 'cancelled';
    }
  }

  static CoordinationFlowStatus fromWire(String raw) {
    switch (raw) {
      case 'draft':
        return CoordinationFlowStatus.draft;
      case 'active':
        return CoordinationFlowStatus.active;
      case 'completed':
        return CoordinationFlowStatus.completed;
      case 'cancelled':
        return CoordinationFlowStatus.cancelled;
      default:
        throw ArgumentError('CoordinationFlowStatus desconocido: $raw');
    }
  }
}

// ============================================================================
// lib/domain/entities/core_common/coordination_flow_entity.dart
// COORDINATION FLOW ENTITY — Core Common v1 (F5 Hito 11 / Flutter alineado)
// ============================================================================
// QUÉ HACE:
//   - Modela el agrupador canónico de OperationalRequests bajo una Relación.
//   - Espejo estructural del modelo server-side (Prisma: CoordinationFlow).
//
// QUÉ NO HACE:
//   - No crea flows localmente: Core API es fuente de verdad. Esta entidad se
//     hidrata tras POST /v1/coordination-flows.
//   - No gobierna transiciones (draft→active→…): vive server-side.
//
// PRINCIPIOS:
//   - Dominio puro + freezed + json_serializable.
//   - Enums wire-stable (CoordinationFlowKind, CoordinationFlowStatus).
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects/coordination_flow_kind.dart';
import 'value_objects/coordination_flow_status.dart';

part 'coordination_flow_entity.freezed.dart';
part 'coordination_flow_entity.g.dart';

@freezed
abstract class CoordinationFlowEntity with _$CoordinationFlowEntity {
  const factory CoordinationFlowEntity({
    required String id,
    required String sourceWorkspaceId,
    required String relationshipId,

    /// userId del miembro del workspace que inició el flujo (server-derived).
    required String startedBy,

    @Default(CoordinationFlowKind.generic) CoordinationFlowKind flowKind,
    required CoordinationFlowStatus status,

    required DateTime statusUpdatedAt,
    required DateTime createdAt,
    required DateTime updatedAt,

    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) = _CoordinationFlowEntity;

  factory CoordinationFlowEntity.fromJson(Map<String, dynamic> json) =>
      _$CoordinationFlowEntityFromJson(json);
}

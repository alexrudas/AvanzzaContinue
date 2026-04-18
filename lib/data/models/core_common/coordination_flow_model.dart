// ============================================================================
// lib/data/models/core_common/coordination_flow_model.dart
// COORDINATION FLOW MODEL — Cache local (Isar) del CoordinationFlow canónico
// ============================================================================
// QUÉ HACE:
//   - Persiste CoordinationFlowEntity en Isar como cache offline.
//   - Wire-stable: los enums se guardan como string (wireName) para permitir
//     extender el enum server-side sin migración local forzada.
//
// QUÉ NO HACE:
//   - No es fuente de verdad: el backend la tiene. Esta tabla se hidrata tras
//     POST /v1/coordination-flows.
//   - No genera UUIDs locales. El id viene del backend.
// ============================================================================

// NOTA: import de isar_community sin alias — requerido por el codegen.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/coordination_flow_entity.dart';
import '../../../domain/entities/core_common/value_objects/coordination_flow_kind.dart';
import '../../../domain/entities/core_common/value_objects/coordination_flow_status.dart';

part 'coordination_flow_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class CoordinationFlowModel {
  /// Isar internal auto-id.
  Id? isarId;

  /// Business id (UUID generado server-side). Unique para evitar duplicados.
  @Index(unique: true)
  final String id;

  /// Partition key del workspace emisor.
  @Index(composite: [CompositeIndex('statusWire')])
  final String sourceWorkspaceId;

  /// FK al Relationship contenedor.
  @Index()
  final String relationshipId;

  /// userId del miembro del workspace que inició el flujo.
  final String startedBy;

  final String flowKindWire;
  final String statusWire;

  final DateTime statusUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  CoordinationFlowModel({
    this.isarId,
    required this.id,
    required this.sourceWorkspaceId,
    required this.relationshipId,
    required this.startedBy,
    this.flowKindWire = 'generic',
    required this.statusWire,
    required this.statusUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  CoordinationFlowEntity toEntity() => CoordinationFlowEntity(
        id: id,
        sourceWorkspaceId: sourceWorkspaceId,
        relationshipId: relationshipId,
        startedBy: startedBy,
        flowKind: CoordinationFlowKindX.fromWire(flowKindWire),
        status: CoordinationFlowStatusX.fromWire(statusWire),
        statusUpdatedAt: statusUpdatedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        startedAt: startedAt,
        completedAt: completedAt,
        cancelledAt: cancelledAt,
      );

  factory CoordinationFlowModel.fromEntity(CoordinationFlowEntity e) =>
      CoordinationFlowModel(
        id: e.id,
        sourceWorkspaceId: e.sourceWorkspaceId,
        relationshipId: e.relationshipId,
        startedBy: e.startedBy,
        flowKindWire: e.flowKind.wireName,
        statusWire: e.status.wireName,
        statusUpdatedAt: e.statusUpdatedAt.toUtc(),
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        startedAt: e.startedAt?.toUtc(),
        completedAt: e.completedAt?.toUtc(),
        cancelledAt: e.cancelledAt?.toUtc(),
      );

  factory CoordinationFlowModel.fromJson(Map<String, dynamic> json) =>
      _$CoordinationFlowModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinationFlowModelToJson(this);
}

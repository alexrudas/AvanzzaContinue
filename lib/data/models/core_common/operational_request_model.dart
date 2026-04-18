// ============================================================================
// lib/data/models/core_common/operational_request_model.dart
// OPERATIONAL REQUEST MODEL — Data Layer / Isar + JSON
// ============================================================================
// QUÉ HACE:
//   - Persiste OperationalRequestEntity en Isar.
//   - Guarda enums como String wire-stable.
//
// QUÉ NO HACE:
//   - No ejecuta transiciones (F2.b es el motor).
//   - No embebe deliveries.
//
// PRINCIPIOS:
//   - Wire-stable.
//   - Índices para consultas por relación y por workspace.
//
// ENTERPRISE NOTES:
//   - payloadJson es opaco en v1; extensiones por requestKind lo tiparán.
//   - El ciclo de vida es INDEPENDIENTE del de la Relación.
// ============================================================================

// NOTA: import de isar_community sin alias — requerido por el codegen.
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/core_common/operational_request_entity.dart';
import '../../../domain/entities/core_common/value_objects/request_kind.dart';
import '../../../domain/entities/core_common/value_objects/request_origin_channel.dart';
import '../../../domain/entities/core_common/value_objects/request_state.dart';

part 'operational_request_model.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class OperationalRequestModel {
  Id? isarId;

  /// Unique sin replace: las colisiones de id deben resolverse explícitamente.
  @Index(unique: true)
  final String id;

  /// Partition key del workspace emisor.
  @Index(composite: [CompositeIndex('stateWire')])
  final String sourceWorkspaceId;

  /// FK obligatoria a la Relación.
  @Index()
  final String relationshipId;

  final String requestKindWire;
  final String stateWire;

  final String title;
  final String createdBy;
  final String originChannelWire;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime stateUpdatedAt;

  final String? summary;
  final String? payloadJson;
  final String? notesSource;

  final DateTime? sentAt;
  final DateTime? respondedAt;
  final DateTime? closedAt;
  final DateTime? expiresAt;

  OperationalRequestModel({
    this.isarId,
    required this.id,
    required this.sourceWorkspaceId,
    required this.relationshipId,
    required this.requestKindWire,
    required this.stateWire,
    required this.title,
    required this.createdBy,
    required this.originChannelWire,
    required this.createdAt,
    required this.updatedAt,
    required this.stateUpdatedAt,
    this.summary,
    this.payloadJson,
    this.notesSource,
    this.sentAt,
    this.respondedAt,
    this.closedAt,
    this.expiresAt,
  });

  OperationalRequestEntity toEntity() => OperationalRequestEntity(
        id: id,
        sourceWorkspaceId: sourceWorkspaceId,
        relationshipId: relationshipId,
        requestKind: RequestKindX.fromWire(requestKindWire),
        state: RequestStateX.fromWire(stateWire),
        title: title,
        createdBy: createdBy,
        originChannel: RequestOriginChannelX.fromWire(originChannelWire),
        createdAt: createdAt,
        updatedAt: updatedAt,
        stateUpdatedAt: stateUpdatedAt,
        summary: summary,
        payloadJson: payloadJson,
        notesSource: notesSource,
        sentAt: sentAt,
        respondedAt: respondedAt,
        closedAt: closedAt,
        expiresAt: expiresAt,
      );

  factory OperationalRequestModel.fromEntity(OperationalRequestEntity e) =>
      OperationalRequestModel(
        id: e.id,
        sourceWorkspaceId: e.sourceWorkspaceId,
        relationshipId: e.relationshipId,
        requestKindWire: e.requestKind.wireName,
        stateWire: e.state.wireName,
        title: e.title,
        createdBy: e.createdBy,
        originChannelWire: e.originChannel.wireName,
        createdAt: e.createdAt.toUtc(),
        updatedAt: e.updatedAt.toUtc(),
        stateUpdatedAt: e.stateUpdatedAt.toUtc(),
        summary: e.summary,
        payloadJson: e.payloadJson,
        notesSource: e.notesSource,
        sentAt: e.sentAt?.toUtc(),
        respondedAt: e.respondedAt?.toUtc(),
        closedAt: e.closedAt?.toUtc(),
        expiresAt: e.expiresAt?.toUtc(),
      );

  factory OperationalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OperationalRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OperationalRequestModelToJson(this);
}

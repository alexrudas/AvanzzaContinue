import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/ai/ai_audit_log_entity.dart' as domain;

part 'ai_audit_log_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AIAuditLogModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  String id;
  @Index()
  String orgId;
  @Index()
  String userId;
  @Index()
  String accion;
  @Index()
  String modulo;

  /// Solo lo usamos en memoria, no se persiste
  @ignore
  Map<String, dynamic>? contexto;

  /// Guardado como JSON en la BD
  String? resultadoJson;

  @Index()
  DateTime createdAt;
  DateTime? updatedAt;

  AIAuditLogModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.userId,
    required this.accion,
    required this.modulo,
    this.contexto,
    this.resultadoJson,
    required this.createdAt,
    this.updatedAt,
  });

  factory AIAuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AIAuditLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$AIAuditLogModelToJson(this);

  factory AIAuditLogModel.fromFirestore(
    String docId,
    Map<String, dynamic> json,
  ) =>
      AIAuditLogModel.fromJson({...json, 'id': docId});

  factory AIAuditLogModel.fromEntity(domain.AIAuditLogEntity e) =>
      AIAuditLogModel(
        id: e.id,
        orgId: e.orgId,
        userId: e.userId,
        accion: e.accion,
        modulo: e.modulo,
        contexto: e.contexto,
        resultadoJson: jsonEncode(e.resultado),
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AIAuditLogEntity toEntity() => domain.AIAuditLogEntity(
        id: id,
        orgId: orgId,
        userId: userId,
        accion: accion,
        modulo: modulo,
        contexto: contexto ?? const {},
        resultado: (() {
          if (resultadoJson == null || resultadoJson!.isEmpty) {
            return <String, dynamic>{};
          }
          final decoded = jsonDecode(resultadoJson!);
          return decoded is Map<String, dynamic>
              ? decoded
              : Map<String, dynamic>.from(decoded as Map);
        })(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

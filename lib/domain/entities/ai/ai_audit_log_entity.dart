import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_audit_log_entity.freezed.dart';
part 'ai_audit_log_entity.g.dart';

@freezed
abstract class AIAuditLogEntity with _$AIAuditLogEntity {
  const factory AIAuditLogEntity({
    required String id,
    required String orgId,
    required String userId,
    required String accion, // consulta | ejecución sugerida | rechazo
    required String modulo,
    required Map<String, dynamic> contexto,
    required Map<String, dynamic> resultado,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AIAuditLogEntity;

  factory AIAuditLogEntity.fromJson(Map<String, dynamic> json) => _$AIAuditLogEntityFromJson(json);
}

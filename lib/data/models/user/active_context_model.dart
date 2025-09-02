import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user/active_context.dart' as domain;

part 'active_context_model.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class ActiveContextModel {
  String? orgId;
  String? orgName;
  String? rol;

  ActiveContextModel({this.orgId, this.orgName, this.rol});

  factory ActiveContextModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveContextModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveContextModelToJson(this);

  factory ActiveContextModel.fromEntity(domain.ActiveContext e) =>
      ActiveContextModel(orgId: e.orgId, orgName: e.orgName, rol: e.rol);

  domain.ActiveContext toEntity() => domain.ActiveContext(
        orgId: orgId ?? '',
        orgName: orgName ?? '',
        rol: rol ?? '',
      );
}

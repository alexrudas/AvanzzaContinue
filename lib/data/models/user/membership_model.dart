import 'dart:convert';

import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user/membership_entity.dart' as domain;

part 'membership_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class MembershipModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id; // synthetic key: userId_orgId
  @Index()
  final String userId;
  @Index()
  final String orgId;
  final String orgName;
  final List<String> roles;
  final String estatus;

  // ANTES: Map<String, String> primaryLocation
  final String? primaryLocationJson; // JSON de {countryId, regionId?, cityId?}

  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  MembershipModel({
    this.isarId,
    required this.id,
    required this.userId,
    required this.orgId,
    required this.orgName,
    this.roles = const [],
    required this.estatus,
    this.primaryLocationJson,
    this.createdAt,
    this.updatedAt,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);
  Map<String, dynamic> toJson() => _$MembershipModelToJson(this);

  factory MembershipModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      MembershipModel.fromJson({...json, 'id': docId});

  factory MembershipModel.fromEntity(domain.MembershipEntity e) =>
      MembershipModel(
        id: '${e.userId}_${e.orgId}',
        userId: e.userId,
        orgId: e.orgId,
        orgName: e.orgName,
        roles: e.roles,
        estatus: e.estatus,
        primaryLocationJson: jsonEncode(e.primaryLocation),
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.MembershipEntity toEntity() => domain.MembershipEntity(
        userId: userId,
        orgId: orgId,
        orgName: orgName,
        roles: roles,
        estatus: estatus,
        primaryLocation: () {
          if (primaryLocationJson == null || primaryLocationJson!.isEmpty) {
            return <String, String>{};
          }
          final m = Map<String, dynamic>.from(
              jsonDecode(primaryLocationJson!) as Map);
          return m.map((k, v) => MapEntry(k, v?.toString() ?? ''));
        }(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

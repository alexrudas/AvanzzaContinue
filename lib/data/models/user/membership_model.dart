import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:isar_community/isar.dart' as isar;
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user/membership_entity.dart' as domain;
import '../common/converters/doc_ref_path_converter.dart';

part 'membership_model.g.dart';
part 'membership_model.isar.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class MembershipModel {
  isar.Id? isarId;

  @isar.Index(unique: true)
  final String id; // synthetic key: userId_orgId
  @isar.Index()
  final String userId;
  @isar.Index()
  final String orgId;
  final String orgName;
  final List<String> roles;
  @isar.Index()
  final String estatus;

  // primaryLocation persistido como JSON en Isar
  final String? primaryLocationJson; // JSON de {countryId, regionId?, cityId?}

  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? orgRef;
  final String? orgRefPath;

  final DateTime? createdAt;
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
    this.orgRef,
    this.orgRefPath,
    this.createdAt,
    this.updatedAt,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);
  Map<String, dynamic> toJson() => _$MembershipModelToJson(this);

  static DocumentReference<Map<String, dynamic>>? _refFrom(
      FirebaseFirestore db, dynamic any) {
    if (any is DocumentReference) {
      return any.withConverter<Map<String, dynamic>>(
        fromFirestore: (s, _) => s.data() ?? <String, dynamic>{},
        toFirestore: (m, _) => m,
      );
    }
    if (any is String && any.isNotEmpty) return db.doc(any);
    return null;
  }

  static DateTime? _parseTimestamp(Object? v) {
    if (v == null) return null;
    if (v is fs.Timestamp) return v.toDate().toUtc();
    if (v is String) return DateTime.tryParse(v)?.toUtc();
    if (v is num) {
      final isMillis = v.abs() >= 1000000000000;
      final ms = isMillis ? v.toInt() : (v * 1000).toInt();
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    }
    if (v is Map) {
      final s = v['seconds'] ?? v['_seconds'];
      final ns = v['nanoseconds'] ?? v['_nanoseconds'] ?? 0;
      if (s is num && ns is num) {
        final ms = (s * 1000).toInt() + (ns / 1e6).round();
        return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
      }
    }
    return null;
  }

  factory MembershipModel.fromFirestore(String docId, Map<String, dynamic> json,
      {required FirebaseFirestore db}) {
    const conv = DocRefPathConverter();
    final oRef = _refFrom(db, json['orgRef']);
    String? orgId = json['orgId'] as String?;
    orgId ??= oRef?.id;

    return MembershipModel(
      id: docId,
      userId: (json['userId'] as String?) ?? '',
      orgId: orgId ?? '',
      orgName: (json['orgName'] as String?) ?? '',
      roles: (json['roles'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[],
      estatus: (json['estatus'] as String?) ?? 'activo',
      primaryLocationJson:
          jsonEncode(json['primaryLocation'] ?? const <String, String>{}),
      orgRef: oRef,
      orgRefPath: conv.toPath(oRef),
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'userId': userId,
      'orgName': orgName,
      'roles': roles,
      'estatus': estatus,
      if (primaryLocationJson != null && primaryLocationJson!.isNotEmpty)
        'primaryLocation': jsonDecode(primaryLocationJson!),
      'orgRef': orgRef,
    };
  }

  Map<String, dynamic> toIsarJson() {
    return {
      'id': id,
      'userId': userId,
      'orgId': orgId,
      'orgName': orgName,
      'roles': roles,
      'estatus': estatus,
      'primaryLocationJson': primaryLocationJson,
      'orgRefPath': orgRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MembershipModel.fromIsar(
      Map<String, dynamic> isar, FirebaseFirestore db) {
    const conv = DocRefPathConverter();
    final oPath = isar['orgRefPath'] as String?;
    return MembershipModel(
      id: isar['id'] as String,
      userId: isar['userId'] as String,
      orgId: isar['orgId'] as String,
      orgName: isar['orgName'] as String,
      roles: (isar['roles'] as List?)?.map((e) => e.toString()).toList() ??
          const <String>[],
      estatus: isar['estatus'] as String,
      primaryLocationJson: isar['primaryLocationJson'] as String?,
      orgRef: conv.fromPath(db, oPath),
      orgRefPath: oPath,
      createdAt: (isar['createdAt'] is String)
          ? DateTime.tryParse(isar['createdAt'] as String)
          : null,
      updatedAt: (isar['updatedAt'] is String)
          ? DateTime.tryParse(isar['updatedAt'] as String)
          : null,
    );
  }

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

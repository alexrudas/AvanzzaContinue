/// CityModel (Homogeneizado)
/// ------------------------------------------------------------
/// Propósito:
/// - Compatibilidad *_Id/*Ref con serialización dual (Firestore vs Isar/local)
/// - Refs ignoradas en JSON y Isar (paths para persistencia local)
library;

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/city_entity.dart' as domain;
import '../common/converters/doc_ref_path_converter.dart';

part 'city_model.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class CityModel {
  isar.Id? isarId;

  @isar.Index(unique: true, replace: true)
  final String id;

  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? countryRef;
  final String? countryRefPath;
  @isar.Index()
  final String countryId;

  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? regionRef;
  final String? regionRefPath;
  @isar.Index()
  final String regionId;

  @isar.Index()
  final String? regionCode;
  @isar.Index()
  final String? cityCode;

  final String name;

  static double? _toDouble(Object? v) => v == null
      ? null
      : (v is num ? v.toDouble() : double.tryParse(v.toString()));

  @JsonKey(fromJson: _toDouble)
  final double? lat;
  @JsonKey(fromJson: _toDouble)
  final double? lng;

  final String? timezoneOverride;
  @isar.Index()
  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CityModel({
    this.isarId,
    required this.id,
    this.countryRef,
    this.countryRefPath,
    required this.countryId,
    this.regionRef,
    this.regionRefPath,
    required this.regionId,
    this.regionCode,
    this.cityCode,
    required this.name,
    this.lat,
    this.lng,
    this.timezoneOverride,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);

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

  factory CityModel.fromFirestore(
    String docId,
    Map<String, dynamic> json, {
    required FirebaseFirestore db,
  }) {
    const conv = DocRefPathConverter();
    final cRef = _refFrom(db, json['countryRef']);
    final rRef = _refFrom(db, json['regionRef']);

    String? countryId = json['countryId'] as String?;
    String? regionId = json['regionId'] as String?;
    countryId ??= cRef?.id;
    regionId ??= rRef?.id;

    return CityModel(
      id: docId,
      countryRef: cRef,
      countryRefPath: conv.toPath(cRef),
      countryId: countryId ?? '',
      regionRef: rRef,
      regionRefPath: conv.toPath(rRef),
      regionId: regionId ?? '',
      regionCode: json['regionCode'] as String?,
      cityCode: json['cityCode'] as String?,
      name: (json['name'] as String?) ?? '',
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
      timezoneOverride: json['timezoneOverride'] as String?,
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'timezoneOverride': timezoneOverride,
      'isActive': isActive,
      'countryRef': countryRef,
      'regionRef': regionRef,
      'regionCode': regionCode,
      'cityCode': cityCode,
    };
  }

  Map<String, dynamic> toIsarJson() {
    return {
      'id': id,
      'countryId': countryId,
      'regionId': regionId,
      'regionCode': regionCode,
      'cityCode': cityCode,
      'name': name,
      'lat': lat,
      'lng': lng,
      'timezoneOverride': timezoneOverride,
      'isActive': isActive,
      'countryRefPath': countryRefPath,
      'regionRefPath': regionRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CityModel.fromIsar(Map<String, dynamic> isar, FirebaseFirestore db) {
    const conv = DocRefPathConverter();
    final cPath = isar['countryRefPath'] as String?;
    final rPath = isar['regionRefPath'] as String?;
    return CityModel(
      id: isar['id'] as String,
      countryId: isar['countryId'] as String,
      regionId: isar['regionId'] as String,
      regionCode: isar['regionCode'] as String?,
      cityCode: isar['cityCode'] as String?,
      name: (isar['name'] as String?) ?? '',
      lat: _toDouble(isar['lat']),
      lng: _toDouble(isar['lng']),
      timezoneOverride: isar['timezoneOverride'] as String?,
      isActive: (isar['isActive'] as bool?) ?? true,
      countryRef: conv.fromPath(db, cPath),
      countryRefPath: cPath,
      regionRef: conv.fromPath(db, rPath),
      regionRefPath: rPath,
      createdAt: (isar['createdAt'] is String)
          ? DateTime.tryParse(isar['createdAt'] as String)
          : null,
      updatedAt: (isar['updatedAt'] is String)
          ? DateTime.tryParse(isar['updatedAt'] as String)
          : null,
    );
  }

  factory CityModel.fromEntity(domain.CityEntity e) => CityModel(
        id: e.id,
        countryId: e.countryId,
        regionId: e.regionId,
        name: e.name,
        lat: e.lat,
        lng: e.lng,
        timezoneOverride: e.timezoneOverride,
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.CityEntity toEntity() => domain.CityEntity(
        id: id,
        countryId: countryId,
        regionId: regionId,
        name: name,
        lat: lat,
        lng: lng,
        timezoneOverride: timezoneOverride,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

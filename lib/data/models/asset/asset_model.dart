import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:isar_community/isar.dart' as isar;
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/asset/asset_entity.dart' as domain;
import '../common/converters/doc_ref_path_converter.dart';

part 'asset_model.g.dart';
part 'asset_model.isar.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class AssetModel {
  isar.Id? isarId;

  @isar.Index(unique: true)
  final String id;

  // Índices útiles: orgId, estado, cityId (assetType/ownerId opcional si se filtra)
  @isar.Index()
  final String orgId;

  final String assetType;
  final String countryId;
  final String? regionId;
  @isar.Index()
  final String? cityId;

  final String ownerType;
  final String ownerId;
  @isar.Index()
  final String estado;

  @JsonKey(defaultValue: <String>[])
  final List<String> etiquetas;
  @JsonKey(defaultValue: <String>[])
  final List<String> fotosUrls;

  // Refs ignoradas por JsonSerializable + paths para Isar/local
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? orgRef;

  final String? orgRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? ownerRef;

  final String? ownerRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? countryRef;

  final String? countryRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? regionRef;

  final String? regionRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? cityRef;

  final String? cityRefPath;

  // Timestamps (parseo en factories; no incluir en toFirestoreJson)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssetModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetType,
    required this.countryId,
    this.regionId,
    this.cityId,
    required this.ownerType,
    required this.ownerId,
    required this.estado,
    this.etiquetas = const [],
    this.fotosUrls = const [],
    this.orgRef,
    this.orgRefPath,
    this.ownerRef,
    this.ownerRefPath,
    this.countryRef,
    this.countryRefPath,
    this.regionRef,
    this.regionRefPath,
    this.cityRef,
    this.cityRefPath,
    this.createdAt,
    this.updatedAt,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetModelToJson(this);

  // Firestore: acepta DocumentReference o path en refs; completa *_Id; parsea timestamps
  factory AssetModel.fromFirestore(
    String docId,
    Map<String, dynamic> json, {
    required FirebaseFirestore db,
  }) {
    const conv = DocRefPathConverter();

    DocumentReference<Map<String, dynamic>>? refFrom(
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

    final oRef = refFrom(db, json['orgRef']);
    final owRef = refFrom(db, json['ownerRef']);
    final cRef = refFrom(db, json['countryRef']);
    final rRef = refFrom(db, json['regionRef']);
    final ciRef = refFrom(db, json['cityRef']);

    String? orgId = json['orgId'] as String?;
    String? ownerId = json['ownerId'] as String?;
    String? countryId = json['countryId'] as String?;
    String? regionId = json['regionId'] as String?;
    String? cityId = json['cityId'] as String?;

    orgId ??= oRef?.id;
    ownerId ??= owRef?.id;
    countryId ??= cRef?.id;
    regionId ??= rRef?.id;
    cityId ??= ciRef?.id;

    DateTime? parseTimestamp(Object? v) {
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

    return AssetModel(
      id: docId,
      orgId: orgId ?? '',
      assetType: (json['assetType'] as String?) ?? '',
      countryId: countryId ?? '',
      regionId: regionId,
      cityId: cityId,
      ownerType: (json['ownerType'] as String?) ?? 'org',
      ownerId: ownerId ?? '',
      estado: (json['estado'] as String?) ?? 'activo',
      etiquetas:
          (json['etiquetas'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      fotosUrls:
          (json['fotosUrls'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      orgRef: oRef,
      orgRefPath: conv.toPath(oRef),
      ownerRef: owRef,
      ownerRefPath: conv.toPath(owRef),
      countryRef: cRef,
      countryRefPath: conv.toPath(cRef),
      regionRef: rRef,
      regionRefPath: conv.toPath(rRef),
      cityRef: ciRef,
      cityRefPath: conv.toPath(ciRef),
      createdAt: parseTimestamp(json['createdAt']),
      updatedAt: parseTimestamp(json['updatedAt']),
    );
  }

  // Firestore: incluir refs + primitivos; omitir *_Id y timestamps
  Map<String, dynamic> toFirestoreJson() {
    return {
      'assetType': assetType,
      'ownerType': ownerType,
      'estado': estado,
      'etiquetas': etiquetas,
      'fotosUrls': fotosUrls,
      'orgRef': orgRef,
      'ownerRef': ownerRef,
      'countryRef': countryRef,
      'regionRef': regionRef,
      'cityRef': cityRef,
    };
  }

  // Isar/local: primitivos + paths + timestamps ISO
  Map<String, dynamic> toIsarJson() {
    return {
      'id': id,
      'orgId': orgId,
      'assetType': assetType,
      'countryId': countryId,
      'regionId': regionId,
      'cityId': cityId,
      'ownerType': ownerType,
      'ownerId': ownerId,
      'estado': estado,
      'etiquetas': etiquetas,
      'fotosUrls': fotosUrls,
      'orgRefPath': orgRefPath,
      'ownerRefPath': ownerRefPath,
      'countryRefPath': countryRefPath,
      'regionRefPath': regionRefPath,
      'cityRefPath': cityRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Reconstrucción desde Isar/local
  factory AssetModel.fromIsar(Map<String, dynamic> isar, FirebaseFirestore db) {
    const conv = DocRefPathConverter();
    final oPath = isar['orgRefPath'] as String?;
    final owPath = isar['ownerRefPath'] as String?;
    final cPath = isar['countryRefPath'] as String?;
    final rPath = isar['regionRefPath'] as String?;
    final ciPath = isar['cityRefPath'] as String?;

    return AssetModel(
      id: isar['id'] as String,
      orgId: isar['orgId'] as String,
      assetType: isar['assetType'] as String,
      countryId: isar['countryId'] as String,
      regionId: isar['regionId'] as String?,
      cityId: isar['cityId'] as String?,
      ownerType: isar['ownerType'] as String,
      ownerId: isar['ownerId'] as String,
      estado: isar['estado'] as String,
      etiquetas:
          (isar['etiquetas'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      fotosUrls:
          (isar['fotosUrls'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      orgRef: conv.fromPath(db, oPath),
      orgRefPath: oPath,
      ownerRef: conv.fromPath(db, owPath),
      ownerRefPath: owPath,
      countryRef: conv.fromPath(db, cPath),
      countryRefPath: cPath,
      regionRef: conv.fromPath(db, rPath),
      regionRefPath: rPath,
      cityRef: conv.fromPath(db, ciPath),
      cityRefPath: ciPath,
      createdAt: (isar['createdAt'] is String)
          ? DateTime.tryParse(isar['createdAt'] as String)
          : null,
      updatedAt: (isar['updatedAt'] is String)
          ? DateTime.tryParse(isar['updatedAt'] as String)
          : null,
    );
  }

  factory AssetModel.fromEntity(domain.AssetEntity e) => AssetModel(
        id: e.id,
        orgId: e.orgId,
        assetType: e.assetType,
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        ownerType: e.ownerType,
        ownerId: e.ownerId,
        estado: e.estado,
        etiquetas: e.etiquetas,
        fotosUrls: e.fotosUrls,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AssetEntity toEntity() => domain.AssetEntity(
        id: id,
        orgId: orgId,
        assetType: assetType,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        ownerType: ownerType,
        ownerId: ownerId,
        estado: estado,
        etiquetas: etiquetas,
        fotosUrls: fotosUrls,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

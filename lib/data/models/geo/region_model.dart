/// RegionModel (Homogeneizado)
/// ------------------------------------------------------------
/// Propósito:
/// - Compatibilidad *_Id/*Ref con serialización dual:
///   - Firestore: toFirestoreJson() escribe refs nativos; omite *_Id y timestamps.
///   - Isar/local: toIsarJson() persiste paths de refs y timestamps ISO.
/// Factorías:
/// - fromFirestore(db): acepta DocumentReference o path String, completa *_Id si falta y setea ref+path.
/// - fromIsar(db): reconstruye refs desde paths guardados.
library;

import 'package:cloud_firestore/cloud_firestore.dart' as fs
    show FirebaseFirestore, DocumentReference, Timestamp;
import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/region_entity.dart' as domain;
import '../common/converters/doc_ref_path_converter.dart';

part 'region_model.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class RegionModel {
  isar.Id? isarId;

  @isar.Index(unique: true)
  final String id;

  // Refs ignoradas por JsonSerializable (se manejan en fábricas)
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final fs.DocumentReference<Map<String, dynamic>>? countryRef;

  final String? countryRefPath; // Path para Isar/local

  // Legacy IDs para filtros/compatibilidad
  @isar.Index()
  final String countryId;

  final String name;
  final String? code;

  @isar.Index()
  final bool isActive;

  // Timestamps (no se incluyen en toFirestoreJson)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RegionModel({
    this.isarId,
    required this.id,
    this.countryRef,
    this.countryRefPath,
    required this.countryId,
    required this.name,
    this.code,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Serialización local (Isar) básica
  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionModelToJson(this);

  // Construcción desde Firestore (acepta ref nativo o path)
  factory RegionModel.fromFirestore(
    String docId,
    Map<String, dynamic> json, {
    required fs.FirebaseFirestore db,
  }) {
    const conv = DocRefPathConverter();
    final anyRef = json['countryRef'];
    fs.DocumentReference<Map<String, dynamic>>? cRef;
    if (anyRef is fs.DocumentReference) {
      cRef = anyRef.withConverter<Map<String, dynamic>>(
        fromFirestore: (s, _) => s.data() ?? <String, dynamic>{},
        toFirestore: (m, _) => m,
      );
    } else if (anyRef is String && anyRef.isNotEmpty) {
      cRef = db.doc(anyRef);
    }

    String? countryId = json['countryId'] as String?;
    countryId ??= cRef?.id;

    DateTime? parseTs(Object? v) {
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

    return RegionModel(
      id: docId,
      countryRef: cRef,
      countryRefPath: conv.toPath(cRef),
      countryId: countryId ?? '',
      name: (json['name'] as String?) ?? '',
      code: json['code'] as String?,
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: parseTs(json['createdAt']),
      updatedAt: parseTs(json['updatedAt']),
    );
  }

  // Firestore: incluir refs, omitir *_Id y timestamps
  Map<String, dynamic> toFirestoreJson() {
    return {
      'name': name,
      'code': code,
      'isActive': isActive,
      'countryRef': countryRef,
    };
  }

  // Isar/local: persistir paths y primitivos
  Map<String, dynamic> toIsarJson() {
    return {
      'id': id,
      'countryId': countryId,
      'name': name,
      'code': code,
      'isActive': isActive,
      'countryRefPath': countryRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Reconstrucción desde Isar/local
  factory RegionModel.fromIsar(
      Map<String, dynamic> isar, fs.FirebaseFirestore db) {
    const conv = DocRefPathConverter();
    final cPath = isar['countryRefPath'] as String?;
    return RegionModel(
      id: isar['id'] as String,
      countryId: isar['countryId'] as String,
      name: (isar['name'] as String?) ?? '',
      code: isar['code'] as String?,
      isActive: (isar['isActive'] as bool?) ?? true,
      countryRef: conv.fromPath(db, cPath),
      countryRefPath: cPath,
      createdAt: (isar['createdAt'] is String)
          ? DateTime.tryParse(isar['createdAt'] as String)
          : null,
      updatedAt: (isar['updatedAt'] is String)
          ? DateTime.tryParse(isar['updatedAt'] as String)
          : null,
    );
  }

  // Mapeos dominio
  factory RegionModel.fromEntity(domain.RegionEntity e) => RegionModel(
        id: e.id,
        countryId: e.countryId,
        name: e.name,
        code: e.code,
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.RegionEntity toEntity() => domain.RegionEntity(
        id: id,
        countryId: countryId,
        name: name,
        code: code,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

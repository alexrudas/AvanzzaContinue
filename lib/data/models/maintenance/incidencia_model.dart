import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:isar_community/isar.dart' as isar;
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/maintenance/incidencia_entity.dart' as domain;
import '../common/converters/doc_ref_path_converter.dart';

part 'incidencia_model.g.dart';
part 'incidencia_model.isar.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class IncidenciaModel {
  isar.Id? isarId;

  @isar.Index(unique: true)
  final String id;
  @isar.Index()
  final String orgId;
  @isar.Index()
  final String assetId;
  final String descripcion;
  final List<String> fotosUrls;
  @isar.Index()
  final String? prioridad;
  @isar.Index()
  final String estado;
  @isar.Index()
  final String reportedBy;
  @isar.Index()
  final String? cityId;

  // Refs ignoradas + paths
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? orgRef;
  final String? orgRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? assetRef;
  final String? assetRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? reportedByRef;
  final String? reportedByRefPath;
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? cityRef;
  final String? cityRefPath;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  IncidenciaModel({
    this.isarId,
    required this.id,
    required this.orgId,
    required this.assetId,
    required this.descripcion,
    this.fotosUrls = const [],
    this.prioridad,
    required this.estado,
    required this.reportedBy,
    this.cityId,
    this.orgRef,
    this.orgRefPath,
    this.assetRef,
    this.assetRefPath,
    this.reportedByRef,
    this.reportedByRefPath,
    this.cityRef,
    this.cityRefPath,
    this.createdAt,
    this.updatedAt,
  });

  factory IncidenciaModel.fromJson(Map<String, dynamic> json) =>
      _$IncidenciaModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncidenciaModelToJson(this);

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

  factory IncidenciaModel.fromFirestore(
    String docId,
    Map<String, dynamic> json, {
    required FirebaseFirestore db,
  }) {
    const conv = DocRefPathConverter();

    final oRef = _refFrom(db, json['orgRef']);
    final aRef = _refFrom(db, json['assetRef']);
    final rRef = _refFrom(db, json['reportedByRef']);
    final cRef = _refFrom(db, json['cityRef']);

    String? orgId = json['orgId'] as String?;
    String? assetId = json['assetId'] as String?;
    String? reportedBy = json['reportedBy'] as String?;
    String? cityId = json['cityId'] as String?;

    orgId ??= oRef?.id;
    assetId ??= aRef?.id;
    reportedBy ??= rRef?.id;
    cityId ??= cRef?.id;

    return IncidenciaModel(
      id: docId,
      orgId: orgId ?? '',
      assetId: assetId ?? '',
      descripcion: (json['descripcion'] as String?) ?? '',
      fotosUrls:
          (json['fotosUrls'] as List?)?.map((e) => e.toString()).toList() ??
              const <String>[],
      prioridad: json['prioridad'] as String?,
      estado: (json['estado'] as String?) ?? 'abierta',
      reportedBy: reportedBy ?? '',
      cityId: cityId,
      orgRef: oRef,
      orgRefPath: conv.toPath(oRef),
      assetRef: aRef,
      assetRefPath: conv.toPath(aRef),
      reportedByRef: rRef,
      reportedByRefPath: conv.toPath(rRef),
      cityRef: cRef,
      cityRefPath: conv.toPath(cRef),
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'descripcion': descripcion,
      'fotosUrls': fotosUrls,
      'prioridad': prioridad,
      'estado': estado,
      'reportedBy': reportedBy,
      'orgRef': orgRef,
      'assetRef': assetRef,
      'reportedByRef': reportedByRef,
      'cityRef': cityRef,
    };
  }

  Map<String, dynamic> toIsarJson() {
    return {
      'id': id,
      'orgId': orgId,
      'assetId': assetId,
      'descripcion': descripcion,
      'fotosUrls': fotosUrls,
      'prioridad': prioridad,
      'estado': estado,
      'reportedBy': reportedBy,
      'cityId': cityId,
      'orgRefPath': orgRefPath,
      'assetRefPath': assetRefPath,
      'reportedByRefPath': reportedByRefPath,
      'cityRefPath': cityRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory IncidenciaModel.fromIsar(
      Map<String, dynamic> isar, FirebaseFirestore db) {
    const conv = DocRefPathConverter();
    final oPath = isar['orgRefPath'] as String?;
    final aPath = isar['assetRefPath'] as String?;
    final rPath = isar['reportedByRefPath'] as String?;
    final cPath = isar['cityRefPath'] as String?;

    return IncidenciaModel(
      id: isar['id'] as String,
      orgId: isar['orgId'] as String,
      assetId: isar['assetId'] as String,
      descripcion: (isar['descripcion'] as String?) ?? '',
      fotosUrls:
          (isar['fotosUrls'] as List?)?.map((e) => e.toString()).toList() ??
              const <String>[],
      prioridad: isar['prioridad'] as String?,
      estado: isar['estado'] as String? ?? 'abierta',
      reportedBy: isar['reportedBy'] as String? ?? '',
      cityId: isar['cityId'] as String?,
      orgRef: conv.fromPath(db, oPath),
      orgRefPath: oPath,
      assetRef: conv.fromPath(db, aPath),
      assetRefPath: aPath,
      reportedByRef: conv.fromPath(db, rPath),
      reportedByRefPath: rPath,
      cityRef: conv.fromPath(db, cPath),
      cityRefPath: cPath,
      createdAt: (isar['createdAt'] is String)
          ? DateTime.tryParse(isar['createdAt'] as String)
          : null,
      updatedAt: (isar['updatedAt'] is String)
          ? DateTime.tryParse(isar['updatedAt'] as String)
          : null,
    );
  }

  factory IncidenciaModel.fromEntity(domain.IncidenciaEntity e) =>
      IncidenciaModel(
        id: e.id,
        orgId: e.orgId,
        assetId: e.assetId,
        descripcion: e.descripcion,
        fotosUrls: e.fotosUrls,
        prioridad: e.prioridad,
        estado: e.estado,
        reportedBy: e.reportedBy,
        cityId: e.cityId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.IncidenciaEntity toEntity() => domain.IncidenciaEntity(
        id: id,
        orgId: orgId,
        assetId: assetId,
        descripcion: descripcion,
        fotosUrls: fotosUrls,
        prioridad: prioridad,
        estado: estado,
        reportedBy: reportedBy,
        cityId: cityId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/org/organization_entity.dart' as domain;
import '../../../domain/value/organization_contract/organization_access_contract.dart';
import '../common/converters/doc_ref_path_converter.dart';

part 'organization_model.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class OrganizationModel {
  isar.Id? isarId;

  @isar.Index(unique: true, replace: true)
  final String id;

  String nombre;
  String tipo;
  @isar.Index()
  final String countryId;

  @isar.Index()
  String? regionId;
  @isar.Index()
  String? cityId;

  @isar.Index()
  String? ownerUid;

  String? logoUrl;

  // Refs ignoradas + paths para Isar/local
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
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? ownerRef;
  final String? ownerRefPath;

  // antes: Map<String, dynamic>? metadata;
  String? metadataJson;

  /// Contrato de acceso serializado como JSON String (Isar-safe).
  /// Expected shape: OrganizationAccessContract.toJson()
  String? contractJson;

  @isar.Index()
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrganizationModel({
    this.isarId,
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.countryId,
    this.regionId,
    this.cityId,
    this.ownerUid,
    this.logoUrl,
    this.countryRef,
    this.countryRefPath,
    this.regionRef,
    this.regionRefPath,
    this.cityRef,
    this.cityRefPath,
    this.ownerRef,
    this.ownerRefPath,
    this.metadataJson,
    this.contractJson,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);

  // --------------------------------------------------------------------------
  // SAFE PARSERS (ISAR-SAFE)
  // --------------------------------------------------------------------------

  /// Parse seguro de `contractJson` → `OrganizationAccessContract`.
  /// Si falla o es null/vacío, retorna default restrictivo (deny-by-default).
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  OrganizationAccessContract get parsedContract {
    if (contractJson == null || contractJson!.trim().isEmpty) {
      return const OrganizationAccessContract();
    }
    try {
      final map = jsonDecode(contractJson!) as Map<String, dynamic>;
      return OrganizationAccessContract.fromJson(map);
    } catch (_) {
      return const OrganizationAccessContract();
    }
  }

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

  /// Serializa OrganizationAccessContract a JSON String.
  /// Retorna null si es el default restrictivo (ahorra bytes).
  static String? _encodeContractJson(OrganizationAccessContract contract) {
    // Si es el default (deny-by-default), no persistir — ahorra bytes.
    if (contract == const OrganizationAccessContract()) return null;
    try {
      return jsonEncode(contract.toJson());
    } catch (_) {
      return null;
    }
  }

  /// Normaliza contract desde Firestore (puede venir como Map o String).
  static String? _parseContractJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map) {
      try {
        final m = Map<String, dynamic>.from(raw);
        return m.isEmpty ? null : jsonEncode(m);
      } catch (_) {
        return null;
      }
    }
    if (raw is String && raw.trim().isNotEmpty) {
      // Validate it's valid JSON before persisting
      try {
        final decoded = jsonDecode(raw.trim());
        if (decoded is Map) return jsonEncode(decoded);
      } catch (_) {
        // ignore corruption
      }
    }
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

  // Firestore: acepta refs/path; completa *_Id; parsea timestamps
  factory OrganizationModel.fromFirestore(
    String docId,
    Map<String, dynamic> json, {
    required FirebaseFirestore db,
  }) {
    const conv = DocRefPathConverter();

    final cRef = _refFrom(db, json['countryRef']);
    final rRef = _refFrom(db, json['regionRef']);
    final ciRef = _refFrom(db, json['cityRef']);
    final oRef = _refFrom(db, json['ownerRef']);

    String? countryId = json['countryId'] as String?;
    String? regionId = json['regionId'] as String?;
    String? cityId = json['cityId'] as String?;
    String? ownerUid = json['ownerUid'] as String?;

    countryId ??= cRef?.id;
    regionId ??= rRef?.id;
    cityId ??= ciRef?.id;
    ownerUid ??= oRef?.id;

    return OrganizationModel(
      id: docId,
      nombre: (json['nombre'] as String?) ?? '',
      tipo: (json['tipo'] as String?) ?? 'personal',
      countryId: countryId ?? '',
      regionId: regionId,
      cityId: cityId,
      ownerUid: ownerUid,
      logoUrl: json['logoUrl'] as String?,
      countryRef: cRef,
      countryRefPath: conv.toPath(cRef),
      regionRef: rRef,
      regionRefPath: conv.toPath(rRef),
      cityRef: ciRef,
      cityRefPath: conv.toPath(ciRef),
      ownerRef: oRef,
      ownerRefPath: conv.toPath(oRef),
      metadataJson: json['metadataJson'] as String?,
      contractJson: _parseContractJson(json['contract']),
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  // Firestore: primitivos + refs; omitir *_Id y timestamps
  Map<String, dynamic> toFirestoreJson() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'logoUrl': logoUrl,
      'isActive': isActive,
      'countryRef': countryRef,
      'regionRef': regionRef,
      'cityRef': cityRef,
      'ownerRef': ownerRef,
      if (metadataJson != null && metadataJson!.isNotEmpty)
        'metadata': jsonDecode(metadataJson!),
      if (contractJson != null && contractJson!.isNotEmpty)
        'contract': jsonDecode(contractJson!),
    };
  }

  // Isar/local: primitivos + paths + timestamps ISO
  Map<String, dynamic> toIsarJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'countryId': countryId,
      'regionId': regionId,
      'cityId': cityId,
      'ownerUid': ownerUid,
      'logoUrl': logoUrl,
      'metadataJson': metadataJson,
      'contractJson': contractJson,
      'isActive': isActive,
      'countryRefPath': countryRefPath,
      'regionRefPath': regionRefPath,
      'cityRefPath': cityRefPath,
      'ownerRefPath': ownerRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Reconstrucción desde Isar/local
  factory OrganizationModel.fromIsar(
      Map<String, dynamic> isar, FirebaseFirestore db) {
    const conv = DocRefPathConverter();
    final cPath = isar['countryRefPath'] as String?;
    final rPath = isar['regionRefPath'] as String?;
    final ciPath = isar['cityRefPath'] as String?;
    final oPath = isar['ownerRefPath'] as String?;

    return OrganizationModel(
      id: isar['id'] as String,
      nombre: isar['nombre'] as String,
      tipo: isar['tipo'] as String,
      countryId: isar['countryId'] as String,
      regionId: isar['regionId'] as String?,
      cityId: isar['cityId'] as String?,
      ownerUid: isar['ownerUid'] as String?,
      logoUrl: isar['logoUrl'] as String?,
      countryRef: conv.fromPath(db, cPath),
      countryRefPath: cPath,
      regionRef: conv.fromPath(db, rPath),
      regionRefPath: rPath,
      cityRef: conv.fromPath(db, ciPath),
      cityRefPath: ciPath,
      ownerRef: conv.fromPath(db, oPath),
      ownerRefPath: oPath,
      metadataJson: isar['metadataJson'] as String?,
      contractJson: isar['contractJson'] as String?,
      isActive: (isar['isActive'] as bool?) ?? true,
      createdAt: (isar['createdAt'] is String)
          ? DateTime.tryParse(isar['createdAt'] as String)
          : null,
      updatedAt: (isar['updatedAt'] is String)
          ? DateTime.tryParse(isar['updatedAt'] as String)
          : null,
    );
  }

  factory OrganizationModel.fromEntity(domain.OrganizationEntity e) =>
      OrganizationModel(
        id: e.id,
        nombre: e.nombre,
        tipo: e.tipo,
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        ownerUid: e.ownerUid,
        logoUrl: e.logoUrl,
        metadataJson: e.metadata == null ? null : jsonEncode(e.metadata),
        contractJson: _encodeContractJson(e.contract),
        isActive: e.isActive,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.OrganizationEntity toEntity() => domain.OrganizationEntity(
        id: id,
        nombre: nombre,
        tipo: tipo,
        countryId: countryId,
        regionId: regionId,
        cityId: cityId,
        ownerUid: ownerUid,
        logoUrl: logoUrl,
        metadata: (() {
          if (metadataJson == null || metadataJson!.isEmpty) return null;
          final m = jsonDecode(metadataJson!);
          return m is Map<String, dynamic>
              ? m
              : Map<String, dynamic>.from(m as Map);
        })(),
        contract: parsedContract,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

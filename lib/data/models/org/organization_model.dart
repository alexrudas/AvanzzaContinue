import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/telemetry/capability_profile_telemetry.dart';
import '../../../domain/entities/org/organization_entity.dart' as domain;
import '../../../domain/value/capability/capability_profile.dart';
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

  /// Capabilities del workspace serializadas como JSON Array String
  /// (Isar-safe). Expected shape: List<CapabilityProfile.toJson()>.
  /// Null o vacío ⇒ workspace sin capabilities declaradas.
  /// Datos corruptos en lectura ⇒ fallback seguro a [] (no rompe la app).
  String? capabilityProfilesJson;

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
    this.capabilityProfilesJson,
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

  /// Parse seguro de `capabilityProfilesJson` → `List<CapabilityProfile>`.
  /// Si falla o es null/vacío, retorna lista vacía (workspace sin
  /// capabilities). Datos parcialmente corruptos ⇒ fallback total a [];
  /// se prefiere "sin capabilities" sobre "mezclar buenas y malas".
  @isar.ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<CapabilityProfile> get parsedCapabilityProfiles =>
      _parseCapabilityProfilesJson(capabilityProfilesJson, orgId: id);

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

  /// Serializa una lista de CapabilityProfile a JSON String (array).
  /// Retorna null si la lista está vacía — ahorra bytes y mantiene
  /// semántica: "ausencia" == "sin capabilities declaradas".
  static String? _encodeCapabilityProfilesJson(
      List<CapabilityProfile> profiles) {
    if (profiles.isEmpty) return null;
    try {
      return jsonEncode(profiles.map((p) => p.toJson()).toList());
    } catch (_) {
      return null;
    }
  }

  /// Parse seguro de un JSON Array String → `List<CapabilityProfile>`.
  /// Política:
  /// - null / vacío / no-array ⇒ retorna lista vacía constante.
  /// - JSON inválido o estructura incorrecta ⇒ fallback [] + telemetría
  ///   (`capability_profiles_parse_error`).
  /// - Cualquier item malformado dispara excepción del CapabilityProfile;
  ///   se atrapa globalmente y se cae a [] + telemetría.
  ///   Política deliberada: preferimos "sin capabilities" sobre "mezclar
  ///   datos buenos con corrupción no detectada", pero NUNCA silenciamos —
  ///   cada degradación deja rastro estructurado.
  static List<CapabilityProfile> _parseCapabilityProfilesJson(
    String? raw, {
    String? orgId,
  }) {
    if (raw == null || raw.trim().isEmpty) {
      return const <CapabilityProfile>[];
    }
    final dynamic decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (e) {
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        orgId: orgId,
        rawValue: raw,
        errorMessage: e.toString(),
        errorType: 'json_decode',
      );
      return const <CapabilityProfile>[];
    }
    if (decoded is! List) {
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        orgId: orgId,
        rawValue: raw,
        errorMessage:
            'expected JSON array at root, got ${decoded.runtimeType}',
        errorType: 'structure_invalid',
      );
      return const <CapabilityProfile>[];
    }
    try {
      return decoded
          .map((item) {
            if (item is Map<String, dynamic>) {
              return CapabilityProfile.fromJson(item);
            }
            if (item is Map) {
              return CapabilityProfile.fromJson(
                Map<String, dynamic>.from(item),
              );
            }
            throw ArgumentError(
              'capabilityProfiles: cada item debe ser Map<String,dynamic>',
            );
          })
          .toList(growable: false);
    } catch (e) {
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        orgId: orgId,
        rawValue: raw,
        errorMessage: e.toString(),
        errorType: 'item_invalid',
      );
      return const <CapabilityProfile>[];
    }
  }

  /// Normaliza capabilityProfiles desde Firestore: acepta List nativa
  /// (forma canónica) o String JSON (legacy/edge cases). Retorna JSON
  /// String para almacenar en Isar, o null si vacío/inválido.
  ///
  /// Política de degradación:
  /// - Lista válida ⇒ re-encode canónico, sin telemetría.
  /// - Lista con todos sus items no-Map ⇒ retorna null (interpretado como
  ///   "sin capabilities") + telemetría `capability_profiles_parse_error`.
  /// - String JSON corrupto ⇒ retorna null + telemetría.
  /// - Tipo inesperado en raíz ⇒ retorna null + telemetría.
  /// - null o lista vacía ⇒ silencio (no es degradación, es ausencia legítima).
  static String? _parseCapabilityProfilesFromFirestore(
    dynamic raw, {
    String? orgId,
  }) {
    if (raw == null) return null;
    if (raw is List) {
      if (raw.isEmpty) return null;
      try {
        // Validar shape mínimo y re-encode canónico.
        final cleaned = raw
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList(growable: false);
        if (cleaned.isEmpty) {
          // La lista venía con datos pero ningún elemento era Map.
          CapabilityProfileTelemetry.recordParseError(
            source: CapabilityParseSource.firestore,
            orgId: orgId,
            rawValue: raw,
            errorMessage:
                'firestore capabilityProfiles list had ${raw.length} '
                'items but none were Map; dropped',
            errorType: 'structure_invalid',
          );
          return null;
        }
        return jsonEncode(cleaned);
      } catch (e) {
        CapabilityProfileTelemetry.recordParseError(
          source: CapabilityParseSource.firestore,
          orgId: orgId,
          rawValue: raw,
          errorMessage: e.toString(),
          errorType: 'list_normalize_failed',
        );
        return null;
      }
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw.trim());
        if (decoded is List && decoded.isNotEmpty) return jsonEncode(decoded);
        // String JSON válido pero no era lista, o lista vacía.
        CapabilityProfileTelemetry.recordParseError(
          source: CapabilityParseSource.firestore,
          orgId: orgId,
          rawValue: raw,
          errorMessage:
              'firestore capabilityProfiles string was valid JSON '
              'but not a non-empty array (got ${decoded.runtimeType})',
          errorType: 'structure_invalid',
        );
        return null;
      } catch (e) {
        CapabilityProfileTelemetry.recordParseError(
          source: CapabilityParseSource.firestore,
          orgId: orgId,
          rawValue: raw,
          errorMessage: e.toString(),
          errorType: 'json_decode',
        );
        return null;
      }
    }
    // Tipo inesperado (num, bool, Map en raíz, etc.).
    CapabilityProfileTelemetry.recordParseError(
      source: CapabilityParseSource.firestore,
      orgId: orgId,
      rawValue: raw,
      errorMessage:
          'firestore capabilityProfiles had unexpected root type: '
          '${raw.runtimeType}',
      errorType: 'structure_invalid',
    );
    return null;
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
      capabilityProfilesJson: _parseCapabilityProfilesFromFirestore(
        json['capabilityProfiles'],
        orgId: docId,
      ),
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
      if (capabilityProfilesJson != null &&
          capabilityProfilesJson!.isNotEmpty)
        'capabilityProfiles': jsonDecode(capabilityProfilesJson!),
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
      'capabilityProfilesJson': capabilityProfilesJson,
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
      capabilityProfilesJson: isar['capabilityProfilesJson'] as String?,
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
        capabilityProfilesJson:
            _encodeCapabilityProfilesJson(e.capabilityProfiles),
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
        capabilityProfiles: parsedCapabilityProfiles,
        contract: parsedContract,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

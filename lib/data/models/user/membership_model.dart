// ============================================================================
// lib/data/models/user/membership_model.dart
// MEMBERSHIP MODEL — Enterprise Ultra Pro (Data / Model)
//
// QUÉ HACE:
// - Persiste membresía en Isar (offline) y mapea a/desde Firestore (cloud).
// - Serializa MembershipScope como JSON String en `scopeJson` (Isar-safe).
// - Provee parse seguro de `scopeJson` con try/catch → fallback a default seguro.
// - Mapea bidireccionalmente MembershipModel ↔ MembershipEntity.
// - Normaliza timestamps y booleanos polimórficos (defensive parsing).
// - Limpia payloads de Firestore (no envía nulls ni JSONs vacíos).
// - Endurece strings/roles (trim, sin vacíos) para higiene y consistencia.
//
// QUÉ NO HACE:
// - No valida semántica de roles/estatus/scope (eso es dominio/policy).
// - No resuelve grupos→activos (assignedGroupIds) (eso es repositorio/usecases).
// - No hace enforcement de granularOverrides (fase posterior).
//
// NOTAS CRÍTICAS (Isar):
// - Cualquier tipo no soportado por Isar debe ir con @ignore (ej: DocumentReference).
// - `scopeJson` y `primaryLocationJson` son String para evitar embedded objects.
//
// NOTA ENTERPRISE (scope optimization):
// - NO optimizamos scope a null usando "isEffectivelyEmpty" genérico,
//   porque podría perder intención (ej: ScopeType.none).
// - Solo optimizamos a null si es el default seguro: restricted + sin asignaciones.
// ============================================================================

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:isar_community/isar.dart' as isar; // isar.Id
import 'package:isar_community/isar.dart'; // @Collection/@Index/@ignore
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user/membership_entity.dart' as domain;
import '../../../domain/value/membership_scope.dart';
import '../common/converters/doc_ref_path_converter.dart';

part 'membership_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class MembershipModel {
  // Isar internal id
  isar.Id? isarId;

  @Index(unique: true, replace: true)
  final String id; // synthetic key recomendado: userId_orgId

  @Index()
  final String userId;

  @Index()
  final String orgId;

  final String orgName;

  final List<String> roles;

  @Index()
  final String estatus;

  /// Flag crítico de propiedad (alineado con MembershipEntity.isOwner)
  final bool? isOwner;

  /// Persistido como JSON String en Isar.
  /// Expected keys: { countryId, regionId?, cityId? }
  final String? primaryLocationJson;

  /// Persistido como JSON String en Isar (Isar-safe).
  /// Expected shape: MembershipScope.toJson()
  final String? scopeJson;

  /// Referencia real de Firestore (NO persistible en Isar).
  @ignore
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DocumentReference<Map<String, dynamic>>? orgRef;

  /// Persistencia segura de referencia: path string (Isar-safe).
  final String? orgRefPath;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  MembershipModel({
    this.isarId,
    required this.id,
    required this.userId,
    required this.orgId,
    required this.orgName,
    this.roles = const <String>[],
    required this.estatus,
    this.isOwner,
    this.primaryLocationJson,
    this.scopeJson,
    this.orgRef,
    this.orgRefPath,
    this.createdAt,
    this.updatedAt,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipModelToJson(this);

  // --------------------------------------------------------------------------
  // INTERNAL HELPERS
  // --------------------------------------------------------------------------

  static String _s(dynamic v, {String fallback = ''}) {
    final raw = (v == null) ? '' : v.toString();
    final t = raw.trim();
    return t.isEmpty ? fallback : t;
  }

  static List<String> _stringList(dynamic v) {
    if (v is! List) return const <String>[];
    final out = <String>[];
    for (final e in v) {
      final s = _s(e, fallback: '');
      if (s.isNotEmpty) out.add(s);
    }
    return out;
  }

  static DocumentReference<Map<String, dynamic>>? _refFrom(
    FirebaseFirestore db,
    dynamic any,
  ) {
    if (any is DocumentReference) {
      return any.withConverter<Map<String, dynamic>>(
        fromFirestore: (s, _) => s.data() ?? <String, dynamic>{},
        toFirestore: (m, _) => m,
      );
    }
    if (any is String && any.trim().isNotEmpty) return db.doc(any.trim());
    return null;
  }

  static DateTime? _parseTimestamp(Object? v) {
    if (v == null) return null;

    if (v is fs.Timestamp) return v.toDate().toUtc();
    if (v is DateTime) return v.toUtc();
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

  static bool? _parseBoolDefensive(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;

    if (v is String) {
      final lower = v.toLowerCase().trim();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
      if (lower == '1') return true;
      if (lower == '0') return false;
    }

    if (v is num) {
      if (v == 1) return true;
      if (v == 0) return false;
    }

    return null;
  }

  /// Decodifica JSON string a Map<String,dynamic> de forma segura.
  static Map<String, dynamic>? _decodeJsonMapSafe(
    String? raw, {
    bool treatEmptyMapAsNull = true,
  }) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.isEmpty) return null;

    try {
      final decoded = jsonDecode(s);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        if (treatEmptyMapAsNull && map.isEmpty) return null;
        return map;
      }
    } catch (_) {
      // ignore corruption
    }
    return null;
  }

  /// Normaliza y serializa un Map a JSON string.
  static String? _encodeJsonMapSafe(
    Map<String, dynamic>? map, {
    bool nullIfEmpty = true,
  }) {
    if (map == null) return null;
    if (nullIfEmpty && map.isEmpty) return null;
    try {
      return jsonEncode(map);
    } catch (_) {
      return null;
    }
  }

  // --------------------------------------------------------------------------
  // SAFE PARSERS (ISAR-SAFE)
  // --------------------------------------------------------------------------

  /// Parse seguro de `scopeJson` → `MembershipScope`.
  /// Si falla, retorna default seguro (restricted sin acceso).
  @ignore
  MembershipScope get parsedScope {
    final map = _decodeJsonMapSafe(scopeJson, treatEmptyMapAsNull: false);
    if (map == null) return const MembershipScope();

    try {
      return MembershipScope.fromJson(map);
    } catch (_) {
      return const MembershipScope();
    }
  }

  /// Parse seguro de `primaryLocationJson` → Map<String,String>.
  @ignore
  Map<String, String> get parsedPrimaryLocation {
    final map = _decodeJsonMapSafe(primaryLocationJson);
    if (map == null) return <String, String>{};

    return map.map((k, v) => MapEntry(k, v?.toString() ?? ''));
  }

  // --------------------------------------------------------------------------
  // FIRESTORE MAPPING
  // --------------------------------------------------------------------------

  factory MembershipModel.fromFirestore(
    String docId,
    Map<String, dynamic> json, {
    required FirebaseFirestore db,
  }) {
    const conv = DocRefPathConverter();
    final oRef = _refFrom(db, json['orgRef']);

    // orgId: si viene vacío, cae a oRef.id
    var resolvedOrgId = _s(json['orgId'], fallback: '');
    if (resolvedOrgId.isEmpty) resolvedOrgId = oRef?.id ?? '';

    // scope: Map (nuevo) o String (legado). Guardamos como String en Isar.
    final rawScope = json['scope'];
    String? scopeStr;
    if (rawScope is Map) {
      try {
        final m = Map<String, dynamic>.from(rawScope);
        scopeStr = m.isEmpty ? null : jsonEncode(m);
      } catch (_) {
        scopeStr = null;
      }
    } else if (rawScope is String && rawScope.trim().isNotEmpty) {
      // si viene como string, lo normalizamos a JSON válido si es posible
      final normalized = rawScope.trim();
      final decoded = _decodeJsonMapSafe(
        normalized,
        treatEmptyMapAsNull: false,
      );
      // si no decodifica, lo omitimos para no persistir basura
      scopeStr = (decoded == null) ? null : jsonEncode(decoded);
    }

    // primaryLocation: normalmente Map; si vacío, null
    String? plStr;
    try {
      final pl = json['primaryLocation'];
      if (pl is Map) {
        final m = Map<String, dynamic>.from(pl);
        plStr = m.isEmpty ? null : jsonEncode(m);
      } else {
        plStr = null;
      }
    } catch (_) {
      plStr = null;
    }

    return MembershipModel(
      id: docId.trim(),
      userId: _s(json['userId'], fallback: ''),
      orgId: resolvedOrgId,
      orgName: _s(json['orgName'], fallback: ''),
      roles: _stringList(json['roles']),
      estatus: _s(json['estatus'], fallback: 'activo'),
      isOwner: _parseBoolDefensive(json['isOwner']),
      primaryLocationJson: plStr,
      scopeJson: scopeStr,
      orgRef: oRef,
      orgRefPath: conv.toPath(oRef),
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  /// Payload listo para Firestore.
  /// Convierte los strings JSON locales a Map para la nube.
  Map<String, dynamic> toFirestoreJson() {
    final data = <String, dynamic>{
      'userId': userId,
      'orgId': orgId,
      'orgName': orgName,
      'roles': roles,
      'estatus': estatus,
      if (isOwner != null) 'isOwner': isOwner,
      if (orgRef != null) 'orgRef': orgRef,
      if (createdAt != null) 'createdAt': createdAt!.toUtc(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc(),
    };

    final plMap = _decodeJsonMapSafe(primaryLocationJson);
    if (plMap != null) {
      data['primaryLocation'] = plMap;
    }

    final scMap = _decodeJsonMapSafe(scopeJson, treatEmptyMapAsNull: true);
    if (scMap != null) {
      data['scope'] = scMap;
    }

    return data;
  }

  // --------------------------------------------------------------------------
  // ISAR JSON HELPERS (OPTIONAL / DEBUG / MIGRATIONS)
  // --------------------------------------------------------------------------

  Map<String, dynamic> toIsarJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'orgId': orgId,
      'orgName': orgName,
      'roles': roles,
      'estatus': estatus,
      'isOwner': isOwner,
      'primaryLocationJson': primaryLocationJson,
      'scopeJson': scopeJson,
      'orgRefPath': orgRefPath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MembershipModel.fromIsar(
    Map<String, dynamic> isarMap,
    FirebaseFirestore db,
  ) {
    const conv = DocRefPathConverter();
    final oPath = isarMap['orgRefPath'] as String?;

    return MembershipModel(
      id: (isarMap['id'] as String).trim(),
      userId: _s(isarMap['userId'], fallback: ''),
      orgId: _s(isarMap['orgId'], fallback: ''),
      orgName: _s(isarMap['orgName'], fallback: ''),
      roles: _stringList(isarMap['roles']),
      estatus: _s(isarMap['estatus'], fallback: 'activo'),
      isOwner: _parseBoolDefensive(isarMap['isOwner']),
      primaryLocationJson: isarMap['primaryLocationJson'] as String?,
      scopeJson: isarMap['scopeJson'] as String?,
      orgRef: conv.fromPath(db, oPath),
      orgRefPath: oPath,
      createdAt: (isarMap['createdAt'] is String)
          ? DateTime.tryParse(isarMap['createdAt'] as String)?.toUtc()
          : null,
      updatedAt: (isarMap['updatedAt'] is String)
          ? DateTime.tryParse(isarMap['updatedAt'] as String)?.toUtc()
          : null,
    );
  }

  // --------------------------------------------------------------------------
  // ENTITY MAPPING
  // --------------------------------------------------------------------------

  /// Optimización segura:
  /// - primaryLocationJson: null si vacío.
  /// - scopeJson: null SOLO si es el default seguro (restricted + sin asignaciones).
  factory MembershipModel.fromEntity(domain.MembershipEntity e) {
    // primaryLocation: null si vacío (ahorra bytes)
    String? plStr;
    if (e.primaryLocation.isNotEmpty) {
      plStr = _encodeJsonMapSafe(
        e.primaryLocation.map((k, v) => MapEntry(k, v)),
        nullIfEmpty: true,
      );
    }

    // scope: null solo si es default restricted vacío (no perder intención)
    String? scopeStr;
    final scopeMap = e.scope.toJson();
    final scopeType = (scopeMap['type']?.toString() ?? '').trim().toLowerCase();

    final assignedAssets = scopeMap['assignedAssetIds'];
    final assignedGroups = scopeMap['assignedGroupIds'];
    final overrides = scopeMap['granularOverrides'];

    final hasAssets =
        (assignedAssets is List) ? assignedAssets.isNotEmpty : false;
    final hasGroups =
        (assignedGroups is List) ? assignedGroups.isNotEmpty : false;
    final hasOverrides = (overrides is List) ? overrides.isNotEmpty : false;

    final isDefaultRestrictedEmpty =
        (scopeType.isEmpty || scopeType == 'restricted') &&
            !hasAssets &&
            !hasGroups &&
            !hasOverrides;

    if (!isDefaultRestrictedEmpty) {
      scopeStr = _encodeJsonMapSafe(
        Map<String, dynamic>.from(scopeMap),
        nullIfEmpty: false,
      );
    }

    return MembershipModel(
      id: '${e.userId}_${e.orgId}',
      userId: e.userId.trim(),
      orgId: e.orgId.trim(),
      orgName: e.orgName.trim(),
      roles: e.roles.map((r) => r.trim()).where((r) => r.isNotEmpty).toList(),
      estatus: e.estatus.trim(),
      isOwner: e.isOwner,
      primaryLocationJson: plStr,
      scopeJson: scopeStr,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  domain.MembershipEntity toEntity() => domain.MembershipEntity(
        userId: userId,
        orgId: orgId,
        orgName: orgName,
        roles: roles,
        estatus: estatus,
        isOwner: isOwner,
        primaryLocation: parsedPrimaryLocation,
        scope: parsedScope,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

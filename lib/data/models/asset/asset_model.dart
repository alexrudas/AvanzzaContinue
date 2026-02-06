import 'package:cloud_firestore/cloud_firestore.dart'
    show FirebaseFirestore, DocumentReference;
import 'package:cloud_firestore/cloud_firestore.dart' as fs show Timestamp;
import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/asset/asset_content.dart' as domain;
import '../../../domain/entities/asset/asset_entity.dart' as domain;
import '../common/converters/doc_ref_path_converter.dart';

part 'asset_model.g.dart';

// ============================================================================
// ASSET MODEL - Data Layer (Firestore/Isar)
//
// NOTA: Este modelo es LEGACY y mantiene compatibilidad con estructura plana.
// El Domain (AssetEntity V2) usa AssetContent polimórfico.
// Los mappers fromEntity/toEntity hacen "best effort" pero tienen limitaciones.
// ============================================================================

@isar.collection
@JsonSerializable(explicitToJson: true)
class AssetModel {
  isar.Id? isarId;

  @isar.Index(unique: true, replace: true)
  final String id;

  // Campos legacy mantenidos para compatibilidad Firestore/Isar
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

  // ===========================================================================
  // MAPPERS DOMAIN ↔ DATA
  //
  // NOTA: AssetModel es estructura PLANA legacy.
  // AssetEntity V2 usa AssetContent polimórfico (vehicle/realEstate/etc).
  // Estos mappers hacen "best effort" con las limitaciones estructurales.
  // ===========================================================================

  /// Convierte Domain → Data.
  /// Extrae campos legacy desde metadata del Domain cuando es posible.
  factory AssetModel.fromEntity(domain.AssetEntity e) {
    // Mapear type enum a string
    final typeStr = e.type.name;

    // Mapear state enum a string legacy "estado"
    final estadoStr = _mapStateToEstado(e.state);

    // Extraer owner info desde beneficialOwner si existe
    final ownerTypeStr = e.beneficialOwner?.ownerType.name ?? 'org';
    final ownerIdStr = e.beneficialOwner?.ownerId ?? '';

    // Campos legacy: intentar extraer de metadata
    final meta = e.metadata;
    final orgId = (meta['orgId'] as String?) ?? '';
    final countryId = (meta['countryId'] as String?) ?? '';
    final regionId = meta['regionId'] as String?;
    final cityId = meta['cityId'] as String?;
    final etiquetas = _extractStringList(meta['etiquetas']);
    final fotosUrls = _extractStringList(meta['fotosUrls']);

    return AssetModel(
      id: e.id,
      orgId: orgId,
      assetType: typeStr,
      countryId: countryId,
      regionId: regionId,
      cityId: cityId,
      ownerType: ownerTypeStr,
      ownerId: ownerIdStr,
      estado: estadoStr,
      etiquetas: etiquetas,
      fotosUrls: fotosUrls,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  /// Convierte Data → Domain.
  ///
  /// LIMITACIÓN: AssetModel no tiene campos de contenido detallado
  /// (plate, address, serialNumber, etc). Se crea un AssetContent
  /// placeholder con datos mínimos. Para datos completos, usar
  /// los modelos específicos (AssetVehiculoModel, etc).
  domain.AssetEntity toEntity() {
    final type = _parseAssetType(assetType);
    final state = _parseAssetState(estado);
    final content = _createPlaceholderContent(type, id);
    final now = DateTime.now().toUtc();

    return domain.AssetEntity(
      id: id,
      assetKey: content.assetKey,
      type: type,
      state: state,
      content: content,
      legalOwner: null,
      beneficialOwner: _createBeneficialOwnerIfValid(),
      snapshotId: null,
      portfolioId: null,
      metadata: {
        'orgId': orgId,
        'countryId': countryId,
        if (regionId != null) 'regionId': regionId,
        if (cityId != null) 'cityId': cityId,
        'etiquetas': etiquetas,
        'fotosUrls': fotosUrls,
        // Paths para reconstrucción de refs
        if (orgRefPath != null) 'orgRefPath': orgRefPath,
        if (ownerRefPath != null) 'ownerRefPath': ownerRefPath,
        if (countryRefPath != null) 'countryRefPath': countryRefPath,
        if (regionRefPath != null) 'regionRefPath': regionRefPath,
        if (cityRefPath != null) 'cityRefPath': cityRefPath,
      },
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  // ===========================================================================
  // HELPERS PRIVADOS
  // ===========================================================================

  static String _mapStateToEstado(domain.AssetState state) {
    switch (state) {
      case domain.AssetState.draft:
        return 'borrador';
      case domain.AssetState.pendingOwnership:
        return 'pendiente';
      case domain.AssetState.verified:
        return 'verificado';
      case domain.AssetState.active:
        return 'activo';
      case domain.AssetState.archived:
        return 'archivado';
    }
  }

  static domain.AssetType _parseAssetType(String s) {
    final normalized = s.toLowerCase().replaceAll('_', '');
    for (final t in domain.AssetType.values) {
      if (t.name.toLowerCase() == normalized) return t;
    }
    // Mapeos legacy adicionales
    if (s == 'vehiculo' || s == 'vehicle') return domain.AssetType.vehicle;
    if (s == 'inmueble' || s == 'real_estate') {
      return domain.AssetType.realEstate;
    }
    if (s == 'maquinaria' || s == 'machinery') {
      return domain.AssetType.machinery;
    }
    return domain.AssetType.equipment;
  }

  static domain.AssetState _parseAssetState(String s) {
    final normalized = s.toLowerCase();
    // Mapeo legacy español → enum
    if (normalized == 'borrador') return domain.AssetState.draft;
    if (normalized == 'pendiente') return domain.AssetState.pendingOwnership;
    if (normalized == 'verificado') return domain.AssetState.verified;
    if (normalized == 'activo') return domain.AssetState.active;
    if (normalized == 'archivado') return domain.AssetState.archived;
    // Intentar match directo con enum
    for (final st in domain.AssetState.values) {
      if (st.name.toLowerCase() == normalized) return st;
    }
    return domain.AssetState.draft;
  }

  static List<String> _extractStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }

  /// Crea un AssetContent placeholder.
  /// Los datos reales deben venir de modelos específicos de contenido.
  /// Crea un AssetContent placeholder compatible con V2.
  /// (Lossy mapping: llena obligatorios con defaults seguros).
  static domain.AssetContent _createPlaceholderContent(
    domain.AssetType type,
    String assetId,
  ) {
    final fullId = assetId.trim().toUpperCase();

    // REGLA DE NEGOCIO:
    // - Vehículos: derivar 6 chars tipo placa si hay longitud suficiente.
    // - Otros tipos: usar el ID completo (longitud variable).
    final placeholder = (type == domain.AssetType.vehicle && fullId.length >= 6)
        ? fullId.substring(0, 6)
        : fullId;

    const unknown = 'PENDIENTE';

    switch (type) {
      case domain.AssetType.vehicle:
        return domain.AssetContent.vehicle(
          assetKey: placeholder,
          brand: unknown,
          model: unknown, // V2: String
          color: unknown, // V2: required
          engineDisplacement: 0, // V2: required
          mileage: 0,
        );

      case domain.AssetType.realEstate:
        return domain.AssetContent.realEstate(
          assetKey: placeholder, // matrícula real: longitud variable
          address: unknown,
          city: unknown,
          area: 0,
          usage: unknown,
          propertyType: unknown, // opcional, pero útil si tu UI lo espera
        );

      case domain.AssetType.machinery:
        return domain.AssetContent.machinery(
          assetKey: placeholder,
          brand: unknown,
          model: unknown,
          category: unknown,
        );

      case domain.AssetType.equipment:
        return domain.AssetContent.equipment(
          assetKey: placeholder,
          name: unknown,
          brand: unknown,
          model: unknown,
          category: unknown,
        );
    }
  }

  domain.BeneficialOwner? _createBeneficialOwnerIfValid() {
    if (ownerId.isEmpty) return null;
    return domain.BeneficialOwner(
      ownerType: ownerType == 'user'
          ? domain.BeneficialOwnerType.user
          : domain.BeneficialOwnerType.org,
      ownerId: ownerId,
      ownerName: '', // No disponible en modelo legacy
      relationship: domain.OwnershipRelationship.owner,
      assignedAt: DateTime.now().toUtc(),
      assignedBy: '',
    );
  }
}

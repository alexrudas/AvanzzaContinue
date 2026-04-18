// ============================================================================
// lib/data/models/portfolio/portfolio_model.dart
// PORTFOLIO MODEL — Data Layer / Isar + JSON
//
// QUÉ HACE:
// - Persiste PortfolioEntity en Isar (colección local, offline-first).
// - Incluye 10 campos opcionales de snapshot del propietario VRC,
//   persistidos al completar un batch (completed | partially_completed).
//
// QUÉ NO HACE:
// - No contiene lógica de negocio.
// - No accede a Firebase directamente.
//
// PRINCIPIOS:
// - Campos del snapshot VRC son todos nullable — null = sin batch VRC previo.
// - La rama UPDATE de upsert() en PortfolioLocalDataSource copia model.*
//   para los campos del snapshot, preservando los datos escritos.
// - Wire-stable: no renombrar campos owner* ni simit*.
//
// ENTERPRISE NOTES:
// CREADO (original): Portafolio base.
// ACTUALIZADO (2026-04): +10 campos snapshot propietario VRC
//   (Problema B — Fase SIMIT-1).
// ============================================================================

import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/portfolio/portfolio_entity.dart';

part 'portfolio_model.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class PortfolioModel {
  /// Isar internal ID (auto-increment)
  isar.Id? isarId;

  /// String ID (domain ID, único, indexado)
  @isar.Index(unique: true, replace: true)
  final String id;

  @isar.Index()
  final String portfolioType; // 'VEHICULOS' | 'INMUEBLES'

  final String portfolioName;
  final String countryId;
  final String cityId;

  /// Partition key del tenant SaaS.
  /// Índice simple para queries por org. Índice compuesto (orgId+status)
  /// permite listActiveByOrg() eficiente.
  /// Default '' para compatibilidad con registros previos al campo.
  @isar.Index(
    composite: [isar.CompositeIndex('status')],
  )
  final String orgId;

  @isar.Index()
  final String status; // 'DRAFT' | 'ACTIVE'

  final int assetsCount;

  @isar.Index()
  final String createdBy;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ── Snapshot del propietario VRC ─────────────────────────────────────────
  // Persistido al completar un batch VRC (completed | partially_completed).
  // Null cuando el portafolio nunca pasó por un batch VRC.
  // Sin @Index — campos de snapshot no se usan como filtro de query.
  final String? ownerName;
  final String? ownerDocument;
  final String? ownerDocumentType;
  final String? licenseStatus;
  /// Fecha de vencimiento de la licencia (formato "DD/MM/YYYY").
  final String? licenseExpiryDate;
  final bool? simitHasFines;
  /// Conteo total de infracciones SIMIT (todos los tipos).
  final int? simitFinesCount;
  /// Comparendos (infracciones de tránsito — dato firme del backend).
  final int? simitComparendosCount;
  /// Multas confirmadas (puede ser null si el backend aún no las envía).
  final int? simitMultasCount;
  final String? simitFormattedTotal;
  /// Timestamp de la consulta VRC que originó este snapshot (UTC).
  final DateTime? simitCheckedAt;

  /// Timestamp del último refresh exitoso de licencia (RUNT Persona, UTC).
  final DateTime? licenseCheckedAt;

  /// JSON blob del bloque owner.simit completo (summary + fines[]).
  ///
  /// Fuente de verdad para el detalle itemizado SIMIT. Se serializa desde
  /// VrcOwnerSimitModel.toJson() al persistir el snapshot y se deserializa
  /// bajo demanda solo al navegar a SimitPersonDetailPage.
  /// Null para registros creados antes de esta feature — Isar asigna null
  /// automáticamente a campos nuevos (backward-compatible, sin migración).
  final String? simitDetailJson;

  PortfolioModel({
    this.isarId,
    required this.id,
    required this.portfolioType,
    required this.portfolioName,
    required this.countryId,
    required this.cityId,
    this.orgId = '',
    required this.status,
    required this.assetsCount,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.ownerName,
    this.ownerDocument,
    this.ownerDocumentType,
    this.licenseStatus,
    this.licenseExpiryDate,
    this.simitHasFines,
    this.simitFinesCount,
    this.simitComparendosCount,
    this.simitMultasCount,
    this.simitFormattedTotal,
    this.simitCheckedAt,
    this.licenseCheckedAt,
    this.simitDetailJson,
  });

  /// Mapper: Model -> Entity
  PortfolioEntity toEntity() {
    return PortfolioEntity(
      id: id,
      portfolioType: _parsePortfolioType(portfolioType),
      portfolioName: portfolioName,
      countryId: countryId,
      cityId: cityId,
      orgId: orgId,
      status: _parsePortfolioStatus(status),
      assetsCount: assetsCount,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      ownerName: ownerName,
      ownerDocument: ownerDocument,
      ownerDocumentType: ownerDocumentType,
      licenseStatus: licenseStatus,
      licenseExpiryDate: licenseExpiryDate,
      simitHasFines: simitHasFines,
      simitFinesCount: simitFinesCount,
      simitComparendosCount: simitComparendosCount,
      simitMultasCount: simitMultasCount,
      simitFormattedTotal: simitFormattedTotal,
      simitCheckedAt: simitCheckedAt,
      licenseCheckedAt: licenseCheckedAt,
      simitDetailJson: simitDetailJson,
    );
  }

  /// Mapper: Entity -> Model
  factory PortfolioModel.fromEntity(PortfolioEntity entity) {
    return PortfolioModel(
      id: entity.id,
      portfolioType: _serializePortfolioType(entity.portfolioType),
      portfolioName: entity.portfolioName,
      countryId: entity.countryId,
      cityId: entity.cityId,
      orgId: entity.orgId,
      status: _serializePortfolioStatus(entity.status),
      assetsCount: entity.assetsCount,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt?.toUtc(),
      updatedAt: entity.updatedAt?.toUtc(),
      ownerName: entity.ownerName,
      ownerDocument: entity.ownerDocument,
      ownerDocumentType: entity.ownerDocumentType,
      licenseStatus: entity.licenseStatus,
      licenseExpiryDate: entity.licenseExpiryDate,
      simitHasFines: entity.simitHasFines,
      simitFinesCount: entity.simitFinesCount,
      simitComparendosCount: entity.simitComparendosCount,
      simitMultasCount: entity.simitMultasCount,
      simitFormattedTotal: entity.simitFormattedTotal,
      simitCheckedAt: entity.simitCheckedAt?.toUtc(),
      licenseCheckedAt: entity.licenseCheckedAt?.toUtc(),
      simitDetailJson: entity.simitDetailJson,
    );
  }

  /// JSON serialization
  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioModelToJson(this);

  // Helper parsers
  static PortfolioType _parsePortfolioType(String value) {
    switch (value) {
      case 'VEHICULOS':
        return PortfolioType.vehiculos;
      case 'INMUEBLES':
        return PortfolioType.inmuebles;
      case 'OPERACION_GENERAL':
        return PortfolioType.operacionGeneral;
      default:
        return PortfolioType.operacionGeneral;
    }
  }

  static String _serializePortfolioType(PortfolioType type) {
    switch (type) {
      case PortfolioType.vehiculos:
        return 'VEHICULOS';
      case PortfolioType.inmuebles:
        return 'INMUEBLES';
      case PortfolioType.operacionGeneral:
        return 'OPERACION_GENERAL';
    }
  }

  static PortfolioStatus _parsePortfolioStatus(String value) {
    switch (value) {
      case 'DRAFT':
        return PortfolioStatus.draft;
      case 'ACTIVE':
        return PortfolioStatus.active;
      default:
        return PortfolioStatus.draft;
    }
  }

  static String _serializePortfolioStatus(PortfolioStatus status) {
    switch (status) {
      case PortfolioStatus.draft:
        return 'DRAFT';
      case PortfolioStatus.active:
        return 'ACTIVE';
    }
  }
}

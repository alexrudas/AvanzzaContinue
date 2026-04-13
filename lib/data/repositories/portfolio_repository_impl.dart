// ============================================================================
// lib/data/repositories/portfolio_repository_impl.dart
// PORTFOLIO REPOSITORY IMPL — Enterprise Ultra Pro (Data / Repositories)
//
// QUÉ HACE:
// - Implementa PortfolioRepository usando PortfolioLocalDataSource (Isar).
// - Mapea entre PortfolioModel (data) y PortfolioEntity (domain).
// - Expone streams reactivos para Home y detalle de portafolio.
//
// QUÉ NO HACE:
// - No accede a Firebase directamente (offline-first local primero).
// - No contiene lógica de negocio (pertenece al domain).
// - No gestiona DI (responsabilidad de DIContainer).
//
// PRINCIPIOS:
// - Offline-first: todas las lecturas y escrituras van a Isar.
// - Null-safety explícita: lanza Exception si el registro no existe.
// - Single responsibility: solo traduce entre capas.
//
// ENTERPRISE NOTES:
// - incrementAssetsCount y decrementAssetsCount delegan la transición
//   DRAFT → ACTIVE al data source (portfolio_local_ds.dart).
// - renamePortfolio reutiliza getById + upsert para actualizar solo el nombre.
// ACTUALIZADO (2026-04): +repairMissingOrgId — delega a PortfolioLocalDataSource
//   para recuperar portafolios con orgId:'' creados por race condition de arranque.
// ============================================================================

import 'package:uuid/uuid.dart';

import '../../domain/entities/portfolio/portfolio_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../models/portfolio/portfolio_model.dart';
import '../sources/local/portfolio_local_ds.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource local;
  final _uuid = const Uuid();

  PortfolioRepositoryImpl({required this.local});

  @override
  Future<PortfolioEntity> createPortfolio(PortfolioEntity portfolio) async {
    // Generar UUID v4 para el nuevo portfolio
    final id = _uuid.v4();

    final model = PortfolioModel(
      id: id,
      portfolioType: _serializePortfolioType(portfolio.portfolioType),
      portfolioName: portfolio.portfolioName,
      countryId: portfolio.countryId,
      cityId: portfolio.cityId,
      orgId: portfolio.orgId,
      status: 'DRAFT', // Siempre DRAFT al crear
      assetsCount: 0, // Siempre 0 al crear
      createdBy: portfolio.createdBy,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    final saved = await local.upsert(model);
    return saved.toEntity();
  }

  @override
  Future<PortfolioEntity?> getPortfolioById(String portfolioId) async {
    final model = await local.getById(portfolioId);
    return model?.toEntity();
  }

  @override
  Future<List<PortfolioEntity>> getActivePortfoliosByOrg(String orgId) async {
    final models = await local.listActiveByOrg(orgId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updatePortfolio(PortfolioEntity portfolio) async {
    final model = PortfolioModel.fromEntity(portfolio);
    await local.upsert(model);
  }

  @override
  Future<PortfolioEntity> incrementAssetsCount(String portfolioId) async {
    // La transición DRAFT → ACTIVE ocurre en portfolio_local_ds.dart
    final updated = await local.incrementAssetsCount(portfolioId);
    return updated.toEntity();
  }

  @override
  Future<PortfolioEntity> decrementAssetsCount(String portfolioId) async {
    final updated = await local.decrementAssetsCount(portfolioId);
    return updated.toEntity();
  }

  @override
  Future<void> renamePortfolio(String portfolioId, String newName) async {
    final existing = await local.getById(portfolioId);
    if (existing == null) {
      throw Exception('Portfolio not found for rename: id=$portfolioId');
    }

    final renamed = PortfolioModel(
      isarId: existing.isarId,
      id: existing.id,
      portfolioType: existing.portfolioType,
      portfolioName: newName,
      countryId: existing.countryId,
      cityId: existing.cityId,
      orgId: existing.orgId,
      status: existing.status,
      assetsCount: existing.assetsCount,
      createdBy: existing.createdBy,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    await local.upsert(renamed);
  }

  @override
  Stream<PortfolioEntity?> watchPortfolioById(String portfolioId) {
    return local.watchById(portfolioId).map((model) => model?.toEntity());
  }

  @override
  Stream<List<PortfolioEntity>> watchActivePortfoliosByOrg(String orgId) {
    return local
        .watchActiveByOrg(orgId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> updateOwnerSnapshot(
    String portfolioId, {
    required String? ownerName,
    required String? ownerDocument,
    required String? ownerDocumentType,
    required String? licenseStatus,
    required String? licenseExpiryDate,
    required bool? simitHasFines,
    required int? simitFinesCount,
    required int? simitComparendosCount,
    required int? simitMultasCount,
    required String? simitFormattedTotal,
    required DateTime? simitCheckedAt,
  }) {
    return local.updateOwnerSnapshot(
      portfolioId,
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
    );
  }

  @override
  Future<int> repairMissingOrgId(String userId, String correctOrgId) {
    return local.repairMissingOrgId(userId, correctOrgId);
  }

  // Helper para serializar PortfolioType
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
}

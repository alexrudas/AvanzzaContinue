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

import '../../domain/entities/portfolio/portfolio_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../models/portfolio/portfolio_model.dart';
import '../sources/local/portfolio_local_ds.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource local;

  PortfolioRepositoryImpl({required this.local});

  @override
  Future<PortfolioEntity> createPortfolio(PortfolioEntity portfolio) async {
    // CONTRATO: respetar el id, status, assetsCount y timestamps que el
    // caller ya estableció en la entity. El caller es la fuente de verdad —
    // típicamente `CompleteOnboardingUC` genera el id con `_idGenerator()`,
    // setea el status (`active` desde 2026-05) y persiste el portfolio
    // como contenedor técnico. La navegación post-onboarding (resolver +
    // FusionadoFlow) usa ESE mismo id para llegar a la página de registro
    // VRC, que a su vez lo pasa a `incrementAssetsCountTx`.
    //
    // BUG HISTÓRICO (corregido 2026-05): este método regeneraba el UUID
    // internamente (`_uuid.v4()`) y forzaba `status: 'DRAFT'` /
    // `assetsCount: 0`, ignorando los valores de la entity. Resultado:
    //   1) El portfolio quedaba persistido con un UUID DISTINTO al que
    //      el caller tenía en memoria. Cualquier write subsiguiente
    //      (`incrementAssetsCountTx`, `updateOwnerSnapshot`) buscaba el
    //      portfolio por el UUID original y fallaba con
    //      `portfolioUpdateFailed`. Síntoma: VRC consulta exitosa pero
    //      el activo NO se persistía ("El portafolio no pudo
    //      actualizarse correctamente" en logs).
    //   2) El status se sobreescribía a DRAFT incluso cuando el caller
    //      ya había decidido `active` — el splash gate de portafolio
    //      (cuando estaba activo) nunca veía el portfolio como ACTIVE
    //      hasta el primer activo registrado, y como el registro fallaba
    //      por (1), nunca pasaba a ACTIVE.
    //
    // Fix: usar `PortfolioModel.fromEntity` (ya existente) que mapea
    // 1:1 todos los campos respetando lo que el caller envía. El método
    // `local.upsert` es idempotente — si la entity tiene un id que ya
    // existe, lo reemplaza; si no, lo crea.
    final model = PortfolioModel.fromEntity(portfolio);
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
    DateTime? licenseCheckedAt,
    String? simitDetailJson,
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
      licenseCheckedAt: licenseCheckedAt,
      simitDetailJson: simitDetailJson,
    );
  }

  @override
  Future<void> updateSimitSnapshot(
    String portfolioId, {
    required bool? hasFines,
    required int? finesCount,
    required int? comparendosCount,
    required int? multasCount,
    required String? formattedTotal,
    required DateTime checkedAt,
    String? detailJson,
  }) {
    return local.updateSimitSnapshot(
      portfolioId,
      hasFines: hasFines,
      finesCount: finesCount,
      comparendosCount: comparendosCount,
      multasCount: multasCount,
      formattedTotal: formattedTotal,
      checkedAt: checkedAt,
      detailJson: detailJson,
    );
  }

  @override
  Future<void> updateLicenseSnapshot(
    String portfolioId, {
    required String? ownerName,
    required String? ownerDocument,
    required String? ownerDocumentType,
    required String? licenseStatus,
    required String? licenseExpiryDate,
    required DateTime checkedAt,
  }) {
    return local.updateLicenseSnapshot(
      portfolioId,
      ownerName: ownerName,
      ownerDocument: ownerDocument,
      ownerDocumentType: ownerDocumentType,
      licenseStatus: licenseStatus,
      licenseExpiryDate: licenseExpiryDate,
      checkedAt: checkedAt,
    );
  }

  @override
  Future<int> repairMissingOrgId(String userId, String correctOrgId) {
    return local.repairMissingOrgId(userId, correctOrgId);
  }
}

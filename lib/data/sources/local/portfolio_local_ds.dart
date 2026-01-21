import 'package:isar_community/isar.dart';
import '../../models/portfolio/portfolio_model.dart';

class PortfolioLocalDataSource {
  final Isar _isar;

  PortfolioLocalDataSource(this._isar);

  /// Obtener portfolio por String id
  Future<PortfolioModel?> getById(String id) async {
    return await _isar.portfolioModels
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  /// Upsert: crear o actualizar preservando isarId
  Future<PortfolioModel> upsert(PortfolioModel model) async {
    return await _isar.writeTxn(() async {
      // Buscar existente por id (String) dentro de la transacción
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(model.id)
          .findFirst();

      final PortfolioModel toSave;
      if (existing != null) {
        // UPDATE: preservar isarId y createdAt
        toSave = PortfolioModel(
          isarId: existing.isarId, // CRÍTICO: preservar isarId
          id: model.id,
          portfolioType: model.portfolioType,
          portfolioName: model.portfolioName,
          countryId: model.countryId,
          cityId: model.cityId,
          status: model.status,
          assetsCount: model.assetsCount,
          createdBy: model.createdBy,
          createdAt: existing.createdAt, // Inmutable
          updatedAt: DateTime.now().toUtc(), // Siempre UTC
        );
      } else {
        // INSERT: nuevo registro
        toSave = PortfolioModel(
          isarId: model.isarId, // null para auto-increment
          id: model.id,
          portfolioType: model.portfolioType,
          portfolioName: model.portfolioName,
          countryId: model.countryId,
          cityId: model.cityId,
          status: model.status,
          assetsCount: model.assetsCount,
          createdBy: model.createdBy,
          createdAt: model.createdAt ?? DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        );
      }

      await _isar.portfolioModels.put(toSave);

      // Re-leer para obtener isarId asignado
      final saved = await _isar.portfolioModels
          .filter()
          .idEqualTo(toSave.id)
          .findFirst();

      if (saved == null) {
        throw Exception('Portfolio upsert failed: could not retrieve saved record for id=${model.id}');
      }

      return saved;
    });
  }

  /// Eliminar por String id
  Future<bool> deleteById(String id) async {
    return await _isar.writeTxn(() async {
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (existing == null) return false;

      return await _isar.portfolioModels.delete(existing.isarId!);
    });
  }

  /// Listar portfolios del usuario (todos los status)
  Future<List<PortfolioModel>> listByUser(String userId) async {
    return await _isar.portfolioModels
        .filter()
        .createdByEqualTo(userId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Listar portfolios activos del usuario
  Future<List<PortfolioModel>> listActiveByUser(String userId) async {
    return await _isar.portfolioModels
        .filter()
        .createdByEqualTo(userId)
        .statusEqualTo('ACTIVE')
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Incrementar assetsCount (transacción atómica)
  Future<PortfolioModel> incrementAssetsCount(String id) async {
    return await _isar.writeTxn(() async {
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (existing == null) {
        throw Exception('Portfolio not found for increment: id=$id');
      }

      final newCount = existing.assetsCount + 1;

      // Auto-transición DRAFT → ACTIVE cuando pasa de 0 → 1
      final newStatus = (existing.status == 'DRAFT' && existing.assetsCount == 0 && newCount == 1)
          ? 'ACTIVE'
          : existing.status;

      final updated = PortfolioModel(
        isarId: existing.isarId, // Preservar isarId
        id: existing.id,
        portfolioType: existing.portfolioType,
        portfolioName: existing.portfolioName,
        countryId: existing.countryId,
        cityId: existing.cityId,
        status: newStatus,
        assetsCount: newCount,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt, // Inmutable
        updatedAt: DateTime.now().toUtc(),
      );

      await _isar.portfolioModels.put(updated);

      // Re-leer para confirmar
      final saved = await _isar.portfolioModels
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (saved == null) {
        throw Exception('Portfolio increment failed: could not retrieve updated record for id=$id');
      }

      return saved;
    });
  }

  /// Decrementar assetsCount (transacción atómica)
  Future<PortfolioModel> decrementAssetsCount(String id) async {
    return await _isar.writeTxn(() async {
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (existing == null) {
        throw Exception('Portfolio not found for decrement: id=$id');
      }

      final newCount = (existing.assetsCount > 0) ? existing.assetsCount - 1 : 0;

      final updated = PortfolioModel(
        isarId: existing.isarId, // Preservar isarId
        id: existing.id,
        portfolioType: existing.portfolioType,
        portfolioName: existing.portfolioName,
        countryId: existing.countryId,
        cityId: existing.cityId,
        status: existing.status,
        assetsCount: newCount,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt, // Inmutable
        updatedAt: DateTime.now().toUtc(),
      );

      await _isar.portfolioModels.put(updated);

      // Re-leer para confirmar
      final saved = await _isar.portfolioModels
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (saved == null) {
        throw Exception('Portfolio decrement failed: could not retrieve updated record for id=$id');
      }

      return saved;
    });
  }
}

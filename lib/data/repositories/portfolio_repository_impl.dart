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
  Future<List<PortfolioEntity>> getActivePortfolios(String userId) async {
    final models = await local.listActiveByUser(userId);
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

    // Null-safety: incrementAssetsCount lanza Exception si no existe
    // Nunca retorna null, así que podemos mapear directamente
    return updated.toEntity();
  }

  @override
  Future<PortfolioEntity> decrementAssetsCount(String portfolioId) async {
    final updated = await local.decrementAssetsCount(portfolioId);

    // Null-safety: decrementAssetsCount lanza Exception si no existe
    // Nunca retorna null, así que podemos mapear directamente
    return updated.toEntity();
  }

  // Helper para serializar PortfolioType
  static String _serializePortfolioType(PortfolioType type) {
    switch (type) {
      case PortfolioType.vehiculos:
        return 'VEHICULOS';
      case PortfolioType.inmuebles:
        return 'INMUEBLES';
    }
  }
}

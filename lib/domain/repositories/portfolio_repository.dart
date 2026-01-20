import '../entities/portfolio/portfolio_entity.dart';

/// Repositorio de Portfolio
/// Gestiona la persistencia y consulta de portafolios
///
/// Reglas de negocio:
/// - Un portafolio se crea con status = DRAFT y assetsCount = 0
/// - La transición DRAFT → ACTIVE ocurre automáticamente cuando assetsCount pasa de 0 → 1
/// - assetsCount nunca puede ser < 0
/// - Solo portafolios ACTIVE aparecen en Home
abstract class PortfolioRepository {
  /// Crear un nuevo portafolio (status = DRAFT, assetsCount = 0)
  Future<PortfolioEntity> createPortfolio(PortfolioEntity portfolio);

  /// Obtener portafolio por ID
  Future<PortfolioEntity?> getPortfolioById(String portfolioId);

  /// Obtener todos los portafolios ACTIVE del usuario
  Future<List<PortfolioEntity>> getActivePortfolios(String userId);

  /// Actualizar portafolio
  Future<void> updatePortfolio(PortfolioEntity portfolio);

  /// Incrementar contador de activos
  /// Si assetsCount pasa de 0 → 1, activa el portafolio automáticamente (DRAFT → ACTIVE)
  /// Retorna el portafolio actualizado
  Future<PortfolioEntity> incrementAssetsCount(String portfolioId);

  /// Decrementar contador de activos
  /// assetsCount nunca será < 0 (protegido internamente)
  /// Retorna el portafolio actualizado
  Future<PortfolioEntity> decrementAssetsCount(String portfolioId);
}

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

  /// Obtener todos los portafolios ACTIVE de una organización
  Future<List<PortfolioEntity>> getActivePortfoliosByOrg(String orgId);

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

  /// Renombra un portafolio existente usando su ID.
  ///
  /// Debe actualizar únicamente el nombre visible del portafolio
  /// sin alterar su identidad, conteo de activos, tipo, organización
  /// ni demás campos de negocio.
  ///
  /// Reglas esperadas:
  /// - [newName] debe persistirse ya normalizado/validado internamente.
  /// - Si el portafolio no existe, la implementación debe fallar de forma controlada.
  /// - El cambio debe propagarse a los watchers reactivos que observen este portafolio
  ///   o la lista de portafolios de la organización.
  Future<void> renamePortfolio(String portfolioId, String newName);

  /// Stream reactivo de un portafolio específico por su ID.
  ///
  /// Emite el portafolio actual cada vez que cambie en la fuente de datos
  /// (por ejemplo: nombre, estado, conteo de activos, etc.).
  ///
  /// Uso esperado:
  /// - Mantener pantallas de detalle sincronizadas sin depender de snapshots
  ///   pasados por navegación.
  /// - Reflejar cambios inmediatos como rename, activación o actualización
  ///   de metadatos del portafolio.
  ///
  /// Si el portafolio deja de existir, puede emitir `null` según la implementación.
  Stream<PortfolioEntity?> watchPortfolioById(String portfolioId);

  /// Stream reactivo de portafolios ACTIVE para una organización.
  /// Emite lista actualizada cada vez que Isar detecta cambios.
  Stream<List<PortfolioEntity>> watchActivePortfoliosByOrg(String orgId);

  /// Actualiza solo los campos del snapshot propietario VRC (owner* + simit*).
  ///
  /// Lee el estado actual de Isar dentro de una transacción atómica para
  /// resolver la carrera con incrementAssetsCountTx: cuando el batch VRC
  /// llega a 'completed' con 100% éxito, _persistOwnerSnapshot y _registerPlate
  /// corren casi simultáneamente. Isar serializa writeTxn — la que corre
  /// después siempre lee el estado correcto (incluyendo el ACTIVE que
  /// incrementAssetsCountTx ya escribió).
  ///
  /// NUNCA modifica status, assetsCount ni campos operativos.
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
  });

  /// Repara portafolios del usuario que fueron creados con orgId vacío.
  ///
  /// Race condition de arranque: cuando createPortfolioStep1() llama
  /// _resolveOrgId() antes de que SessionContextController haya cargado el
  /// activeContext, el portafolio se persiste con orgId:''. watchActiveByOrg
  /// filtra por orgId — ese portafolio nunca aparece en Home.
  ///
  /// Llamar desde AdminHomeController._loadLocal() antes de suscribirse al
  /// stream, para que los portafolios huérfanos ya tengan el orgId correcto
  /// en el primer evento del stream.
  ///
  /// Retorna el número de portafolios reparados (0 si no había huérfanos).
  Future<int> repairMissingOrgId(String userId, String correctOrgId);
}

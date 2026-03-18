// ============================================================================
// lib/data/sources/local/portfolio_local_ds.dart
// PORTFOLIO LOCAL DATA SOURCE — Enterprise Ultra Pro (Data / Sources / Local)
//
// QUÉ HACE:
// - Acceso a PortfolioModel en Isar (CRUD + contadores).
// - incrementAssetsCountTx(): método COMPOSABLE que asume que el llamador ya
//   está dentro de un writeTxn; NO abre su propio writeTxn.
// - incrementAssetsCount(): operación standalone que envuelve incrementAssetsCountTx
//   en su propio writeTxn (uso fuera de transacciones atómicas compuestas).
//
// QUÉ NO HACE:
// - No contiene lógica de negocio.
// - No conoce el dominio de activos más allá de AssetCreationException
//   (usado para señalizar portafolio no encontrado en contexto transaccional).
//
// NOTAS:
// - incrementAssetsCountTx(Isar, String) resuelve el deadlock que causaba
//   llamar incrementAssetsCount() (con writeTxn propio) desde dentro de otra
//   transacción Isar (Isar no soporta transacciones reentrantes en el mismo
//   isolate).
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../domain/errors/asset_creation_exception.dart';
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
        // UPDATE: preservar isarId, createdAt y orgId (inmutable tras creación).
        toSave = PortfolioModel(
          isarId: existing.isarId,
          id: model.id,
          portfolioType: model.portfolioType,
          portfolioName: model.portfolioName,
          countryId: model.countryId,
          cityId: model.cityId,
          orgId: model.orgId.isNotEmpty ? model.orgId : existing.orgId,
          status: model.status,
          assetsCount: model.assetsCount,
          createdBy: model.createdBy,
          createdAt: existing.createdAt,
          updatedAt: DateTime.now().toUtc(),
        );
      } else {
        // INSERT: nuevo registro.
        toSave = PortfolioModel(
          isarId: model.isarId,
          id: model.id,
          portfolioType: model.portfolioType,
          portfolioName: model.portfolioName,
          countryId: model.countryId,
          cityId: model.cityId,
          orgId: model.orgId,
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

  /// Contar portfolios ACTIVE del usuario sin deserializar objetos — O(log n).
  ///
  /// Usar en el gate S2 de SplashBootstrapController: solo interesa saber si
  /// count > 0. Isar ejecuta `.count()` con un full-table-scan filtrado por
  /// índice, sin construir objetos Dart.
  Future<int> countActiveByUser(String userId) {
    return _isar.portfolioModels
        .filter()
        .createdByEqualTo(userId)
        .statusEqualTo('ACTIVE')
        .count();
  }

  /// Incrementa assetsCount de forma COMPOSABLE.
  ///
  /// PREREQUISITO: el llamador DEBE estar ya dentro de un [Isar.writeTxn].
  /// Este método NO abre su propia transacción; permite ser incluido en
  /// transacciones atómicas más grandes (ej. asset + vehículo + portafolio).
  ///
  /// Lanza [AssetCreationException.portfolioUpdateFailed()] si el portafolio
  /// no existe; el error aborta la transacción exterior automáticamente.
  Future<void> incrementAssetsCountTx(Isar isar, String portfolioId) async {
    final existing = await isar.portfolioModels
        .filter()
        .idEqualTo(portfolioId)
        .findFirst();

    if (existing == null) {
      throw AssetCreationException.portfolioUpdateFailed();
    }

    final newCount = existing.assetsCount + 1;

    // Auto-transición DRAFT → ACTIVE cuando se vincula el primer activo.
    final newStatus =
        (existing.status == 'DRAFT' && existing.assetsCount == 0 && newCount == 1)
            ? 'ACTIVE'
            : existing.status;

    await isar.portfolioModels.put(PortfolioModel(
      isarId: existing.isarId,
      id: existing.id,
      portfolioType: existing.portfolioType,
      portfolioName: existing.portfolioName,
      countryId: existing.countryId,
      cityId: existing.cityId,
      orgId: existing.orgId,
      status: newStatus,
      assetsCount: newCount,
      createdBy: existing.createdBy,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
    ));
  }

  /// Incrementa assetsCount en transacción standalone.
  ///
  /// Usar cuando el incremento NO forma parte de una transacción mayor.
  /// Para uso dentro de [Isar.writeTxn] existente, usar [incrementAssetsCountTx].
  Future<PortfolioModel> incrementAssetsCount(String id) async {
    await _isar.writeTxn(() => incrementAssetsCountTx(_isar, id));

    final saved = await _isar.portfolioModels
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (saved == null) {
      throw Exception(
          'Portfolio increment failed: cannot retrieve updated record id=$id');
    }

    return saved;
  }

  /// Stream reactivo de portafolios ACTIVE para una organización.
  ///
  /// Isar emite un nuevo evento cada vez que cualquier PortfolioModel cuyo
  /// orgId == [orgId] y status == 'ACTIVE' es insertado, modificado o
  /// eliminado. El HomeController puede suscribirse aquí para mantener la
  /// lista actualizada sin polling.
  Stream<List<PortfolioModel>> watchActiveByOrg(String orgId) {
    return _isar.portfolioModels
        .filter()
        .orgIdEqualTo(orgId)
        .statusEqualTo('ACTIVE')
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  /// Consulta puntual de portafolios ACTIVE de una organización.
  Future<List<PortfolioModel>> listActiveByOrg(String orgId) {
    return _isar.portfolioModels
        .filter()
        .orgIdEqualTo(orgId)
        .statusEqualTo('ACTIVE')
        .sortByCreatedAtDesc()
        .findAll();
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
        isarId: existing.isarId,
        id: existing.id,
        portfolioType: existing.portfolioType,
        portfolioName: existing.portfolioName,
        countryId: existing.countryId,
        cityId: existing.cityId,
        orgId: existing.orgId,
        status: existing.status,
        assetsCount: newCount,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt,
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

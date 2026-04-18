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
//
// ENTERPRISE NOTES:
// ACTUALIZADO (2026-04): Fix crítico — los 10 campos del snapshot propietario VRC
//   (owner* y simit*) no se copiaban en ninguna rama de escritura (upsert UPDATE,
//   incrementAssetsCountTx, decrementAssetsCount). Cada escritura sobreescribía
//   esos campos con null, haciendo que _OwnerSnapshotBand nunca mostrara el grid.
//   Fix: upsert usa model.*??existing.* para preservar; increment/decrement
//   copian siempre de existing.* (no los modifican).
// ACTUALIZADO (2026-04): +repairMissingOrgId() — recupera portafolios creados
//   con orgId:'' por race condition de arranque (SessionContextController no
//   tenía orgId disponible cuando createPortfolioStep1 llamó _resolveOrgId()).
//   Llamado desde AdminHomeController._loadLocal() en cada arranque.
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
        // Los campos del snapshot VRC (owner* y simit*) se toman de [model]:
        // si [model] los trae no-null (llamada desde _persistOwnerSnapshot),
        // se guardan; si son null se conserva lo que ya había en Isar
        // (upsert desde otros paths que no tocan el snapshot).
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
          // Snapshot propietario VRC: modelo gana si trae dato; fallback a Isar.
          ownerName: model.ownerName ?? existing.ownerName,
          ownerDocument: model.ownerDocument ?? existing.ownerDocument,
          ownerDocumentType: model.ownerDocumentType ?? existing.ownerDocumentType,
          licenseStatus: model.licenseStatus ?? existing.licenseStatus,
          licenseExpiryDate: model.licenseExpiryDate ?? existing.licenseExpiryDate,
          simitHasFines: model.simitHasFines ?? existing.simitHasFines,
          simitFinesCount: model.simitFinesCount ?? existing.simitFinesCount,
          simitComparendosCount: model.simitComparendosCount ?? existing.simitComparendosCount,
          simitMultasCount: model.simitMultasCount ?? existing.simitMultasCount,
          simitFormattedTotal: model.simitFormattedTotal ?? existing.simitFormattedTotal,
          simitCheckedAt: model.simitCheckedAt ?? existing.simitCheckedAt,
          licenseCheckedAt: model.licenseCheckedAt ?? existing.licenseCheckedAt,
          simitDetailJson: model.simitDetailJson ?? existing.simitDetailJson,
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
      // Preservar snapshot VRC — solo se actualiza desde _persistOwnerSnapshot.
      ownerName: existing.ownerName,
      ownerDocument: existing.ownerDocument,
      ownerDocumentType: existing.ownerDocumentType,
      licenseStatus: existing.licenseStatus,
      licenseExpiryDate: existing.licenseExpiryDate,
      simitHasFines: existing.simitHasFines,
      simitFinesCount: existing.simitFinesCount,
      simitComparendosCount: existing.simitComparendosCount,
      simitMultasCount: existing.simitMultasCount,
      simitFormattedTotal: existing.simitFormattedTotal,
      simitCheckedAt: existing.simitCheckedAt,
      licenseCheckedAt: existing.licenseCheckedAt,
      simitDetailJson: existing.simitDetailJson,
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

  /// Stream reactivo de un portafolio específico por su String id.
  ///
  /// Isar emite un nuevo evento cada vez que el registro cambia.
  /// Emite null si el portafolio no existe o es eliminado.
  Stream<PortfolioModel?> watchById(String id) {
    return _isar.portfolioModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((list) => list.isNotEmpty ? list.first : null);
  }

  /// Actualiza solo los campos del snapshot propietario VRC (owner* + simit*).
  ///
  /// Lee el registro DENTRO de la writeTxn para capturar el status/assetsCount
  /// más reciente, incluso si incrementAssetsCountTx está corriendo
  /// concurrentemente. Isar serializa writeTxn: la que corre después siempre
  /// ve el resultado de la anterior.
  ///
  /// NUNCA sobreescribe status, assetsCount ni ningún campo operativo —
  /// solo los campos snapshot (owner* y simit*). Los campos snapshot se
  /// fusionan: null incoming conserva el valor existente en Isar.
  ///
  /// Lanza excepción si el portafolio no existe (el caller puede reattempt).
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
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(portfolioId)
          .findFirst();

      if (existing == null) {
        throw Exception(
            'Portfolio updateOwnerSnapshot: not found id=$portfolioId');
      }

      await _isar.portfolioModels.put(PortfolioModel(
        isarId: existing.isarId,
        id: existing.id,
        portfolioType: existing.portfolioType,
        portfolioName: existing.portfolioName,
        countryId: existing.countryId,
        cityId: existing.cityId,
        orgId: existing.orgId,
        // INMUTABLE en este contexto — solo incrementAssetsCountTx transiciona status.
        status: existing.status,
        assetsCount: existing.assetsCount,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
        // Snapshot VRC: merge — null conserva el valor existente.
        ownerName: ownerName ?? existing.ownerName,
        ownerDocument: ownerDocument ?? existing.ownerDocument,
        ownerDocumentType: ownerDocumentType ?? existing.ownerDocumentType,
        licenseStatus: licenseStatus ?? existing.licenseStatus,
        licenseExpiryDate: licenseExpiryDate ?? existing.licenseExpiryDate,
        simitHasFines: simitHasFines ?? existing.simitHasFines,
        simitFinesCount: simitFinesCount ?? existing.simitFinesCount,
        simitComparendosCount:
            simitComparendosCount ?? existing.simitComparendosCount,
        simitMultasCount: simitMultasCount ?? existing.simitMultasCount,
        simitFormattedTotal: simitFormattedTotal ?? existing.simitFormattedTotal,
        simitCheckedAt: simitCheckedAt ?? existing.simitCheckedAt,
        licenseCheckedAt: licenseCheckedAt ?? existing.licenseCheckedAt,
        simitDetailJson: simitDetailJson ?? existing.simitDetailJson,
      ));
    });
  }

  /// Actualiza SOLO campos SIMIT del snapshot. No toca licencia ni identidad.
  ///
  /// Mismo patrón read-modify-write que [updateOwnerSnapshot], pero con
  /// firma enfocada — elimina necesidad de pasar nulls para campos de licencia.
  Future<void> updateSimitSnapshot(
    String portfolioId, {
    required bool? hasFines,
    required int? finesCount,
    required int? comparendosCount,
    required int? multasCount,
    required String? formattedTotal,
    required DateTime checkedAt,
    String? detailJson,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(portfolioId)
          .findFirst();

      if (existing == null) {
        throw Exception(
            'Portfolio updateSimitSnapshot: not found id=$portfolioId');
      }

      await _isar.portfolioModels.put(PortfolioModel(
        isarId: existing.isarId,
        id: existing.id,
        portfolioType: existing.portfolioType,
        portfolioName: existing.portfolioName,
        countryId: existing.countryId,
        cityId: existing.cityId,
        orgId: existing.orgId,
        status: existing.status,
        assetsCount: existing.assetsCount,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
        // Preservar campos de identidad y licencia — no tocar.
        ownerName: existing.ownerName,
        ownerDocument: existing.ownerDocument,
        ownerDocumentType: existing.ownerDocumentType,
        licenseStatus: existing.licenseStatus,
        licenseExpiryDate: existing.licenseExpiryDate,
        licenseCheckedAt: existing.licenseCheckedAt,
        // SIMIT: merge — null incoming conserva existente.
        simitHasFines: hasFines ?? existing.simitHasFines,
        simitFinesCount: finesCount ?? existing.simitFinesCount,
        simitComparendosCount:
            comparendosCount ?? existing.simitComparendosCount,
        simitMultasCount: multasCount ?? existing.simitMultasCount,
        simitFormattedTotal: formattedTotal ?? existing.simitFormattedTotal,
        simitCheckedAt: checkedAt,
        simitDetailJson: detailJson ?? existing.simitDetailJson,
      ));
    });
  }

  /// Actualiza SOLO campos de licencia/identidad del snapshot. No toca SIMIT.
  Future<void> updateLicenseSnapshot(
    String portfolioId, {
    required String? ownerName,
    required String? ownerDocument,
    required String? ownerDocumentType,
    required String? licenseStatus,
    required String? licenseExpiryDate,
    required DateTime checkedAt,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.portfolioModels
          .filter()
          .idEqualTo(portfolioId)
          .findFirst();

      if (existing == null) {
        throw Exception(
            'Portfolio updateLicenseSnapshot: not found id=$portfolioId');
      }

      await _isar.portfolioModels.put(PortfolioModel(
        isarId: existing.isarId,
        id: existing.id,
        portfolioType: existing.portfolioType,
        portfolioName: existing.portfolioName,
        countryId: existing.countryId,
        cityId: existing.cityId,
        orgId: existing.orgId,
        status: existing.status,
        assetsCount: existing.assetsCount,
        createdBy: existing.createdBy,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toUtc(),
        // Licencia/identidad: merge — null incoming conserva existente.
        ownerName: ownerName ?? existing.ownerName,
        ownerDocument: ownerDocument ?? existing.ownerDocument,
        ownerDocumentType: ownerDocumentType ?? existing.ownerDocumentType,
        licenseStatus: licenseStatus ?? existing.licenseStatus,
        licenseExpiryDate: licenseExpiryDate ?? existing.licenseExpiryDate,
        licenseCheckedAt: checkedAt,
        // Preservar campos SIMIT — no tocar.
        simitHasFines: existing.simitHasFines,
        simitFinesCount: existing.simitFinesCount,
        simitComparendosCount: existing.simitComparendosCount,
        simitMultasCount: existing.simitMultasCount,
        simitFormattedTotal: existing.simitFormattedTotal,
        simitCheckedAt: existing.simitCheckedAt,
        simitDetailJson: existing.simitDetailJson,
      ));
    });
  }

  /// Repara portafolios huérfanos (orgId vacío) del usuario.
  ///
  /// Isar no admite UPDATE parcial — reescribe el registro completo preservando
  /// todos los campos, incluidos los del snapshot VRC.
  ///
  /// Llamar desde AdminHomeController en onInit para recuperar portafolios
  /// creados cuando SessionContextController aún no tenía orgId disponible
  /// (race condition de arranque que asigna orgId: '' al portafolio).
  ///
  /// Retorna el número de portafolios reparados (0 si no había huérfanos).
  Future<int> repairMissingOrgId(String userId, String correctOrgId) async {
    // Buscar portafolios del usuario con orgId vacío
    final orphans = await _isar.portfolioModels
        .filter()
        .createdByEqualTo(userId)
        .orgIdEqualTo('')
        .findAll();

    if (orphans.isEmpty) return 0;

    await _isar.writeTxn(() async {
      for (final orphan in orphans) {
        await _isar.portfolioModels.put(PortfolioModel(
          isarId: orphan.isarId,
          id: orphan.id,
          portfolioType: orphan.portfolioType,
          portfolioName: orphan.portfolioName,
          countryId: orphan.countryId,
          cityId: orphan.cityId,
          orgId: correctOrgId, // ← REPAIR
          status: orphan.status,
          assetsCount: orphan.assetsCount,
          createdBy: orphan.createdBy,
          createdAt: orphan.createdAt,
          updatedAt: DateTime.now().toUtc(),
          // Preservar snapshot VRC — no se toca en este repair.
          ownerName: orphan.ownerName,
          ownerDocument: orphan.ownerDocument,
          ownerDocumentType: orphan.ownerDocumentType,
          licenseStatus: orphan.licenseStatus,
          licenseExpiryDate: orphan.licenseExpiryDate,
          simitHasFines: orphan.simitHasFines,
          simitFinesCount: orphan.simitFinesCount,
          simitComparendosCount: orphan.simitComparendosCount,
          simitMultasCount: orphan.simitMultasCount,
          simitFormattedTotal: orphan.simitFormattedTotal,
          simitCheckedAt: orphan.simitCheckedAt,
          licenseCheckedAt: orphan.licenseCheckedAt,
          simitDetailJson: orphan.simitDetailJson,
        ));
      }
    });

    return orphans.length;
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
        // Preservar snapshot VRC — solo se actualiza desde _persistOwnerSnapshot.
        ownerName: existing.ownerName,
        ownerDocument: existing.ownerDocument,
        ownerDocumentType: existing.ownerDocumentType,
        licenseStatus: existing.licenseStatus,
        licenseExpiryDate: existing.licenseExpiryDate,
        simitHasFines: existing.simitHasFines,
        simitFinesCount: existing.simitFinesCount,
        simitComparendosCount: existing.simitComparendosCount,
        simitMultasCount: existing.simitMultasCount,
        simitFormattedTotal: existing.simitFormattedTotal,
        simitCheckedAt: existing.simitCheckedAt,
        licenseCheckedAt: existing.licenseCheckedAt,
        simitDetailJson: existing.simitDetailJson,
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

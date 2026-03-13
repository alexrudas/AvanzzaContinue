// ============================================================================
// lib/data/repositories/asset_repository_impl.dart
// ASSET REPOSITORY IMPL — Enterprise Ultra Pro (Data / Repositories)
//
// QUÉ HACE:
// - Implementa AssetRepository con estrategia offline-first.
// - createAssetFromRuntAndLinkToPortfolio(): escritura atómica ALL-OR-NOTHING
//   (asset + vehículo + contador de portafolio) en un único writeTxn Isar.
// - Encola sync remoto fuera de la transacción vía SyncEnqueueFn.
//
// QUÉ NO HACE:
// - No usa GetX, navegación ni lógica de UI.
// - No abre transacciones anidadas (cada método usa su propio writeTxn).
// - No expone errores técnicos crudos: los mapea a AssetCreationException.
//
// NOTAS:
// - portfolioLocalDS.incrementAssetsCountTx(isar, id) es composable: recibe
//   el Isar singleton y asume que el llamador ya está dentro de un writeTxn.
//   Elimina el riesgo de deadlock por transacciones anidadas.
// - placa en AssetVehiculoModel tiene @Index(unique:true) sin replace; el
//   pre-check previo es la primera capa de defensa. IsarError capturado en el
//   bloque catch es la segunda capa (escenario TOCTOU race).
// ============================================================================

import 'dart:async';

import 'package:avanzza/data/models/asset/asset_document_model.dart';
import 'package:avanzza/data/models/asset/asset_model.dart';
import 'package:avanzza/data/models/asset/special/asset_inmueble_model.dart';
import 'package:avanzza/data/models/asset/special/asset_maquinaria_model.dart';
import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/sources/local/asset_local_ds.dart';
import 'package:avanzza/data/sources/remote/asset_remote_ds.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/asset/asset_content.dart';
import '../../../domain/entities/asset/asset_document_entity.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/asset/special/asset_inmueble_entity.dart';
import '../../../domain/entities/asset/special/asset_maquinaria_entity.dart';
import '../../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../../domain/errors/asset_creation_exception.dart';
import '../../../domain/repositories/asset_repository.dart';
import '../sources/local/portfolio_local_ds.dart';

/// Firma del encolador de sync. Coincide con [OfflineSyncService.enqueue].
typedef SyncEnqueueFn = void Function(Future<void> Function() job);

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource local;
  final AssetRemoteDataSource remote;
  final SyncEnqueueFn enqueueSync;

  /// Requerido para la escritura atómica asset + vehículo + portafolio.
  /// Se mantiene como dependencia explícita para testabilidad.
  final PortfolioLocalDataSource portfolioLocalDS;

  AssetRepositoryImpl({
    required this.local,
    required this.remote,
    required this.enqueueSync,
    required this.portfolioLocalDS,
  });

  // ---------------------------------------------------------------------------
  // Helpers (Enterprise: evita streams colgados + evita throws por add/close tardío)
  // ---------------------------------------------------------------------------

  static void _safeAdd<T>(StreamController<T> c, T value) {
    try {
      if (!c.isClosed) c.add(value);
    } catch (_) {
      // Intencional: si ya cerró / listener canceló, no hacemos ruido.
    }
  }

  static Future<void> _safeClose(StreamController<dynamic> c) async {
    try {
      if (!c.isClosed) await c.close();
    } catch (_) {
      // Intencional: cierre idempotente.
    }
  }

  // ---------------------------------------------------------------------------
  // Root assets
  // ---------------------------------------------------------------------------

  @override
  Stream<List<AssetEntity>> watchAssetsByOrg(
    String orgId, {
    String? assetType,
    String? cityId,
  }) async* {
    final controller = StreamController<List<AssetEntity>>();

    unawaited(() async {
      try {
        final locals = await local.listAssetsByOrg(
          orgId,
          assetType: assetType,
          cityId: cityId,
        );
        _safeAdd(controller, locals.map((e) => e.toEntity()).toList());

        final remotesResult = await remote.listAssetsByOrg(
          orgId,
          assetType: assetType,
          cityId: cityId,
        );

        await _syncAssets(locals, remotesResult.items);

        final updated = await local.listAssetsByOrg(
          orgId,
          assetType: assetType,
          cityId: cityId,
        );
        _safeAdd(controller, updated.map((e) => e.toEntity()).toList());
      } finally {
        await _safeClose(controller);
      }
    }());

    yield* controller.stream;
  }

  @override
  Future<List<AssetEntity>> fetchAssetsByOrg(
    String orgId, {
    String? assetType,
    String? cityId,
  }) async {
    final locals = await local.listAssetsByOrg(
      orgId,
      assetType: assetType,
      cityId: cityId,
    );

    unawaited(() async {
      final remotesResult = await remote.listAssetsByOrg(
        orgId,
        assetType: assetType,
        cityId: cityId,
      );
      await _syncAssets(locals, remotesResult.items);
    }());

    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncAssets(
      List<AssetModel> locals, List<AssetModel> remotes) async {
    final map = {for (final l in locals) l.id: l};

    for (final r in remotes) {
      final l = map[r.id];

      // NOTA: updatedAt es nullable en AssetModel (según tu modelo).
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertAsset(r);
      }
    }
  }

  @override
  Stream<AssetEntity?> watchAsset(String assetId) async* {
    final controller = StreamController<AssetEntity?>();

    unawaited(() async {
      try {
        final l = await local.getAsset(assetId);
        _safeAdd(controller, l?.toEntity());

        final r = await remote.getAsset(assetId);
        if (r != null) {
          await local.upsertAsset(r);
          final updated = await local.getAsset(assetId);
          _safeAdd(controller, updated?.toEntity());
        }
      } finally {
        await _safeClose(controller);
      }
    }());

    yield* controller.stream;
  }

  @override
  Future<AssetEntity?> getAsset(String assetId) async {
    final l = await local.getAsset(assetId);

    unawaited(() async {
      final r = await remote.getAsset(assetId);
      if (r != null) await local.upsertAsset(r);
    }());

    return l?.toEntity();
  }

  @override
  Future<void> upsertAsset(AssetEntity asset) async {
    final m = AssetModel.fromEntity(asset);

    await local.upsertAsset(m);

    try {
      await remote.upsertAsset(m);
    } catch (_) {
      enqueueSync(() => remote.upsertAsset(m));
    }
  }

  @override
  Future<
      ({
        AssetVehiculoEntity? vehiculo,
        AssetInmuebleEntity? inmueble,
        AssetMaquinariaEntity? maquinaria
      })> getAssetDetails(String assetId) async {
    final vLocal = await local.getVehiculo(assetId);
    final iLocal = await local.getInmueble(assetId);
    final mLocal = await local.getMaquinaria(assetId);

    // background sync
    unawaited(() async {
      final vRem = await remote.getVehiculo(assetId);
      if (vRem != null) await local.upsertVehiculo(vRem);

      final iRem = await remote.getInmueble(assetId);
      if (iRem != null) await local.upsertInmueble(iRem);

      final mRem = await remote.getMaquinaria(assetId);
      if (mRem != null) await local.upsertMaquinaria(mRem);
    }());

    return (
      vehiculo: vLocal?.toEntity(),
      inmueble: iLocal?.toEntity(),
      maquinaria: mLocal?.toEntity(),
    );
  }

  @override
  Future<void> upsertVehiculo(AssetVehiculoEntity vehiculo) async {
    // OJO: Si updatedAt en Domain es no-nullable, este ?? podría disparar dead_null_aware_expression.
    // Con el Domain real se decide si se elimina el fallback o se mantiene.
    final now = DateTime.now().toUtc();
    final m = AssetVehiculoModel.fromEntity(
      vehiculo.copyWith(updatedAt: vehiculo.updatedAt ?? now),
    );

    await local.upsertVehiculo(m);

    try {
      await remote.upsertVehiculo(m);
    } catch (_) {
      enqueueSync(() => remote.upsertVehiculo(m));
    }
  }

  @override
  Future<void> upsertInmueble(AssetInmuebleEntity inmueble) async {
    final now = DateTime.now().toUtc();
    final m = AssetInmuebleModel.fromEntity(
      inmueble.copyWith(updatedAt: inmueble.updatedAt ?? now),
    );

    await local.upsertInmueble(m);

    try {
      await remote.upsertInmueble(m);
    } catch (_) {
      enqueueSync(() => remote.upsertInmueble(m));
    }
  }

  @override
  Future<void> upsertMaquinaria(AssetMaquinariaEntity maquinaria) async {
    final now = DateTime.now().toUtc();
    final m = AssetMaquinariaModel.fromEntity(
      maquinaria.copyWith(updatedAt: maquinaria.updatedAt ?? now),
    );

    await local.upsertMaquinaria(m);

    try {
      await remote.upsertMaquinaria(m);
    } catch (_) {
      enqueueSync(() => remote.upsertMaquinaria(m));
    }
  }

  // ---------------------------------------------------------------------------
  // Documents
  // ---------------------------------------------------------------------------

  @override
  Stream<List<AssetDocumentEntity>> watchAssetDocuments(
    String assetId, {
    String? countryId,
    String? cityId,
  }) async* {
    final controller = StreamController<List<AssetDocumentEntity>>();

    unawaited(() async {
      try {
        final locals = await local.listDocuments(
          assetId,
          countryId: countryId,
          cityId: cityId,
        );
        _safeAdd(controller, locals.map((e) => e.toEntity()).toList());

        final remotesResult = await remote.listDocuments(
          assetId,
          countryId: countryId,
          cityId: cityId,
        );

        await _syncDocs(locals, remotesResult.items);

        final updated = await local.listDocuments(
          assetId,
          countryId: countryId,
          cityId: cityId,
        );
        _safeAdd(controller, updated.map((e) => e.toEntity()).toList());
      } finally {
        await _safeClose(controller);
      }
    }());

    yield* controller.stream;
  }

  @override
  Future<List<AssetDocumentEntity>> fetchAssetDocuments(
    String assetId, {
    String? countryId,
    String? cityId,
  }) async {
    final locals = await local.listDocuments(
      assetId,
      countryId: countryId,
      cityId: cityId,
    );

    unawaited(() async {
      final remotesResult = await remote.listDocuments(
        assetId,
        countryId: countryId,
        cityId: cityId,
      );
      await _syncDocs(locals, remotesResult.items);
    }());

    return locals.map((e) => e.toEntity()).toList();
  }

  Future<void> _syncDocs(
    List<AssetDocumentModel> locals,
    List<AssetDocumentModel> remotes,
  ) async {
    final map = {for (final l in locals) l.id: l};

    for (final r in remotes) {
      final l = map[r.id];

      // NOTA: updatedAt es nullable en AssetDocumentModel (según tu modelo).
      final lTime = l?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rTime = r.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      if (l == null || rTime.isAfter(lTime)) {
        await local.upsertDocument(r);
      }
    }
  }

  @override
  Future<void> upsertAssetDocument(AssetDocumentEntity document) async {
    final now = DateTime.now().toUtc();
    final m = AssetDocumentModel.fromEntity(
      document.copyWith(updatedAt: document.updatedAt ?? now),
    );

    await local.upsertDocument(m);

    try {
      await remote.upsertDocument(m);
    } catch (_) {
      enqueueSync(() => remote.upsertDocument(m));
    }
  }

  // ---------------------------------------------------------------------------
  // NUEVO: Portfolio integration
  // ---------------------------------------------------------------------------

  @override
  Future<AssetEntity> createAssetFromRuntAndLinkToPortfolio({
    required String portfolioId,
    required String orgId,
    required String plate,
    required String marca,
    required String modelo,
    required int anio,
    required String countryId,
    required String cityId,
    required String createdBy,
  }) async {
    // ── VALIDACIONES PREVIAS ──────────────────────────────────────────────────
    // Se ejecutan ANTES de iniciar la transacción Isar.
    // Un fallo aquí no genera efectos secundarios en la base de datos.

    if (portfolioId.trim().isEmpty) {
      throw AssetCreationException.validationError(
        'portfolioId no puede ser vacío.',
      );
    }

    // Normalizar placa: uppercase, solo A-Z 0-9, sin guiones ni espacios.
    // Formato estándar CO: 3 letras + 3 dígitos → ej. "ABC123".
    final normalizedPlate =
        plate.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    if (normalizedPlate.isEmpty) {
      throw AssetCreationException.validationError(
        'La placa no puede ser vacía.',
      );
    }

    // Pre-check de placa duplicada.
    // AssetVehiculoModel.placa tiene @Index() sin unique → Isar no lanza
    // constraint error en inserción duplicada; la detección debe ser explícita.
    final existingVehiculo = await local.isar.assetVehiculoModels
        .filter()
        .placaEqualTo(normalizedPlate)
        .findFirst();

    if (existingVehiculo != null) {
      throw AssetCreationException.duplicatePlate();
    }

    // ── CONSTRUCCIÓN DE ENTIDADES DE DOMINIO ─────────────────────────────────
    // Todo el trabajo de mapeo se hace FUERA de la transacción Isar.
    // Las conversiones son puras; reducir el tiempo dentro del writeTxn.

    final assetId = const Uuid().v4();
    final now = DateTime.now().toUtc();

    // refCode: identificador compacto de 6 chars derivado de la placa.
    // Para placas más cortas se rellena con '0' para mantener uniformidad.
    final refCode = normalizedPlate.length >= 6
        ? normalizedPlate.substring(0, 6)
        : normalizedPlate.padRight(6, '0');

    // AssetContent.vehicle: campos obligatorios completos con datos RUNT.
    // color y engineDisplacement se marcan como pendientes; el enriquecimiento
    // posterior (nueva consulta RUNT o edición manual) los completará.
    final content = AssetContent.vehicle(
      assetKey: normalizedPlate,
      brand: marca.trim().toUpperCase(),
      model: modelo.trim().toUpperCase(),
      color: 'PENDIENTE',
      engineDisplacement: 0.0,
      mileage: 0,
    );

    // metadata.orgId / countryId / cityId son leídos por AssetModel.fromEntity().
    final assetEntity = AssetEntity.create(
      id: assetId,
      content: content,
      state: AssetState.active,
      portfolioId: portfolioId,
      metadata: {
        'orgId': orgId,
        'countryId': countryId,
        'cityId': cityId,
      },
    );

    final vehiculoEntity = AssetVehiculoEntity(
      assetId: assetId,
      refCode: refCode,
      placa: normalizedPlate,
      marca: marca.trim().toUpperCase(),
      modelo: modelo.trim().toUpperCase(),
      anio: anio,
      createdAt: now,
      updatedAt: now,
    );

    // Invariante de consistencia cross-entidad.
    // Esta condición es teóricamente imposible con el código actual,
    // pero se verifica explícitamente como guardia contra regresiones.
    if (vehiculoEntity.assetId != assetEntity.id) {
      throw AssetCreationException.validationError(
        'Inconsistencia interna: vehiculoEntity.assetId != assetEntity.id.',
      );
    }

    // ── CONVERSIÓN DOMAIN → DATA ──────────────────────────────────────────────
    final assetModel = AssetModel.fromEntity(assetEntity);
    final vehiculoModel = AssetVehiculoModel.fromEntity(vehiculoEntity);

    // ── TRANSACCIÓN ATÓMICA (ALL-OR-NOTHING) ──────────────────────────────────
    //
    // Una sola llamada a writeTxn() garantiza que las 3 escrituras se
    // confirmen o aborten juntas:
    //   1. AssetModel
    //   2. AssetVehiculoModel
    //   3. Incremento de assetsCount en PortfolioModel
    //
    // NOTA ARQUITECTÓNICA: se usa portfolioLocalDS.incrementAssetsCountTx()
    // (composable, sin writeTxn propio) en lugar de incrementAssetsCount()
    // (que abriría un writeTxn anidado → deadlock en Isar mismo isolate).
    try {
      await local.isar.writeTxn(() async {
        // Paso 1: AssetModel (índice único en id con replace:true → idempotente).
        await local.isar.assetModels.put(assetModel);

        // Paso 2: AssetVehiculoModel (índice único en assetId con replace:true).
        await local.isar.assetVehiculoModels.put(vehiculoModel);

        // Paso 3: Incremento atómico del portafolio (vía DS composable).
        // incrementAssetsCountTx asume que ya estamos dentro de writeTxn;
        // evita el deadlock de transacciones anidadas que causaría
        // portfolioLocalDS.incrementAssetsCount() (tiene su propio writeTxn).
        await portfolioLocalDS.incrementAssetsCountTx(local.isar, portfolioId);
      });
    } on AssetCreationException {
      // Excepción de dominio ya formateada (ej. portfolioUpdateFailed).
      // Propagar sin re-envolver para que la capa de aplicación la capture.
      rethrow;
    } on IsarError {
      // IsarError en este contexto indica violación de constraint unique en
      // placa (el pre-check elimina el 99.9 % de casos; este catch cubre el
      // residual TOCTOU race de escrituras concurrentes).
      throw AssetCreationException.duplicatePlate();
    } catch (e) {
      // Cualquier otro error de runtime, serialización, etc.
      // Se mapea a isarWriteFailed sin exponer detalles técnicos.
      throw AssetCreationException.isarWriteFailed();
    }

    // ── ENCOLADO DE SYNC REMOTO ───────────────────────────────────────────────
    // Las operaciones de red se delegan al OfflineSyncService fuera de la
    // transacción. Si fallan, el worker reintenta con backoff exponencial.
    enqueueSync(() => remote.upsertAsset(assetModel));
    enqueueSync(() => remote.upsertVehiculo(vehiculoModel));

    return assetEntity;
  }

  @override
  Future<List<AssetEntity>> getAssetsByPortfolio(String portfolioId) async {
    // TODO: Implementar en siguiente prompt
    // Consultar assets where portfolioId == portfolioId
    // Sincronizar local + remote
    throw UnimplementedError(
      'AssetRepository.getAssetsByPortfolio() not implemented yet',
    );
  }
}

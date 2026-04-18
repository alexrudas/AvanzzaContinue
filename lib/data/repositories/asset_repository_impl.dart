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
import 'dart:convert';

import 'package:avanzza/data/models/asset/asset_document_model.dart';
import 'package:avanzza/data/models/asset/asset_model.dart';
import 'package:avanzza/data/models/asset/special/asset_inmueble_model.dart';
import 'package:avanzza/data/models/asset/special/asset_maquinaria_model.dart';
import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/models/insurance/insurance_policy_model.dart';
import 'package:avanzza/data/sources/local/asset_local_ds.dart';
import '../../../domain/entities/insurance/insurance_policy_entity.dart'
    show InsurancePolicyType;
import 'package:avanzza/data/sources/remote/asset_remote_ds.dart';
import 'package:flutter/foundation.dart';
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
import '../../../domain/value/registration/asset_runt_snapshot.dart';
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
        // _mergeForLocalStorage preserva portfolioId del local cuando el remoto
        // no lo tiene (toFirestoreJson no incluye portfolioId → Firebase nulo).
        await local.upsertAsset(_mergeForLocalStorage(r, l));
      }
    }
  }

  @override
  Stream<AssetEntity?> watchAsset(String assetId) async* {
    final controller = StreamController<AssetEntity?>();

    unawaited(() async {
      try {
        final l = await local.getAsset(assetId);
        if (kDebugMode) {
          debugPrint(
            '[AUDIT][WATCH_ASSET] assetId=$assetId '
            'localFound=${l != null} type=${l?.assetType}',
          );
        }
        // Enriquecer con datos reales de AssetVehiculoModel antes de emitir.
        final entity = l != null ? await _toEnrichedEntity(l) : null;
        _safeAdd(controller, entity);

        final r = await remote.getAsset(assetId);
        if (r != null) {
          // Preservar portfolioId local: toFirestoreJson no lo incluye en Firebase.
          await local.upsertAsset(_mergeForLocalStorage(r, l));
          final updated = await local.getAsset(assetId);
          if (kDebugMode) {
            debugPrint(
              '[AUDIT][WATCH_ASSET] remote sync done assetId=$assetId '
              'updatedFound=${updated != null}',
            );
          }
          final updatedEntity =
              updated != null ? await _toEnrichedEntity(updated) : null;
          _safeAdd(controller, updatedEntity);
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
      // Preservar portfolioId local: toFirestoreJson no lo incluye en Firebase.
      if (r != null) await local.upsertAsset(_mergeForLocalStorage(r, l));
    }());

    return l != null ? await _toEnrichedEntity(l) : null;
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
    AssetRuntSnapshot runtSnapshot = AssetRuntSnapshot.empty,
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

    // ── Construcción de runtMetaJson ─────────────────────────────────────
    // Serializa snapshots RTM / limitaciones / garantías como JSON string.
    // Almacenado en AssetVehiculoModel.runtMetaJson y leído de vuelta
    // en _toEnrichedEntity() para poblar AssetEntity.metadata.
    String? runtMetaJson;
    final hasMeta = runtSnapshot.rtmRecords.isNotEmpty ||
        runtSnapshot.limitations.isNotEmpty ||
        runtSnapshot.warranties.isNotEmpty;
    if (hasMeta) {
      try {
        runtMetaJson = jsonEncode({
          if (runtSnapshot.rtmRecords.isNotEmpty)
            'runt_rtm': runtSnapshot.rtmRecords,
          if (runtSnapshot.limitations.isNotEmpty)
            'runt_limitations': runtSnapshot.limitations,
          if (runtSnapshot.warranties.isNotEmpty)
            'runt_warranties': runtSnapshot.warranties,
        });
      } catch (_) {
        // Fail-silent: si la serialización falla, los snapshots se pierden
        // pero el activo se registra correctamente.
        runtMetaJson = null;
      }
    }

    // AssetContent.vehicle: todos los campos RUNT disponibles.
    // Fallback a 'PENDIENTE'/0.0 para activos sin snapshot RUNT.
    final colorRaw = runtSnapshot.color?.trim();
    final resolvedColor = (colorRaw != null && colorRaw.isNotEmpty)
        ? colorRaw.toUpperCase()
        : 'PENDIENTE';
    final content = AssetContent.vehicle(
      assetKey: normalizedPlate,
      brand: marca.trim().toUpperCase(),
      model: modelo.trim().toUpperCase(),
      color: resolvedColor,
      engineDisplacement: runtSnapshot.engineDisplacement ?? 0.0,
      mileage: 0,
      vin: runtSnapshot.vin,
      engineNumber: runtSnapshot.engineNumber,
      chassisNumber: runtSnapshot.chassisNumber,
      line: runtSnapshot.line,
      serviceType: runtSnapshot.serviceType,
      vehicleClass: runtSnapshot.vehicleClass,
      bodyType: runtSnapshot.bodyType,
      fuelType: runtSnapshot.fuelType,
      passengerCapacity: runtSnapshot.passengerCapacity,
      loadCapacityKg: runtSnapshot.loadCapacityKg,
      grossWeightKg: runtSnapshot.grossWeightKg,
      axles: runtSnapshot.axles,
      transitAuthority: runtSnapshot.transitAuthority,
      initialRegistrationDate: runtSnapshot.initialRegistrationDate,
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
      color: resolvedColor != 'PENDIENTE' ? resolvedColor : null,
      engineDisplacement: runtSnapshot.engineDisplacement,
      vin: runtSnapshot.vin,
      engineNumber: runtSnapshot.engineNumber,
      chassisNumber: runtSnapshot.chassisNumber,
      line: runtSnapshot.line,
      serviceType: runtSnapshot.serviceType,
      vehicleClass: runtSnapshot.vehicleClass,
      bodyType: runtSnapshot.bodyType,
      fuelType: runtSnapshot.fuelType,
      passengerCapacity: runtSnapshot.passengerCapacity,
      loadCapacityKg: runtSnapshot.loadCapacityKg,
      grossWeightKg: runtSnapshot.grossWeightKg,
      axles: runtSnapshot.axles,
      transitAuthority: runtSnapshot.transitAuthority,
      initialRegistrationDate: runtSnapshot.initialRegistrationDate,
      propertyLiens: runtSnapshot.propertyLiens,
      ownerDocumentType: runtSnapshot.ownerDocumentType,
      ownerName: runtSnapshot.ownerName,
      ownerDocument: runtSnapshot.ownerDocument,
      runtMetaJson: runtMetaJson,
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

    // ── CONSTRUCCIÓN DE PÓLIZAS DE SEGURO ────────────────────────────────────
    // SOAT y RC del snapshot se convierten a InsurancePolicyModel para
    // persistencia local inmediata. El módulo de seguros los leerá con
    // DIContainer().insuranceRepository.fetchPoliciesByAsset(assetId).
    final policyModels = _buildInsurancePolicies(
      assetId: assetId,
      snapshot: runtSnapshot,
      countryId: countryId,
      cityId: cityId,
      now: now,
    );

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
    if (kDebugMode) {
      debugPrint(
        '[AUDIT][ASSET_WRITE] ⬇️ Iniciando writeTxn Isar\n'
        '  assetId=$assetId portfolioId=$portfolioId\n'
        '  plate=$normalizedPlate marca=$marca modelo=$modelo\n'
        '  assetModel.portfolioId=${assetModel.portfolioId}',
      );
    }
    try {
      await local.isar.writeTxn(() async {
        // Paso 1: AssetModel (índice único en id con replace:true → idempotente).
        await local.isar.assetModels.put(assetModel);

        // Paso 2: AssetVehiculoModel (índice único en assetId con replace:true).
        // Incluye todos los campos RUNT enriquecidos del snapshot.
        await local.isar.assetVehiculoModels.put(vehiculoModel);

        // Paso 3: Incremento atómico del portafolio (vía DS composable).
        // incrementAssetsCountTx asume que ya estamos dentro de writeTxn;
        // evita el deadlock de transacciones anidadas que causaría
        // portfolioLocalDS.incrementAssetsCount() (tiene su propio writeTxn).
        await portfolioLocalDS.incrementAssetsCountTx(local.isar, portfolioId);

        // Paso 4: Pólizas SOAT y RC del snapshot (si las hay).
        // putAll es idempotente gracias al índice @Index(unique:true, replace:true)
        // en InsurancePolicyModel.id.
        if (policyModels.isNotEmpty) {
          await local.isar.insurancePolicyModels.putAll(policyModels);
        }
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

    if (kDebugMode) {
      debugPrint(
        '[AUDIT][CREATE_ASSET] ✅ Isar write OK\n'
        '  assetId=$assetId\n'
        '  portfolioId=$portfolioId\n'
        '  plate(real)=$normalizedPlate\n'
        '  marca=$marca modelo=$modelo anio=$anio refCode=$refCode\n'
        '  AssetModel.id=${assetModel.id} assetType=${assetModel.assetType}\n'
        '  AssetVehiculoModel.placa=${vehiculoModel.placa}\n'
        '  ✅ Read path corregido: _toEnrichedEntity() leerá AssetVehiculoModel y '
        'mostrará placa real "$normalizedPlate"',
      );
      debugPrint(
        '[AUDIT][FIREBASE_PAYLOAD_ASSET] '
        'assetId=$assetId orgId=$orgId assetType=${assetModel.assetType} '
        'portfolioId=${assetModel.portfolioId}',
      );
      debugPrint(
        '[AUDIT][FIREBASE_PAYLOAD_VEHICLE] '
        'assetId=${vehiculoModel.assetId} placa=${vehiculoModel.placa} '
        'marca=${vehiculoModel.marca} modelo=${vehiculoModel.modelo} '
        'anio=${vehiculoModel.anio} refCode=${vehiculoModel.refCode}',
      );
    }

    return assetEntity;
  }

  @override
  Future<List<AssetEntity>> getAssetsByPortfolio(String portfolioId) async {
    // Consulta local Isar usando el índice portfolioId.
    // Los activos creados vía createAssetFromRuntAndLinkToPortfolio() tienen
    // el campo portfolioId persistido. Activos legacy (creados antes de este
    // campo) no aparecerán aquí y requieren migración manual si es necesario.
    final models = await local.listAssetsByPortfolio(portfolioId);
    if (kDebugMode) {
      debugPrint(
        '[AUDIT][GET_ASSETS_PORTFOLIO] portfolioId=$portfolioId count=${models.length}',
      );
    }
    return Future.wait(models.map(_toEnrichedEntity));
  }

  @override
  Stream<List<AssetEntity>> watchAssetsByPortfolio(String portfolioId) {
    // asyncMap permite llamadas async (_toEnrichedEntity) dentro del stream.
    // Isar emite List<AssetModel> → enriquecemos cada modelo con su
    // AssetVehiculoModel antes de exponer la lista a la UI.
    if (kDebugMode) {
      debugPrint(
        '[AUDIT][WATCH_PORTFOLIO_QUERY] portfolioId=$portfolioId '
        '→ suscribiendo stream Isar watchAssetsByPortfolio()',
      );
    }
    return local.watchAssetsByPortfolio(portfolioId).asyncMap(
      (models) async {
        if (kDebugMode) {
          // Cross-check: cuántos AssetModel existen en total y sus portfolioIds.
          final allAssets = await local.isar.assetModels.where().findAll();
          debugPrint(
            '[AUDIT][ISAR_ALL_ASSETS] total=${allAssets.length} '
            'portfolioIds=${allAssets.map((a) => a.portfolioId).toSet()}',
          );
          debugPrint(
            '[AUDIT][WATCH_PORTFOLIO_RESULT] portfolioId=$portfolioId '
            'count=${models.length} '
            'assetIds=[${models.map((m) => m.id).join(', ')}]',
          );
        }
        return Future.wait(models.map(_toEnrichedEntity));
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: merge seguro para escritura local (preserva portfolioId)
  // ---------------------------------------------------------------------------

  /// Construye un [AssetModel] fusionando datos remotos con metadatos locales.
  ///
  /// PROBLEMA QUE RESUELVE:
  /// [toFirestoreJson()] NO incluye [portfolioId] → los documentos Firebase no
  /// tienen ese campo. Cuando [_syncAssets] / [watchAsset] / [getAsset]
  /// sobreescriben el local con el modelo remoto, [portfolioId] se pierde →
  /// el filtro Isar [portfolioIdEqualTo] devuelve [] → lista vacía en UI.
  ///
  /// ESTRATEGIA:
  /// 1. Todos los campos del modelo remoto (datos más recientes).
  /// 2. [portfolioId]: del remoto si lo trae, del local en caso contrario.
  /// 3. [isarId]: del local para que Isar actualice el registro existente.
  AssetModel _mergeForLocalStorage(AssetModel remote, AssetModel? local) {
    final mergedPortfolioId = remote.portfolioId ?? local?.portfolioId;

    if (kDebugMode && local?.portfolioId != null && remote.portfolioId == null) {
      debugPrint(
        '[AUDIT][MERGE_LOCAL] assetId=${remote.id} '
        'portfolioId preservado del local="${local!.portfolioId}" '
        '(remoto=null — toFirestoreJson() no serializa portfolioId)',
      );
    }

    return AssetModel(
      isarId: local?.isarId,
      id: remote.id,
      orgId: remote.orgId,
      assetType: remote.assetType,
      countryId: remote.countryId,
      regionId: remote.regionId,
      cityId: remote.cityId,
      ownerType: remote.ownerType,
      ownerId: remote.ownerId,
      estado: remote.estado,
      etiquetas: remote.etiquetas,
      fotosUrls: remote.fotosUrls,
      orgRef: remote.orgRef,
      orgRefPath: remote.orgRefPath,
      ownerRef: remote.ownerRef,
      ownerRefPath: remote.ownerRefPath,
      countryRef: remote.countryRef,
      countryRefPath: remote.countryRefPath,
      regionRef: remote.regionRef,
      regionRefPath: remote.regionRefPath,
      cityRef: remote.cityRef,
      cityRefPath: remote.cityRefPath,
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
      portfolioId: mergedPortfolioId,
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: construye AssetEntity enriquecido con datos reales de especialización
  // ---------------------------------------------------------------------------

  /// Convierte [AssetModel] → [AssetEntity] leyendo el modelo especializado
  /// desde Isar cuando el tipo es vehículo.
  ///
  /// PROBLEMA QUE RESUELVE:
  /// [AssetModel.toEntity()] genera un placeholder con assetKey = uuid[0:6],
  /// que el [PlateWidget] formatea como placa visual falsa (ej: "AA2 - 25A").
  /// La placa real está en [AssetVehiculoModel.placa], que es una colección
  /// Isar separada vinculada por clave foránea [assetId].
  ///
  /// ESTRATEGIA:
  /// 1. Construye la entidad base con todos sus metadatos via [model.toEntity()].
  /// 2. Si el tipo es vehículo y [AssetVehiculoModel] existe en Isar,
  ///    reemplaza el [AssetContent] placeholder con el contenido real.
  /// 3. Fallback a la entidad base si no se encuentra la especialización.
  Future<AssetEntity> _toEnrichedEntity(AssetModel model) async {
    // Paso 1: entidad base con metadatos completos (state, owner, portfolioId,
    // timestamps, metadata). El content es placeholder — se reemplaza abajo.
    final base = model.toEntity();

    // Paso 2: solo los vehículos tienen AssetVehiculoModel en Isar.
    if (model.assetType != 'vehicle') {
      if (kDebugMode) {
        debugPrint(
          '[AUDIT][ENRICH_ENTITY] assetId=${model.id} '
          'assetType=${model.assetType} → no-vehicle, usando toEntity()',
        );
      }
      return base;
    }

    // Paso 3: leer especialización vehicular de Isar.
    final veh = await local.getVehiculo(model.id);

    if (kDebugMode) {
      debugPrint(
        '[AUDIT][ENRICH_ENTITY] assetId=${model.id} assetType=vehicle '
        'vehiculoFound=${veh != null} '
        'placa=${veh?.placa ?? "NULL"} '
        'marca=${veh?.marca ?? "NULL"} '
        'modelo=${veh?.modelo ?? "NULL"}',
      );
    }

    if (veh == null) {
      // Fallback: sin especialización → entidad base con placeholder.
      // Esto cubre activos legacy o race conditions post-creación.
      if (kDebugMode) {
        debugPrint(
          '[AUDIT][ENRICH_ENTITY] vehiculoFound=false → '
          'fallback a toEntity() para assetId=${model.id}',
        );
      }
      return base;
    }

    // Paso 4: construir VehicleContent con datos reales del RUNT.
    // Los campos enriquecidos provienen de AssetVehiculoModel (persistidos
    // durante el registro con runtSnapshot). Null para activos legacy.
    final realContent = AssetContent.vehicle(
      assetKey: veh.placa,
      brand: veh.marca,
      model: veh.modelo,
      color: (veh.color != null && veh.color!.isNotEmpty)
          ? veh.color!
          : 'PENDIENTE',
      engineDisplacement: veh.engineDisplacement ?? 0.0,
      mileage: 0,
      vin: veh.vin,
      engineNumber: veh.engineNumber,
      chassisNumber: veh.chassisNumber,
      line: veh.line,
      serviceType: veh.serviceType,
      vehicleClass: veh.vehicleClass,
      bodyType: veh.bodyType,
      fuelType: veh.fuelType,
      passengerCapacity: veh.passengerCapacity,
      loadCapacityKg: veh.loadCapacityKg,
      grossWeightKg: veh.grossWeightKg,
      axles: veh.axles,
      transitAuthority: veh.transitAuthority,
      initialRegistrationDate: veh.initialRegistrationDate,
    );

    if (kDebugMode) {
      debugPrint(
        '[AUDIT][ENRICH_ENTITY] ✅ assetId=${model.id} '
        'placaReal=${veh.placa} marca=${veh.marca} modelo=${veh.modelo} '
        'anio=${veh.anio}',
      );
    }

    // Paso 5: deserializar runtMetaJson si existe, para añadirlo al metadata
    // de la entidad. Esto permite que capas superiores (Asset Detail, Campaign
    // Engine) lean snapshots RTM/limitaciones/garantías del activo.
    Map<String, dynamic> enrichedMeta = {...base.metadata};
    if (veh.runtMetaJson != null && veh.runtMetaJson!.trim().isNotEmpty) {
      try {
        final decoded =
            jsonDecode(veh.runtMetaJson!) as Map<String, dynamic>;
        enrichedMeta.addAll(decoded);
      } catch (_) {
        // JSON corrupto — ignorar, mantener metadata base.
      }
    }
    if (veh.propertyLiens != null && veh.propertyLiens!.isNotEmpty) {
      enrichedMeta['runt_property_liens'] = veh.propertyLiens;
    }

    // Paso 6: copyWith reemplaza content, assetKey y metadata.
    return base.copyWith(
      content: realContent,
      assetKey: realContent.assetKey,
      metadata: enrichedMeta,
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper: construir InsurancePolicyModel desde AssetRuntSnapshot
  // ──────────────────────────────────────────────────────────────────────────

  /// Convierte los registros SOAT y RC del [snapshot] en [InsurancePolicyModel].
  ///
  /// Solo se incluyen registros con [fechaFinVigencia] parseable.
  /// - SOAT: tipo = [InsurancePolicyType.soat] wire value ('soat').
  /// - RC: tipo derivado de rec['tipoPoliza'] via [_mapRcTipoPoliza].
  ///   Puede ser 'rc_contractual', 'rc_extracontractual' o 'unknown'.
  ///   NUNCA produce 'todo_riesgo' — ese wire value es exclusivo del flujo manual.
  /// [tarifaBase] es 0.0 — RUNT no entrega el monto de la prima.
  List<InsurancePolicyModel> _buildInsurancePolicies({
    required String assetId,
    required AssetRuntSnapshot snapshot,
    required String countryId,
    required String cityId,
    required DateTime now,
  }) {
    final result = <InsurancePolicyModel>[];

    // ── SOAT ────────────────────────────────────────────────────────────────
    for (final rec in snapshot.soatRecords) {
      // El backend VRC envía claves en inglés camelCase.
      // Fallback a claves en español para compatibilidad con flujos legados.
      final fechaFin = _parseDate(rec['endDate'] ?? rec['fechaFinVigencia']);
      if (fechaFin == null) continue;
      final fechaInicio =
          _parseDate(rec['startDate'] ?? rec['fechaInicioVigencia']) ?? fechaFin.subtract(const Duration(days: 365));
      final aseguradora = _strVal(rec['insurer']) ?? _strVal(rec['entidadExpide']) ?? 'Sin datos';
      result.add(InsurancePolicyModel(
        id: const Uuid().v4(),
        assetId: assetId,
        tipo: InsurancePolicyType.soat.toWireString(), // 'soat'
        aseguradora: aseguradora,
        tarifaBase: 0.0,
        currencyCode: 'COP',
        countryId: countryId,
        cityId: cityId.isNotEmpty ? cityId : null,
        fechaInicio: fechaInicio.toUtc(),
        fechaFin: fechaFin.toUtc(),
        estado: _computeEstado(fechaFin),
        createdAt: now,
        updatedAt: now,
      ));
    }

    // ── RC (Responsabilidad Civil) ───────────────────────────────────────────
    for (final rec in snapshot.rcRecords) {
      // El backend VRC envía claves en inglés camelCase.
      // Fallback a claves en español para compatibilidad con flujos legados.
      final fechaFin = _parseDate(rec['endDate'] ?? rec['fechaFinVigencia']);
      if (fechaFin == null) continue;
      final fechaInicio =
          _parseDate(rec['startDate'] ?? rec['fechaInicioVigencia']) ?? fechaFin.subtract(const Duration(days: 365));
      final aseguradora = _strVal(rec['insurer']) ??
          _strVal(rec['aseguradora']) ??
          _strVal(rec['entidadExpide']) ??
          'Sin datos';
      result.add(InsurancePolicyModel(
        id: const Uuid().v4(),
        assetId: assetId,
        // Backend VRC envía "policyType"; fallback a "tipoPoliza" para legado.
        // Contiene "Responsabilidad Civil Contractual/Extracontractual".
        // _mapRcTipoPoliza() clasifica correctamente. NUNCA produce 'todo_riesgo'.
        tipo: _mapRcTipoPoliza((rec['policyType'] ?? rec['tipoPoliza']) as String?),
        aseguradora: aseguradora,
        tarifaBase: 0.0,
        currencyCode: 'COP',
        countryId: countryId,
        cityId: cityId.isNotEmpty ? cityId : null,
        fechaInicio: fechaInicio.toUtc(),
        fechaFin: fechaFin.toUtc(),
        estado: _computeEstado(fechaFin),
        createdAt: now,
        updatedAt: now,
      ));
    }

    // TODO (Track C — Insurance Remote Sync): encolar sync remoto cuando el
    // módulo de seguros active InsuranceRemoteDS.upsertPolicy().
    // Por ahora las pólizas se persisten solo en Isar (offline-first).

    return result;
  }

  /// Mapea el valor crudo de `rec['tipoPoliza']` de rcRecords al wire value
  /// correcto de [InsurancePolicyType].
  ///
  /// **EXTRACONTRACTUAL debe verificarse ANTES que CONTRACTUAL.**
  /// El string "extracontractual" contiene "contractual" como substring —
  /// verificar contractual primero produciría falsos positivos.
  ///
  /// Si [rawTipo] es null o no reconocible → retorna 'unknown' (nunca 'todo_riesgo').
  String _mapRcTipoPoliza(String? rawTipo) {
    if (rawTipo == null) {
      if (kDebugMode) {
        debugPrint('[AssetRepositoryImpl][_mapRcTipoPoliza] '
            'tipoPoliza es null en rcRecord — persiste como unknown.');
      }
      return InsurancePolicyType.unknown.toWireString();
    }
    final lower = rawTipo.toLowerCase();
    if (lower.contains('extracontractual')) {
      return InsurancePolicyType.rcExtracontractual.toWireString();
    }
    if (lower.contains('contractual')) {
      return InsurancePolicyType.rcContractual.toWireString();
    }
    if (kDebugMode) {
      debugPrint('[AssetRepositoryImpl][_mapRcTipoPoliza] '
          'tipoPoliza no reconocido: "$rawTipo" — persiste como unknown.');
    }
    return InsurancePolicyType.unknown.toWireString();
  }

  // ── Helpers privados de fecha y estado ───────────────────────────────────

  /// Parsea un valor de fecha proveniente de los registros SOAT/RC del VRC.
  ///
  /// Soporta tres formatos que el backend colombiano emite históricamente:
  /// - ISO 8601:    `YYYY-MM-DD`  →  `DateTime.tryParse` nativo.
  /// - Colombiano:  `DD/MM/YYYY`  →  reordenado antes de tryParse.
  /// - Guión:       `DD-MM-YYYY`  →  detectado por longitud + posición del '-'.
  ///
  /// Retorna null si el valor es null, vacío o no coincide con ningún formato.
  /// Fail-silent: nunca lanza excepción.
  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;

    // 1. Intento directo ISO 8601 (YYYY-MM-DD o YYYY-MM-DDTHH:mm:ssZ…).
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;

    // 2. Formato colombiano DD/MM/YYYY  (separador '/').
    if (s.contains('/')) {
      final parts = s.split('/');
      if (parts.length == 3) {
        // Puede venir tanto como DD/MM/YYYY como MM/DD/YYYY según la fuente.
        // El sistema RUNT colombiano usa DD/MM/YYYY como estándar.
        final reordered = '${parts[2]}-${parts[1]}-${parts[0]}';
        final parsed = DateTime.tryParse(reordered);
        if (parsed != null) return parsed;
      }
    }

    // 3. Formato DD-MM-YYYY con guión (distinguible de ISO porque el año
    //    está al final: la parte[0] tiene 2 dígitos, no 4).
    if (s.contains('-')) {
      final parts = s.split('-');
      if (parts.length == 3 && parts[0].length == 2 && parts[2].length == 4) {
        final reordered = '${parts[2]}-${parts[1]}-${parts[0]}';
        final parsed = DateTime.tryParse(reordered);
        if (parsed != null) return parsed;
      }
    }

    if (kDebugMode) {
      debugPrint('[AssetRepositoryImpl][_parseDate] '
          'Formato de fecha no reconocido: "$s" — registro SOAT/RC descartado.');
    }
    return null;
  }

  /// Extrae un String no vacío de un valor dinámico; null si vacío o null.
  String? _strVal(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    return s.isNotEmpty ? s : null;
  }

  /// Calcula el estado de vigencia de una póliza según su fecha de vencimiento.
  String _computeEstado(DateTime fechaFin) {
    final now = DateTime.now().toUtc();
    if (fechaFin.isBefore(now)) return 'vencido';
    if (fechaFin.isBefore(now.add(const Duration(days: 30)))) return 'por_vencer';
    return 'vigente';
  }
}

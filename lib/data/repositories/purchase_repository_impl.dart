// ============================================================================
// lib/data/repositories/purchase_repository_impl.dart
// PURCHASE REPOSITORY IMPL — Core API + Isar cache
// ============================================================================
// QUÉ HACE:
//   - Implementa PurchaseRepository consumiendo Core API como única fuente
//     remota. Isar queda como cache local (read path).
//   - Create path canónico: createRequest(CreatePurchaseRequestInput)
//     construye el payload alineado al ADR actor-canon fase 2. Envía
//     vendorActorRefs[] cuando el input los trae; si el input usa legacy
//     vendorContactIds, los reenvía como legacy para compat durante fase 1
//     de transición.
//
// QUÉ NO HACE:
//   - NO escribe a Firestore. No usa `syncService.enqueue`.
//   - NO esconde campos estructurados en `notes`.
//   - NO crea flows manualmente: el backend crea CoordinationFlow atómicamente
//     en el POST.
//
// TENANT SAFETY:
//   - orgId y requestedBy NO se envían en body; los deriva el backend del JWT.
//   - ActorRef.local.localId son IDs de LocalContact/LocalOrganization del
//     workspace activo.
//
// See docs/adr/0001-actor-canon.md (regla 2.13 — transición vendorContactIds).
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../application/core_common/actor_canon_telemetry.dart';
import '../../domain/entities/purchase/award_entity.dart';
import '../../domain/entities/purchase/create_purchase_request_input.dart';
import '../../domain/entities/purchase/purchase_document_entities.dart';
import '../../domain/entities/purchase/purchase_request_detail_entity.dart';
import '../../domain/entities/purchase/purchase_request_entity.dart';
import '../../domain/entities/purchase/purchase_request_summary_entity.dart';
import '../../domain/entities/purchase/quote_with_items_entity.dart';
import '../../domain/entities/purchase/supplier_response_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../models/purchase/purchase_request_model.dart';
import '../sources/local/purchase_local_ds.dart';
import '../sources/remote/core_common/nestjs_exceptions.dart';
import '../sources/remote/purchase/purchase_api_client.dart';
import '../sources/remote/purchase/purchase_api_mapper.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource local;
  final PurchaseApiClient remote;

  /// Emisor de eventos del canon ActorRef. Default: [DebugPrintActorCanonTelemetry]
  /// — guardrail operativo local provisional (ver ADR §8.3 para límites).
  final ActorCanonTelemetry telemetry;

  PurchaseRepositoryImpl({
    required this.local,
    required this.remote,
    this.telemetry = kDefaultActorCanonTelemetry,
  });

  // ───────────────────────────────────────────────────────────────────────────
  // CREATE
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> createRequest(CreatePurchaseRequestInput input) async {
    // Invariante blindada: al menos una variante de destinatarios no vacía.
    final hasActorRefs =
        input.vendorActorRefs != null && input.vendorActorRefs!.isNotEmpty;
    final hasLegacy =
        input.vendorContactIds != null && input.vendorContactIds!.isNotEmpty;
    if (!hasActorRefs && !hasLegacy) {
      throw ArgumentError(
        'createRequest: vendorActorRefs y vendorContactIds ambos vacíos.',
      );
    }
    if (input.items.isEmpty) {
      throw ArgumentError(
        'items vacío: el backend exige al menos 1 ítem.',
      );
    }

    // Componer fragmentos comunes del body una sola vez para no duplicar.
    final deliveryWire = input.delivery == null
        ? null
        : CreatePurchaseRequestDelivery(
            department: input.delivery!.department,
            city: input.delivery!.city,
            address: input.delivery!.address,
            info: input.delivery!.info,
          );
    final itemsWire = input.items
        .map((i) => CreatePurchaseRequestItem(
              description: i.description,
              quantity: i.quantity,
              unit: i.unit,
              notes: i.notes,
            ))
        .toList(growable: false);

    // Rama canónica (ADR actor-canon) vs rama legacy. Mutuamente excluyentes
    // por construcción del DTO wire.
    final body = hasActorRefs
        ? CreatePurchaseRequestBody.withActorRefs(
            title: input.title,
            type: input.type.wireName,
            category: input.category,
            originType: input.originType.wireName,
            assetId: input.assetId,
            notes: input.notes,
            delivery: deliveryWire,
            items: itemsWire,
            vendorActorRefs: List.unmodifiable(input.vendorActorRefs!),
            attestSelf: input.attestSelf,
          )
        : CreatePurchaseRequestBody.withLegacyContactIds(
            title: input.title,
            type: input.type.wireName,
            category: input.category,
            originType: input.originType.wireName,
            assetId: input.assetId,
            notes: input.notes,
            delivery: deliveryWire,
            items: itemsWire,
            vendorContactIds: List<String>.unmodifiable(input.vendorContactIds!),
          );

    // ADR actor-canon §8 + §8.2 observabilidad:
    // Si el backend rechaza un ActorRef.local sin attestation (409
    // ACTOR_REF_UNKNOWN), reportar vía [telemetry]. El sink decide dónde
    // va (hoy: debugPrint provisional; mañana: sink enterprise).
    // NO hay retry automático ni fallback a attestSelf=true: el ADR dice que
    // attestSelf es excepción acotada, no mecanismo de recuperación.
    final StartPurchaseRequestResponse response;
    try {
      response = await remote.createPurchaseRequest(body);
    } on BadRequestException catch (e) {
      if (e.code == 'ACTOR_REF_UNKNOWN') {
        telemetry.actorRefUnknownDetected(
          statusCode: e.statusCode,
          callerHint: 'PurchaseRepositoryImpl.createRequest',
          refs: body.vendorActorRefs ?? const [],
          attestSelf: body.attestSelf ?? false,
          message: e.message,
        );
      }
      rethrow;
    }

    // Hidratar cache local con el PR canónico devuelto por el backend
    // (usa el id server-side, no uno inventado por el cliente).
    final mapped = PurchaseApiMapper.modelFromServerJson(response.request);

    // Estampamos el snapshot VehicleSpec local-only encima del modelo mapeado.
    // El backend canónico no conoce aún ese bloque → el mapper trae todos los
    // campos vehicleSpec* como null. Sin este merge, la cache quedaría sin
    // snapshot apenas se reconstruya desde backend.
    final model = _stampVehicleSpec(mapped, input.vehicleSpec);
    await local.upsertRequest(model);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LOCAL-ONLY SNAPSHOT PROTECTION
  // ───────────────────────────────────────────────────────────────────────────

  /// Copia un [PurchaseRequestModel] preservando todos sus campos y sustituyendo
  /// únicamente los slots de VehicleSpec por el snapshot provisto.
  ///
  /// Si [snapshot] es null, el modelo sale SIN snapshot (útil cuando un PR
  /// genuinamente no tiene target VehicleSpec).
  PurchaseRequestModel _stampVehicleSpec(
    PurchaseRequestModel base,
    VehicleSpecSnapshotInput? snapshot,
  ) {
    return PurchaseRequestModel(
      id: base.id,
      orgId: base.orgId,
      title: base.title,
      typeWire: base.typeWire,
      category: base.category,
      originTypeWire: base.originTypeWire,
      assetId: base.assetId,
      notes: base.notes,
      deliveryCity: base.deliveryCity,
      deliveryDepartment: base.deliveryDepartment,
      deliveryAddress: base.deliveryAddress,
      deliveryInfo: base.deliveryInfo,
      itemsCount: base.itemsCount,
      status: base.status,
      respuestasCount: base.respuestasCount,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      vehicleSpecId: snapshot?.vehicleSpecId,
      vehicleSpecLabel: snapshot?.displayLabel,
      vehicleSpecMake: snapshot?.make,
      vehicleSpecModel: snapshot?.model,
      vehicleSpecYear: snapshot?.year,
      vehicleSpecVersion: snapshot?.version,
      vehicleSpecMotorization: snapshot?.motorization,
      vehicleSpecEngineCc: snapshot?.engineDisplacementCc,
      vehicleSpecTransmission: snapshot?.transmission,
      vehicleSpecLinkedAssetsCount: snapshot?.linkedAssetsCountSnapshot,
    );
  }

  /// Preserva los campos VehicleSpec del row local al sobrescribir con datos
  /// remotos. El backend canónico aún no envía ese bloque, por lo que el
  /// [remote] mapeado llega con todos los slots en null; si el [existing]
  /// local los tenía poblados, se conservan — sin este merge, cualquier
  /// refresh/sync (status → responded, etc.) vaciaría el snapshot.
  ///
  /// Contrato: se respeta la fuente remota para todo lo demás.
  ///
  /// `@visibleForTesting`: blinda el invariante contra regresiones; el test
  /// debe poder fallar si alguien vacía el snapshot por accidente.
  @visibleForTesting
  PurchaseRequestModel mergeLocalSnapshotInto(
    PurchaseRequestModel remote,
    PurchaseRequestModel existing,
  ) =>
      _mergeLocalSnapshotInto(remote, existing);

  PurchaseRequestModel _mergeLocalSnapshotInto(
    PurchaseRequestModel remote,
    PurchaseRequestModel existing,
  ) {
    final remoteHasSpec = remote.vehicleSpecId != null;
    if (remoteHasSpec) {
      // Cuando el backend empiece a enviar VehicleSpec, este branch toma lo
      // que diga el servidor sin tocarlo: el merge queda automáticamente
      // neutralizado sin cambios de código.
      return remote;
    }
    if (existing.vehicleSpecId == null) {
      // El row local tampoco tenía snapshot → nada que proteger.
      return remote;
    }
    return PurchaseRequestModel(
      id: remote.id,
      orgId: remote.orgId,
      title: remote.title,
      typeWire: remote.typeWire,
      category: remote.category,
      originTypeWire: remote.originTypeWire,
      assetId: remote.assetId,
      notes: remote.notes,
      deliveryCity: remote.deliveryCity,
      deliveryDepartment: remote.deliveryDepartment,
      deliveryAddress: remote.deliveryAddress,
      deliveryInfo: remote.deliveryInfo,
      itemsCount: remote.itemsCount,
      status: remote.status,
      respuestasCount: remote.respuestasCount,
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
      vehicleSpecId: existing.vehicleSpecId,
      vehicleSpecLabel: existing.vehicleSpecLabel,
      vehicleSpecMake: existing.vehicleSpecMake,
      vehicleSpecModel: existing.vehicleSpecModel,
      vehicleSpecYear: existing.vehicleSpecYear,
      vehicleSpecVersion: existing.vehicleSpecVersion,
      vehicleSpecMotorization: existing.vehicleSpecMotorization,
      vehicleSpecEngineCc: existing.vehicleSpecEngineCc,
      vehicleSpecTransmission: existing.vehicleSpecTransmission,
      vehicleSpecLinkedAssetsCount: existing.vehicleSpecLinkedAssetsCount,
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // READS
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Stream<List<PurchaseRequestEntity>> watchRequestsByOrg(
    String orgId, {
    String? assetId,
  }) {
    _backgroundRefresh();
    return local.watchRequestsByOrg(orgId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<List<PurchaseRequestEntity>> fetchRequestsByOrg(
    String orgId, {
    String? assetId,
  }) async {
    // Local-first: leer Isar primero, refrescar contra Core API en background.
    // El patrón anterior (await _refreshFromApi antes del read) bloqueaba el
    // Home cuando la API estaba lenta o inalcanzable — caso reportado en el
    // que el splash navegaba en <500ms pero el spinner del tab Home se
    // mantenía decenas de segundos esperando esta llamada.
    final locals = await local.requestsByOrg(orgId, assetId: assetId);
    unawaited(() async {
      try {
        await _refreshFromApi();
      } catch (e) {
        debugPrint('[PurchaseRepo] fetchRequestsByOrg refresh fail: $e');
      }
    }());
    return locals.map((m) => m.toEntity()).toList();
  }

  void _backgroundRefresh() {
    unawaited(Future(() async {
      try {
        await _refreshFromApi();
      } catch (e) {
        debugPrint('[PurchaseRepo] background refresh fail: $e');
      }
    }));
  }

  /// Descarga la lista canónica desde Core API y refresca Isar por diff.
  /// La tenancy viene del JWT, por lo que esta lista ya está filtrada al
  /// workspace activo — no es necesario pasar orgId al HTTP.
  Future<void> _refreshFromApi() async {
    final page = await remote.listPurchaseRequests(limit: 100);
    if (page.items.isEmpty) return;

    // 1) Mapear remotos una sola vez.
    final remoteModels = page.items
        .map(PurchaseApiMapper.modelFromServerJson)
        .toList(growable: false);

    // 2) Pre-indexar locales por id ANTES del loop.
    //    La API filtra por JWT tenancy → en la práctica todos los items
    //    comparten orgId. Aun así, agrupamos por orgId por defensa y
    //    hacemos 1 query por orgId, no 1 por item. Esto convierte el costo
    //    de O(N·M) (N items × M locales) a O(N + M) con ≤ 1 query/org.
    final orgIds = {for (final m in remoteModels) m.orgId};
    final existingById = <String, PurchaseRequestModel>{};
    for (final orgId in orgIds) {
      final rows = await local.requestsByOrg(orgId);
      for (final r in rows) {
        existingById[r.id] = r;
      }
    }

    // 3) Diff por updatedAt + merge del snapshot local si aplica.
    for (final remoteModel in remoteModels) {
      final localRow = existingById[remoteModel.id];
      final lTime = localRow?.updatedAt;
      final rTime = remoteModel.updatedAt;
      final shouldWrite = localRow == null ||
          (rTime != null && (lTime == null || rTime.isAfter(lTime)));
      if (!shouldWrite) continue;

      // Preserva el snapshot VehicleSpec local si el remoto no lo trae.
      // Sin este merge, un status change en backend (sent → responded)
      // sobrescribiría el row con vehicleSpec* = null.
      final toWrite = localRow == null
          ? remoteModel
          : _mergeLocalSnapshotInto(remoteModel, localRow);
      await local.upsertRequest(toWrite);
    }
  }

  @override
  Stream<PurchaseRequestEntity?> watchRequest(String id) async* {
    // Solo cache local: sin caller vivo en UI para esta firma todavía.
    final all = await local.requestsByOrg('');
    final match = all.where((e) => e.id == id).toList();
    yield match.isEmpty ? null : match.first.toEntity();
  }

  @override
  Future<PurchaseRequestEntity?> getRequest(String id) async {
    final all = await local.requestsByOrg('');
    final match = all.where((e) => e.id == id).toList();
    return match.isEmpty ? null : match.first.toEntity();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SUPPLIER RESPONSES
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Stream<List<SupplierResponseEntity>> watchResponsesByRequest(
    String requestId,
  ) async* {
    final locals = await local.responsesByRequest(requestId);
    yield locals.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<SupplierResponseEntity>> fetchResponsesByRequest(
    String requestId,
  ) async {
    try {
      final quotes = await remote.fetchComparison(requestId);
      for (final quoteJson in quotes) {
        final model =
            PurchaseApiMapper.supplierResponseModelFromQuoteJson(quoteJson);
        await local.upsertSupplierResponse(model);
      }
    } catch (e) {
      debugPrint('[PurchaseRepo] fetchResponsesByRequest remote fail: $e');
    }
    final locals = await local.responsesByRequest(requestId);
    return locals.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> upsertSupplierResponse(SupplierResponseEntity response) async {
    // DEPRECADO por contrato. El flujo canónico es [submitQuote]: toma el
    // detalle por ítem que el SupplierResponseEntity plano no modela. Si
    // alguna UI antigua toca este método, debe migrarse a submitQuote.
    throw UnimplementedError(
      'upsertSupplierResponse: flujo canónico es submitQuote '
      '(POST /v1/purchase-requests/:id/quotes).',
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // DETAIL + SUMMARY
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<PurchaseRequestDetailEntity> fetchRequestDetail(String id) async {
    final raw = await remote.fetchPurchaseRequest(id);
    return PurchaseRequestDetailEntity.fromJson(raw);
  }

  @override
  Future<PurchaseRequestSummaryEntity> fetchSummary(String id) async {
    final raw = await remote.fetchSummary(id);
    return PurchaseRequestSummaryEntity.fromJson(raw);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // COMPARISON (read completo con items)
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<List<QuoteWithItemsEntity>> fetchComparison(String requestId) async {
    final quotesJson = await remote.fetchComparison(requestId);
    return quotesJson
        .map((q) => QuoteWithItemsEntity.fromJson(q))
        .toList(growable: false);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SUBMIT QUOTE (admin-captura)
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<QuoteWithItemsEntity> submitQuote({
    required String requestId,
    required String vendorContactId,
    required List<SubmitQuoteItemInput> items,
    DateTime? validUntil,
    String? currency,
    String? notes,
  }) async {
    assert(vendorContactId.isNotEmpty, 'vendorContactId requerido');
    if (items.isEmpty) {
      throw ArgumentError('submitQuote: items no puede ser vacío');
    }
    final raw = await remote.submitQuote(
      requestId: requestId,
      vendorContactId: vendorContactId,
      items: items.map((i) => i.toJson()).toList(growable: false),
      validUntil: validUntil,
      currency: currency,
      notes: notes,
    );
    return QuoteWithItemsEntity.fromJson(raw);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // AWARD
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<AwardEntity> createAward({
    required String requestId,
    required List<CreateAwardLineInput> lines,
    String? notes,
  }) async {
    if (lines.isEmpty) {
      throw ArgumentError('createAward: lines no puede ser vacío');
    }
    final raw = await remote.createAward(
      requestId: requestId,
      lines: lines.map((l) => l.toJson()).toList(growable: false),
      notes: notes,
    );
    return AwardEntity.fromJson(raw);
  }

  @override
  Future<AwardEntity?> fetchAward(String requestId) async {
    final raw = await remote.fetchAward(requestId);
    if (raw == null) return null;
    return AwardEntity.fromJson(raw);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // DOCUMENT GENERATION
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<GenerateDocumentsResultEntity> generateDocuments(String awardId) async {
    final raw = await remote.generateDocuments(awardId);
    return GenerateDocumentsResultEntity.fromJson(raw);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // CLOSE
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> closePurchaseRequest(String requestId) async {
    // Refresca cache local con el PR cerrado (status=closed) para que
    // listados y detalles reflejen el estado sin otro round-trip.
    final raw = await remote.closePurchaseRequest(requestId);
    final model = PurchaseApiMapper.modelFromServerJson(raw);
    await local.upsertRequest(model);
  }
}

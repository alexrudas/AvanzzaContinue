// ============================================================================
// lib/data/repositories/purchase_repository_impl.dart
// PURCHASE REPOSITORY IMPL — Core API + Isar cache
// ============================================================================
// QUÉ HACE:
//   - Implementa PurchaseRepository consumiendo Core API como única fuente
//     remota. Isar queda como cache local (read path).
//   - Create path canónico: createRequest(CreatePurchaseRequestInput)
//     construye el payload alineado al contrato backend vigente (title, type,
//     category, originType, assetId, notes, delivery, items[], vendorContactIds).
//
// QUÉ NO HACE:
//   - NO escribe a Firestore. No usa `syncService.enqueue`.
//   - NO esconde campos estructurados en `notes` (el backend ya los acepta
//     canónicamente; el patrón legacy `notesWithCity` fue eliminado).
//   - NO crea flows manualmente: el backend crea CoordinationFlow atómicamente
//     en el POST.
//
// TENANT SAFETY:
//   - orgId y requestedBy NO se envían en body; los deriva el backend del JWT.
//   - vendorContactIds provienen de contactos del workspace activo.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/purchase/create_purchase_request_input.dart';
import '../../domain/entities/purchase/purchase_request_entity.dart';
import '../../domain/entities/purchase/supplier_response_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../sources/local/purchase_local_ds.dart';
import '../sources/remote/purchase/purchase_api_client.dart';
import '../sources/remote/purchase/purchase_api_mapper.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource local;
  final PurchaseApiClient remote;

  PurchaseRepositoryImpl({required this.local, required this.remote});

  // ───────────────────────────────────────────────────────────────────────────
  // CREATE
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> createRequest(CreatePurchaseRequestInput input) async {
    // Invariante blindada (el controller ya valida, pero nunca llegue al backend
    // un payload sin targets: el DTO NestJS responde 400 con @ArrayMinSize(1)).
    if (input.vendorContactIds.isEmpty) {
      throw ArgumentError(
        'vendorContactIds vacío: el backend exige al menos 1 destinatario.',
      );
    }
    if (input.items.isEmpty) {
      throw ArgumentError(
        'items vacío: el backend exige al menos 1 ítem.',
      );
    }

    final body = CreatePurchaseRequestBody(
      title: input.title,
      type: input.type.wireName,
      category: input.category,
      originType: input.originType.wireName,
      assetId: input.assetId,
      notes: input.notes,
      delivery: input.delivery == null
          ? null
          : CreatePurchaseRequestDelivery(
              department: input.delivery!.department,
              city: input.delivery!.city,
              address: input.delivery!.address,
              info: input.delivery!.info,
            ),
      items: input.items
          .map((i) => CreatePurchaseRequestItem(
                description: i.description,
                quantity: i.quantity,
                unit: i.unit,
                notes: i.notes,
              ))
          .toList(growable: false),
      vendorContactIds: List<String>.unmodifiable(input.vendorContactIds),
    );

    final response = await remote.createPurchaseRequest(body);

    // Hidratar cache local con el PR canónico devuelto por el backend
    // (usa el id server-side, no uno inventado por el cliente).
    final model = PurchaseApiMapper.modelFromServerJson(response.request);
    await local.upsertRequest(model);
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
    try {
      await _refreshFromApi();
    } catch (e) {
      debugPrint('[PurchaseRepo] fetchRequestsByOrg refresh fail: $e');
    }
    final locals = await local.requestsByOrg(orgId, assetId: assetId);
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
    for (final json in page.items) {
      final model = PurchaseApiMapper.modelFromServerJson(json);
      final existing = await local.requestsByOrg(model.orgId);
      final match = existing.where((m) => m.id == model.id).toList();
      final lTime = match.isNotEmpty ? match.first.updatedAt : null;
      final rTime = model.updatedAt;
      if (match.isEmpty ||
          (rTime != null && (lTime == null || rTime.isAfter(lTime)))) {
        await local.upsertRequest(model);
      }
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
    // Sin caller vivo. El flujo canónico servidor es POST
    // /v1/purchase-requests/:id/quotes; ese endpoint exige `items[]` que el
    // SupplierResponseEntity plano no modela. Error explícito hasta que exista
    // UI real con selector de ítems.
    throw UnimplementedError(
      'upsertSupplierResponse: flujo canónico es el backend '
      '(POST /v1/purchase-requests/:id/quotes). Sin caller vivo en v1.',
    );
  }
}

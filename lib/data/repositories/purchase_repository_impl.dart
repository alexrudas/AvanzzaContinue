// ============================================================================
// lib/data/repositories/purchase_repository_impl.dart
// PURCHASE REPOSITORY IMPL — Core API + Isar cache (F5 Hito 17)
// ============================================================================
// QUÉ HACE:
//   - Implementa PurchaseRepository consumiendo Core API como única fuente
//     remota. Isar queda como cache local.
//   - Único camino: Flutter → Core API → Isar cache.
//
// QUÉ NO HACE:
//   - NO escribe a Firestore. No usa `syncService.enqueue`. Ambos caminos
//     legacy fueron retirados en este hito.
//   - NO crea flows de coordinación manualmente: el backend crea el
//     CoordinationFlow atómicamente al recibir el POST /v1/purchase-requests.
//
// PAYLOAD:
//   - orgId y requestedBy NO se envían en body. El backend los deriva del
//     JWT (@ActiveOrgId + @CurrentUser).
//   - Enviar esos campos provocaría 400 (forbidNonWhitelisted backend).
//
// GAP DE DOMINIO (documentado en PurchaseApiMapper):
//   El entity cliente (tipoRepuesto/cantidad/ciudadEntrega) no modela items[]
//   ni targets[]. Se hace best-effort con un único item sintetizado desde
//   title + cantidad. vendorContactIds debe venir con al menos 1 entry o el
//   backend rechaza con 400 (DTO @ArrayMinSize(1)). El controller
//   PurchaseRequestController.submitRequest debe añadir selector de vendor
//   para cerrar este gap; fuera de alcance aquí.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';

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
  // REQUESTS
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Stream<List<PurchaseRequestEntity>> watchRequestsByOrg(
    String orgId, {
    String? cityId,
    String? assetId,
  }) {
    // Dispara un refresh fire-and-forget contra Core API; las escrituras a Isar
    // que haga _backgroundRefresh disparan automáticamente re-emisión del stream.
    _backgroundRefresh();
    return local.watchRequestsByOrg(orgId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<List<PurchaseRequestEntity>> fetchRequestsByOrg(
    String orgId, {
    String? cityId,
    String? assetId,
  }) async {
    // Intento sincronizar primero con backend; si falla, devolvemos lo que
    // haya en Isar. Patrón offline-first.
    try {
      await _refreshFromApi();
    } catch (e) {
      debugPrint('[PurchaseRepo] fetchRequestsByOrg refresh fail: $e');
    }
    final locals =
        await local.requestsByOrg(orgId, cityId: cityId, assetId: assetId);
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
  /// Nota: la tenancy viene del JWT, por lo que esta lista ya está filtrada
  /// al workspace activo — no es necesario pasar orgId al HTTP.
  Future<void> _refreshFromApi() async {
    final page = await remote.listPurchaseRequests(limit: 100);
    for (final json in page.items) {
      final model = PurchaseApiMapper.modelFromServerJson(json);
      final existing = await local.requestsByOrg(
        model.orgId,
        cityId: null,
        assetId: null,
      );
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
    // Solo cache local: sin caller vivo en UI para esta firma en Hito 17.
    // Si un caller futuro la necesita, añadir GET /:id al ApiClient.
    final all = await local.requestsByOrg('', cityId: null, assetId: null);
    final match = all.where((e) => e.id == id).toList();
    yield match.isEmpty ? null : match.first.toEntity();
  }

  @override
  Future<PurchaseRequestEntity?> getRequest(String id) async {
    // Solo cache local; ver nota en watchRequest.
    final all = await local.requestsByOrg('', cityId: null, assetId: null);
    final match = all.where((e) => e.id == id).toList();
    return match.isEmpty ? null : match.first.toEntity();
  }

  @override
  Future<void> upsertRequest(PurchaseRequestEntity request) async {
    // Validación honesta del gap de vendors: el backend exige @ArrayMinSize(1).
    // El UI actual no tiene selector, por lo que esta creación fallará con
    // error explícito hasta que el controller añada vendor picker.
    if (request.proveedorIdsInvitados.isEmpty) {
      throw ArgumentError(
        'proveedorIdsInvitados vacío: el backend exige al menos 1 vendor '
        'invitado. Añadir selector de vendors en la UI de creación.',
      );
    }

    final body = CreatePurchaseRequestBody(
      title: request.tipoRepuesto,
      notes: _notesWithCity(request.specs, request.ciudadEntrega),
      items: [
        CreatePurchaseRequestItem(
          description: request.tipoRepuesto,
          quantity: request.cantidad,
          unit: 'und',
          notes: request.specs,
        ),
      ],
      vendorContactIds: request.proveedorIdsInvitados,
    );

    // HTTP síncrono. Si falla, propaga la excepción del DS.
    final response = await remote.createPurchaseRequest(body);

    // Hidratar cache local con el PR canónico devuelto por el backend
    // (usa el id server-side, no el id que haya creado el cliente).
    final model = PurchaseApiMapper.modelFromServerJson(response.request);
    await local.upsertRequest(model);
  }

  /// Inserta la ciudad de entrega (si existe) dentro de `notes` para no
  /// perder información al mapear el entity plano al contrato backend.
  /// Reemplazable cuando el entity migre a items[]+targets[].
  static String? _notesWithCity(String? specs, String city) {
    final parts = <String>[];
    if (specs != null && specs.trim().isNotEmpty) parts.add(specs.trim());
    final c = city.trim();
    if (c.isNotEmpty) parts.add('Ciudad: $c');
    if (parts.isEmpty) return null;
    return parts.join(' — ');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SUPPLIER RESPONSES
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Stream<List<SupplierResponseEntity>> watchResponsesByRequest(
    String requestId,
  ) async* {
    // Cache local; refresh on-demand vía fetch. Sin callers vivos de la
    // versión stream en Hito 17 — se mantiene por contrato.
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
      // Fall-through: devolvemos cache local.
    }
    final locals = await local.responsesByRequest(requestId);
    return locals.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> upsertSupplierResponse(SupplierResponseEntity response) async {
    // No hay caller vivo. El flujo canónico servidor es POST
    // /v1/purchase-requests/:id/quotes; ese endpoint exige `items[]` que el
    // SupplierResponseEntity plano no modela. Hasta que se introduzca un
    // caller real + UI con selector de ítems, este método lanza error
    // explícito para evitar regresiones silenciosas a Firestore legacy.
    throw UnimplementedError(
      'upsertSupplierResponse: flujo canónico es el backend '
      '(POST /v1/purchase-requests/:id/quotes). Sin caller vivo en v1.',
    );
  }
}

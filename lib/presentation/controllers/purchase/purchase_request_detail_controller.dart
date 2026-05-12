// ============================================================================
// lib/presentation/controllers/purchase/purchase_request_detail_controller.dart
// PURCHASE REQUEST DETAIL CONTROLLER — Orquestación del loop mono-workspace
// ============================================================================
// QUÉ HACE:
//   - Cierra el loop admin-captura completo de un PurchaseRequest ya creado:
//       1. carga detalle (items + targets)
//       2. carga quotes (comparison)
//       3. carga summary (canClose)
//       4. registra quote recibida off-platform
//       5. adjudica (award CONFIRMED en un solo paso)
//       6. emite documentos OC/OT
//       7. cierra PR
//   - Expone estado reactivo para la pantalla de detalle y sus sheets.
//
// QUÉ NO HACE:
//   - No crea el PurchaseRequest: eso sigue viviendo en PurchaseRequestController
//     (wizard de creación).
//   - No abre cross-workspace: el loop es mono-workspace admin-captura.
//   - No implementa inbox del target, invitación ni WhatsApp.
//
// PRINCIPIOS:
//   - Orquestación pura: todo write path es un método Future que reporta
//     errores vía `lastError.value`. La UI observa con Obx y muestra snackbar.
//   - Cada acción refresca los sub-agregados afectados (quotes/award/summary)
//     para mantener coherencia sin polling global.
//   - `requestId` se recibe por argumentos de la ruta; el controller no lo
//     asume del controller de creación.
//
// ENTERPRISE NOTES:
//   - Para submit-quote y create-award, `vendorContactId` coincide siempre con
//     `PurchaseRequestTargetEntity.vendorContactId` (igual al localId para
//     ActorRef.local, al platformActorId para ActorRef.platform). El
//     controller no inventa ese valor: lo toma del detalle ya persistido.
//   - El contrato de conversionType se deriva del fulfillmentType del ítem
//     (GOODS→OC, SERVICE→OT, BOTH→OC_AND_OT) — ver helper awardConversionFor.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../domain/entities/purchase/award_entity.dart';
import '../../../domain/entities/purchase/purchase_document_entities.dart';
import '../../../domain/entities/purchase/purchase_request_detail_entity.dart';
import '../../../domain/entities/purchase/purchase_request_summary_entity.dart';
import '../../../domain/entities/purchase/quote_with_items_entity.dart';
import '../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../domain/repositories/purchase_repository.dart';

/// ViewModel mínimo para render histórico de proveedor en el detalle.
///
/// - `displayName`: nombre humano del `LocalContact` resuelto por `getById`
///   (incluye soft-deleted por contrato del repo).
/// - `isDeleted`: cuando true, la UI debe marcar el chip como "Eliminado"
///   para mantener legibilidad sin confundir con proveedores activos.
/// - `notFound`: true cuando el `vendorContactId` no corresponde a un
///   `LocalContact` del workspace (ej. ActorRef.platform con un
///   `platformActorId`); la UI cae a render opaco truncado.
class VendorLabelVm {
  final String displayName;
  final bool isDeleted;
  final bool notFound;

  const VendorLabelVm({
    required this.displayName,
    this.isDeleted = false,
    this.notFound = false,
  });

  const VendorLabelVm.notFound()
      : displayName = '',
        isDeleted = false,
        notFound = true;
}

/// Orquesta el loop admin-captura sobre un PurchaseRequest existente.
class PurchaseRequestDetailController extends GetxController {
  // ── IDENTIDAD ─────────────────────────────────────────────────────────────
  /// UUID del PurchaseRequest a operar. Resuelto desde Get.arguments o Get.parameters.
  final RxnString requestId = RxnString();

  // ── ESTADO REACTIVO ───────────────────────────────────────────────────────
  final loading = false.obs;
  final RxnString lastError = RxnString();

  final Rxn<PurchaseRequestDetailEntity> detail =
      Rxn<PurchaseRequestDetailEntity>();
  final quotes = <QuoteWithItemsEntity>[].obs;
  final Rxn<AwardEntity> award = Rxn<AwardEntity>();
  final Rxn<PurchaseRequestSummaryEntity> summary =
      Rxn<PurchaseRequestSummaryEntity>();

  /// Resolución reactiva de displayName por `vendorContactId`.
  /// Alimentado por `_hydrateVendorLabels` tras cada load del detalle.
  /// Usa `LocalContactRepository.getById` que INCLUYE soft-deleted por
  /// contrato → el historial sigue legible aunque el proveedor haya sido
  /// eliminado del directorio. Si el id no corresponde a un LocalContact
  /// (p. ej. ActorRef.platform en el futuro), el map guarda `notFound=true`
  /// y la UI cae al render opaco truncado.
  final RxMap<String, VendorLabelVm> vendorLabels =
      <String, VendorLabelVm>{}.obs;

  /// Flags por-acción para deshabilitar botones mientras corre la acción.
  final submittingQuote = false.obs;
  final creatingAward = false.obs;
  final emittingDocuments = false.obs;
  final closingRequest = false.obs;

  // ── DERIVADOS CONVENIENCIA ───────────────────────────────────────────────

  /// true si ya existe un award CONFIRMED.
  bool get hasAward => award.value != null;

  /// true si backend confirma que todo el ciclo operativo está cerrado.
  bool get canClose => summary.value?.completion.canClose ?? false;

  /// Motivos canónicos que bloquean el cierre (códigos wire-stable).
  List<String> get closeBlockers =>
      summary.value?.completion.missingActions ?? const [];

  /// true si el PR ya fue cerrado formalmente.
  /// Nombre deliberadamente distinto a `isClosed` de GetxController para evitar
  /// colisión con el lifecycle del controller.
  bool get isRequestClosed => detail.value?.status == 'closed' ||
      summary.value?.request.status == 'closed';

  /// true si hay al menos un documento emitido (OC o WO) según summary.
  bool get hasDocuments =>
      (summary.value?.purchaseOrdersCount ?? 0) > 0 ||
      (summary.value?.workOrdersCount ?? 0) > 0;

  // ── PRIVATE ──────────────────────────────────────────────────────────────
  late final PurchaseRepository _repo;
  late final LocalContactRepository _contacts;

  // ── LIFECYCLE ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _repo = DIContainer().purchaseRepository;
    _contacts = DIContainer().localContactRepository;
    _resolveIdFromArgs();
    if (requestId.value != null) {
      refreshAll();
    }
  }

  /// Acepta requestId en Get.arguments (String) o en Get.parameters['id'].
  void _resolveIdFromArgs() {
    final args = Get.arguments;
    if (args is String && args.trim().isNotEmpty) {
      requestId.value = args.trim();
      return;
    }
    if (args is Map && args['id'] is String) {
      final id = (args['id'] as String).trim();
      if (id.isNotEmpty) {
        requestId.value = id;
        return;
      }
    }
    final fromParams = Get.parameters['id'];
    if (fromParams != null && fromParams.trim().isNotEmpty) {
      requestId.value = fromParams.trim();
    }
  }

  // ── RECARGAS ─────────────────────────────────────────────────────────────

  /// Carga detalle + quotes + award + summary en paralelo. Single-shot.
  Future<void> refreshAll() async {
    final id = requestId.value;
    if (id == null) {
      lastError.value = 'No se recibió el identificador del pedido.';
      return;
    }
    loading.value = true;
    lastError.value = null;
    try {
      final results = await Future.wait([
        _repo.fetchRequestDetail(id),
        _repo.fetchComparison(id),
        _repo.fetchAward(id),
        _repo.fetchSummary(id),
      ]);
      detail.value = results[0] as PurchaseRequestDetailEntity;
      quotes.assignAll(results[1] as List<QuoteWithItemsEntity>);
      award.value = results[2] as AwardEntity?;
      summary.value = results[3] as PurchaseRequestSummaryEntity;
      // Hidratar displayName de proveedores para targets + quotes.
      // Fire-and-forget: la UI lee `vendorLabels` reactivo; mientras llega la
      // resolución, muestra el fallback opaco truncado existente.
      unawaited(_hydrateVendorLabels());
    } catch (e, st) {
      debugPrint('[PRDetailCtrl] refreshAll fail: $e\n$st');
      lastError.value = 'No se pudo cargar el pedido: $e';
    } finally {
      loading.value = false;
    }
  }

  /// Resuelve `displayName` + flag de soft-delete para cada `vendorContactId`
  /// referenciado por targets o quotes del pedido. Usa `getById` del
  /// repositorio LOCAL (Isar) que es prácticamente instantáneo y, por
  /// contrato, incluye registros soft-deleted. Cualquier id que no pertenezca
  /// a `LocalContact` del workspace se marca `notFound` y la UI degrada al
  /// display opaco actual sin crashear.
  Future<void> _hydrateVendorLabels() async {
    final d = detail.value;
    if (d == null) return;
    final ids = <String>{
      for (final t in d.targets) t.vendorContactId,
      for (final q in quotes) q.vendorContactId,
    }..removeWhere((id) => id.isEmpty);
    if (ids.isEmpty) {
      vendorLabels.clear();
      return;
    }
    final next = <String, VendorLabelVm>{};
    for (final id in ids) {
      try {
        final LocalContactEntity? c = await _contacts.getById(id);
        if (c == null) {
          next[id] = const VendorLabelVm.notFound();
        } else {
          next[id] = VendorLabelVm(
            displayName: c.displayName,
            isDeleted: c.isDeleted,
          );
        }
      } catch (e) {
        debugPrint('[PRDetailCtrl] vendorLabel getById($id) fail: $e');
        next[id] = const VendorLabelVm.notFound();
      }
    }
    vendorLabels.assignAll(next);
  }

  Future<void> refreshQuotes() async {
    final id = requestId.value;
    if (id == null) return;
    try {
      quotes.assignAll(await _repo.fetchComparison(id));
    } catch (e) {
      debugPrint('[PRDetailCtrl] refreshQuotes fail: $e');
    }
  }

  Future<void> refreshAwardAndSummary() async {
    final id = requestId.value;
    if (id == null) return;
    try {
      final results = await Future.wait([
        _repo.fetchAward(id),
        _repo.fetchSummary(id),
      ]);
      award.value = results[0] as AwardEntity?;
      summary.value = results[1] as PurchaseRequestSummaryEntity;
    } catch (e) {
      debugPrint('[PRDetailCtrl] refreshAwardAndSummary fail: $e');
    }
  }

  // ── ACCIONES DEL LOOP ────────────────────────────────────────────────────

  /// Registra una cotización recibida off-platform. Refresca quotes y summary.
  /// Retorna la cotización persistida o null si falló (error en lastError).
  Future<QuoteWithItemsEntity?> submitQuote({
    required String vendorContactId,
    required List<SubmitQuoteItemInput> items,
    DateTime? validUntil,
    String? currency,
    String? notes,
  }) async {
    final id = requestId.value;
    if (id == null) {
      lastError.value = 'No se recibió el identificador del pedido.';
      return null;
    }
    submittingQuote.value = true;
    lastError.value = null;
    try {
      final quote = await _repo.submitQuote(
        requestId: id,
        vendorContactId: vendorContactId,
        items: items,
        validUntil: validUntil,
        currency: currency,
        notes: notes,
      );
      await Future.wait([refreshQuotes(), refreshAwardAndSummary()]);
      return quote;
    } catch (e) {
      lastError.value = 'No se pudo registrar la cotización: $e';
      return null;
    } finally {
      submittingQuote.value = false;
    }
  }

  /// Crea la adjudicación (CONFIRMED en un solo paso). Refresca award y summary.
  Future<AwardEntity?> createAward({
    required List<CreateAwardLineInput> lines,
    String? notes,
  }) async {
    final id = requestId.value;
    if (id == null) {
      lastError.value = 'No se recibió el identificador del pedido.';
      return null;
    }
    creatingAward.value = true;
    lastError.value = null;
    try {
      final created = await _repo.createAward(
        requestId: id,
        lines: lines,
        notes: notes,
      );
      award.value = created;
      await refreshAwardAndSummary();
      return created;
    } catch (e) {
      lastError.value = 'No se pudo adjudicar: $e';
      return null;
    } finally {
      creatingAward.value = false;
    }
  }

  /// Emite OC/OT desde el award CONFIRMED. Refresca summary (que proyecta los
  /// documentos). Retorna el resultado con ids/numbers persistidos.
  Future<GenerateDocumentsResultEntity?> emitDocuments() async {
    final awardId = award.value?.id;
    if (awardId == null) {
      lastError.value = 'Primero debes adjudicar para emitir OC/OT.';
      return null;
    }
    emittingDocuments.value = true;
    lastError.value = null;
    try {
      final result = await _repo.generateDocuments(awardId);
      await refreshAwardAndSummary();
      return result;
    } catch (e) {
      lastError.value = 'No se pudieron emitir documentos: $e';
      return null;
    } finally {
      emittingDocuments.value = false;
    }
  }

  /// Cierra el PR. Backend exige canClose=true (summary).
  Future<bool> closeRequest() async {
    final id = requestId.value;
    if (id == null) return false;
    if (!canClose) {
      lastError.value =
          'El pedido aún no se puede cerrar: ${closeBlockers.join(", ")}';
      return false;
    }
    closingRequest.value = true;
    lastError.value = null;
    try {
      await _repo.closePurchaseRequest(id);
      // Refresca detalle y summary para reflejar status=closed.
      await Future.wait([
        _refreshDetailOnly(),
        refreshAwardAndSummary(),
      ]);
      return true;
    } catch (e) {
      lastError.value = 'No se pudo cerrar el pedido: $e';
      return false;
    } finally {
      closingRequest.value = false;
    }
  }

  Future<void> _refreshDetailOnly() async {
    final id = requestId.value;
    if (id == null) return;
    try {
      detail.value = await _repo.fetchRequestDetail(id);
    } catch (e) {
      debugPrint('[PRDetailCtrl] _refreshDetailOnly fail: $e');
    }
  }

  // ── HELPERS WIRE ─────────────────────────────────────────────────────────

  /// Mapea fulfillmentType wire → conversionType wire compatible.
  /// GOODS → OC, SERVICE → OT, BOTH → OC_AND_OT.
  /// La UI usa este helper al construir CreateAwardLineInput sin acoplarse
  /// a enums dart (backend valida coherencia de todos modos).
  static String awardConversionFor(String fulfillmentType) {
    switch (fulfillmentType) {
      case 'SERVICE':
        return 'OT';
      case 'BOTH':
        return 'OC_AND_OT';
      case 'GOODS':
      default:
        return 'OC';
    }
  }
}

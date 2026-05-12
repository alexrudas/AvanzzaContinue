// ============================================================================
// lib/domain/repositories/purchase_repository.dart
// PURCHASE REPOSITORY — Contrato del loop comercial mono-workspace
// ============================================================================
// QUÉ HACE:
//   - Contrato de repositorio que cubre el loop admin-captura completo:
//     crear PR → registrar cotización → comparar → adjudicar → emitir → cerrar.
//   - Read path en cache local (Isar) para listados; write path y detalle
//     operativo van siempre contra Core API.
//
// QUÉ NO HACE:
//   - No abre cross-workspace: no modela inbox del target ni quote recibida
//     desde otro workspace.
//   - No implementa invitación, WhatsApp, notificaciones push.
//
// CREATE PATH (ADR actor-canon fase 2):
//   - `createRequest(input)` es el único camino canónico. El input acepta
//     `vendorActorRefs[]` (preferido) o `vendorContactIds[]` (legacy,
//     mutuamente excluyente). Retira antes de 2026-07-20.
//
// See docs/adr/0001-actor-canon.md (regla 2.13).
// ============================================================================

import '../entities/purchase/award_entity.dart';
import '../entities/purchase/create_purchase_request_input.dart';
import '../entities/purchase/purchase_document_entities.dart';
import '../entities/purchase/purchase_request_detail_entity.dart';
import '../entities/purchase/purchase_request_entity.dart';
import '../entities/purchase/purchase_request_summary_entity.dart';
import '../entities/purchase/quote_with_items_entity.dart';
import '../entities/purchase/supplier_response_entity.dart';

abstract class PurchaseRepository {
  // ───────────────────────────────────────────────────────────────────────────
  // CREATE
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> createRequest(CreatePurchaseRequestInput input);

  // ───────────────────────────────────────────────────────────────────────────
  // READS — lista y resumen (cache local para list; backend para detalle)
  // ───────────────────────────────────────────────────────────────────────────

  Stream<List<PurchaseRequestEntity>> watchRequestsByOrg(
    String orgId, {
    String? assetId,
  });

  Future<List<PurchaseRequestEntity>> fetchRequestsByOrg(
    String orgId, {
    String? assetId,
  });

  Stream<PurchaseRequestEntity?> watchRequest(String id);

  Future<PurchaseRequestEntity?> getRequest(String id);

  /// Detalle completo del PR con items + targets (backend directo, no cache).
  Future<PurchaseRequestDetailEntity> fetchRequestDetail(String id);

  /// Resumen operativo con `canClose` y `missingActions[]`. Única fuente
  /// válida para decidir si cerrar el PR es posible.
  Future<PurchaseRequestSummaryEntity> fetchSummary(String id);

  // ───────────────────────────────────────────────────────────────────────────
  // QUOTES
  // ───────────────────────────────────────────────────────────────────────────

  Stream<List<SupplierResponseEntity>> watchResponsesByRequest(String requestId);

  /// Lista legacy plana. Se mantiene por compat con UIs antiguas.
  Future<List<SupplierResponseEntity>> fetchResponsesByRequest(
    String requestId,
  );

  /// Comparación completa (con items detallados) para UI de registro y award.
  Future<List<QuoteWithItemsEntity>> fetchComparison(String requestId);

  /// Registra una cotización recibida off-platform (admin-captura).
  /// - [vendorContactId] debe coincidir con el vendorContactId del target
  ///   ya creado al enviar el PR.
  /// - [itemPrices] mapea purchaseRequestItemId → {unitPrice, notes?}. Debe
  ///   cubrir todos los items del PR.
  Future<QuoteWithItemsEntity> submitQuote({
    required String requestId,
    required String vendorContactId,
    required List<SubmitQuoteItemInput> items,
    DateTime? validUntil,
    String? currency,
    String? notes,
  });

  /// Deprecado. El flujo canónico es [submitQuote]. Se deja solo para no
  /// romper referencias externas. Siempre lanza `UnimplementedError`.
  @Deprecated('Usar submitQuote. Se remueve cuando no queden callers.')
  Future<void> upsertSupplierResponse(SupplierResponseEntity response);

  // ───────────────────────────────────────────────────────────────────────────
  // AWARD
  // ───────────────────────────────────────────────────────────────────────────

  /// Crea la adjudicación (CONFIRMED en un solo paso). Retorna el award con
  /// sus líneas persistidas (incluyen ids reales para cruzar con items/targets).
  Future<AwardEntity> createAward({
    required String requestId,
    required List<CreateAwardLineInput> lines,
    String? notes,
  });

  /// Lee el award CONFIRMED activo del PR. Retorna null si aún no se ha
  /// adjudicado (backend 404 se traduce a null).
  Future<AwardEntity?> fetchAward(String requestId);

  // ───────────────────────────────────────────────────────────────────────────
  // DOCUMENT GENERATION (OC / OT)
  // ───────────────────────────────────────────────────────────────────────────

  /// Emite OC/OT a partir del award CONFIRMED. Anti-duplicación server-side:
  /// una segunda llamada sobre el mismo award responde DOCUMENTS_ALREADY_GENERATED.
  Future<GenerateDocumentsResultEntity> generateDocuments(String awardId);

  // ───────────────────────────────────────────────────────────────────────────
  // CLOSE
  // ───────────────────────────────────────────────────────────────────────────

  /// Cierra el PR. Backend valida `summary.completion.canClose=true`. La UI
  /// debe refrescar el summary antes de llamar este método.
  Future<void> closePurchaseRequest(String requestId);
}

// ═════════════════════════════════════════════════════════════════════════════
// Inputs de dominio para write-side (quote / award).
// ═════════════════════════════════════════════════════════════════════════════

/// Precio por ítem al registrar una cotización.
class SubmitQuoteItemInput {
  final String purchaseRequestItemId;
  final double unitPrice;
  final String? notes;

  const SubmitQuoteItemInput({
    required this.purchaseRequestItemId,
    required this.unitPrice,
    this.notes,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'purchaseRequestItemId': purchaseRequestItemId,
        'unitPrice': unitPrice,
        if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
      };
}

/// Línea de adjudicación al crear un award.
class CreateAwardLineInput {
  final String purchaseRequestItemId;
  final String targetId;
  final String vendorContactId;
  final num awardedQuantity;

  /// Valor wire: 'OC' | 'OT' | 'OC_AND_OT'. Coherente con fulfillmentType del
  /// ítem (GOODS→OC, SERVICE→OT, BOTH→OC_AND_OT).
  final String conversionType;

  final String? poDescription;
  final String? otDescription;
  final String? notes;

  const CreateAwardLineInput({
    required this.purchaseRequestItemId,
    required this.targetId,
    required this.vendorContactId,
    required this.awardedQuantity,
    required this.conversionType,
    this.poDescription,
    this.otDescription,
    this.notes,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'purchaseRequestItemId': purchaseRequestItemId,
        'targetId': targetId,
        'vendorContactId': vendorContactId,
        'awardedQuantity': awardedQuantity,
        'conversionType': conversionType,
        if (poDescription != null && poDescription!.trim().isNotEmpty)
          'poDescription': poDescription!.trim(),
        if (otDescription != null && otDescription!.trim().isNotEmpty)
          'otDescription': otDescription!.trim(),
        if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
      };
}

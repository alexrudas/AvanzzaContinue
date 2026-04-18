// ============================================================================
// lib/presentation/controllers/purchase_request_controller.dart
// PURCHASE REQUEST CONTROLLER — Creación canónica de solicitud coordinada
// ============================================================================
// QUÉ HACE:
//   - Gestiona el formulario de creación alineado al contrato backend
//     canónico: title, type, category, originType, assetId, notes, delivery,
//     items[], vendorContactIds[].
//   - Resuelve orgId desde SessionContextController.
//   - Mantiene estado reactivo de:
//       - encabezado (title, type, category)
//       - contexto (originType, assetId, notes)
//       - items dinámicos (descripción, cantidad, unidad, notas)
//       - destinatarios seleccionados (targets)
//       - delivery (department?, city, address, info?)
//   - Provee stream de contactos elegibles del workspace desde Isar.
//   - Envía vía PurchaseRepository.createRequest(); el repo llama al
//     Core API POST /v1/purchase-requests.
//
// QUÉ NO HACE:
//   - NO lista solicitudes existentes (AdminPurchaseController).
//   - NO construye widgets.
//   - NO esconde campos estructurados en `notes` (eso lo acepta el backend
//     canónicamente vía delivery/assetId/category).
//
// TENANT SAFETY:
//   - orgId se lee del SessionContextController; nunca del body/UI.
//   - vendorContactIds son LocalContactEntity.id del workspace activo.
//
// PRINCIPIOS:
//   - Cero semántica legacy (tipoRepuesto/cantidad/ciudadEntrega/specs).
//   - Delivery es opcional como bloque: si el usuario empieza a llenarlo,
//     city + address son obligatorios; si lo deja completamente vacío, se
//     omite del payload.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/core_common/local_contact_entity.dart';
import '../../domain/entities/purchase/create_purchase_request_input.dart';
import '../../domain/repositories/core_common/local_contact_repository.dart';
import '../../domain/repositories/purchase_repository.dart';
import 'session_context_controller.dart';

/// Borrador de ítem dentro del formulario. Se mantiene como clase mutable
/// simple porque vive solo en memoria del controller y los cambios los
/// empuja el controller vía setters (no hay reactividad granular por ítem).
class PurchaseRequestItemDraft {
  String description;
  String quantityText;
  String unit;
  String? notes;

  PurchaseRequestItemDraft({
    this.description = '',
    this.quantityText = '1',
    this.unit = 'und',
    this.notes,
  });
}

class PurchaseRequestController extends GetxController {
  /// Ctor productivo + inyección opcional para tests.
  PurchaseRequestController({
    PurchaseRepository? repo,
    LocalContactRepository? contactsRepo,
    SessionContextController? session,
  })  : _repoOverride = repo,
        _contactsRepoOverride = contactsRepo,
        _sessionOverride = session;

  final PurchaseRepository? _repoOverride;
  final LocalContactRepository? _contactsRepoOverride;
  final SessionContextController? _sessionOverride;

  // ── STATE: submit ────────────────────────────────────────────────────────
  final isSubmitting = false.obs;

  // ── STATE: encabezado ────────────────────────────────────────────────────
  final title = ''.obs;
  final type = PurchaseRequestTypeInput.product.obs;
  final category = ''.obs;

  // ── STATE: contexto ──────────────────────────────────────────────────────
  final originType = PurchaseRequestOriginInput.general.obs;
  final assetId = ''.obs;
  /// Etiqueta humana del activo seleccionado (assetKey/placa).
  /// Solo UI — NO se envía al backend. Se resetea si cambia originType.
  final assetLabel = ''.obs;
  final notes = ''.obs;

  // ── STATE: ítems ─────────────────────────────────────────────────────────
  /// Borradores de ítems. Arranca con un ítem vacío para que el form tenga
  /// siempre al menos una fila visible.
  final RxList<PurchaseRequestItemDraft> items =
      <PurchaseRequestItemDraft>[PurchaseRequestItemDraft()].obs;

  // ── STATE: destinatarios ─────────────────────────────────────────────────
  final RxList<LocalContactEntity> availableContacts =
      <LocalContactEntity>[].obs;
  final RxList<String> selectedVendorIds = <String>[].obs;

  // ── STATE: delivery (bloque opcional activable) ──────────────────────────
  /// Bloque activado explícitamente por el usuario (switch/colapsable).
  /// Cuando es false, el delivery se omite del payload aunque haya texto.
  final deliveryEnabled = false.obs;
  final deliveryDepartment = ''.obs;
  final deliveryCity = ''.obs;
  final deliveryAddress = ''.obs;
  final deliveryInfo = ''.obs;

  // ── PRIVATE ──────────────────────────────────────────────────────────────
  late final PurchaseRepository _repo;
  late final LocalContactRepository _contactsRepo;
  late final SessionContextController _session;
  StreamSubscription<List<LocalContactEntity>>? _contactsSub;

  String? get _orgId => _session.user?.activeContext?.orgId;

  // ── LIFECYCLE ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _repo = _repoOverride ?? DIContainer().purchaseRepository;
    _contactsRepo =
        _contactsRepoOverride ?? DIContainer().localContactRepository;
    _session = _sessionOverride ?? Get.find<SessionContextController>();
    _bindContactsStream();
  }

  @override
  void onClose() {
    _contactsSub?.cancel();
    super.onClose();
  }

  void _bindContactsStream() {
    final orgId = _orgId;
    if (orgId == null || orgId.isEmpty) return;
    _contactsSub?.cancel();
    _contactsSub = _contactsRepo.watchByWorkspace(orgId).listen((list) {
      availableContacts.assignAll(list);
      // Si un contacto seleccionado sale del workspace, se retira.
      final validIds = list.map((c) => c.id).toSet();
      selectedVendorIds.removeWhere((id) => !validIds.contains(id));
    });
  }

  // ── ITEMS API ────────────────────────────────────────────────────────────

  void addItem() {
    items.add(PurchaseRequestItemDraft());
  }

  void removeItemAt(int index) {
    if (items.length <= 1) return; // siempre al menos 1 ítem
    if (index < 0 || index >= items.length) return;
    items.removeAt(index);
  }

  void updateItem(
    int index, {
    String? description,
    String? quantityText,
    String? unit,
    String? notes,
  }) {
    if (index < 0 || index >= items.length) return;
    final draft = items[index];
    if (description != null) draft.description = description;
    if (quantityText != null) draft.quantityText = quantityText;
    if (unit != null) draft.unit = unit;
    if (notes != null) draft.notes = notes;
    items.refresh();
  }

  // ── TARGETS API ──────────────────────────────────────────────────────────

  bool isSelected(String contactId) => selectedVendorIds.contains(contactId);

  void toggleVendor(String contactId) {
    if (selectedVendorIds.contains(contactId)) {
      selectedVendorIds.remove(contactId);
    } else {
      selectedVendorIds.add(contactId);
    }
  }

  void clearSelectedVendors() => selectedVendorIds.clear();

  // ── ASSET SELECTION ──────────────────────────────────────────────────────

  /// Invocado desde AssetPickerSheet al tap en un activo.
  void selectAsset({required String id, required String label}) {
    assetId.value = id;
    assetLabel.value = label;
  }

  void clearAsset() {
    assetId.value = '';
    assetLabel.value = '';
  }

  // ── DELIVERY ─────────────────────────────────────────────────────────────

  /// Activa/desactiva el bloque delivery. Al desactivar se limpia el estado
  /// para evitar que el payload lleve basura si el usuario cambia de idea.
  void setDeliveryEnabled(bool enabled) {
    deliveryEnabled.value = enabled;
    if (!enabled) {
      deliveryDepartment.value = '';
      deliveryCity.value = '';
      deliveryAddress.value = '';
      deliveryInfo.value = '';
    }
  }

  CreateDeliveryInput? _buildDeliveryOrNull() {
    if (!deliveryEnabled.value) return null;
    return CreateDeliveryInput(
      department: deliveryDepartment.value.trim().isEmpty
          ? null
          : deliveryDepartment.value.trim(),
      city: deliveryCity.value.trim(),
      address: deliveryAddress.value.trim(),
      info: deliveryInfo.value.trim().isEmpty
          ? null
          : deliveryInfo.value.trim(),
    );
  }

  // ── DERIVED ──────────────────────────────────────────────────────────────

  /// True si el form es válido lo suficiente como para habilitar submit.
  /// Espejo en UI-friendly de [validate] sin devolver mensaje.
  bool get canSubmit => validate() == null;

  // ── VALIDATION ───────────────────────────────────────────────────────────

  /// Valida el estado actual del formulario.
  /// Retorna null si todo OK, o un String con el primer error humano.
  String? validate() {
    if (_orgId == null || _orgId!.isEmpty) {
      return 'No hay organización activa. Selecciona una organización primero.';
    }
    if (title.value.trim().isEmpty) {
      return 'El título es obligatorio.';
    }
    if (originType.value == PurchaseRequestOriginInput.asset &&
        assetId.value.trim().isEmpty) {
      return 'Selecciona un activo cuando el origen es "Activo específico".';
    }

    // Ítems: al menos 1, y cada uno con descripción, cantidad > 0 y unidad.
    if (items.isEmpty) {
      return 'Agrega al menos un ítem.';
    }
    for (var i = 0; i < items.length; i++) {
      final it = items[i];
      if (it.description.trim().isEmpty) {
        return 'Ítem ${i + 1}: la descripción es obligatoria.';
      }
      final q = num.tryParse(it.quantityText.trim());
      if (q == null || q <= 0) {
        return 'Ítem ${i + 1}: la cantidad debe ser mayor a 0.';
      }
      if (it.unit.trim().isEmpty) {
        return 'Ítem ${i + 1}: la unidad es obligatoria.';
      }
    }

    if (selectedVendorIds.isEmpty) {
      return 'Selecciona al menos un destinatario antes de enviar.';
    }

    // Delivery: si el bloque está activado, city y address son obligatorios.
    if (deliveryEnabled.value) {
      if (deliveryCity.value.trim().isEmpty) {
        return 'Entrega: la ciudad es obligatoria.';
      }
      if (deliveryAddress.value.trim().isEmpty) {
        return 'Entrega: la dirección es obligatoria.';
      }
    }

    return null;
  }

  // ── SUBMIT ───────────────────────────────────────────────────────────────

  /// Crea la solicitud en el backend. Retorna true si OK, false si falló.
  /// El caller debe haber llamado [validate] antes y manejar feedback de UI.
  Future<bool> submitRequest() async {
    if (isSubmitting.value) return false;

    // Gate final (defensivo): nunca llegue al backend un payload inválido.
    final err = validate();
    if (err != null) {
      debugPrint('[PurchaseRequestCtrl] submit bloqueado: $err');
      return false;
    }

    isSubmitting.value = true;
    try {
      final input = CreatePurchaseRequestInput(
        title: title.value.trim(),
        type: type.value,
        category:
            category.value.trim().isEmpty ? null : category.value.trim(),
        originType: originType.value,
        assetId: originType.value == PurchaseRequestOriginInput.asset
            ? assetId.value.trim()
            : null,
        notes: notes.value.trim().isEmpty ? null : notes.value.trim(),
        delivery: _buildDeliveryOrNull(),
        items: items
            .map((it) => CreatePurchaseRequestItemInput(
                  description: it.description.trim(),
                  quantity: num.parse(it.quantityText.trim()),
                  unit: it.unit.trim(),
                  notes: (it.notes == null || it.notes!.trim().isEmpty)
                      ? null
                      : it.notes!.trim(),
                ))
            .toList(growable: false),
        vendorContactIds: List<String>.unmodifiable(selectedVendorIds),
      );

      await _repo.createRequest(input);
      debugPrint('[PurchaseRequestCtrl] Solicitud creada '
          '(targets=${selectedVendorIds.length} items=${items.length})');
      _resetAfterSubmit();
      return true;
    } catch (e) {
      debugPrint('[PurchaseRequestCtrl] Error al crear solicitud: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void _resetAfterSubmit() {
    // Limpieza de selección para no arrastrar estado entre submits sucesivos.
    // Los campos de texto los limpia la page (es dueña de los TextEditingController).
    selectedVendorIds.clear();
    clearAsset();
    setDeliveryEnabled(false);
  }
}

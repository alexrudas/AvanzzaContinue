// ============================================================================
// lib/presentation/controllers/purchase_request_controller.dart
// PURCHASE REQUEST CONTROLLER — Creación de solicitud de compra (F5 Hito 18)
// ============================================================================
// QUÉ HACE:
// - Gestiona el formulario de creación de una PurchaseRequestEntity real.
// - Resuelve orgId desde SessionContextController.
// - Mantiene estado reactivo de destinatarios seleccionados (targets).
// - Provee stream de contactos elegibles del workspace desde Isar.
// - Valida que haya al menos 1 destinatario antes de submit (regla de negocio
//   de producto: "solicitud sin destinatarios = intención interna, no envío").
// - Persiste vía PurchaseRepository.upsertRequest(); el repo llama a Core API.
//
// QUÉ NO HACE:
// - NO lista solicitudes existentes (AdminPurchaseController).
// - NO construye widgets.
// - NO inventa vendorContactIds: provienen siempre de LocalContact.id del
//   workspace activo.
//
// TENANT SAFETY:
// - orgId se lee del SessionContextController; nunca del body/UI.
// - vendorContactIds son siempre LocalContactEntity.id del workspace activo.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/container.dart';
import '../../domain/entities/core_common/local_contact_entity.dart';
import '../../domain/entities/purchase/purchase_request_entity.dart';
import '../../domain/repositories/core_common/local_contact_repository.dart';
import '../../domain/repositories/purchase_repository.dart';
import 'session_context_controller.dart';

class PurchaseRequestController extends GetxController {
  /// Ctor productivo + inyección opcional para tests.
  /// Si se omiten las deps, onInit las resuelve desde DIContainer / Get.find.
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

  // ── STATE ────────────────────────────────────────────────────────────────
  final isSubmitting = false.obs;

  /// Contactos elegibles del workspace activo (fuente reactiva Isar).
  /// Se alimenta vía LocalContactRepository.watchByWorkspace().
  final RxList<LocalContactEntity> availableContacts =
      <LocalContactEntity>[].obs;

  /// Ids seleccionados como destinatarios del PurchaseRequest.
  /// Subset de availableContacts[*].id. Deduplicado por construcción.
  final RxList<String> selectedVendorIds = <String>[].obs;

  /// Campos del form reactivos para que canSubmit derive correctamente.
  final tipoRepuesto = ''.obs;
  final cantidadText = '1'.obs;
  final ciudadEntrega = ''.obs;

  /// Derivado: true cuando el form es válido Y hay al menos un destinatario.
  /// UI usa este bool para habilitar el botón Enviar.
  bool get canSubmit {
    final orgOk = _orgId != null && _orgId!.isNotEmpty;
    final tipoOk = tipoRepuesto.value.trim().isNotEmpty;
    final qty = int.tryParse(cantidadText.value.trim());
    final qtyOk = qty != null && qty >= 1;
    final ciudadOk = ciudadEntrega.value.trim().isNotEmpty;
    final targetsOk = selectedVendorIds.isNotEmpty;
    return orgOk && tipoOk && qtyOk && ciudadOk && targetsOk;
  }

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
      // Si se eliminaron contactos que estaban seleccionados, los retiramos
      // de la selección para mantener el estado coherente.
      final validIds = list.map((c) => c.id).toSet();
      selectedVendorIds.removeWhere((id) => !validIds.contains(id));
    });
  }

  // ── TARGET SELECTION ─────────────────────────────────────────────────────

  bool isSelected(String contactId) => selectedVendorIds.contains(contactId);

  void toggleVendor(String contactId) {
    if (selectedVendorIds.contains(contactId)) {
      selectedVendorIds.remove(contactId);
    } else {
      selectedVendorIds.add(contactId);
    }
  }

  void clearSelectedVendors() => selectedVendorIds.clear();

  // ── VALIDATION ───────────────────────────────────────────────────────────

  /// Valida los campos del formulario. Retorna null si todo OK,
  /// o un String con el primer error encontrado.
  String? validate({
    required String tipoRepuesto,
    required String cantidad,
    required String ciudadEntrega,
  }) {
    if (_orgId == null || _orgId!.isEmpty) {
      return 'No hay organización activa. Selecciona una organización primero.';
    }
    if (tipoRepuesto.trim().isEmpty) {
      return 'El tipo de repuesto es obligatorio.';
    }
    final cant = int.tryParse(cantidad.trim());
    if (cant == null || cant < 1) {
      return 'La cantidad debe ser un número mayor a 0.';
    }
    if (ciudadEntrega.trim().isEmpty) {
      return 'La ciudad de entrega es obligatoria.';
    }
    if (selectedVendorIds.isEmpty) {
      return 'Selecciona al menos un destinatario antes de enviar.';
    }
    return null;
  }

  // ── SUBMIT ───────────────────────────────────────────────────────────────

  /// Crea una solicitud de compra real. Retorna true si OK, false en fallo.
  /// El caller debe llamar [validate] antes y manejar el feedback de UI.
  Future<bool> submitRequest({
    required String tipoRepuesto,
    required int cantidad,
    required String ciudadEntrega,
    String? specs,
  }) async {
    // Prevención de doble submit
    if (isSubmitting.value) return false;
    isSubmitting.value = true;

    try {
      final orgId = _orgId;
      if (orgId == null || orgId.isEmpty) return false;
      // Invariante blindada: la UI ya debió bloquear, pero el controller
      // repite la validación para que NUNCA llegue al backend un payload sin
      // targets.
      if (selectedVendorIds.isEmpty) return false;

      final entity = PurchaseRequestEntity(
        id: const Uuid().v4(),
        orgId: orgId,
        assetId: null,
        tipoRepuesto: tipoRepuesto.trim(),
        specs: specs?.trim().isNotEmpty == true ? specs!.trim() : null,
        cantidad: cantidad,
        ciudadEntrega: ciudadEntrega.trim(),
        proveedorIdsInvitados: List<String>.unmodifiable(selectedVendorIds),
        estado: 'abierta',
        respuestasCount: 0,
        currencyCode: 'COP',
        expectedDate: null,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await _repo.upsertRequest(entity);
      debugPrint('[PurchaseRequestCtrl] Solicitud creada: ${entity.id} '
          'targets=${selectedVendorIds.length}');
      // Limpiar selección para no arrastrar estado entre submits sucesivos.
      selectedVendorIds.clear();
      return true;
    } catch (e) {
      debugPrint('[PurchaseRequestCtrl] Error al crear solicitud: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

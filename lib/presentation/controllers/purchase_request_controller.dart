// ============================================================================
// lib/presentation/controllers/purchase_request_controller.dart
// PURCHASE REQUEST CONTROLLER — Creación canónica de solicitud coordinada
// ============================================================================
// QUÉ HACE:
//   - Gestiona el formulario de creación alineado al contrato backend
//     canónico ADR actor-canon: title, type, category, originType, assetId,
//     notes, delivery, items[], vendorActorRefs[], attestSelf.
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
//   - NO esconde campos estructurados en `notes`.
//
// TENANT SAFETY:
//   - orgId se lee del SessionContextController; nunca del body/UI.
//   - Los destinatarios seleccionados son LocalContactEntity.id del workspace
//     activo; se empaquetan como ActorRef.local(kind=contact, localId=...).
//
// ATTESTATION (ADR actor-canon §8):
//   - Al enviar ActorRef.local, el controller setea attestSelf=true. El
//     backend crea LocalRefAttestation solo la primera vez por par; usos
//     subsiguientes son no-op silencioso. El rate limit por org acota abuso.
//
// PRINCIPIOS:
//   - Cero semántica legacy (tipoRepuesto/cantidad/ciudadEntrega/specs).
//   - Delivery es opcional como bloque.
//
// See docs/adr/0001-actor-canon.md (regla 2.5, 2.13 — ActorRef + transición).
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../application/core_common/actor_ref_factory.dart';
import '../../core/di/container.dart';
import '../../domain/errors/remote_exceptions.dart';
import '../../domain/entities/asset/asset_entity.dart';
import '../../domain/entities/asset/special/asset_vehiculo_entity.dart';
import '../../domain/entities/core_common/constants/role_labels.dart';
import '../../domain/entities/core_common/local_contact_entity.dart';
import '../../domain/entities/purchase/create_purchase_request_input.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/repositories/core_common/local_contact_repository.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../domain/services/core_common/category_taxonomy.dart';
import '../../domain/value/purchase/vehicle_spec.dart';
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
  /// Tipo de activo precontexto (UX). Se resuelve antes de abrir el formulario
  /// desde el BottomSheet de "Nueva solicitud". Si hay un solo tipo registrado
  /// en el workspace, se preselecciona directo. NO se envía al backend: es
  /// prefiltro de UI para categorías y picker de activos.
  final Rx<AssetType?> selectedAssetType = Rx<AssetType?>(null);

  /// Default operativo: al entrar desde "Nueva solicitud" ya tenemos tipo de
  /// activo contextual, así que "Pedido para un activo" es el caso dominante.
  final originType = PurchaseRequestOriginInput.asset.obs;
  final assetId = ''.obs;
  /// Etiqueta humana del activo seleccionado (assetKey/placa).
  /// Solo UI — NO se envía al backend. Se resetea si cambia originType.
  final assetLabel = ''.obs;
  /// Detalle enriquecido del vehículo seleccionado — solo poblado cuando
  /// `selectedAssetType == AssetType.vehicle` y el usuario eligió un activo
  /// concreto. Fuente: `AssetRepository.getAssetDetails(assetId).vehiculo`.
  /// UI-only: se usa para pintar un bloque de contexto comercial/técnico
  /// y NO se envía al backend (contrato canónico no cambia).
  final Rx<AssetVehiculoEntity?> selectedVehicle =
      Rx<AssetVehiculoEntity?>(null);

  /// VehicleSpec seleccionado cuando originType == inventory y el tipo de
  /// activo precontexto es vehículo. Derivado del parque real del workspace.
  /// Se pobla solo desde el picker. Snapshot mínimo se envía en submit.
  final Rx<VehicleSpec?> selectedVehicleSpec = Rx<VehicleSpec?>(null);
  final notes = ''.obs;

  // ── STATE: ítems ─────────────────────────────────────────────────────────
  /// Borradores de ítems. Arranca con un ítem vacío para que el form tenga
  /// siempre al menos una fila visible.
  final RxList<PurchaseRequestItemDraft> items =
      <PurchaseRequestItemDraft>[PurchaseRequestItemDraft()].obs;

  // ── STATE: destinatarios / proveedores ──────────────────────────────────
  /// Lista cruda de contactos del workspace (sin filtrar). Expuesta solo para
  /// tests/debug. La UI debe consumir [availableContacts], que devuelve solo
  /// los contactos que pueden actuar como proveedor.
  final RxList<LocalContactEntity> _allContacts =
      <LocalContactEntity>[].obs;

  /// Contactos del workspace que pueden aparecer como proveedor del pedido.
  /// Incluye:
  ///   - los marcados con `roleLabel == 'proveedor'` (canon de esta fase).
  ///   - los contactos antiguos sin `roleLabel` (compat: fueron creados antes
  ///     de que existiera la marca; no se excluyen para no romper flujos).
  /// Excluye: contactos marcados con otro rol libre (ej. "conductor",
  /// "técnico") — esos pertenecen a otros flujos, no a compras.
  List<LocalContactEntity> get availableContacts => _allContacts
      .where((c) {
        final r = c.roleLabel?.trim();
        return r == null || r.isEmpty || isVendorRoleLabel(r);
      })
      .toList(growable: false);

  final RxList<String> selectedVendorIds = <String>[].obs;

  /// IDs de proveedores que fueron CREADOS inline durante esta misma
  /// sesión del formulario. Se usan para decidir `attestSelf` al enviar:
  /// cuando un proveedor recién creado NO tiene llaves normalizables
  /// (phone/email/docId), el probe del use case es no-op y el backend
  /// rechazará el submit con 409 ACTOR_REF_UNKNOWN a menos que se pida
  /// attestation en el mismo write (ADR actor-canon §8, flujo combinado
  /// "crear proveedor + enviar solicitud"). Se limpia tras submit exitoso.
  final Set<String> _freshlyCreatedVendorIds = <String>{};

  /// Último error humano del submit (null cuando no hay error o ya se
  /// limpió). La UI lo muestra como SnackBar específico en vez del
  /// mensaje genérico "Error al enviar la solicitud. Intenta de nuevo".
  final RxnString lastSubmitError = RxnString();

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
  AssetRepository? _assetRepoOverride;
  AssetRepository get _assetRepo =>
      _assetRepoOverride ??= DIContainer().assetRepository;
  StreamSubscription<List<LocalContactEntity>>? _contactsSub;

  String? get _orgId => _session.user?.activeContext?.orgId;

  /// orgId expuesto para callers que necesitan crear contactos en el workspace
  /// activo (ej. VendorTargetPickerSheet). Mantiene `_orgId` como privado para
  /// no exponer el ciclo de vida de sesión completo.
  String? get orgIdForNewContact => _orgId;

  // ── LIFECYCLE ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _repo = _repoOverride ?? DIContainer().purchaseRepository;
    _contactsRepo =
        _contactsRepoOverride ?? DIContainer().localContactRepository;
    _session = _sessionOverride ?? Get.find<SessionContextController>();
    _hydrateFromRouteArgs();
    _bindContactsStream();
  }

  /// Hidrata el tipo de activo precontexto desde `Get.arguments` — lo setea
  /// `startNewPurchaseRequestFlow` antes de navegar. No es obligatorio:
  /// permite que la page funcione también en casos de prueba / deep link.
  void _hydrateFromRouteArgs() {
    final args = Get.arguments;
    if (args is Map && args['assetType'] is AssetType) {
      selectedAssetType.value = args['assetType'] as AssetType;
    }
  }

  /// Categorías elegibles para (tipo de activo precontexto × tipo de solicitud).
  List<String> get currentCategories =>
      categoriesFor(selectedAssetType.value, type.value);

  /// Limpia la categoría actual si dejó de pertenecer al catálogo válido
  /// (tipo de activo × tipo de solicitud efectivo). Llamado desde la page
  /// al cambiar "Aplica a" o "Tipo de solicitud".
  void ensureCategoryValid() {
    final cur = category.value.trim();
    if (cur.isEmpty) return;
    if (!currentCategories.contains(cur)) {
      category.value = '';
    }
  }

  /// Fija la naturaleza del pedido a PRODUCTO de forma obligatoria — usado
  /// cuando el usuario escoge "Pedido para inventario / stock" (servicio no
  /// aplica a inventario). Al forzarlo, también limpia categoría si queda
  /// fuera de la taxonomía de producto.
  void forceProductNature() {
    if (type.value != PurchaseRequestTypeInput.product) {
      type.value = PurchaseRequestTypeInput.product;
    }
    ensureCategoryValid();
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
      // Persistimos la lista cruda; `availableContacts` ya filtra por rol
      // "proveedor" (o sin rol por compat). La UI solo consume ese getter.
      _allContacts.assignAll(list);
      // Si un contacto seleccionado desaparece del workspace (soft-delete,
      // cambio de workspace, etc.), se retira de la selección actual.
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

  /// true cuando ya se alcanzó el máximo de proveedores admitido por pedido.
  /// Usado por UI para deshabilitar tiles no seleccionados y mostrar aviso.
  bool get hasReachedMaxVendors =>
      selectedVendorIds.length >= kMaxVendorsPerPurchaseRequest;

  /// Alterna la selección de un proveedor para el pedido.
  /// Respeta el tope duro `kMaxVendorsPerPurchaseRequest` (alineado al backend).
  /// Retorna `true` si la acción se aplicó; `false` si fue rechazada por
  /// exceder el máximo (la UI puede mostrar feedback al usuario).
  bool toggleVendor(String contactId) {
    if (selectedVendorIds.contains(contactId)) {
      selectedVendorIds.remove(contactId);
      return true;
    }
    if (selectedVendorIds.length >= kMaxVendorsPerPurchaseRequest) {
      // Tope duro. No agregamos silenciosamente ni hacemos snackbar aquí:
      // el estado vive en controller, la UX (aviso) vive en la capa UI.
      return false;
    }
    selectedVendorIds.add(contactId);
    return true;
  }

  void clearSelectedVendors() => selectedVendorIds.clear();

  /// Marca un proveedor como RECIÉN CREADO en esta sesión del formulario.
  /// El picker lo llama justo después de persistir un alta inline. En el
  /// submit, si cualquiera de los proveedores seleccionados está marcado,
  /// el controller envía `attestSelf=true` (excepción autorizada por ADR
  /// actor-canon §8). Si el usuario deselecciona y no vuelve a usarlo, la
  /// marca queda inocua: solo cuenta lo que efectivamente esté en
  /// `selectedVendorIds` al enviar.
  void markVendorAsFreshlyCreated(String contactId) {
    _freshlyCreatedVendorIds.add(contactId);
  }

  /// True si al menos uno de los proveedores ACTUALMENTE seleccionados fue
  /// creado inline en esta sesión sin probe previo confirmado. Decide el
  /// factory de ActorRef en [submitRequest].
  bool get _hasFreshlyCreatedSelectedVendor =>
      selectedVendorIds.any(_freshlyCreatedVendorIds.contains);

  // ── ASSET SELECTION ──────────────────────────────────────────────────────

  /// Invocado desde AssetPickerSheet al tap en un activo. Para activos tipo
  /// Vehículo dispara un fetch ligero a `AssetRepository.getAssetDetails()`
  /// (offline-first, read desde Isar) para poblar `selectedVehicle` y así la
  /// UI puede pintar un bloque de contexto comercial/técnico útil para la
  /// cotización (marca, línea, año, servicio, chasis/VIN).
  void selectAsset({required String id, required String label}) {
    assetId.value = id;
    assetLabel.value = label;
    selectedVehicle.value = null;
    if (selectedAssetType.value == AssetType.vehicle) {
      _loadVehicleDetails(id);
    }
  }

  Future<void> _loadVehicleDetails(String id) async {
    try {
      final details = await _assetRepo.getAssetDetails(id);
      // Si el usuario ya cambió de activo mientras llegaba la respuesta,
      // descartamos este resultado para no pisar la selección vigente.
      if (assetId.value != id) return;
      selectedVehicle.value = details.vehiculo;
    } catch (e) {
      debugPrint('[PurchaseRequestCtrl] getAssetDetails($id) error: $e');
      // UI-only: si falla la carga, el chip de placa sigue visible y el
      // bloque resumen simplemente no se renderiza. No bloqueamos el form.
    }
  }

  void clearAsset() {
    assetId.value = '';
    assetLabel.value = '';
    selectedVehicle.value = null;
  }

  // ── VEHICLE SPEC SELECTION (inventario/stock) ────────────────────────────

  /// Invocado desde VehicleSpecPickerSheet al tap en una spec derivada.
  /// Solo aplica a originType=inventory. Si el usuario cambia a activo
  /// específico, la selección se limpia desde `onChanged` del dropdown.
  void selectVehicleSpec(VehicleSpec spec) {
    selectedVehicleSpec.value = spec;
  }

  void clearVehicleSpec() {
    selectedVehicleSpec.value = null;
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
    // El título ya no es campo visible del formulario: se auto-genera en
    // submit a partir del tipo de activo + categoría. No se valida aquí.
    if (originType.value == PurchaseRequestOriginInput.asset &&
        assetId.value.trim().isEmpty) {
      return 'Selecciona un activo cuando el origen es "Activo específico".';
    }
    // Inventario/stock para vehículos exige VehicleSpec. Para otros tipos de
    // activo no hay spec equivalente hoy; el pedido queda genérico de stock.
    if (originType.value == PurchaseRequestOriginInput.inventory &&
        selectedAssetType.value == AssetType.vehicle &&
        selectedVehicleSpec.value == null) {
      return 'Selecciona una especificación de vehículo para el pedido de inventario.';
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
    lastSubmitError.value = null;
    try {
      final effectiveTitle = title.value.trim().isEmpty
          ? _autoGenerateTitle()
          : title.value.trim();
      // ADR actor-canon §8 — decisión de `attestSelf`:
      //   - Si TODOS los proveedores seleccionados son "conocidos" (ya
      //     pasaron por probe vía save_local_contact_with_probe en sesiones
      //     anteriores), usamos `fromKnownLocalContactIds` → attestSelf=false.
      //   - Si al menos UNO fue creado inline en esta misma sesión del
      //     formulario, aplica la excepción "primer write post-alta sin
      //     probe previo confirmado" descrita en el ADR: usamos
      //     `fromFreshlyCreatedLocalContactIds` → attestSelf=true. Esto
      //     autoriza al backend a crear LocalRefAttestation en el mismo
      //     write y evita el 409 ACTOR_REF_UNKNOWN cuando el proveedor
      //     recién creado no tenía llaves normalizables (phone/email/docId)
      //     y por tanto el probe fue no-op.
      //
      // BLINDAJE POR TIPOS: CreatePurchaseRequestInput.withBuiltActorRefs
      // exige un BuiltActorRefs (constructor privado). No hay forma de armar
      // el input con attestSelf=true por fuera del factory.
      final built = _hasFreshlyCreatedSelectedVendor
          ? ActorRefFactory.fromFreshlyCreatedLocalContactIds(selectedVendorIds)
          : ActorRefFactory.fromKnownLocalContactIds(selectedVendorIds);

      final input = CreatePurchaseRequestInput.withBuiltActorRefs(
        title: effectiveTitle,
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
        built: built,
        vehicleSpec:
            originType.value == PurchaseRequestOriginInput.inventory &&
                    selectedVehicleSpec.value != null
                ? _buildVehicleSpecSnapshot(selectedVehicleSpec.value!)
                : null,
      );

      await _repo.createRequest(input);
      debugPrint('[PurchaseRequestCtrl] Solicitud creada '
          '(targets=${selectedVendorIds.length} items=${items.length} '
          'attestSelf=${built.attestSelf})');
      _resetAfterSubmit();
      return true;
    } on UnauthorizedException catch (e) {
      debugPrint('[PurchaseRequestCtrl] 401/403 al crear solicitud: $e');
      lastSubmitError.value =
          'Tu sesión expiró o no tienes permisos sobre este workspace. '
          'Vuelve a iniciar sesión.';
      return false;
    } on NetworkException catch (e) {
      debugPrint('[PurchaseRequestCtrl] Network al crear solicitud: $e');
      lastSubmitError.value =
          'Sin conexión o el servidor no responde. Revisa tu internet '
          'e intenta de nuevo.';
      return false;
    } on BadRequestException catch (e) {
      // Log estructurado con todo lo útil para depurar. No logueamos tokens.
      debugPrint('[PurchaseRequestCtrl] 4xx al crear solicitud: '
          'status=${e.statusCode} code=${e.code} message=${e.message}');
      lastSubmitError.value = _humanMessageFor(e);
      return false;
    } on ServerException catch (e) {
      debugPrint('[PurchaseRequestCtrl] 5xx al crear solicitud: '
          'status=${e.statusCode} message=${e.message}');
      lastSubmitError.value =
          'Error del servidor (${e.statusCode}). Intenta en unos minutos.';
      return false;
    } catch (e) {
      // Fallback para errores no esperados (ArgumentError, bug, etc.).
      // Se expone al usuario el `toString()` tal cual: en caso de assert o
      // ArgumentError lanzado por el input, el mensaje YA es humano y útil.
      debugPrint('[PurchaseRequestCtrl] Error inesperado al crear '
          'solicitud: $e');
      lastSubmitError.value =
          'No se pudo enviar la solicitud: ${e.toString()}';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Mapea los `code` canónicos del backend a mensajes humanos específicos.
  /// Fallback: devolver el `message` del backend si está, o un genérico.
  /// Mantenemos los `code` wire-stable como strings (no enum) para no
  /// acoplar presentation a constantes de backend.
  String _humanMessageFor(BadRequestException e) {
    switch (e.code) {
      case 'ACTOR_REF_UNKNOWN':
        return 'Uno de los proveedores seleccionados aún no está validado '
            'en la plataforma. Si lo acabas de crear, espera unos segundos '
            'y reintenta; si persiste, agrega un teléfono al proveedor y '
            'vuelve a intentar.';
      case 'TOO_MANY_TARGETS':
        return 'Máximo $kMaxVendorsPerPurchaseRequest proveedores por '
            'solicitud.';
      case 'DUPLICATE_VENDOR_CONTACTS':
        return 'Hay proveedores duplicados en la selección. Revísalos y '
            'vuelve a intentar.';
      case 'EMPTY_VENDOR_REFS':
        return 'Selecciona al menos un proveedor antes de enviar.';
      case 'CONFLICTING_VENDOR_REFS':
        return 'La solicitud mezcla formatos de proveedor incompatibles. '
            'Contacta a soporte.';
      case 'ASSET_REQUIRED_FOR_ASSET_ORIGIN':
        return 'Debes seleccionar un activo cuando el origen es "Activo '
            'específico".';
      case 'ASSET_ID_WITHOUT_ASSET_ORIGIN':
        return 'El activo solo aplica cuando el origen es "Activo '
            'específico". Cambia el origen o quita el activo.';
      case 'INVALID_CONTEXT':
        return 'No hay organización activa. Selecciona una organización y '
            'vuelve a intentar.';
      default:
        final trimmed = e.message.trim();
        if (trimmed.isEmpty) {
          return 'No se pudo enviar la solicitud (HTTP ${e.statusCode}).';
        }
        return trimmed;
    }
  }

  /// Título auto-generado cuando el usuario no escribió uno explícito.
  /// Compone una etiqueta legible a partir del tipo de activo precontexto +
  /// la naturaleza (producto/servicio) + categoría si existe. El backend
  /// sigue exigiendo `title` no vacío; esto lo garantiza sin exponer un campo
  /// extra al usuario.
  String _autoGenerateTitle() {
    final nature = type.value == PurchaseRequestTypeInput.service
        ? 'Servicio'
        : 'Producto';
    final typeLabel = selectedAssetType.value == null
        ? null
        : _assetTypeSingular(selectedAssetType.value!);
    final cat = category.value.trim();
    final parts = <String>[
      nature,
      if (typeLabel != null) typeLabel,
      if (cat.isNotEmpty) cat,
    ];
    return parts.join(' · ');
  }

  String _assetTypeSingular(AssetType t) {
    switch (t) {
      case AssetType.vehicle:
        return 'Vehículo';
      case AssetType.realEstate:
        return 'Inmueble';
      case AssetType.machinery:
        return 'Maquinaria';
      case AssetType.equipment:
        return 'Equipo';
    }
  }

  void _resetAfterSubmit() {
    // Limpieza de selección para no arrastrar estado entre submits sucesivos.
    // Los campos de texto los limpia la page (es dueña de los TextEditingController).
    selectedVendorIds.clear();
    // Tras el submit, el backend ya creó attestation para los proveedores
    // fresh enviados. Limpiar el set evita que un segundo submit sobre un
    // form reabierto vuelva a pedir attestSelf=true innecesariamente.
    _freshlyCreatedVendorIds.clear();
    lastSubmitError.value = null;
    clearAsset();
    clearVehicleSpec();
    setDeliveryEnabled(false);
  }

  /// Construye el snapshot persistible a partir del spec derivado.
  VehicleSpecSnapshotInput _buildVehicleSpecSnapshot(VehicleSpec s) {
    return VehicleSpecSnapshotInput(
      vehicleSpecId: s.id,
      displayLabel: s.displayLabel,
      make: s.makeLabel,
      model: s.modelLabel,
      year: s.year,
      version: s.version,
      motorization: s.motorization,
      engineDisplacementCc: s.engineDisplacementCc,
      transmission: s.transmission,
      linkedAssetsCountSnapshot: s.linkedAssetsCount,
    );
  }
}

// ============================================================================
// lib/presentation/controllers/provider/bootstrap/provider_bootstrap_controller.dart
// PROVIDER BOOTSTRAP CONTROLLER — wizard de auto-onboarding (MF1).
//
// QUÉ HACE:
//   Orquesta el wizard 3 pasos:
//     0) Identidad: name + phone (TextField).
//     1) Tipos de activo: multi-select sobre WorkspaceAssetTypeRepository.
//        Es prerequisito de Step 2 porque SelectSpecialtiesPage filtra por
//        assetType (contrato del catálogo backend).
//     2) Especialidades: lanza SelectSpecialtiesPage existente con el
//        primer assetType seleccionado como anchor y captura el resultado
//        (SpecialtiesSelectionResult).
//   En el submit final llama POST /v1/providers/bootstrap con los IDs
//   recolectados y, en éxito, navega a /provider/me.
//
// QUÉ NO HACE:
//   - NO duplica la UI del selector de specialties (reusa
//     SelectSpecialtiesPage / SelectSpecialtiesController).
//   - NO persiste estado intermedio: el usuario debe completar el wizard
//     en una sesión.
//
// REUSE:
//   - DIContainer().providerSelfRepository (MF1).
//   - DIContainer().workspaceAssetTypeRepository (existente).
//   - SelectSpecialtiesPage + SpecialtiesSelectionResult (existente).
//
// ENTERPRISE NOTES:
//   - Validaciones por paso: name no vacío (Step 0), specialties no
//     vacías (Step 1). assetTypes opcionales (Step 2).
//   - Manejo de errores tipados: PROVIDER_ALREADY_BOOTSTRAPPED redirige
//     a /provider/me; el resto se muestra en `error` UX.
// ============================================================================

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../data/datasources/local/registration_intent_ds.dart';
import '../../../../domain/entities/workspace/workspace_asset_type_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/provider/provider_self_repository.dart';
import '../../../../domain/services/access/asset_class_catalog.dart';
import '../../../../domain/services/catalog/specialty_grouping.dart';
import '../../../../routes/app_routes.dart';
import '../specialties/specialties_selection_result.dart';

/// Pasos del wizard. Orden estable y verificable por test.
///
/// ORDEN: identity → assetTypes → specialties. AssetTypes es prerequisito
/// de specialties porque SelectSpecialtiesPage filtra por assetType
/// (contrato del catálogo backend `/v1/catalog/specialties`).
enum ProviderBootstrapStep {
  identity, // name + phone
  assetTypes, // selector multi (al menos uno requerido)
  specialties, // selector via SelectSpecialtiesPage anclado a primer assetType
}

class ProviderBootstrapController extends GetxController {
  final ProviderSelfRepository _selfRepo =
      DIContainer().providerSelfRepository;

  // ─── Wizard state ──────────────────────────────────────────────────────
  final Rx<ProviderBootstrapStep> step =
      Rx<ProviderBootstrapStep>(ProviderBootstrapStep.identity);

  /// Step 0 — Identidad.
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  /// Step 2 — Tipo de oferta del proveedor (Producto / Servicio / Ambos).
  ///
  /// Estado UI clasificatorio comercial — NO es rol ni capability. Se usa
  /// para:
  ///   1. filtrar la lista de specialties que se le ofrecen al usuario
  ///      (vía `initialKind` en el binding del selector),
  ///   2. habilitar el botón "Elegir especialidades" (no se puede abrir
  ///      el selector sin haber clasificado el negocio primero).
  ///
  /// `null` = aún no seleccionado. El usuario debe elegir uno antes de
  /// avanzar al selector; `canAdvanceFromOffer` lo enforza.
  final Rx<SpecialtyOfferType?> offerType = Rx<SpecialtyOfferType?>(null);

  /// Step 2 — Especialidades. `details` se preserva para mostrar resumen
  /// en el siguiente step sin reconsultar el catálogo.
  final RxSet<String> specialtyIds = <String>{}.obs;
  final RxList<SpecialtySelectionDetail> specialtyDetails =
      <SpecialtySelectionDetail>[].obs;

  /// Step 2 — Tipos de activo del workspace activo (catálogo derivado).
  final RxList<WorkspaceAssetTypeEntity> availableAssetTypes =
      <WorkspaceAssetTypeEntity>[].obs;
  final RxBool loadingAssetTypes = false.obs;
  final RxString assetTypesError = ''.obs;
  final RxSet<String> assetTypeIds = <String>{}.obs;

  /// Estado del submit final.
  final RxBool submitting = false.obs;
  final RxString error = ''.obs;

  /// `true` mientras el onInit hace el check idempotente (`me()`). UI muestra
  /// loading global hasta que se resuelva el check.
  final RxBool initializing = true.obs;

  // ─── Onboarding gate idempotente ──────────────────────────────────────
  //
  // Cuando alguien navega a /provider/bootstrap y ya es proveedor (caso de
  // re-login, drawer del workspace, append-mode del registro), debemos
  // saltar el wizard. El controller llama me() en onInit y, si
  // `isProvider=true`, redirige a /provider/me. Si me() falla
  // (ej. WORKSPACE_NOT_FOUND porque el bootstrap base aún no ocurrió),
  // mostramos un Snackbar accionable.

  @override
  void onInit() {
    super.onInit();
    _runIdempotentCheck();
  }

  Future<void> _runIdempotentCheck() async {
    initializing.value = true;
    try {
      final me = await _selfRepo.me();
      if (me.isProvider) {
        // Ya es proveedor en este workspace → saltar wizard. Limpiar el
        // onboarding intent (si quedó residual) para que el splash NO
        // vuelva a empujar a /provider/bootstrap en arranques siguientes.
        await RegistrationIntentDS().clear();
        Get.offAllNamed(Routes.providerWorkspaceServices);
        return;
      }
      // No es proveedor todavía → arrancar wizard.
    } on UnauthorizedException catch (e) {
      error.value = 'Sesión inválida. Vuelve a iniciar sesión. (${e.message})';
    } on WorkspaceNotFoundException catch (_) {
      // Bootstrap base no completado: el wizard /provider/bootstrap NO
      // puede operar sin workspace. Mostramos el error visible y ofrecemos
      // volver a la home; el flujo de registro debe pasar primero por
      // registerSummary para crear el workspace.
      error.value =
          'Tu cuenta no tiene workspace activo. Completa el registro '
          'antes de configurar el proveedor.';
    } on NetworkException catch (_) {
      error.value = 'Sin conexión. Reintenta cuando tengas red.';
    } on ServerException catch (e) {
      error.value =
          'Error del servidor (${e.statusCode}). Intenta más tarde.';
    } on BadRequestException catch (e) {
      // Cualquier 4xx no esperado en `me()` (no debería ocurrir).
      error.value = e.message;
    } finally {
      initializing.value = false;
    }
  }

  // ─── Validaciones por paso ────────────────────────────────────────────

  bool get canAdvanceFromIdentity => nameCtrl.text.trim().isNotEmpty;

  bool get canAdvanceFromAssetTypes => assetTypeIds.isNotEmpty;

  /// `true` cuando el usuario ya escogió tipo de oferta. El botón
  /// "Elegir especialidades" se habilita solo bajo esta condición.
  bool get canOpenSpecialtyPicker => offerType.value != null;

  bool get canAdvanceFromSpecialties =>
      offerType.value != null && specialtyIds.isNotEmpty;

  bool get canSubmit =>
      canAdvanceFromIdentity &&
      canAdvanceFromAssetTypes &&
      canAdvanceFromSpecialties &&
      !submitting.value;

  /// AssetType "ancla" para invocar SelectSpecialtiesPage. Por contrato
  /// del backend, el selector exige UN assetType específico — usamos el
  /// primero seleccionado en el Step 1 como referencia. Si el provider
  /// declaró varios assetTypes, todos van al payload de bootstrap pero
  /// la pantalla de specialties solo se ancla a uno (limitación UI MF1).
  String? get specialtyPickerAssetType =>
      assetTypeIds.isNotEmpty ? assetTypeIds.first : null;

  // ─── Navegación entre pasos ───────────────────────────────────────────

  void next() {
    error.value = '';
    switch (step.value) {
      case ProviderBootstrapStep.identity:
        if (!canAdvanceFromIdentity) {
          error.value = 'Ingresa un nombre.';
          return;
        }
        step.value = ProviderBootstrapStep.assetTypes;
        // Cargar assetTypes la primera vez que entramos.
        if (availableAssetTypes.isEmpty && !loadingAssetTypes.value) {
          _loadAssetTypes();
        }
        break;
      case ProviderBootstrapStep.assetTypes:
        if (!canAdvanceFromAssetTypes) {
          error.value = 'Elige al menos un tipo de activo.';
          return;
        }
        step.value = ProviderBootstrapStep.specialties;
        break;
      case ProviderBootstrapStep.specialties:
        // Sin paso siguiente — el botón en este step llama a submit().
        break;
    }
  }

  void back() {
    error.value = '';
    switch (step.value) {
      case ProviderBootstrapStep.identity:
        // No hay back desde el primer paso.
        break;
      case ProviderBootstrapStep.assetTypes:
        step.value = ProviderBootstrapStep.identity;
        break;
      case ProviderBootstrapStep.specialties:
        step.value = ProviderBootstrapStep.assetTypes;
        break;
    }
  }

  // ─── Step 2 — Selector de tipo de oferta ──────────────────────────────

  /// Setea el tipo de oferta y limpia la selección de specialties si
  /// cambió respecto al valor anterior.
  ///
  /// La limpieza es deliberada: si el usuario seleccionó "Productos" y
  /// marcó 5 specialties, luego cambia a "Servicios", esas 5 son
  /// PRODUCTos y no aplican al nuevo filtro. Es más honesto re-empezar
  /// la selección que enviarlas al backend (donde serían rechazadas con
  /// `SPECIALTY_ASSET_TYPE_INCOMPATIBLE` o equivalente).
  void setOfferType(SpecialtyOfferType value) {
    if (offerType.value == value) return;
    offerType.value = value;
    specialtyIds.clear();
    specialtyDetails.clear();
  }

  /// Mapea el `offerType` activo al wireName que el binding del selector
  /// entiende (`'PRODUCT' | 'SERVICE' | null`). El selector traduce
  /// `null` a "sin pre-filtro" (caso "Ambos"), donde la lista llega
  /// completa y la UI agrupa en dos secciones.
  String? get specialtyPickerInitialKindWire {
    final kind = offerType.value?.toQueryKind();
    return kind?.wireName;
  }

  /// Copy en español del valor seleccionado de `offerType` para mostrar
  /// dentro de la card del wizard. Vacío cuando no hay selección.
  String get offerTypeLabel {
    switch (offerType.value) {
      case SpecialtyOfferType.product:
        return 'Producto';
      case SpecialtyOfferType.service:
        return 'Servicio';
      case SpecialtyOfferType.both:
        return 'Productos y servicios';
      case null:
        return '';
    }
  }

  // ─── Step 2 — Selector de especialidades ──────────────────────────────

  /// Aplica el resultado del SelectSpecialtiesPage (Get.back con
  /// SpecialtiesSelectionResult). El caller (UI) llama esto tras la
  /// navegación.
  void applySpecialtiesResult(SpecialtiesSelectionResult result) {
    specialtyIds
      ..clear()
      ..addAll(result.ids);
    specialtyDetails
      ..clear()
      ..addAll(result.details);
  }

  // ─── Step 2 — AssetTypes ──────────────────────────────────────────────

  /// Carga los tipos de activos OFRECIBLES por el proveedor.
  ///
  /// Fuente: `AssetClassCatalog` — catálogo global cliente con los 5 ids
  /// canónicos top-level (`vehicle`, `real_estate`, `machinery`,
  /// `equipment`, `other`) que el backend reconoce como AssetType raíces
  /// vivas (`ASSET_CLASS_TO_ROOT_ID` en
  /// `avanzza-core-api/src/modules/core-common/asset-actor-link/constants/
  /// asset-class.ts`).
  ///
  /// IMPORTANTE: este selector NO es "qué opera HOY el workspace" sino
  /// "qué declara cubrir el proveedor". Por eso NO depende de
  /// `WorkspaceAssetTypeRepository` (cuya respuesta puede ser vacía para
  /// proveedores nuevos sin activos registrados — bug pre-fix). Cuando
  /// Core API publique `GET /v1/catalog/asset-types`, esta función debe
  /// migrar a consumirlo y dejar el catálogo cliente como fallback.
  Future<void> _loadAssetTypes() async {
    loadingAssetTypes.value = true;
    assetTypesError.value = '';
    try {
      availableAssetTypes.assignAll(AssetClassCatalog.list());
    } finally {
      loadingAssetTypes.value = false;
    }
  }

  /// Re-intenta la carga (no-op real hoy: el catálogo es local). Lo
  /// preservamos por estabilidad de API hacia la UI; cuando exista el
  /// endpoint global, este método sí re-pegará al backend.
  Future<void> retryAssetTypes() async => _loadAssetTypes();

  void toggleAssetType(String id) {
    if (assetTypeIds.contains(id)) {
      assetTypeIds.remove(id);
    } else {
      assetTypeIds.add(id);
    }
  }

  // ─── Submit final ─────────────────────────────────────────────────────

  Future<void> submit() async {
    if (!canSubmit) {
      error.value = 'Completa los pasos anteriores.';
      return;
    }
    submitting.value = true;
    error.value = '';
    try {
      // El IDs específicos del result no se usan aquí — la pantalla
      // /provider/me hará su propio refresh y mostrará el estado fresco.
      await _selfRepo.bootstrap(
        name: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
        specialtyIds: specialtyIds.toList(growable: false),
        assetTypeIds:
            assetTypeIds.isEmpty ? null : assetTypeIds.toList(growable: false),
      );
      // Bootstrap exitoso: el onboarding intent queda satisfecho. Limpiar
      // antes de navegar para que próximos arranques sigan el flujo
      // canónico (/v1/providers/me decide).
      await RegistrationIntentDS().clear();
      Get.offAllNamed(Routes.providerWorkspaceServices);
    } on BadRequestException catch (e) {
      error.value = _humanizeBootstrapError(e);
      // Caso 409 PROVIDER_ALREADY_BOOTSTRAPPED → redirigir al /me.
      if (e.code == 'PROVIDER_ALREADY_BOOTSTRAPPED') {
        await RegistrationIntentDS().clear();
        Get.offAllNamed(Routes.providerWorkspaceServices);
      }
    } on UnauthorizedException catch (e) {
      error.value = 'Sesión inválida. Vuelve a iniciar sesión. (${e.message})';
    } on WorkspaceNotFoundException catch (_) {
      error.value =
          'Workspace no resuelto. Cierra sesión y vuelve a entrar.';
    } on NetworkException catch (_) {
      error.value = 'Sin conexión. Reintenta cuando tengas red.';
    } on ServerException catch (e) {
      error.value =
          'Error del servidor (${e.statusCode}). Intenta más tarde.';
    } finally {
      submitting.value = false;
    }
  }

  /// Mapper code → mensaje UX en español. Códigos no contemplados
  /// devuelven el mensaje del backend.
  String _humanizeBootstrapError(BadRequestException e) {
    switch (e.code) {
      case 'PROVIDER_ALREADY_BOOTSTRAPPED':
        return 'Ya tienes un proveedor en este workspace. Te redirigimos.';
      case 'EMPTY_SPECIALTY_LIST':
        return 'Elige al menos una especialidad.';
      case 'INVALID_SPECIALTY_IDS':
        return 'Una o más especialidades ya no existen. Recarga.';
      case 'INVALID_ASSET_TYPE_IDS':
        return 'Uno o más tipos de activo ya no existen.';
      case 'SPECIALTY_ASSET_TYPE_INCOMPATIBLE':
        return 'Las especialidades elegidas no cubren los tipos de activo seleccionados.';
      case 'USER_NOT_MEMBER_OF_WORKSPACE':
        return 'Tu cuenta no pertenece a este workspace.';
      case 'PLATFORM_ACTOR_KIND_MISMATCH':
        return 'Tu cuenta está vinculada a un actor incompatible. Contacta soporte.';
      default:
        return e.message;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}

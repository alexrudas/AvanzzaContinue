// ============================================================================
// lib/presentation/controllers/admin/network/provider_form_controller.dart
// PROVIDER FORM CONTROLLER — Alta y edición COMPLETA de proveedor
// ============================================================================
// QUÉ HACE:
//   - Maneja el estado del formulario completo de un proveedor (modo `create`
//     o `edit`) sobre la SSOT canónica `LocalContactEntity` con
//     `roleLabel = 'proveedor'`.
//   - En modo edit, hidrata desde `LocalContactRepository.getById` al onInit,
//     hidratando TODOS los campos del entity, incluidos `supplierType` y
//     `categories` legacy: se conservan en estado pasivo para reemisión en
//     `buildEntitySnapshot` y no perder datos antiguos. La UI canónica ya
//     NO los muestra (sección "Tipo y categorías" retirada en Hito 1; la
//     gobernanza viva en `ProviderProfile + ProviderSpecialty`).
//   - Persiste DIRECTAMENTE vía `LocalContactRepository.save(entity)` —
//     deliberadamente sin pasar por `SaveLocalContactWithProbe`: el alta y
//     la edición del formulario NO deben depender del probe remoto. El use
//     case del probe queda reservado a futuros flujos de identidad
//     transversal, fuera de alcance de esta fase.
//   - Expone `focusedSection` para que la UI pueda enfocar una sola sección
//     cuando el detalle abre "Editar" por sección — la persistencia sigue
//     trabajando con la entidad COMPLETA; "editar por sección" es UX, no un
//     contrato distinto.
//
// QUÉ NO HACE:
//   - NO crea write paths paralelos ni segundas fuentes de verdad.
//   - NO duplica validación estructural con el helper: la UI consume el
//     mismo `missingProviderProfileFields` para coherencia con el directorio.
//   - NO crea `LocalOrganization` si el proveedor es empresa (se persiste el
//     nombre comercial en `displayName`). Cuando el flujo empresa-NIT esté
//     habilitado se migrará aquí sin romper el resto.
//   - NO normaliza teléfonos/emails en cada keystroke (UX): normaliza al
//     construir el snapshot de guardado (`buildEntitySnapshot`).
//
// PRINCIPIOS:
//   - Controller de composición (ADR §15): no mini-backend, no replicates
//     estado que ya vive en el repo. Solo orquesta texto ↔ entidad ↔ save.
//   - Reactividad con `.obs` por campo. Al guardar, el stream del repo
//     emite el nuevo estado y las otras vistas se sincronizan solas.
//
// ENTERPRISE NOTES:
//   - `defaultCountryCallingCode` sigue la misma convención del resto de la
//     capa core_common: '57' (CO) por default.
//   - La cobertura funciona en dos modos mutuamente excluyentes:
//       · `coverageAllCountry=true` → envíos nacionales; `coverageCityIds`
//         se ignora y no debe mostrarse en UI.
//       · `coverageAllCountry=false` → lista manual en `coverageCityIds`.
//   - Si en el futuro se reintroduce el probe para altas desde este form,
//     basta con envolver el `_contacts.save(entity)` en un use case; el
//     resto del controller queda intacto.
//   - SPECIALTIES (2026-04-26, Hito 1 — integración canónica):
//     `save()` orquesta la cadena completa
//       LocalContact.save → match-candidate.probe → POST /v1/providers
//       → PUT /v1/providers/:id/specialties
//     contra Avanzza Core API. La SSOT de specialties vive en Postgres
//     (`ProviderSpecialty` table); este controller cachea
//     `linkedProviderProfileId` en `LocalContactEntity` tras un
//     `provision()` 2xx para que el siguiente save salte el POST y vaya
//     directo a GET + PUT (idempotencia eficiente).
//
//   - KILL-SWITCH ABSOLUTO: el primer statement de `save()` es
//     `if (!AppConfig.enableProviderSpecialtiesUI) return _contacts.save(...)`.
//     Cuando el flag está OFF, se preserva el flujo legacy puro (solo
//     persistencia local). Cero llamadas a Core API.
//
//   - BRANCHING POR linkedProviderProfileId:
//     · si está vinculado → SKIP POST, hacer GET + PUT specialties.
//     · si NO está vinculado → POST + cachear linked id ANTES del PUT,
//       para que un fallo en specialties no fuerce repetir el POST.
//
//   - AMBIGUOUS 409: el controller propaga
//     `AmbiguousPlatformActorException` para que la page la capture y
//     muestre snackbar técnico. Logging estructurado obligatorio antes
//     del rethrow para que soporte pueda intervenir manualmente.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/app_config.dart';
import '../../../../domain/entities/catalog/specialty_entity.dart' show SpecialtyKind;
import '../../../../domain/entities/core_common/constants/role_labels.dart';
import '../../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../../domain/entities/core_common/provider_branch_entity.dart';
import '../../../../domain/entities/core_common/value_objects/normalized_key.dart';
import '../../../../domain/entities/core_common/value_objects/supplier_type.dart';
import '../../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../../domain/entities/core_common/value_objects/verified_key_type.dart';
import '../../../../domain/entities/provider/provider_canonical_entity.dart';
import '../../../../domain/entities/workspace/workspace_asset_type_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../../domain/repositories/provider/provider_canonical_repository.dart';
import '../../../../domain/repositories/workspace/workspace_asset_type_repository.dart';
import '../../../../domain/services/core_common/key_normalizer.dart';
import '../../../../domain/services/core_common/local_contact_completeness.dart';
import '../../../../data/sources/remote/core_common/match_candidate_nestjs_ds.dart';
import 'provider_form_section.dart';

/// Modo del formulario.
enum ProviderFormMode { create, edit }

class ProviderFormController extends GetxController {
  final LocalContactRepository _contacts;
  final ProviderCanonicalRepository _providers;
  final MatchCandidateNestJsDataSource _matchCandidateProbe;
  final WorkspaceAssetTypeRepository _workspaceAssetTypes;
  final String _orgId;
  final String? _editingProviderId;
  final String _defaultCountryId;
  final String defaultCountryCallingCode;

  /// Sección que la UI debe enfocar cuando el form se abre en modo edit
  /// desde el detalle. `null` = mostrar el formulario completo.
  final ProviderFormSection? focusedSection;

  /// AssetType de contexto para el selector de specialties (e.g. `vehicle.car`).
  ///
  /// Inmutable para el ciclo de vida del controller cuando se inicializa con
  /// un valor no nulo. Si el caller necesita cambiarlo dinámicamente (caso
  /// improbable hoy), debe llamar `setAssetType()` — eso reinicia el state
  /// de specialties para evitar mezclar IDs de catálogos distintos.
  ///
  /// Si es `null`, el form NO requiere specialties (alta rápida sin contexto
  /// de activos), preservando el flujo actual de proveedores genéricos.
  final String? initialAssetType;

  /// Override del kill-switch para tests. `null` = usar
  /// `AppConfig.enableProviderSpecialtiesUI` (const en producción).
  /// **NO usar en código de producción** — único caller legítimo es el
  /// suite de tests del flujo orquestado.
  final bool? _canonicalIntegrationOverride;

  ProviderFormController({
    required LocalContactRepository contacts,
    required ProviderCanonicalRepository providers,
    required MatchCandidateNestJsDataSource matchCandidateProbe,
    required WorkspaceAssetTypeRepository workspaceAssetTypes,
    required String orgId,
    String? editingProviderId,
    required String defaultCountryId,
    this.focusedSection,
    this.defaultCountryCallingCode = '57',
    String? assetType,
    @visibleForTesting bool? enableCanonicalIntegrationOverride,
  })  : _contacts = contacts,
        _providers = providers,
        _matchCandidateProbe = matchCandidateProbe,
        _workspaceAssetTypes = workspaceAssetTypes,
        _orgId = orgId,
        _editingProviderId = editingProviderId,
        _defaultCountryId = defaultCountryId,
        initialAssetType = assetType,
        _canonicalIntegrationOverride = enableCanonicalIntegrationOverride;

  /// Effective state of the canonical integration kill-switch.
  /// Production: `AppConfig.enableProviderSpecialtiesUI`.
  /// Tests: override via constructor.
  bool get _canonicalIntegrationEnabled =>
      _canonicalIntegrationOverride ?? AppConfig.enableProviderSpecialtiesUI;

  // ── ESTADO REACTIVO DEL FORM ────────────────────────────────────────────

  final mode = ProviderFormMode.create.obs;

  /// Loading inicial (hidratación en edit).
  final isLoading = false.obs;

  /// Saving en curso (bloquea el botón).
  final isSaving = false.obs;

  /// Error humano no bloqueante (carga/guardado).
  final RxnString error = RxnString();

  // Datos básicos
  final displayName = ''.obs;
  final docId = ''.obs;

  // Contacto
  final primaryPhone = ''.obs;
  final secondaryPhone = ''.obs;
  final primaryEmail = ''.obs;
  final website = ''.obs;

  // Ubicación — reutiliza el sistema geo del proyecto (Region/City selectors).
  final countryId = RxnString();
  final regionId = RxnString();
  final cityId = RxnString();
  final addressLine = ''.obs;

  // Tipo y categorías
  final supplierType = Rxn<SupplierType>();
  final RxList<String> categories = <String>[].obs;

  // Cobertura
  final coverageAllCountry = false.obs;
  final RxList<String> coverageCityIds = <String>[].obs;

  // Sedes adicionales (la principal vive implícita en los campos geo del
  // propio proveedor). La lista es reactiva para que la UI se refresque
  // al agregar/editar/eliminar sin navegar fuera del form.
  final RxList<ProviderBranchEntity> additionalBranches =
      <ProviderBranchEntity>[].obs;

  // ╔══════════════════════════════════════════════════════════════════════╗
  // ║ INVARIANT — specialtyIds (estado UI EFÍMERO, A-mejorada)              ║
  // ║                                                                      ║
  // ║   `specialtyIds` es estado del form que NO se persiste en             ║
  // ║   `LocalContactEntity` ni en ningún almacén local. Vive solo         ║
  // ║   mientras vive el controller. La SSOT canónica (cuando exista)      ║
  // ║   estará en Core API (`/v1/providers/:id/specialties`).              ║
  // ║                                                                      ║
  // ║   `_specialtiesInitialized == true` ⇔ ya se sembró `specialtyIds`    ║
  // ║   con su valor inicial (vacío en create / vacío en edit hasta que    ║
  // ║   exista `GET /v1/providers/:id` / aplicado desde el selector).      ║
  // ║   Mientras sea `true`, NINGÚN refresh tardío del repo debe pisar     ║
  // ║   el set. El usuario YA INTERACTUÓ — su elección manda.              ║
  // ║                                                                      ║
  // ║   AssetType ortogonal: si `setAssetType()` cambia el contexto del    ║
  // ║   catálogo, `_specialtiesInitialized` se resetea a `false` y         ║
  // ║   `specialtyIds` se vacía. Razón: los IDs son del catálogo previo    ║
  // ║   y mezclar catálogos crearía referencias inválidas.                 ║
  // ║                                                                      ║
  // ║   Puntos de mutación canónicos:                                      ║
  // ║     · onInit() / _hydrateFromExisting() — sembrado vacío + flag=true ║
  // ║     · applySelectedSpecialties() — reemplazo total + flag=true       ║
  // ║     · setAssetType() — clear + flag=false                            ║
  // ╚══════════════════════════════════════════════════════════════════════╝

  /// IDs de specialties seleccionadas para el proveedor. SSOT del form.
  /// Reactivo para que el widget de "Especialidades" actualice el resumen
  /// ("3 especialidades seleccionadas") sin rebuild manual.
  final RxSet<String> specialtyIds = <String>{}.obs;

  /// Cache id → name de specialties seleccionadas, hidratado por
  /// `applySelectedSpecialtiesWithNames()` cada vez que el selector
  /// regresa con un `SpecialtiesSelectionResult`. Se usa exclusivamente
  /// para construir el resumen compacto del tile en el form (subtitle:
  /// "Mecánica general +2"). NO se persiste en LocalContact ni viaja al
  /// backend — los nombres viven en `Specialty.name` (Postgres) y se
  /// resuelven en cada apertura del selector.
  ///
  /// Si el cache está vacío pero `specialtyIds` no (caso EDIT recién
  /// hidratado desde `getById` antes de abrir el selector), el subtitle
  /// cae en el copy genérico "N especialidades seleccionadas".
  final RxMap<String, String> specialtyNames = <String, String>{}.obs;

  /// Guard contra overwrite tras interacción. Ver bloque INVARIANT arriba.
  /// `private` para que solo el controller pueda transicionarlo.
  bool _specialtiesInitialized = false;

  /// AssetType reactivo para el selector. Inicializado por el binding
  /// vía constructor; mutable solo a través de `setAssetType()`.
  late final Rxn<String> assetType = Rxn<String>(initialAssetType);

  /// "Tipo de Oferta" del proveedor (productos/servicios/ambos). Pre-filtro
  /// del catálogo de specialties — single-source-of-truth en el form. La
  /// page del selector recibe este valor como `initialKind` y lo aplica al
  /// fetch sin permitir cambiarlo dentro (toggle interno eliminado).
  ///
  /// ESTADO PURO UX — NO se persiste en LocalContactEntity ni se envía al
  /// backend. La taxonomía canónica del proveedor se infiere del set de
  /// specialties (cada specialty tiene su propio `kind` en backend); no
  /// existe atributo "ofertaKind" en `ProviderProfile`.
  ///
  /// Mutable solo a través de `setOfferKind()` para garantizar la regla
  /// de invalidación: cambiar el kind limpia `specialtyIds` (las
  /// specialties del kind anterior NO aplican al nuevo filtro).
  final Rxn<SpecialtyKind> offerKind = Rxn<SpecialtyKind>();

  /// Token de optimistic concurrency para el `PUT /:id/specialties`.
  /// Se setea tras `provision()` o `getById()` exitoso. Null hasta que
  /// el primer call al backend resuelva.
  DateTime? _providerUpdatedAt;

  /// AssetTypes que el workspace activo opera, derivados canónicamente
  /// de sus AssetActorLink activos vía
  /// `GET /v1/core-common/workspaces/me/asset-types`.
  ///
  /// Estados:
  ///   - `availableAssetTypesLoading == true` → cargando, dropdown disabled.
  ///   - `availableAssetTypesError != null`   → fallo, mostrar retry.
  ///   - lista vacía → workspace sin activos, copy "registra un activo
  ///     primero".
  ///   - lista no vacía → poblar dropdown.
  final RxList<WorkspaceAssetTypeEntity> availableAssetTypes =
      <WorkspaceAssetTypeEntity>[].obs;
  final RxBool availableAssetTypesLoading = false.obs;
  final RxnString availableAssetTypesError = RxnString();

  /// UUID estable usado por `buildEntitySnapshot()` durante el ciclo de
  /// vida del controller en **CREATE mode**.
  ///
  /// Se genera UNA SOLA VEZ (lazy en el primer `buildEntitySnapshot`) y se
  /// reutiliza en todas las invocaciones subsiguientes. Esto convierte un
  /// re-tap del botón "Guardar" en un upsert por id (idempotente sobre la
  /// misma fila local) en lugar de un INSERT duplicado.
  ///
  /// EDIT mode NO usa este campo: el id viene de `_original.id` o
  /// `_editingProviderId`, ambos estables por contrato.
  ///
  /// Diseño: `String?` lazy en lugar de `late final` para evitar el costo
  /// de `Uuid().v4()` cuando el controller solo se usa para hidratar y
  /// mostrar (sin invocar `buildEntitySnapshot`).
  String? _createModeContactId;

  // Observaciones (privado, nunca sincroniza)
  final notesPrivate = ''.obs;

  /// Snapshot original para edit mode (detectar si hay cambios). Null en create.
  LocalContactEntity? _original;

  // ── LIFECYCLE ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    if (_orgId.isEmpty) {
      error.value = 'Organización no disponible en la sesión.';
      return;
    }
    countryId.value = _defaultCountryId.isEmpty ? null : _defaultCountryId;
    if (_editingProviderId == null || _editingProviderId.isEmpty) {
      mode.value = ProviderFormMode.create;
      // SPECIALTIES — sembrado canónico de create: set vacío, flag true.
      // Ver bloque INVARIANT arriba. A partir de aquí, ningún path debe
      // sobrescribir `specialtyIds` excepto `applySelectedSpecialties()`
      // o `setAssetType()`.
      specialtyIds.clear();
      _specialtiesInitialized = true;
    } else {
      mode.value = ProviderFormMode.edit;
      _hydrateFromExisting(_editingProviderId);
    }
    // Cargar assetTypes del workspace activo para alimentar el dropdown
    // del selector de specialties. Fire-and-forget — la UI muestra
    // loading/empty/error según el state reactivo.
    if (_canonicalIntegrationEnabled) {
      unawaited(loadAvailableAssetTypes());
    }
  }

  /// Carga los assetTypes que el workspace activo opera, llamando al
  /// endpoint canónico de Core API. Idempotente: se puede llamar
  /// repetidamente (p. ej. desde un botón "Reintentar") sin efectos
  /// secundarios. La UI escucha los Rx para reflejar loading/empty/error.
  Future<void> loadAvailableAssetTypes() async {
    availableAssetTypesLoading.value = true;
    availableAssetTypesError.value = null;
    try {
      final list = await _workspaceAssetTypes.listActive();
      availableAssetTypes.assignAll(list);
    } on UnauthorizedException catch (e) {
      debugPrint('[ProviderFormController] assetTypes UNAUTHORIZED: ${e.message}');
      availableAssetTypesError.value = 'Tu sesión expiró.';
    } on NetworkException catch (e) {
      debugPrint('[ProviderFormController] assetTypes NETWORK: ${e.message}');
      availableAssetTypesError.value = 'Sin conexión.';
    } on ServerException catch (e) {
      debugPrint(
        '[ProviderFormController] assetTypes SERVER ${e.statusCode}: ${e.message}',
      );
      availableAssetTypesError.value = 'Error del servidor.';
    } catch (e) {
      debugPrint('[ProviderFormController] assetTypes load fail: $e');
      availableAssetTypesError.value = 'No se pudieron cargar los tipos de activo.';
    } finally {
      availableAssetTypesLoading.value = false;
    }
  }

  Future<void> _hydrateFromExisting(String id) async {
    try {
      isLoading.value = true;
      final existing = await _contacts.getById(id);
      if (existing == null) {
        error.value = 'No se encontró el proveedor para editar.';
        return;
      }
      _original = existing;
      displayName.value = existing.displayName;
      docId.value = existing.docId ?? '';
      primaryPhone.value = existing.primaryPhoneE164 ?? '';
      secondaryPhone.value = existing.secondaryPhoneE164 ?? '';
      primaryEmail.value = existing.primaryEmail ?? '';
      website.value = existing.website ?? '';
      countryId.value = (existing.countryId ?? '').isEmpty
          ? (_defaultCountryId.isEmpty ? null : _defaultCountryId)
          : existing.countryId;
      regionId.value = existing.regionId;
      cityId.value = existing.cityId;
      addressLine.value = existing.addressLine ?? '';
      supplierType.value = existing.supplierType;
      categories.assignAll(existing.categories);
      coverageAllCountry.value = existing.coverageAllCountry;
      coverageCityIds.assignAll(existing.coverageCityIds);
      additionalBranches.assignAll(existing.additionalBranches);
      notesPrivate.value = existing.notesPrivate ?? '';

      // SPECIALTIES — Hito 1 (integración canónica):
      // Si el contacto ya está vinculado a un ProviderProfile en backend
      // (`linkedProviderProfileId != null`) y la integración está activa,
      // hidratar specialties desde `GET /v1/providers/:id`. Si la
      // integración está OFF (kill-switch), se preserva el comportamiento
      // legacy: set vacío + flag true.
      if (!_specialtiesInitialized) {
        specialtyIds.clear();
        _specialtiesInitialized = true;
        final linkedId = existing.linkedProviderProfileId;
        if (linkedId != null &&
            linkedId.isNotEmpty &&
            _canonicalIntegrationEnabled) {
          // Hidratación remota fire-and-forget desde el lifecycle.
          // Si falla con 404 PROVIDER_PROFILE_NOT_FOUND, limpiamos el
          // cache local (linked id obsoleto). Si falla por red u otro
          // motivo, dejamos el set vacío y el usuario puede reintentar
          // tocando el selector — es defensivo, no bloquea el form.
          unawaited(_hydrateFromCanonicalProvider(linkedId, existing));
        }
      }
    } catch (e) {
      debugPrint('[ProviderFormController] hydrate fail: $e');
      error.value = 'No se pudo cargar el proveedor: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ── ACCIONES DE FORM ────────────────────────────────────────────────────

  void onCountryChanged(String? id) {
    countryId.value = (id ?? '').isEmpty ? null : id;
    // Si cambió el país, reseteamos región y ciudad (no son consistentes).
    regionId.value = null;
    cityId.value = null;
  }

  void onRegionChanged(String? id) {
    regionId.value = (id ?? '').isEmpty ? null : id;
    // Ciudad deja de ser válida si cambia región.
    cityId.value = null;
  }

  void onCityChanged(String? id) {
    cityId.value = (id ?? '').isEmpty ? null : id;
  }


  /// Activa/desactiva el toggle "Envíos a todo el país". Si se activa, se
  /// limpia la lista manual de ciudades (son excluyentes).
  void setCoverageAllCountry(bool value) {
    coverageAllCountry.value = value;
    if (value) {
      coverageCityIds.clear();
    }
  }

  /// Añade una ciudad a la cobertura manual. Ignorada si el modo nacional
  /// está activo.
  bool addCoverageCity(String cityIdValue) {
    if (coverageAllCountry.value) return false;
    if (cityIdValue.trim().isEmpty) return false;
    if (coverageCityIds.contains(cityIdValue)) return false;
    coverageCityIds.add(cityIdValue);
    return true;
  }

  void removeCoverageCity(String cityIdValue) {
    coverageCityIds.removeWhere((c) => c == cityIdValue);
  }

  // ── SEDES ADICIONALES ────────────────────────────────────────────────────

  /// Agrega o actualiza una sede por `id`. Si el id existe, reemplaza in-place
  /// (preservando el orden). Si es nueva, la añade al final de la lista.
  /// El caller es dueño de generar el id (uuid) al crear una sede nueva.
  void upsertBranch(ProviderBranchEntity branch) {
    final idx =
        additionalBranches.indexWhere((b) => b.id == branch.id);
    if (idx == -1) {
      additionalBranches.add(branch);
    } else {
      additionalBranches[idx] = branch;
    }
  }

  /// Elimina una sede por id.
  void removeBranch(String branchId) {
    additionalBranches.removeWhere((b) => b.id == branchId);
  }

  // ── SPECIALTIES (selector multi-select) ──────────────────────────────────

  /// Aplica el resultado del selector de specialties.
  ///
  /// CONTRATO: el selector devuelve estado COMPLETO (no parcial). Por eso
  /// hacemos `clear() + addAll()`, NO merge. Si el usuario deselecciona en
  /// el selector, ese cambio se refleja al volver al form.
  ///
  /// Marca `_specialtiesInitialized = true` para blindar el set ante un
  /// eventual refresh tardío del repo. Ver bloque INVARIANT arriba.
  ///
  /// El caller (ProviderFormPage) DEBE pasar el `Set<String>` retornado
  /// por `Get.toNamed<Set<String>>(Routes.selectSpecialties)`. Si el
  /// resultado es `null` (usuario salió sin guardar), NO llames a este
  /// método — la regla "cancelar = no cambiar estado" se preserva por
  /// omisión.
  void applySelectedSpecialties(Set<String> ids) {
    specialtyIds
      ..clear()
      ..addAll(ids);
    _specialtiesInitialized = true;
  }

  /// Variante que también hidrata el cache `specialtyNames` con los
  /// nombres de las specialties recién seleccionadas — usada por
  /// `_onPickSpecialties` cuando el selector devuelve
  /// `SpecialtiesSelectionResult` (que incluye id+name).
  ///
  /// El [namesById] DEBE contener una entry por cada id en [ids] (el
  /// selector lo garantiza para los IDs visibles bajo el filtro). Si
  /// algún id queda sin nombre por estar oculto bajo el filtro
  /// (`hiddenSelectedCount > 0` en el selector), no es problemático —
  /// el subtitle cae en el copy genérico para ese caso. La entrada
  /// faltante NO contamina el cache (solo se escriben las presentes).
  ///
  /// Reemplaza el cache completo (no merge) para evitar acumular
  /// nombres de specialties que ya no están seleccionadas.
  void applySelectedSpecialtiesWithNames(
    Set<String> ids,
    Map<String, String> namesById,
  ) {
    applySelectedSpecialties(ids);
    specialtyNames
      ..clear()
      ..addAll(namesById);
  }

  /// Subtítulo compacto del tile "Especialidades" en el form. Reglas
  /// (Hito 1.x — UX):
  ///
  ///   - 0 specialties → "Selecciona una o más especialidades"
  ///   - 1 specialty con nombre cacheado → "${name}"
  ///   - 1 specialty sin nombre cacheado (EDIT recién hidratado)
  ///     → "1 especialidad seleccionada"
  ///   - N>1 specialties con nombre primer ID cacheado
  ///     → "${firstName} +${N-1}"
  ///   - N>1 specialties sin nombre cacheado
  ///     → "$N especialidades seleccionadas"
  ///
  /// "Primer nombre" se elige como el primero que aparezca al iterar
  /// `specialtyIds` (Set unmodifiable). Como el orden en un Set no es
  /// determinístico para el caller en general, este copy es estable
  /// dentro de la misma sesión (el set Rx preserva orden de inserción
  /// hasta que `applySelectedSpecialties()` lo reescriba).
  String get specialtiesSummarySubtitle {
    final n = specialtyIds.length;
    if (n == 0) return 'Selecciona una o más especialidades';

    // Resuelve el "primer nombre" usando el primer id del set que
    // tenga entry en el cache. Si ningún id tiene cache (caso EDIT
    // antes de abrir el selector), cae al copy genérico.
    String? firstName;
    for (final id in specialtyIds) {
      final name = specialtyNames[id];
      if (name != null && name.isNotEmpty) {
        firstName = name;
        break;
      }
    }

    if (firstName == null) {
      return n == 1
          ? '1 especialidad seleccionada'
          : '$n especialidades seleccionadas';
    }
    if (n == 1) return firstName;
    return '$firstName +${n - 1}';
  }

  /// Cambia el assetType de contexto (catálogo de specialties al que apunta
  /// el selector).
  ///
  /// Si el nuevo valor difiere del actual, los `specialtyIds` previamente
  /// elegidos pertenecen a un catálogo distinto y se DESCARTAN para evitar
  /// referencias inválidas. El flag se resetea a `false` para que la
  /// próxima hidratación / aplicación canónica vuelva a sembrar el set.
  ///
  /// Si el valor es idéntico, es no-op.
  void setAssetType(String? newAssetType) {
    if (assetType.value == newAssetType) return;
    assetType.value = newAssetType;
    specialtyIds.clear();
    _specialtiesInitialized = false;
  }

  /// Cambia el "Tipo de Oferta" (PRODUCT | SERVICE | BOTH).
  ///
  /// Si el valor cambia, los `specialtyIds` previamente seleccionados
  /// pueden quedar fuera del nuevo filtro (ej. el usuario tenía
  /// servicios y cambia a productos). Para evitar conservar referencias
  /// incompatibles con el filtro recién elegido, se DESCARTAN. El flag
  /// `_specialtiesInitialized` se resetea para que la próxima apertura
  /// del selector vuelva a sembrar el set desde cero.
  ///
  /// Si el valor es idéntico, es no-op (preserva specialties seleccionadas).
  void setOfferKind(SpecialtyKind? newKind) {
    if (offerKind.value == newKind) return;
    offerKind.value = newKind;
    specialtyIds.clear();
    _specialtiesInitialized = false;
  }

  // ── DERIVADOS ────────────────────────────────────────────────────────────

  /// Construye un snapshot de la entidad con el estado actual del form.
  /// NO persiste: para preview y para validar completitud al vuelo.
  ///
  /// CONTRATO DE ID (importante para idempotencia):
  ///   - EDIT mode: id = `_original.id` (hidratado del repo) o
  ///     `_editingProviderId` (provisto por el binding). Ambos estables.
  ///   - CREATE mode: id = `_createModeContactId`, UUID v4 generado UNA
  ///     SOLA VEZ y cacheado en el campo. Cualquier llamada posterior a
  ///     `buildEntitySnapshot()` reutiliza el mismo id, así un re-tap del
  ///     botón "Guardar" se traduce en upsert por id (no INSERT duplicado).
  LocalContactEntity buildEntitySnapshot() {
    final now = DateTime.now().toUtc();
    final id = _original?.id ??
        _editingProviderId ??
        (_createModeContactId ??= const Uuid().v4());
    final created = _original?.createdAt ?? now;

    final phoneNorm = primaryPhone.value.trim().isEmpty
        ? null
        : normalizePhoneE164(
            primaryPhone.value.trim(),
            defaultCountryCallingCode: defaultCountryCallingCode,
          );
    final altPhoneNorm = secondaryPhone.value.trim().isEmpty
        ? null
        : normalizePhoneE164(
            secondaryPhone.value.trim(),
            defaultCountryCallingCode: defaultCountryCallingCode,
          );
    final emailNorm = primaryEmail.value.trim().isEmpty
        ? null
        : normalizeEmail(primaryEmail.value.trim());
    final docNorm = docId.value.trim().isEmpty
        ? null
        : normalizeDocId(docId.value.trim());

    return LocalContactEntity(
      id: id,
      workspaceId: _orgId,
      displayName: displayName.value.trim(),
      createdAt: created,
      updatedAt: now,
      organizationId: _original?.organizationId,
      roleLabel: kRoleLabelVendor,
      primaryPhoneE164: phoneNorm,
      primaryEmail: emailNorm,
      docId: docNorm,
      notesPrivate:
          notesPrivate.value.trim().isEmpty ? null : notesPrivate.value.trim(),
      tagsPrivate: _original?.tagsPrivate ?? const <String>[],
      snapshotSourcePlatformActorId: _original?.snapshotSourcePlatformActorId,
      snapshotAdoptedAt: _original?.snapshotAdoptedAt,
      isDeleted: _original?.isDeleted ?? false,
      deletedAt: _original?.deletedAt,
      supplierType: supplierType.value,
      categories: List<String>.unmodifiable(categories),
      countryId: countryId.value,
      regionId: regionId.value,
      cityId: cityId.value,
      addressLine:
          addressLine.value.trim().isEmpty ? null : addressLine.value.trim(),
      secondaryPhoneE164: altPhoneNorm,
      website: website.value.trim().isEmpty ? null : website.value.trim(),
      coverageAllCountry: coverageAllCountry.value,
      coverageCityIds: coverageAllCountry.value
          ? const <String>[]
          : List<String>.unmodifiable(coverageCityIds),
      additionalBranches:
          List<ProviderBranchEntity>.unmodifiable(additionalBranches),
      // `specialtyIds` NO se persiste en LocalContactEntity (la SSOT
      // canónica vive en Postgres via `ProviderSpecialty`). Lo que SÍ
      // se persiste es `linkedProviderProfileId`, que actúa como puente
      // entre la libreta local del workspace y el ProviderProfile
      // canónico del backend.
      linkedProviderProfileId: _original?.linkedProviderProfileId,
    );
  }

  /// Lista de campos faltantes para que la entidad cuente como "completa".
  List<String> get missingFields =>
      missingProviderProfileFields(buildEntitySnapshot());

  bool get isComplete => missingFields.isEmpty;

  // ── SUBMIT ──────────────────────────────────────────────────────────────

  /// Validaciones mínimas para poder ejecutar un save (aunque la entidad
  /// no esté "completa" por la regla de completeness). El save parcial está
  /// permitido: el flujo trabaja con borrador → completo.
  ///
  /// SPECIALTIES: NO se valida (decisión A-mejorada del audit del 2026-04-25).
  /// La selección de specialties no se persiste en `LocalContactEntity` —
  /// vive solo como estado UI efímero hasta que Core API exponga
  /// `POST /v1/providers` + `PUT /v1/providers/:id/specialties`.
  /// Bloquear el save por un campo que el sistema no puede persistir aún
  /// frustraría al usuario sin razón. Cuando exista persistencia real,
  /// evaluar si re-introducir aquí la regla "≥1 specialty si hay assetType".
  String? validateForSave() {
    if (_orgId.isEmpty) return 'Sesión sin organización activa.';
    if (displayName.value.trim().isEmpty) {
      return 'El nombre del proveedor es obligatorio.';
    }
    // Email: si hay texto, debe parecer email.
    final email = primaryEmail.value.trim();
    if (email.isNotEmpty && !email.contains('@')) {
      return 'El correo no tiene un formato válido.';
    }
    // Website: si hay texto, chequeo mínimo (. y no espacios).
    final web = website.value.trim();
    if (web.isNotEmpty && (web.contains(' ') || !web.contains('.'))) {
      return 'La página web no tiene un formato válido.';
    }
    return null;
  }

  /// Orquesta el guardado canónico:
  ///   1. KILL-SWITCH: si `enableProviderSpecialtiesUI=false` → solo
  ///      persistencia local (flujo legacy puro).
  ///   2. Persistencia local del contacto.
  ///   3. Si source.kind=LOCAL_* → match-candidate.probe (registra
  ///      LocalRefAttestation, evita 404 LOCAL_REF_NOT_FOUND).
  ///   4. BRANCHING:
  ///      - Si `linkedProviderProfileId != null` → GET (verificar) + PUT.
  ///      - Si null → POST + cachear linked id + PUT.
  ///   5. PUT replaceSpecialties (solo si specialtyIds.isNotEmpty).
  ///
  /// Retorna `null` si OK, mensaje humano si algo falló.
  /// Lanza `AmbiguousPlatformActorException` para que la page la capture
  /// (page muestra snackbar técnico + log estructurado).
  Future<String?> save() async {
    final v = validateForSave();
    if (v != null) return v;

    // ── KILL-SWITCH ABSOLUTO ──
    // Cuando la integración canónica está deshabilitada, preservar el
    // flujo legacy puro: persistir solo LocalContact y retornar OK.
    // NUNCA disparar probe/provision/replace en este path.
    if (!_canonicalIntegrationEnabled) {
      try {
        isSaving.value = true;
        await _contacts.save(buildEntitySnapshot());
        return null;
      } catch (e) {
        debugPrint('[ProviderFormController] save (legacy) fail: $e');
        return 'No se pudo guardar el proveedor: $e';
      } finally {
        isSaving.value = false;
      }
    }

    try {
      isSaving.value = true;
      // Construye el snapshot ANTES de la primera escritura. El id es un
      // UUID v4 estable (cliente-generado) → upserts posteriores por id.
      final entity = buildEntitySnapshot();
      await _contacts.save(entity);

      // Probe sólo cuando vamos a llamar `provision()` (CREATE flow).
      // En EDIT flow el provider ya existe en backend; el probe sería
      // innecesario.
      final isCreateFlow = entity.linkedProviderProfileId == null ||
          entity.linkedProviderProfileId!.isEmpty;

      if (isCreateFlow) {
        await _runProbeForLocalContact(entity);
      }

      // Branching POST vs GET.
      ProviderCanonicalEntity provider;
      if (isCreateFlow) {
        try {
          provider = await _providers.provision(
            _buildProvisionInput(entity),
          );
        } on AmbiguousPlatformActorException catch (e) {
          // Logging estructurado obligatorio antes de propagar — soporte
          // necesita los candidates para intervenir manualmente.
          debugPrint(
            '[ProviderFormController] event=PROVIDER_AMBIGUOUS_MATCH_BLOCKED_UI '
            'workspaceId=$_orgId localId=${entity.id} '
            'candidatesCount=${e.candidates.length} '
            'candidatePlatformActorIds=${e.candidates.map((c) => c.platformActorId).toList()} '
            'matchedKeyTypes=${e.candidates.expand((c) => c.matchedKeys).toSet().toList()}',
          );
          rethrow; // la page captura el throw y muestra snackbar técnico
        }

        // Cache del linked id INMEDIATAMENTE tras provision exitoso,
        // ANTES del PUT de specialties. Si specialties falla, el cache
        // ya está válido y el siguiente intento salta el POST.
        await _contacts.save(entity.copyWith(
          linkedProviderProfileId: provider.providerProfileId,
        ));
        _providerUpdatedAt = provider.updatedAt;
      } else {
        // EDIT flow: GET para verificar existencia + tenancy y obtener
        // updatedAt fresco para optimistic concurrency del PUT.
        final linkedId = entity.linkedProviderProfileId!;
        try {
          provider = await _providers.getById(linkedId);
          _providerUpdatedAt = provider.updatedAt;
        } on ProviderProfileNotFoundException {
          // El linked id está obsoleto (provider eliminado en backend).
          // Limpiar cache local y caer al CREATE flow disparando
          // recursivamente el save(). Cero loop infinito porque tras la
          // limpieza linkedProviderProfileId == null y entrará al
          // CREATE branch.
          debugPrint(
            '[ProviderFormController] linkedProviderProfileId obsoleto, '
            'limpiando cache y reintentando como CREATE flow.',
          );
          _original = entity.copyWith(linkedProviderProfileId: null);
          await _contacts.save(_original!);
          isSaving.value = false; // libera el guard antes del recurse
          return save();
        }
      }

      // PUT specialties — sólo si el usuario eligió alguna.
      if (specialtyIds.isNotEmpty) {
        provider = await _providers.replaceSpecialties(
          providerProfileId: provider.providerProfileId,
          specialtyIds: Set<String>.from(specialtyIds),
          providerProfileUpdatedAt: _providerUpdatedAt!,
        );
        _providerUpdatedAt = provider.updatedAt;
      }

      return null;
    } on AmbiguousPlatformActorException {
      // Re-lanzar tras log para que la page atrape con candidates.
      rethrow;
    } on LocalRefNotFoundException catch (e) {
      debugPrint('[ProviderFormController] LOCAL_REF_NOT_FOUND: ${e.message}');
      return 'Por favor reintenta. Si el problema persiste, contacta soporte.';
    } on WorkspaceNotFoundException catch (e) {
      debugPrint('[ProviderFormController] WORKSPACE_NOT_FOUND: ${e.message}');
      return 'Tu workspace aún no está activo. Contacta soporte.';
    } on UnauthorizedException catch (e) {
      debugPrint('[ProviderFormController] UNAUTHORIZED: ${e.message}');
      return 'Tu sesión expiró. Vuelve a iniciar sesión.';
    } on NetworkException catch (e) {
      debugPrint('[ProviderFormController] NETWORK: ${e.message}');
      return 'Sin conexión. Reintenta.';
    } on ServerException catch (e) {
      debugPrint('[ProviderFormController] SERVER ${e.statusCode}: ${e.message}');
      return 'Error del servidor. Reintenta más tarde.';
    } on BadRequestException catch (e) {
      debugPrint(
        '[ProviderFormController] BAD_REQUEST ${e.statusCode} '
        'code=${e.code}: ${e.message}',
      );
      return e.message;
    } catch (e) {
      debugPrint('[ProviderFormController] save fail: $e');
      return 'No se pudo guardar el proveedor: $e';
    } finally {
      isSaving.value = false;
    }
  }

  // ── HIDRATACIÓN CANÓNICA EN EDIT MODE ───────────────────────────────────

  /// Carga specialties asignadas desde `GET /v1/providers/:id` y las aplica
  /// al state del form. Idempotente con `_specialtiesInitialized`.
  ///
  /// Errores tolerados:
  /// - `ProviderProfileNotFoundException` (404): el linked id está obsoleto.
  ///   Limpiar el cache local para que el siguiente save sea CREATE flow.
  /// - Cualquier otro error: log + dejar el set vacío. El usuario puede
  ///   tocar el selector para refrescar manualmente.
  Future<void> _hydrateFromCanonicalProvider(
    String linkedProviderProfileId,
    LocalContactEntity existing,
  ) async {
    try {
      final provider = await _providers.getById(linkedProviderProfileId);
      _providerUpdatedAt = provider.updatedAt;
      specialtyIds
        ..clear()
        ..addAll(provider.specialties.map((s) => s.id));
    } on ProviderProfileNotFoundException {
      debugPrint(
        '[ProviderFormController] linked provider obsoleto en hidratación; '
        'limpiando cache local.',
      );
      try {
        await _contacts.save(existing.copyWith(linkedProviderProfileId: null));
        _original = existing.copyWith(linkedProviderProfileId: null);
      } catch (e) {
        debugPrint(
          '[ProviderFormController] no se pudo limpiar linked id obsoleto: $e',
        );
      }
    } catch (e) {
      // Cualquier otro error es no-fatal — la UI sigue usable y el set
      // queda vacío. El usuario puede reintentar tocando el selector.
      debugPrint(
        '[ProviderFormController] hidratación canónica falló: $e',
      );
    }
  }

  // ── PROBE + INPUT BUILDERS ──────────────────────────────────────────────

  /// Dispara `match-candidate.probe` para registrar el LocalRefAttestation
  /// del contacto en backend. Evita 404 LOCAL_REF_NOT_FOUND en `provision()`.
  Future<void> _runProbeForLocalContact(LocalContactEntity entity) async {
    final probes = _extractNormalizedKeys(entity);
    // El probe es válido aunque la lista esté vacía: registra el
    // LocalRefAttestation por (workspace, localKind, localId) sin afectar
    // identidad. Sin embargo, hoy una lista vacía no aporta valor al
    // matcher, así que skip-emos la llamada en ese caso.
    if (probes.isEmpty) return;
    try {
      await _matchCandidateProbe.probe(
        localKind: TargetLocalKind.contact,
        localId: entity.id,
        probes: probes,
      );
    } catch (e) {
      // El probe es defensivo. Si falla, dejamos que `provision()` reciba
      // el 404 LOCAL_REF_NOT_FOUND y lo propague al usuario; NO swallowing.
      debugPrint('[ProviderFormController] probe failed (no rethrow): $e');
    }
  }

  /// Extrae los probes ya normalizados desde el entity recién persistido.
  List<NormalizedKey> _extractNormalizedKeys(LocalContactEntity entity) {
    final out = <NormalizedKey>[];
    final phone = entity.primaryPhoneE164;
    if (phone != null && phone.isNotEmpty) {
      out.add(NormalizedKey(
        keyType: VerifiedKeyType.phoneE164,
        normalizedValue: phone,
      ));
    }
    final email = entity.primaryEmail;
    if (email != null && email.isNotEmpty) {
      out.add(NormalizedKey(
        keyType: VerifiedKeyType.email,
        normalizedValue: email,
      ));
    }
    final doc = entity.docId;
    if (doc != null && doc.isNotEmpty) {
      out.add(NormalizedKey(
        keyType: VerifiedKeyType.docId,
        normalizedValue: doc,
      ));
    }
    return out;
  }

  /// Construye el input para `POST /v1/providers` desde el entity local
  /// recién persistido + el state del form.
  ///
  /// Decisión de `actorKind`: el form actual no expone explícitamente la
  /// distinción person/organization. Se cae a `organization` por default
  /// (concordante con el flujo canónico de proveedores comerciales). Si
  /// el form en el futuro expone un selector explícito, este helper es el
  /// único punto a actualizar.
  ProvisionProviderInput _buildProvisionInput(LocalContactEntity entity) {
    final source = ProvisionProviderSource.localContact(localId: entity.id);

    // Heurística mínima: si docId parece NIT (10 dígitos típicos) o el
    // displayName trae sufijos legales comunes, lo tratamos como
    // organization. En cualquier otro caso → organization (default
    // operativo del flujo). El backend valida coherencia y devuelve 400
    // INVALID_ACTOR_IDENTITY si los campos no concuerdan.
    const actorKind = ProviderActorKind.organization;
    final identity = ProvisionProviderIdentity(
      displayName: entity.displayName,
      actorKind: actorKind,
      legalName: entity.displayName, // razón social = displayName por default
    );

    final probes = _extractNormalizedKeys(entity)
        .map(
          (k) => ProvisionProviderProbe(
            keyTypeWire: k.keyType.wireName,
            normalizedValue: k.normalizedValue,
          ),
        )
        .toList(growable: false);

    return ProvisionProviderInput(
      source: source,
      identity: identity,
      probes: probes,
    );
  }
}

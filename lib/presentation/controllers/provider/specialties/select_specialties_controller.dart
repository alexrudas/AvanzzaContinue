// ============================================================================
// lib/presentation/controllers/provider/specialties/select_specialties_controller.dart
// SELECT SPECIALTIES CONTROLLER — Selector multi-select de specialties
//
// QUÉ HACE:
// - Orquesta la pantalla "¿Qué ofreces?" para proveedores.
// - Estado reactivo:
//     - `assetType` (inmutable, viene del binding)
//     - `selectedKind: Rx<SpecialtyKind?>` (null = sin filtro inicial)
//     - `phase: Rx<SelectSpecialtiesPhase>` (fase MACRO de la pantalla)
//     - `isRefetching: RxBool` (loading "ligero" durante un refetch
//       cuando ya hay datos visibles en pantalla)
//     - `specialties: RxList<Specialty>` (lista del backend, NO se reordena)
//     - `selectedIds: RxSet<String>` (multi-select; soporta initialSelection)
//     - `errorCode: Rx<String?>` (para UX por código, no por mensaje)
// - Refetch al cambiar el toggle, con:
//     1) Debounce 250 ms (evita flood al backend al togglear rápido).
//     2) Sequence-token: descarta respuestas tardías ante carreras.
//   La cancelación HTTP del request previo es responsabilidad EXCLUSIVA del
//   repository: cada `repo.list()` cancela internamente el request en vuelo.
//   El controller no orquesta cancelación durante el flujo (sin duplicación).
//   La única salvedad es `onClose()`, donde el caller debe cerrar sus
//   recursos in-flight para no leakar trabajo al desmontar la pantalla.
// - `initialSelection` opcional: rehidrata la selección al volver al selector
//   (CAMBIO 1 — persistencia del flujo, en memoria, sin storage).
// - Loading diferenciado (CAMBIO 4):
//     * Primera carga (sin datos previos) → `phase = loading` (full screen).
//     * Refetch con datos visibles → `isRefetching = true` (inline).
// - Selección "fantasma" (CAMBIO 1 refinamiento): el controller expone
//   `hiddenSelectedCount` para que la UI muestre cuántas selecciones están
//   fuera del filtro vigente, evitando sensación de inconsistencia sin
//   destruir la elección del usuario.
// - Toggle del item por id; expone `canContinue` y `submit()` que devuelve
//   los IDs seleccionados al caller via `Get.back(result: ...)`.
//
// QUÉ NO HACE:
// - NO ordena, deduplica ni filtra en cliente.
// - NO mapea `null` a `BOTH`: estado inicial es `null` y se envía sin `type`.
// - NO infiere kind desde key.
// - NO cachea localmente.
// - NO persiste la selección a disco: el caller decide qué hacer con los IDs.
//
// PRINCIPIOS:
// - Patrón GetX: `.obs` granular, sin `update()` global.
// - Repos vienen de `DIContainer()` (regla CLAUDE.md).
// - Cancelación gestionada por el repo (Clean Architecture: el controller
//   no conoce `package:dio`).
//
// ENTERPRISE NOTES:
// - CREADO (2026-04-25).
// - REFINADO (2026-04-25): initialSelection, debounce 250ms,
//   cancelación HTTP, loading inline, empty state diferenciado por kind.
// - REFINADO (2026-04-25, ronda 2): cancelación delegada 100% al repo
//   (sin duplicación en flujo); getter `hiddenSelectedCount` para banner
//   de selección fuera del filtro.
// - REFINADO (2026-04-25, ronda 3): `hiddenSelectedCount` migrado a
//   contador incremental — O(1) en toggles, O(n+m) solo al recibir un
//   dataset nuevo. Set `_visibleIds` cacheado como índice O(1) lookups.
//   El getter público es ahora reactivo (RxInt) y la API hacia la UI no
//   cambia.
// - REFINADO (2026-04-25, ronda 4): bloque INVARIANT explícito sobre
//   `_hiddenSelectedCount`/`_visibleIds`/`_selectedIds`/`_specialties`.
//   Cualquier nueva ruta que mute esos campos DEBE restablecer el
//   invariante (delta O(1) o `_recomputeVisibleIndex()` como reset total).
// - REFINADO (2026-04-25, ronda 5): el INVARIANT es ahora chequeado por
//   `assert(_invariantHolds(...))` al final de cada punto de mutación
//   (toggleSelection, onInit, _runFetch, _recomputeVisibleIndex). Coste
//   cero en release (las assertions se elidan); pánico inmediato en debug
//   y tests si una nueva ruta deja inconsistente el estado derivado.
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/catalog/specialty_entity.dart';
import '../../../../domain/errors/remote_exceptions.dart';
import '../../../../domain/repositories/catalog/specialty_catalog_repository.dart';
import 'specialties_selection_result.dart';

/// Fase macro de la pantalla. NO confundir con `isRefetching`: las fases
/// `loading`/`empty`/`data`/`error` describen el contenido del cuerpo;
/// `isRefetching` es una capa ortogonal que indica un refresco *encima* de
/// datos ya visibles.
enum SelectSpecialtiesPhase { idle, loading, empty, data, error }

class SelectSpecialtiesController extends GetxController {
  final SpecialtyCatalogRepository _repo;

  /// AssetType objetivo (e.g. `vehicle.car`). Inmutable durante la vida
  /// del controller — si cambia, el caller debe destruir el controller.
  final String assetType;

  /// Selección inicial (CAMBIO 1). Si el caller la provee, hidratamos
  /// `selectedIds` en `onInit` y se preserva entre toggles.
  final Set<String> initialSelection;

  /// Debounce aplicado a cambios de toggle. 250 ms balancea responsividad
  /// (sigue sintiéndose inmediato) y agrupación (un usuario que duda entre
  /// Productos/Servicios no manda 3 requests).
  static const Duration _toggleDebounce = Duration(milliseconds: 250);

  /// Pre-filtro `kind` opcional inyectado por el caller (form de
  /// proveedor). Single-source-of-truth: el form decide y el selector
  /// solo aplica. Cuando es no-null, `onInit` lo asigna al
  /// `_selectedKind` ANTES del primer fetch — así la lista llega
  /// filtrada de entrada y no hay re-fetch redundante.
  ///
  /// Hito 1.x: el toggle interno fue eliminado para evitar divergencia
  /// con el form. Si el usuario quiere cambiar el kind, vuelve al form,
  /// ajusta el BottomSheet "Tipo de oferta" y reabre el selector.
  final SpecialtyKind? initialKind;

  /// Nombre del proveedor que se está editando — viene del form vía
  /// `Get.arguments`. Se usa exclusivamente como título del AppBar para
  /// dar contexto al usuario ("estás eligiendo specialties para
  /// Autokorea"). Si null/vacío, la page cae a fallback "Especialidades".
  ///
  /// NO se persiste, NO viaja al backend, NO afecta la lógica de fetch.
  final String? providerName;

  SelectSpecialtiesController({
    required SpecialtyCatalogRepository repository,
    required this.assetType,
    Set<String>? initialSelection,
    this.initialKind,
    this.providerName,
  })  : _repo = repository,
        initialSelection = Set<String>.unmodifiable(
          initialSelection ?? const <String>{},
        );

  // ── Estado reactivo ─────────────────────────────────────────────────────
  final Rx<SpecialtyKind?> _selectedKind = Rx<SpecialtyKind?>(null);
  final Rx<SelectSpecialtiesPhase> _phase =
      Rx<SelectSpecialtiesPhase>(SelectSpecialtiesPhase.idle);
  final RxBool _isRefetching = false.obs;
  final RxList<Specialty> _specialties = <Specialty>[].obs;
  final RxSet<String> _selectedIds = <String>{}.obs;
  final Rx<String?> _errorCode = Rx<String?>(null);
  final Rx<String?> _errorMessage = Rx<String?>(null);

  // ╔══════════════════════════════════════════════════════════════════════╗
  // ║ INVARIANT — "selección oculta" (estado derivado mantenido a mano)     ║
  // ║                                                                      ║
  // ║   _hiddenSelectedCount.value                                         ║
  // ║       == número de ids en `_selectedIds` que NO están en `_visibleIds`║
  // ║       == |_selectedIds \ _visibleIds|                                ║
  // ║                                                                      ║
  // ║   _visibleIds == { s.id | s ∈ _specialties }                         ║
  // ║                                                                      ║
  // ║ MUST be updated in TODOS los siguientes puntos de mutación. Si       ║
  // ║ tocas estos campos sin restablecer el invariante, el banner          ║
  // ║ "X seleccionadas fuera del filtro" mostrará un número incorrecto     ║
  // ║ — bug silencioso (en release).                                       ║
  // ║                                                                      ║
  // ║   • Mutaciones de `_selectedIds`:                                    ║
  // ║       - `toggleSelection()` ............ delta O(1)                  ║
  // ║       - `onInit()` (assignAll inicial) . sembrado completo           ║
  // ║       - cualquier futuro método que toque `_selectedIds` (clear,     ║
  // ║         addAll, removeWhere, …) DEBE recalcular o usar deltas        ║
  // ║                                                                      ║
  // ║   • Mutaciones de `_specialties`:                                    ║
  // ║       - `_runFetch()` (assignAll tras HTTP) → llama                  ║
  // ║         `_recomputeVisibleIndex()`                                   ║
  // ║       - cualquier futura mutación (insert, removeAt, sort en local,  ║
  // ║         que NO debería existir, …) DEBE invocar                      ║
  // ║         `_recomputeVisibleIndex()` antes de devolver el control      ║
  // ║         a la UI                                                      ║
  // ║                                                                      ║
  // ║ Regla de oro: si añades una nueva ruta que escribe en `_selectedIds` ║
  // ║ o `_specialties`, su última instrucción debe dejar el invariante     ║
  // ║ restablecido. Si dudas → llama `_recomputeVisibleIndex()`.           ║
  // ║                                                                      ║
  // ║ DEFENSA AUTOMÁTICA: cada punto de mutación termina en                ║
  // ║   assert(_invariantHolds(...));                                      ║
  // ║ Coste cero en release (las assertions se elidan en AOT). En debug    ║
  // ║ y `flutter test`, una violación rompe la app/test inmediatamente     ║
  // ║ con el mensaje del invariante — no llega como bug silencioso.        ║
  // ╚══════════════════════════════════════════════════════════════════════╝

  /// Contador incremental de selecciones FUERA del filtro vigente.
  /// Lo expone `hiddenSelectedCount`. Ver bloque INVARIANT arriba.
  final RxInt _hiddenSelectedCount = 0.obs;

  /// Índice O(1) de IDs visibles bajo el filtro actual. Se rehidrata
  /// junto con `_specialties` desde `_recomputeVisibleIndex()`. Vacío
  /// hasta que llegue el primer fetch. Ver bloque INVARIANT arriba.
  Set<String> _visibleIds = const <String>{};

  /// Token monotónico para descartar respuestas obsoletas (defensa en
  /// profundidad; la cancelación HTTP del repo ya las aborta antes).
  int _requestSeq = 0;

  /// Timer de debounce de toggles. Solo activo entre selectKind() y el
  /// fetch real. Cancelado en cada nuevo cambio o en onClose().
  Timer? _debounceTimer;

  // ── Getters públicos (lectura) ──────────────────────────────────────────

  /// Versión Rx del filtro vigente. Expuesta para que widgets externos
  /// puedan suscribirse vía `ever()` (p. ej. el `ScrollController` de la
  /// lista, que anima a top al cambiar el filtro). NO mutable desde fuera:
  /// el contrato de mutación sigue siendo `selectKind()` /
  /// `toggleProducts()` / `toggleServices()`.
  Rx<SpecialtyKind?> get selectedKindRx => _selectedKind;

  /// Versión Rx del set de IDs seleccionados. Mismo patrón que
  /// `selectedKindRx`: expuesto para que tests / consumers externos
  /// puedan suscribirse al stream subyacente con `.listen()` y validar
  /// emisiones reactivas (regresión del bug "check no aparece sin
  /// salir/entrar"). NO mutable desde fuera — la mutación canónica
  /// sigue siendo `toggleSelection()`.
  RxSet<String> get selectedIdsRx => _selectedIds;

  SpecialtyKind? get selectedKind => _selectedKind.value;
  SelectSpecialtiesPhase get phase => _phase.value;
  bool get isRefetching => _isRefetching.value;
  List<Specialty> get specialties => _specialties;
  Set<String> get selectedIds => _selectedIds;
  String? get errorCode => _errorCode.value;
  String? get errorMessage => _errorMessage.value;

  /// El CTA "Continuar" se habilita solo si hay al menos una specialty
  /// seleccionada (regla del prompt).
  bool get canContinue => _selectedIds.isNotEmpty;

  /// Cantidad de IDs seleccionados que NO aparecen en la lista visible
  /// actual (filtrada por el toggle vigente).
  ///
  /// La selección NO se destruye al filtrar — pero esto puede generar
  /// sensación de inconsistencia ("seleccioné 5 pero ahora veo solo 2
  /// marcadas"). La UI usa este número para mostrar un banner discreto:
  /// "3 seleccionadas fuera del filtro".
  ///
  /// Mantenido como contador incremental:
  ///   - `toggleSelection()` lo actualiza en O(1) consultando `_visibleIds`.
  ///   - `_recomputeVisibleIndex()` lo recalcula en O(n+m) cuando llega
  ///     un dataset nuevo (cambio de filtro, retry, hidratación inicial).
  /// Reactivo (RxInt) — los `Obx` que lo lean se reconstruyen sólo cuando
  /// el contador cambia, no en cada rebuild reactivo de otros campos.
  int get hiddenSelectedCount => _hiddenSelectedCount.value;

  // ── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // PUNTO DE MUTACIÓN de `_selectedIds` — ver bloque INVARIANT arriba.
    // Hidratar selección inicial (CAMBIO 1). Pasa SIEMPRE — incluso si está
    // vacía — para mantener el contrato de "el set viene del caller".
    _selectedIds.assignAll(initialSelection);

    // Restablecer INVARIANT: como `_specialties` aún está vacío,
    // `_visibleIds` está vacío → todos los ids hidratados son "hidden".
    // El primer fetch llamará a `_recomputeVisibleIndex()` y bajará el
    // contador a su valor real una vez que la lista esté poblada.
    _hiddenSelectedCount.value = _selectedIds.length;
    assert(_invariantHolds(), 'INVARIANT violated after onInit hydration');

    // Pre-filtro `initialKind` (Hito 1.x): si el caller (form de
    // proveedor) pre-seleccionó un kind, lo aplicamos ANTES del primer
    // fetch — así la lista llega filtrada de entrada y evitamos un
    // re-fetch redundante. Si es null, comportamiento legacy: carga sin
    // filtro y el endpoint devuelve todas las specialties del catálogo.
    if (initialKind != null) {
      _selectedKind.value = initialKind;
    }

    // Carga inicial. La primera carga NO pasa por debounce — el usuario
    // espera datos al entrar. Si `_selectedKind` está seteado por
    // `initialKind`, el fetch envía `?type=<wireName>` desde el primer
    // request.
    _fetch(immediate: true);
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    // CLEANUP de lifecycle (NO orquestación de flujo):
    // al desmontar la pantalla, le pedimos al repo abortar cualquier
    // request HTTP pendiente para no leakar trabajo ni que la respuesta
    // tardía intente tocar Rx ya disposed. Esta es la única vía por la
    // cual el controller invoca `cancelInFlight()` — durante el flujo
    // normal de fetch, la cancelación la maneja exclusivamente el repo.
    _repo.cancelInFlight();
    super.onClose();
  }

  // ── Acciones ─────────────────────────────────────────────────────────────

  /// Cambia el filtro de tipo y dispara refetch (con debounce).
  ///
  /// - [kind] = `null` → sin filtro (estado inicial).
  /// - Tap sobre el toggle ya activo → vuelve a `null` (toggle off).
  ///
  /// Mantiene la selección actual: ids seleccionados que NO estén en la nueva
  /// lista quedan ocultos pero NO se eliminan del set. La validación final
  /// la hace el caller cuando recibe el `Set<String>`.
  void selectKind(SpecialtyKind? kind) {
    if (_selectedKind.value == kind) return;
    _selectedKind.value = kind;
    _fetch(immediate: false);
  }

  /// Atajo: el toggle "Productos" en la UI llama a esto. Si ya está activo,
  /// lo apaga (vuelve a `null` = sin filtro).
  void toggleProducts() {
    selectKind(_selectedKind.value == SpecialtyKind.product
        ? null
        : SpecialtyKind.product);
  }

  /// Atajo: el toggle "Servicios" en la UI llama a esto.
  void toggleServices() {
    selectKind(_selectedKind.value == SpecialtyKind.service
        ? null
        : SpecialtyKind.service);
  }

  /// Marca/desmarca una specialty por id (multi-select).
  ///
  /// INVARIANT (ver bloque arriba): mantiene `_hiddenSelectedCount` en O(1).
  /// - Si el id NO está en `_visibleIds` (selección oculta), cada toggle
  ///   suma o resta 1 al contador.
  /// - Si el id sí está visible, el contador no cambia (sigue fuera del
  ///   conjunto "hidden" tanto antes como después).
  ///
  /// PUNTO DE MUTACIÓN de `_selectedIds`. Si modificas este método o
  /// añades otro que toque `_selectedIds`, restablece el invariante
  /// (delta O(1) o `_recomputeVisibleIndex()` si dudas).
  void toggleSelection(String id) {
    final isVisible = _visibleIds.contains(id);
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (!isVisible) _hiddenSelectedCount.value -= 1;
    } else {
      _selectedIds.add(id);
      if (!isVisible) _hiddenSelectedCount.value += 1;
    }
    assert(_invariantHolds(), 'INVARIANT violated after toggleSelection');
  }

  /// Reintenta el último fetch (CTA del estado de error). Sin debounce —
  /// el usuario lo pidió explícitamente.
  Future<void> retry() async {
    await _fetch(immediate: true);
  }

  /// Cierra la pantalla devolviendo `SpecialtiesSelectionResult` al
  /// caller (form de proveedor).
  ///
  /// El resultado lleva tanto los IDs como los detalles (id+name) de
  /// las specialties realmente seleccionadas, para que el caller pueda
  /// construir un resumen compacto sin volver a consultar el catálogo.
  ///
  /// Los detalles se construyen desde `_specialties` actual filtrando
  /// por `_selectedIds`. **Importante**: si el filtro `_selectedKind`
  /// está activo, `_specialties` solo contiene los visibles bajo el
  /// filtro — pero pueden existir IDs seleccionados FUERA del filtro
  /// (`hiddenSelectedCount > 0`) que NO aparecen en `_specialties`. En
  /// ese caso solo se incluye en `details` lo que está visible; los
  /// hidden quedan en `ids` pero NO tienen entry en `details`. El
  /// caller (form) tolera esto: usa `details.first.name` si hay, y si
  /// no, cae al copy genérico.
  ///
  /// Si no hay selección, no hace nada (el botón debería estar
  /// deshabilitado vía `canContinue`).
  void submit() {
    if (!canContinue) return;
    final details = <SpecialtySelectionDetail>[
      for (final s in _specialties)
        if (_selectedIds.contains(s.id))
          SpecialtySelectionDetail(id: s.id, name: s.name),
    ];
    Get.back<SpecialtiesSelectionResult>(
      result: SpecialtiesSelectionResult(
        ids: _selectedIds,
        details: details,
      ),
    );
  }

  // ── Fetch + debounce + cancelación ───────────────────────────────────────

  /// Dispara el fetch.
  ///
  /// - [immediate] = `true`: carga inicial o retry — sin debounce.
  /// - [immediate] = `false`: cambio de toggle — con debounce de 250 ms.
  ///
  /// CONTRATO DE CANCELACIÓN: el controller NO orquesta cancelación HTTP.
  /// El repo, dentro de `list()`, cancela su propio request en vuelo antes
  /// de disparar el nuevo. Aquí únicamente cancelamos el `Timer` de debounce
  /// previo para que dos cambios de toggle dentro de la ventana de 250 ms
  /// solo disparen una request — la última. Mientras tanto, si hay HTTP en
  /// vuelo, sigue corriendo y la cancelación efectiva ocurre cuando el
  /// `Timer` finalmente llama a `_runFetch()` → `repo.list()`.
  Future<void> _fetch({required bool immediate}) async {
    _debounceTimer?.cancel();

    if (immediate) {
      await _runFetch();
    } else {
      _debounceTimer = Timer(_toggleDebounce, _runFetch);
    }
  }

  Future<void> _runFetch() async {
    final mySeq = ++_requestSeq;

    // Loading diferenciado (CAMBIO 4):
    //   - Si ya hay datos visibles → loading inline (no bloquea la lista).
    //   - Si no hay datos previos → fase loading full-screen.
    final hasVisibleData = _specialties.isNotEmpty;
    if (hasVisibleData) {
      _isRefetching.value = true;
    } else {
      _phase.value = SelectSpecialtiesPhase.loading;
    }
    _errorCode.value = null;
    _errorMessage.value = null;

    try {
      final result = await _repo.list(
        assetType: assetType,
        type: _selectedKind.value,
      );
      // Descartar si el usuario disparó otro fetch entretanto. La cancelación
      // del repo ya debería haber lanzado RequestCancelledException, pero
      // mantener el guard es defensa en profundidad ante cache local del cliente
      // o respuestas que carrera-ganen al cancel.
      if (mySeq != _requestSeq) return;

      // PUNTO DE MUTACIÓN de `_specialties` — ver bloque INVARIANT arriba.
      // La línea siguiente (`_recomputeVisibleIndex()`) es OBLIGATORIA y NO
      // puede separarse de `assignAll`. Si en el futuro alguien añade un
      // `early return` entre ambas, el banner mostrará un valor obsoleto.
      _specialties.assignAll(result.specialties);
      _recomputeVisibleIndex();
      assert(_invariantHolds(),
          'INVARIANT violated after _runFetch dataset apply');
      _phase.value = result.specialties.isEmpty
          ? SelectSpecialtiesPhase.empty
          : SelectSpecialtiesPhase.data;

      // Log canónico para observabilidad del filtro (productos/servicios/
      // ambos). El offerType en wire es SpecialtyKind.wireName cuando hay
      // filtro server-side y "BOTH" cuando no (UI agrupa por sección).
      if (kDebugMode) {
        final offerWire = _selectedKind.value?.wireName ?? 'BOTH';
        debugPrint('[SpecialtyFilter] '
            'assetType=$assetType '
            'offerType=$offerWire '
            'visibleCount=${result.specialties.length}');
      }
    } on RequestCancelledException {
      // Cancelación esperada (toggle nuevo durante request previo).
      // No tocar UI — el fetch superviniente la actualizará. Tampoco
      // restablecer flags porque el nuevo fetch ya los gestionó.
      return;
    } on UnauthorizedException catch (e) {
      if (mySeq != _requestSeq) return;
      _setError(code: 'UNAUTHORIZED', message: e.message);
    } on BadRequestException catch (e) {
      if (mySeq != _requestSeq) return;
      _setError(code: e.code ?? 'BAD_REQUEST', message: e.message);
    } on NetworkException catch (e) {
      if (mySeq != _requestSeq) return;
      _setError(code: 'NETWORK', message: e.message);
    } on ServerException catch (e) {
      if (mySeq != _requestSeq) return;
      _setError(code: 'SERVER', message: e.message);
    } catch (e, st) {
      if (mySeq != _requestSeq) return;
      debugPrint('[SelectSpecialtiesController] error inesperado: $e\n$st');
      _setError(code: 'UNKNOWN', message: e.toString());
    } finally {
      // Apagar el indicador inline solo si seguimos siendo el fetch vigente.
      if (mySeq == _requestSeq) {
        _isRefetching.value = false;
      }
    }
  }

  /// Reconstruye el índice `_visibleIds` desde `_specialties` y recalcula
  /// el contador `_hiddenSelectedCount` desde cero.
  ///
  /// RESET TOTAL del INVARIANT (ver bloque arriba). Es el "botón rojo": si
  /// alguien duda sobre qué hacer al mutar `_selectedIds` o `_specialties`
  /// fuera de los puntos canónicos, llamar aquí restablece el invariante
  /// con seguridad — el coste O(n+m) es trivial en el rango realista del
  /// catálogo (decenas de items).
  ///
  /// Hoy se invoca exclusivamente al recibir un dataset nuevo (cambio de
  /// filtro, retry, hidratación post-fetch). Los toggles individuales NO
  /// pasan por aquí — el contador se mantiene en O(1) en `toggleSelection()`.
  void _recomputeVisibleIndex() {
    final next = <String>{
      for (final s in _specialties) s.id,
    };
    _visibleIds = next;

    if (_selectedIds.isEmpty) {
      _hiddenSelectedCount.value = 0;
    } else {
      var hidden = 0;
      for (final id in _selectedIds) {
        if (!next.contains(id)) hidden += 1;
      }
      _hiddenSelectedCount.value = hidden;
    }
    assert(_invariantHolds(),
        'INVARIANT violated after _recomputeVisibleIndex (self-check)');
  }

  /// Verifica el INVARIANT (ver bloque arriba).
  ///
  /// Llamado SOLO desde `assert()` — coste cero en release porque AOT elide
  /// las assertions y la expresión `_invariantHolds(...)` no se evalúa.
  /// En debug / `flutter test`, valida que:
  ///   1. `_visibleIds == { s.id | s ∈ _specialties }`.
  ///   2. `_hiddenSelectedCount.value == |_selectedIds \ _visibleIds|`.
  ///
  /// Si retorna `false`, el `assert()` lanza `AssertionError` con el
  /// mensaje contextual del caller (`'after toggleSelection'`, etc.) — el
  /// stack trace identifica el punto de mutación que rompió el invariante.
  ///
  /// Coste en debug: O(n+m). Aceptable porque sólo corre en debug y el
  /// rango realista del catálogo son decenas de items.
  bool _invariantHolds() {
    // 1) `_visibleIds` corresponde 1:1 a los ids de `_specialties`.
    final expectedVisible = <String>{
      for (final s in _specialties) s.id,
    };
    if (expectedVisible.length != _visibleIds.length) return false;
    if (!expectedVisible.containsAll(_visibleIds)) return false;

    // 2) `_hiddenSelectedCount` es exactamente |_selectedIds \ _visibleIds|.
    var expectedHidden = 0;
    for (final id in _selectedIds) {
      if (!_visibleIds.contains(id)) expectedHidden += 1;
    }
    return expectedHidden == _hiddenSelectedCount.value;
  }

  void _setError({required String code, required String message}) {
    _errorCode.value = code;
    _errorMessage.value = message;
    // Solo conmutar a fase `error` si NO hay datos visibles. Si la lista
    // sigue en pantalla, mantenemos `data` y la UI puede mostrar un toast
    // o snackbar — para esta v1, dejamos la lista anterior y cambiamos a
    // error solo si la pantalla estaba vacía. Así un fallo transitorio
    // durante un toggle no destruye la selección visual del usuario.
    if (_specialties.isEmpty) {
      _phase.value = SelectSpecialtiesPhase.error;
    }
  }
}

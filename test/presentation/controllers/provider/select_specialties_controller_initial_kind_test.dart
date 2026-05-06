// ============================================================================
// test/presentation/controllers/provider/select_specialties_controller_initial_kind_test.dart
// SelectSpecialtiesController — propagación de `initialKind` (Hito 1.x)
// ============================================================================
//
// QUÉ CUBRE:
//   - El controller acepta `initialKind` opcional en su constructor.
//   - `onInit` aplica `initialKind` a `_selectedKind` ANTES del primer
//     fetch, así la primera llamada al repo lleva el filtro de kind.
//   - Cuando `initialKind` es null, el comportamiento legacy se preserva
//     (primer fetch sin filtro de tipo).
//
// PATRÓN: fake `SpecialtyCatalogRepository` con captura de invocaciones.
// Sin GetX testing pesado — instanciamos el controller directamente.
// ============================================================================

import 'package:avanzza/domain/entities/catalog/specialty_entity.dart';
import 'package:avanzza/domain/repositories/catalog/specialty_catalog_repository.dart';
import 'package:avanzza/presentation/controllers/provider/specialties/select_specialties_controller.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fake repo ──────────────────────────────────────────────────────────────

class _FakeSpecialtyCatalogRepository implements SpecialtyCatalogRepository {
  /// Histórico de invocaciones a `list()` para asserts de payload.
  final List<({String assetType, SpecialtyKind? type})> listCalls = [];

  /// Resultado fijo (vacío) — los tests aquí no inspeccionan el resultado,
  /// sólo el payload del request.
  SpecialtyCatalogResult result = const SpecialtyCatalogResult(
    assetType: 'vehicle.car',
    resolvedAssetTypes: ['vehicle.car', 'vehicle'],
    type: null,
    specialties: <Specialty>[],
  );

  @override
  Future<SpecialtyCatalogResult> list({
    required String assetType,
    SpecialtyKind? type,
  }) async {
    listCalls.add((assetType: assetType, type: type));
    return result;
  }

  @override
  void cancelInFlight() {}
}

// ─── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('SelectSpecialtiesController — initialKind passthrough', () {
    test('null (legacy) → primer fetch SIN filtro de tipo', () async {
      final repo = _FakeSpecialtyCatalogRepository();
      final c = SelectSpecialtiesController(
        repository: repo,
        assetType: 'vehicle.car',
        // initialKind omitido → comportamiento legacy
      );
      c.onInit();
      // Permite que el _fetch async (sin debounce) complete.
      await Future<void>.delayed(Duration.zero);

      expect(c.selectedKind, isNull);
      expect(repo.listCalls, hasLength(1));
      expect(repo.listCalls.single.type, isNull,
          reason:
              'sin initialKind, el primer request va sin `?type=` (sin filtro)');
      expect(repo.listCalls.single.assetType, 'vehicle.car');
    });

    test('PRODUCT → primer fetch con type=PRODUCT', () async {
      final repo = _FakeSpecialtyCatalogRepository();
      final c = SelectSpecialtiesController(
        repository: repo,
        assetType: 'vehicle.car',
        initialKind: SpecialtyKind.product,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.selectedKind, SpecialtyKind.product);
      expect(repo.listCalls, hasLength(1),
          reason: 'no debe haber re-fetch redundante; el filtro va en el primero');
      expect(repo.listCalls.single.type, SpecialtyKind.product);
    });

    test('SERVICE → primer fetch con type=SERVICE', () async {
      final repo = _FakeSpecialtyCatalogRepository();
      final c = SelectSpecialtiesController(
        repository: repo,
        assetType: 'vehicle.car',
        initialKind: SpecialtyKind.service,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.selectedKind, SpecialtyKind.service);
      expect(repo.listCalls.single.type, SpecialtyKind.service);
    });

    test('BOTH → primer fetch con type=BOTH', () async {
      final repo = _FakeSpecialtyCatalogRepository();
      final c = SelectSpecialtiesController(
        repository: repo,
        assetType: 'vehicle.car',
        initialKind: SpecialtyKind.both,
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.selectedKind, SpecialtyKind.both);
      expect(repo.listCalls.single.type, SpecialtyKind.both);
    });

    test('initialSelection se hidrata junto con initialKind', () async {
      // El kind preseleccionado y la selección preexistente deben coexistir
      // sin pisarse: el caller (form en EDIT mode) puede pasar ambos.
      final repo = _FakeSpecialtyCatalogRepository();
      final c = SelectSpecialtiesController(
        repository: repo,
        assetType: 'vehicle.car',
        initialKind: SpecialtyKind.product,
        initialSelection: const {'sp-prod-1', 'sp-prod-2'},
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(c.selectedKind, SpecialtyKind.product);
      expect(c.selectedIds, {'sp-prod-1', 'sp-prod-2'});
    });

    test('providerName se expone tal cual al constructor', () {
      // El field es puro carry — la page lo lee para el AppBar.
      final c = SelectSpecialtiesController(
        repository: _FakeSpecialtyCatalogRepository(),
        assetType: 'vehicle.car',
        providerName: 'Autokorea',
      );
      expect(c.providerName, 'Autokorea');
    });

    test('providerName ausente → null (page debe caer a fallback)', () {
      final c = SelectSpecialtiesController(
        repository: _FakeSpecialtyCatalogRepository(),
        assetType: 'vehicle.car',
      );
      expect(c.providerName, isNull);
    });

    // ── Regresión: rebuild reactivo del RxSet ────────────────────────────
    //
    // El bug del "check no aparece sin salir/entrar" tenía como causa raíz
    // que la page hacía `final selected = _controller.selectedIds` dentro
    // del closure del Obx. Eso retornaba el RxSet casteado a Set sin
    // tocar ningún método observable, así que GetX no registraba la
    // suscripción y el Obx no rebuildeaba ante mutaciones.
    //
    // El fix en la page es leer `_controller.selectedIds.toSet()` (itera
    // → toca `iterator`/`length` → registra suscripción).
    //
    // Este test valida el invariante a nivel CONTROLLER: el RxSet emite
    // notificaciones al `add`/`remove`, así que cualquier consumer
    // suscrito CORRECTAMENTE rebuildea. Si en el futuro alguien rompe el
    // tipo de `_selectedIds` (p. ej. de RxSet a Set raw), este test cae.
    test(
        'toggleSelection emite notificación reactiva al RxSet — '
        'invariante para que la UI rebuildeé inmediatamente', () async {
      final repo = _FakeSpecialtyCatalogRepository()
        ..result = const SpecialtyCatalogResult(
          assetType: 'vehicle.car',
          resolvedAssetTypes: ['vehicle.car', 'vehicle'],
          type: null,
          specialties: [
            Specialty(id: 'sp-1', name: 'A', kind: SpecialtyKind.service),
            Specialty(id: 'sp-2', name: 'B', kind: SpecialtyKind.service),
          ],
        );
      final c = SelectSpecialtiesController(
        repository: repo,
        assetType: 'vehicle.car',
      );
      c.onInit();
      await Future<void>.delayed(Duration.zero);

      // Captura emisiones del RxSet usando el getter `selectedIdsRx`
      // (paralelo a `selectedKindRx` ya existente). Si el RxSet NO
      // emite ante mutaciones, este buffer queda vacío y el test cae.
      final emissions = <int>[];
      final sub = c.selectedIdsRx.listen((set) => emissions.add(set.length));

      c.toggleSelection('sp-1'); // add
      c.toggleSelection('sp-2'); // add
      c.toggleSelection('sp-1'); // remove

      await Future<void>.delayed(Duration.zero);
      sub.cancel();

      // El RxSet emite tras CADA mutación: esperamos 3 emisiones
      // (tamaños 1, 2, 1 respectivamente).
      expect(emissions, hasLength(3),
          reason:
              'toggleSelection debe emitir una notificación por cada add/remove');
      expect(emissions[0], 1, reason: 'add → set de tamaño 1');
      expect(emissions[1], 2, reason: 'segundo add → set de tamaño 2');
      expect(emissions[2], 1, reason: 'remove → vuelta a tamaño 1');
    });
  });
}

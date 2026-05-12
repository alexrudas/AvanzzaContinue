// ============================================================================
// test/domain/services/access/asset_class_catalog_test.dart
//
// QUÉ HACE:
// - Verifica el catálogo global cliente de AssetType raíces que el wizard
//   `/provider/bootstrap` usa para que el proveedor pueda declarar qué
//   tipos atiende SIN depender de los AssetType ya operados por el
//   workspace activo (bug pre-fix: "Este workspace no tiene tipos de
//   activo configurados").
// - Asegura wire-stability con `AssetClass` del Core API
//   (`asset-actor-link/constants/asset-class.ts`).
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/domain/services/access/asset_class_catalog.dart';

void main() {
  group('AssetClassCatalog — wire-stable contract con Core API', () {
    test(
        'expone exactamente los 5 ids canónicos del enum AssetClass del backend',
        () {
      final ids = AssetClassCatalog.list().map((e) => e.id).toSet();
      expect(
        ids,
        equals({
          'vehicle',
          'real_estate',
          'machinery',
          'equipment',
          'other',
        }),
        reason:
            'Wire-stable con `ASSET_CLASS_TO_ROOT_ID` en avanzza-core-api/'
            'src/modules/core-common/asset-actor-link/constants/asset-class.ts. '
            'No renombrar sin migración coordinada.',
      );
    });

    test('validIds coincide con la lista pública', () {
      final listIds = AssetClassCatalog.list().map((e) => e.id).toSet();
      expect(AssetClassCatalog.validIds, equals(listIds));
    });

    test('todos los items tienen parentId=null (son roots de la jerarquía)', () {
      for (final at in AssetClassCatalog.list()) {
        expect(at.parentId, isNull,
            reason: 'Catálogo cliente sólo expone roots top-level. '
                'Subtipos requieren `GET /v1/catalog/asset-types` '
                '(deuda backend documentada).');
      }
    });

    test('todos los items tienen nombre legible en español', () {
      final byId = {for (final at in AssetClassCatalog.list()) at.id: at.name};
      expect(byId['vehicle'], 'Vehículos');
      expect(byId['real_estate'], 'Inmuebles');
      expect(byId['machinery'], 'Maquinaria');
      expect(byId['equipment'], 'Equipos');
      expect(byId['other'], 'Otros');
    });

    test('list() retorna lista no modificable', () {
      final list = AssetClassCatalog.list();
      expect(() => list.add(list.first), throwsUnsupportedError);
    });

    // ── BUG ESPECÍFICO REPORTADO ─────────────────────────────────────────
    test(
        'BUG provider bootstrap: catálogo NUNCA está vacío aunque el '
        'workspace no opere ningún AssetType', () {
      // Antes: el wizard usaba `WorkspaceAssetTypeRepository.listActive()` que
      // devolvía [] para workspaces nuevos sin AssetActorLink, lo que
      // bloqueaba el bootstrap con el copy "Pide al administrador que los
      // registre primero". Ahora el catálogo cliente garantiza N >= 5.
      expect(AssetClassCatalog.list(), hasLength(5));
      expect(AssetClassCatalog.list(), isNotEmpty);
    });
  });
}

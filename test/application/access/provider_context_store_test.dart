// ============================================================================
// test/application/access/provider_context_store_test.dart
//
// QUÉ HACE:
// - Verifica el contrato del `ProviderContextStore`: lectura reactiva de
//   `isProvider` + `workspaceId`, idempotencia de set y reset en logout/switch.
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/application/services/access/provider_context_store.dart';

void main() {
  group('ProviderContextStore — lectura', () {
    test('store nuevo: isProvider=false, workspaceId vacío, isResolved=false',
        () {
      final store = ProviderContextStore();
      expect(store.isProvider, isFalse);
      expect(store.workspaceId, '');
      expect(store.isResolved, isFalse);
    });

    test('set() publica isProvider y workspaceId; isResolved=true', () {
      final store = ProviderContextStore();
      store.set(isProvider: true, workspaceId: 'ws_1');
      expect(store.isProvider, isTrue);
      expect(store.workspaceId, 'ws_1');
      expect(store.isResolved, isTrue);
    });

    test('clear() vacía valores y resetea isResolved', () {
      final store = ProviderContextStore();
      store.set(isProvider: true, workspaceId: 'ws_1');
      store.clear();
      expect(store.isProvider, isFalse);
      expect(store.workspaceId, '');
      expect(store.isResolved, isFalse);
    });

    test(
        'usuario nuevo sin proveedor: store puede registrar isProvider=false '
        'pero workspaceId resuelto', () {
      // Caso típico tras /providers/me con isProvider=false: el store recibe
      // el workspaceId canónico y debe quedar resuelto.
      final store = ProviderContextStore();
      store.set(isProvider: false, workspaceId: 'ws_42');
      expect(store.isProvider, isFalse);
      expect(store.workspaceId, 'ws_42');
      expect(store.isResolved, isTrue,
          reason:
              'isResolved depende de workspaceId no vacío, no de isProvider.');
    });
  });

  group('ProviderContextStore — reactividad', () {
    test('isProviderRx observable cambia tras set/clear', () {
      final store = ProviderContextStore();
      final history = <bool>[];
      final sub = store.isProviderRx.listen(history.add);

      store.set(isProvider: true, workspaceId: 'ws_1');
      store.set(isProvider: false, workspaceId: 'ws_1'); // workspace mismo
      store.clear();

      // El stream emite snapshots; basta verificar que registró cambios.
      expect(history, contains(true));
      expect(history, contains(false));
      sub.cancel();
    });
  });
}

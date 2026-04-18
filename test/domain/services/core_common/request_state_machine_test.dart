// ============================================================================
// test/domain/services/core_common/request_state_machine_test.dart
// REQUEST STATE MACHINE — Tests unitarios (F2.b)
// ============================================================================
// QUÉ HACE:
//   - Verifica transiciones válidas de cada evento.
//   - Verifica rechazo tipado de transiciones inválidas.
//   - Verifica diffs correctos de timestamps (sentAt, respondedAt, closedAt).
//   - Verifica INDEPENDENCIA total del estado de la Relación: el motor y el
//     snapshot no reciben ni consultan RelationshipState.
//
// QUÉ NO HACE:
//   - No integra Isar ni repositorio; prueba la función pura.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/request_state.dart';
import 'package:avanzza/domain/services/core_common/request_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 4, 17, 12, 0, 0);

  group('send', () {
    test('draft → sent con sentAt=now', () {
      const snap = RequestSnapshot(state: RequestState.draft);

      final t = transitionRequest(
        current: snap,
        event: RequestEvent.send,
        now: now,
      );

      expect(t.nextState, RequestState.sent);
      expect(t.sentAt, now);
      expect(t.stateUpdatedAt, now);
      expect(t.respondedAt, isNull);
      expect(t.closedAt, isNull);
    });

    test('desde sent lanza', () {
      const snap = RequestSnapshot(state: RequestState.sent);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.send,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });
  });

  group('markDelivered', () {
    test('sent → delivered', () {
      const snap = RequestSnapshot(state: RequestState.sent);

      final t = transitionRequest(
        current: snap,
        event: RequestEvent.markDelivered,
        now: now,
      );

      expect(t.nextState, RequestState.delivered);
      expect(t.stateUpdatedAt, now);
    });

    test('desde delivered lanza (no re-delivery)', () {
      const snap = RequestSnapshot(state: RequestState.delivered);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.markDelivered,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });
  });

  group('markSeen', () {
    test('delivered → seen', () {
      const snap = RequestSnapshot(state: RequestState.delivered);

      final t = transitionRequest(
        current: snap,
        event: RequestEvent.markSeen,
        now: now,
      );

      expect(t.nextState, RequestState.seen);
      expect(t.stateUpdatedAt, now);
    });

    test('desde sent lanza (primero delivered, luego seen)', () {
      const snap = RequestSnapshot(state: RequestState.sent);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.markSeen,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });
  });

  group('markResponded', () {
    test('desde sent, delivered o seen → responded con respondedAt=now', () {
      for (final from in [
        RequestState.sent,
        RequestState.delivered,
        RequestState.seen,
      ]) {
        final t = transitionRequest(
          current: RequestSnapshot(state: from),
          event: RequestEvent.markResponded,
          now: now,
        );

        expect(t.nextState, RequestState.responded);
        expect(t.respondedAt, now);
        expect(t.stateUpdatedAt, now);
      }
    });

    test('desde draft lanza', () {
      const snap = RequestSnapshot(state: RequestState.draft);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.markResponded,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });

    test('desde responded lanza', () {
      const snap = RequestSnapshot(state: RequestState.responded);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.markResponded,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });
  });

  group('accept / reject', () {
    test('responded → accepted', () {
      const snap = RequestSnapshot(state: RequestState.responded);

      final t = transitionRequest(
        current: snap,
        event: RequestEvent.accept,
        now: now,
      );

      expect(t.nextState, RequestState.accepted);
      expect(t.stateUpdatedAt, now);
    });

    test('responded → rejected', () {
      const snap = RequestSnapshot(state: RequestState.responded);

      final t = transitionRequest(
        current: snap,
        event: RequestEvent.reject,
        now: now,
      );

      expect(t.nextState, RequestState.rejected);
    });

    test('accept desde sent lanza', () {
      const snap = RequestSnapshot(state: RequestState.sent);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.accept,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });

    test('accept desde accepted lanza (ya terminal)', () {
      const snap = RequestSnapshot(state: RequestState.accepted);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.accept,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });
  });

  group('expire', () {
    test('sent, delivered, seen, responded → expired', () {
      for (final from in [
        RequestState.sent,
        RequestState.delivered,
        RequestState.seen,
        RequestState.responded,
      ]) {
        final t = transitionRequest(
          current: RequestSnapshot(state: from),
          event: RequestEvent.expire,
          now: now,
        );
        expect(t.nextState, RequestState.expired);
        expect(t.stateUpdatedAt, now);
      }
    });

    test('desde draft lanza (nada enviado que expirar)', () {
      const snap = RequestSnapshot(state: RequestState.draft);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.expire,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });

    test('desde accepted/rejected/expired lanza', () {
      for (final from in [
        RequestState.accepted,
        RequestState.rejected,
        RequestState.expired,
      ]) {
        expect(
          () => transitionRequest(
            current: RequestSnapshot(state: from),
            event: RequestEvent.expire,
            now: now,
          ),
          throwsA(isA<IllegalRequestTransition>()),
          reason: 'expire no debe aplicar desde $from',
        );
      }
    });
  });

  group('close', () {
    test('desde cualquier estado no-closed → closed con closedAt=now', () {
      final nonClosed = RequestState.values
          .where((s) => s != RequestState.closed)
          .toList();

      for (final from in nonClosed) {
        final t = transitionRequest(
          current: RequestSnapshot(state: from),
          event: RequestEvent.close,
          now: now,
        );
        expect(t.nextState, RequestState.closed);
        expect(t.closedAt, now);
        expect(t.stateUpdatedAt, now);
      }
    });

    test('desde closed lanza (terminal dura)', () {
      const snap = RequestSnapshot(state: RequestState.closed);

      expect(
        () => transitionRequest(
          current: snap,
          event: RequestEvent.close,
          now: now,
        ),
        throwsA(isA<IllegalRequestTransition>()),
      );
    });
  });

  group('terminal closed bloquea todos los eventos', () {
    test('cualquier evento desde closed lanza', () {
      const snap = RequestSnapshot(state: RequestState.closed);

      for (final event in RequestEvent.values) {
        expect(
          () => transitionRequest(
            current: snap,
            event: event,
            now: now,
          ),
          throwsA(isA<IllegalRequestTransition>()),
          reason: 'evento $event debe rechazarse desde closed',
        );
      }
    });
  });

  group('ortogonalidad con Relación (regla crítica v1)', () {
    test('ciclo completo draft → accepted sin referencia a Relación', () {
      // La API del motor NO admite parámetros de Relación por diseño.
      // Si este ciclo compila y pasa, la independencia queda garantizada.
      RequestState s = RequestState.draft;

      final t1 = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.send,
        now: now,
      );
      s = t1.nextState;
      expect(s, RequestState.sent);

      final t2 = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.markDelivered,
        now: now,
      );
      s = t2.nextState;
      expect(s, RequestState.delivered);

      final t3 = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.markSeen,
        now: now,
      );
      s = t3.nextState;
      expect(s, RequestState.seen);

      final t4 = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.markResponded,
        now: now,
      );
      s = t4.nextState;
      expect(s, RequestState.responded);

      final t5 = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.accept,
        now: now,
      );
      s = t5.nextState;
      expect(s, RequestState.accepted);

      final t6 = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.close,
        now: now,
      );
      s = t6.nextState;
      expect(s, RequestState.closed);
    });

    test('ciclo degradable externo: draft → sent → responded → rejected → closed',
        () {
      // Simula canal externo donde delivered/seen no llegan automáticamente.
      RequestState s = RequestState.draft;

      s = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.send,
        now: now,
      ).nextState;

      // Emisor salta markDelivered/markSeen y marca responded directo.
      s = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.markResponded,
        now: now,
      ).nextState;

      s = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.reject,
        now: now,
      ).nextState;

      expect(s, RequestState.rejected);

      s = transitionRequest(
        current: RequestSnapshot(state: s),
        event: RequestEvent.close,
        now: now,
      ).nextState;

      expect(s, RequestState.closed);
    });
  });

  group('IllegalRequestTransition', () {
    test('toString incluye from, event y reason', () {
      const snap = RequestSnapshot(state: RequestState.closed);

      try {
        transitionRequest(
          current: snap,
          event: RequestEvent.send,
          now: now,
        );
        fail('debería haber lanzado');
      } on IllegalRequestTransition catch (e) {
        final s = e.toString();
        expect(s, contains('closed'));
        expect(s, contains('send'));
      }
    });
  });
}

// ============================================================================
// test/domain/services/core_common/relationship_state_machine_test.dart
// RELATIONSHIP STATE MACHINE — Tests unitarios (F2.a)
// ============================================================================
// QUÉ HACE:
//   - Verifica que el motor puro de Relación cumple con:
//       · Transiciones válidas por evento.
//       · Invariantes de datos (trustLevel=alto, platformActor requerido, etc.).
//       · Rechazo tipado de transiciones inválidas.
//       · Diffs correctos de campos (clear*, timestamps, reasons).
//       · Independencia del estado respecto de cualquier Request.
//
// QUÉ NO HACE:
//   - No integra Isar ni repositorio; prueba la función pura.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/match_trust_level.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_suspension_reason.dart';
import 'package:avanzza/domain/services/core_common/relationship_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 4, 17, 12, 0, 0);

  group('matcherConfirmedHighTrust', () {
    test('referenciada + alto + platformActorId → detectable', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.matcherConfirmedHighTrust,
        now: now,
        incomingPlatformActorId: 'actor-1',
        incomingTrustLevel: MatchTrustLevel.alto,
      );

      expect(t.nextState, RelationshipState.detectable);
      expect(t.stateUpdatedAt, now);
      expect(t.targetPlatformActorId, 'actor-1');
      expect(t.matchTrustLevel, MatchTrustLevel.alto);
      expect(t.clearPlatformActor, isFalse);
      expect(t.clearMatchTrustLevel, isFalse);
    });

    test('desde detectable lanza IllegalRelationshipTransition', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.detectable,
        targetPlatformActorId: 'actor-1',
        matchTrustLevel: MatchTrustLevel.alto,
      );

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.matcherConfirmedHighTrust,
          now: now,
          incomingPlatformActorId: 'actor-2',
          incomingTrustLevel: MatchTrustLevel.alto,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });

    test('trustLevel=medio lanza (solo alto promueve)', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.matcherConfirmedHighTrust,
          now: now,
          incomingPlatformActorId: 'actor-1',
          incomingTrustLevel: MatchTrustLevel.medio,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });

    test('sin incomingPlatformActorId lanza', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.matcherConfirmedHighTrust,
          now: now,
          incomingTrustLevel: MatchTrustLevel.alto,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });
  });

  group('matcherInvalidated', () {
    test('detectable → referenciada + limpia platformActor y trust', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.detectable,
        targetPlatformActorId: 'actor-1',
        matchTrustLevel: MatchTrustLevel.alto,
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.matcherInvalidated,
        now: now,
      );

      expect(t.nextState, RelationshipState.referenciada);
      expect(t.clearPlatformActor, isTrue);
      expect(t.clearMatchTrustLevel, isTrue);
      expect(t.stateUpdatedAt, now);
    });

    test('desde referenciada lanza', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.matcherInvalidated,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });
  });

  group('deliveryDispatched (regla de activación real)', () {
    test('referenciada → activadaUnilateral (sin platformActor permitido)', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.deliveryDispatched,
        now: now,
      );

      expect(t.nextState, RelationshipState.activadaUnilateral);
      expect(t.activatedUnilaterallyAt, now);
      expect(t.stateUpdatedAt, now);
      // No exige platformActor: la degradable funciona sin match confirmado.
      expect(t.clearPlatformActor, isFalse);
    });

    test('detectable → activadaUnilateral', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.detectable,
        targetPlatformActorId: 'actor-1',
        matchTrustLevel: MatchTrustLevel.alto,
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.deliveryDispatched,
        now: now,
      );

      expect(t.nextState, RelationshipState.activadaUnilateral);
      expect(t.activatedUnilaterallyAt, now);
    });

    test('desde vinculada lanza (ya está habilitada, nada que activar)', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.vinculada,
        targetPlatformActorId: 'actor-1',
      );

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.deliveryDispatched,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });
  });

  group('invitationAccepted', () {
    test('activadaUnilateral + platformActor → vinculada', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.activadaUnilateral,
        targetPlatformActorId: 'actor-1',
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.invitationAccepted,
        now: now,
      );

      expect(t.nextState, RelationshipState.vinculada);
      expect(t.linkedAt, now);
      expect(t.stateUpdatedAt, now);
    });

    test('sin platformActor lanza (vinculada exige match)', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.activadaUnilateral,
      );

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.invitationAccepted,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });

    test('desde referenciada lanza', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.referenciada,
        targetPlatformActorId: 'actor-1',
      );

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.invitationAccepted,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });
  });

  group('invitationExpired / invitationRevoked', () {
    test('activadaUnilateral → referenciada + clean slate', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.activadaUnilateral,
        targetPlatformActorId: 'actor-1',
        matchTrustLevel: MatchTrustLevel.alto,
      );

      for (final event in [
        RelationshipEvent.invitationExpired,
        RelationshipEvent.invitationRevoked,
      ]) {
        final t = transitionRelationship(
          current: snap,
          event: event,
          now: now,
        );

        expect(t.nextState, RelationshipState.referenciada);
        expect(t.clearPlatformActor, isTrue);
        expect(t.clearMatchTrustLevel, isTrue);
      }
    });

    test('desde vinculada lanza', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.vinculada,
        targetPlatformActorId: 'actor-1',
      );

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.invitationExpired,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });
  });

  group('suspend / resume', () {
    test('vinculada + razón → suspendida con suspensionReason', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.vinculada,
        targetPlatformActorId: 'actor-1',
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.suspend,
        now: now,
        suspensionReason: RelationshipSuspensionReason.userRequested,
      );

      expect(t.nextState, RelationshipState.suspendida);
      expect(t.suspendedAt, now);
      expect(t.suspensionReason, RelationshipSuspensionReason.userRequested);
      expect(t.stateUpdatedAt, now);
    });

    test('suspend sin razón lanza', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.vinculada,
        targetPlatformActorId: 'actor-1',
      );

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.suspend,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });

    test('suspendida → vinculada (resume) + clearSuspensionReason', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.suspendida,
        targetPlatformActorId: 'actor-1',
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.resume,
        now: now,
      );

      expect(t.nextState, RelationshipState.vinculada);
      expect(t.clearSuspensionReason, isTrue);
      // resume no cambia linkedAt (se preserva la fecha original del vínculo).
      expect(t.linkedAt, isNull);
    });

    test('resume desde referenciada lanza', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      expect(
        () => transitionRelationship(
          current: snap,
          event: RelationshipEvent.resume,
          now: now,
        ),
        throwsA(isA<IllegalRelationshipTransition>()),
      );
    });
  });

  group('close', () {
    test('desde activadaUnilateral → cerrada', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.activadaUnilateral,
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.close,
        now: now,
      );

      expect(t.nextState, RelationshipState.cerrada);
      expect(t.closedAt, now);
    });

    test('desde vinculada → cerrada', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.vinculada,
        targetPlatformActorId: 'actor-1',
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.close,
        now: now,
      );

      expect(t.nextState, RelationshipState.cerrada);
      expect(t.closedAt, now);
    });

    test('desde suspendida → cerrada', () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.suspendida,
        targetPlatformActorId: 'actor-1',
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.close,
        now: now,
      );

      expect(t.nextState, RelationshipState.cerrada);
      expect(t.closedAt, now);
    });

    test('desde referenciada → cerrada (cierre administrativo local)', () {
      const snap = RelationshipSnapshot(state: RelationshipState.referenciada);

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.close,
        now: now,
      );

      expect(t.nextState, RelationshipState.cerrada);
      expect(t.closedAt, now);
      expect(t.stateUpdatedAt, now);
      // No exige ni toca platformActor / matchTrustLevel.
      expect(t.clearPlatformActor, isFalse);
      expect(t.clearMatchTrustLevel, isFalse);
    });

    test(
        'desde detectable → cerrada (preserva match info para auditoría)',
        () {
      const snap = RelationshipSnapshot(
        state: RelationshipState.detectable,
        targetPlatformActorId: 'actor-1',
        matchTrustLevel: MatchTrustLevel.alto,
      );

      final t = transitionRelationship(
        current: snap,
        event: RelationshipEvent.close,
        now: now,
      );

      expect(t.nextState, RelationshipState.cerrada);
      expect(t.closedAt, now);
      // No limpia: el match confirmado se preserva como histórico.
      expect(t.clearPlatformActor, isFalse);
      expect(t.clearMatchTrustLevel, isFalse);
    });
  });

  group('terminal cerrada', () {
    test('cerrada bloquea todos los eventos', () {
      const snap = RelationshipSnapshot(state: RelationshipState.cerrada);

      for (final event in RelationshipEvent.values) {
        expect(
          () => transitionRelationship(
            current: snap,
            event: event,
            now: now,
            incomingPlatformActorId: 'actor-1',
            incomingTrustLevel: MatchTrustLevel.alto,
            suspensionReason: RelationshipSuspensionReason.userRequested,
          ),
          throwsA(isA<IllegalRelationshipTransition>()),
          reason:
              'evento $event debe ser rechazado desde cerrada (terminal dura)',
        );
      }
    });
  });

  group('IllegalRelationshipTransition', () {
    test('toString incluye from, event y reason', () {
      const snap = RelationshipSnapshot(state: RelationshipState.cerrada);

      try {
        transitionRelationship(
          current: snap,
          event: RelationshipEvent.close,
          now: now,
        );
        fail('debería haber lanzado');
      } on IllegalRelationshipTransition catch (e) {
        final s = e.toString();
        expect(s, contains('cerrada'));
        expect(s, contains('close'));
        expect(s, contains('terminal dura'));
      }
    });
  });
}

// ============================================================================
// test/domain/services/core_common/trust_level_evaluator_test.dart
// TRUST LEVEL EVALUATOR — Tests (F4.a)
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/actor_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_trust_level.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/normalized_key.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/verified_key_type.dart';
import 'package:avanzza/domain/services/core_common/trust_level_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const docId = VerifiedKeyType.docId;
  const phone = VerifiedKeyType.phoneE164;
  const email = VerifiedKeyType.email;

  NormalizedKey k(VerifiedKeyType t, String v) =>
      NormalizedKey(keyType: t, normalizedValue: v);

  group('organization', () {
    test('docId match → alto', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.organization,
          candidateKeys: [k(docId, '900123456')],
          localProbes: [k(docId, '900123456')],
        ),
        MatchTrustLevel.alto,
      );
    });

    test('phoneE164 match (sin docId) → medio', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.organization,
          candidateKeys: [k(phone, '+573001234567')],
          localProbes: [k(phone, '+573001234567')],
        ),
        MatchTrustLevel.medio,
      );
    });

    test('email match (sin docId) → medio', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.organization,
          candidateKeys: [k(email, 'contacto@acme.co')],
          localProbes: [k(email, 'contacto@acme.co')],
        ),
        MatchTrustLevel.medio,
      );
    });

    test('docId + email match → alto (máximo individual)', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.organization,
          candidateKeys: [
            k(docId, '900123456'),
            k(email, 'contacto@acme.co'),
          ],
          localProbes: [
            k(docId, '900123456'),
            k(email, 'contacto@acme.co'),
          ],
        ),
        MatchTrustLevel.alto,
      );
    });
  });

  group('person', () {
    test('phoneE164 match → alto', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: [k(phone, '+573009876543')],
          localProbes: [k(phone, '+573009876543')],
        ),
        MatchTrustLevel.alto,
      );
    });

    test('docId match (sin phone) → medio', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: [k(docId, '1020304050')],
          localProbes: [k(docId, '1020304050')],
        ),
        MatchTrustLevel.medio,
      );
    });

    test('email match (sin phone) → medio', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: [k(email, 'juan@empresa.co')],
          localProbes: [k(email, 'juan@empresa.co')],
        ),
        MatchTrustLevel.medio,
      );
    });

    test('phone + email match → alto', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: [
            k(phone, '+573009876543'),
            k(email, 'juan@empresa.co'),
          ],
          localProbes: [
            k(phone, '+573009876543'),
            k(email, 'juan@empresa.co'),
          ],
        ),
        MatchTrustLevel.alto,
      );
    });

    test('dos MEDIUM NO escalan a ALTO (sin combo-boost)', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: [
            k(docId, '1020304050'),
            k(email, 'juan@empresa.co'),
          ],
          localProbes: [
            k(docId, '1020304050'),
            k(email, 'juan@empresa.co'),
          ],
        ),
        MatchTrustLevel.medio,
      );
    });
  });

  group('sin match', () {
    test('tipos distintos NO matchean', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.organization,
          candidateKeys: [k(docId, '900123456')],
          localProbes: [k(phone, '900123456')],
        ),
        MatchTrustLevel.bajo,
      );
    });

    test('valores distintos NO matchean', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.organization,
          candidateKeys: [k(docId, '900123456')],
          localProbes: [k(docId, '900999999')],
        ),
        MatchTrustLevel.bajo,
      );
    });

    test('candidateKeys vacío → bajo', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: const <NormalizedKey>[],
          localProbes: [k(phone, '+573001234567')],
        ),
        MatchTrustLevel.bajo,
      );
    });

    test('localProbes vacío → bajo', () {
      expect(
        evaluateTrust(
          candidateActorKind: ActorKind.person,
          candidateKeys: [k(phone, '+573001234567')],
          localProbes: const <NormalizedKey>[],
        ),
        MatchTrustLevel.bajo,
      );
    });
  });

  group('determinismo', () {
    test('misma entrada → misma salida', () {
      final input = [k(phone, '+573001234567'), k(email, 'juan@empresa.co')];

      final r1 = evaluateTrust(
        candidateActorKind: ActorKind.person,
        candidateKeys: input,
        localProbes: input,
      );
      final r2 = evaluateTrust(
        candidateActorKind: ActorKind.person,
        candidateKeys: input,
        localProbes: input,
      );
      expect(r1, r2);
    });
  });

  group('determinismo final feliz (alto cortocircuita)', () {
    test('docId match en primera probe de org → alto sin evaluar el resto', () {
      final result = evaluateTrust(
        candidateActorKind: ActorKind.organization,
        candidateKeys: [
          k(docId, '900123456'),
          k(email, 'contacto@acme.co'),
        ],
        localProbes: [
          k(docId, '900123456'),
          k(email, 'no-importa@otro.co'),
        ],
      );
      expect(result, MatchTrustLevel.alto);
    });
  });
}

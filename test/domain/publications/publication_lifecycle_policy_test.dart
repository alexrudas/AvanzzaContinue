import 'package:avanzza/domain/publications/services/publication_lifecycle_policy.dart';
import 'package:avanzza/domain/publications/value_objects/publication_status.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mock implementation de LifecyclePlanPolicy para tests.
class MockLifecyclePlanPolicy implements LifecyclePlanPolicy {
  @override
  bool hasCredits;

  @override
  bool canUseFreeOnce;

  final Set<String> _processedRequests = {};
  bool consumeForRenewalCalled = false;

  MockLifecyclePlanPolicy({
    this.hasCredits = false,
    this.canUseFreeOnce = false,
  });

  @override
  void consumeForRenewal() {
    consumeForRenewalCalled = true;
  }

  @override
  bool isRequestProcessed(String requestId) {
    return _processedRequests.contains(requestId);
  }

  @override
  void markRequestProcessed(String requestId) {
    _processedRequests.add(requestId);
  }

  void reset() {
    _processedRequests.clear();
    consumeForRenewalCalled = false;
  }
}

void main() {
  group('PublicationLifecyclePolicy', () {
    late DateTime nowUtc;
    late String requestId;

    setUp(() {
      nowUtc = DateTime.utc(2025, 1, 15, 10, 30);
      requestId = 'test-request-123';
    });

    group('transiciones válidas del grafo', () {
      test('active → paused es exitoso', () {
        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.active,
          to: PublicationStatus.paused,
          reason: PublicationTransitionReason.userPause,
          nowUtc: nowUtc,
          requestId: requestId,
        );

        expect(result, isA<LifecycleSuccess>());
        final success = result as LifecycleSuccess;
        expect(success.from, PublicationStatus.active);
        expect(success.to, PublicationStatus.paused);
        expect(success.reason, PublicationTransitionReason.userPause);
        expect(success.processedAtUtc, nowUtc);
      });

      test('paused → active es exitoso sin consumir créditos', () {
        final policy = MockLifecyclePlanPolicy(hasCredits: true);

        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.paused,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.userResume,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: policy,
        );

        expect(result, isA<LifecycleSuccess>());
        final success = result as LifecycleSuccess;
        expect(success.from, PublicationStatus.paused);
        expect(success.to, PublicationStatus.active);
        expect(success.audit['creditsConsumed'], 0);
        expect(policy.consumeForRenewalCalled, isFalse);
      });

      test('active → expired con reason planExpired es exitoso', () {
        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.active,
          to: PublicationStatus.expired,
          reason: PublicationTransitionReason.planExpired,
          nowUtc: nowUtc,
          requestId: requestId,
        );

        expect(result, isA<LifecycleSuccess>());
        final success = result as LifecycleSuccess;
        expect(success.from, PublicationStatus.active);
        expect(success.to, PublicationStatus.expired);
        expect(success.audit['automatic'], isTrue);
      });

      test('cualquier estado → closed es exitoso (terminal)', () {
        for (final from in PublicationStatus.values) {
          if (from == PublicationStatus.closed) continue;

          final result = PublicationLifecyclePolicy.transition(
            from: from,
            to: PublicationStatus.closed,
            reason: PublicationTransitionReason.userClose,
            nowUtc: nowUtc,
            requestId: 'req-close-${from.wireName}',
          );

          expect(result, isA<LifecycleSuccess>(),
              reason: 'Debe permitir ${from.wireName} → closed');
          final success = result as LifecycleSuccess;
          expect(success.to, PublicationStatus.closed);
          expect(success.audit['terminal'], isTrue);
        }
      });
    });

    group('transiciones inválidas del grafo', () {
      test('active → active falla con not_allowed', () {
        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.active,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.userResume,
          nowUtc: nowUtc,
          requestId: requestId,
        );

        expect(result, isA<LifecycleFailure>());
        final failure = result as LifecycleFailure;
        expect(failure.code, 'not_allowed');
      });

      test('closed → active falla con not_allowed (terminal)', () {
        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.closed,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.planRenewed,
          nowUtc: nowUtc,
          requestId: requestId,
        );

        expect(result, isA<LifecycleFailure>());
        final failure = result as LifecycleFailure;
        expect(failure.code, 'not_allowed');
      });
    });

    group('renovación desde expired', () {
      test('expired → active sin policy falla con policy_missing', () {
        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.expired,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.planRenewed,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: null,
        );

        expect(result, isA<LifecycleFailure>());
        final failure = result as LifecycleFailure;
        expect(failure.code, 'policy_missing');
      });

      test(
          'expired → active sin créditos ni freeOnce falla con credits_required',
          () {
        final policy = MockLifecyclePlanPolicy(
          hasCredits: false,
          canUseFreeOnce: false,
        );

        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.expired,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.planRenewed,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: policy,
        );

        expect(result, isA<LifecycleFailure>());
        final failure = result as LifecycleFailure;
        expect(failure.code, 'credits_required');
      });

      test('expired → active con créditos es exitoso y consume créditos', () {
        final policy = MockLifecyclePlanPolicy(
          hasCredits: true,
          canUseFreeOnce: false,
        );

        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.expired,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.planRenewed,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: policy,
        );

        expect(result, isA<LifecycleSuccess>());
        expect(policy.consumeForRenewalCalled, isTrue);
        final success = result as LifecycleSuccess;
        expect(success.audit['renewed'], isTrue);
      });

      test('expired → active con freeOnce es exitoso sin consumir créditos',
          () {
        final policy = MockLifecyclePlanPolicy(
          hasCredits: false,
          canUseFreeOnce: true,
        );

        final result = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.expired,
          to: PublicationStatus.active,
          reason: PublicationTransitionReason.planRenewed,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: policy,
        );

        expect(result, isA<LifecycleSuccess>());
        expect(policy.consumeForRenewalCalled, isFalse);
      });
    });

    group('idempotencia', () {
      test('duplicate_operation si requestId ya fue procesado', () {
        final policy = MockLifecyclePlanPolicy(hasCredits: true);

        // Primera transición
        final result1 = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.active,
          to: PublicationStatus.paused,
          reason: PublicationTransitionReason.userPause,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: policy,
        );

        expect(result1, isA<LifecycleSuccess>());

        // Segunda transición con mismo requestId
        final result2 = PublicationLifecyclePolicy.transition(
          from: PublicationStatus.active,
          to: PublicationStatus.paused,
          reason: PublicationTransitionReason.userPause,
          nowUtc: nowUtc,
          requestId: requestId,
          planPolicy: policy,
        );

        expect(result2, isA<LifecycleFailure>());
        final failure = result2 as LifecycleFailure;
        expect(failure.code, 'duplicate_operation');
        expect(failure.metadata['requestId'], requestId);
      });
    });

    group('validación UTC', () {
      test('assert falla si nowUtc no es UTC', () {
        expect(
          () => PublicationLifecyclePolicy.transition(
            from: PublicationStatus.active,
            to: PublicationStatus.paused,
            reason: PublicationTransitionReason.userPause,
            nowUtc: DateTime(2025, 1, 15, 10, 30), // No UTC
            requestId: requestId,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}

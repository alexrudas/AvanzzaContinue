// ============================================================================
// test/domain/policy/core_common/request_channel_policy_test.dart
// REQUEST CHANNEL POLICY — Tests unitarios (F2.b blindaje)
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/delivery_channel.dart';
import 'package:avanzza/domain/policy/core_common/request_channel_policy.dart';
import 'package:avanzza/domain/services/core_common/request_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = RequestChannelPolicy();

  group('markDelivered', () {
    test('inApp: pasa (tiene ACK nativo)', () {
      expect(
        () => policy.guardChannelSupports(
          event: RequestEvent.markDelivered,
          channel: DeliveryChannel.inApp,
        ),
        returnsNormally,
      );
    });

    test('whatsappExternal: lanza', () {
      expect(
        () => policy.guardChannelSupports(
          event: RequestEvent.markDelivered,
          channel: DeliveryChannel.whatsappExternal,
        ),
        throwsA(isA<RequestChannelPolicyViolation>()),
      );
    });

    test('emailExternal: lanza', () {
      expect(
        () => policy.guardChannelSupports(
          event: RequestEvent.markDelivered,
          channel: DeliveryChannel.emailExternal,
        ),
        throwsA(isA<RequestChannelPolicyViolation>()),
      );
    });

    test('manual: lanza', () {
      expect(
        () => policy.guardChannelSupports(
          event: RequestEvent.markDelivered,
          channel: DeliveryChannel.manual,
        ),
        throwsA(isA<RequestChannelPolicyViolation>()),
      );
    });

    test('mensaje explica la asimetría con confirmedByEmitter', () {
      try {
        policy.guardChannelSupports(
          event: RequestEvent.markDelivered,
          channel: DeliveryChannel.whatsappExternal,
        );
        fail('debería haber lanzado');
      } on RequestChannelPolicyViolation catch (e) {
        expect(e.toString(), contains('confirmedByEmitter'));
        expect(e.toString(), contains('NO es equivalente'));
      }
    });
  });

  group('markSeen', () {
    test('inApp: pasa', () {
      expect(
        () => policy.guardChannelSupports(
          event: RequestEvent.markSeen,
          channel: DeliveryChannel.inApp,
        ),
        returnsNormally,
      );
    });

    test('canales externos: lanzan', () {
      for (final ch in [
        DeliveryChannel.whatsappExternal,
        DeliveryChannel.emailExternal,
        DeliveryChannel.manual,
      ]) {
        expect(
          () => policy.guardChannelSupports(
            event: RequestEvent.markSeen,
            channel: ch,
          ),
          throwsA(isA<RequestChannelPolicyViolation>()),
          reason: 'markSeen debe rechazarse desde ${ch.wireName}',
        );
      }
    });
  });

  group('eventos NO sensibles a canal (no-op)', () {
    test('send, markResponded, accept, reject, expire, close pasan en cualquier canal',
        () {
      const noOpEvents = [
        RequestEvent.send,
        RequestEvent.markResponded,
        RequestEvent.accept,
        RequestEvent.reject,
        RequestEvent.expire,
        RequestEvent.close,
      ];

      for (final event in noOpEvents) {
        for (final ch in DeliveryChannel.values) {
          expect(
            () => policy.guardChannelSupports(event: event, channel: ch),
            returnsNormally,
            reason: '$event en ${ch.wireName} debe pasar (no sensible a canal)',
          );
        }
      }
    });
  });

  group('channelSensitiveEvents', () {
    test('expone exactamente {markDelivered, markSeen}', () {
      expect(
        RequestChannelPolicy.channelSensitiveEvents,
        {RequestEvent.markDelivered, RequestEvent.markSeen},
      );
    });
  });
}

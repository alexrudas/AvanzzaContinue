// ============================================================================
// test/data/models/network/network_action_dto_test.dart
// NetworkActionDto.fromJson — invariantes y forward-compat de enums
// ============================================================================

import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _action({
  String type = 'call',
  bool enabled = true,
  String? domain,
  String? capability,
  String? reason,
}) =>
    {
      'type': type,
      'enabled': enabled,
      'domain': domain,
      'capability': capability,
      if (reason != null) 'reason': reason,
    };

void main() {
  group('NetworkActionDto — parse válido', () {
    test('acción habilitada simple (call) sin domain ni capability', () {
      final dto = NetworkActionDto.fromJson(_action(type: 'call'));
      expect(dto.type, NetworkActionType.call);
      expect(dto.enabled, isTrue);
      expect(dto.domain, isNull);
      expect(dto.capability, isNull);
      expect(dto.reason, isNull);
    });

    test('acción request_quote con domain y capability', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'request_quote',
        domain: 'purchase-request',
        capability: 'purchase_request.create',
      ));
      expect(dto.type, NetworkActionType.requestQuote);
      expect(dto.domain, NetworkActionDomain.purchaseRequest);
      expect(dto.capability, NetworkActionCapability.purchaseRequestCreate);
    });

    test('view_provider_profile con provider.read', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'view_provider_profile',
        domain: 'provider',
        capability: 'provider.read',
      ));
      expect(dto.type, NetworkActionType.viewProviderProfile);
      expect(dto.domain, NetworkActionDomain.provider);
      expect(dto.capability, NetworkActionCapability.providerRead);
    });

    test('start_coordination_flow con coordination-flow', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'start_coordination_flow',
        domain: 'coordination-flow',
      ));
      expect(dto.type, NetworkActionType.startCoordinationFlow);
      expect(dto.domain, NetworkActionDomain.coordinationFlow);
    });
  });

  group('NetworkActionDto — invariante enabled=false ⇒ reason', () {
    test('disabled con reason válido parsea', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'whatsapp',
        enabled: false,
        reason: 'phone_not_available',
      ));
      expect(dto.enabled, isFalse);
      expect(dto.reason, NetworkActionDisabledReason.phoneNotAvailable);
    });

    test('disabled sin reason lanza FormatException', () {
      expect(
        () => NetworkActionDto.fromJson(_action(
          type: 'email',
          enabled: false,
        )),
        throwsFormatException,
      );
    });

    test('enabled=true puede venir con reason informativo', () {
      // El contrato no prohíbe esto, solo exige reason cuando enabled=false.
      final dto = NetworkActionDto.fromJson(_action(
        type: 'call',
        enabled: true,
        reason: 'phone_not_available',
      ));
      expect(dto.enabled, isTrue);
      expect(dto.reason, NetworkActionDisabledReason.phoneNotAvailable);
    });
  });

  group('NetworkActionDto — forward-compat de enums', () {
    test('reason desconocido cae a "other"', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'call',
        enabled: false,
        reason: 'kyc_pending', // valor futuro no listado
      ));
      expect(dto.reason, NetworkActionDisabledReason.other);
    });

    test('"other" se parsea explícitamente', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'call',
        enabled: false,
        reason: 'other',
      ));
      expect(dto.reason, NetworkActionDisabledReason.other);
    });

    test('capability desconocido cae a unknownCapability y preserva raw', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'call',
        capability: 'future.capability',
      ));
      expect(dto.capability, NetworkActionCapability.unknownCapability);
      expect(dto.rawUnknownCapability, 'future.capability');
    });

    test('domain desconocido se mapea a null (no rompe parse)', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'call',
        domain: 'future-domain',
      ));
      expect(dto.domain, isNull);
    });
  });

  group('NetworkActionDto — type estricto (fail-fast, sin fallback silencioso)', () {
    test('type desconocido lanza FormatException', () {
      expect(
        () => NetworkActionDto.fromJson(_action(type: 'morse_code')),
        throwsFormatException,
      );
    });

    test('mensaje de excepción incluye el valor recibido (debugging)', () {
      try {
        NetworkActionDto.fromJson(_action(type: 'sms_blast'));
        fail('debió lanzar FormatException');
      } on FormatException catch (e) {
        expect(e.message, contains('sms_blast'));
        expect(e.message, contains('NetworkActionType'));
      }
    });

    test('múltiples valores desconocidos lanzan consistentemente', () {
      const desconocidos = [
        'fax',
        'pigeon',
        'CALL', // case-sensitive: mayúsculas tampoco matchean
        'CallType',
        'request_quote_v2',
      ];
      for (final t in desconocidos) {
        expect(
          () => NetworkActionDto.fromJson(_action(type: t)),
          throwsFormatException,
          reason: 'type="$t" debería lanzar',
        );
      }
    });

    test('NO existe enum value para el typo: confirma fail-fast', () {
      // Salvaguarda contra regresión: si alguien agrega un valor con typo
      // al enum, este test sigue verificando que "morse_code" NO matchea.
      final typos = NetworkActionType.values
          .where((v) => v.wireName == 'morse_code');
      expect(typos, isEmpty);
    });
  });

  group('NetworkActionDto — round-trip toJson', () {
    test('toJson preserva campos canónicos', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'request_quote',
        domain: 'purchase-request',
        capability: 'purchase_request.create',
      ));
      final json = dto.toJson();
      expect(json['type'], 'request_quote');
      expect(json['enabled'], isTrue);
      expect(json['domain'], 'purchase-request');
      expect(json['capability'], 'purchase_request.create');
    });

    test('toJson con capability desconocido emite el raw original', () {
      final dto = NetworkActionDto.fromJson(_action(
        type: 'call',
        capability: 'future.capability',
      ));
      expect(dto.toJson()['capability'], 'future.capability');
    });
  });
}

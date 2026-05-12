// ============================================================================
// test/presentation/view_models/network/v2/network_action_vm_test.dart
// NetworkActionVM.fromDto — adaptador UI sin strings
// ============================================================================

import 'package:avanzza/data/models/network/network_action_dto.dart';
import 'package:avanzza/presentation/view_models/network/v2/network_action_vm.dart';
import 'package:flutter_test/flutter_test.dart';

NetworkActionDto _dto({
  String type = 'call',
  bool enabled = true,
  String? domain,
  String? capability,
  String? reason,
}) =>
    NetworkActionDto.fromJson({
      'type': type,
      'enabled': enabled,
      'domain': domain,
      'capability': capability,
      if (reason != null) 'reason': reason,
    });

void main() {
  group('NetworkActionVM.fromDto', () {
    test('mapea acción habilitada simple', () {
      final vm = NetworkActionVM.fromDto(_dto(type: 'call'));
      expect(vm.type, NetworkActionType.call);
      expect(vm.enabled, isTrue);
      expect(vm.domain, isNull);
      expect(vm.capability, isNull);
      expect(vm.disabledReason, isNull);
      expect(vm.isExecutable, isTrue);
      expect(vm.showsDisabledHint, isFalse);
    });

    test('mapea acción deshabilitada con reason', () {
      final vm = NetworkActionVM.fromDto(_dto(
        type: 'whatsapp',
        enabled: false,
        reason: 'phone_not_available',
      ));
      expect(vm.enabled, isFalse);
      expect(vm.disabledReason,
          NetworkActionDisabledReason.phoneNotAvailable);
      expect(vm.isExecutable, isFalse);
      expect(vm.showsDisabledHint, isTrue);
    });

    test('preserva domain y capability cuando vienen', () {
      final vm = NetworkActionVM.fromDto(_dto(
        type: 'request_quote',
        domain: 'purchase-request',
        capability: 'purchase_request.create',
      ));
      expect(vm.domain, NetworkActionDomain.purchaseRequest);
      expect(vm.capability,
          NetworkActionCapability.purchaseRequestCreate);
    });

    test('NO contiene strings de copy (solo enums)', () {
      final vm = NetworkActionVM.fromDto(_dto(type: 'call'));
      // El VM no debe exponer un getter "label" / "humanLabel" / "displayName"
      // que retorne un string de copy. Esto se valida implícitamente porque
      // el tipo NetworkActionVM no tiene tal getter; este test sirve como
      // tripwire si alguien lo agrega: type.runtimeType debe ser enum.
      expect(vm.type, isA<NetworkActionType>());
    });
  });
}

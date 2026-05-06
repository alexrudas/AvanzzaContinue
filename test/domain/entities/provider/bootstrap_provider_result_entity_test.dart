// ============================================================================
// test/domain/entities/provider/bootstrap_provider_result_entity_test.dart
// MF1 — Mapper de BootstrapProviderResultEntity.
// ============================================================================

import 'package:avanzza/domain/entities/provider/bootstrap_provider_result_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BootstrapProviderResultEntity.fromJson hidrata los 3 campos', () {
    final entity = BootstrapProviderResultEntity.fromJson({
      'providerProfileId': 'pp-bob',
      'workspaceId': 'ws-bob',
      'created': true,
    });
    expect(entity.providerProfileId, 'pp-bob');
    expect(entity.workspaceId, 'ws-bob');
    expect(entity.created, isTrue);
  });

  test('campo created ausente → default true por contrato del backend', () {
    final entity = BootstrapProviderResultEntity.fromJson({
      'providerProfileId': 'pp-x',
      'workspaceId': 'ws-x',
    });
    expect(entity.created, isTrue);
  });
}

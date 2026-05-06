// ============================================================================
// test/domain/entities/provider/provider_me_entity_test.dart
// MF1 — Mapper de ProviderMeEntity. Verifica el contrato exacto del wire.
// ============================================================================

import 'package:avanzza/domain/entities/provider/provider_me_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProviderMeEntity.fromJson — MF1 contract', () {
    test('hidrata isProvider=true con providerProfile + specialties + caps', () {
      final json = <String, dynamic>{
        'workspaceId': 'ws-bob',
        'isProvider': true,
        'providerProfile': {
          'providerProfileId': 'pp-bob',
          'platformActorId': 'pa-bob',
          'displayName': 'Bob Provider',
          'isActive': true,
          'updatedAt': '2026-04-27T10:00:00.000Z',
        },
        'specialties': [
          {
            'id': 'sp-engine',
            'key': 'engine_repair',
            'name': 'Reparación de motor',
            'kind': 'SERVICE',
          },
          {
            'id': 'sp-tires',
            'key': 'tires',
            'name': 'Llantas',
            'kind': 'PRODUCT',
          },
        ],
        'assetTypes': [
          {'id': 'vehicle.car', 'name': 'Auto'},
        ],
        'capabilities': [
          'provider.read',
          'provider.invite_agent',
          'provider.revoke_agent',
          'provider.agent_invitation.read',
          'purchase_request.read',
        ],
      };

      final me = ProviderMeEntity.fromJson(json);

      expect(me.workspaceId, 'ws-bob');
      expect(me.isProvider, isTrue);
      expect(me.providerProfile, isNotNull);
      expect(me.providerProfile!.providerProfileId, 'pp-bob');
      expect(me.providerProfile!.platformActorId, 'pa-bob');
      expect(me.providerProfile!.displayName, 'Bob Provider');
      expect(me.providerProfile!.isActive, isTrue);
      expect(me.specialties.length, 2);
      expect(me.specialties.first.kind, 'SERVICE');
      expect(me.assetTypes.length, 1);
      expect(me.assetTypes.first.id, 'vehicle.car');
      // Capabilities admin (criterio de cierre MF1).
      expect(me.hasInviteAgentCapability, isTrue);
      expect(me.hasReadAgentInvitationsCapability, isTrue);
    });

    test('isProvider=false con providerProfile=null y arrays vacíos', () {
      final json = <String, dynamic>{
        'workspaceId': 'ws-x',
        'isProvider': false,
        'providerProfile': null,
        'specialties': [],
        'assetTypes': [],
        'capabilities': ['purchase_request.read', 'provider.read'],
      };

      final me = ProviderMeEntity.fromJson(json);

      expect(me.isProvider, isFalse);
      expect(me.providerProfile, isNull);
      expect(me.specialties, isEmpty);
      expect(me.assetTypes, isEmpty);
      expect(me.hasInviteAgentCapability, isFalse);
      expect(me.hasReadAgentInvitationsCapability, isFalse);
    });

    test('campos opcionales ausentes → defaults seguros', () {
      // El backend siempre los emite; defensa por wire-versioning.
      final json = <String, dynamic>{
        'workspaceId': 'ws-x',
        // isProvider, specialties, assetTypes, capabilities ausentes.
      };

      final me = ProviderMeEntity.fromJson(json);

      expect(me.isProvider, isFalse);
      expect(me.specialties, isEmpty);
      expect(me.assetTypes, isEmpty);
      expect(me.capabilities, isEmpty);
    });
  });
}

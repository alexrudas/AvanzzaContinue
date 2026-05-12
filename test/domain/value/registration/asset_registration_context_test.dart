// ============================================================================
// test/domain/value/registration/asset_registration_context_test.dart
// Tests del value object [AssetRegistrationContext].
// ============================================================================
// Cubre:
//   - Construcción "legacy" (sin vrcSnapshot ni expectedRelationKind) sigue
//     compilando — backward compat con entry points Step1, PortfolioDetail,
//     PortfolioAssetList, AssetDetail.
//   - Construcción con expectedRelationKind preservado.
//   - Construcción con vrcSnapshot preservado.
//   - Construcción con ambos campos opcionales.
//   - toString incluye los nuevos campos sin crashear cuando son null.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/registration/asset_registration_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssetRegistrationContext — construcción legacy (backward compat)',
      () {
    test('compila sin pasar vrcSnapshot ni expectedRelationKind', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        cityId: 'CO-ANT-MEDELLIN',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: '11111111-1111-4111-8111-111111111111',
      );
      expect(ctx.vrcSnapshot, isNull);
      expect(ctx.expectedRelationKind, isNull);
      expect(ctx.initialPlate, isNull);
    });

    test('compila pasando solo initialPlate (entry point AssetDetail)', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        cityId: null,
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
        initialPlate: 'ABC123',
      );
      expect(ctx.initialPlate, 'ABC123');
      expect(ctx.vrcSnapshot, isNull);
      expect(ctx.expectedRelationKind, isNull);
    });
  });

  group('AssetRegistrationContext — con expectedRelationKind', () {
    test('preserva AssetActorRole.owner', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
        expectedRelationKind: AssetActorRole.owner,
      );
      expect(ctx.expectedRelationKind, AssetActorRole.owner);
    });

    test('preserva AssetActorRole.manager (rol introducido en 2026-05)', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        assetType: AssetRegistrationType.maquinaria,
        registrationSessionId: 'session-uuid',
        expectedRelationKind: AssetActorRole.manager,
      );
      expect(ctx.expectedRelationKind, AssetActorRole.manager);
    });

    test('preserva AssetActorRole.tenant (arrendatario inquilino)', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mis inmuebles',
        countryId: 'CO',
        assetType: AssetRegistrationType.inmueble,
        registrationSessionId: 'session-uuid',
        expectedRelationKind: AssetActorRole.tenant,
      );
      expect(ctx.expectedRelationKind, AssetActorRole.tenant);
    });
  });

  group('AssetRegistrationContext — con vrcSnapshot', () {
    test('preserva snapshot poblado', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
        vrcSnapshot: {'placa': 'ABC123', 'marca': 'Toyota'},
      );
      expect(ctx.vrcSnapshot, {'placa': 'ABC123', 'marca': 'Toyota'});
    });

    test('snapshot vacío se preserva (no se confunde con null)', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
        vrcSnapshot: <String, String>{},
      );
      expect(ctx.vrcSnapshot, isNotNull);
      expect(ctx.vrcSnapshot, isEmpty);
    });
  });

  group('AssetRegistrationContext — con ambos campos opcionales', () {
    test('vrcSnapshot + expectedRelationKind se conservan independientes',
        () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        cityId: 'CO-ANT-MEDELLIN',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
        vrcSnapshot: {'placa': 'ABC123'},
        expectedRelationKind: AssetActorRole.owner,
      );
      expect(ctx.vrcSnapshot, {'placa': 'ABC123'});
      expect(ctx.expectedRelationKind, AssetActorRole.owner);
    });
  });

  group('AssetRegistrationContext — toString', () {
    test('no crashea con campos opcionales null', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
      );
      final str = ctx.toString();
      expect(str, contains('portfolioId=pf-1'));
      expect(str, contains('vrcSnapshot=null'));
      expect(str, contains('expectedRelationKind=null'));
    });

    test('refleja conteo de keys del snapshot y wireName del rol', () {
      const ctx = AssetRegistrationContext(
        portfolioId: 'pf-1',
        portfolioName: 'Mi flota',
        countryId: 'CO',
        assetType: AssetRegistrationType.vehiculo,
        registrationSessionId: 'session-uuid',
        vrcSnapshot: {'placa': 'ABC', 'marca': 'Toyota'},
        expectedRelationKind: AssetActorRole.manager,
      );
      final str = ctx.toString();
      expect(str, contains('vrcSnapshot=2 keys'));
      expect(str, contains('expectedRelationKind=manager'));
    });
  });
}

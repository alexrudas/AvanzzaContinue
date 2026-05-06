// ============================================================================
// test/presentation/demo_registration_v2/fusionado/onboarding_asset_handoff_mapper_test.dart
// Tests del mapper puro WorkspaceBootstrapResult+DemoRegistrationState ⇒
// AssetRegistrationContext.
// ============================================================================
// Cubre:
//   - portfolio == null ⇒ retorna null (no handoff).
//   - portfolio != null ⇒ retorna context tipado con todos los campos
//     canónicos.
//   - assetType demo se mapea a AssetRegistrationType correspondiente,
//     incluyendo el caso degenerado state.assetType==null ⇒ otro.
//   - vrcSnapshot:
//       · state.assetData vacío    ⇒ campo null.
//       · state.assetData poblado  ⇒ Map<String,String> COPIA defensiva.
//   - expectedRelationKind se propaga (incluyendo null).
//   - registrationSessionId:
//       · NUNCA igual a portfolioId.
//       · Fresco por llamada (UUID v4).
//       · Formato UUID v4 plausible (longitud + guiones).
//   - El mapper NO muta el state.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/services/onboarding/shell_mode.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/usecases/onboarding/workspace_bootstrap_result.dart';
import 'package:avanzza/presentation/demo_registration_v2/demo_state.dart';
import 'package:avanzza/presentation/demo_registration_v2/fusionado/onboarding_asset_handoff_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

WorkspaceBootstrapResult _result({
  PortfolioEntity? portfolio,
  String orgId = 'org-1',
}) {
  final org = OrganizationEntity(
    id: orgId,
    nombre: 'Acme',
    tipo: 'personal',
    countryId: 'CO',
  );
  final membership = MembershipEntity(
    userId: 'uid-1',
    orgId: orgId,
    orgName: 'Acme',
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO'},
  );
  return WorkspaceBootstrapResult(
    organization: org,
    membership: membership,
    portfolio: portfolio,
    shellMode:
        portfolio == null ? ShellMode.providerServicios : ShellMode.assetOwner,
  );
}

PortfolioEntity _portfolio({
  String id = 'pf-1',
  String portfolioName = 'Mi flota',
  String countryId = 'CO',
  String cityId = 'CO-ANT-MEDELLIN',
  AssetActorRole? expectedRelationKind = AssetActorRole.owner,
  PortfolioType type = PortfolioType.vehiculos,
}) =>
    PortfolioEntity(
      id: id,
      portfolioType: type,
      portfolioName: portfolioName,
      countryId: countryId,
      cityId: cityId,
      orgId: 'org-1',
      createdBy: 'uid-1',
      expectedRelationKind: expectedRelationKind,
    );

DemoRegistrationState _state(void Function(DemoRegistrationState s) build) {
  final s = DemoRegistrationState();
  build(s);
  return s;
}

void main() {
  group('mapBootstrapToAssetRegistrationContext — sin portfolio', () {
    test('result.portfolio == null ⇒ retorna null', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(),
        state: _state((s) => s.role = DemoRoleCode.provider),
      );
      expect(ctx, isNull);
    });
  });

  group('mapBootstrapToAssetRegistrationContext — campos canónicos', () {
    test('propaga portfolioId, portfolioName, countryId, cityId desde '
        'portfolio', () {
      final pf = _portfolio(
        id: 'pf-77',
        portfolioName: 'Mis vehículos personales',
        countryId: 'MX',
        cityId: 'mx-cdmx',
      );
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: pf),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      expect(ctx, isNotNull);
      expect(ctx!.portfolioId, 'pf-77');
      expect(ctx.portfolioName, 'Mis vehículos personales');
      expect(ctx.countryId, 'MX');
      expect(ctx.cityId, 'mx-cdmx');
    });

    test('mapea DemoAssetType.vehiculo ⇒ AssetRegistrationType.vehiculo', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      expect(ctx?.assetType, AssetRegistrationType.vehiculo);
    });

    test('mapea DemoAssetType.inmueble ⇒ AssetRegistrationType.inmueble', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio(type: PortfolioType.inmuebles)),
        state: _state((s) => s.assetType = DemoAssetType.inmueble),
      );
      expect(ctx?.assetType, AssetRegistrationType.inmueble);
    });

    test('mapea DemoAssetType.maquinaria ⇒ AssetRegistrationType.maquinaria',
        () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(
            portfolio: _portfolio(type: PortfolioType.operacionGeneral)),
        state: _state((s) => s.assetType = DemoAssetType.maquinaria),
      );
      expect(ctx?.assetType, AssetRegistrationType.maquinaria);
    });

    test('mapea DemoAssetType.equipo ⇒ AssetRegistrationType.equipo', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(
            portfolio: _portfolio(type: PortfolioType.operacionGeneral)),
        state: _state((s) => s.assetType = DemoAssetType.equipo),
      );
      expect(ctx?.assetType, AssetRegistrationType.equipo);
    });

    test('state.assetType==null ⇒ assetType=otro (defensivo)', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: _state((_) {}),
      );
      expect(ctx?.assetType, AssetRegistrationType.otro);
    });
  });

  group('mapBootstrapToAssetRegistrationContext — vrcSnapshot', () {
    test('state.assetData vacío ⇒ vrcSnapshot null', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      expect(ctx?.vrcSnapshot, isNull);
    });

    test('state.assetData poblado ⇒ vrcSnapshot con copia tipada', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: _state((s) {
          s.assetType = DemoAssetType.vehiculo;
          s.assetData['placa'] = 'ABC123';
          s.assetData['marca'] = 'Toyota';
        }),
      );
      expect(ctx?.vrcSnapshot, {'placa': 'ABC123', 'marca': 'Toyota'});
    });

    test('vrcSnapshot es COPIA — mutarla no afecta state.assetData', () {
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC123';
      });
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: state,
      )!;
      ctx.vrcSnapshot!['placa'] = 'OTRO';
      ctx.vrcSnapshot!['nuevo'] = 'campo';
      expect(state.assetData['placa'], 'ABC123');
      expect(state.assetData.containsKey('nuevo'), isFalse);
    });
  });

  group('mapBootstrapToAssetRegistrationContext — expectedRelationKind', () {
    test('propaga AssetActorRole.owner desde portfolio', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(
            portfolio:
                _portfolio(expectedRelationKind: AssetActorRole.owner)),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      expect(ctx?.expectedRelationKind, AssetActorRole.owner);
    });

    test('propaga AssetActorRole.manager desde portfolio', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(
            portfolio:
                _portfolio(expectedRelationKind: AssetActorRole.manager)),
        state: _state((s) => s.assetType = DemoAssetType.maquinaria),
      );
      expect(ctx?.expectedRelationKind, AssetActorRole.manager);
    });

    test('propaga AssetActorRole.tenant (renter inquilino)', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(
            portfolio:
                _portfolio(expectedRelationKind: AssetActorRole.tenant)),
        state: _state((s) => s.assetType = DemoAssetType.inmueble),
      );
      expect(ctx?.expectedRelationKind, AssetActorRole.tenant);
    });

    test('portfolio.expectedRelationKind == null ⇒ context con null', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result:
            _result(portfolio: _portfolio(expectedRelationKind: null)),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      expect(ctx?.expectedRelationKind, isNull);
    });
  });

  group('mapBootstrapToAssetRegistrationContext — registrationSessionId', () {
    test('jamás es igual a portfolioId (incluso si UUID-like)', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(
            portfolio: _portfolio(id: '11111111-1111-4111-8111-111111111111')),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      )!;
      expect(ctx.registrationSessionId, isNot(equals(ctx.portfolioId)));
    });

    test('fresco por llamada — dos llamadas producen UUIDs distintos', () {
      final pf = _portfolio();
      final state = _state((s) => s.assetType = DemoAssetType.vehiculo);
      final c1 = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: pf),
        state: state,
      )!;
      final c2 = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: pf),
        state: state,
      )!;
      expect(c1.registrationSessionId,
          isNot(equals(c2.registrationSessionId)));
    });

    test('formato UUID v4 plausible (36 chars, 4 guiones)', () {
      final ctx = mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      )!;
      expect(ctx.registrationSessionId.length, 36);
      expect(ctx.registrationSessionId.split('-').length, 5);
    });
  });

  group('mapBootstrapToAssetRegistrationContext — pureza', () {
    test('NO muta state.assetData', () {
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC';
        s.assetData['marca'] = 'Toyota';
      });
      final pre = Map<String, String>.from(state.assetData);
      mapBootstrapToAssetRegistrationContext(
        result: _result(portfolio: _portfolio()),
        state: state,
      );
      expect(state.assetData, pre);
    });
  });
}

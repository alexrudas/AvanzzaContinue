// ============================================================================
// test/presentation/demo_registration_v2/fusionado/onboarding_navigation_resolver_test.dart
// Tests del resolver puro de navegación post-CompleteOnboardingUC.
// ============================================================================
// Cubre:
//   - portfolio != null  ⇒ Routes.assetRegister con AssetRegistrationContext
//     tipado en `arguments` (NO Map<String,dynamic>).
//   - portfolio == null  ⇒ Routes.home con `arguments == null`.
//   - El context tipado propaga portfolioId, assetType, vrcSnapshot,
//     expectedRelationKind.
//   - Función pura: misma decisión semántica ante mismo input (UUID
//     diferente entre llamadas — esperado).
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/services/onboarding/shell_mode.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/usecases/onboarding/workspace_bootstrap_result.dart';
import 'package:avanzza/domain/value/registration/asset_registration_context.dart';
import 'package:avanzza/presentation/demo_registration_v2/demo_state.dart';
import 'package:avanzza/presentation/demo_registration_v2/fusionado/onboarding_navigation_resolver.dart';
import 'package:avanzza/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

WorkspaceBootstrapResult _resultWithPortfolio({
  required AssetActorRole? expectedRelationKind,
  String portfolioId = 'pf-1',
  String orgId = 'org-1',
  String portfolioName = 'Mi flota',
  String countryId = 'CO',
  String cityId = 'CO-ANT-MEDELLIN',
}) {
  final org = OrganizationEntity(
    id: orgId,
    nombre: 'Acme',
    tipo: 'personal',
    countryId: countryId,
  );
  final membership = MembershipEntity(
    userId: 'uid-1',
    orgId: orgId,
    orgName: 'Acme',
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO'},
  );
  final portfolio = PortfolioEntity(
    id: portfolioId,
    portfolioType: PortfolioType.vehiculos,
    portfolioName: portfolioName,
    countryId: countryId,
    cityId: cityId,
    orgId: orgId,
    createdBy: 'uid-1',
    expectedRelationKind: expectedRelationKind,
  );
  return WorkspaceBootstrapResult(
    organization: org,
    membership: membership,
    portfolio: portfolio,
    shellMode: ShellMode.assetOwner,
  );
}

WorkspaceBootstrapResult _resultWithoutPortfolio({ShellMode? shell}) {
  const org = OrganizationEntity(
    id: 'org-2',
    nombre: 'Acme Provider',
    tipo: 'empresa',
    countryId: 'CO',
  );
  const membership = MembershipEntity(
    userId: 'uid-2',
    orgId: 'org-2',
    orgName: 'Acme Provider',
    estatus: 'activo',
    primaryLocation: {'countryId': 'CO'},
  );
  return WorkspaceBootstrapResult(
    organization: org,
    membership: membership,
    shellMode: shell ?? ShellMode.providerServicios,
  );
}

DemoRegistrationState _state(void Function(DemoRegistrationState s) build) {
  final s = DemoRegistrationState();
  build(s);
  return s;
}

void main() {
  group('resolveOnboardingNavigation — portfolio != null', () {
    test('routea a Routes.assetRegister con AssetRegistrationContext tipado',
        () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC123';
      });
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.assetRegister);
      expect(decision.goesToAssetRegistration, isTrue);
      expect(decision.arguments, isA<AssetRegistrationContext>());
    });

    test('arguments NO es Map — es AssetRegistrationContext', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
      });
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.arguments, isNot(isA<Map<dynamic, dynamic>>()));
    });

    test('contexto incluye portfolioId, assetType, vrcSnapshot, '
        'expectedRelationKind', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
        portfolioId: 'pf-X',
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC123';
        s.assetData['marca'] = 'Toyota';
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx, isNotNull);
      expect(ctx!.portfolioId, 'pf-X');
      expect(ctx.assetType, AssetRegistrationType.vehiculo);
      expect(ctx.expectedRelationKind, AssetActorRole.owner);
      expect(ctx.vrcSnapshot, {'placa': 'ABC123', 'marca': 'Toyota'});
    });

    test('expectedRelationKind=manager se preserva tipado', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.manager,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.maquinaria;
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx?.expectedRelationKind, AssetActorRole.manager);
      expect(ctx?.assetType, AssetRegistrationType.maquinaria);
    });

    test('expectedRelationKind=tenant (renter inquilino)', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.tenant,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.inmueble;
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx?.expectedRelationKind, AssetActorRole.tenant);
      expect(ctx?.assetType, AssetRegistrationType.inmueble);
    });

    test('expectedRelationKind null en portfolio se propaga como null', () {
      final r = _resultWithPortfolio(expectedRelationKind: null);
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx, isNotNull);
      expect(ctx!.expectedRelationKind, isNull);
    });

    test('vrcSnapshot vacío ⇒ campo null en el contexto', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx?.vrcSnapshot, isNull);
    });

    test('assetType null en state ⇒ contexto con assetType=otro (defensivo)',
        () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((_) {});
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx?.assetType, AssetRegistrationType.otro);
    });

    test('registrationSessionId NUNCA es igual a portfolioId', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
        portfolioId: 'pf-uuid-collision',
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      expect(ctx?.registrationSessionId, isNotNull);
      expect(ctx!.registrationSessionId, isNot(equals(ctx.portfolioId)));
      expect(ctx.registrationSessionId.length, greaterThan(0));
    });
  });

  group('resolveOnboardingNavigation — role provider (precedencia absoluta)',
      () {
    test('provider + offerType=servicios ⇒ providerWorkspaceServices', () {
      final r = _resultWithoutPortfolio();
      final state = _state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
      });
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.providerWorkspaceServices);
      expect(decision.arguments, isNull);
      expect(decision.goesToAssetRegistration, isFalse);
      expect(decision.assetRegistrationContext, isNull);
    });

    test('provider + offerType=productos ⇒ providerWorkspaceArticles', () {
      final r = _resultWithoutPortfolio();
      final state = _state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.productos;
      });
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.providerWorkspaceArticles);
      expect(decision.arguments, isNull);
    });

    test('provider sin offerType declarado ⇒ Routes.home (readiness gap)', () {
      // Regla canónica: readiness > role. El role=provider en state NO
      // es suficiente — falta `providerOfferType` para distinguir
      // Articles vs Services. La ruta segura es home; el shell del
      // home renderiza empty-state con CTA para completar el onboarding
      // pendiente del proveedor.
      final r = _resultWithoutPortfolio();
      final state = _state((s) {
        s.role = DemoRoleCode.provider;
      });
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.home);
      expect(decision.arguments, isNull);
      expect(decision.goesToAssetRegistration, isFalse);
    });

    // ── REGRESSION GUARD ──────────────────────────────────────────────────
    // Bug histórico: si por accidente CompleteOnboardingUC creaba un
    // portfolio para un provider (race / data leak), el resolver caía a
    // Routes.assetRegister y reanimaba el wizard legacy de registro de
    // activo. Aunque el UC no debería crear portfolio para providers, el
    // resolver DEBE ser defensivo: provider → workspace de proveedor,
    // independientemente del estado del result.
    test('provider con portfolio fortuito NO va a Routes.assetRegister', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.role = DemoRoleCode.provider;
        s.providerOfferType = DemoProviderOfferType.servicios;
        // assetType seteado deliberadamente para confirmar que el resolver
        // lo IGNORA cuando role==provider (corta-circuito).
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'XYZ789';
      });
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.providerWorkspaceServices);
      expect(decision.routeName, isNot(Routes.assetRegister));
      expect(decision.assetRegistrationContext, isNull);
      expect(decision.goesToAssetRegistration, isFalse);
    });
  });

  group('resolveOnboardingNavigation — portfolio == null + role no-provider',
      () {
    test('shellMode advisor ⇒ home (decisión es solo por presencia de '
        'portfolio)', () {
      final r = _resultWithoutPortfolio(shell: ShellMode.advisor);
      final state = _state((_) {});
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.home);
    });

    test('shellMode insurer ⇒ home', () {
      final r = _resultWithoutPortfolio(shell: ShellMode.insurer);
      final state = _state((_) {});
      final decision = resolveOnboardingNavigation(
        result: r,
        state: state,
      );
      expect(decision.routeName, Routes.home);
    });
  });

  group('resolveOnboardingNavigation — semántica pura', () {
    test('decisiones equivalentes son iguales (== ignora '
        'registrationSessionId)', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC';
      });
      final d1 = resolveOnboardingNavigation(result: r, state: state);
      final d2 = resolveOnboardingNavigation(result: r, state: state);
      expect(d1, equals(d2));
    });

    test('NO muta el state input', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC';
      });
      final preData = Map<String, String>.from(state.assetData);
      resolveOnboardingNavigation(result: r, state: state);
      expect(state.assetData, preData);
    });

    test('vrcSnapshot del contexto es una COPIA de assetData (no shared)',
        () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
        s.assetData['placa'] = 'ABC';
      });
      final ctx = resolveOnboardingNavigation(
        result: r,
        state: state,
      ).assetRegistrationContext;
      final snapshot = ctx!.vrcSnapshot!;
      // Mutar el snapshot no afecta el state original.
      snapshot['placa'] = 'OTRO';
      expect(state.assetData['placa'], 'ABC');
    });

    test('cada llamada genera registrationSessionId fresco', () {
      final r = _resultWithPortfolio(
        expectedRelationKind: AssetActorRole.owner,
      );
      final state = _state((s) {
        s.assetType = DemoAssetType.vehiculo;
      });
      final c1 = resolveOnboardingNavigation(result: r, state: state)
          .assetRegistrationContext!;
      final c2 = resolveOnboardingNavigation(result: r, state: state)
          .assetRegistrationContext!;
      expect(c1.registrationSessionId,
          isNot(equals(c2.registrationSessionId)));
    });
  });
}

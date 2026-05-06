// ============================================================================
// test/presentation/demo_registration_v2/fusionado/onboarding_commit_controller_test.dart
// Tests del OnboardingCommitController (state machine + retry).
// ============================================================================
// Cubre:
//   - status inicial idle.
//   - commit() ⇒ committing → success con lastResult + lastNavigation.
//   - commit() con UC que lanza ⇒ error con lastError + canRetry=true.
//   - retry() repite con último input.
//   - reset() vuelve a idle, limpia state.
//   - canRetry=false en idle/committing/success.
//   - controller NO navega (lastNavigation es Rx pero no invoca Get).
// ============================================================================

import 'dart:async';

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/repositories/org_repository.dart';
import 'package:avanzza/domain/repositories/portfolio_repository.dart';
import 'package:avanzza/domain/repositories/user_repository.dart';
import 'package:avanzza/domain/services/onboarding/shell_mode.dart';
import 'package:avanzza/domain/usecases/onboarding/complete_onboarding_uc.dart';
import 'package:avanzza/domain/usecases/onboarding/workspace_bootstrap_result.dart';
import 'package:avanzza/presentation/demo_registration_v2/demo_state.dart';
import 'package:avanzza/presentation/demo_registration_v2/fusionado/onboarding_commit_controller.dart';
import 'package:avanzza/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FAKES
// ─────────────────────────────────────────────────────────────────────────────

class _NoOpOrgRepo extends Fake implements OrgRepository {}

class _NoOpUserRepo extends Fake implements UserRepository {}

class _NoOpPortfolioRepo extends Fake implements PortfolioRepository {}

class _ProgrammableUC extends CompleteOnboardingUC {
  _ProgrammableUC({required this.handler})
      : super(
          orgRepository: _NoOpOrgRepo(),
          userRepository: _NoOpUserRepo(),
          portfolioRepository: _NoOpPortfolioRepo(),
        );

  Future<WorkspaceBootstrapResult> Function(
      String userId, DemoRegistrationState state) handler;

  int callCount = 0;
  String? lastUserIdSeen;

  @override
  Future<WorkspaceBootstrapResult> execute({
    required String userId,
    required DemoRegistrationState state,
  }) {
    callCount++;
    lastUserIdSeen = userId;
    return handler(userId, state);
  }
}

WorkspaceBootstrapResult _resultWithPortfolio() {
  const org = OrganizationEntity(
    id: 'org-1',
    nombre: 'Acme',
    tipo: 'personal',
    countryId: 'CO',
  );
  const membership = MembershipEntity(
    userId: 'uid-1',
    orgId: 'org-1',
    orgName: 'Acme',
    estatus: 'activo',
    primaryLocation: {'countryId': 'CO'},
  );
  const portfolio = PortfolioEntity(
    id: 'pf-1',
    portfolioType: PortfolioType.vehiculos,
    portfolioName: 'Mi flota',
    countryId: 'CO',
    cityId: 'col-ant-med',
    orgId: 'org-1',
    createdBy: 'uid-1',
    expectedRelationKind: AssetActorRole.owner,
  );
  return const WorkspaceBootstrapResult(
    organization: org,
    membership: membership,
    portfolio: portfolio,
    shellMode: ShellMode.assetOwner,
  );
}

WorkspaceBootstrapResult _resultWithoutPortfolio() {
  const org = OrganizationEntity(
    id: 'org-2',
    nombre: 'Acme',
    tipo: 'empresa',
    countryId: 'CO',
  );
  const membership = MembershipEntity(
    userId: 'uid-2',
    orgId: 'org-2',
    orgName: 'Acme',
    estatus: 'activo',
    primaryLocation: {'countryId': 'CO'},
  );
  return const WorkspaceBootstrapResult(
    organization: org,
    membership: membership,
    shellMode: ShellMode.providerServicios,
  );
}

DemoRegistrationState _state(void Function(DemoRegistrationState s) build) {
  final s = DemoRegistrationState();
  build(s);
  return s;
}

void main() {
  group('estado inicial', () {
    test('idle por default; rest de Rx en null', () {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);
      expect(c.status.value, OnboardingCommitStatus.idle);
      expect(c.isIdle, isTrue);
      expect(c.lastResult.value, isNull);
      expect(c.lastNavigation.value, isNull);
      expect(c.lastError.value, isNull);
      expect(c.canRetry, isFalse);
    });
  });

  group('commit — happy path', () {
    test('commit() ⇒ status=success + lastResult + lastNavigation', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);

      await c.commit(
        userId: 'uid-1',
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );

      expect(c.status.value, OnboardingCommitStatus.success);
      expect(c.isSuccess, isTrue);
      expect(c.lastResult.value, isNotNull);
      expect(c.lastResult.value!.portfolio?.id, 'pf-1');
      expect(c.lastNavigation.value, isNotNull);
      expect(c.lastNavigation.value!.routeName, Routes.assetRegister);
      expect(c.lastError.value, isNull);
      expect(c.canRetry, isFalse);
      expect(uc.callCount, 1);
      expect(uc.lastUserIdSeen, 'uid-1');
    });

    test('committing es estado intermedio (observable)', () async {
      // Usamos un Completer para inspeccionar el estado mientras execute
      // está pendiente.
      final completer = Completer<WorkspaceBootstrapResult>();
      final uc = _ProgrammableUC(
        handler: (_, __) => completer.future,
      );
      final c = OnboardingCommitController(useCase: uc);

      final commitFuture = c.commit(
        userId: 'uid-1',
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      // Yield para que el _run() entre y cambie a committing.
      await Future<void>.delayed(Duration.zero);

      expect(c.status.value, OnboardingCommitStatus.committing);
      expect(c.isCommitting, isTrue);
      expect(c.canRetry, isFalse, reason: 'committing no permite retry');

      completer.complete(_resultWithPortfolio());
      await commitFuture;
      expect(c.status.value, OnboardingCommitStatus.success);
    });

    test('result sin portfolio ⇒ navigation a home', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithoutPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.commit(
        userId: 'uid-2',
        state: _state((s) => s.role = DemoRoleCode.provider),
      );
      expect(c.lastNavigation.value!.routeName, Routes.home);
    });
  });

  group('commit — error path', () {
    test('UC throws ⇒ status=error + lastError + canRetry=true', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => throw Exception('boom'),
      );
      final c = OnboardingCommitController(useCase: uc);

      await c.commit(
        userId: 'uid-1',
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );

      expect(c.status.value, OnboardingCommitStatus.error);
      expect(c.isError, isTrue);
      expect(c.lastError.value, isNotNull);
      expect(c.lastError.value, contains('boom'));
      expect(c.canRetry, isTrue);
    });

    test('error NO publica lastNavigation', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => throw StateError('oops'),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.commit(
        userId: 'uid-1',
        state: _state((_) {}),
      );
      expect(c.lastNavigation.value, isNull);
    });
  });

  group('retry', () {
    test('retry tras error ⇒ re-ejecuta con mismo input', () async {
      var firstCall = true;
      final uc = _ProgrammableUC(
        handler: (uid, _) async {
          if (firstCall) {
            firstCall = false;
            throw Exception('transient');
          }
          return _resultWithPortfolio();
        },
      );
      final c = OnboardingCommitController(useCase: uc);

      await c.commit(
        userId: 'uid-1',
        state: _state((s) => s.assetType = DemoAssetType.vehiculo),
      );
      expect(c.isError, isTrue);
      expect(c.canRetry, isTrue);

      await c.retry();

      expect(c.isSuccess, isTrue);
      expect(uc.callCount, 2);
      expect(uc.lastUserIdSeen, 'uid-1');
    });

    test('retry sin commit previo ⇒ no-op (sigue idle)', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.retry();
      expect(c.isIdle, isTrue);
      expect(uc.callCount, 0);
    });

    test('canRetry es false durante committing y success', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.commit(
        userId: 'uid-1',
        state: _state((_) {}),
      );
      expect(c.isSuccess, isTrue);
      expect(c.canRetry, isFalse);
    });
  });

  group('reset', () {
    test('reset() limpia state a idle', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => throw Exception('x'),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.commit(
        userId: 'uid-1',
        state: _state((_) {}),
      );
      expect(c.isError, isTrue);

      c.reset();
      expect(c.isIdle, isTrue);
      expect(c.lastError.value, isNull);
      expect(c.lastResult.value, isNull);
      expect(c.lastNavigation.value, isNull);
      expect(c.canRetry, isFalse);
    });

    test('reset tras success limpia lastNavigation y lastResult', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.commit(
        userId: 'uid-1',
        state: _state((_) {}),
      );
      expect(c.lastResult.value, isNotNull);
      c.reset();
      expect(c.lastResult.value, isNull);
      expect(c.lastNavigation.value, isNull);
    });
  });

  group('controller NO navega (separación de concerns)', () {
    test('lastNavigation es Rx — el controller solo publica, no ejecuta '
        'Get.offAllNamed', () async {
      final uc = _ProgrammableUC(
        handler: (_, __) async => _resultWithPortfolio(),
      );
      final c = OnboardingCommitController(useCase: uc);
      await c.commit(
        userId: 'uid-1',
        state: _state((_) {}),
      );
      // El controller publica la decisión. NO invoca navegación. Esto se
      // verifica por la firma: el controller no importa Get nor Routes
      // para llamar offAllNamed (solo Routes para wireName de la decisión).
      expect(c.lastNavigation.value, isNotNull);
      expect(c.lastNavigation.value!.routeName, isNotEmpty);
    });
  });
}

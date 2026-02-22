// test/domain/policy/product_access_policy_test.dart

import 'package:avanzza/domain/policy/product_access_policy.dart';
import 'package:avanzza/domain/value/membership_scope.dart';
import 'package:avanzza/domain/value/organization_contract/organization_access_contract.dart';
import 'package:avanzza/domain/value/product_access_context.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helper ────────────────────────────────────────────────────────────────────

ProductAccessContext _ctx({
  String userId = 'u1',
  String orgId = 'org1',
  Set<String> roles = const {'owner'},
  MembershipScope? scope,
  OrganizationAccessContract? contract,
  bool isOnline = true,
}) =>
    ProductAccessContext(
      userId: userId,
      orgId: orgId,
      roles: Set.unmodifiable(roles),
      membershipScope: scope ?? MembershipScope.global(),
      organizationContract: contract ?? OrganizationAccessContract.enterprise(),
      isOnline: isOnline,
    );

const _policy = ProductAccessPolicy();

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  // ── Guardia estructural ─────────────────────────────────────────────────────

  group('Guardia estructural — ManageAsset sin assetId', () {
    test('sin assetId → deny(assetContextMissing)', () {
      expect(
        _policy.evaluate(
          feature: const ManageAsset(),
          context: _ctx(),
        ),
        AccessDecision.deny(
          const ManageAsset(),
          AccessReasonCodes.assetContextMissing,
        ),
      );
    });
  });

  // ── Deny-by-default ─────────────────────────────────────────────────────────

  group('Deny-by-default — contrato restrictivo bloquea toda feature', () {
    final restrictedCtx = _ctx(
      contract: OrganizationAccessContract.defaultRestricted(),
    );

    test('SyncData → deny(restrictedContract)', () {
      expect(
        _policy.evaluate(feature: const SyncData(), context: restrictedCtx),
        AccessDecision.deny(
          const SyncData(),
          AccessReasonCodes.restrictedContract,
        ),
      );
    });

    test('IntelligenceAnalytics → deny(restrictedContract)', () {
      expect(
        _policy.evaluate(
          feature: const IntelligenceAnalytics(),
          context: restrictedCtx,
        ),
        AccessDecision.deny(
          const IntelligenceAnalytics(),
          AccessReasonCodes.restrictedContract,
        ),
      );
    });

    test('ManageAsset con assetId → deny(restrictedContract)', () {
      expect(
        _policy.evaluate(
          feature: const ManageAsset(),
          context: restrictedCtx,
          assetId: 'asset-1',
        ),
        AccessDecision.deny(
          const ManageAsset(),
          AccessReasonCodes.restrictedContract,
        ),
      );
    });

    test('CreateAccountingEntry → deny(restrictedContract)', () {
      expect(
        _policy.evaluate(
          feature: const CreateAccountingEntry(),
          context: restrictedCtx,
        ),
        AccessDecision.deny(
          const CreateAccountingEntry(),
          AccessReasonCodes.restrictedContract,
        ),
      );
    });

    test('ManageOrganization → deny(restrictedContract)', () {
      expect(
        _policy.evaluate(
          feature: const ManageOrganization(),
          context: restrictedCtx,
        ),
        AccessDecision.deny(
          const ManageOrganization(),
          AccessReasonCodes.restrictedContract,
        ),
      );
    });

    test('CollaborateUsers → deny(restrictedContract)', () {
      expect(
        _policy.evaluate(
          feature: const CollaborateUsers(),
          context: restrictedCtx,
        ),
        AccessDecision.deny(
          const CollaborateUsers(),
          AccessReasonCodes.restrictedContract,
        ),
      );
    });
  });

  // ── Orden de evaluación ─────────────────────────────────────────────────────

  group('Orden de evaluación — restricted tiene precedencia sobre offline', () {
    final restrictedOfflineCtx = _ctx(
      contract: OrganizationAccessContract.defaultRestricted(),
      isOnline: false,
    );

    test(
      'defaultRestricted + offline + SyncData → deny(restrictedContract), NO offlineMode',
      () {
        expect(
          _policy.evaluate(
            feature: const SyncData(),
            context: restrictedOfflineCtx,
          ),
          AccessDecision.deny(
            const SyncData(),
            AccessReasonCodes.restrictedContract,
          ),
        );
      },
    );
  });

  // ── SyncData ────────────────────────────────────────────────────────────────

  group('SyncData', () {
    test('offline + enterprise → deny(offlineMode)', () {
      expect(
        _policy.evaluate(
          feature: const SyncData(),
          context: _ctx(
            contract: OrganizationAccessContract.enterprise(),
            isOnline: false,
          ),
        ),
        AccessDecision.deny(const SyncData(), AccessReasonCodes.offlineMode),
      );
    });

    test('online + guest (localOnly) → deny(contractNoSync)', () {
      expect(
        _policy.evaluate(
          feature: const SyncData(),
          context: _ctx(
            contract: OrganizationAccessContract.guest(),
            isOnline: true,
          ),
        ),
        AccessDecision.deny(const SyncData(), AccessReasonCodes.contractNoSync),
      );
    });

    test('online + enterprise → allow', () {
      expect(
        _policy.evaluate(
          feature: const SyncData(),
          context: _ctx(
            contract: OrganizationAccessContract.enterprise(),
            isOnline: true,
          ),
        ),
        AccessDecision.allow(const SyncData()),
      );
    });
  });

  // ── IntelligenceAnalytics ───────────────────────────────────────────────────

  group('IntelligenceAnalytics', () {
    test('guest (sin IA) → deny(contractNoIntelligence)', () {
      expect(
        _policy.evaluate(
          feature: const IntelligenceAnalytics(),
          context: _ctx(contract: OrganizationAccessContract.guest()),
        ),
        AccessDecision.deny(
          const IntelligenceAnalytics(),
          AccessReasonCodes.contractNoIntelligence,
        ),
      );
    });

    test('enterprise (IA avanzada) → allow', () {
      expect(
        _policy.evaluate(
          feature: const IntelligenceAnalytics(),
          context: _ctx(contract: OrganizationAccessContract.enterprise()),
        ),
        AccessDecision.allow(const IntelligenceAnalytics()),
      );
    });
  });

  // ── ManageAsset ─────────────────────────────────────────────────────────────

  group('ManageAsset', () {
    test('scope restricted sin el asset → deny(membershipScopeRestricted)', () {
      expect(
        _policy.evaluate(
          feature: const ManageAsset(),
          context: _ctx(
            scope: MembershipScope.restricted(assetIds: ['otro-asset']),
          ),
          assetId: 'asset-1',
        ),
        AccessDecision.deny(
          const ManageAsset(),
          AccessReasonCodes.membershipScopeRestricted,
        ),
      );
    });

    test('scope restricted con el asset asignado → allow', () {
      expect(
        _policy.evaluate(
          feature: const ManageAsset(),
          context: _ctx(
            scope: MembershipScope.restricted(assetIds: ['asset-1']),
          ),
          assetId: 'asset-1',
        ),
        AccessDecision.allow(const ManageAsset()),
      );
    });

    test('scope global → allow independientemente del assetId', () {
      expect(
        _policy.evaluate(
          feature: const ManageAsset(),
          context: _ctx(scope: MembershipScope.global()),
          assetId: 'cualquier-asset',
        ),
        AccessDecision.allow(const ManageAsset()),
      );
    });

    test('scope none → deny(membershipScopeRestricted)', () {
      expect(
        _policy.evaluate(
          feature: const ManageAsset(),
          context: _ctx(scope: MembershipScope.none()),
          assetId: 'asset-1',
        ),
        AccessDecision.deny(
          const ManageAsset(),
          AccessReasonCodes.membershipScopeRestricted,
        ),
      );
    });
  });

  // ── CreateAccountingEntry ───────────────────────────────────────────────────

  group('CreateAccountingEntry', () {
    test('rol member → deny(roleInsufficient)', () {
      expect(
        _policy.evaluate(
          feature: const CreateAccountingEntry(),
          context: _ctx(roles: {'member'}),
        ),
        AccessDecision.deny(
          const CreateAccountingEntry(),
          AccessReasonCodes.roleInsufficient,
        ),
      );
    });

    test('rol owner → allow', () {
      expect(
        _policy.evaluate(
          feature: const CreateAccountingEntry(),
          context: _ctx(roles: {'owner'}),
        ),
        AccessDecision.allow(const CreateAccountingEntry()),
      );
    });

    test('rol admin → allow', () {
      expect(
        _policy.evaluate(
          feature: const CreateAccountingEntry(),
          context: _ctx(roles: {'admin'}),
        ),
        AccessDecision.allow(const CreateAccountingEntry()),
      );
    });

    test('roles combinados {admin, member} → allow', () {
      expect(
        _policy.evaluate(
          feature: const CreateAccountingEntry(),
          context: _ctx(roles: {'admin', 'member'}),
        ),
        AccessDecision.allow(const CreateAccountingEntry()),
      );
    });
  });

  // ── ManageOrganization ──────────────────────────────────────────────────────

  group('ManageOrganization', () {
    test('rol viewer → deny(roleInsufficient)', () {
      expect(
        _policy.evaluate(
          feature: const ManageOrganization(),
          context: _ctx(roles: {'viewer'}),
        ),
        AccessDecision.deny(
          const ManageOrganization(),
          AccessReasonCodes.roleInsufficient,
        ),
      );
    });

    test('rol admin → allow', () {
      expect(
        _policy.evaluate(
          feature: const ManageOrganization(),
          context: _ctx(roles: {'admin'}),
        ),
        AccessDecision.allow(const ManageOrganization()),
      );
    });

    test('rol owner → allow', () {
      expect(
        _policy.evaluate(
          feature: const ManageOrganization(),
          context: _ctx(roles: {'owner'}),
        ),
        AccessDecision.allow(const ManageOrganization()),
      );
    });
  });

  // ── CollaborateUsers ────────────────────────────────────────────────────────

  group('CollaborateUsers', () {
    test('guest → deny(contractNoCollaboration)', () {
      expect(
        _policy.evaluate(
          feature: const CollaborateUsers(),
          context: _ctx(contract: OrganizationAccessContract.guest()),
        ),
        AccessDecision.deny(
          const CollaborateUsers(),
          AccessReasonCodes.contractNoCollaboration,
        ),
      );
    });

    test('enterprise → allow', () {
      expect(
        _policy.evaluate(
          feature: const CollaborateUsers(),
          context: _ctx(contract: OrganizationAccessContract.enterprise()),
        ),
        AccessDecision.allow(const CollaborateUsers()),
      );
    });
  });

  // ── AccessDecision — igualdad estructural ───────────────────────────────────

  group('AccessDecision — igualdad estructural', () {
    test('hashCode e igualdad estructural consistente', () {
      final d1 = AccessDecision.allow(const SyncData());
      final d2 = AccessDecision.allow(const SyncData());
      expect(d1, equals(d2));
      expect(d1.hashCode, equals(d2.hashCode));
    });

    test('distinta feature → distintos', () {
      expect(
        AccessDecision.deny(
            const SyncData(), AccessReasonCodes.restrictedContract),
        isNot(
          equals(
            AccessDecision.deny(
              const CollaborateUsers(),
              AccessReasonCodes.restrictedContract,
            ),
          ),
        ),
      );
    });
  });
}

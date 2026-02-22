// test/domain/value/product_access_context_test.dart

import 'package:avanzza/application/factories/product_access_context_factory.dart';
import 'package:avanzza/domain/value/membership_scope.dart';
import 'package:avanzza/domain/value/organization_contract/organization_access_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductAccessContext — deny-by-default (contract=null, scope=null)',
      () {
    test('canSync == false', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u1',
        orgId: 'org1',
        roles: const {},
        isOnline: true,
      );

      expect(ctx.canSync, isFalse);
    });

    test('hasIntelligence == false', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u1',
        orgId: 'org1',
        roles: const {},
        isOnline: true,
      );

      expect(ctx.hasIntelligence, isFalse);
    });

    test('canAccessAsset == false (restricted vacío)', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u1',
        orgId: 'org1',
        roles: const {},
        isOnline: true,
      );

      expect(ctx.canAccessAsset('asset-x'), isFalse);
    });

    test('isRestrictedContract == true (defaultRestricted)', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u1',
        orgId: 'org1',
        roles: const {},
        isOnline: true,
      );

      expect(ctx.isRestrictedContract, isTrue);
    });
  });

  group('ProductAccessContext — enterprise + global + online', () {
    test('canSync == true', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u2',
        orgId: 'org2',
        roles: {'admin'},
        contract: OrganizationAccessContract.enterprise(),
        scope: MembershipScope.global(),
        isOnline: true,
      );

      expect(ctx.canSync, isTrue);
    });

    test('canAccessAsset == true (scope global)', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u2',
        orgId: 'org2',
        roles: {'admin'},
        contract: OrganizationAccessContract.enterprise(),
        scope: MembershipScope.global(),
        isOnline: true,
      );

      expect(ctx.canAccessAsset('cualquier-asset'), isTrue);
    });

    test('supportsCollaboration reflects contract', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u2',
        orgId: 'org2',
        roles: {'admin'},
        contract: OrganizationAccessContract.enterprise(),
        scope: MembershipScope.global(),
        isOnline: true,
      );

      expect(ctx.supportsCollaboration, isTrue);
    });
  });

  group('ProductAccessContext — enterprise + global + offline', () {
    test('canSync == false (offline)', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u3',
        orgId: 'org3',
        roles: {'admin'},
        contract: OrganizationAccessContract.enterprise(),
        scope: MembershipScope.global(),
        isOnline: false,
      );

      expect(ctx.canSync, isFalse);
    });
  });

  group('ProductAccessContext — restricted scope sin assets', () {
    test('canAccessAsset == false (restricted sin asignaciones)', () {
      final ctx = ProductAccessContextFactory.build(
        userId: 'u4',
        orgId: 'org4',
        roles: const {},
        contract: OrganizationAccessContract.enterprise(),
        scope: const MembershipScope(),
        isOnline: true,
      );

      expect(ctx.canAccessAsset('asset-x'), isFalse);
    });
  });
}

// test/domain/value/organization_access_contract_is_default_restricted_test.dart

import 'package:avanzza/domain/value/organization_contract/organization_access_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrganizationAccessContract.isDefaultRestricted — semántica canónica', () {
    test('defaultRestricted() → true', () {
      expect(
        OrganizationAccessContract.defaultRestricted().isDefaultRestricted,
        isTrue,
      );
    });

    test('guest() → false', () {
      expect(
        OrganizationAccessContract.guest().isDefaultRestricted,
        isFalse,
      );
    });

    test('personal() → false', () {
      expect(
        OrganizationAccessContract.personal().isDefaultRestricted,
        isFalse,
      );
    });

    test('team() → false', () {
      expect(
        OrganizationAccessContract.team().isDefaultRestricted,
        isFalse,
      );
    });

    test('enterprise() → false', () {
      expect(
        OrganizationAccessContract.enterprise().isDefaultRestricted,
        isFalse,
      );
    });

    test('const OrganizationAccessContract() (canonical) → false', () {
      // El default canónico NO es el perfil restrictivo.
      expect(
        const OrganizationAccessContract().isDefaultRestricted,
        isFalse,
      );
    });
  });
}

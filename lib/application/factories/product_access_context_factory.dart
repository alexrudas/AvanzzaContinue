// lib/application/factories/product_access_context_factory.dart

import 'package:avanzza/domain/value/membership_scope.dart';
import 'package:avanzza/domain/value/organization_contract/organization_access_contract.dart';
import 'package:avanzza/domain/value/product_access_context.dart';

/// Factory estática para construir [ProductAccessContext].
///
/// Reglas duras:
/// - contract == null → OrganizationAccessContract.defaultRestricted() (deny-by-default)
/// - scope == null → MembershipScope() (restricted, sin acceso a activos)
/// - roles → normalización + Set.unmodifiable() para inmutabilidad real
/// - Sin side effects, sin repositorios, sin clocks, sin throws por null.
class ProductAccessContextFactory {
  const ProductAccessContextFactory._();

  static ProductAccessContext build({
    required String userId,
    required String orgId,
    required Set<String> roles,
    OrganizationAccessContract? contract,
    MembershipScope? scope,
    required bool isOnline,
  }) {
    final normalizedRoles =
        roles.map((r) => r.trim()).where((r) => r.isNotEmpty).toSet();

    final safeContract =
        contract ?? OrganizationAccessContract.defaultRestricted();
    final safeScope = scope ?? const MembershipScope();

    return ProductAccessContext(
      userId: userId,
      orgId: orgId,
      roles: Set.unmodifiable(normalizedRoles),
      membershipScope: safeScope,
      organizationContract: safeContract,
      isOnline: isOnline,
    );
  }
}

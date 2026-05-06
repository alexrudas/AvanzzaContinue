// ============================================================================
// lib/domain/usecases/onboarding/workspace_bootstrap_result.dart
// WorkspaceBootstrapResult — output canónico de CompleteOnboardingUC.
// ============================================================================
// QUÉ HACE:
//   - Agrupa las entidades creadas (o hidratadas, en idempotencia) durante
//     el bootstrap del primer workspace al completar onboarding:
//       · Organization (siempre).
//       · Membership (siempre, fundador con MembershipRole.admin + isOwner=true).
//       · Portfolio (opcional, solo cuando intent ∈ {owner,assetAdmin,renter}
//         AND assetType definido).
//   - Reporta el shellMode runtime para que el caller decida la ruta.
//   - Lleva la lista de warnings del mapper para que el caller los
//     emita por telemetría (o los persista para auditoría).
//   - Indica si fue idempotent hit (fromExisting=true) o creación fresca.
//
// QUÉ NO HACE:
//   - NO incluye AssetActorLink. Esa entidad la crea VRC al añadir el
//     primer asset, usando Portfolio.expectedRelationKind como hint.
//   - NO incluye ruta de navegación. El caller (controller del flow)
//     decide a qué pantalla ir.
//   - NO emite telemetría por sí mismo. La emisión la hace
//     CompleteOnboardingUC durante execute().
// ============================================================================

import '../../entities/org/organization_entity.dart';
import '../../entities/portfolio/portfolio_entity.dart';
import '../../entities/user/membership_entity.dart';
import '../../services/onboarding/shell_mode.dart';
import '../../value/migration/legacy_migration_warning.dart';

class WorkspaceBootstrapResult {
  /// Organization creada (o existente si fromExisting=true).
  final OrganizationEntity organization;

  /// Membership del fundador. SIEMPRE roles=['admin'] + isOwner=true en
  /// creación fresca.
  final MembershipEntity membership;

  /// Portfolio creado (DRAFT) cuando el intent declara mantenedor de
  /// assets. Null cuando el workspace ofrece solo capabilities (provider/
  /// advisor/broker/legal/insurer) sin Portfolio inicial.
  final PortfolioEntity? portfolio;

  /// Shell por default según el intent + capabilities.
  final ShellMode shellMode;

  /// Warnings que el mapper produjo durante el mapeo Q3/Q4 → canonical.
  /// El UC los emite por telemetría; aquí se exponen también para que el
  /// caller pueda mostrarlos al admin o persistirlos para auditoría.
  final List<LegacyMigrationWarning> warnings;

  /// True cuando el use case detectó memberships preexistentes y retornó
  /// hidratando lo encontrado (idempotencia). False cuando fue creación
  /// fresca.
  final bool fromExisting;

  const WorkspaceBootstrapResult({
    required this.organization,
    required this.membership,
    required this.shellMode,
    this.portfolio,
    this.warnings = const [],
    this.fromExisting = false,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasPortfolio => portfolio != null;

  @override
  String toString() => 'WorkspaceBootstrapResult('
      'orgId: ${organization.id}, '
      'membershipUser: ${membership.userId}, '
      'portfolio: ${portfolio?.id}, '
      'shellMode: ${shellMode.wireName}, '
      'warnings: ${warnings.length}, '
      'fromExisting: $fromExisting)';
}

// ============================================================================
// lib/presentation/workspace/workspace_config.dart
// WORKSPACE CONFIG — Enterprise Ultra Pro Premium (Presentation / Navigation)
//
// QUÉ HACE:
// - Define WorkspaceConfig como contrato entre WorkspaceShell y sus tabs.
// - Define WorkspaceTab como unidad de navegación visual.
// - Agrega workspaceType: WorkspaceType para routing y rendering tipado.
// - Provee NavigationRegistry.configFor(WorkspaceType) como camino principal
//   de configuración tipada durante Fase 1.
// - Mantiene workspaceFor(...) y helpers legacy como compatibilidad transicional
//   explícita mientras termina la migración del sistema viejo.
//
// QUÉ NO HACE:
// - NO navega directamente.
// - NO persiste estado.
// - NO conoce SessionContextController ni ContextSwitchService.
// - NO valida acceso del usuario al contexto.
// - NO decide bootstrap ni fallback de sesión.
//
// PRINCIPIOS:
// - TYPE-DRIVEN: el camino nuevo es WorkspaceType → WorkspaceConfig.
// - BACKWARD COMPAT: workspaceFor(...) sigue existiendo para callers legacy.
// - FAIL-SAFE: roles no reconocidos NO caen silenciosamente a admin.
// - TRANSICIÓN CONTROLADA: insurer/legal/advisor aún delegan temporalmente
//   a una experiencia de servicios/workshop, pero de forma explícita y logueada.
// - AISLAMIENTO: el shell consume config; no reconstruye reglas de negocio.
//
// ENTERPRISE NOTES:
// - NavigationRegistry es la tabla principal tipada para código nuevo.
// - workspaceFor(...) queda deprecado y solo debe usarse donde todavía no
//   se haya migrado a WorkspaceType.
// - Los helpers isAdmin/isOwner/etc. quedan deprecados por la misma razón.
// - WorkspaceConfig.workspaceType default=unknown protege constructores legacy.
// ============================================================================

import 'package:avanzza/presentation/pages/admin/accounting/admin_accounting_page.dart';
import 'package:avanzza/presentation/pages/admin/chat/admin_chat_page.dart';
import 'package:avanzza/presentation/pages/admin/home/admin_home_page.dart';
import 'package:avanzza/presentation/pages/admin/maintenance/admin_maintenance_page.dart';
import 'package:avanzza/presentation/pages/admin/orders_and_quotation/admin_orders_page.dart';
import 'package:avanzza/presentation/pages/tenant/home/tenant_home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/workspace_normalizer.dart';
import '../../domain/entities/workspace/workspace_type.dart';
import '../../services/telemetry/telemetry_service.dart';
import '../bindings/admin/admin_accounting_binding.dart';
import '../bindings/admin/admin_chat_binding.dart';
import '../bindings/admin/admin_home_binding.dart';
import '../bindings/admin/admin_maintenance_binding.dart';
import '../bindings/admin/admin_purchase_binding.dart';
import '../bindings/owner/owner_binding.dart';
import '../bindings/provider/provider_articles_binding.dart';
import '../bindings/provider/provider_services_binding.dart';
import '../bindings/renter/renter_binding.dart';
import '../pages/accounting/accounting_page.dart';
import '../pages/owner/chat/owner_chat_page.dart';
import '../pages/owner/contracts/owner_contracts_page.dart';
import '../pages/owner/home/owner_home_page.dart';
import '../pages/owner/portfolio/owner_portfolio_page.dart';
import '../pages/provider/articles/catalog/provider_articles_catalog_page.dart';
import '../pages/provider/articles/chat/provider_articles_chat_page.dart';
import '../pages/provider/articles/home/provider_articles_home_page.dart';
import '../pages/provider/services/agenda/provider_services_agenda_page.dart';
import '../pages/provider/services/chat/provider_services_chat_page.dart';
import '../pages/provider/services/home/provider_services_home_page.dart';
import '../pages/provider/services/orders/provider_services_orders_page.dart';
import '../pages/renter/asset/renter_asset_page.dart';
import '../pages/renter/chat/renter_chat_page.dart';
import '../pages/renter/documents/renter_documents_page.dart';
import '../pages/renter/payments/renter_payments_page.dart';
import '../pages/workspaces/provider_articles_commercial_page.dart';
import '../pages/workspaces/provider_articles_orders_shell.dart';
import '../pages/workspaces/provider_articles_profile_page.dart';

class WorkspaceConfig {
  final String roleKey;
  final List<WorkspaceTab> tabs;
  final void Function()? onInit;

  /// Tipo canónico del workspace.
  ///
  /// Default: unknown para compatibilidad con callers legacy.
  final WorkspaceType workspaceType;

  const WorkspaceConfig({
    required this.roleKey,
    required this.tabs,
    this.onInit,
    this.workspaceType = WorkspaceType.unknown,
  });
}

class WorkspaceTab {
  final String title;
  final IconData icon;
  final Widget page;

  const WorkspaceTab({
    required this.title,
    required this.icon,
    required this.page,
  });
}

// ============================================================================
// LEGACY HELPERS — DEPRECATED
// Mantener solo mientras callers antiguos sigan operando por role strings.
// ============================================================================

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isAdmin(String rol) => rol.contains('admin');

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isOwner(String rol) => rol.contains('propietario');

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isRenter(String rol) => rol.contains('arrendatario');

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isProvider(String rol) => rol.contains('proveedor');

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isAdvisor(String rol) => rol.contains('asesor');

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isInsurer(String rol) =>
    rol.contains('aseguradora') || rol.contains('broker');

@Deprecated(
  'Usa WorkspaceType + NavigationRegistry.configFor(...) en lugar de role strings.',
)
bool isLegal(String rol) => rol.contains('abog');

// ============================================================================
// LEGACY ENTRYPOINT — DEPRECATED
// Se mantiene solo para compatibilidad de Fase 1.
// ============================================================================

@Deprecated(
  'Usa NavigationRegistry.configFor(WorkspaceType, orgType: ...) como camino principal.',
)
WorkspaceConfig workspaceFor({
  required String rol,
  String? providerType,
  String? orgType,
}) {
  if (rol.isEmpty) {
    _logUnrecognizedRole('', 'empty_role');
    return _buildUnknownWorkspaceConfig(reason: 'empty_role');
  }

  final normalized = WorkspaceNormalizer.normalize(rol).toLowerCase();
  final pt = (providerType ?? '').trim().toLowerCase();
  final normalizedOrgType = _normalizeOrgType(orgType);

  if (isAdmin(normalized)) {
    return _buildAssetAdminConfig();
  }

  if (isOwner(normalized)) {
    return _buildOwnerConfig();
  }

  if (isRenter(normalized)) {
    return _buildRenterConfig();
  }

  if (isProvider(normalized) ||
      isAdvisor(normalized) ||
      isInsurer(normalized) ||
      isLegal(normalized)) {
    if (pt == 'articulos') {
      return _buildSupplierConfig(orgType: normalizedOrgType);
    }

    if (pt == 'servicios' || pt.isEmpty) {
      return _buildWorkshopConfig();
    }
  }

  _logUnrecognizedRole(rol, normalized);
  return _buildUnknownWorkspaceConfig(reason: 'unrecognized_role:$normalized');
}

/// Versión segura que retorna null para roles desconocidos.
///
/// Debe preferirse sobre `workspaceFor(...)` en código que todavía opere
/// con roles legacy pero quiera evitar fallbacks inseguros.
WorkspaceConfig? getConfigForRole({
  required String rol,
  String? providerType,
  String? orgType,
}) {
  if (rol.isEmpty) {
    _logUnrecognizedRole('', 'empty_role');
    return null;
  }

  final normalized = WorkspaceNormalizer.normalize(rol).toLowerCase();

  final recognized = isAdmin(normalized) ||
      isOwner(normalized) ||
      isRenter(normalized) ||
      isProvider(normalized) ||
      isAdvisor(normalized) ||
      isInsurer(normalized) ||
      isLegal(normalized);

  if (!recognized) {
    _logUnrecognizedRole(rol, normalized);
    return null;
  }

  return workspaceFor(
    rol: normalized,
    providerType: providerType,
    orgType: orgType,
  );
}

// ============================================================================
// NAVIGATION REGISTRY — CAMINO PRINCIPAL NUEVO
// WorkspaceType → WorkspaceConfig
// ============================================================================

class NavigationRegistry {
  NavigationRegistry._();

  /// Retorna el [WorkspaceConfig] principal para el [WorkspaceType] dado.
  ///
  /// - `orgType` solo afecta supplier.
  /// - insurer/legal/advisor usan fallback explícito a workshop en Fase 1.
  /// - unknown retorna null: el caller debe manejar cuarentena/recovery.
  static WorkspaceConfig? configFor(
    WorkspaceType type, {
    String? orgType,
  }) {
    final normalizedOrgType = _normalizeOrgType(orgType);

    switch (type) {
      case WorkspaceType.assetAdmin:
        return _buildAssetAdminConfig();

      case WorkspaceType.owner:
        return _buildOwnerConfig();

      case WorkspaceType.renter:
        return _buildRenterConfig();

      case WorkspaceType.supplier:
        return _buildSupplierConfig(orgType: normalizedOrgType);

      case WorkspaceType.workshop:
        return _buildWorkshopConfig();

      case WorkspaceType.insurer:
        _logTypedFallback(
          sourceType: WorkspaceType.insurer,
          targetType: WorkspaceType.workshop,
        );
        return _buildWorkshopConfig();

      case WorkspaceType.legal:
        _logTypedFallback(
          sourceType: WorkspaceType.legal,
          targetType: WorkspaceType.workshop,
        );
        return _buildWorkshopConfig();

      case WorkspaceType.advisor:
        _logTypedFallback(
          sourceType: WorkspaceType.advisor,
          targetType: WorkspaceType.workshop,
        );
        return _buildWorkshopConfig();

      case WorkspaceType.unknown:
        return null;
    }
  }
}

// ============================================================================
// CONFIG BUILDERS — fuente declarativa real de tabs y bindings.
// ============================================================================

WorkspaceConfig _buildAssetAdminConfig() {
  return WorkspaceConfig(
    roleKey: 'admin_activos',
    workspaceType: WorkspaceType.assetAdmin,
    tabs: const [
      WorkspaceTab(
        title: 'Inicio',
        icon: Icons.home_outlined,
        page: AdminHomePage(),
      ),
      WorkspaceTab(
        title: 'Mantenimientos',
        icon: Icons.build_outlined,
        page: AdminMaintenancePage(),
      ),
      WorkspaceTab(
        title: 'Contabilidad',
        icon: Icons.receipt_long_outlined,
        page: AdminAccountingPage(),
      ),
      WorkspaceTab(
        title: 'Pedidos',
        icon: Icons.shopping_cart_outlined,
        page: AdminOrdersPage(),
      ),
      WorkspaceTab(
        title: 'Chat',
        icon: Icons.chat_bubble_outline,
        page: AdminChatPage(),
      ),
    ],
    onInit: () {
      AdminHomeBinding().dependencies();
      AdminMaintenanceBinding().dependencies();
      AdminAccountingBinding().dependencies();
      AdminPurchaseBinding().dependencies();
      AdminChatBinding().dependencies();
    },
  );
}

WorkspaceConfig _buildOwnerConfig() {
  return WorkspaceConfig(
    roleKey: 'propietario',
    workspaceType: WorkspaceType.owner,
    tabs: const [
      WorkspaceTab(
        title: 'Inicio',
        icon: Icons.home_outlined,
        page: OwnerHomePage(),
      ),
      WorkspaceTab(
        title: 'Portafolio',
        icon: Icons.inventory_2_outlined,
        page: OwnerPortfolioPage(),
      ),
      WorkspaceTab(
        title: 'Contratos',
        icon: Icons.description_outlined,
        page: OwnerContractsPage(),
      ),
      WorkspaceTab(
        title: 'Contabilidad',
        icon: Icons.receipt_long_outlined,
        page: AccountingPage(),
      ),
      WorkspaceTab(
        title: 'Chat',
        icon: Icons.chat_bubble_outline,
        page: OwnerChatPage(),
      ),
    ],
    onInit: () => OwnerBinding().dependencies(),
  );
}

WorkspaceConfig _buildRenterConfig() {
  return WorkspaceConfig(
    roleKey: 'arrendatario',
    workspaceType: WorkspaceType.renter,
    tabs: const [
      WorkspaceTab(
        title: 'Inicio',
        icon: Icons.home_outlined,
        page: TenantHomePage(),
      ),
      WorkspaceTab(
        title: 'Pagos',
        icon: Icons.payments_outlined,
        page: RenterPaymentsPage(),
      ),
      WorkspaceTab(
        title: 'Activo',
        icon: Icons.precision_manufacturing_outlined,
        page: RenterAssetPage(),
      ),
      WorkspaceTab(
        title: 'Documentos',
        icon: Icons.folder_open_outlined,
        page: RenterDocumentsPage(),
      ),
      WorkspaceTab(
        title: 'Chat',
        icon: Icons.chat_bubble_outline,
        page: RenterChatPage(),
      ),
    ],
    onInit: () => RenterBinding().dependencies(),
  );
}

WorkspaceConfig _buildSupplierConfig({
  required String orgType,
}) {
  final isEmpresa = orgType == 'empresa';

  return WorkspaceConfig(
    roleKey: 'prov_articulos',
    workspaceType: WorkspaceType.supplier,
    tabs: [
      const WorkspaceTab(
        title: 'Inicio',
        icon: Icons.home_outlined,
        page: ProviderArticlesHomePage(),
      ),
      const WorkspaceTab(
        title: 'Productos',
        icon: Icons.view_list_outlined,
        page: ProviderArticlesCatalogPage(),
      ),
      const WorkspaceTab(
        title: 'Pedidos',
        icon: Icons.assignment_outlined,
        page: ProviderArticlesOrdersShell(),
      ),
      if (isEmpresa)
        const WorkspaceTab(
          title: 'Comercial',
          icon: Icons.campaign_outlined,
          page: ProviderArticlesCommercialPage(),
        )
      else
        const WorkspaceTab(
          title: 'Chat',
          icon: Icons.chat_bubble_outline,
          page: ProviderArticlesChatPage(),
        ),
      if (isEmpresa)
        const WorkspaceTab(
          title: 'Chat',
          icon: Icons.chat_bubble_outline,
          page: ProviderArticlesChatPage(),
        )
      else
        const WorkspaceTab(
          title: 'Perfil',
          icon: Icons.person_outline,
          page: ProviderArticlesProfilePage(),
        ),
    ],
    onInit: () => ProviderArticlesBinding().dependencies(),
  );
}

WorkspaceConfig _buildWorkshopConfig() {
  return WorkspaceConfig(
    roleKey: 'prov_servicios',
    workspaceType: WorkspaceType.workshop,
    tabs: const [
      WorkspaceTab(
        title: 'Inicio',
        icon: Icons.home_outlined,
        page: ProviderServicesHomePage(),
      ),
      WorkspaceTab(
        title: 'Agenda',
        icon: Icons.calendar_today_outlined,
        page: ProviderServicesAgendaPage(),
      ),
      WorkspaceTab(
        title: 'Órdenes',
        icon: Icons.assignment_outlined,
        page: ProviderServicesOrdersPage(),
      ),
      WorkspaceTab(
        title: 'Contabilidad',
        icon: Icons.receipt_long_outlined,
        page: AccountingPage(),
      ),
      WorkspaceTab(
        title: 'Chat',
        icon: Icons.chat_bubble_outline,
        page: ProviderServicesChatPage(),
      ),
    ],
    onInit: () => ProviderServicesBinding().dependencies(),
  );
}

WorkspaceConfig _buildUnknownWorkspaceConfig({
  required String reason,
}) {
  return WorkspaceConfig(
    roleKey: 'unknown_workspace',
    workspaceType: WorkspaceType.unknown,
    tabs: [
      WorkspaceTab(
        title: 'Recuperación',
        icon: Icons.warning_amber_rounded,
        page: _UnknownWorkspacePage(reason: reason),
      ),
    ],
    onInit: null,
  );
}

// ============================================================================
// UNKNOWN / RECOVERY PAGE — fallback visual seguro para callers legacy.
// No debe ser el camino principal del bootstrap nuevo.
// ============================================================================

class _UnknownWorkspacePage extends StatelessWidget {
  final String reason;

  const _UnknownWorkspacePage({
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  'No fue posible cargar el workspace.',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Razón: $reason',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Regresa al inicio o actualiza el contexto del usuario para continuar.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LOGGING / NORMALIZATION HELPERS
// ============================================================================

String _normalizeOrgType(String? raw) {
  final value = (raw ?? 'personal').trim().toLowerCase();
  if (value == 'empresa') return 'empresa';
  return 'personal';
}

void _logUnrecognizedRole(String original, String normalized) {
  if (kDebugMode || kProfileMode) {
    debugPrint(
      '[WorkspaceConfig] Unrecognized role original="$original" normalized="$normalized"',
    );
  }

  try {
    if (Get.isRegistered<TelemetryService>()) {
      Get.find<TelemetryService>().log(
        'workspace_config_unrecognized_role',
        {
          'original': original,
          'normalized': normalized,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  } catch (e) {
    if (kDebugMode || kProfileMode) {
      debugPrint('[WorkspaceConfig] Telemetry error: $e');
    }
  }
}

void _logTypedFallback({
  required WorkspaceType sourceType,
  required WorkspaceType targetType,
}) {
  if (kDebugMode || kProfileMode) {
    debugPrint(
      '[WorkspaceConfig] Fallback tipado Fase 1: '
      '${sourceType.wireName} -> ${targetType.wireName}',
    );
  }

  try {
    if (Get.isRegistered<TelemetryService>()) {
      Get.find<TelemetryService>().log(
        'workspace_config_typed_fallback',
        {
          'sourceType': sourceType.wireName,
          'targetType': targetType.wireName,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  } catch (e) {
    if (kDebugMode || kProfileMode) {
      debugPrint('[WorkspaceConfig] Telemetry error: $e');
    }
  }
}

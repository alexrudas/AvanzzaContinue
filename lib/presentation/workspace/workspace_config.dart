// Chat por rol
import 'package:avanzza/presentation/pages/admin/accounting/admin_accounting_page.dart';
import 'package:avanzza/presentation/pages/admin/chat/admin_chat_page.dart';
import 'package:avanzza/presentation/pages/admin/home/admin_home_page.dart';
import 'package:avanzza/presentation/pages/admin/maintenance/admin_maintenance_page.dart';
import 'package:avanzza/presentation/pages/admin/purchase/admin_purchase_page.dart';
import 'package:flutter/material.dart';

import '../bindings/admin/admin_accounting_binding.dart';
import '../bindings/admin/admin_chat_binding.dart';
// Reemplazo de AdminShellBinding por bindings individuales
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
// Owner pages
import '../pages/owner/home/owner_home_page.dart';
import '../pages/owner/portfolio/owner_portfolio_page.dart';
import '../pages/provider/articles/catalog/provider_articles_catalog_page.dart';
import '../pages/provider/articles/chat/provider_articles_chat_page.dart';
// Provider Articles pages
import '../pages/provider/articles/home/provider_articles_home_page.dart';
import '../pages/provider/services/agenda/provider_services_agenda_page.dart';
import '../pages/provider/services/chat/provider_services_chat_page.dart';
// Provider Services pages
import '../pages/provider/services/home/provider_services_home_page.dart';
import '../pages/provider/services/orders/provider_services_orders_page.dart';
import '../pages/renter/asset/renter_asset_page.dart';
import '../pages/renter/chat/renter_chat_page.dart';
import '../pages/renter/documents/renter_documents_page.dart';
// Renter pages
import '../pages/renter/home/renter_home_page.dart';
import '../pages/renter/payments/renter_payments_page.dart';
import '../pages/workspaces/provider_articles_commercial_page.dart';
import '../pages/workspaces/provider_articles_orders_shell.dart';
import '../pages/workspaces/provider_articles_profile_page.dart';

class WorkspaceConfig {
  final String roleKey;
  final List<WorkspaceTab> tabs;
  final void Function()? onInit; // optional per-role bindings
  const WorkspaceConfig(
      {required this.roleKey, required this.tabs, this.onInit});
}

class WorkspaceTab {
  final String title;
  final IconData icon;
  final Widget page;
  const WorkspaceTab(
      {required this.title, required this.icon, required this.page});
}

bool isAdmin(String rol) => rol.contains('admin');
bool isOwner(String rol) => rol.contains('propietario');
bool isRenter(String rol) => rol.contains('arrendatario');
bool isProvider(String rol) => rol.contains('proveedor');
bool isAdvisor(String rol) => rol.contains('asesor');
bool isInsurer(String rol) =>
    rol.contains('aseguradora') || rol.contains('broker');
bool isLegal(String rol) => rol.contains('abog');

WorkspaceConfig workspaceFor({
  required String rol,
  String? providerType,
  String? orgType,
}) {
  final r = rol.toLowerCase();

  if (isAdmin(r)) {
    return WorkspaceConfig(
      roleKey: 'admin_activos',
      tabs: const [
        WorkspaceTab(
            title: 'Home', icon: Icons.home_outlined, page: AdminHomePage()),
        WorkspaceTab(
            title: 'Mantenimientos',
            icon: Icons.build_outlined,
            page: AdminMaintenancePage()),
        WorkspaceTab(
            title: 'Contabilidad',
            icon: Icons.receipt_long_outlined,
            page: AdminAccountingPage()),
        WorkspaceTab(
            title: 'Compras',
            icon: Icons.shopping_cart_outlined,
            page: AdminPurchasePage()),
        WorkspaceTab(
            title: 'Chat',
            icon: Icons.chat_bubble_outline,
            page: AdminChatPage()),
      ],
      onInit: () {
        // Cargar bindings de secciones admin
        AdminHomeBinding().dependencies();
        AdminMaintenanceBinding().dependencies();
        AdminAccountingBinding().dependencies();
        AdminPurchaseBinding().dependencies();
        AdminChatBinding().dependencies();
      },
    );
  }

  // Normalización de roles “proveedor de productos”
  if (isProvider(r) || isAdvisor(r) || isInsurer(r) || isLegal(r)) {
    final pt = (providerType ?? 'articulos').toLowerCase();
    if (pt == 'articulos') {
      // Detectar tipo de organización para adaptar tabs
      final isEmpresa = (orgType ?? 'personal').toLowerCase() == 'empresa';
      return WorkspaceConfig(
        roleKey: 'prov_articulos',
        tabs: [
          const WorkspaceTab(
              title: 'Home',
              icon: Icons.home_outlined,
              page: ProviderArticlesHomePage()),
          const WorkspaceTab(
              title: 'Productos',
              icon: Icons.view_list_outlined,
              page: ProviderArticlesCatalogPage()),
          const WorkspaceTab(
              title: 'Pedidos',
              icon: Icons.assignment_outlined,
              page: ProviderArticlesOrdersShell()),
          // Slot 4 depende del tipo de titular
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
          // Slot 5
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
    // Si providerType no es 'articulos', tratamos como servicios
    return WorkspaceConfig(
      roleKey: 'prov_servicios',
      tabs: const [
        WorkspaceTab(
            title: 'Home',
            icon: Icons.home_outlined,
            page: ProviderServicesHomePage()),
        WorkspaceTab(
            title: 'Agenda',
            icon: Icons.calendar_today_outlined,
            page: ProviderServicesAgendaPage()),
        WorkspaceTab(
            title: 'Órdenes',
            icon: Icons.assignment_outlined,
            page: ProviderServicesOrdersPage()),
        WorkspaceTab(
            title: 'Contabilidad',
            icon: Icons.receipt_long_outlined,
            page: AccountingPage()),
        WorkspaceTab(
            title: 'Chat',
            icon: Icons.chat_bubble_outline,
            page: ProviderServicesChatPage()),
      ],
      onInit: () => ProviderServicesBinding().dependencies(),
    );
  }

  if (isOwner(r)) {
    return WorkspaceConfig(
      roleKey: 'propietario',
      tabs: const [
        WorkspaceTab(
            title: 'Home', icon: Icons.home_outlined, page: OwnerHomePage()),
        WorkspaceTab(
            title: 'Portafolio',
            icon: Icons.inventory_2_outlined,
            page: OwnerPortfolioPage()),
        WorkspaceTab(
            title: 'Contratos',
            icon: Icons.description_outlined,
            page: OwnerContractsPage()),
        WorkspaceTab(
            title: 'Contabilidad',
            icon: Icons.receipt_long_outlined,
            page: AccountingPage()),
        WorkspaceTab(
            title: 'Chat',
            icon: Icons.chat_bubble_outline,
            page: OwnerChatPage()),
      ],
      onInit: () => OwnerBinding().dependencies(),
    );
  }

  if (isRenter(r)) {
    return WorkspaceConfig(
      roleKey: 'arrendatario',
      tabs: const [
        WorkspaceTab(
            title: 'Home', icon: Icons.home_outlined, page: RenterHomePage()),
        WorkspaceTab(
            title: 'Pagos',
            icon: Icons.payments_outlined,
            page: RenterPaymentsPage()),
        WorkspaceTab(
            title: 'Activo',
            icon: Icons.precision_manufacturing_outlined,
            page: RenterAssetPage()),
        WorkspaceTab(
            title: 'Documentos',
            icon: Icons.folder_open_outlined,
            page: RenterDocumentsPage()),
        WorkspaceTab(
            title: 'Chat',
            icon: Icons.chat_bubble_outline,
            page: RenterChatPage()),
      ],
      onInit: () => RenterBinding().dependencies(),
    );
  }

  // Fallback admin
  return workspaceFor(rol: 'admin', providerType: providerType);
}

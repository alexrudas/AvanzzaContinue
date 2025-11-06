/// lib/presentation/pages/admin/orders_and_quotation/admin_orders_page.dart
library;
// ============================================================================
// AdminOrdersPage — Pedidos/Cotizaciones PRO 2025 (Refactorizado)
// ----------------------------------------------------------------------------
// Orquesta los tabs de Pedidos y Cotizaciones usando widgets modulares.
// Los componentes se encuentran en widgets/ organizados por funcionalidad:
//   - widgets/shared/: Helpers y componentes compartidos
//   - widgets/header/: AddressCapsule y ExpandingTabsBar
//   - widgets/orders/: Todo lo relacionado con pedidos
//   - widgets/quotes/: Todo lo relacionado con cotizaciones
// Exportados mediante widgets.dart (barrel pattern)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avanzza/presentation/controllers/admin/purchase/admin_purchase_controller.dart';
import 'widgets.dart';

// ============================================================================
// ADMIN ORDERS PAGE ROOT
// ============================================================================
class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});
  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  int _tabIndex = 0;
  AdminPurchaseController get controller => Get.find<AdminPurchaseController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final hasOrg = controller.hasActiveOrg;
      final isLoading = controller.loading.value;
      final hasError = controller.error.value != null;

      return Column(
        children: [
          // HEADER
          Material(
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AddressCapsule(
                        address: 'Cra 43 #79-135, Barranquilla',
                        onTap: () => openAddressPicker(
                            initial: 'Cra 43 #79-135, Barranquilla'),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.location_on),
                            tooltip: 'Direcciones favoritas',
                            onPressed: () =>
                                Get.snackbar('Direcciones', 'En desarrollo'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_business),
                            tooltip: 'Proveedores favoritos',
                            onPressed: () =>
                                Get.snackbar('Proveedores', 'En desarrollo'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: ExpandingTabsBar(
                    index: _tabIndex,
                    onChanged: (i) => setState(() => _tabIndex = i),
                    onSearch: () => Get.snackbar('Buscar', 'En desarrollo'),
                    onFilter: () => Get.snackbar('Filtros', 'En desarrollo'),
                  ),
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _tabIndex == 0
                  ? OrdersTabBody(
                      controller: controller, key: const ValueKey('orders'))
                  : QuotesTabBody(
                      controller: controller, key: const ValueKey('quotes')),
            ),
          ),
        ],
      );
    });
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../navigation/bottom_nav_controller.dart';
import '../navigation/bottom_nav_items.dart';
import '../pages/admin/home/admin_home_page.dart';
import '../pages/admin/maintenance/admin_maintenance_page.dart';
import '../pages/admin/accounting/admin_accounting_page.dart';
import '../pages/admin/purchase/admin_purchase_page.dart';
import '../pages/admin/chat/admin_chat_page.dart';

class AdminShell extends GetView<BottomNavController> {
  const AdminShell({super.key});

  int _indexForRoute(String route) {
    switch (route) {
      case Routes.admin:
      case Routes.adminHome:
      case Routes.home:
        return BottomNavItem.home.index;
      case Routes.adminMaintenance:
        return BottomNavItem.maintenance.index;
      case Routes.adminAccounting:
        return BottomNavItem.accounting.index;
      case Routes.adminPurchase:
        return BottomNavItem.purchase.index;
      case Routes.adminChat:
        return BottomNavItem.chat.index;
      default:
        return BottomNavItem.home.index;
    }
  }

  void _navigateForIndex(int index) {
    switch (BottomNavItem.values[index]) {
      case BottomNavItem.home:
        Get.offNamed(Routes.adminHome);
        break;
      case BottomNavItem.maintenance:
        Get.offNamed(Routes.adminMaintenance);
        break;
      case BottomNavItem.accounting:
        Get.offNamed(Routes.adminAccounting);
        break;
      case BottomNavItem.purchase:
        Get.offNamed(Routes.adminPurchase);
        break;
      case BottomNavItem.chat:
        Get.offNamed(Routes.adminChat);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    controller.setIndexIfDifferent(_indexForRoute(currentRoute));

    final pages = const <Widget>[
      AdminHomePage(),
      AdminMaintenancePage(),
      AdminAccountingPage(),
      AdminPurchasePage(),
      AdminChatPage(),
    ];
    final useWideNav = Theme.of(context).useMaterial3 && MediaQuery.of(context).size.width >= 600;

    return Obx(() {
      final idx = controller.index.value;
      final items = bottomNavItems;
      return Scaffold(
        body: IndexedStack(index: idx, children: pages),
        bottomNavigationBar: useWideNav
            ? NavigationBar(
                selectedIndex: idx,
                destinations: [for (final it in items) NavigationDestination(icon: Icon(it.icon), label: it.label)],
                onDestinationSelected: (i) {
                  controller.setIndex(i);
                  _navigateForIndex(i);
                },
              )
            : BottomNavigationBar(
                currentIndex: idx,
                type: BottomNavigationBarType.fixed,
                items: [for (final it in items) BottomNavigationBarItem(icon: Icon(it.icon), label: it.label)],
                onTap: (i) {
                  controller.setIndex(i);
                  _navigateForIndex(i);
                },
              ),
      );
    });
  }
}

import 'package:avanzza/presentation/pages/provider/articles/orders/provider_articles_orders_page.dart';
import 'package:avanzza/presentation/pages/provider/articles/quotes/provider_articles_quotes_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderArticlesOrdersTabController extends GetxController {
  final RxInt desiredIndex = 0.obs;
  final RxString source = 'ui'.obs;
  void setIndex(int i, String src) {
    desiredIndex.value = i.clamp(0, 1);
    source.value = src;
    debugPrint('[OrdersShell] initialTab=${desiredIndex.value} source=$src');
  }
}

class ProviderArticlesOrdersShell extends StatefulWidget {
  final int initialTab; // 0=Órdenes, 1=Cotizaciones
  final String source; // ui | deeplink | push
  const ProviderArticlesOrdersShell(
      {super.key, this.initialTab = 0, this.source = 'ui'});

  @override
  State<ProviderArticlesOrdersShell> createState() =>
      _ProviderArticlesOrdersShellState();
}

class _ProviderArticlesOrdersShellState
    extends State<ProviderArticlesOrdersShell>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ProviderArticlesOrdersTabController _bus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTab.clamp(0, 1));
    _bus = Get.put(ProviderArticlesOrdersTabController(), permanent: false);
    // Log inicial
    debugPrint(
        '[OrdersShell] initialTab=${widget.initialTab} source=${widget.source}');
    // Suscribirse a cambios externos para idempotencia
    ever<int>(_bus.desiredIndex, (i) {
      if (_tabController.index != i) {
        _tabController.index = i;
      }
    });
    // Inicializar bus con el valor de entrada
    _bus.setIndex(widget.initialTab, widget.source);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        tabs: const [
          Tab(text: 'Pedidos'),
          Tab(text: 'Cotizaciones'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProviderArticlesOrdersPage(),
          ProviderArticlesQuotesPage(),
        ],
      ),
    );
  }
}

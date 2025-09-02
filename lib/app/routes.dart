import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String login = '/login';
  static const String orgSelect = '/org_select';
  static const String assets = '/assets';
  static const String incidencia = '/incidencia';
  static const String purchase = '/purchase';

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: login,
      page: () => const _PlaceholderPage(title: 'Login'),
    ),
    GetPage(
      name: orgSelect,
      page: () => const _PlaceholderPage(title: 'Seleccionar Organización'),
    ),
    GetPage(
      name: assets,
      page: () => const _PlaceholderPage(title: 'Activos'),
    ),
    GetPage(
      name: incidencia,
      page: () => const _PlaceholderPage(title: 'Incidencia'),
    ),
    GetPage(
      name: purchase,
      page: () => const _PlaceholderPage(title: 'Compras'),
    ),
  ];
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

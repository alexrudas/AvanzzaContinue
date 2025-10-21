import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/bottom_nav_theme.dart';
import '../controllers/workspace_controller.dart';
import '../widgets/workspace/workspace_drawer.dart';
import 'workspace_config.dart';

class WorkspaceShell extends StatefulWidget {
  final WorkspaceConfig config;
  const WorkspaceShell({super.key, required this.config});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  late final WorkspaceController c;

  @override
  void initState() {
    super.initState();
    widget.config.onInit?.call();
    c = Get.put(WorkspaceController(), permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    // Parsear roleKey a UserRole para aplicar el tema correcto
    final userRole = parseUserRole(widget.config.roleKey);

    return Obx(() {
      final idx = c.index.value;
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.config.roleKey),
        ),
        drawer: const WorkspaceDrawer(),
        body: IndexedStack(
            index: idx, children: [for (final t in widget.config.tabs) t.page]),
        // Usar NavigationBar (M3) siempre para aprovechar el diseño de burbujas
        // Material 3 está habilitado globalmente en app_theme.dart
        bottomNavigationBar: AvanzzaNavigationBar(
          role: userRole,
          currentIndex: idx,
          destinations: [
            for (final t in widget.config.tabs)
              NavigationDestination(icon: Icon(t.icon), label: t.title)
          ],
          onDestinationSelected: c.setIndex,
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final useWideNav = Theme.of(context).useMaterial3 &&
        MediaQuery.of(context).size.width >= 600;

    final isProviderRole = widget.config.roleKey.startsWith('prov_');

    return Obx(() {
      final idx = c.index.value;
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.config.roleKey),
        ),
        drawer: const WorkspaceDrawer(),
        body: IndexedStack(
            index: idx, children: [for (final t in widget.config.tabs) t.page]),
        bottomNavigationBar: useWideNav
            ? NavigationBar(
                selectedIndex: idx,
                destinations: [
                  for (final t in widget.config.tabs)
                    NavigationDestination(icon: Icon(t.icon), label: t.title)
                ],
                onDestinationSelected: c.setIndex,
              )
            : BottomNavigationBar(
                currentIndex: idx,
                type: BottomNavigationBarType.fixed,
                items: [
                  for (final t in widget.config.tabs)
                    BottomNavigationBarItem(icon: Icon(t.icon), label: t.title)
                ],
                onTap: c.setIndex,
              ),
      );
    });
  }
}

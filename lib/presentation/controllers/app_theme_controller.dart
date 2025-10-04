import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../data/datasources/local/theme_pref_ds.dart';

class AppThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  late final ThemePrefDS _ds;

  @override
  void onInit() {
    super.onInit();
    _ds = ThemePrefDS(DIContainer().isar);
    _loadPersisted();
  }

  Future<void> _loadPersisted() async {
    final m = await _ds.getMode();
    switch (m) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      case 'system':
      default:
        themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _ds.setMode(_toString(mode));
  }

  Future<void> toggleDark() async {
    final next =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = next;
    await _ds.setMode(_toString(next));
  }

  String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}

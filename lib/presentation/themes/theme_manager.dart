// ============================================================================
// theme_manager.dart
// ============================================================================
//
// QUÉ ES:
//   ChangeNotifier para gestionar ThemeMode con persistencia en SharedPreferences.
//
// DÓNDE SE IMPORTA:
//   - main.dart o donde se configure MaterialApp
//
// QUÉ NO HACE:
//   - NO está acoplado a GetX/Riverpod (ChangeNotifier puro)
//   - NO gestiona ColorScheme dinámico (solo ThemeMode)
//
// USO ESPERADO:
//   final themeManager = ThemeManager();
//   await themeManager.loadTheme();
//
//   MaterialApp(
//     themeMode: themeManager.currentMode,
//     theme: lightTheme,
//     darkTheme: darkTheme,
//   )
//
//   // Cambiar tema
//   themeManager.setTheme(ThemeMode.dark);
//   themeManager.toggleTheme();
//
// ADAPTACIÓN:
//   - Para GetX: convertir a GetxController con obs/update
//   - Para Riverpod: convertir a StateNotifier<ThemeMode>
//   - Para Bloc: convertir a ThemeCubit
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static const String _kThemeModeKey = 'theme_mode';

  ThemeMode _currentMode = ThemeMode.system;

  ThemeMode get currentMode => _currentMode;

  /// Cargar tema desde SharedPreferences.
  /// Llamar al inicio de la app (antes de runApp o en splash).
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_kThemeModeKey);

    if (modeIndex != null && modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
      _currentMode = ThemeMode.values[modeIndex];
      notifyListeners();
    }
  }

  /// Establecer tema explícito (light, dark, system).
  Future<void> setTheme(ThemeMode mode) async {
    if (_currentMode == mode) return;

    _currentMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeModeKey, mode.index);
  }

  /// Alternar entre light y dark (ignora system).
  /// Si está en system, cambia a light primero.
  Future<void> toggleTheme() async {
    final newMode = _currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newMode);
  }

  /// Restablecer a ThemeMode.system.
  Future<void> resetToSystem() async {
    await setTheme(ThemeMode.system);
  }
}

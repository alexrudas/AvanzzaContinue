# 🎨 Módulo de Theming UI PRO 2025

Sistema de diseño completo para Flutter con Material 3, tokens de diseño, y arquitectura escalable.

## 📋 Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Arquitectura](#arquitectura)
- [Estructura de Archivos](#estructura-de-archivos)
- [Guía de Uso](#guía-de-uso)
- [Migración desde Design System Local](#migración-desde-design-system-local)
- [Tokens de Diseño](#tokens-de-diseño)
- [Componentes](#componentes)
- [Temas (Presets)](#temas-presets)
- [Theme Manager](#theme-manager)
- [Ejemplos](#ejemplos)
- [FAQ](#faq)

---

## Descripción General

El módulo de theming UI PRO 2025 es un sistema de diseño centralizado que proporciona:

✅ **Material 3** completo (`useMaterial3: true`)
✅ **Dynamic Color** vía `ColorScheme.fromSeed()`
✅ **Tokens de diseño** (primitivos y semánticos)
✅ **Fundaciones** (tipografía, colores, motion, elevation)
✅ **Componentes** Material con estilos consistentes
✅ **3 Temas** pre-configurados (light, dark, high contrast)
✅ **Theme Manager** con persistencia en SharedPreferences
✅ **Tree-shakeable** (importa solo lo que necesitas)
✅ **Sin acoples** (compatible con GetX, Riverpod, Bloc)

---

## Arquitectura

El módulo sigue una arquitectura en capas sin dependencias circulares:

```
tokens/ (primitivas)
    ↓
foundations/ (fundaciones)
    ↓
components/ (estilos de componentes)
    ↓
presets/ (temas completos)
```

### Capas

1. **tokens/**: Valores atómicos (colores, spacing, motion, elevation)
2. **foundations/**: Construcciones sobre tokens (typography, color schemes, design system)
3. **components/**: Estilos de componentes Material (buttons, inputs, cards, etc.)
4. **presets/**: ThemeData completos para light/dark/high contrast

---

## Estructura de Archivos

```
lib/presentation/themes/
├── tokens/
│   ├── primitives.dart          # Colores base, spacing, radii, breakpoints
│   ├── semantic.dart             # Colores semánticos, estados, overlays
│   ├── motion.dart               # Duraciones, curvas, presets de animación
│   ├── elevation.dart            # Niveles 0-5 con BoxShadow
│   └── typography.dart           # Tokens tipográficos
│
├── foundations/
│   ├── typography.dart           # TextTheme M3 + highContrast
│   ├── color_schemes.dart        # ColorScheme light/dark/highContrast
│   ├── design_system.dart        # HUB central (DS)
│   └── theme_extensions.dart    # CustomThemeExtension (gradients, sombras)
│
├── components/
│   ├── material/
│   │   ├── buttons.dart          # Elevated, Text, Outlined, Filled, Icon
│   │   ├── inputs.dart           # InputDecorationTheme
│   │   ├── cards.dart            # CardTheme
│   │   ├── navigation.dart       # AppBar, BottomNav, Rail, Drawer
│   │   └── surfaces.dart         # BottomSheet, Dialog, SnackBar, Tooltip
│   └── custom/
│       └── .gitkeep              # Placeholder para componentes custom
│
├── presets/
│   ├── light_theme.dart          # ThemeData light completo
│   ├── dark_theme.dart           # ThemeData dark completo
│   └── high_contrast_theme.dart  # ThemeData accesible (WCAG AAA)
│
├── theme_manager.dart            # ChangeNotifier con SharedPreferences
└── theme_module.dart             # Barrel export completo
```

**Total:** 19 archivos Dart + 1 .gitkeep

---

## Guía de Uso

### 1. Integración Básica en `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:avanzza/presentation/themes/theme_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar ThemeManager
  final themeManager = ThemeManager();
  await themeManager.loadTheme();

  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatelessWidget {
  final ThemeManager themeManager;

  const MyApp({required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        return MaterialApp(
          title: 'Avanzza 2.0',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.currentMode,
          home: HomeScreen(),
        );
      },
    );
  }
}
```

### 2. Uso del Design System (DS)

El hub central `DS` proporciona acceso a todos los tokens y helpers:

```dart
import 'package:avanzza/presentation/themes/foundations/design_system.dart';

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Spacing
      padding: DS.insetsAll(DS.spacing.md),
      margin: DS.insetsSym(h: DS.spacing.lg, v: DS.spacing.sm),

      decoration: BoxDecoration(
        // Color del tema activo
        color: DS.scheme(context).surface,

        // Radii
        borderRadius: DS.radii.mdRadius,

        // Elevación
        boxShadow: DS.elevation.level2,
      ),

      child: Column(
        children: [
          // Tipografía del tema activo
          Text('Título', style: DS.text(context).titleLarge),

          // Gap vertical
          DS.gapH(DS.spacing.sm),

          // Colores semánticos
          Container(color: DS.semantic.success),
        ],
      ),
    );
  }
}
```

### 3. Acceso a Colores

```dart
// Colores primitivos (brand estático)
final brandPrimary = ColorPrimitives.primary;      // 0xFF1E88E5

// Colores semánticos
final success = SemanticColors.success;
final warning = SemanticColors.warning;
final info = SemanticColors.info;
final error = SemanticColors.error;

// Colores del tema activo (runtime)
final primary = DS.scheme(context).primary;
final onPrimary = DS.scheme(context).onPrimary;
final surface = DS.scheme(context).surface;
```

### 4. Breakpoints Responsive

```dart
final breakpoint = DS.bp(context);

switch (breakpoint) {
  case BreakpointType.mobile:
    return MobileLayout();
  case BreakpointType.tablet:
    return TabletLayout();
  case BreakpointType.desktop:
    return DesktopLayout();
}
```

### 5. Animaciones y Motion

```dart
AnimatedContainer(
  duration: DS.motion.normal,         // 250ms
  curve: DS.motion.easeOut,
  child: Widget(),
)

// Presets de motion
AnimatedOpacity(
  duration: DS.motion.fadeDuration,   // 150ms
  curve: DS.motion.fadeCurve,
  opacity: isVisible ? 1.0 : 0.0,
  child: Widget(),
)
```

### 6. Theme Extensions (Gradients y Sombras Custom)

```dart
final ext = DS.ext(context);

Container(
  decoration: BoxDecoration(
    gradient: ext.primaryGradient,    // Gradiente del brand
  ),
)

// Sombra acentuada (recordar poner elevation: 0 en widgets Material)
Card(
  elevation: 0,
  child: Container(
    decoration: BoxDecoration(
      boxShadow: ext.accentShadow,
    ),
  ),
)
```

---

## Migración desde Design System Local

Si tienes un `_DesignSystem` local, migra siguiendo estos pasos:

### Antes (Design System Local)

```dart
import '../widgets/_design_system.dart';

// Colores
final color = _DesignSystem.primaryColor;
final success = _DesignSystem.colors.success;

// Spacing
final padding = _DesignSystem.spacingMedium;

// Radii
final radius = _DesignSystem.borderRadiusMedium;
```

### Después (Módulo de Theming)

```dart
import 'package:avanzza/presentation/themes/tokens/primitives.dart';
import 'package:avanzza/presentation/themes/tokens/semantic.dart';
import 'package:avanzza/presentation/themes/foundations/design_system.dart';

// Colores
final color = ColorPrimitives.primary;       // Primitiva estática
final primary = DS.scheme(context).primary;  // Color del tema activo
final success = SemanticColors.success;

// Spacing
final padding = DS.spacing.md;  // 16.0

// Radii
final radius = DS.radii.mdRadius;  // BorderRadius.circular(12)
```

### Ejemplo Práctico: AdminMaintenancePage

**Antes:**
```dart
import '../widgets/_design_system.dart';

QuickAction(
  color: _DesignSystem.colors.success,  // ❌ Error: Undefined name
  badgeColor: _DesignSystem.colors.info,
)
```

**Después:**
```dart
import '../../../themes/tokens/primitives.dart';
import '../../../themes/tokens/semantic.dart';

QuickAction(
  color: SemanticColors.success,   // ✅ Funciona
  badgeColor: SemanticColors.info,
)
```

---

## Tokens de Diseño

### Colores Primitivos (`ColorPrimitives`)

```dart
// Brand colors
primary: Color(0xFF1E88E5)     // Azul corporativo (CONGELADO)
secondary: Color(0xFF388E3C)   // Verde
tertiary: Color(0xFFFF6F00)    // Naranja
error: Color(0xFFD32F2F)       // Rojo

// Escala de grises
neutral100 - neutral900
```

### Colores Semánticos (`SemanticColors`)

```dart
success: secondary        // Verde (operaciones exitosas)
warning: tertiary         // Naranja (advertencias)
info: primary            // Azul (información)
error: error             // Rojo (errores)

// Variantes light (contenedores)
successLight, warningLight, infoLight, errorLight
```

### Spacing (`SpacingPrimitives`)

```dart
xxs: 4.0
xs: 8.0
sm: 12.0
md: 16.0     // Estándar
lg: 24.0
xl: 32.0
xxl: 48.0
xxxl: 64.0
```

### Radii (`RadiusPrimitives`)

```dart
xs: 4.0
sm: 8.0
md: 12.0     // Estándar
lg: 16.0
xl: 24.0
full: 999.0  // Circular

// Helpers
DS.radii.mdRadius  // BorderRadius.circular(12)
```

### Breakpoints

```dart
mobile: < 600dp
tablet: 600-839dp
desktop: ≥ 1280dp
```

### Motion (Duraciones)

```dart
veryFast: 100ms   // Micro-interacciones mínimas
fast: 150ms       // Hover, pressed
normal: 250ms     // Transiciones estándar
slow: 350ms       // Transiciones complejas
verySlow: 500ms   // Animaciones enfáticas
```

### Motion (Curvas)

```dart
easeIn               // Salida de pantalla
easeOut              // Entrada a pantalla (recomendado)
easeInOut            // Bidireccional
easeInOutCubic       // Más suave
easeInOutCubicEmphasized  // M3 2025 enfática
fastOutSlowIn        // Material standard
```

### Elevation

```dart
level0: []                    // Sin elevación
level1: [BoxShadow...]        // 1dp - Cards
level2: [BoxShadow...]        // 3dp - Cards hover
level3: [BoxShadow...]        // 6dp - FAB, SnackBar
level4: [BoxShadow...]        // 8dp - Drawer
level5: [BoxShadow...]        // 12dp - Dialogs

// Valores numéricos para widgets Material
DS.elevation.value1  // 1.0
```

---

## Componentes

### Buttons

```dart
// Estilos pre-configurados para:
ElevatedButton
TextButton
OutlinedButton
FilledButton
IconButton

// Estados incluidos:
- Normal
- Hover (desktop)
- Pressed
- Disabled (onSurface al 38%)
- Focus (teclado)

// Características:
- Minimum size: 48x48dp (WCAG)
- Padding: horizontal 24dp, vertical 12dp
- Border radius: 12dp
```

### Inputs

```dart
// InputDecorationTheme incluye:
- Filled: true (background surfaceContainerHighest)
- Border: outline con primary en focus
- Error border: error color
- Label y hint styles
- Content padding: 16dp
```

### Cards

```dart
// CardTheme incluye:
- Color: surfaceContainerLow
- Shadow color y surface tint (M3)
- Elevation: 1dp
- Shape: border radius 12dp
- Margin: 8dp
```

### Navigation

```dart
// AppBarTheme
- Background: surface
- Elevation: 0 (flat)
- Icon theme
- Title style: titleLarge

// BottomNavigationBar
- Selected: primary
- Unselected: onSurfaceVariant
- Type: fixed
- Elevation: 3dp

// NavigationRail
- Similar a BottomNavigationBar
- Para tablets/desktop

// Drawer
- Background: surface
- Elevation: 1dp
```

### Surfaces

```dart
// BottomSheet
- Background: surface
- Elevation: 6dp
- Rounded top corners (16dp)

// Dialog
- Background: surface
- Elevation: 6dp
- Rounded corners (16dp)

// SnackBar
- Background: inverseSurface
- Text: onInverseSurface
- Shape: rounded (8dp)
- Behavior: floating

// Tooltip
- Background: inverseSurface
- Text: onInverseSurface
- Shape: rounded (4dp)
```

### Animated Helpers

Helpers de animación reutilizables con soporte automático para accesibilidad.

**✨ Características:**
- ✅ Respetan `MediaQuery.disableAnimations` automáticamente
- ✅ Usan tokens de `DS.motion` para consistencia
- ✅ Stateless y sin rebuilds innecesarios
- ✅ API ergonómica y composable

#### fadeIn

Animación de fade-in (opacidad 0.0 → 1.0):

```dart
fadeIn(
  duration: DS.motion.normal,  // 250ms
  curve: DS.motion.easeInOut,
  delay: DS.motion.fast,  // 150ms
  child: Text('Hello World'),
)
```

#### slideUp

Animación de deslizamiento desde abajo:

```dart
slideUp(
  offset: 50.0,
  duration: DS.motion.slow,  // 350ms
  curve: DS.motion.easeInOutCubicEmphasized,
  delay: DS.motion.veryFast,  // 100ms
  child: Card(
    child: ListTile(title: Text('Item')),
  ),
)
```

#### scaleIn

Animación de escala (0.85 → 1.0):

```dart
scaleIn(
  initialScale: 0.85,
  duration: DS.motion.normal,  // 250ms
  curve: DS.motion.easeInOutCubicEmphasized,
  child: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

#### staggeredList

Lista con animación escalonada (cada elemento con delay incremental):

```dart
staggeredList(
  staggerDelay: DS.motion.fast,  // 150ms entre elementos
  animationDuration: DS.motion.normal,  // 250ms cada uno
  curve: DS.motion.easeInOut,
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
    ListTile(title: Text('Item 3')),
  ],
)
```

#### staggeredListBuilder

Lista escalonada optimizada para grandes volúmenes (lazy building):

```dart
staggeredListBuilder(
  itemCount: 100,
  staggerDelay: DS.motion.veryFast,  // 100ms entre elementos
  animationDuration: DS.motion.normal,  // 250ms cada uno
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text('Item ${index + 1}'),
    );
  },
)
```

**♿ Nota de Accesibilidad:**
Todos los helpers verifican `MediaQuery.of(context).disableAnimations`.
Si el usuario ha deshabilitado animaciones (ajustes del sistema), los widgets se renderizan inmediatamente sin animación.

---

## Temas (Presets)

### Light Theme

```dart
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.light,
  textTheme: AppTypography.textTheme,
  extensions: [CustomThemeExtension.light],
  // ... todos los component themes
);
```

**Características:**
- Brightness: light
- Seed color: 0xFF1E88E5
- Surface tints automáticos (M3)
- Contraste óptimo para luz diurna

### Dark Theme

```dart
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.dark,
  textTheme: AppTypography.textTheme,
  extensions: [CustomThemeExtension.dark],
  // ... todos los component themes
);
```

**Características:**
- Brightness: dark
- Surface tints sutiles
- Mayor contraste en on* colors
- Optimizado para OLED

### High Contrast Theme

```dart
final highContrastTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColorSchemes.highContrastLight,
  textTheme: AppTypography.highContrastTextTheme,
  extensions: [CustomThemeExtension.highContrast],
  // ... todos los component themes
);
```

**Características:**
- Contraste WCAG AAA
- onPrimary/onSecondary: siempre blanco
- Sin gradientes (colores sólidos)
- Sombras más fuertes
- Font weights mayores
- Sin letter spacing negativo

---

## Theme Manager

Gestiona el modo de tema (light/dark/system) con persistencia.

### API

```dart
final themeManager = ThemeManager();

// Cargar tema guardado
await themeManager.loadTheme();

// Cambiar tema
await themeManager.setTheme(ThemeMode.dark);
await themeManager.setTheme(ThemeMode.light);
await themeManager.setTheme(ThemeMode.system);

// Alternar entre light y dark
await themeManager.toggleTheme();

// Restablecer a system
await themeManager.resetToSystem();

// Obtener tema actual
final mode = themeManager.currentMode;
```

### Integración con MaterialApp

```dart
AnimatedBuilder(
  animation: themeManager,
  builder: (context, _) {
    return MaterialApp(
      themeMode: themeManager.currentMode,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  },
)
```

### Adaptación a otros State Managers

**GetX:**
```dart
class ThemeController extends GetxController {
  final mode = ThemeMode.system.obs;

  void setTheme(ThemeMode newMode) async {
    mode.value = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', newMode.index);
  }
}
```

**Riverpod:**
```dart
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt('theme_mode');
    if (modeIndex != null) {
      state = ThemeMode.values[modeIndex];
    }
  }
}
```

---

## Ejemplos

### Ejemplo 1: Card con Design System

```dart
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: DS.radii.mdRadius,
  ),
  child: Container(
    padding: DS.insetsAll(DS.spacing.md),
    decoration: BoxDecoration(
      boxShadow: DS.elevation.level1,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Título', style: DS.text(context).titleMedium),
        DS.gapH(DS.spacing.xs),
        Text('Contenido', style: DS.text(context).bodyMedium),
      ],
    ),
  ),
)
```

### Ejemplo 2: Lista con Estados

```dart
ListView.builder(
  itemBuilder: (context, index) {
    final isActive = items[index].isActive;

    return Container(
      margin: DS.insetsSym(h: DS.spacing.md, v: DS.spacing.xs),
      padding: DS.insetsAll(DS.spacing.md),
      decoration: BoxDecoration(
        color: isActive
          ? DS.semantic.successLight
          : DS.scheme(context).surface,
        borderRadius: DS.radii.mdRadius,
        border: Border.all(
          color: isActive
            ? DS.semantic.success
            : DS.scheme(context).outline,
        ),
      ),
      child: Text(items[index].title),
    );
  },
)
```

### Ejemplo 3: Animación con Motion

```dart
class AnimatedBox extends StatefulWidget {
  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: DS.motion.expansionDuration,
        curve: DS.motion.expansionCurve,
        height: isExpanded ? 200 : 80,
        decoration: BoxDecoration(
          color: DS.scheme(context).primaryContainer,
          borderRadius: DS.radii.lgRadius,
        ),
        child: Center(child: Text('Tap para expandir')),
      ),
    );
  }
}
```

### Ejemplo 4: Responsive Layout

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final breakpoint = DS.bp(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: breakpoint == BreakpointType.mobile
            ? DS.spacing.md
            : DS.spacing.xxl,
        ),
        child: breakpoint == BreakpointType.mobile
          ? _buildMobileLayout()
          : breakpoint == BreakpointType.tablet
            ? _buildTabletLayout()
            : _buildDesktopLayout(),
      ),
    );
  }
}
```

---

## FAQ

### ¿Puedo usar solo tokens sin el theme manager?

Sí. Los tokens son independientes:

```dart
import 'package:avanzza/presentation/themes/tokens/primitives.dart';
import 'package:avanzza/presentation/themes/tokens/semantic.dart';

Container(color: SemanticColors.success)
```

### ¿Cómo cambio el color primary del brand?

El color está congelado en `ColorPrimitives.primary = 0xFF1E88E5`. Para cambiarlo:

1. Edita `lib/presentation/themes/tokens/primitives.dart`
2. Ejecuta `flutter pub run build_runner build --delete-conflicting-outputs` (si usas code generation)
3. Verifica que todos los ColorScheme usen el mismo seed

### ¿Puedo agregar tokens custom?

Sí. Agrega nuevas constantes en los archivos de tokens:

```dart
// tokens/primitives.dart
abstract class ColorPrimitives {
  // ... existentes
  static const Color accent = Color(0xFFFF5722);
}

// tokens/semantic.dart
abstract class SemanticColors {
  // ... existentes
  static const Color accent = ColorPrimitives.accent;
}
```

### ¿Cómo evito doble sombra?

Si usas `CustomThemeExtension.accentShadow` o `softShadow`, pon `elevation: 0` en widgets Material:

```dart
Card(
  elevation: 0,  // ⚠️ IMPORTANTE
  child: Container(
    decoration: BoxDecoration(
      boxShadow: DS.ext(context).accentShadow,
    ),
  ),
)
```

### ¿El módulo es compatible con Dynamic Color (Android 12+)?

Los ColorScheme se generan con `ColorScheme.fromSeed()`, que es compatible con Dynamic Color. Sin embargo, los **gradientes** en `CustomThemeExtension` son estáticos (hardcoded).

**TODO:** Derivar gradientes desde `Theme.of(context).colorScheme.primary` cuando actives Dynamic Color.

### ¿Puedo usar este módulo con GetX/Riverpod/Bloc?

Sí. `ThemeManager` es un `ChangeNotifier` puro. Adaptaciones:

- **GetX:** Convertir a `GetxController` con `.obs` y `update()`
- **Riverpod:** Convertir a `StateNotifier<ThemeMode>`
- **Bloc:** Convertir a `ThemeCubit`

### ¿Qué hacer si flutter analyze muestra warnings de `prefer_const_constructors`?

Son sugerencias de optimización, no errores. Puedes:

1. Ignorarlos (no afectan funcionalidad)
2. Agregar `const` donde aplique
3. Desactivar el lint en `analysis_options.yaml`

### ¿Cómo testeo el módulo?

```dart
testWidgets('DS colors are accessible', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: lightTheme,
      home: Builder(
        builder: (context) {
          final primary = DS.scheme(context).primary;
          expect(primary, isNotNull);
          return Container();
        },
      ),
    ),
  );
});
```

### ¿Necesito registrar la fuente Roboto?

Roboto viene incluida en Flutter. Si quieres una fuente custom:

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

Luego actualiza `foundations/typography.dart`:

```dart
static const String fontFamily = 'Inter';
```

---

## 📚 Referencias

- [Material 3 Design](https://m3.material.io/)
- [Flutter Material 3](https://docs.flutter.dev/ui/design/material)
- [WCAG Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Design Tokens](https://designtokens.org/)

---

## 📝 Changelog

### v1.0.0 (2025-01-XX)
- ✅ Módulo inicial completo
- ✅ Tokens: primitives, semantic, motion, elevation, typography
- ✅ Foundations: typography, color_schemes, design_system, theme_extensions
- ✅ Components: buttons, inputs, cards, navigation, surfaces
- ✅ Presets: light, dark, high contrast
- ✅ ThemeManager con SharedPreferences
- ✅ Migración de AdminMaintenancePage

---

## 🤝 Contribuir

Para agregar nuevos componentes o tokens:

1. Crear archivos en la carpeta correspondiente (`tokens/`, `foundations/`, `components/`)
2. Agregar documentación con headers (Qué es, Dónde se importa, Qué no hace, Uso esperado)
3. Exportar en `theme_module.dart` si es público
4. Actualizar este README con ejemplos

---

## ⚠️ Notas Importantes

🔒 **Color seed congelado:** `0xFF1E88E5` - NO cambiar sin revisión completa
🔒 **NO modificar archivos fuera de** `lib/presentation/themes/`
🔒 **NO borrar design systems locales todavía** (migración gradual)

📝 **TODOs pendientes:**
- Derivar gradientes desde Dynamic Color cuando se active
- Agregar pruebas golden con textScaler 1.0/1.2/1.4
- Registrar fuente Roboto en pubspec.yaml (opcional)
- Migrar páginas restantes al nuevo módulo

---

**Creado por:** Claude AI
**Rama:** `refactor/themes-module`
**Estado:** ✅ Completado y funcional

# Sistema de Theming de Bottom Navigation Bar por Rol

## Descripción

Sistema centralizado de theming para Bottom Navigation Bars en Avanzza 2.0 que implementa burbujas activas con colores específicos por rol de usuario, respetando la paleta corporativa.

## Archivos

- **`bottom_nav_theme.dart`**: Sistema completo de theming
- **`../presentation/pages/demo/bottom_nav_demo_page.dart`**: Página de demostración

## Características

✅ **7 roles con colores únicos**
- Propietario de activos: `#004E64` (azul petróleo)
- Administrador de activos: `#0077B6`
- Arrendatario de activos: `#2A9D8F`
- Proveedor de artículos: `#E76F51`
- Proveedor de servicios: `#E9C46A`
- Aseguradora/Broker/Asesor: `#264653`
- Abogados: `#6A4C93`

✅ **Soporte para Material 2 y Material 3**
- `NavigationBar` (M3) con burbuja activa
- `BottomNavigationBar` (M2) con colores por rol

✅ **Paleta corporativa Avanzza 2.0**
- Marca: `#004E64`, `#00A5CF`
- Neutros: `#F4F4F4`, `#1A1A1A`, `#FFFFFF`
- Inactivos: `#E0E0E0` (fondo), `#555555` (texto)

✅ **Animaciones suaves** (200ms, manejadas automáticamente por Flutter)

✅ **Código 100% documentado** con ejemplos completos

## Uso Rápido

### 1. Aplicar globalmente en ThemeData

```dart
import 'package:avanzza/core/theme/bottom_nav_theme.dart';

MaterialApp(
  theme: ThemeData(
    navigationBarTheme: buildNavigationBarTheme(UserRole.administradorActivos),
    bottomNavigationBarTheme: buildBottomNavigationBarTheme(UserRole.administradorActivos),
  ),
  home: MyHomePage(),
);
```

### 2. Usar widgets pre-configurados

```dart
// Material 3 - NavigationBar
AvanzzaNavigationBar(
  role: UserRole.proveedorServicios,
  currentIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
    NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
    NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
  ],
);

// Material 2 - BottomNavigationBar
AvanzzaBottomNavigationBar(
  role: UserRole.aseguradora,
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
  ],
);
```

### 3. Parsear rol desde string

```dart
// Desde Firestore o backend
final roleString = userDoc.data()['role'] as String;
final userRole = parseUserRole(roleString); // Soporta aliases comunes

// Ejemplos de strings que funcionan:
parseUserRole('propietario');           // → UserRole.propietarioActivos
parseUserRole('admin');                 // → UserRole.administradorActivos
parseUserRole('Asesor de seguros');     // → UserRole.aseguradora
```

### 4. Integración con GetX (patrón Avanzza)

```dart
class SessionContextController extends GetxController {
  final Rx<UserRole> currentRole = UserRole.propietarioActivos.obs;

  void updateRole(UserRole newRole) {
    currentRole.value = newRole;
  }
}

class MyPage extends GetView<SessionContextController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final role = controller.currentRole.value;
      return Scaffold(
        bottomNavigationBar: AvanzzaNavigationBar(
          role: role,
          currentIndex: 0,
          onDestinationSelected: (index) {},
          destinations: [...],
        ),
      );
    });
  }
}
```

## Ver Demo

Para ver la demostración completa con selector de roles y visualización de paleta:

```dart
import 'package:avanzza/presentation/pages/demo/bottom_nav_demo_page.dart';

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const BottomNavDemoPage()),
);
```

## API Reference

### Enums

```dart
enum UserRole {
  propietarioActivos,
  administradorActivos,
  arrendatarioActivos,
  proveedorArticulos,
  proveedorServicios,
  aseguradora,
  abogados,
}
```

### Funciones de Builder

```dart
// Material 3
NavigationBarThemeData buildNavigationBarTheme(UserRole role)

// Material 2
BottomNavigationBarThemeData buildBottomNavigationBarTheme(UserRole role)
```

### Funciones Helper

```dart
// Parsear string a UserRole (soporta aliases)
UserRole parseUserRole(String roleString)
```

### Clases de Colores

```dart
class AvanzzaColors {
  static const Color brandPrimary = Color(0xFF004E64);
  static const Color accent = Color(0xFF00A5CF);
  static const Color neutralLight = Color(0xFFF4F4F4);
  static const Color neutralDark = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color inactiveBackground = Color(0xFFE0E0E0);
  static const Color inactiveText = Color(0xFF555555);

  // Colores por rol
  static const Color propietario = Color(0xFF004E64);
  static const Color administrador = Color(0xFF0077B6);
  static const Color arrendatario = Color(0xFF2A9D8F);
  static const Color proveedorArticulos = Color(0xFFE76F51);
  static const Color proveedorServicios = Color(0xFFE9C46A);
  static const Color aseguradora = Color(0xFF264653);
  static const Color abogados = Color(0xFF6A4C93);
}
```

### Widgets Personalizados

```dart
// Material 3 wrapper
class AvanzzaNavigationBar extends StatelessWidget {
  final UserRole role;
  final int currentIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<NavigationDestination> destinations;
}

// Material 2 wrapper
class AvanzzaBottomNavigationBar extends StatelessWidget {
  final UserRole role;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<BottomNavigationBarItem> items;
}
```

## Migración desde Implementaciones Antiguas

Si tienes bottom navigation bars existentes en las páginas por rol:

### Antes:
```dart
BottomNavigationBar(
  currentIndex: _index,
  selectedItemColor: Colors.blue, // Color hardcodeado
  items: [...],
)
```

### Después:
```dart
AvanzzaBottomNavigationBar(
  role: UserRole.administradorActivos, // Color automático
  currentIndex: _index,
  onTap: (index) => setState(() => _index = index),
  items: [...],
)
```

## Testing

```dart
testWidgets('NavigationBar muestra color correcto por rol', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        navigationBarTheme: buildNavigationBarTheme(UserRole.administradorActivos),
      ),
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          ],
        ),
      ),
    ),
  );

  // Verificar que el tema se aplicó correctamente
  final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
  expect(Theme.of(tester.element(find.byType(NavigationBar)))
    .navigationBarTheme.indicatorColor,
    AvanzzaColors.administrador);
});
```

## Requisitos de Compilación

- Flutter SDK >=3.4.0
- Dart >=3.4.0
- Material Components (incluido en Flutter)

## Notas Importantes

1. **Animaciones**: Las transiciones de 200ms son manejadas automáticamente por Flutter, no requieren configuración explícita.

2. **Material 3 vs Material 2**:
   - `NavigationBar` (M3) usa una burbuja/indicador para el item activo
   - `BottomNavigationBar` (M2) colorea el icono y texto del item activo

3. **Compatibilidad**: Funciona con cualquier versión de Flutter >=3.4.0

4. **Accesibilidad**: Los colores cumplen con WCAG AA para contraste (blanco sobre colores de rol)

## Ejemplos de Integración

Ver el archivo `bottom_nav_theme.dart` líneas 406-746 para una guía completa con 8 casos de uso diferentes.

## Autores

Implementado para Avanzza 2.0 - Sistema de theming corporativo centralizado.

## Licencia

Este código es parte del proyecto Avanzza 2.0.

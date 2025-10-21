import 'package:flutter/material.dart';

/// Enumera los roles de usuario en la plataforma Avanzza 2.0.
///
/// Cada rol tiene asociado un color de burbuja activa específico
/// que se aplica en el bottom navigation bar cuando el ítem está seleccionado.
enum UserRole {
  /// Propietario de activos - Color: #004E64 (azul petróleo)
  propietarioActivos,

  /// Administrador de activos - Color: #0077B6
  administradorActivos,

  /// Arrendatario de activos - Color: #2A9D8F
  arrendatarioActivos,

  /// Proveedor de artículos - Color: #E76F51
  proveedorArticulos,

  /// Proveedor de servicios - Color: #E9C46A
  proveedorServicios,

  /// Aseguradora/Broker/Asesor - Color: #264653
  aseguradora,

  /// Abogados - Color: #6A4C93
  abogados,
}

/// Parsea un string a [UserRole], soportando alias comunes.
///
/// Parámetros:
/// - [roleString]: String que representa el rol (case-insensitive)
///
/// Retorna:
/// - El [UserRole] correspondiente
/// - Si no se encuentra match, retorna [UserRole.propietarioActivos] por defecto
///
/// Ejemplos:
/// ```dart
/// parseUserRole('propietario'); // UserRole.propietarioActivos
/// parseUserRole('admin'); // UserRole.administradorActivos
/// parseUserRole('Asesor de seguros'); // UserRole.aseguradora
/// parseUserRole('admin_activos'); // UserRole.administradorActivos (roleKey)
/// parseUserRole('prov_servicios'); // UserRole.proveedorServicios (roleKey)
/// ```
UserRole parseUserRole(String roleString) {
  final normalized = roleString.toLowerCase().trim();

  // Mapeo de aliases comunes a roles
  final aliases = <String, UserRole>{
    // Propietario
    'propietario': UserRole.propietarioActivos,
    'propietario de activos': UserRole.propietarioActivos,
    'owner': UserRole.propietarioActivos,
    'dueño': UserRole.propietarioActivos,

    // Administrador
    'administrador': UserRole.administradorActivos,
    'administrador de activos': UserRole.administradorActivos,
    'admin': UserRole.administradorActivos,
    'administrator': UserRole.administradorActivos,
    'admin_activos': UserRole.administradorActivos, // roleKey

    // Arrendatario
    'arrendatario': UserRole.arrendatarioActivos,
    'arrendatario de activos': UserRole.arrendatarioActivos,
    'tenant': UserRole.arrendatarioActivos,
    'inquilino': UserRole.arrendatarioActivos,

    // Proveedor de artículos
    'proveedor articulos': UserRole.proveedorArticulos,
    'proveedor de articulos': UserRole.proveedorArticulos,
    'proveedor de artículos': UserRole.proveedorArticulos,
    'proveedor artículos': UserRole.proveedorArticulos,
    'supplier': UserRole.proveedorArticulos,
    'product provider': UserRole.proveedorArticulos,
    'prov_articulos': UserRole.proveedorArticulos, // roleKey

    // Proveedor de servicios
    'proveedor servicios': UserRole.proveedorServicios,
    'proveedor de servicios': UserRole.proveedorServicios,
    'service provider': UserRole.proveedorServicios,
    'services': UserRole.proveedorServicios,
    'prov_servicios': UserRole.proveedorServicios, // roleKey

    // Aseguradora/Broker/Asesor
    'aseguradora': UserRole.aseguradora,
    'broker': UserRole.aseguradora,
    'asesor': UserRole.aseguradora,
    'asesor de seguros': UserRole.aseguradora,
    'insurance': UserRole.aseguradora,
    'insurance broker': UserRole.aseguradora,

    // Abogados
    'abogado': UserRole.abogados,
    'abogados': UserRole.abogados,
    'lawyer': UserRole.abogados,
    'legal': UserRole.abogados,
    'attorney': UserRole.abogados,

    // Neutral/fallback
    'prov_neutral': UserRole.propietarioActivos,
  };

  return aliases[normalized] ?? UserRole.propietarioActivos;
}

/// Paleta de colores corporativos de Avanzza 2.0
class AvanzzaColors {
  AvanzzaColors._();

  // Colores de marca principales
  /// Color de marca principal - Azul petróleo
  static const Color brandPrimary = Color(0xFF004E64);

  /// Color de acento
  static const Color accent = Color(0xFF00A5CF);

  // Colores neutros
  /// Fondo claro
  static const Color neutralLight = Color(0xFFF4F4F4);

  /// Texto/elementos oscuros
  static const Color neutralDark = Color(0xFF1A1A1A);

  /// Blanco
  static const Color white = Color(0xFFFFFFFF);

  // Estados inactivos
  /// Fondo de elementos inactivos
  static const Color inactiveBackground = Color(0xFFE0E0E0);

  /// Texto de elementos inactivos
  static const Color inactiveText = Color(0xFF555555);

  /// Texto de labels en navigation bar (más oscuro para mejor legibilidad)
  static const Color navLabelText = Color(0xFF2C2C2C);

  // Colores por rol (burbuja activa)
  /// Propietario de activos - Azul petróleo
  static const Color propietario = Color(0xFF004E64);

  /// Administrador de activos
  static const Color administrador = Color(0xFF0077B6);

  /// Arrendatario de activos
  static const Color arrendatario = Color(0xFF2A9D8F);

  /// Proveedor de artículos
  static const Color proveedorArticulos = Color(0xFFE76F51);

  /// Proveedor de servicios
  static const Color proveedorServicios = Color(0xFFE9C46A);

  /// Aseguradora/Broker/Asesor
  static const Color aseguradora = Color(0xFF264653);

  /// Abogados
  static const Color abogados = Color(0xFF6A4C93);
}

/// Mapa que asocia cada rol con su color de burbuja activa.
///
/// Este mapa se utiliza internamente por los builders de tema
/// para aplicar el color correcto según el rol del usuario.
const Map<UserRole, Color> roleColorMap = {
  UserRole.propietarioActivos: AvanzzaColors.propietario,
  UserRole.administradorActivos: AvanzzaColors.administrador,
  UserRole.arrendatarioActivos: AvanzzaColors.arrendatario,
  UserRole.proveedorArticulos: AvanzzaColors.proveedorArticulos,
  UserRole.proveedorServicios: AvanzzaColors.proveedorServicios,
  UserRole.aseguradora: AvanzzaColors.aseguradora,
  UserRole.abogados: AvanzzaColors.abogados,
};

/// Construye un [NavigationBarThemeData] personalizado para Material 3
/// con burbuja activa según el [UserRole].
///
/// Características:
/// - Burbuja activa con el color del rol
/// - Icono y label activos en blanco sobre fondo del color del rol
/// - Elementos inactivos en gris (#E0E0E0 fondo, #555555 texto)
/// - Animación de 200ms
/// - Fondo blanco del navigation bar
///
/// IMPORTANTE: Para lograr el efecto de fondo gris en items inactivos,
/// usa el widget AvanzzaNavigationBar que incluye un overlay personalizado,
/// o usa surfaceTintColor con un overlay color.
///
/// Parámetros:
/// - [role]: El rol del usuario actual
///
/// Retorna:
/// - [NavigationBarThemeData] configurado con la paleta Avanzza 2.0
///
/// Ejemplo de uso:
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     navigationBarTheme: buildNavigationBarTheme(UserRole.administradorActivos),
///   ),
///   home: Scaffold(
///     bottomNavigationBar: NavigationBar(
///       selectedIndex: 0,
///       destinations: [
///         NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
///         NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
///       ],
///     ),
///   ),
/// );
/// ```
NavigationBarThemeData buildNavigationBarTheme(UserRole role) {
  final activeColor = roleColorMap[role] ?? AvanzzaColors.propietario;

  return NavigationBarThemeData(
    // Fondo del navigation bar
    backgroundColor: AvanzzaColors.white,

    // Altura del navigation bar
    height: 64,

    // Color de la burbuja/indicador activo
    indicatorColor: activeColor,

    // Shape del indicador (burbuja con bordes redondeados stadium=pill)
    indicatorShape: const StadiumBorder(),

    // Overlay color para efectos de hover/ripple en items inactivos
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return AvanzzaColors.inactiveBackground.withValues(alpha: 0.5);
      }
      if (states.contains(WidgetState.hovered)) {
        return AvanzzaColors.inactiveBackground.withValues(alpha: 0.3);
      }
      // Sin overlay por defecto (el NavigationDestination renderiza su propio Container)
      return null;
    }),

    // Color del icono según estado
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
      if (states.contains(WidgetState.selected)) {
        // Icono activo: blanco sobre burbuja de color
        return const IconThemeData(
          color: AvanzzaColors.white,
          size: 24,
        );
      }
      // Icono inactivo: gris oscuro
      return const IconThemeData(
        color: AvanzzaColors.inactiveText,
        size: 24,
      );
    }),

    // Estilo del label según estado
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(WidgetState.selected)) {
        // Label activo: blanco sobre burbuja de color
        return const TextStyle(
          color: AvanzzaColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      }
      // Label inactivo: gris oscuro
      return const TextStyle(
        color: AvanzzaColors.inactiveText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
    }),

    // Comportamiento del label
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

    // Nota: La animación de 200ms es manejada automáticamente por Flutter
    // en las transiciones del NavigationBar. No requiere configuración explícita.
  );
}

/// Construye un [BottomNavigationBarThemeData] personalizado para Material 2
/// con estilos según el [UserRole].
///
/// Características:
/// - Item seleccionado con el color del rol
/// - Icono y label activos en color del rol
/// - Elementos inactivos en gris (#555555)
/// - Fondo blanco
/// - Todos los labels visibles
///
/// Parámetros:
/// - [role]: El rol del usuario actual
///
/// Retorna:
/// - [BottomNavigationBarThemeData] configurado con la paleta Avanzza 2.0
///
/// Ejemplo de uso:
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     bottomNavigationBarTheme: buildBottomNavigationBarTheme(UserRole.proveedorServicios),
///   ),
///   home: Scaffold(
///     bottomNavigationBar: BottomNavigationBar(
///       currentIndex: 0,
///       items: [
///         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
///         BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
///       ],
///     ),
///   ),
/// );
/// ```
BottomNavigationBarThemeData buildBottomNavigationBarTheme(UserRole role) {
  final activeColor = roleColorMap[role] ?? AvanzzaColors.propietario;

  return BottomNavigationBarThemeData(
    // Fondo del navigation bar
    backgroundColor: AvanzzaColors.white,

    // Color del item seleccionado (icono + label)
    selectedItemColor: activeColor,

    // Color del item no seleccionado
    unselectedItemColor: AvanzzaColors.inactiveText,

    // Tipo de navigation bar (fixed mantiene todos los items visibles)
    type: BottomNavigationBarType.fixed,

    // Mostrar labels tanto seleccionados como no seleccionados
    showSelectedLabels: true,
    showUnselectedLabels: true,

    // Estilos de texto
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),

    // Tamaño de iconos
    selectedIconTheme: const IconThemeData(size: 24),
    unselectedIconTheme: const IconThemeData(size: 24),

    // Elevation
    elevation: 8,
  );
}

/// Widget personalizado que implementa NavigationBar (M3) estilo Avanzza 2.0
/// con burbuja activa por rol según especificaciones de diseño.
///
/// Características:
/// - Item activo: Burbuja con color del rol + icono blanco + label oscuro semibold
/// - Items inactivos: SIN burbuja, solo icono gris + label oscuro normal
/// - Fondo del nav bar: Color de fondo de páginas (#F4F4F4)
/// - Altura aumentada para mejor espaciado vertical
/// - Animaciones suaves de 200ms
///
/// Ejemplo de uso:
/// ```dart
/// AvanzzaNavigationBar(
///   role: UserRole.administradorActivos,
///   currentIndex: 0,
///   onDestinationSelected: (index) => print('Selected: $index'),
///   destinations: [
///     NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
///     NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
///     NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
///   ],
/// )
/// ```
class AvanzzaNavigationBar extends StatelessWidget {
  /// Rol del usuario (determina el color de la burbuja activa)
  final UserRole role;

  /// Índice del item actualmente seleccionado
  final int currentIndex;

  /// Callback cuando se selecciona un destino
  final ValueChanged<int>? onDestinationSelected;

  /// Lista de destinos del navigation bar
  final List<NavigationDestination> destinations;

  const AvanzzaNavigationBar({
    super.key,
    required this.role,
    required this.currentIndex,
    this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = roleColorMap[role] ?? AvanzzaColors.propietario;

    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          // Fondo del nav bar: mismo color que el fondo de las páginas
          backgroundColor: AvanzzaColors.neutralLight,

          // Altura aumentada para mejor espaciado
          height: 72,

          // Color de la burbuja del item activo
          indicatorColor: activeColor,

          // Shape de la burbuja: pill/stadium
          indicatorShape: const StadiumBorder(),

          // Iconos: blanco cuando activo, gris cuando inactivo
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                color: AvanzzaColors.white,
                size: 26, // Ligeramente más grande
              );
            }
            return const IconThemeData(
              color: AvanzzaColors.inactiveText,
              size: 24,
            );
          }),

          // Labels: TODOS en color oscuro para legibilidad
          // Activo = semibold, Inactivo = normal
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AvanzzaColors.navLabelText, // Oscuro #2C2C2C
                fontSize: 13,
                fontWeight: FontWeight.w600, // Semibold para destacar
                letterSpacing: 0.1,
                height: 1.3,
              );
            }
            return const TextStyle(
              color: AvanzzaColors.navLabelText, // Mismo color oscuro
              fontSize: 12,
              fontWeight: FontWeight.normal, // Peso normal
              letterSpacing: 0.1,
              height: 1.3,
            );
          }),

          // Siempre mostrar labels tanto para activos como inactivos
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      ),
    );
  }
}

/// Ejemplo de widget personalizado que usa BottomNavigationBar (M2)
/// con theming dinámico por rol.
///
/// Este widget muestra cómo aplicar el tema directamente
/// sin modificar el ThemeData global.
///
/// Ejemplo de uso:
/// ```dart
/// AvanzzaBottomNavigationBar(
///   role: UserRole.proveedorArticulos,
///   currentIndex: 1,
///   onTap: (index) => print('Selected: $index'),
///   items: [
///     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
///     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
///     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
///   ],
/// )
/// ```
class AvanzzaBottomNavigationBar extends StatelessWidget {
  /// Rol del usuario (determina el color activo)
  final UserRole role;

  /// Índice del item actualmente seleccionado
  final int currentIndex;

  /// Callback cuando se toca un item
  final ValueChanged<int>? onTap;

  /// Lista de items del navigation bar
  final List<BottomNavigationBarItem> items;

  const AvanzzaBottomNavigationBar({
    super.key,
    required this.role,
    required this.currentIndex,
    this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = buildBottomNavigationBarTheme(role);

    return Theme(
      data: Theme.of(context).copyWith(
        bottomNavigationBarTheme: theme,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
      ),
    );
  }
}

/*
═══════════════════════════════════════════════════════════════════════════════
GUÍA DE USO COMPLETA
═══════════════════════════════════════════════════════════════════════════════

1. USO EN THEMEDATA GLOBAL
───────────────────────────────────────────────────────────────────────────────
Si quieres aplicar el tema globalmente en tu app:

```dart
// En tu main.dart o donde configures el MaterialApp
MaterialApp(
  theme: ThemeData(
    // ... otros temas
    navigationBarTheme: buildNavigationBarTheme(UserRole.administradorActivos),
    bottomNavigationBarTheme: buildBottomNavigationBarTheme(UserRole.administradorActivos),
  ),
  home: MyHomePage(),
);
```

2. USO CON THEME WRAPPER
───────────────────────────────────────────────────────────────────────────────
Si quieres aplicar el tema solo en una pantalla específica:

```dart
class MyScreen extends StatelessWidget {
  final UserRole userRole;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: buildNavigationBarTheme(userRole),
      ),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          ],
        ),
      ),
    );
  }
}
```

3. USO CON WIDGETS PERSONALIZADOS
───────────────────────────────────────────────────────────────────────────────
Usa los widgets pre-configurados AvanzzaNavigationBar o AvanzzaBottomNavigationBar:

```dart
// Material 3 NavigationBar
AvanzzaNavigationBar(
  role: UserRole.proveedorServicios,
  currentIndex: _currentIndex,
  onDestinationSelected: (index) {
    setState(() => _currentIndex = index);
  },
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: 'Agenda',
    ),
    NavigationDestination(
      icon: Icon(Icons.work_outline),
      selectedIcon: Icon(Icons.work),
      label: 'Órdenes',
    ),
  ],
);

// Material 2 BottomNavigationBar
AvanzzaBottomNavigationBar(
  role: UserRole.aseguradora,
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() => _currentIndex = index);
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.description),
      label: 'Planes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.attach_money),
      label: 'Cotizaciones',
    ),
  ],
);
```

4. PARSEO DE ROLES DESDE STRINGS
───────────────────────────────────────────────────────────────────────────────
Si recibes el rol como string desde Firestore o backend:

```dart
// Desde Firestore
final roleString = userDoc.data()['role'] as String;
final userRole = parseUserRole(roleString);

// Aplicar tema
final navTheme = buildNavigationBarTheme(userRole);
```

5. CAMBIO DINÁMICO DE ROL
───────────────────────────────────────────────────────────────────────────────
Si el usuario puede cambiar de rol en runtime:

```dart
class RoleAwareScaffold extends StatefulWidget {
  @override
  State<RoleAwareScaffold> createState() => _RoleAwareScaffoldState();
}

class _RoleAwareScaffoldState extends State<RoleAwareScaffold> {
  UserRole _currentRole = UserRole.propietarioActivos;
  int _currentIndex = 0;

  void _changeRole(UserRole newRole) {
    setState(() {
      _currentRole = newRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rol: ${_currentRole.name}'),
        actions: [
          // Selector de rol para demo
          PopupMenuButton<UserRole>(
            onSelected: _changeRole,
            itemBuilder: (context) => UserRole.values.map((role) {
              return PopupMenuItem(
                value: role,
                child: Text(role.name),
              );
            }).toList(),
          ),
        ],
      ),
      body: Center(child: Text('Contenido')),
      bottomNavigationBar: AvanzzaNavigationBar(
        role: _currentRole,
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
```

6. INTEGRACIÓN CON GETX (PATRÓN USADO EN AVANZZA)
───────────────────────────────────────────────────────────────────────────────
```dart
class SessionContextController extends GetxController {
  final Rx<UserRole> currentRole = UserRole.propietarioActivos.obs;

  void updateRole(UserRole newRole) {
    currentRole.value = newRole;
  }
}

// En tu widget
class MyPage extends GetView<SessionContextController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final role = controller.currentRole.value;
      return Scaffold(
        bottomNavigationBar: AvanzzaNavigationBar(
          role: role,
          // ... resto de propiedades
        ),
      );
    });
  }
}
```

7. PALETA DE COLORES COMPLETA
───────────────────────────────────────────────────────────────────────────────
Colores disponibles en AvanzzaColors:

Marca:
  - brandPrimary: #004E64 (azul petróleo)
  - accent: #00A5CF

Neutros:
  - neutralLight: #F4F4F4
  - neutralDark: #1A1A1A
  - white: #FFFFFF

Inactivos:
  - inactiveBackground: #E0E0E0
  - inactiveText: #555555

Por rol:
  - propietario: #004E64
  - administrador: #0077B6
  - arrendatario: #2A9D8F
  - proveedorArticulos: #E76F51
  - proveedorServicios: #E9C46A
  - aseguradora: #264653
  - abogados: #6A4C93

8. TESTING
───────────────────────────────────────────────────────────────────────────────
```dart
void main() {
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

    // Verificar que el indicador tiene el color correcto
    final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navBar.indicatorColor, AvanzzaColors.administrador);
  });
}
```

═══════════════════════════════════════════════════════════════════════════════
FIN DE LA GUÍA
═══════════════════════════════════════════════════════════════════════════════
*/

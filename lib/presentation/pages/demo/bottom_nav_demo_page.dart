// import 'package:flutter/material.dart';
// import '../../../core/theme/bottom_nav_theme.dart';

// /// Página de demostración del sistema de theming de Bottom Navigation Bar
// /// por rol de usuario en Avanzza 2.0.
// ///
// /// Esta página muestra:
// /// - Selector de rol dinámico
// /// - NavigationBar (Material 3) con burbuja activa
// /// - BottomNavigationBar (Material 2) con colores por rol
// /// - Visualización de la paleta de colores
// class BottomNavDemoPage extends StatefulWidget {
//   const BottomNavDemoPage({super.key});

//   @override
//   State<BottomNavDemoPage> createState() => _BottomNavDemoPageState();
// }

// class _BottomNavDemoPageState extends State<BottomNavDemoPage> {
//   // Rol actualmente seleccionado
//   UserRole _currentRole = UserRole.propietarioActivos;

//   // Índice para NavigationBar (M3)
//   int _navBarIndex = 0;

//   // Índice para BottomNavigationBar (M2)
//   int _bottomNavBarIndex = 0;

//   // Tipo de navigation bar a mostrar
//   _NavType _navType = _NavType.navigationBar;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bottom Nav Theme Demo'),
//         centerTitle: true,
//         backgroundColor: AvanzzaColors.brandPrimary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Header
//             _buildHeader(),
//             const SizedBox(height: 24),

//             // Selector de rol
//             _buildRoleSelector(),
//             const SizedBox(height: 24),

//             // Selector de tipo de navigation bar
//             _buildNavTypeSelector(),
//             const SizedBox(height: 24),

//             // Información del rol actual
//             _buildRoleInfo(),
//             const SizedBox(height: 24),

//             // Preview de colores
//             _buildColorPreview(),
//             const SizedBox(height: 24),

//             // Instrucciones
//             _buildInstructions(),

//             // Espaciado para el bottom navigation bar
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigation(),
//     );
//   }

//   /// Construye el header de la página
//   Widget _buildHeader() {
//     return Card(
//       color: AvanzzaColors.brandPrimary,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Icon(
//               Icons.palette,
//               size: 48,
//               color: Colors.white,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Sistema de Theming por Rol',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Avanzza 2.0',
//               style: TextStyle(
//                 color: Colors.white.withValues(alpha: 0.8),
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construye el selector de roles
//   Widget _buildRoleSelector() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.person, color: AvanzzaColors.brandPrimary),
//                 SizedBox(width: 8),
//                 Text(
//                   'Seleccionar Rol',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: UserRole.values.map((role) {
//                 final isSelected = role == _currentRole;
//                 final color = roleColorMap[role]!;

//                 return ChoiceChip(
//                   label: Text(_getRoleDisplayName(role)),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     if (selected) {
//                       setState(() {
//                         _currentRole = role;
//                       });
//                     }
//                   },
//                   selectedColor: color,
//                   labelStyle: TextStyle(
//                     color: isSelected ? Colors.white : AvanzzaColors.neutralDark,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construye el selector de tipo de navigation bar
//   Widget _buildNavTypeSelector() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.navigation, color: AvanzzaColors.brandPrimary),
//                 SizedBox(width: 8),
//                 Text(
//                   'Tipo de Navigation Bar',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             SegmentedButton<_NavType>(
//               segments: const [
//                 ButtonSegment(
//                   value: _NavType.navigationBar,
//                   label: Text('M3 NavigationBar'),
//                   icon: Icon(Icons.radio_button_checked),
//                 ),
//                 ButtonSegment(
//                   value: _NavType.bottomNavigationBar,
//                   label: Text('M2 BottomNavBar'),
//                   icon: Icon(Icons.radio_button_unchecked),
//                 ),
//               ],
//               selected: {_navType},
//               onSelectionChanged: (Set<_NavType> newSelection) {
//                 setState(() {
//                   _navType = newSelection.first;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construye la información del rol actual
//   Widget _buildRoleInfo() {
//     final color = roleColorMap[_currentRole]!;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Rol Activo',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.person,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _getRoleDisplayName(_currentRole),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Color: ${_colorToHex(color)}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construye el preview de la paleta de colores
//   Widget _buildColorPreview() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.color_lens, color: AvanzzaColors.brandPrimary),
//                 SizedBox(width: 8),
//                 Text(
//                   'Paleta Avanzza 2.0',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildColorRow('Marca Principal', AvanzzaColors.brandPrimary),
//             _buildColorRow('Acento', AvanzzaColors.accent),
//             const Divider(height: 24),
//             _buildColorRow('Neutro Claro', AvanzzaColors.neutralLight),
//             _buildColorRow('Neutro Oscuro', AvanzzaColors.neutralDark),
//             const Divider(height: 24),
//             _buildColorRow('Inactivo (Fondo)', AvanzzaColors.inactiveBackground),
//             _buildColorRow('Inactivo (Texto)', AvanzzaColors.inactiveText),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construye una fila de color en el preview
//   Widget _buildColorRow(String label, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//           Text(
//             _colorToHex(color),
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontFamily: 'monospace',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Construye las instrucciones
//   Widget _buildInstructions() {
//     return Card(
//       color: AvanzzaColors.accent.withValues(alpha: 0.1),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.info_outline, color: AvanzzaColors.accent),
//                 SizedBox(width: 8),
//                 Text(
//                   'Cómo usar',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             _buildInstruction('1', 'Selecciona un rol para ver su color específico'),
//             _buildInstruction('2', 'Elige el tipo de navigation bar (M3 o M2)'),
//             _buildInstruction('3', 'Observa el color de la burbuja activa cambiar'),
//             _buildInstruction('4', 'Los items inactivos siempre usan gris neutro'),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Construye una instrucción individual
//   Widget _buildInstruction(String number, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 24,
//             height: 24,
//             decoration: const BoxDecoration(
//               color: AvanzzaColors.accent,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 number,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Construye el bottom navigation según el tipo seleccionado
//   Widget _buildBottomNavigation() {
//     if (_navType == _NavType.navigationBar) {
//       return AvanzzaNavigationBar(
//         role: _currentRole,
//         currentIndex: _navBarIndex,
//         onDestinationSelected: (index) {
//           setState(() {
//             _navBarIndex = index;
//           });
//         },
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home),
//             label: 'Inicio',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.search_outlined),
//             selectedIcon: Icon(Icons.search),
//             label: 'Buscar',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.work_outline),
//             selectedIcon: Icon(Icons.work),
//             label: 'Trabajo',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person),
//             label: 'Perfil',
//           ),
//         ],
//       );
//     } else {
//       return AvanzzaBottomNavigationBar(
//         role: _currentRole,
//         currentIndex: _bottomNavBarIndex,
//         onTap: (index) {
//           setState(() {
//             _bottomNavBarIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Inicio',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Buscar',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.work),
//             label: 'Trabajo',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Perfil',
//           ),
//         ],
//       );
//     }
//   }

//   /// Obtiene el nombre de display del rol
//   String _getRoleDisplayName(UserRole role) {
//     switch (role) {
//       case UserRole.propietarioActivos:
//         return 'Propietario';
//       case UserRole.administradorActivos:
//         return 'Administrador';
//       case UserRole.arrendatarioActivos:
//         return 'Arrendatario';
//       case UserRole.proveedorArticulos:
//         return 'Prov. Artículos';
//       case UserRole.proveedorServicios:
//         return 'Prov. Servicios';
//       case UserRole.aseguradora:
//         return 'Aseguradora';
//       case UserRole.abogados:
//         return 'Abogados';
//     }
//   }

//   /// Convierte un color a formato hexadecimal
//   String _colorToHex(Color color) {
//     final argb = color.toARGB32();
//     return '#${argb.toRadixString(16).substring(2).toUpperCase()}';
//   }
// }

// /// Tipo de navigation bar
// enum _NavType {
//   navigationBar,
//   bottomNavigationBar,
// }

/// lib/presentation/pages/admin/orders_and_quotation/widgets/shared/format_helpers.dart
///
/// Utilidades compartidas de formateo para pedidos y cotizaciones:
/// - fmt: formatea números con separador de miles
/// - fmtDateTime: formatea fechas y horas
/// - assetKindCode: obtiene código de tipo de activo
/// - openAddressPicker: abre selector de dirección (placeholder)

import 'package:get/get.dart';

/// Formatea un número entero con separador de miles (,)
/// Ejemplo: 1980000 → "1,980,000"
String fmt(int v) {
  final s = v.toString();
  final re = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return s.replaceAllMapped(re, (m) => ',');
}

/// Formatea DateTime a string "yyyy-MM-dd HH:mm"
/// Ejemplo: 2025-10-23 16:19
String fmtDateTime(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  final y = dt.year, mo = two(dt.month), d = two(dt.day);
  final h = two(dt.hour), mi = two(dt.minute);
  return '$y-$mo-$d $h:$mi';
}

/// Obtiene el código de tipo de activo para series
/// Vehículo → V, Inmueble → I, Equipos construcción → EC, etc.
String assetKindCode(String type) {
  final t = type.toLowerCase().trim();
  if (t.startsWith('veh')) return 'V';
  if (t.startsWith('inm')) return 'I';
  if (t.contains('constr')) return 'EC';
  if (t.contains('ofic')) return 'EO';
  if (t.contains('otros equip')) return 'OE';
  if (t.contains('otros act')) return 'OA';
  return 'X';
}

/// Abre selector de dirección (placeholder)
void openAddressPicker({required String initial}) {
  Get.snackbar('Dirección actual', initial);
}

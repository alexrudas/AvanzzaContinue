// ============================================================================
// lib/presentation/widgets/asset/vehicle_detail_row.dart
// VEHICLE DETAIL ROW — Fila label/valor para detalle vehicular
//
// QUÉ HACE:
// - Renderiza una fila con label a la izquierda y valor a la derecha.
// - Si value es null o vacío, no renderiza nada (SizedBox.shrink).
// - Mantiene tipografía consistente con textTheme del tema activo.
//
// QUÉ NO HACE:
// - No modifica ni transforma datos.
// - No lanza excepciones por valores nulos.
// - No tiene lógica de negocio.
//
// PRINCIPIOS:
// - StatelessWidget puro: sin estado ni side-effects.
// - Usa exclusivamente Theme.of(context) para colores y estilos.
// - Oculta filas vacías para evitar espacio muerto visual.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): componente base del Vehicle Detail System.
// Reutilizable como bloque atómico en VehicleDetailSection y futuros
// módulos de detalle (RealEstateDetailSection, MachineryDetailSection, etc.).
// ============================================================================

import 'package:flutter/material.dart';

/// Fila de dato vehicular con label fija izquierda y valor alineado a la derecha.
///
/// Se oculta automáticamente si [value] es null o está vacío.
/// Usar dentro de [VehicleDetailSection] o cualquier sección de detalle tipado.
class VehicleDetailRow extends StatelessWidget {
  /// Etiqueta descriptiva del campo (ej: "Placa", "Marca", "Año").
  final String label;

  /// Valor a mostrar. Si es null o vacío, el widget no se renderiza.
  final String? value;

  const VehicleDetailRow({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Ocultar filas sin dato para evitar espacios muertos.
    if (value == null || value!.trim().isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label: ancho fijo 110px → columna izquierda alineada verticalmente.
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Valor: expandido, alineado a la derecha, peso visual mayor.
          Expanded(
            child: Text(
              value!.trim(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

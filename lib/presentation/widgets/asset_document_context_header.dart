// lib/presentation/widgets/asset_document_context_header.dart
// ============================================================================
// ASSET DOCUMENT CONTEXT HEADER — Header de contexto del activo en pages de
// detalle documental (RTM, SOAT, RC, Estado jurídico).
//
// QUÉ HACE:
// - Muestra placa (primaryLabel), marca+modelo+año (secondaryLabel) y nombre
//   de sección (sectionTitle) debajo del AppBar.
// - Expone buildVehicleSecondaryLabel() como helper puro reutilizable para
//   construir el label secundario desde campos ya en memoria.
//
// QUÉ NO HACE:
// - No accede a repositorios ni servicios.
// - No hace fetch.
// - No tiene lógica de negocio.
//
// PRINCIPIOS:
// - Theme-only: cero colores hardcodeados.
// - Sin Card, sin íconos, sin Container decorativo.
// - secondaryLabel condicional: no se renderiza si es null o vacío.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Header de contexto para páginas de detalle documental.
// Fuente de datos: AssetVehiculoEntity campos ya en memoria (sin fetch).
// ============================================================================

import 'package:flutter/material.dart';

/// Construye el label secundario vehicular desde campos ya en memoria.
///
/// No accede a repositorios ni servicios — operación pura sobre strings.
///
/// Ejemplo: buildVehicleSecondaryLabel('HYUNDAI', 'GRAND I10 GLS', 2018)
///          → 'HYUNDAI GRAND I10 GLS - 2018'
///
/// Retorna null si marca y modelo están vacíos.
String? buildVehicleSecondaryLabel(String marca, String modelo, int anio) {
  final parts = <String>[
    if (marca.trim().isNotEmpty) marca.trim(),
    if (modelo.trim().isNotEmpty) modelo.trim(),
  ];
  if (parts.isEmpty) return null;
  return '${parts.join(' ')} - $anio';
}

/// Header de contexto del activo para páginas de detalle documental.
///
/// Muestra:
///   1. [primaryLabel] — placa del vehículo
///   2. [secondaryLabel] — "MARCA MODELO - AÑO" (omitido si null/vacío)
///   3. [sectionTitle] — nombre de la sección ("SOAT", "RTM", etc.)
///
/// Usado en: RtmDetailPage, SoatDetailPage, SegurosRcDetailPage,
///           JuridicalStatusDetailPage.
class AssetDocumentContextHeader extends StatelessWidget {
  final String primaryLabel;
  final String? secondaryLabel;
  final String sectionTitle;

  const AssetDocumentContextHeader({
    super.key,
    required this.primaryLabel,
    this.secondaryLabel,
    required this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            primaryLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (secondaryLabel != null && secondaryLabel!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              secondaryLabel!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            sectionTitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

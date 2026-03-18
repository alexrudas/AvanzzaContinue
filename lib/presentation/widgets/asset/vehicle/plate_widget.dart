// ============================================================================
// lib/presentation/widgets/asset/vehicle/plate_widget.dart
// PLATE WIDGET — Widget público reutilizable de placa vehicular
//
// QUÉ HACE:
// - Renderiza la placa de un vehículo con color semántico según tipo de servicio
//   y clase de vehículo (moto, remolque, diplomático, público, particular).
// - Aplica formato "XXX - XXX" a placas estándar de 6 caracteres.
// - Exporta PlateWidget como widget público reutilizable.
//
// QUÉ NO HACE:
// - No modifica ni persiste datos del vehículo.
// - No conoce controladores ni repositorios.
//
// PRINCIPIOS:
// - StatelessWidget puro: sin estado, sin side-effects.
// - Toda la lógica de color está encapsulada en _getPlateStyle() (privado).
// - Reutilizable desde cualquier parte del proyecto.
//
// ENTERPRISE NOTES:
// EXTRAÍDO (2026-03): era `_PlateWidget` privado en runt_query_result_page.dart.
// Convertido en widget público para habilitar reutilización en
// PortfolioAssetListPage, AssetListPage y futuras vistas de detalle.
// ============================================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PLATE STYLE — Lógica centralizada de color semántico de placa
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado de [_getPlateStyle]: los tres colores que componen la placa.
class _PlateStyle {
  final Color background;
  final Color text;
  final Color border;

  const _PlateStyle({
    required this.background,
    required this.text,
    required this.border,
  });
}

/// Normaliza un string para comparación tolerante a acentos y mayúsculas.
/// Convierte a minúsculas, elimina espacios extremos y reemplaza vocales acentuadas.
String _normalize(String? value) {
  if (value == null) return '';
  return value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .trim();
}

/// Determina el estilo de placa según tipo de servicio y tipo de vehículo.
///
/// PRIORIDAD:
///   1. Si [vehicleType] contiene "moto" → placa amarilla siempre.
///      En Colombia las motocicletas tienen placa amarilla independientemente
///      del tipo de servicio (particular o público).
///   2. Si no → regla por [serviceType]:
///      • remolque / semiremolque → verde
///      • diplomático             → azul oscuro
///      • público                 → blanco
///      • particular / cualquier  → amarillo (fallback seguro)
///
/// Comparación: trim + lowercase para tolerar variaciones del backend.
_PlateStyle _getPlateStyle(String? serviceType, String? vehicleType) {
  final typeNorm = _normalize(vehicleType);
  final serviceNorm = _normalize(serviceType);

  // ── Excepción: Motocicleta ──────────────────────────────────────────────
  // Las motos son SIEMPRE amarillas en Colombia, sin excepción por servicio.
  if (typeNorm.contains('moto')) {
    return const _PlateStyle(
      background: Color(0xFFFDD835),
      text: Colors.black,
      border: Colors.black,
    );
  }

  // ── Remolque / Semiremolque (verde) ─────────────────────────────────────
  // Puede venir en serviceType o vehicleType según el backend.
  if (serviceNorm.contains('remolque') ||
      serviceNorm.contains('semiremolque') ||
      typeNorm.contains('remolque') ||
      typeNorm.contains('semiremolque')) {
    return const _PlateStyle(
      background: Color(0xFF2E7D32),
      text: Colors.white,
      border: Color(0xFF1B5E20),
    );
  }

  // ── Diplomático (azul oscuro) ────────────────────────────────────────────
  if (serviceNorm.contains('diplomat')) {
    return const _PlateStyle(
      background: Color(0xFF003087),
      text: Colors.white,
      border: Color(0xFF001A4D),
    );
  }

  // ── Público (blanco) ─────────────────────────────────────────────────────
  if (serviceNorm.contains('public')) {
    return const _PlateStyle(
      background: Colors.white,
      text: Colors.black,
      border: Colors.black,
    );
  }

  // ── Particular (amarillo) ────────────────────────────────────────────────
  if (serviceNorm.contains('particular')) {
    return const _PlateStyle(
      background: Color(0xFFFDD835),
      text: Colors.black,
      border: Colors.black,
    );
  }

  // ── Fallback seguro (amarillo) ────────────────────────────────────────────
  return const _PlateStyle(
    background: Color(0xFFFDD835),
    text: Colors.black,
    border: Colors.black,
  );
}

/// Formatea la placa para visualización: 6 caracteres → "XXX - XXX".
///
/// Elimina espacios y guiones existentes antes de aplicar el formato.
/// Si la placa tiene longitud distinta de 6, se muestra tal cual.
///
/// Ejemplos:
///   HXP334 → HXP - 334
///   COZ92E → COZ - 92E
///   WPV580 → WPV - 580
String _formatPlateForDisplay(String plate) {
  // Normalizar: quitar espacios y guiones internos, todo uppercase.
  final clean = plate.trim().replaceAll(RegExp(r'[\s\-]+'), '').toUpperCase();
  if (clean.length == 6) {
    return '${clean.substring(0, 3)} - ${clean.substring(3)}';
  }
  // Placas no estándar (7 chars, parciales, etc.) se muestran sin modificar.
  return clean;
}

// ─────────────────────────────────────────────────────────────────────────────
// PLATE WIDGET — Widget dedicado de placa con color semántico y formato
// ─────────────────────────────────────────────────────────────────────────────

/// Widget de placa estilizado para la UI de Avanzza.
///
/// Responsabilidades:
///   • Aplicar color semántico vía [_getPlateStyle] (moto > servicio > fallback).
///   • Aplicar formato "XXX - XXX" vía [_formatPlateForDisplay].
///   • No intenta replicar la placa física — representación limpia y consistente.
class PlateWidget extends StatelessWidget {
  /// Placa en formato interno (sin separadores), ej: "HXP334".
  final String plate;

  /// Tipo de servicio del vehículo (Público / Particular / Diplomático / etc.).
  /// Determina el color de fondo cuando no es motocicleta.
  final String? serviceType;

  /// Clase o tipo del vehículo. Usada para detectar motocicletas.
  /// En Colombia las motos tienen placa amarilla independiente del servicio.
  final String? vehicleType;

  const PlateWidget({
    super.key,
    required this.plate,
    this.serviceType,
    this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular estilo siguiendo la prioridad: moto > servicio > fallback.
    final style = _getPlateStyle(serviceType, vehicleType);
    // Aplicar formato de visualización "XXX - XXX" para placas de 6 caracteres.
    final displayPlate = _formatPlateForDisplay(plate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(10),
        // style.border adapta el contraste al fondo semántico.
        border: Border.all(color: style.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        displayPlate,
        style: TextStyle(
          // style.text garantiza legibilidad sobre cualquier fondo semántico.
          color: style.text,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 4,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

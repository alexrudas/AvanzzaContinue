// ============================================================================
// lib/presentation/pages/asset/asset_rtm_helpers.dart
// ASSET RTM HELPERS — Resolución RTM para páginas de activos
//
// QUÉ HACE:
// - Encapsula el pipeline completo de resolución RTM desde runtMetaJson:
//     runtMetaJson (String?) → JSON decode → 'runt_rtm' (List) →
//     normalización de registros → VehicleDocumentStatusResolver.resolveRtm()
//     → VehicleDocumentStatus?
// - Actúa como adaptador entre dos formatos de persistencia RTM y el resolver
//   de dominio existente:
//     • Legado: claves snake_case + fechas DD/MM/YYYY (RuntRtmRecord.toJson())
//     • Nuevo:  claves camelCase + fechas ISO YYYY-MM-DD (wizard async backend)
// - Usada por AssetDetailPage y RtmDetailPage para evitar duplicar esta lógica.
//
// QUÉ NO HACE:
// - No accede a repositorios ni a Isar/Firebase.
// - No resuelve SOAT, RC ni otros documentos (solo RTM en esta fase).
// - No importa nada de la capa de presentación (solo dominio y dart:convert).
// - No modifica VehicleDocumentStatusResolver.resolveRtm() ni el dominio.
//
// PRINCIPIOS:
// - Función pura: sin side effects, sin estado.
// - Null-safe por diseño: returns null ante cualquier dato ausente o inválido.
// - Reutilizable: cualquier widget en lib/presentation/pages/asset/ puede importarlo.
// - Dual-format: normaliza ambos formatos al contrato del resolver antes de delegarle.
//
// ENTERPRISE NOTES:
// CREADO   (2026-03): RTM v1 — punto único de parsing RTM en presentation.
// ADAPTADO (2026-03): Normalización dual-format añadida tras detectar que el
//   wizard async persiste camelCase + ISO (YYYY-MM-DD) mientras el resolver
//   del dominio espera snake_case + DD/MM/YYYY. Fix contenido íntegramente
//   en este helper; resolveRtm() y el dominio permanecen sin cambios.
// ============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/vehicle/vehicle_document_status.dart';

/// Parsea el estado RTM más reciente desde el campo [runtMetaJson] de
/// [AssetVehiculoEntity].
///
/// Pipeline:
/// 1. Decodifica [runtMetaJson] como `Map<String, dynamic>`.
/// 2. Extrae la lista `runt_rtm`.
/// 3. Normaliza cada registro al formato esperado por
///    [VehicleDocumentStatusResolver.resolveRtm] (ver [_normalizeRtmRecord]).
/// 4. Llama [VehicleDocumentStatusResolver.resolveRtm], que toma el registro
///    con `fecha_vigencia` más reciente y calcula `daysToExpire`.
///
/// Soporta dos formatos de origen:
/// - **Legado**: claves snake_case + fechas `DD/MM/YYYY`.
/// - **Nuevo** (wizard async): claves camelCase + fechas ISO `YYYY-MM-DD`.
///
/// Returns null si:
/// - [runtMetaJson] es null o vacío.
/// - El JSON es inválido o no contiene la clave `runt_rtm`.
/// - La lista está vacía o no contiene Maps válidos.
VehicleDocumentStatus? parseRtmFromMetaJson(String? runtMetaJson) {
  if (runtMetaJson == null || runtMetaJson.trim().isEmpty) return null;
  try {
    final decoded = jsonDecode(runtMetaJson) as Map<String, dynamic>;
    final rtmList = decoded['runt_rtm'];
    if (rtmList is! List) return null;

    // Normalizar cada registro al formato snake_case + DD/MM/YYYY que espera
    // VehicleDocumentStatusResolver.resolveRtm(). Soporta legado y nuevo formato.
    final normalized = rtmList
        .whereType<Map<String, dynamic>>()
        .map(_normalizeRtmRecord)
        .toList();

    return VehicleDocumentStatusResolver.resolveRtm(normalized);
  } catch (e) {
    if (kDebugMode) {
      debugPrint('[RTM_HELPERS][parseRtmFromMetaJson] Error al parsear '
          'runtMetaJson: $e');
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ADAPTADOR DE FORMATO — uso exclusivo de parseRtmFromMetaJson
// ─────────────────────────────────────────────────────────────────────────────

/// Normaliza un registro RTM crudo al formato que espera
/// [VehicleDocumentStatusResolver.resolveRtm]:
/// claves snake_case y fechas en `DD/MM/YYYY`.
///
/// **Formato legado** (RuntRtmRecord.toJson()):
/// `fecha_vigencia`, `fecha_expedicion`, `nro_certificado`, `cda_expide_rtm`
/// con fechas ya en `DD/MM/YYYY` — pasan sin cambio.
///
/// **Formato nuevo** (wizard async — payload crudo del backend):
/// `fechaVigencia`, `fechaExpedicion`, `numeroCertificado`, `cdaExpide`
/// con fechas en ISO `YYYY-MM-DD` — se mapean y convierten.
///
/// Regla de precedencia: si la clave destino snake_case ya existe en el registro
/// (formato legado), no se sobreescribe.
Map<String, dynamic> _normalizeRtmRecord(Map<String, dynamic> raw) {
  final out = Map<String, dynamic>.from(raw);

  // Escribe la clave snake_case si aún no existe pero sí la camelCase.
  void adopt(String camel, String snake) {
    if (!out.containsKey(snake) && out.containsKey(camel)) {
      out[snake] = out[camel];
    }
  }

  adopt('fechaVigencia', 'fecha_vigencia');
  adopt('fechaExpedicion', 'fecha_expedicion');
  adopt('numeroCertificado', 'nro_certificado');
  adopt('cdaExpide', 'cda_expide_rtm');

  // Convierte fechas ISO → DD/MM/YYYY en todas las claves que resolveRtm() lee.
  // Si ya son DD/MM/YYYY (legado), _isoToRuntDate las retorna intactas.
  for (final key in const ['fecha_vigencia', 'fecha_expedicion', 'fecha_expedici_n']) {
    final val = out[key];
    if (val is String && val.isNotEmpty) {
      out[key] = _isoToRuntDate(val);
    }
  }

  return out;
}

/// Convierte una fecha ISO `YYYY-MM-DD` al formato RUNT `DD/MM/YYYY`.
///
/// Si la cadena ya contiene `/` asume formato legado y la retorna sin cambio.
/// Si el formato no es reconocible, retorna la cadena original para que
/// `_parseRuntDate` del resolver la rechace de forma controlada (sin excepción).
String _isoToRuntDate(String dateStr) {
  // Ya es DD/MM/YYYY u otro formato con separador '/'.
  if (dateStr.contains('/')) return dateStr;

  // ISO YYYY-MM-DD → DD/MM/YYYY.
  final parts = dateStr.split('-');
  if (parts.length == 3 && parts[0].length == 4) {
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  // Formato desconocido: retornar sin cambio; el resolver lo descartará.
  return dateStr;
}

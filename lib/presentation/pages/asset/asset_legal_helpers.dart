// ============================================================================
// lib/presentation/pages/asset/asset_legal_helpers.dart
// ASSET LEGAL HELPERS — Parsing de datos jurídicos desde runtMetaJson
//
// QUÉ HACE:
// - Parsea los datos de Estado Jurídico almacenados en AssetVehiculoEntity:
//     runtMetaJson (String?) → 'runt_limitations' → List<LimitationItem>
//     runtMetaJson (String?) → 'runt_warranties'  → List<WarrantyItem>
//     propertyLiens (String?)                      → texto contextual de gravámenes
// - Devuelve LegalStatusData con contrato estable (nunca null) para la UI.
// - Usada por AssetDetailPage (tile) y JuridicalStatusDetailPage (detail).
//
// QUÉ NO HACE:
// - No accede a repositorios ni a Isar/Firebase.
// - No importa nada de la capa de presentación (solo dart:convert + foundation).
// - No parsea fechas a DateTime: las fechas jurídicas del RUNT se conservan
//   como String? porque este helper es parsing estructural, no normalización
//   temporal. El consumidor decide si necesita parsear la fecha.
// - No normaliza ni suprime el texto de propertyLiens: el valor fuente del
//   RUNT se conserva íntegramente en propertyLiensText. La interpretación de
//   novedad (ej. "NO REGISTRA" = sin gravamen) vive en getters derivados.
//
// PRINCIPIOS:
// - Función pura: sin side effects, sin estado.
// - Contrato estable: parseLegalDataFromMetaJson() retorna SIEMPRE
//   LegalStatusData, nunca null. Usa LegalStatusData.empty si no hay datos.
// - Null-safe y type-safe: falla silenciosamente ante datos inválidos.
// - Claves JSON — DOS paths posibles (prioridad camelCase async → snake legacy):
//     runt_limitations items:
//       'tipoLimitacion'          | 'tipo_de_limitaci_n'              → String?
//       'numeroOficio'            | 'n_mero_de_oficio'                → int?  (NO fecha)
//       'entidadJuridica'         | 'entidad_jur_dica'                → String?
//       'departamento'            (igual en ambos paths)              → String?
//       'municipio'               (igual en ambos paths)              → String?
//       'fechaExpedicionOficio'   | 'fecha_de_expedici_n_del_oficio'  → String? (no DateTime)
//       'fechaRegistro'           | 'fecha_de_registro_en_el_sistema' → String? (no DateTime)
//     runt_warranties items:
//       'identificacionAcreedor'  | 'identificaci_n_acreedor'         → String?
//       'acreedor'                (igual en ambos paths)              → String?
//       'fechaInscripcion'        | 'fecha_de_inscripci_n'            → String? (no DateTime)
//       'patrimonioAutonomo'      | 'patrimonio_aut_nomo'             → String?
//       'confecamaras'            | 'confec_maras'                    → String?
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Track B1 — Estado Jurídico. Primera implementación.
//   Cachear resultado en _AssetDetailPageState._legalData (setState).
//   Nunca llamar parseLegalDataFromMetaJson() desde build().
//
// ACTUALIZACIÓN (2026-03): Fix de claves de parsing.
//   El sistema de consulta asíncrona (RuntQueryController / runt_query_result_page)
//   almacena los ítems con claves camelCase extraídas directamente del backend:
//     runt_limitations: tipoLimitacion, entidadJuridica, fechaExpedicionOficio,
//                       fechaRegistro, departamento, municipio
//     runt_warranties:  acreedor, identificacionAcreedor, fechaInscripcion,
//                       patrimonioAutonomo, confecamaras
//   Las claves snake_case (_$RuntOwnershipLimitationToJson) solo aplican cuando
//   el dato pasa por el typed model; en el path async van como raw Maps.
//   _strKey() prioriza camelCase y cae al snake_case como fallback legacy.
// ============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// VALUE OBJECTS — Resultado del parsing
// ─────────────────────────────────────────────────────────────────────────────

/// Limitación a la propiedad individual parseada desde runt_limitations.
///
/// Todos los campos son nullable: el RUNT puede omitir cualquiera.
/// Las fechas se conservan como String? fuente del RUNT — no se parsean
/// a DateTime en este helper (parsing estructural, no normalización temporal).
/// [officeNumber] es int? porque el backend lo almacena vía IntFlexibleConverter
/// — NO es una fecha.
///
/// Contenido jurídicamente útil: [hasContent] es true solo cuando hay campos
/// de identidad semántica ([limitationType], [legalEntity], [officeIssueDate],
/// [systemRegistrationDate]). [officeNumber] solo no cuenta como contenido útil.
class LimitationItem {
  /// Tipo de limitación ("Embargo", "Prenda", etc.)
  /// wire async: 'tipoLimitacion' | wire legacy: 'tipo_de_limitaci_n'
  final String? limitationType;

  /// Número de oficio (int?, NO fecha)
  /// wire async: 'numeroOficio' | wire legacy: 'n_mero_de_oficio'
  final int? officeNumber;

  /// Entidad jurídica que impone la limitación.
  /// wire async: 'entidadJuridica' | wire legacy: 'entidad_jur_dica'
  final String? legalEntity;

  /// Departamento — wire: 'departamento' (mismo en ambos paths)
  final String? department;

  /// Municipio — wire: 'municipio' (mismo en ambos paths)
  final String? municipality;

  /// Fecha de expedición del oficio (String fuente RUNT, no DateTime).
  /// wire async: 'fechaExpedicionOficio' | wire legacy: 'fecha_de_expedici_n_del_oficio'
  final String? officeIssueDate;

  /// Fecha de registro en el sistema (String fuente RUNT, no DateTime).
  /// wire async: 'fechaRegistro' | wire legacy: 'fecha_de_registro_en_el_sistema'
  final String? systemRegistrationDate;

  const LimitationItem({
    this.limitationType,
    this.officeNumber,
    this.legalEntity,
    this.department,
    this.municipality,
    this.officeIssueDate,
    this.systemRegistrationDate,
  });

  /// True si este ítem tiene contenido jurídicamente semántico.
  ///
  /// [officeNumber] solo NO activa hasContent — es un campo técnico-registral.
  /// Requiere al menos uno de: tipo, entidad, fecha de expedición o fecha de registro.
  bool get hasContent =>
      limitationType != null ||
      legalEntity != null ||
      officeIssueDate != null ||
      systemRegistrationDate != null;

  /// Fecha principal de referencia para mostrar en UI.
  ///
  /// Prioridad 1: systemRegistrationDate (fecha más reciente en el sistema).
  /// Prioridad 2: officeIssueDate (fecha del documento original).
  /// String fuente del RUNT — no se parsea a DateTime.
  String? get primaryDate => systemRegistrationDate ?? officeIssueDate;
}

/// Garantía / gravamen individual parseada desde runt_warranties.
///
/// Todos los campos son nullable. Las fechas son String? fuente del RUNT.
class WarrantyItem {
  /// Identificación del acreedor.
  /// wire async: 'identificacionAcreedor' | wire legacy: 'identificaci_n_acreedor'
  final String? creditorId;

  /// Nombre del acreedor — wire: 'acreedor' (mismo en ambos paths)
  final String? creditorName;

  /// Fecha de inscripción (String fuente RUNT, no DateTime).
  /// wire async: 'fechaInscripcion' | wire legacy: 'fecha_de_inscripci_n'
  final String? registrationDate;

  /// Patrimonio autónomo.
  /// wire async: 'patrimonioAutonomo' | wire legacy: 'patrimonio_aut_nomo'
  final String? autonomousPatrimony;

  /// Confecámaras.
  /// wire async: 'confecamaras' | wire legacy: 'confec_maras'
  final String? confecamaras;

  const WarrantyItem({
    this.creditorId,
    this.creditorName,
    this.registrationDate,
    this.autonomousPatrimony,
    this.confecamaras,
  });

  /// True si este ítem tiene al menos un campo con contenido útil.
  bool get hasContent =>
      creditorName != null ||
      creditorId != null ||
      registrationDate != null;
}

/// Resultado consolidado del parsing jurídico de un activo.
///
/// Contrato estable: siempre disponible (nunca null), usando [LegalStatusData.empty]
/// cuando no hay datos. La UI no necesita null-checks adicionales.
///
/// [propertyLiensText] conserva el texto fuente del RUNT sin modificación.
/// La interpretación de novedad ("NO REGISTRA" = sin gravamen) se delega
/// a [hasPropertyLiensNovelties] — la semántica del dato no se suprime.
class LegalStatusData {
  /// Limitaciones a la propiedad parseadas desde runtMetaJson['runt_limitations'].
  /// Lista vacía si no hay datos o si la clave no existe.
  final List<LimitationItem> limitations;

  /// Garantías y gravámenes parseados desde runtMetaJson['runt_warranties'].
  /// Lista vacía si no hay datos o si la clave no existe.
  final List<WarrantyItem> warranties;

  /// Texto fuente de gravámenes desde AssetVehiculoEntity.propertyLiens.
  /// Se conserva íntegramente del RUNT — null si el campo no está disponible o vacío.
  /// Ejemplos: "NO REGISTRA", "PRENDA A FAVOR DE BANCO X", "EMBARGO JUDICIAL".
  final String? propertyLiensText;

  const LegalStatusData({
    required this.limitations,
    required this.warranties,
    this.propertyLiensText,
  });

  /// Estado vacío: sin datos jurídicos de ningún tipo.
  static const empty = LegalStatusData(limitations: [], warranties: []);

  // ── Getters de conteo ─────────────────────────────────────────────────────

  /// Número de limitaciones con contenido jurídicamente útil.
  int get totalLimitations => limitations.where((l) => l.hasContent).length;

  /// Número de garantías con contenido útil.
  int get totalWarranties => warranties.where((w) => w.hasContent).length;

  /// Total de novedades con contenido útil (limitaciones + garantías).
  /// No incluye propertyLiens — ese es texto contextual, no un conteo registral.
  int get totalNovelties => totalLimitations + totalWarranties;

  // ── Getters de presencia de novedades ─────────────────────────────────────

  /// True si existe al menos una limitación con contenido jurídico útil.
  bool get hasLimitations => totalLimitations > 0;

  /// True si existe al menos una garantía con contenido útil.
  bool get hasWarranties => totalWarranties > 0;

  /// True si propertyLiensText indica una novedad real (no vacío ni "NO REGISTRA").
  ///
  /// El texto "NO REGISTRA" es el valor canónico del RUNT para ausencia de gravámenes.
  /// Se conserva en [propertyLiensText] para fidelidad de datos, pero no se considera
  /// una novedad jurídica — por eso este getter lo excluye.
  bool get hasPropertyLiensNovelties {
    if (propertyLiensText == null) return false;
    final upper = propertyLiensText!.trim().toUpperCase();
    return upper.isNotEmpty && upper != 'NO REGISTRA';
  }

  /// True si existe alguna novedad jurídica de cualquier tipo.
  bool get hasAnyLegalNovelty =>
      hasLimitations || hasWarranties || hasPropertyLiensNovelties;
}

// ─────────────────────────────────────────────────────────────────────────────
// FUNCIÓN DE PARSING — Punto de entrada público
// ─────────────────────────────────────────────────────────────────────────────

/// Parsea los datos de Estado Jurídico desde [runtMetaJson] y [propertyLiens].
///
/// Siempre retorna [LegalStatusData] (nunca null). Retorna [LegalStatusData.empty]
/// si [runtMetaJson] es inválido o vacío y [propertyLiens] es null/vacío.
///
/// IMPORTANTE: Llamar UNA SOLA VEZ y cachear en el state del widget
/// (_AssetDetailPageState._legalData). NO llamar desde build().
///
/// Pipeline:
/// 1. Decodifica [runtMetaJson] como Map (defensivo ante Map<dynamic,dynamic>).
/// 2. Extrae 'runt_limitations' → List → parsea → filtra por [LimitationItem.hasContent].
/// 3. Extrae 'runt_warranties'  → List → parsea → filtra por [WarrantyItem.hasContent].
/// 4. Conserva [propertyLiens] en propertyLiensText sin modificación (null si vacío).
/// 5. Retorna [LegalStatusData] con las tres fuentes.
LegalStatusData parseLegalDataFromMetaJson(
  String? runtMetaJson, {
  String? propertyLiens,
}) {
  List<LimitationItem> limitations = [];
  List<WarrantyItem> warranties = [];

  if (runtMetaJson != null && runtMetaJson.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(runtMetaJson);
      if (decoded is Map) {
        final safeDecoded = Map<String, dynamic>.from(decoded);
        limitations = _parseLimitations(safeDecoded);
        warranties = _parseWarranties(safeDecoded);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[LEGAL_HELPERS][parseLegalDataFromMetaJson] '
            'Error al decodificar runtMetaJson: $e');
      }
      // Falla silenciosamente: limitations y warranties quedan vacías.
    }
  }

  // Normalizar propertyLiens: null si vacío (pero NO si es "NO REGISTRA" —
  // ese texto tiene semántica propia y se conserva en propertyLiensText).
  final normalizedLiens = propertyLiens?.trim();
  final liensFinal =
      (normalizedLiens == null || normalizedLiens.isEmpty) ? null : normalizedLiens;

  return LegalStatusData(
    limitations: limitations,
    warranties: warranties,
    propertyLiensText: liensFinal,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// PARSERS PRIVADOS
// ─────────────────────────────────────────────────────────────────────────────

/// Parsea 'runt_limitations' del JSON decodificado.
///
/// Claves exactas verificadas en _$RuntOwnershipLimitationToJson (.g.dart).
/// Cast defensivo Map<dynamic,dynamic> → Map<String,dynamic> vía from().
/// Filtra ítems sin contenido jurídicamente útil ([LimitationItem.hasContent]).
List<LimitationItem> _parseLimitations(Map<String, dynamic> decoded) {
  final raw = decoded['runt_limitations'];
  if (raw is! List) return [];

  final result = <LimitationItem>[];
  for (final entry in raw) {
    if (entry is! Map) continue;
    final m = Map<String, dynamic>.from(entry);

    // int? — IntFlexibleConverter puede entregar int, String numérico o null.
    // NO es una fecha. officeNumber solo no basta para declarar contenido útil.
    // Prioriza clave camelCase del path async; cae a snake_case legacy si ausente.
    final officeNumberRaw = m['numeroOficio'] ?? m['n_mero_de_oficio'];
    final int? officeNumber = switch (officeNumberRaw) {
      int v => v,
      String s => int.tryParse(s),
      _ => null,
    };

    final item = LimitationItem(
      // camelCase (path async) → snake_case encoded (path typed model legacy)
      limitationType: _strKey(m, ['tipoLimitacion', 'tipo_de_limitaci_n', 'tipo_de_limitacion']),
      officeNumber: officeNumber,
      legalEntity: _strKey(m, ['entidadJuridica', 'entidad_jur_dica', 'entidad_juridica']),
      department: _str(m['departamento']),
      municipality: _str(m['municipio']),
      officeIssueDate: _strKey(m, ['fechaExpedicionOficio', 'fecha_de_expedici_n_del_oficio']),
      systemRegistrationDate: _strKey(m, ['fechaRegistro', 'fecha_de_registro_en_el_sistema']),
    );

    if (item.hasContent) result.add(item);
  }

  if (kDebugMode && raw.isNotEmpty && result.isEmpty) {
    debugPrint('[LEGAL_HELPERS][_parseLimitations] '
        '${raw.length} entradas en runt_limitations, '
        'ninguna con contenido jurídico útil. Verificar claves JSON del RUNT.');
  }

  return result;
}

/// Parsea 'runt_warranties' del JSON decodificado.
///
/// Claves exactas verificadas en _$RuntWarrantyToJson (.g.dart).
/// Cast defensivo Map<dynamic,dynamic> → Map<String,dynamic> vía from().
/// Filtra ítems sin contenido útil ([WarrantyItem.hasContent]).
List<WarrantyItem> _parseWarranties(Map<String, dynamic> decoded) {
  final raw = decoded['runt_warranties'];
  if (raw is! List) return [];

  final result = <WarrantyItem>[];
  for (final entry in raw) {
    if (entry is! Map) continue;
    final m = Map<String, dynamic>.from(entry);

    final item = WarrantyItem(
      // camelCase (path async) → snake_case encoded (path typed model legacy)
      creditorId: _strKey(m, ['identificacionAcreedor', 'identificaci_n_acreedor']),
      creditorName: _str(m['acreedor']),
      registrationDate: _strKey(m, ['fechaInscripcion', 'fecha_de_inscripci_n']),
      autonomousPatrimony: _strKey(m, ['patrimonioAutonomo', 'patrimonio_aut_nomo']),
      confecamaras: _strKey(m, ['confecamaras', 'confec_maras']),
    );

    if (item.hasContent) result.add(item);
  }

  if (kDebugMode && raw.isNotEmpty && result.isEmpty) {
    debugPrint('[LEGAL_HELPERS][_parseWarranties] '
        '${raw.length} entradas en runt_warranties, '
        'ninguna con contenido útil. Verificar claves JSON del RUNT.');
  }

  return result;
}

// ─────────────────────────────────────────────────────────────────────────────
// UTILIDADES PRIVADAS
// ─────────────────────────────────────────────────────────────────────────────

/// Extrae String? de un valor dinámico: retorna null si es nulo o vacío.
String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

/// Busca el primer valor no nulo y no vacío entre [keys] en [m].
///
/// Protege contra encoding inconsistente del RUNT: itera las claves en orden
/// y retorna el primer valor útil. Trim aplicado. Retorna null si ninguno es válido.
/// Usar SOLO en campos críticos donde se conoce el riesgo de clave alternativa.
String? _strKey(Map<String, dynamic> m, List<String> keys) {
  for (final key in keys) {
    final v = _str(m[key]);
    if (v != null) return v;
  }
  return null;
}

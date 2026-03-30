// ============================================================================
// lib/data/sync/domains/compliance_label_resolver.dart
// COMPLIANCE LABEL RESOLVER — Única fuente de verdad para labels humanos
//
// QUÉ HACE:
// - Resuelve el label UX de un complianceType (wire string) → String legible.
// - Provee el catálogo cerrado de labels de cumplimiento/documento/póliza.
// - Soporta crecimiento a otros tipos de activo sin modificar el motor
//   de prioridad.
//
// QUÉ NO HACE:
// - No accede a Isar ni Firestore.
// - No aplica lógica de negocio (solo resolución de texto).
// - No contiene i18n; labels en español LatAm.
// - No define tipos de asset; solo complianceType.
//
// PRINCIPIOS:
// - Catálogo CERRADO: agregar nuevos tipos aquí y en ningún otro lugar.
// - PROHIBIDO hardcodear labels en UI, builders, dispatcher o cualquier
//   otro archivo.
// - Fallback seguro: complianceType no reconocido → "Documento".
// - Función pura: mismo input → mismo output siempre.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Asset Schema v1.3.4.
// SCOPE DE USO: exclusivamente en asset_priority_engine.dart (_buildReasonHuman).
// ============================================================================

/// Resuelve el label UX de un wire string de tipo de cumplimiento.
///
/// Catálogo cerrado — actualizar aquí cuando se agreguen nuevos tipos.
/// Uso exclusivo dentro de AssetPriorityEngine.
abstract final class ComplianceLabelResolver {
  // --------------------------------------------------------------------------
  // CATÁLOGO CERRADO
  // --------------------------------------------------------------------------

  static const Map<String, String> _all = {
    // Vehículos
    'soat': 'SOAT',
    'rc_contractual': 'RC Contractual',
    'rc_extracontractual': 'RC Extracontractual',
    'todo_riesgo': 'Todo Riesgo',
    'rtm': 'Revisión técnica',

    // Inmuebles
    'fire_insurance': 'Seguro contra incendio',
    'flood_insurance': 'Seguro contra inundación',

    // Agregar aquí nuevos complianceType reales del sistema.
  };

  // --------------------------------------------------------------------------
  // API PÚBLICA
  // --------------------------------------------------------------------------

  /// Retorna el label UX para [complianceType].
  ///
  /// Reglas:
  /// - Input: wire string (ej. 'soat', 'rtm', 'fire_insurance').
  /// - Case-insensitive.
  /// - Tolerante a espacios en blanco al inicio/fin.
  /// - Fallback: 'Documento' para tipos no reconocidos.
  static String resolve(String complianceType) =>
      _all[complianceType.trim().toLowerCase()] ?? 'Documento';
}

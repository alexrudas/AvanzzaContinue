// ============================================================================
// lib/domain/entities/alerts/alert_code.dart
// ALERT CODE — Discriminador canónico wire-stable de tipos de alerta
//
// QUÉ HACE:
// - Define AlertCode, el enum wire-stable que identifica unívocamente el tipo
//   de señal dentro del sistema canónico.
// - Expone wireName (valor de red estable) y fromWire() para serialización.
//
// QUÉ NO HACE:
// - No importa Flutter, GetX ni nada de infraestructura.
// - No define severidad, alcance ni política de promoción (son enums separados).
// - No contiene lógica de evaluación (esa vive en los evaluadores).
// - No define reglas de negocio sobre qué servicios requieren qué pólizas.
//
// PRINCIPIOS:
// - Wire-stability obligatoria: NO cambiar wireName sin migración de datos.
// - fromWire() retorna null ante wire values no reconocidos. El caller decide
//   cómo manejar el null — no asumir un tipo desconocido.
// - Tolerancia a espacios y mayúsculas en fromWire(): robustez defensiva,
//   no contrato. Los wire values canónicos son siempre snake_case minúsculas.
// - Los valores reservados no deben usarse en evaluadores V1; cualquier
//   activación requiere actualizar el contrato arquitectónico primero.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Discriminador canónico v1.
// ACTUALIZADO (2026-03): Agregados rcContractualMissing y rcExtracontractualMissing.
// ACTUALIZADO (2026-03): V5 — Agregado rcExtracontractualOpportunity.
// ============================================================================

/// Código canónico de una señal del sistema de alertas de Avanzza.
///
/// Wire-stable: el [wireName] NO debe cambiar sin migración.
/// Para construir desde red/almacenamiento: [AlertCode.fromWire].
enum AlertCode {
  // ── V1 — Asset compliance ──────────────────────────────────────────────────

  /// SOAT vencido.
  soatExpired,

  /// SOAT próximo a vencer.
  soatDueSoon,

  /// Revisión técnico-mecánica (RTM) vencida.
  rtmExpired,

  /// RTM próxima a vencer.
  rtmDueSoon,

  /// RTM exenta por periodo de gracia (vehículo nuevo).
  rtmExempt,

  /// Póliza RC Contractual vencida.
  rcContractualExpired,

  /// Póliza RC Contractual próxima a vencer.
  rcContractualDueSoon,

  /// Póliza RC Contractual ausente (no existe ninguna póliza registrada).
  rcContractualMissing,

  /// Póliza RC Extracontractual vencida.
  rcExtracontractualExpired,

  /// Póliza RC Extracontractual próxima a vencer.
  rcExtracontractualDueSoon,

  /// Póliza RC Extracontractual ausente.
  rcExtracontractualMissing,

  /// Ausencia de RC Extracontractual — señal comercial (no incumplimiento).
  rcExtracontractualOpportunity,

  /// Limitación jurídica activa (embargo, prenda, etc.).
  legalLimitationActive,

  /// Embargo activo registrado en RUNT.
  embargoActive,

  // ── Reservados — SIN pipeline en V1 ───────────────────────────────────────

  /// Multas SIMIT activas. Reservado para Fase 6+.
  simitFineActive,

  /// Mantenimiento vencido/pendiente. Reservado para Fase 6+.
  maintenanceOverdue,

  /// Cartera contable vencida. Reservado para Fase 6+.
  accountsPayableOverdue,

  /// Orden de compra bloqueada. Reservado para Fase 6+.
  purchaseOrderBlocked;

  // ---------------------------------------------------------------------------
  // WIRE MAP
  // ---------------------------------------------------------------------------

  static const Map<String, AlertCode> _byWire = {
    'soat_expired': AlertCode.soatExpired,
    'soat_due_soon': AlertCode.soatDueSoon,
    'rtm_expired': AlertCode.rtmExpired,
    'rtm_due_soon': AlertCode.rtmDueSoon,
    'rtm_exempt': AlertCode.rtmExempt,
    'rc_contractual_expired': AlertCode.rcContractualExpired,
    'rc_contractual_due_soon': AlertCode.rcContractualDueSoon,
    'rc_contractual_missing': AlertCode.rcContractualMissing,
    'rc_extracontractual_expired': AlertCode.rcExtracontractualExpired,
    'rc_extracontractual_due_soon': AlertCode.rcExtracontractualDueSoon,
    'rc_extracontractual_missing': AlertCode.rcExtracontractualMissing,
    'rc_extracontractual_opportunity': AlertCode.rcExtracontractualOpportunity,
    'legal_limitation_active': AlertCode.legalLimitationActive,
    'embargo_active': AlertCode.embargoActive,
    'simit_fine_active': AlertCode.simitFineActive,
    'maintenance_overdue': AlertCode.maintenanceOverdue,
    'accounts_payable_overdue': AlertCode.accountsPayableOverdue,
    'purchase_order_blocked': AlertCode.purchaseOrderBlocked,
  };

  /// Construye el enum desde su wire value. Retorna null si no se reconoce.
  ///
  /// Aplica trim() + toLowerCase() — defensivo ante espacios y variaciones
  /// de capitalización en datos fuente. Los productores canónicos siempre
  /// emiten snake_case minúsculas.
  static AlertCode? fromWire(String? value) =>
      _byWire[value?.trim().toLowerCase()];

  /// Wire value estable de esta señal.
  ///
  /// NO cambiar sin migración de datos (wire-stability).
  String get wireName => switch (this) {
        AlertCode.soatExpired => 'soat_expired',
        AlertCode.soatDueSoon => 'soat_due_soon',
        AlertCode.rtmExpired => 'rtm_expired',
        AlertCode.rtmDueSoon => 'rtm_due_soon',
        AlertCode.rtmExempt => 'rtm_exempt',
        AlertCode.rcContractualExpired => 'rc_contractual_expired',
        AlertCode.rcContractualDueSoon => 'rc_contractual_due_soon',
        AlertCode.rcContractualMissing => 'rc_contractual_missing',
        AlertCode.rcExtracontractualExpired => 'rc_extracontractual_expired',
        AlertCode.rcExtracontractualDueSoon => 'rc_extracontractual_due_soon',
        AlertCode.rcExtracontractualMissing => 'rc_extracontractual_missing',
        AlertCode.rcExtracontractualOpportunity =>
          'rc_extracontractual_opportunity',
        AlertCode.legalLimitationActive => 'legal_limitation_active',
        AlertCode.embargoActive => 'embargo_active',
        AlertCode.simitFineActive => 'simit_fine_active',
        AlertCode.maintenanceOverdue => 'maintenance_overdue',
        AlertCode.accountsPayableOverdue => 'accounts_payable_overdue',
        AlertCode.purchaseOrderBlocked => 'purchase_order_blocked',
      };
}

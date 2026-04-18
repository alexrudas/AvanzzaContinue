// ============================================================================
// lib/presentation/alerts/mappers/alert_impact_mapper.dart
// ALERT IMPACT MAPPER — Textos de impacto operativo/legal por AlertCode
//
// QUÉ HACE:
// - Resuelve el texto de impacto (consecuencia real) para cada AlertCode.
// - Consumido exclusivamente por FleetAlertDetailPage (Nivel 3).
//
// QUÉ NO HACE:
// - No depende de package:flutter (Dart puro).
// - No contiene lógica de evaluación ni de negocio.
// - No decide si mostrar el texto — el widget decide si renderizar la sección.
//
// PRINCIPIOS:
// - Función estática pura: sin estado, sin side effects.
// - V1: textos en español directo.
//   En V2+: reemplazar por keys de i18n y resolver desde sistema real.
// - Ningún texto de impacto vive hardcodeado en widgets — siempre pasar por aquí.
// - Retorna null para códigos sin impacto definido en V1 (reservados/exentos).
//   El widget omite la sección si el resultado es null.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import '../../../domain/entities/alerts/alert_code.dart';

abstract final class AlertImpactMapper {
  AlertImpactMapper._();

  /// Texto de impacto operativo/legal para [code].
  ///
  /// Describe la consecuencia real de la alerta para el operador.
  /// Null para códigos sin impacto definido en V1 (rtmExempt, reservados).
  /// El widget omite la sección de impacto si retorna null.
  static String? resolveImpactBody(AlertCode code) => switch (code) {
        // ── SOAT ──────────────────────────────────────────────────────────
        AlertCode.soatExpired =>
          'Riesgo de inmovilización inmediata. Sin SOAT no hay cobertura '
          'de atención médica para víctimas en accidentes.',

        AlertCode.soatDueSoon =>
          'En riesgo de quedar sin cobertura. Renovar antes del vencimiento '
          'evita sanciones y períodos sin amparo.',

        // ── RTM ───────────────────────────────────────────────────────────
        AlertCode.rtmExpired =>
          'Riesgo de inmovilización por tránsito. '
          'El vehículo no cumple la normativa de seguridad vial vigente.',

        AlertCode.rtmDueSoon =>
          'Próximo a quedar fuera de normativa. '
          'Agendar con anticipación evita la inmovilización.',

        AlertCode.rtmExempt => null, // Exención activa: sin impacto negativo

        // ── RC Contractual ────────────────────────────────────────────────
        AlertCode.rcContractualExpired =>
          'Sin cobertura para pasajeros. Obligatoria para transporte público '
          '— su ausencia puede generar sanciones graves.',

        AlertCode.rcContractualDueSoon =>
          'Cobertura de pasajeros próxima a vencer. '
          'Renovar antes evita períodos sin amparo.',

        AlertCode.rcContractualMissing =>
          'Sin cobertura para pasajeros a bordo. '
          'Póliza obligatoria para transporte público no registrada.',

        // ── RC Extracontractual ───────────────────────────────────────────
        AlertCode.rcExtracontractualExpired =>
          'Riesgo patrimonial directo. Sin cobertura frente a daños '
          'causados a terceros en accidentes.',

        AlertCode.rcExtracontractualDueSoon =>
          'Cobertura a terceros próxima a vencer. '
          'Renovar evita exposición patrimonial.',

        AlertCode.rcExtracontractualMissing =>
          'Sin cobertura a terceros. Cualquier daño en accidente queda '
          'sin amparo asegurador — riesgo patrimonial directo.',

        AlertCode.rcExtracontractualOpportunity =>
          'Sin cobertura a terceros. Contratarla protege el patrimonio '
          'del operador ante accidentes con daños externos.',

        // ── Legal ─────────────────────────────────────────────────────────
        AlertCode.legalLimitationActive =>
          'Puede bloquear operación o comercialización. '
          'Limitación jurídica activa registrada en RUNT.',

        AlertCode.embargoActive =>
          'Puede derivar en retención del vehículo. '
          'Embargo activo impide transferencia de propiedad.',

        // Códigos reservados para fases futuras — sin impacto definido en V1
        _ => null,
      };
}

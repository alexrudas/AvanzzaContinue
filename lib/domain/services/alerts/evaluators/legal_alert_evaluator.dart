// ============================================================================
// lib/domain/services/alerts/evaluators/legal_alert_evaluator.dart
// LEGAL ALERT EVALUATOR — Evaluador de alertas jurídicas
//
// QUÉ HACE:
// - Genera alertas de tipo legal_limitation_active y embargo_active a partir
//   de los datos jurídicos consolidados en el snapshot.
// - Detecta embargos por texto en propertyLiensText (contiene "EMBARGO").
// - Genera legal_limitation_active si existen limitaciones jurídicas activas.
// - Retorna lista vacía si no hay novedades jurídicas.
//
// QUÉ NO HACE:
// - NO importa Flutter, GetX ni infraestructura.
// - NO accede a repositorios — recibe el snapshot ya construido.
// - NO parsea runtMetaJson directamente (ya viene resuelto en el snapshot).
//
// PRINCIPIOS:
// - Función pura: sin estado, sin side effects.
// - Las alertas jurídicas siempre son severity critical — acción inmediata.
// - Umbral de días no aplica: las alertas jurídicas no tienen "due soon".
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Evaluador Legal v1. Ver ALERTS_SYSTEM_V4.md §4.
// ============================================================================

import 'package:uuid/uuid.dart';

import '../../../entities/alerts/alert_audience.dart';
import '../../../entities/alerts/alert_code.dart';
import '../../../entities/alerts/alert_evidence_keys.dart';
import '../../../entities/alerts/alert_fact_keys.dart';
import '../../../entities/alerts/alert_promotion_policy.dart';
import '../../../entities/alerts/alert_scope.dart';
import '../../../entities/alerts/alert_severity.dart';
import '../../../entities/alerts/domain_alert.dart';
import '../asset_alert_snapshot.dart';

/// Genera alertas jurídicas para el activo descrito en [snapshot].
///
/// Retorna hasta 2 alertas: embargo_active y/o legal_limitation_active.
/// Retorna lista vacía si no hay novedades jurídicas.
List<DomainAlert> buildLegalAlerts(AssetAlertSnapshot snapshot) {
  final alerts = <DomainAlert>[];

  // Detectar embargo: propertyLiensText contiene "EMBARGO" (insensible a mayúsculas)
  final hasEmbargo = _detectsEmbargo(snapshot.propertyLiensText);
  if (hasEmbargo) {
    alerts.add(_buildAlert(
      snapshot: snapshot,
      code: AlertCode.embargoActive,
      // Tipo normalizado canónico para embargo_active: siempre "Embargo".
      // No se usa el texto crudo de propertyLiensText — ese es el origen
      // de la detección, no el tipo del hecho jurídico.
      // Contrasta con legal_limitation_active, que usa primaryLimitationType
      // del RUNT (valor crudo del campo runt_limitations).
      legalRestrictionType: 'Embargo',
      legalEntity: null,
    ));
  }

  // Detectar limitaciones jurídicas (embargo, prenda, etc.) desde runt_limitations
  if (snapshot.hasLegalLimitations) {
    // Solo generar si no es ya un embargo (evitar doble alerta por el mismo hecho)
    final legalType = snapshot.primaryLimitationType ?? 'Limitación';
    final isEmbargoPrincipal = legalType.toUpperCase().contains('EMBARGO');

    if (!hasEmbargo || !isEmbargoPrincipal) {
      alerts.add(_buildAlert(
        snapshot: snapshot,
        code: AlertCode.legalLimitationActive,
        legalRestrictionType: legalType,
        legalEntity: snapshot.primaryLegalEntity,
      ));
    }
  }

  return alerts;
}

// ─────────────────────────────────────────────────────────────────────────────
// BUILDER INTERNO
// ─────────────────────────────────────────────────────────────────────────────

DomainAlert _buildAlert({
  required AssetAlertSnapshot snapshot,
  required AlertCode code,
  required String legalRestrictionType,
  String? legalEntity,
}) {
  // primaryEvidenceId: alerta jurídica no tiene PK de documento propio —
  // se usa assetId (mismo valor que evidenceRefs[0][AlertEvidenceKeys.sourceId])
  final dedupeKey =
      '${code.wireName}:${AlertScope.asset.wireName}:${snapshot.assetId}:${snapshot.assetId}';

  return DomainAlert(
    id: const Uuid().v4(),
    code: code,
    severity: AlertSeverity.critical, // Alertas jurídicas siempre critical
    scope: AlertScope.asset,
    audience: AlertAudience.assetAdmin,
    promotionPolicy: AlertPromotionPolicy.alwaysPromote,
    sourceEntityId: snapshot.assetId,
    titleKey: 'alerts.${code.wireName}.title',
    bodyKey: 'alerts.${code.wireName}.body',
    facts: {
      AlertFactKeys.legalRestrictionType: legalRestrictionType,
      if (legalEntity != null) AlertFactKeys.sourceName: legalEntity,
      // Identidad del activo — snapshot del evaluador (mismo objeto que evaluación).
      AlertFactKeys.assetPrimaryLabel: snapshot.assetPrimaryLabel,
      if (snapshot.assetSecondaryLabel != null)
        AlertFactKeys.assetSecondaryLabel: snapshot.assetSecondaryLabel,
      if (snapshot.assetType != null)
        AlertFactKeys.assetType: snapshot.assetType,
    },
    evidenceRefs: [
      {
        AlertEvidenceKeys.sourceType: 'legal_record',
        AlertEvidenceKeys.sourceId: snapshot.assetId,
        // En V1 los datos jurídicos (runt_limitations, propertyLiens) viven
        // embebidos en el documento del activo en Firestore — no hay colección
        // legal separada. 'assets' es la colección Firestore real de la fuente.
        AlertEvidenceKeys.sourceCollection: 'assets',
        AlertEvidenceKeys.documentId: snapshot.assetId,
      }
    ],
    detectedAt: DateTime.now().toUtc(),
    sourceUpdatedAt: snapshot.sourceUpdatedAt,
    dedupeKey: dedupeKey,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// DETECCIÓN DE EMBARGO
// ─────────────────────────────────────────────────────────────────────────────

/// True si [propertyLiensText] indica un embargo real.
///
/// Excluye null, texto vacío y el valor centinela "NO REGISTRA" del RUNT.
///
/// HEURÍSTICA V1: usa `contains('EMBARGO')` sobre el texto en mayúsculas.
/// Limitación conocida: no distingue negaciones textuales tipo
/// "NO REGISTRA EMBARGO" o "NO EXISTE EMBARGO" si el RUNT las emite como valor.
/// El assembler normaliza "NO REGISTRA" exacto a null, pero variantes con sufijo
/// pueden pasar. Si el RUNT introduce esas variantes, este método requiere
/// un parser más robusto (V2+).
bool _detectsEmbargo(String? propertyLiensText) {
  if (propertyLiensText == null) return false;
  final upper = propertyLiensText.trim().toUpperCase();
  if (upper.isEmpty || upper == 'NO REGISTRA') return false;
  return upper.contains('EMBARGO');
}

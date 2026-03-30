// ============================================================================
// lib/domain/entities/alerts/domain_alert.dart
// DOMAIN ALERT — Contrato canónico único del sistema de alertas
//
// QUÉ HACE:
// - Define DomainAlert: entidad inmutable (freezed) que representa una alerta
//   dentro del sistema canónico de Avanzza 2.0.
// - Es el único contrato válido para transportar alertas entre capas.
// - Expone dedupeKey como campo explícito calculado al construir la alerta.
//
// QUÉ NO HACE:
// - NO usa IconData, Color, Widget, BuildContext ni package:flutter.
// - NO contiene strings renderizados finales — solo keys de i18n (titleKey, bodyKey).
// - NO persiste en Isar en V1 (cálculo on-read).
// - NO implementa lógica de evaluación ni de promoción.
//
// PRINCIPIOS:
// - Dominio puro: sin dependencias de infraestructura ni de UI.
// - isActive siempre true en V1 (alertas calculadas on-read, nunca persistidas).
//   El campo existe para compatibilidad futura (V2 con persistencia).
// - dedupeKey = "{code.wireName}:{scope.wireName}:{sourceEntityId}:{primaryEvidenceId}"
//   Separador `:`. Ambos, code y scope, usan su wireName por consistencia.
//   primaryEvidenceId = evidenceRefs[0][AlertEvidenceKeys.sourceId].
//   (Ver ALERTS_SYSTEM_V4.md §12.1 y §19 regla 12)
// - facts y evidenceRefs usan keys canónicas de AlertFactKeys / AlertEvidenceKeys.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — Contrato canónico v1.
// ACTUALIZADO (2026-03): V5 — Campo alertKind añadido con default compliance.
//   Retrocompatible: evaluators existentes no necesitan cambios.
//   Ver ALERTS_SYSTEM_V5.md §3.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import 'alert_audience.dart';
import 'alert_code.dart';
import 'alert_kind.dart';
import 'alert_promotion_policy.dart';
import 'alert_scope.dart';
import 'alert_severity.dart';

part 'domain_alert.freezed.dart';

/// Alerta canónica del sistema de Avanzza 2.0.
///
/// Construida exclusivamente por evaluadores/adapters del pipeline canónico.
/// Consumida por la presentation layer vía DomainAlertMapper → AlertCardVm.
///
/// Restricciones de dominio:
/// - NO depende de `package:flutter`.
/// - titleKey / bodyKey son keys de i18n, nunca strings renderizados.
/// - facts y evidenceRefs usan keys de [AlertFactKeys] / [AlertEvidenceKeys].
@freezed
abstract class DomainAlert with _$DomainAlert {
  const factory DomainAlert({
    /// UUID único de esta alerta.
    required String id,

    /// Código canónico wire-stable que identifica el tipo de alerta.
    required AlertCode code,

    /// Nivel de urgencia.
    required AlertSeverity severity,

    /// Naturaleza semántica de la señal.
    ///
    /// Determina conteo en métricas, elegibilidad para Home y rendering.
    /// Default [AlertKind.compliance] — retrocompatible con V1.
    @Default(AlertKind.compliance) AlertKind alertKind,

    /// Dominio operativo de origen.
    required AlertScope scope,

    /// Rol objetivo. En V1 siempre [AlertAudience.assetAdmin].
    required AlertAudience audience,

    /// Política de visibilidad en Home.
    required AlertPromotionPolicy promotionPolicy,

    /// ID del activo u entidad que originó la alerta.
    required String sourceEntityId,

    /// Key i18n del título de la alerta (NO el string final).
    required String titleKey,

    /// Key i18n del cuerpo/descripción de la alerta (NO el string final).
    required String bodyKey,

    /// Datos contextuales de la alerta.
    ///
    /// REGLAS: las keys deben estar definidas en [AlertFactKeys].
    /// Los productores no pueden inventar keys ad hoc — toda key nueva
    /// requiere agregarla primero en AlertFactKeys.
    /// Los values deben ser serializables y estables (String, num, bool, null).
    /// No insertar objetos arbitrarios ni instancias no serializables.
    @Default({}) Map<String, Object?> facts,

    /// Referencias a la evidencia real que originó la alerta.
    ///
    /// REGLAS: cada entrada usa keys de [AlertEvidenceKeys] exclusivamente:
    /// sourceType, sourceId, sourceCollection, documentId, externalRef.
    /// Los productores no pueden inventar keys fuera de [AlertEvidenceKeys].
    /// Los values deben ser Strings estables o null — no insertar objetos.
    @Default([]) List<Map<String, Object?>> evidenceRefs,

    /// Siempre true en V1 (cálculo on-read).
    ///
    /// Reservado para V2 donde las alertas persistidas podrían
    /// marcarse como inactivas sin eliminarse.
    @Default(true) bool isActive,

    /// Momento en que esta alerta fue calculada/detectada.
    required DateTime detectedAt,

    /// Última actualización de la fuente que originó esta alerta.
    ///
    /// Usado como desempate final en el algoritmo de sort.
    required DateTime sourceUpdatedAt,

    /// Key de deduplicación canónica.
    ///
    /// Formato (V4 §12.1):
    ///   `"{code.wireName}:{scope.wireName}:{sourceEntityId}:{primaryEvidenceId}"`
    ///
    /// Reglas wire-stability:
    /// - `code` → [AlertCode.wireName] (e.g. `"soat_expired"`). NUNCA `.name`.
    /// - `scope` → [AlertScope.wireName] (e.g. `"asset"`). NUNCA `.name`.
    ///   Ambos enums usan wireName por consistencia (V4 §19 regla 12).
    /// - `primaryEvidenceId` → [AlertEvidenceKeys.sourceId] de `evidenceRefs[0]`.
    ///   La mecánica exacta de construcción pertenece al productor, no a esta entidad.
    ///
    /// Calculado por el productor al construir la alerta.
    /// El pipeline de dedupe retiene la de [detectedAt] más reciente
    /// ante duplicados con el mismo dedupeKey.
    required String dedupeKey,
  }) = _DomainAlert;

  // No fromJson/toJson — DomainAlert no se serializa en V1 (on-read).
  // Si V2 requiere persistencia, agregar json_serializable aquí.
}

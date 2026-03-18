// ============================================================================
// lib/core/campaign/resolver/soat_frequency_guard.dart
// SOAT FREQUENCY GUARD — Control de frecuencia específico para campañas SOAT
//
// QUÉ HACE:
// - Determina si una campaña SOAT puede mostrarse según su urgencia.
// - Aplica cooldowns variables sobre lastShownAt escrito por CampaignFrequencyStore:
//     diasRestantes ≤ 3 o vencido → 24h  (mostrar diario)
//     diasRestantes 4–30          → 48h  (mostrar cada 48h)
// - Complementa CampaignFrequencyStore sin reemplazarlo.
//
// QUÉ NO HACE:
// - No escribe lastShownAt — CampaignFrequencyStore.recordShow() lo hace.
// - No gestiona la regla 1/sesión — eso lo maneja CampaignOrchestrator.
// - No duplica la lógica de CampaignFrequencyStore (maxPerDay, silence).
//
// PRINCIPIOS:
// - Solo lectura de Isar — sin side-effects de escritura.
// - Diseño composable: guard adicional, no reemplazo.
// - La regla de sesión ya existe en CampaignFrequencyStore.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Controla frecuencia de campañas SOAT entre sesiones.
// Cooldowns basados en la urgencia del vencimiento, no en cantidad de shows.
// ============================================================================

import 'package:isar_community/isar.dart';

import '../../../data/sources/local/campaign_frequency_local_ds.dart';

/// Control de frecuencia entre sesiones para campañas SOAT.
///
/// Complementa [CampaignFrequencyStore]:
/// - [CampaignFrequencyStore] maneja 1/sesión y 2/día.
/// - [SoatFrequencyGuard] maneja cooldowns de urgencia entre sesiones.
///
/// Lee [lastShownAt] del [CampaignFrequencyModel] que escribe
/// [CampaignFrequencyStore.recordShow()] — sin duplicar escritura.
///
/// Cooldowns aplicados según [diasRestantes]:
/// - ≤ 3 días o vencido → 24 horas (urgente — mostrar diario)
/// - 4 a 30 días        → 48 horas (preventivo — mostrar cada 48h)
class SoatFrequencyGuard {
  final CampaignFrequencyLocalDataSource _localDs;

  SoatFrequencyGuard(Isar isar)
      : _localDs = CampaignFrequencyLocalDataSource(isar);

  /// Verifica si la campaña SOAT puede mostrarse según la urgencia del vencimiento.
  ///
  /// Retorna `true` si:
  /// - La campaña nunca fue mostrada (sin registro en Isar).
  /// - El cooldown de urgencia ya expiró desde el último show.
  ///
  /// La regla 1/sesión la gestiona [CampaignOrchestrator] — no se verifica aquí.
  Future<bool> canShow(String campaignId, int diasRestantes) async {
    final freq = await _localDs.get(campaignId);

    // Primera vez — sin historial de shows.
    if (freq == null) return true;

    // Verificar si el cooldown de urgencia ha expirado.
    final cooldown = _cooldownFor(diasRestantes);
    final nextEligible = freq.lastShownAt.add(cooldown);
    return DateTime.now().isAfter(nextEligible);
  }

  /// Cooldown apropiado según la urgencia del SOAT.
  ///
  /// Reglas de negocio (alineadas con el spec del Campaign Engine):
  /// - vencido o ≤ 3 días → 24h (diario — alto impacto, acción inmediata)
  /// - 4 a 30 días        → 48h (cada 48h — preventivo)
  Duration _cooldownFor(int diasRestantes) {
    // Corresponde a SoatPriority.critical y parte de high (3 días).
    if (diasRestantes < 0 || diasRestantes <= 3) {
      return const Duration(hours: 24);
    }
    // SoatPriority.high (4-7d), medium, low.
    return const Duration(hours: 48);
  }
}

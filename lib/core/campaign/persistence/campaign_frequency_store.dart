import 'package:isar_community/isar.dart';
import '../../../data/models/campaign/campaign_frequency_model.dart';
import '../../../data/sources/local/campaign_frequency_local_ds.dart';
import '../../config/campaign_config.dart';

/// Store para gestión de reglas de frecuencia de campañas
///
/// Implementa:
/// - 1 campaña por sesión
/// - Máximo 2 campañas por día
/// - Silencio de 24h tras 2 cierres manuales consecutivos
class CampaignFrequencyStore {
  late final CampaignFrequencyLocalDataSource _localDs;

  CampaignFrequencyStore(Isar isar) {
    _localDs = CampaignFrequencyLocalDataSource(isar);
  }

  /// Verifica si la campaña puede mostrarse según reglas de frecuencia
  Future<bool> canShow(String campaignId) async {
    final freq = await _localDs.get(campaignId);
    if (freq == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (freq.sessionShown) return false;

    if (freq.nextEligibleAt != null && now.isBefore(freq.nextEligibleAt!)) {
      return false;
    }

    final lastShownDay = DateTime(
      freq.lastShownAt.year,
      freq.lastShownAt.month,
      freq.lastShownAt.day,
    );

    if (lastShownDay.isBefore(today)) {
      return true;
    }

    if (freq.showsToday >= CampaignFrequencyLimits.maxPerDay) {
      return false;
    }

    return true;
  }

  Future<void> recordShow(String campaignId) async {
    var freq = await _localDs.get(campaignId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (freq == null) {
      freq = CampaignFrequencyModel()
        ..campaignId = campaignId
        ..lastShownAt = now
        ..showsToday = 1
        ..consecutiveManualCloses = 0
        ..sessionShown = true
        ..nextEligibleAt = null;
    } else {
      final lastShownDay = DateTime(
        freq.lastShownAt.year,
        freq.lastShownAt.month,
        freq.lastShownAt.day,
      );

      if (lastShownDay.isBefore(today)) {
        freq.showsToday = 1;
      } else {
        freq.showsToday++;
      }

      freq.lastShownAt = now;
      freq.sessionShown = true;
    }

    await _localDs.save(freq);
  }

  Future<void> recordManualDismiss(String campaignId) async {
    var freq = await _localDs.get(campaignId);
    if (freq == null) return;

    freq.consecutiveManualCloses++;

    if (freq.consecutiveManualCloses >=
        CampaignFrequencyLimits.consecutiveDismissThreshold) {
      freq.nextEligibleAt = DateTime.now().add(
        const Duration(hours: CampaignFrequencyLimits.silenceHoursAfterDismiss),
      );
    }

    await _localDs.save(freq);
  }

  Future<void> recordCtaClick(String campaignId) async {
    var freq = await _localDs.get(campaignId);
    if (freq == null) return;

    freq.consecutiveManualCloses = 0;
    freq.nextEligibleAt = null;

    await _localDs.save(freq);
  }

  Future<void> resetAllSessions() async {
    await _localDs.resetAllSessions();
  }
}

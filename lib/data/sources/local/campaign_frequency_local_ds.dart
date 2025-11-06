import 'package:isar_community/isar.dart';
import '../../models/campaign/campaign_frequency_model.dart';

/// Data source local para gestión de frecuencia de campañas
class CampaignFrequencyLocalDataSource {
  final Isar _isar;

  CampaignFrequencyLocalDataSource(this._isar);

  /// Obtiene el registro de frecuencia de una campaña
  Future<CampaignFrequencyModel?> get(String campaignId) async {
    return await _isar.campaignFrequencyModels
        .filter()
        .campaignIdEqualTo(campaignId)
        .findFirst();
  }

  /// Guarda o actualiza el registro de frecuencia
  Future<void> save(CampaignFrequencyModel model) async {
    await _isar.writeTxn(() async {
      await _isar.campaignFrequencyModels.put(model);
    });
  }

  /// Resetea el flag de sesión de todas las campañas
  /// (llamar al iniciar la app)
  Future<void> resetAllSessions() async {
    await _isar.writeTxn(() async {
      final all = await _isar.campaignFrequencyModels.where().findAll();
      for (var model in all) {
        model.sessionShown = false;
        await _isar.campaignFrequencyModels.put(model);
      }
    });
  }

  /// Elimina todos los registros (solo para testing)
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.campaignFrequencyModels.clear();
    });
  }
}

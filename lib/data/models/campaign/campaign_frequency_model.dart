import 'package:isar_community/isar.dart';

part 'campaign_frequency_model.g.dart';

/// Modelo de persistencia para frecuencia de campañas
///
/// Rastrea cuándo y cuántas veces se ha mostrado una campaña
/// para aplicar reglas de frecuencia (1 por sesión, 2 por día, silencio tras dismisses)
@Collection()
class CampaignFrequencyModel {
  Id id = Isar.autoIncrement;

  /// ID de la campaña (único)
  @Index(unique: true)
  late String campaignId;

  /// Última vez que se mostró la campaña
  late DateTime lastShownAt;

  /// Número de veces mostrada hoy (resetea diariamente)
  late int showsToday;

  /// Cierres manuales consecutivos sin CTA click
  late int consecutiveManualCloses;

  /// Flag de sesión (se resetea en RAM al reiniciar app)
  late bool sessionShown;

  /// Fecha hasta la cual está silenciada (tras 2 cierres manuales consecutivos)
  /// NULL si no está silenciada
  DateTime? nextEligibleAt;

  CampaignFrequencyModel();
}

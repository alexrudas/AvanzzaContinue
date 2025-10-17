import '../campaign/models/campaign_event.dart';

/// Servicio de analítica para eventos de campaña
///
/// Mock inicial que solo imprime en consola.
/// TODO: Integrar con Firebase Analytics o servicio de analítica preferido.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// Registra un evento de campaña
  void logCampaignEvent(CampaignEvent event) {
    print('[Campaign Analytics] ${event.type.name}: ${event.toJson()}');

    // TODO: Integrar con Firebase Analytics
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'campaign_${event.type.name}',
    //   parameters: event.toJson(),
    // );
  }

  /// Registra evento con correlación explícita de duración
  void logWithDuration(CampaignEvent event, Duration duration) {
    final eventWithDuration = CampaignEvent(
      type: event.type,
      campaignId: event.campaignId,
      screenId: event.screenId,
      sessionId: event.sessionId,
      role: event.role,
      cityId: event.cityId,
      durationMs: duration.inMilliseconds,
    );
    logCampaignEvent(eventWithDuration);
  }
}

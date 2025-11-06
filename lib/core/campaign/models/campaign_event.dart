import 'package:uuid/uuid.dart';

/// Tipos de eventos de campaña para analítica
enum CampaignEventType {
  /// Campaña mostrada en full-screen
  view,

  /// Campaña cerrada automáticamente tras timer
  autoClose,

  /// Campaña cerrada manualmente por el usuario
  manualClose,

  /// Mini-card mostrada
  miniView,

  /// Usuario hizo click en mini-card
  miniClick,

  /// Usuario hizo click en CTA
  ctaClick,

  /// Acción downstream tras CTA (ej: completó compra)
  downstreamAction,
}

/// Evento de campaña para tracking de analítica
///
/// Incluye session_id para correlación y duration_ms para métricas de engagement
class CampaignEvent {
  final CampaignEventType type;
  final String campaignId;
  final String screenId;
  final String sessionId;
  final String? role;
  final String? cityId;
  final int? durationMs;
  final DateTime timestamp;

  CampaignEvent({
    required this.type,
    required this.campaignId,
    required this.screenId,
    required this.sessionId,
    this.role,
    this.cityId,
    this.durationMs,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
        'event_type': type.name,
        'campaign_id': campaignId,
        'screen_id': screenId,
        'session_id': sessionId,
        'role': role,
        'city_id': cityId,
        'duration_ms': durationMs,
        'timestamp': timestamp.toIso8601String(),
      };

  @override
  String toString() => 'CampaignEvent(${type.name}, $campaignId, ${durationMs}ms)';
}

/// Generador de session ID único por app launch
///
/// Usado para correlacionar eventos de campaña dentro de una misma sesión
class SessionIdGenerator {
  static final SessionIdGenerator _instance = SessionIdGenerator._internal();
  factory SessionIdGenerator() => _instance;

  SessionIdGenerator._internal() {
    _sessionId = const Uuid().v4();
  }

  late final String _sessionId;

  /// Session ID actual (único por app launch)
  String get current => _sessionId;
}

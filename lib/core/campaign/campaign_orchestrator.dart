import 'package:avanzza/domain/entities/user/active_context.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/session_context_controller.dart';
import '../analytics/analytics_service.dart';
import '../config/campaign_config.dart';
import '../di/container.dart';
import 'models/campaign.dart';
import 'models/campaign_eligibility.dart';
import 'models/campaign_event.dart';
import 'persistence/campaign_frequency_store.dart';
import 'ui/full_screen_campaign_overlay.dart';
import 'ui/mini_card_campaign_overlay.dart';

enum CampaignState { idle, full, mini, dismissed }

class CampaignOrchestrator {
  static final CampaignOrchestrator _instance =
      CampaignOrchestrator._internal();
  factory CampaignOrchestrator() => _instance;
  CampaignOrchestrator._internal();

  late final CampaignFrequencyStore _frequencyStore;
  late final AnalyticsService _analytics;
  late final String _sessionId;

  CampaignState _state = CampaignState.idle;
  OverlayEntry? _currentOverlay;
  Campaign? _currentCampaign;
  String? _currentScreenId;
  DateTime? _showStartTime;

  bool _initialized = false;

  CampaignState get state => _state;

  void init() {
    if (_initialized) return;
    final isar = DIContainer().isar;
    _frequencyStore = CampaignFrequencyStore(isar);
    _analytics = AnalyticsService();
    _sessionId = SessionIdGenerator().current;
    _initialized = true;
  }

  Future<void> showIfEligible(
    BuildContext context, {
    required String screenId,
    Campaign? campaign,
  }) async {
    if (!_initialized) init();

    if (!kCampaignsEnabled) return;
    if (_state != CampaignState.idle) return;
    if (!context.mounted) return;

    campaign ??= await _selectCampaign(screenId);
    if (campaign == null) return;

    final eligible = await _checkEligibility(campaign, screenId);
    if (!eligible) return;

    final canShow = await _frequencyStore.canShow(campaign.id);
    if (!canShow) return;

    await _frequencyStore.recordShow(campaign.id);
    _currentCampaign = campaign;
    _currentScreenId = screenId;
    _showStartTime = DateTime.now();

    await Future.delayed(
        const Duration(milliseconds: CampaignTimings.initialDelayMs));

    if (!context.mounted) return;
    _showFullScreen(context);
  }

  void _showFullScreen(BuildContext context) {
    _state = CampaignState.full;

    _currentOverlay = OverlayEntry(
      builder: (ctx) => FullScreenCampaignOverlay(
        campaign: _currentCampaign!,
        onClose: () => _handleManualClose(ctx),
        onCta: () => _handleCtaClick(ctx),
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
    _logEvent(CampaignEventType.view);

    Future.delayed(
        const Duration(seconds: CampaignTimings.fullScreenDurationSeconds), () {
      if (_state == CampaignState.full && context.mounted) {
        _transitionToMini(context);
      }
    });
  }

  void _transitionToMini(BuildContext context) {
    final duration = _getElapsedDuration();
    _currentOverlay?.remove();
    _currentOverlay = null;
    _state = CampaignState.mini;

    _logEventWithDuration(CampaignEventType.autoClose, duration);

    _currentOverlay = OverlayEntry(
      builder: (ctx) => MiniCardCampaignOverlay(
        campaign: _currentCampaign!,
        onDismiss: () => _handleManualClose(ctx),
        onTap: () => _handleMiniClick(ctx),
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
    _logEventWithDuration(CampaignEventType.miniView, duration);
  }

  void _handleManualClose(BuildContext context) {
    final duration = _getElapsedDuration();
    _logEventWithDuration(CampaignEventType.manualClose, duration);
    _frequencyStore.recordManualDismiss(_currentCampaign!.id);
    dismiss();
  }

  void _handleCtaClick(BuildContext context) {
    final duration = _getElapsedDuration();
    _logEventWithDuration(CampaignEventType.ctaClick, duration);
    _frequencyStore.recordCtaClick(_currentCampaign!.id);
    final route = _currentCampaign!.routeName;
    dismiss();
    if (route != null) {
      Get.toNamed(route);
    }
  }

  void _handleMiniClick(BuildContext context) {
    final duration = _getElapsedDuration();
    _logEventWithDuration(CampaignEventType.miniClick, duration);
    _handleCtaClick(context);
  }

  void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
    _state = CampaignState.idle;
    _currentCampaign = null;
    _currentScreenId = null;
    _showStartTime = null;
  }

  Duration _getElapsedDuration() {
    if (_showStartTime == null) return Duration.zero;
    return DateTime.now().difference(_showStartTime!);
  }

  Future<Campaign?> _selectCampaign(String screenId) async {
    return null;
  }

  Future<bool> _checkEligibility(Campaign campaign, String screenId) async {
    try {
      final session = Get.find<SessionContextController>();
      final ctx = CampaignContext(
        screenId: screenId,
        userId: session.user?.uid,
        orgId: session.user?.activeContext?.orgId,
        role: session.user?.activeContext?.userRole,
        cityId: session.user?.activeContext?.currentCityId,
      );
      return await campaign.eligibilityFn(ctx);
    } catch (e) {
      final ctx = CampaignContext(screenId: screenId);
      return await campaign.eligibilityFn(ctx);
    }
  }

  void _logEvent(CampaignEventType type) {
    _logEventWithDuration(type, null);
  }

  void _logEventWithDuration(CampaignEventType type, Duration? duration) {
    if (_currentCampaign == null || _currentScreenId == null) return;

    String? role;
    String? cityId;

    try {
      final session = Get.find<SessionContextController>();
      role = session.user?.activeContext?.userRole;
      cityId = session.user?.activeContext?.currentCityId;
    } catch (_) {}

    final event = CampaignEvent(
      type: type,
      campaignId: _currentCampaign!.id,
      screenId: _currentScreenId!,
      sessionId: _sessionId,
      role: role,
      cityId: cityId,
      durationMs: duration?.inMilliseconds,
    );

    _analytics.logCampaignEvent(event);
  }
}

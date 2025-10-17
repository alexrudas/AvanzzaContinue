import 'package:flutter/material.dart';
import '../../../core/campaign/campaign_orchestrator.dart';
import '../../../core/campaign/demo/demo_campaigns.dart';
import '../../../core/config/campaign_config.dart';

/// Wrapper widget que activa campañas en cualquier pantalla
///
/// Uso:
/// ```dart
/// return CampaignLauncher(
///   screenId: 'admin_maintenance',
///   enabled: kCampaignsEnabled,
///   child: Scaffold(...),
/// );
/// ```
///
/// Características:
/// - Guard interno anti-doble-disparo (_hookFired)
/// - Compatible con rebuilds de Obx
/// - Respeta kill-switch global
/// - No interfiere con el árbol de widgets hijo
class CampaignLauncher extends StatefulWidget {
  final Widget child;
  final String screenId;
  final bool enabled;

  const CampaignLauncher({
    super.key,
    required this.child,
    required this.screenId,
    this.enabled = kCampaignsEnabled,
  });

  @override
  State<CampaignLauncher> createState() => _CampaignLauncherState();
}

class _CampaignLauncherState extends State<CampaignLauncher> {
  bool _hookFired = false; // Guard anti-doble-disparo

  @override
  void initState() {
    super.initState();
    if (widget.enabled && !_hookFired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_hookFired && mounted) {
          _hookFired = true;
          _launchCampaign();
        }
      });
    }
  }

  void _launchCampaign() {
    final campaign = DemoCampaigns.forScreen(widget.screenId);
    if (campaign != null) {
      CampaignOrchestrator().showIfEligible(
        context,
        screenId: widget.screenId,
        campaign: campaign,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

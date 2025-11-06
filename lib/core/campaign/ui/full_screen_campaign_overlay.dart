import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../../config/campaign_config.dart';

class FullScreenCampaignOverlay extends StatefulWidget {
  final Campaign campaign;
  final VoidCallback onClose;
  final VoidCallback onCta;

  const FullScreenCampaignOverlay({
    super.key,
    required this.campaign,
    required this.onClose,
    required this.onCta,
  });

  @override
  State<FullScreenCampaignOverlay> createState() => _FullScreenCampaignOverlayState();
}

class _FullScreenCampaignOverlayState extends State<FullScreenCampaignOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Animation<double>? _scaleAnimation;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(
        milliseconds: _reduceMotion
            ? CampaignTimings.reducedMotionAnimationMs
            : CampaignTimings.normalAnimationMs,
      ),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.of(context).disableAnimations;

    if (!_reduceMotion) {
      _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.transparent),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _reduceMotion
                    ? _buildCard()
                    : ScaleTransition(
                        scale: _scaleAnimation!,
                        child: _buildCard(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              iconSize: 28,
              onPressed: widget.onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.campaign.imageAsset,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) => Container(
                height: 160,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.campaign.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.campaign.subtitle,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onCta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.campaign.ctaText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

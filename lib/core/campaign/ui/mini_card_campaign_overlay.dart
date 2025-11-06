import 'package:flutter/material.dart';
import '../models/campaign.dart';
import 'dart:math' as math;

class MiniCardCampaignOverlay extends StatefulWidget {
  final Campaign campaign;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const MiniCardCampaignOverlay({
    super.key,
    required this.campaign,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  State<MiniCardCampaignOverlay> createState() => _MiniCardCampaignOverlayState();
}

class _MiniCardCampaignOverlayState extends State<MiniCardCampaignOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss(DismissDirection direction) {
    if (direction == DismissDirection.down) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final calculatedBottom = math.max(16.0, safeBottom + 72.0);

    return Positioned(
      bottom: calculatedBottom,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dismissible(
          key: const Key('mini_campaign_card'),
          direction: DismissDirection.down,
          onDismissed: _handleDismiss,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.campaign.imageAsset,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stack) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.campaign.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.campaign.ctaText,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: widget.onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum StatusType { inUse, warning, alert, info }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;
  final bool isCompact;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (type) {
      StatusType.inUse => (
          (cs.brightness == Brightness.dark ? Colors.green.shade900.withOpacity(0.3) : Colors.green.shade50),
          (cs.brightness == Brightness.dark ? Colors.green.shade300 : Colors.green.shade700)
        ),
      StatusType.warning => (
          (cs.brightness == Brightness.dark ? Colors.amber.shade900.withOpacity(0.3) : Colors.amber.shade50),
          (cs.brightness == Brightness.dark ? Colors.amber.shade300 : Colors.amber.shade700)
        ),
      StatusType.alert => (
          (cs.brightness == Brightness.dark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50),
          (cs.brightness == Brightness.dark ? Colors.red.shade300 : Colors.red.shade700)
        ),
      StatusType.info => (
          (cs.brightness == Brightness.dark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50),
          (cs.brightness == Brightness.dark ? Colors.blue.shade300 : Colors.blue.shade700)
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: isCompact ? 10 : 12,
            ),
      ),
    );
  }
}

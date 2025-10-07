import 'package:flutter/material.dart';

class WizardBottomBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final bool continueEnabled;
  final String backLabel;
  final String continueLabel;

  const WizardBottomBar({
    super.key,
    required this.onBack,
    required this.onContinue,
    this.continueEnabled = false,
    this.backLabel = 'Volver',
    this.continueLabel = 'Continuar',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton(onPressed: onBack, child: Text(backLabel)),
            const Spacer(),
            FilledButton(
              onPressed: continueEnabled ? onContinue : null,
              child: Text(continueLabel),
            ),
          ],
        ),
      ),
    );
  }
}

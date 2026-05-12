// ============================================================================
// DEMO REGISTRATION V2 — P6: CONFIG MOCK (Renter / Provider / Insurer / Legal)
// TEMPORARY (SAFE TO DELETE)
//
// Pantalla mock de configuración para roles que aún no tienen el flujo real.
// Solo muestra qué se capturaría en producción y permite confirmar o saltar.
// ============================================================================

import 'package:flutter/material.dart';

import '../demo_state.dart';
import '../widgets/demo_step_scaffold.dart';

class P6ConfigMock extends StatelessWidget {
  final DemoRegistrationState state;
  final VoidCallback onComplete;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const P6ConfigMock({
    super.key,
    required this.state,
    required this.onComplete,
    required this.onSkip,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final copy = _copyForRole(state.role);

    return DemoStepScaffold(
      currentStep: 4,
      totalSteps: 5,
      eyebrow: _roleLabel(state.role),
      title: copy.title,
      onBack: onBack,
      primaryAction: FilledButton.icon(
        onPressed: () {
          state.update(() {
            state.configCompleted = true;
            state.configSkipped = false;
          });
          onComplete();
        },
        icon: const Icon(Icons.check_rounded),
        label: const Text('Listo, ir a mi espacio de trabajo'),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Banner mock ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.tertiaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.construction_rounded,
                    color: cs.onTertiaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mock de configuración',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onTertiaryContainer,
                        ),
                      ),
                      Text(
                        'En producción, esta pantalla sería interactiva. Aquí solo simulamos el flujo.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Lista de campos que se capturarían ───────────────────────────
          Text(
            'Aquí capturaríamos:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          ...copy.fields.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MockField(
                  icon: f.icon,
                  label: f.label,
                  value: f.example,
                ),
              )),

          const SizedBox(height: 24),

          // ── Skip disuasivo ───────────────────────────────────────────────
          Center(
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                copy.skipLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Label legible del rol seleccionado en P3, usado como eyebrow.
  /// Solo Insurer (persona) y Legal llegan a esta pantalla en el flujo actual.
  static String _roleLabel(DemoRoleCode? role) {
    return switch (role) {
      DemoRoleCode.insurer => 'Asegurador / Broker',
      DemoRoleCode.legal => 'Abogado / Firma legal',
      _ => 'Mi negocio',
    };
  }

  // ── Copy por rol ──────────────────────────────────────────────────────────

  static _MockCopy _copyForRole(DemoRoleCode? role) {
    // NOTA: Renter y Provider ya no entran acá — responden todo en P4 inline.
    return switch (role) {
      DemoRoleCode.insurer => const _MockCopy(
          title: 'Especialidad de seguros',
          fields: [
            _MockFieldDef(
              icon: Icons.public_rounded,
              label: 'Mercados que aseguras',
              example: 'Vehículos · Inmuebles · Maquinaria · Equipos',
            ),
            _MockFieldDef(
              icon: Icons.shield_rounded,
              label: 'Especialidad',
              example: 'Broker de Seguros, Broker Inmobiliario…',
            ),
          ],
          skipLabel: 'Lo configuraré después',
        ),
      DemoRoleCode.legal => const _MockCopy(
          title: 'Especialidad jurídica',
          fields: [
            _MockFieldDef(
              icon: Icons.public_rounded,
              label: 'Activos que atiendes',
              example: 'Vehículos · Inmuebles · Maquinaria · Equipos',
            ),
            _MockFieldDef(
              icon: Icons.gavel_rounded,
              label: 'Especialidad',
              example: 'Tránsito, Inmobiliario, Comercial…',
            ),
          ],
          skipLabel: 'Lo configuraré después',
        ),
      _ => const _MockCopy(
          title: 'Configuración',
          fields: [
            _MockFieldDef(
              icon: Icons.settings_rounded,
              label: 'Datos de tu espacio de trabajo',
              example: 'Por definir',
            ),
          ],
          skipLabel: 'Saltar',
        ),
    };
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WIDGETS
// ════════════════════════════════════════════════════════════════════════════

class _MockField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MockField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockCopy {
  final String title;
  final List<_MockFieldDef> fields;
  final String skipLabel;

  const _MockCopy({
    required this.title,
    required this.fields,
    required this.skipLabel,
  });
}

class _MockFieldDef {
  final IconData icon;
  final String label;
  final String example;

  const _MockFieldDef({
    required this.icon,
    required this.label,
    required this.example,
  });
}

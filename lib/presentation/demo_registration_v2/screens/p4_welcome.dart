// ============================================================================
// DEMO REGISTRATION V2 — P4: WELCOME (TEMPORARY)
//
// Pantalla de cierre del registro (auth). Es el momento "🎉 estás dentro".
// Sin nombre ni ciudad porque eso es CONFIGURACIÓN del negocio (capturado en
// P5 "Tu negocio"). Acá solo confirmamos que el registro funcionó y damos
// contexto del próximo paso por rol.
//
// Posición en el flujo: paso 4 de 5. Sin scaffold (es celebración).
// ============================================================================

import 'package:flutter/material.dart';

import '../demo_state.dart';

class P4Welcome extends StatefulWidget {
  final DemoRegistrationState state;

  /// Continuar al siguiente paso (P5 "Tu negocio").
  final VoidCallback onContinue;

  /// Saltar todo lo que viene (P5 + P6) → workspace mock con banner.
  final VoidCallback onSkip;

  const P4Welcome({
    super.key,
    required this.state,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  State<P4Welcome> createState() => _P4WelcomeState();
}

class _P4WelcomeState extends State<P4Welcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final copy = _copyForRole(widget.state.role);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // ── Check animado ────────────────────────────────────────
                  ScaleTransition(
                    scale: _scale,
                    child: Center(
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: cs.onPrimaryContainer,
                          size: 64,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  FadeTransition(
                    opacity: _fade,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Saludo genérico ──────────────────────────────
                        Text(
                          '¡Listo!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ── Subtítulo: cuenta activa + rol ───────────────
                        Text(
                          'Tu cuenta de ${copy.roleLabel} ya está activa.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Tarjeta de próximo paso (genérica) ───────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(copy.icon, color: cs.primary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Configura tu negocio',
                                      style:
                                          theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                copy.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── CTA único ────────────────────────────────────
                        FilledButton(
                          onPressed: widget.onContinue,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Configurar negocio'),
                        ),

                        // ── Skip disuasivo ───────────────────────────────
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: widget.onSkip,
                          child: Text(
                            'Lo configuraré después',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
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

  // ── Copy por rol ──────────────────────────────────────────────────────────

  static _RoleCopy _copyForRole(DemoRoleCode? role) {
    return switch (role) {
      DemoRoleCode.owner => const _RoleCopy(
          roleLabel: 'Propietario de activos',
          icon: Icons.workspace_premium_rounded,
          description:
              'En unos pasos más configuraremos tu espacio de trabajo y '
              'registraremos tu primer activo.',
        ),
      DemoRoleCode.assetAdmin => const _RoleCopy(
          roleLabel: 'Administrador de activos',
          icon: Icons.engineering_rounded,
          description:
              'Vamos a configurar tu espacio de trabajo para que empieces a '
              'gestionar activos.',
        ),
      DemoRoleCode.renter => const _RoleCopy(
          roleLabel: 'Arrendatario',
          icon: Icons.key_rounded,
          description:
              'Configuraremos tu espacio de trabajo según el tipo de '
              'arrendamiento que elegiste.',
        ),
      DemoRoleCode.provider => const _RoleCopy(
          roleLabel: 'Proveedor',
          icon: Icons.handyman_rounded,
          description:
              'Configuraremos tu espacio de trabajo para el mercado que '
              'atiendes. Tu oferta y especialidades las defines después.',
        ),
      DemoRoleCode.asesor => const _RoleCopy(
          roleLabel: 'Asesor comercial',
          icon: Icons.business_center_rounded,
          description:
              'Configuraremos tu espacio de trabajo para el mercado que '
              'atiendes. Tu oferta y especialidades las defines después.',
        ),
      DemoRoleCode.insurer => const _RoleCopy(
          roleLabel: 'Asegurador / Broker',
          icon: Icons.shield_rounded,
          description:
              'Configuraremos tu espacio de trabajo para que recibas leads '
              'relevantes.',
        ),
      DemoRoleCode.broker => const _RoleCopy(
          roleLabel: 'Gestor de activos',
          icon: Icons.handshake_rounded,
          description:
              'Configuraremos tu espacio de trabajo para gestionar las '
              'transacciones de los activos que comercializas.',
        ),
      DemoRoleCode.legal => const _RoleCopy(
          roleLabel: 'Legal',
          icon: Icons.gavel_rounded,
          description:
              'Configuraremos tu espacio de trabajo para que recibas casos '
              'relevantes.',
        ),
      null => const _RoleCopy(
          roleLabel: 'tu rol',
          icon: Icons.dashboard_rounded,
          description: 'Vamos a configurar tu espacio de trabajo.',
        ),
    };
  }
}

class _RoleCopy {
  final String roleLabel;
  final IconData icon;
  final String description;

  const _RoleCopy({
    required this.roleLabel,
    required this.icon,
    required this.description,
  });
}

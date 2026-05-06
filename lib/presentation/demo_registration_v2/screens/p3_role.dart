// ============================================================================
// DEMO REGISTRATION V2 — P3: ROLE + SCOPE (TEMPORARY)
//
// Reemplaza SelectProfile + Follow-up bottom sheet por una sola pantalla:
// roles como cards, follow-up inline con chips cuando aplica.
//
// Posición en el flujo: paso 3 de 5 (después de teléfono + OTP, antes de la
// pantalla de bienvenida).
// ============================================================================

import 'package:flutter/material.dart';

import '../demo_state.dart';
import '../widgets/demo_step_scaffold.dart';

class _RoleOption {
  final DemoRoleCode code;
  final String label;
  final String tagline;
  final IconData icon;

  const _RoleOption({
    required this.code,
    required this.label,
    required this.tagline,
    required this.icon,
  });
}

class P3Role extends StatefulWidget {
  final DemoRegistrationState state;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const P3Role({
    super.key,
    required this.state,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<P3Role> createState() => _P3RoleState();
}

class _P3RoleState extends State<P3Role> {
  static const _roles = <_RoleOption>[
    _RoleOption(
      code: DemoRoleCode.assetAdmin,
      label: 'Administrador de activos',
      tagline: 'Gestiono activos propios o de terceros',
      icon: Icons.engineering_rounded,
    ),
    _RoleOption(
      code: DemoRoleCode.owner,
      label: 'Propietario de activos',
      tagline: 'Soy dueño de los activos',
      icon: Icons.workspace_premium_rounded,
    ),
    _RoleOption(
      code: DemoRoleCode.renter,
      label: 'Arrendatario',
      tagline: 'Tomo activos en arriendo',
      icon: Icons.key_rounded,
    ),
    _RoleOption(
      code: DemoRoleCode.provider,
      label: 'Proveedor',
      tagline: 'Comercializo productos o servicios',
      icon: Icons.handyman_rounded,
    ),
    _RoleOption(
      code: DemoRoleCode.asesor,
      label: 'Asesor comercial',
      tagline: 'Comercializo productos y servicios de terceros',
      icon: Icons.business_center_rounded,
    ),
    _RoleOption(
      code: DemoRoleCode.insurer,
      label: 'Asegurador / Broker',
      tagline: 'Soy intermediario de seguros o finca raíz',
      icon: Icons.shield_rounded,
    ),
    _RoleOption(
      code: DemoRoleCode.legal,
      label: 'Abogado / Firma legal',
      tagline: 'Ofrezco servicios jurídicos',
      icon: Icons.gavel_rounded,
    ),
  ];

  bool get _canContinue {
    final r = widget.state.role;
    if (r == null) return false;
    if (r == DemoRoleCode.assetAdmin && widget.state.adminScope == null) {
      return false;
    }
    if (r == DemoRoleCode.owner && widget.state.ownerScope == null) {
      return false;
    }
    if (r == DemoRoleCode.renter && widget.state.renterSubrole == null) {
      return false;
    }
    if (r == DemoRoleCode.provider && widget.state.providerMarket == null) {
      // Provider solo declara UN mercado en P3; tipo de oferta y
      // especialidades se configuran después en el workspace.
      return false;
    }
    if (r == DemoRoleCode.asesor && widget.state.asesorMarket == null) {
      // Asesor comercial: misma estructura que Provider (un mercado).
      return false;
    }
    if (r == DemoRoleCode.insurer && widget.state.insurerSpecialty == null) {
      return false;
    }
    if (r == DemoRoleCode.legal && widget.state.legalSpecialty == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DemoStepScaffold(
      currentStep: 2,
      totalSteps: 5,
      title: '¿Cuál es tu perfil?',
      onBack: widget.onBack,
      // Sin botón global: cada card expandida muestra su propio
      // "Entrar a Avanzza" inline al final del follow-up.
      primaryAction: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Elige cómo usarás Avanzza. Podrás ajustar esto después.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ..._roles.map((r) {
            final selected = widget.state.role == r.code;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RoleCard(
                option: r,
                selected: selected,
                canContinue: _canContinue,
                onContinue: widget.onNext,
                onTap: () {
                  setState(() {
                    widget.state.role = r.code;
                    if (r.code != DemoRoleCode.assetAdmin) {
                      widget.state.adminScope = null;
                    }
                    if (r.code != DemoRoleCode.owner) {
                      widget.state.ownerScope = null;
                    }
                    if (r.code != DemoRoleCode.renter) {
                      widget.state.renterSubrole = null;
                    }
                    if (r.code != DemoRoleCode.provider) {
                      widget.state.providerMarket = null;
                      widget.state.providerOfferType = null;
                      widget.state.providerSpecialties.clear();
                      widget.state.providerOtherSpecialty = '';
                    }
                    if (r.code != DemoRoleCode.asesor) {
                      widget.state.asesorMarket = null;
                    }
                    if (r.code != DemoRoleCode.insurer) {
                      widget.state.insurerSpecialty = null;
                    }
                    if (r.code != DemoRoleCode.legal) {
                      widget.state.legalSpecialty = null;
                    }
                  });
                },
                followUp: _buildFollowUp(r.code),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget? _buildFollowUp(DemoRoleCode code) {
    if (widget.state.role != code) return null;

    if (code == DemoRoleCode.assetAdmin) {
      return _AdminFollowUp(
        selected: widget.state.adminScope,
        onChanged: (v) => setState(() => widget.state.adminScope = v),
      );
    }
    if (code == DemoRoleCode.owner) {
      return _OwnerFollowUp(
        selected: widget.state.ownerScope,
        onChanged: (v) => setState(() => widget.state.ownerScope = v),
      );
    }
    if (code == DemoRoleCode.renter) {
      return _RenterFollowUp(
        selected: widget.state.renterSubrole,
        onChanged: (v) => setState(() => widget.state.renterSubrole = v),
      );
    }
    if (code == DemoRoleCode.provider) {
      return _ProviderFollowUp(
        selected: widget.state.providerMarket,
        onChanged: (m) => setState(() => widget.state.providerMarket = m),
      );
    }
    if (code == DemoRoleCode.asesor) {
      // Reusamos `_ProviderFollowUp` — misma UI (chips de mercados sin "Otros"),
      // distinta data (asesorMarket vs providerMarket).
      return _ProviderFollowUp(
        selected: widget.state.asesorMarket,
        onChanged: (m) => setState(() => widget.state.asesorMarket = m),
      );
    }
    if (code == DemoRoleCode.insurer) {
      return _InsurerFollowUp(
        selected: widget.state.insurerSpecialty,
        onChanged: (v) => setState(() => widget.state.insurerSpecialty = v),
      );
    }
    if (code == DemoRoleCode.legal) {
      return _LegalFollowUp(
        selected: widget.state.legalSpecialty,
        onChanged: (v) => setState(() => widget.state.legalSpecialty = v),
      );
    }
    return null;
  }
}

class _RoleCard extends StatelessWidget {
  final _RoleOption option;
  final bool selected;
  final VoidCallback onTap;
  final Widget? followUp;

  /// Habilita/deshabilita el botón "Entrar a Avanzza" inline cuando la card
  /// está expandida (depende del follow-up del rol).
  final bool canContinue;

  /// Callback del botón "Entrar a Avanzza" inline. Solo visible cuando la
  /// card está seleccionada (eliminamos el botón global del scaffold).
  final VoidCallback onContinue;

  const _RoleCard({
    required this.option,
    required this.selected,
    required this.onTap,
    required this.canContinue,
    required this.onContinue,
    this.followUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: selected
          ? cs.primaryContainer.withValues(alpha: 0.5)
          : cs.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? cs.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header tappable (icono + label + tagline + check) ───────
              InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selected
                              ? cs.primary.withValues(alpha: 0.15)
                              : cs.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          option.icon,
                          color: selected ? cs.primary : cs.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.label,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              option.tagline,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_circle_rounded, color: cs.primary),
                    ],
                  ),
                ),
              ),

              // ── Sección expandida (follow-up + botón Entrar a Avanzza) ──
              if (selected && followUp != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                        height: 1,
                      ),
                      const SizedBox(height: 12),
                      followUp!,
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: canContinue ? onContinue : null,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Entrar a Avanzza'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminFollowUp extends StatelessWidget {
  final DemoAdminScope? selected;
  final ValueChanged<DemoAdminScope> onChanged;

  const _AdminFollowUp({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué activos administrarás?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DemoAdminScope.values.map((s) {
            final isSelected = selected == s;
            final label = switch (s) {
              DemoAdminScope.propios => 'Los míos',
              DemoAdminScope.terceros => 'De terceros',
              DemoAdminScope.ambos => 'Ambos',
            };
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onChanged(s),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _OwnerFollowUp extends StatelessWidget {
  final DemoOwnerScope? selected;
  final ValueChanged<DemoOwnerScope> onChanged;

  const _OwnerFollowUp({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Quién administra tus activos?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DemoOwnerScope.values.map((s) {
            final isSelected = selected == s;
            final label = switch (s) {
              DemoOwnerScope.self => 'Yo mismo',
              DemoOwnerScope.third => 'Un tercero',
              DemoOwnerScope.both => 'Ambos',
            };
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onChanged(s),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RenterFollowUp extends StatelessWidget {
  final DemoRenterSubrole? selected;
  final ValueChanged<DemoRenterSubrole> onChanged;

  const _RenterFollowUp({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué tipo de arrendatario eres?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DemoRenterSubrole.values.map((s) {
            final isSelected = selected == s;
            return ChoiceChip(
              label: Text(s.label),
              selected: isSelected,
              onSelected: (_) => onChanged(s),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HELPERS COMPARTIDOS
// ════════════════════════════════════════════════════════════════════════════

String _marketLabel(DemoAssetType t) => switch (t) {
      DemoAssetType.vehiculo => 'Vehículos',
      DemoAssetType.inmueble => 'Inmuebles',
      DemoAssetType.maquinaria => 'Maquinaria',
      DemoAssetType.equipo => 'Equipos',
      DemoAssetType.otro => 'Otros',
    };

// ════════════════════════════════════════════════════════════════════════════
// PROVIDER FOLLOW-UP — solo mercado (multi-select).
// Tipo de oferta y especialidades se configuran en el workspace, no aquí.
// ════════════════════════════════════════════════════════════════════════════

class _ProviderFollowUp extends StatelessWidget {
  final DemoAssetType? selected;
  final ValueChanged<DemoAssetType> onChanged;

  const _ProviderFollowUp({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué mercado atiendes?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          // Single-select: un workspace = un mercado. Excluimos "Otros" porque
          // un proveedor/asesor profesional debe categorizarse en un mercado
          // concreto para que el matching del marketplace funcione.
          children: DemoAssetType.values
              .where((m) => m != DemoAssetType.otro)
              .map((m) {
            return ChoiceChip(
              label: Text(_marketLabel(m)),
              selected: selected == m,
              onSelected: (_) => onChanged(m),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// INSURER FOLLOW-UP — chips Seguros / Inmobiliario
// ════════════════════════════════════════════════════════════════════════════

class _InsurerFollowUp extends StatelessWidget {
  final DemoInsurerSpecialty? selected;
  final ValueChanged<DemoInsurerSpecialty> onChanged;

  const _InsurerFollowUp({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿En qué sector te especializas?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DemoInsurerSpecialty.values.map((s) {
            return ChoiceChip(
              label: Text(s.label),
              selected: selected == s,
              onSelected: (_) => onChanged(s),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LEGAL FOLLOW-UP — chips Civil / Penal / Ambas
// ════════════════════════════════════════════════════════════════════════════

class _LegalFollowUp extends StatelessWidget {
  final DemoLegalSpecialty? selected;
  final ValueChanged<DemoLegalSpecialty> onChanged;

  const _LegalFollowUp({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Cuál es tu especialidad jurídica?',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DemoLegalSpecialty.values.map((s) {
            return ChoiceChip(
              label: Text(s.label),
              selected: selected == s,
              onSelected: (_) => onChanged(s),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ============================================================================
// DEMO REGISTRATION V2 — P7: WORKSPACE MOCK (TEMPORARY, SAFE TO DELETE)
//
// Pantalla final del demo. Simula el shell del workspace post-registro.
// - Banner persistente arriba si el usuario saltó la configuración (P6).
// - Resumen completo de los datos capturados (P1–P6).
// - Acciones: reiniciar el demo o salir.
// ============================================================================

import 'package:flutter/material.dart';

import '../demo_state.dart';

class P7WorkspaceMock extends StatelessWidget {
  final DemoRegistrationState state;
  final VoidCallback onConfigure;
  final VoidCallback onReset;
  final VoidCallback onExit;

  /// Opcional. Si se provee, el botón principal pasa de "Salir del demo"
  /// a "Comenzar mi espacio" y dispara el commit real
  /// (CompleteOnboardingUC). Cuando es null, comportamiento legacy
  /// (demo-mock).
  final VoidCallback? onCommit;

  /// True mientras el commit está en progreso. Bloquea botones y muestra
  /// spinner en el botón principal. Solo aplica si onCommit != null.
  final bool isCommitting;

  /// Mensaje de error del último commit fallido. Cuando no es null se
  /// muestra debajo del botón principal con un mini-CTA "Reintentar".
  final String? commitError;

  /// Callback de retry tras error. Solo se renderiza si commitError != null
  /// y onRetry != null.
  final VoidCallback? onRetry;

  const P7WorkspaceMock({
    super.key,
    required this.state,
    required this.onConfigure,
    required this.onReset,
    required this.onExit,
    this.onCommit,
    this.isCommitting = false,
    this.commitError,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final showBanner = state.configSkipped && state.roleNeedsConfig;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.dashboard_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'Mi espacio · ${_workspaceLabel(state)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Salir del demo',
            onPressed: onExit,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // ── Banner persistente si saltó configuración ────────────────
            if (showBanner) _SkipBanner(onConfigure: onConfigure),

            if (showBanner) const SizedBox(height: 16),

            // ── Mock de "tu workspace" ───────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withValues(alpha: 0.12),
                    cs.primaryContainer.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: cs.onPrimary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aquí abriríamos tu espacio de trabajo real',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _greeting(state),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (state.configCompleted) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.task_alt_rounded,
                              size: 14, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Configuración completa',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Resumen ──────────────────────────────────────────────────
            Text(
              'Lo que registraste',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            _SummaryCard(state: state),

            const SizedBox(height: 24),

            // ── Acciones ─────────────────────────────────────────────────
            OutlinedButton.icon(
              onPressed: isCommitting ? null : onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Probar de nuevo'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // CTA principal:
            //  - Si onCommit != null  ⇒ "Comenzar mi espacio" (commit real)
            //  - Si onCommit == null  ⇒ "Salir del demo" (legacy mock)
            if (onCommit != null)
              FilledButton.icon(
                onPressed: isCommitting ? null : onCommit,
                icon: isCommitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.rocket_launch_rounded),
                label: Text(
                  isCommitting ? 'Creando tu espacio...' : 'Comenzar mi espacio',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            else
              FilledButton.icon(
                onPressed: onExit,
                icon: const Icon(Icons.exit_to_app_rounded),
                label: const Text('Salir del demo'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            // Error + retry (solo aplica al modo commit-real)
            if (commitError != null && onCommit != null) ...[
              const SizedBox(height: 12),
              _CommitErrorPanel(
                message: commitError!,
                onRetry: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _workspaceLabel(DemoRegistrationState s) {
    return switch (s.role) {
      DemoRoleCode.assetAdmin => 'Administrador',
      DemoRoleCode.owner => 'Propietario',
      DemoRoleCode.renter => 'Arrendatario',
      DemoRoleCode.provider => 'Proveedor',
      DemoRoleCode.asesor => 'Asesor comercial',
      DemoRoleCode.insurer => 'Asegurador',
      DemoRoleCode.broker => 'Gestor',
      DemoRoleCode.legal => 'Legal',
      null => '—',
    };
  }

  static String _greeting(DemoRegistrationState s) {
    final name = s.fullNameOrCompany.split(' ').first;
    return name.isEmpty
        ? 'Tu cuenta está activa.'
        : 'Hola, $name. Tu cuenta está activa.';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// BANNER — solo visible si el usuario saltó la configuración
// ════════════════════════════════════════════════════════════════════════════

class _SkipBanner extends StatelessWidget {
  final VoidCallback onConfigure;
  const _SkipBanner({required this.onConfigure});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: cs.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Termina de configurar tu cuenta',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onErrorContainer,
                  ),
                ),
                Text(
                  'Sin configuración, tu espacio de trabajo está vacío.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: onConfigure,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Configurar'),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RESUMEN COMPACTO
// ════════════════════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  final DemoRegistrationState state;
  const _SummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final assetRow = _assetRow(state);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            theme,
            cs,
            Icons.phone_rounded,
            'Teléfono',
            '${state.countryDialCode} ${state.phone}',
          ),
          _row(
            theme,
            cs,
            state.titularType == DemoTitularType.empresa
                ? Icons.business_rounded
                : Icons.person_outline_rounded,
            state.titularType == DemoTitularType.empresa ? 'Empresa' : 'Nombre',
            state.fullNameOrCompany,
          ),
          _row(
            theme,
            cs,
            Icons.public_rounded,
            'Ubicación',
            '${state.city}, ${state.countryName}',
          ),
          _row(
            theme,
            cs,
            Icons.badge_outlined,
            'Rol',
            _roleLabel(state),
          ),
          if (state.role == DemoRoleCode.provider ||
              state.role == DemoRoleCode.asesor)
            _row(
              theme,
              cs,
              state.role == DemoRoleCode.asesor
                  ? Icons.business_center_rounded
                  : Icons.handyman_rounded,
              'Mercado que atiende',
              _marketSummary(state),
              isLast: assetRow == null,
            ),
          if (assetRow != null) assetRow,
        ],
      ),
    );
  }

  /// Resumen del mercado (single) para Provider o Asesor. Oferta y
  /// especialidades se configuran en el workspace, no en el registro.
  static String _marketSummary(DemoRegistrationState s) {
    final market = s.role == DemoRoleCode.asesor
        ? s.asesorMarket
        : s.providerMarket;
    if (market == null) return '';
    return switch (market) {
      DemoAssetType.vehiculo => 'Vehículos',
      DemoAssetType.inmueble => 'Inmuebles',
      DemoAssetType.maquinaria => 'Maquinaria',
      DemoAssetType.equipo => 'Equipos',
      DemoAssetType.otro => 'Otros',
    };
  }

  Widget _row(
    ThemeData theme,
    ColorScheme cs,
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                Text(
                  value.isEmpty ? '—' : value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _assetRow(DemoRegistrationState s) {
    if (s.assetType == null) return null;
    final type = switch (s.assetType!) {
      DemoAssetType.vehiculo => 'Vehículo',
      DemoAssetType.inmueble => 'Inmueble',
      DemoAssetType.maquinaria => 'Maquinaria',
      DemoAssetType.equipo => 'Equipo',
      DemoAssetType.otro => 'Otro',
    };
    final detail = _assetDetail(s);
    return Builder(builder: (ctx) {
      final theme = Theme.of(ctx);
      final cs = theme.colorScheme;
      return _row(
        theme,
        cs,
        Icons.inventory_2_rounded,
        'Primer activo',
        detail.isEmpty ? type : '$type · $detail',
        isLast: true,
      );
    });
  }

  static String _assetDetail(DemoRegistrationState s) {
    final d = s.assetData;
    return switch (s.assetType) {
      DemoAssetType.vehiculo => _vehicleSummary(d),
      DemoAssetType.inmueble => _inmuebleSummary(d),
      DemoAssetType.maquinaria => _maquinariaSummary(d),
      DemoAssetType.equipo => _equipoSummary(d),
      DemoAssetType.otro => d['descripcion'] ?? '',
      null => '',
    };
  }

  /// Resumen del vehículo: placa + tipo doc + número doc.
  static String _vehicleSummary(Map<String, String> d) {
    final placa = d['placa'] ?? '';
    final docType = d['docType'] ?? '';
    final docNumber = d['docNumber'] ?? '';
    final docPart = (docType.isNotEmpty && docNumber.isNotEmpty)
        ? '$docType $docNumber'
        : '';
    return [placa, docPart]
        .where((v) => v.isNotEmpty)
        .join(' · ');
  }

  /// Resumen del inmueble: tipo (con "Otros: X") + dirección + complemento.
  static String _inmuebleSummary(Map<String, String> d) {
    final tipoLabel = d['tipoInmuebleLabel'] ?? '';
    final tipoOtro = d['tipoInmuebleOtro'] ?? '';
    final tipoFinal = (tipoLabel == 'Otros' && tipoOtro.isNotEmpty)
        ? 'Otros: $tipoOtro'
        : tipoLabel;
    final direccion = d['direccion'] ?? '';
    final complemento = d['complemento'] ?? '';
    return [tipoFinal, direccion, complemento]
        .where((v) => v.isNotEmpty)
        .join(' · ');
  }

  /// Resumen de maquinaria: tipo (con "Otra: X" si aplica) + nombre + marca +
  /// modelo. Sigue el mismo patrón que el resumen de inmueble.
  static String _maquinariaSummary(Map<String, String> d) {
    final tipoLabel = d['tipoMaquinariaLabel'] ?? '';
    final tipoOtro = d['tipoMaquinariaOtro'] ?? '';
    final tipoFinal = (tipoLabel == 'Otra' && tipoOtro.isNotEmpty)
        ? 'Otra: $tipoOtro'
        : tipoLabel;
    return [tipoFinal, d['nombre'], d['marca'], d['modelo']]
        .whereType<String>()
        .where((v) => v.isNotEmpty)
        .join(' · ');
  }

  /// Resumen de equipo: tipo (con "Otra: X" si aplica) + nombre + marca +
  /// modelo. Marca/Modelo/Serial son opcionales — solo aparecen si están.
  static String _equipoSummary(Map<String, String> d) {
    final tipoLabel = d['tipoEquipoLabel'] ?? '';
    final tipoOtro = d['tipoEquipoOtro'] ?? '';
    final tipoFinal = (tipoLabel == 'Otra' && tipoOtro.isNotEmpty)
        ? 'Otra: $tipoOtro'
        : tipoLabel;
    return [tipoFinal, d['nombre'], d['marca'], d['modelo']]
        .whereType<String>()
        .where((v) => v.isNotEmpty)
        .join(' · ');
  }

  static String _roleLabel(DemoRegistrationState s) {
    final base = switch (s.role) {
      DemoRoleCode.assetAdmin => 'Administrador de activos',
      DemoRoleCode.owner => 'Propietario de activos',
      DemoRoleCode.renter => 'Arrendatario',
      DemoRoleCode.provider => 'Proveedor',
      DemoRoleCode.asesor => 'Asesor comercial',
      DemoRoleCode.insurer => 'Asegurador / Broker',
      DemoRoleCode.broker => 'Gestor de activos',
      DemoRoleCode.legal => 'Legal',
      null => '—',
    };
    final scope = switch (s.role) {
      DemoRoleCode.assetAdmin => switch (s.adminScope) {
          DemoAdminScope.propios => ' · míos',
          DemoAdminScope.terceros => ' · terceros',
          DemoAdminScope.ambos => ' · ambos',
          null => '',
        },
      DemoRoleCode.owner => switch (s.ownerScope) {
          DemoOwnerScope.self => ' · yo mismo',
          DemoOwnerScope.third => ' · tercero',
          DemoOwnerScope.both => ' · ambos',
          null => '',
        },
      DemoRoleCode.renter => switch (s.renterSubrole) {
          DemoRenterSubrole.conductor => ' · conductor',
          DemoRenterSubrole.inquilino => ' · inquilino',
          DemoRenterSubrole.cliente => ' · cliente',
          null => '',
        },
      DemoRoleCode.provider => switch (s.providerOfferType) {
          DemoProviderOfferType.productos => ' · productos',
          DemoProviderOfferType.servicios => ' · servicios',
          null => '',
        },
      DemoRoleCode.insurer => switch (s.insurerSpecialty) {
          DemoInsurerSpecialty.seguros => ' · seguros',
          DemoInsurerSpecialty.inmobiliario => ' · inmobiliario',
          null => '',
        },
      DemoRoleCode.broker => switch (s.brokerMarket) {
          DemoAssetType.inmueble => ' · inmobiliario',
          DemoAssetType.vehiculo => ' · vehículos',
          DemoAssetType.maquinaria => ' · maquinaria',
          DemoAssetType.equipo => ' · equipos',
          DemoAssetType.otro => ' · activos',
          null => '',
        },
      DemoRoleCode.legal => switch (s.legalSpecialty) {
          DemoLegalSpecialty.civil => ' · civil',
          DemoLegalSpecialty.penal => ' · penal',
          DemoLegalSpecialty.ambas => ' · civil y penal',
          null => '',
        },
      _ => '',
    };
    return '$base$scope';
  }
}

/// Panel de error mostrado debajo del CTA principal cuando el commit
/// falla. Incluye mini-CTA "Reintentar" si onRetry no es null.
class _CommitErrorPanel extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _CommitErrorPanel({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded, color: cs.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'No pudimos crear tu espacio',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onErrorContainer,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// lib/presentation/pages/provider/me/provider_me_page.dart
// PROVIDER ME — vista agregada self del proveedor (MF1).
//
// QUÉ HACE:
//   - [ProviderMeBody]: widget sin Scaffold/AppBar pensado para vivir como
//     contenido del tab "Perfil" del Provider Workspace Shell unificado.
//     Lista displayName + workspaceId + specialties + assetTypes +
//     capabilities admin con pull-to-refresh.
//   - [ProviderMePage]: shell mínimo (Scaffold + AppBar) que expone el
//     mismo cuerpo bajo `Routes.providerMe` para deep links / pruebas. NO
//     es el destino canónico post-bootstrap (ese es el shell unificado).
//
// QUÉ NO HACE:
//   - NO muestra invitaciones / equipo / inbox (otras MF).
//   - NO permite editar specialties (M2 reusará PUT /providers/:id/specialties).
//
// REUSE:
//   - GetView<ProviderMeController> con binding.
//   - AppColors / Spacing / Radius del theme central.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/spacing.dart';
import '../../../controllers/provider/me/provider_me_controller.dart';

/// Cuerpo reutilizable de "Mi proveedor". Vive sin Scaffold ni AppBar para
/// poder embeberse como tab "Perfil" del Provider Workspace Shell.
class ProviderMeBody extends GetView<ProviderMeController> {
  const ProviderMeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: Obx(() {
        final me = controller.me.value;
        final err = controller.error.value;

        if (err.isNotEmpty && me == null) {
          return _ErrorState(message: err, onRetry: controller.refresh);
        }
        if (me == null) {
          // Loading inicial (sin datos).
          return const Center(child: CircularProgressIndicator());
        }
        // Si por contrato isProvider=false, el controller ya hizo el
        // redirect en onInit/refresh. Si llegamos aquí con false (ej.
        // race) mostramos placeholder.
        if (!me.isProvider) {
          return const _NotProviderPlaceholder();
        }
        final pp = me.providerProfile!;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (err.isNotEmpty) _InlineErrorBanner(message: err),
            _Header(
              displayName: pp.displayName,
              workspaceId: me.workspaceId,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle('Especialidades'),
            const SizedBox(height: AppSpacing.sm),
            if (me.specialties.isEmpty)
              const _EmptyChip(
                text: 'Sin especialidades configuradas.',
              )
            else
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final s in me.specialties)
                    Chip(
                      label: Text(s.name),
                    ),
                ],
              ),
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle('Tipos de activo'),
            const SizedBox(height: AppSpacing.sm),
            if (me.assetTypes.isEmpty)
              const _EmptyChip(
                text: 'Sin tipos de activo configurados.',
              )
            else
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final a in me.assetTypes)
                    Chip(label: Text(a.name)),
                ],
              ),
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle('Permisos de administrador'),
            const SizedBox(height: AppSpacing.sm),
            _CapabilityRow(
              label: 'Invitar asesores',
              granted: me.hasInviteAgentCapability,
            ),
            _CapabilityRow(
              label: 'Listar invitaciones emitidas',
              granted: me.hasReadAgentInvitationsCapability,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      }),
    );
  }
}

/// Pantalla envoltura para `Routes.providerMe` (deep links). Reusa
/// [ProviderMeBody] como cuerpo. NO es destino canónico tras bootstrap.
class ProviderMePage extends GetView<ProviderMeController> {
  const ProviderMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi proveedor'),
        actions: [
          Obx(() {
            if (controller.loading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            return IconButton(
              tooltip: 'Refrescar',
              icon: const Icon(Icons.refresh),
              onPressed: controller.refresh,
            );
          }),
        ],
      ),
      body: const ProviderMeBody(),
    );
  }
}

class _Header extends StatelessWidget {
  final String displayName;
  final String workspaceId;
  const _Header({required this.displayName, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                displayName.isNotEmpty
                    ? displayName.substring(0, 1).toUpperCase()
                    : '?',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Workspace: $workspaceId',
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _CapabilityRow extends StatelessWidget {
  final String label;
  final bool granted;
  const _CapabilityRow({required this.label, required this.granted});

  @override
  Widget build(BuildContext context) {
    final color =
        granted ? Colors.green.shade700 : Theme.of(context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            granted ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _EmptyChip extends StatelessWidget {
  final String text;
  const _EmptyChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(fontStyle: FontStyle.italic),
    );
  }
}

class _InlineErrorBanner extends StatelessWidget {
  final String message;
  const _InlineErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotProviderPlaceholder extends StatelessWidget {
  const _NotProviderPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Aún no eres proveedor en este workspace.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

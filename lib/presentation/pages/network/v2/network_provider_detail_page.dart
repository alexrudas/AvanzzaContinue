// ============================================================================
// lib/presentation/pages/network/v2/network_provider_detail_page.dart
// NETWORK PROVIDER DETAIL PAGE — Read-only V1 desde Mi Red
// ============================================================================
// QUÉ HACE:
//   - Renderiza el `ProviderCanonicalEntity` obtenido del Core API en 3
//     secciones (Header + Identidad + Especialidades).
//   - Estados disjuntos vía pattern matching sobre `ProviderDetailState`:
//     Loading / Loaded / NotFound / Error con retry.
//   - Pull-to-refresh disponible cuando el estado es Loaded — útil para
//     reflejar cambios concurrentes del backend.
//
// QUÉ NO HACE:
//   - NO edita ni elimina nada. Read-only V1.
//   - NO muestra phone/email/WhatsApp: el DTO de `GET /v1/providers/:id`
//     no los expone. Para contactar, el usuario regresa a Mi Red y usa
//     el BottomSheet de acciones del actor.
//   - NO muestra acciones operativas: `availableActions` no viaja en
//     este DTO. Diferido a un endpoint futuro o a la vista de Mi Red.
//   - NO consume LocalContactRepository ni Isar. Stack 100% Core API.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/catalog/specialty_entity.dart'
    show SpecialtyKind;
import '../../../../domain/entities/provider/provider_canonical_entity.dart';
import '../../../controllers/network/v2/network_provider_detail_controller.dart';

class NetworkProviderDetailPage extends StatelessWidget {
  const NetworkProviderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NetworkProviderDetailController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del proveedor')),
      body: Obx(() {
        final state = c.stateRx.value;
        return switch (state) {
          ProviderDetailLoading() => const _LoadingView(),
          ProviderDetailNotFound() => _NotFoundView(onRetry: c.reload),
          ProviderDetailError() => _ErrorView(onRetry: c.reload),
          ProviderDetailLoaded(:final entity) => _LoadedView(
              entity: entity,
              onRefresh: c.reload,
            ),
        };
      }),
    );
  }
}

// ── Estados ────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _NotFoundView extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _NotFoundView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_outlined, size: 56),
            const SizedBox(height: 12),
            const Text(
              'No encontramos este proveedor.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56),
            const SizedBox(height: 12),
            const Text(
              'No se pudo cargar el proveedor.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loaded ─────────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  final ProviderCanonicalEntity entity;
  final Future<void> Function() onRefresh;

  const _LoadedView({required this.entity, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _HeaderCard(entity: entity),
          const SizedBox(height: 16),
          _IdentityCard(entity: entity),
          const SizedBox(height: 16),
          _SpecialtiesCard(specialties: entity.specialties),
        ],
      ),
    );
  }
}

// ── Header card ────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final ProviderCanonicalEntity entity;
  const _HeaderCard({required this.entity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final initial = entity.displayName.characters.isEmpty
        ? '?'
        : entity.displayName.characters.first.toUpperCase();
    final kindLabel = switch (entity.actorKind) {
      ProviderActorKind.person => 'Persona',
      ProviderActorKind.organization => 'Empresa',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
              child: Text(
                initial,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _KindChip(label: kindLabel),
                      if (!entity.isActive)
                        _StatusBadge(
                          label: 'Inactivo',
                          fg: cs.onErrorContainer,
                          bg: cs.errorContainer,
                        ),
                    ],
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

class _KindChip extends StatelessWidget {
  final String label;
  const _KindChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;

  const _StatusBadge({
    required this.label,
    required this.fg,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Identity card ──────────────────────────────────────────────────────────

class _IdentityCard extends StatelessWidget {
  final ProviderCanonicalEntity entity;
  const _IdentityCard({required this.entity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Selección del nombre legal según actorKind (invariante del DTO:
    // person ⇒ fullLegalName, organization ⇒ legalName; cualquier otro
    // caso ⇒ omitir la fila).
    final legalLabel = switch (entity.actorKind) {
      ProviderActorKind.person => 'Nombre legal',
      ProviderActorKind.organization => 'Razón social',
    };
    final legalValue = switch (entity.actorKind) {
      ProviderActorKind.person => entity.fullLegalName,
      ProviderActorKind.organization => entity.legalName,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identidad',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (legalValue != null && legalValue.trim().isNotEmpty)
              _InfoRow(label: legalLabel, value: legalValue.trim()),
            _InfoRow(
              label: 'Registrado',
              value: _formatDate(entity.createdAt.toLocal()),
            ),
          ],
        ),
      ),
    );
  }

  /// Formato corto local. Si en el futuro se quiere i18n, sustituir por
  /// `intl.DateFormat` con locale del SessionContext.
  static String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d/$m/${dt.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Specialties card ──────────────────────────────────────────────────────

class _SpecialtiesCard extends StatelessWidget {
  final List<ProviderCanonicalSpecialty> specialties;
  const _SpecialtiesCard({required this.specialties});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Especialidades',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (specialties.isEmpty)
              Text(
                'Este proveedor aún no tiene especialidades registradas.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...specialties.map(_SpecialtyRow.new),
          ],
        ),
      ),
    );
  }
}

class _SpecialtyRow extends StatelessWidget {
  final ProviderCanonicalSpecialty specialty;
  const _SpecialtyRow(this.specialty);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kindLabel = switch (specialty.kind) {
      SpecialtyKind.product => 'Productos',
      SpecialtyKind.service => 'Servicios',
      SpecialtyKind.both => 'Ambos',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              specialty.name,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _KindChip(label: kindLabel),
        ],
      ),
    );
  }
}

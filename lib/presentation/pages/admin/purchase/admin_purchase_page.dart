// ============================================================================
// AdminPurchasePage — Siempre renderiza UI completa (sin bloqueos)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin/purchase/admin_purchase_controller.dart';

class AdminPurchasePage extends GetView<AdminPurchaseController> {
  const AdminPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasOrg = controller.hasActiveOrg;
      final isLoading = controller.loading.value;
      final hasError = controller.error.value != null;
      final tiles = controller.requestTiles;

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header + acciones
          Row(
            children: [
              Text('Compras', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                tooltip: 'Filtros',
                onPressed: () =>
                    Get.snackbar('Filtros', 'Configura filtros avanzados'),
                icon: const Icon(Icons.tune),
              ),
              IconButton(
                tooltip: 'Comparador',
                onPressed: () =>
                    Get.snackbar('Comparador', 'Comparador de cotizaciones'),
                icon: const Icon(Icons.compare_arrows),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Estado inline: loading, error, sin organización
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          if (hasError)
            _InlineBanner(
              icon: Icons.error_outline,
              color: Colors.red,
              title: 'Error cargando solicitudes',
              subtitle: controller.error.value!,
            ),
          if (!hasOrg)
            _InlineBanner.action(
              icon: Icons.apartment,
              color: Colors.amber,
              title: 'No hay organización activa',
              subtitle:
                  'Puedes explorar el módulo, pero algunos datos no se cargarán.',
              actionText: 'Elegir organización',
              onAction: controller.selectOrganization,
            ),
          const SizedBox(height: 12),

          // KPIs (si no hay datos, muestra ceros)
          _KpiRow(
            openRequests: tiles.length,
            pendingApprove: 0,
            inProgress: 0,
          ),
          const SizedBox(height: 16),

          // Análisis rápido (placeholders)
          _AnalysisBlockPlaceholder(),
          const SizedBox(height: 16),

          // Órdenes / Solicitudes
          _SectionHeader(
            title: 'Solicitudes abiertas',
            actionText: tiles.isNotEmpty ? 'Ver todas' : null,
            onAction: tiles.isNotEmpty
                ? () =>
                    Get.snackbar('Solicitudes', 'Navegar a listado completo')
                : null,
          ),
          const SizedBox(height: 8),
          if (tiles.isNotEmpty)
            ...tiles
          else
            _EmptyHintCard(
              icon: Icons.playlist_add,
              title: 'Sin solicitudes aún',
              subtitle:
                  'Crea tu primera solicitud para iniciar el flujo de compras.',
              actionText: 'Nueva solicitud',
              onAction: controller.createRequest,
            ),
          const SizedBox(height: 16),

          // Comparador de cotizaciones (placeholder visible siempre)
          const _SectionHeader(title: 'Comparador de cotizaciones'),
          const SizedBox(height: 8),
          _ComparatorPlaceholderRow(),
          const SizedBox(height: 16),

          // Recurrentes / Suscripciones (placeholder visible siempre)
          const _SectionHeader(title: 'Recurrentes y suscripciones'),
          const SizedBox(height: 8),
          _RecurringPlaceholderGrid(),
          const SizedBox(height: 24),

          // CTA
          FilledButton.icon(
            onPressed: controller.createRequest,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Nueva solicitud'),
          ),
        ],
      );
    });
  }
}

/* ========================== Banners inline ========================== */

class _InlineBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const _InlineBanner({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  factory _InlineBanner.action({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return _InlineBanner(
      icon: icon,
      color: color,
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionText!)),
        ],
      ),
    );
  }
}

/* =============================== KPIs =============================== */

class _KpiRow extends StatelessWidget {
  final int openRequests;
  final int pendingApprove;
  final int inProgress;

  const _KpiRow({
    required this.openRequests,
    required this.pendingApprove,
    required this.inProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _KpiTile(
          title: 'Solicitudes abiertas',
          valueText: '$openRequests',
          icon: Icons.shopping_cart_checkout_outlined,
          accent: Colors.indigo,
        ),
        _KpiTile(
          title: 'Pendientes aprobar',
          valueText: '$pendingApprove',
          icon: Icons.rule_folder_outlined,
          accent: Colors.orange,
        ),
        _KpiTile(
          title: 'En ejecución',
          valueText: '$inProgress',
          icon: Icons.playlist_add_check_circle_outlined,
          accent: Colors.teal,
        ),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String title;
  final String valueText;
  final IconData icon;
  final Color accent;

  const _KpiTile({
    super.key,
    required this.title,
    required this.valueText,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: accent.withOpacity(0.18),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(valueText,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== Análisis rápido (placeholder) ===================== */

class _AnalysisBlockPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget fakeChart(String title, String subtitle) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.30),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.labelMedium),
                ],
              ),
            ),
            const Center(
                child: Icon(Icons.show_chart, size: 64, color: Colors.black26)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Análisis rápido', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: fakeChart(
                    'Gasto por categoría', 'Barras apiladas · placeholder')),
            const SizedBox(width: 12),
            Expanded(
                child: fakeChart(
                    'Evolución mensual', 'Línea con proyección · placeholder')),
          ],
        ),
      ],
    );
  }
}

/* =================== Comparador (placeholder visible) =================== */

class _ComparatorPlaceholderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget card(String prov, String precio, String entrega) {
      return Container(
        width: 240,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(0.28),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prov,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Precio: $precio',
                style: Theme.of(context).textTheme.bodySmall),
            Text('Entrega: $entrega',
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FilledButton.icon(
                onPressed: () =>
                    Get.snackbar('Comparador', 'Elegir $prov (demo)'),
                icon: const Icon(Icons.check_circle),
                label: const Text('Elegir'),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => [
          card('Proveedor A', '\$ 1.950.000', '2 días'),
          card('Proveedor B', '\$ 2.050.000', '1 día'),
          card('Proveedor C', '\$ 1.980.000', '3 días'),
        ][i],
      ),
    );
  }
}

/* ================== Recurrentes (placeholder visible) ================== */

class _RecurringPlaceholderGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget card(String nombre, String prov, String vence) {
      return Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(0.28),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo.withOpacity(0.15),
              child: const Icon(Icons.autorenew, color: Colors.indigo),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombre,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  Text(prov, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text('Vence: $vence',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Switch(
                value: true,
                onChanged: (_) =>
                    Get.snackbar('Recurrente', 'Toggle $nombre (demo)')),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        card('SOAT Taxi 001', 'Seguros Andina', '25 días'),
        card('Mantenimiento planificado', 'Taller Express', '10 días'),
        card('Hosting facturación', 'HostCo', '5 días'),
      ],
    );
  }
}

/* ======================= Helpers visuales ======================= */

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionHeader(
      {required this.title, this.actionText, this.onAction, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w900)),
        const Spacer(),
        if (actionText != null && onAction != null)
          TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.chevron_right),
              label: Text(actionText!)),
      ],
    );
  }
}

class _EmptyHintCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onAction;

  const _EmptyHintCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionText)),
        ],
      ),
    );
  }
}

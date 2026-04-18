// ============================================================================
// lib/presentation/pages/admin/network/owner_detail_page.dart
// OWNER DETAIL PAGE — Ficha de propietario en "Mi red operativa"
//
// QUÉ HACE:
// - Muestra la ficha completa de un propietario: identidad, resumen,
//   estado de licencia/SIMIT y portafolios asociados.
// - Permite navegar al detalle de licencia y SIMIT (páginas existentes).
// - Permite navegar a cada portafolio asociado (flujo existente).
//
// QUÉ NO HACE:
// - No persiste datos ni accede directamente a repositorios.
// - No muestra contacto ni acciones de comunicación (Sprint 2+).
// - No tiene controller propio — todos los datos vienen del [OwnerNetworkVm]
//   recibido por arguments.
//
// PRINCIPIOS:
// - Stateless: recibe OwnerNetworkVm via Get.arguments['owner'].
// - El VrcDataModel para detalle se construye desde el portfolio más reciente
//   del propietario — mismo patrón que _buildSnapshotVrcData en
//   portfolio_asset_list_page.dart.
// - Theme-first: colores y estilos desde ColorScheme/TextTheme.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Sprint 1 módulo "Mi red operativa" — Propietarios.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/vrc/models/vrc_models.dart';
import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../../routes/app_routes.dart';
import '../../../view_models/network/owner_network_vm.dart';

class OwnerDetailPage extends StatelessWidget {
  const OwnerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final owner = args?['owner'] as OwnerNetworkVm?;

    if (owner == null) {
      // Guard: nunca debería ocurrir con la navegación correcta.
      return const Scaffold(
        body: Center(child: Text('Propietario no disponible')),
      );
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          owner.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        children: [
          // ── Header: avatar + identidad ───────────────────────────────────
          _OwnerDetailHeader(owner: owner),

          // ── Resumen: portafolios + última consulta ───────────────────────
          _OwnerSummaryRow(owner: owner),

          const Divider(height: 1),

          // ── Estado: licencia + SIMIT ─────────────────────────────────────
          _OwnerStatusBand(owner: owner),

          const Divider(height: 1),

          // ── Portafolios asociados ────────────────────────────────────────
          _OwnerPortfoliosList(portfolios: owner.portfolios),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _OwnerDetailHeader extends StatelessWidget {
  final OwnerNetworkVm owner;

  const _OwnerDetailHeader({required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final initials = _initials(owner.name);
    final docText = _docText(owner);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: cs.primaryContainer,
            child: Text(
              initials,
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (docText != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    docText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.elementAt(1)[0]).toUpperCase();
  }

  String? _docText(OwnerNetworkVm o) {
    final type = o.documentType?.trim().toUpperCase();
    final doc = o.document.trim();
    if (doc.isEmpty) return null;
    if (type != null && type.isNotEmpty) return '$type $doc';
    return doc;
  }
}

// ── Fila de resumen ───────────────────────────────────────────────────────────

class _OwnerSummaryRow extends StatelessWidget {
  final OwnerNetworkVm owner;

  const _OwnerSummaryRow({required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final checkedText = owner.lastUpdated != null
        ? 'Consultado ${_formatDate(owner.lastUpdated!)}'
        : 'Sin consulta VRC registrada';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          _SummaryChip(
            icon: Icons.folder_outlined,
            label:
                '${owner.portfolioCount} ${owner.portfolioCount == 1 ? 'portafolio' : 'portafolios'}',
            cs: cs,
            theme: theme,
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.schedule_rounded,
            label: checkedText,
            cs: cs,
            theme: theme,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString().substring(2);
    return '$dd/$mm/$yy';
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.cs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ── Banda de estado (licencia + SIMIT) ────────────────────────────────────────

/// Muestra los dos tiles de estado del propietario: licencia y SIMIT.
///
/// Construye un [VrcDataModel] mínimo desde el portfolio más reciente del
/// propietario — mismo patrón que _buildSnapshotVrcData en
/// portfolio_asset_list_page.dart. Las páginas de detalle manejan
/// datos ausentes defensivamente.
class _OwnerStatusBand extends StatelessWidget {
  final OwnerNetworkVm owner;

  const _OwnerStatusBand({required this.owner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado del propietario',
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatusTile(
                  icon: Icons.credit_card_outlined,
                  label: 'Licencia',
                  value: owner.licenseStatus ?? 'Sin información',
                  valueColor: _licenseColor(cs, owner.licenseStatus),
                  onTap: () => Get.toNamed(
                    Routes.driverLicenseDetail,
                    arguments: {
                      'data': _buildVrcData(),
                      'checkedAt': owner.lastUpdated,
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'SIMIT',
                  value: _simitValue(),
                  valueColor:
                      owner.simitHasFines == true ? cs.error : null,
                  onTap: () => Get.toNamed(
                    Routes.simitPersonDetail,
                    arguments: {
                      'data': _buildVrcData(),
                      'checkedAt': owner.lastUpdated,
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye VrcDataModel mínimo desde el portfolio más reciente.
  ///
  /// Los arrays de detalle (fines[]) quedan vacíos — las páginas de detalle
  /// los manejan defensivamente (empty state sin crash).
  VrcDataModel _buildVrcData() {
    // portfolios ya están ordenados por simitCheckedAt desc en el mapper.
    final p = owner.portfolios.isNotEmpty ? owner.portfolios.first : null;

    return VrcDataModel(
      owner: VrcOwnerModel(
        name: owner.name,
        document: owner.document,
        documentType: owner.documentType,
        runt: (p?.licenseStatus != null)
            ? VrcOwnerRuntModel(
                licenses: [
                  VrcLicenseModel(
                    status: p!.licenseStatus,
                    expiryDate: p.licenseExpiryDate,
                  ),
                ],
              )
            : null,
        simit: (p?.simitHasFines != null)
            ? VrcOwnerSimitModel(
                summary: _buildSimitSummary(p!),
              )
            : null,
      ),
    );
  }

  VrcSimitSummaryModel? _buildSimitSummary(PortfolioEntity p) {
    if (p.simitHasFines == null) return null;
    return VrcSimitSummaryModel(
      hasFines: p.simitHasFines,
      finesCount: p.simitFinesCount,
      comparendos: p.simitComparendosCount,
      multas: p.simitMultasCount,
      formattedTotal: p.simitFormattedTotal,
    );
  }

  Color? _licenseColor(ColorScheme cs, String? status) {
    if (status == null) return null;
    final n = status.toLowerCase();
    if (n.contains('vig') || n.contains('activ')) return Colors.green.shade600;
    if (n.contains('venc') || n.contains('suspend')) return cs.error;
    return null;
  }

  String _simitValue() {
    if (owner.simitHasFines == false) return 'Sin multas';
    return owner.simitFormattedTotal ?? 'Ver detalle';
  }
}

// ── Tile de estado (reutilizable en la ficha) ─────────────────────────────────

class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _StatusTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainer,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 13, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  if (onTap != null) ...[
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: cs.primary.withValues(alpha: 0.75),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: valueColor ?? cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Lista de portafolios asociados ─────────────────────────────────────────────

class _OwnerPortfoliosList extends StatelessWidget {
  final List<PortfolioEntity> portfolios;

  const _OwnerPortfoliosList({required this.portfolios});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (portfolios.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Portafolios asociados',
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...portfolios.map((p) => _PortfolioMiniCard(portfolio: p)),
      ],
    );
  }
}

class _PortfolioMiniCard extends StatelessWidget {
  final PortfolioEntity portfolio;

  const _PortfolioMiniCard({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: cs.secondaryContainer,
        child: Icon(
          _portfolioIcon(portfolio.portfolioType),
          color: cs.onSecondaryContainer,
          size: 18,
        ),
      ),
      title: Text(
        portfolio.portfolioName,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${portfolio.assetsCount} ${portfolio.assetsCount == 1 ? 'activo' : 'activos'}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      onTap: () => Get.toNamed(Routes.portfolioAssets, arguments: portfolio),
    );
  }

  IconData _portfolioIcon(PortfolioType type) {
    switch (type) {
      case PortfolioType.vehiculos:
        return Icons.directions_car_outlined;
      case PortfolioType.inmuebles:
        return Icons.home_outlined;
      case PortfolioType.operacionGeneral:
        return Icons.work_outline;
    }
  }
}

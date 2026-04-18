// ============================================================================
// lib/presentation/widgets/portfolio/owner_snapshot_band.dart
// OWNER SNAPSHOT BAND — Widget compartido (Presentation / Widgets / Portfolio)
//
// QUÉ HACE:
// - Renderiza la banda/grid del propietario VRC con datos de licencia y SIMIT.
// - Fuente de datos: PortfolioEntity (snapshot persistido en Isar).
// - Provee contrato único de visibilidad via [isAvailable] y de render para
//   evitar divergencia entre portfolio_asset_live_page y portfolio_asset_list_page.
// - Tiles tappable: navega a detalle de licencia o SIMIT cuando hay datos.
//
// QUÉ NO HACE:
// - No muestra datos live del batch (eso es responsabilidad de _OwnerHeader
//   en portfolio_asset_live_page).
// - No persiste datos — solo consume PortfolioEntity ya guardada.
// - No depende de VrcBatchController ni de estado vivo de sesión.
//
// PRINCIPIOS:
// - Single Source of Truth: visibilidad decidida por [isAvailable], no por
//   cada página de forma independiente.
// - Isar-backed: el portfolio DEBE provenir de Isar (stream o lectura directa),
//   nunca de Get.arguments congelado.
// - Self-contained: no depende de widgets privados de otras páginas.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Unificación de _OwnerContextBand (list page) y
//   _OwnerSnapshotBand (live page) para eliminar divergencia de contrato.
// ============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/vrc/models/vrc_models.dart';
import '../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../routes/app_pages.dart';

/// Banda compacta con datos del propietario VRC: nombre, documento, licencia y SIMIT.
///
/// Consume exclusivamente [PortfolioEntity] (snapshot Isar). Para datos live del
/// batch VRC, usar _OwnerHeader en portfolio_asset_live_page.
///
/// Contrato de visibilidad canónico: usar [isAvailable] antes de instanciar.
class OwnerSnapshotBand extends StatelessWidget {
  final PortfolioEntity portfolio;

  const OwnerSnapshotBand({super.key, required this.portfolio});

  /// Contrato canónico de visibilidad del bloque owner/licencia/SIMIT.
  ///
  /// Retorna true si el portfolio tiene AL MENOS un campo del snapshot
  /// disponible. Condición amplia: cualquier campo no-null es suficiente.
  /// Usado por live page (fallback) y list page para decidir si mostrar la banda.
  static bool isAvailable(PortfolioEntity? portfolio) {
    if (portfolio == null) return false;
    return portfolio.ownerName != null ||
        portfolio.licenseStatus != null ||
        portfolio.simitHasFines != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final docDisplay = _formatOwnerDoc(portfolio);

    return Container(
      color: cs.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del propietario
          if (portfolio.ownerName != null)
            Text(
              portfolio.ownerName!,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (docDisplay != null) ...[
            const SizedBox(height: 2),
            Text(
              docDisplay,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          // Grid 2-up: Licencia y SIMIT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OwnerInfoTile(
                  icon: Icons.credit_card_outlined,
                  label: 'Licencia',
                  value: portfolio.licenseStatus ?? 'Sin información',
                  valueColor:
                      _licenseColorFromStatus(cs, portfolio.licenseStatus),
                  subtitle: portfolio.licenseExpiryDate != null
                      ? 'Vence ${portfolio.licenseExpiryDate}'
                      : null,
                  onTap: portfolio.licenseStatus != null
                      ? () => Get.toNamed(
                            Routes.driverLicenseDetail,
                            arguments: {
                              'data': _buildSnapshotVrcData(),
                              'checkedAt': portfolio.licenseCheckedAt ??
                                  portfolio.simitCheckedAt,
                              'portfolioId': portfolio.id,
                            },
                          )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OwnerInfoTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'SIMIT',
                  value: _simitValueText(portfolio),
                  valueColor:
                      portfolio.simitHasFines == true ? cs.error : null,
                  subtitle: _simitSubtitleText(portfolio),
                  onTap: portfolio.simitHasFines != null
                      ? () => Get.toNamed(
                            Routes.simitPersonDetail,
                            arguments: {
                              'data': _buildSnapshotVrcData(),
                              'checkedAt': portfolio.simitCheckedAt,
                              'portfolioId': portfolio.id,
                            },
                          )
                      : null,
                ),
              ),
            ],
          ),
          // Nota de antigüedad del snapshot
          if (portfolio.simitCheckedAt != null) ...[
            const SizedBox(height: 6),
            Text(
              'Última consulta · ${_formatCheckedAt(portfolio.simitCheckedAt!)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Helpers de formato ──────────────────────────────────────────────────────

  String? _formatOwnerDoc(PortfolioEntity p) {
    final type = p.ownerDocumentType?.trim().toUpperCase();
    final number = p.ownerDocument?.trim();
    if (type == null || type.isEmpty || number == null || number.isEmpty) {
      return null;
    }
    return '$type $number';
  }

  Color? _licenseColorFromStatus(ColorScheme cs, String? status) {
    if (status == null) return null;
    final norm = status.toLowerCase();
    if (norm.contains('vig') || norm.contains('activ')) {
      return Colors.green.shade600;
    }
    if (norm.contains('venc') || norm.contains('suspend')) return cs.error;
    return cs.onSurfaceVariant;
  }

  String _simitValueText(PortfolioEntity p) {
    if (p.simitHasFines == false) return 'Sin multas';
    return p.simitFormattedTotal ?? 'Ver detalle';
  }

  String? _simitSubtitleText(PortfolioEntity p) {
    if (p.simitHasFines != true) return null;
    final comparendos = p.simitComparendosCount;
    final multas = p.simitMultasCount;
    if (comparendos == null && multas == null) return null;
    final parts = <String>[];
    if (comparendos != null) {
      parts.add('$comparendos comparendo${comparendos != 1 ? 's' : ''}');
    }
    if (multas != null) {
      parts.add('$multas multa${multas != 1 ? 's' : ''}');
    }
    return parts.join(' · ');
  }

  String _formatCheckedAt(DateTime dt) {
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString().substring(2);
    return '$dd/$mm/$yy';
  }

  // ── Builders de VrcDataModel para navegación a detalle ───────────────────────

  /// Construye un [VrcDataModel] desde el snapshot de Isar para navegación.
  ///
  /// Estrategia de rehidratación:
  /// 1. Si [simitDetailJson] existe → deserializar blob completo (summary + fines[]).
  /// 2. Si no existe (registro legacy) → construir modelo mínimo desde escalares.
  ///
  /// Se llama DENTRO de los lambdas onTap (no en cada build) → costo cero
  /// en renders; la deserialización ocurre solo cuando el usuario toca.
  VrcDataModel _buildSnapshotVrcData() {
    return VrcDataModel(
      owner: VrcOwnerModel(
        name: portfolio.ownerName,
        document: portfolio.ownerDocument,
        documentType: portfolio.ownerDocumentType,
        runt: portfolio.licenseStatus != null
            ? VrcOwnerRuntModel(
                licenses: [
                  VrcLicenseModel(
                    status: portfolio.licenseStatus,
                    expiryDate: portfolio.licenseExpiryDate,
                  ),
                ],
              )
            : null,
        simit: _buildSnapshotSimit(),
      ),
    );
  }

  /// Rehidrata [VrcOwnerSimitModel] desde blob JSON si existe, o construye
  /// modelo mínimo desde campos escalares (fallback legacy).
  VrcOwnerSimitModel? _buildSnapshotSimit() {
    // Ruta 1: blob completo disponible → deserializar (incluye fines[]).
    final blob = portfolio.simitDetailJson;
    if (blob != null && blob.isNotEmpty) {
      try {
        final json = jsonDecode(blob) as Map<String, dynamic>;
        return VrcOwnerSimitModel.fromJson(json);
      } catch (_) {
        // Blob corrupto — fallback a escalares.
      }
    }

    // Ruta 2: fallback legacy — solo summary desde campos escalares.
    if (portfolio.simitHasFines == null) return null;
    return VrcOwnerSimitModel(
      summary: VrcSimitSummaryModel(
        hasFines: portfolio.simitHasFines,
        finesCount: portfolio.simitFinesCount,
        comparendos: portfolio.simitComparendosCount,
        multas: portfolio.simitMultasCount,
        formattedTotal: portfolio.simitFormattedTotal,
      ),
    );
  }
}

// ── _OwnerInfoTile ─────────────────────────────────────────────────────────────
// Tile/card compacto para el snapshot del propietario.
// onTap opcional — cuando se proporciona, muestra chevron y efecto ripple.

class _OwnerInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const _OwnerInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.subtitle,
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
              // Fila de etiqueta con ícono y chevron opcional
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
              // Valor principal
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: valueColor ?? cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Segunda línea opcional
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

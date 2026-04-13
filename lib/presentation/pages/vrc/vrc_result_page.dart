// ============================================================================
// lib/presentation/pages/vrc/vrc_result_page.dart
// VRC RESULT PAGE — Presentation Layer / UI
//
// QUÉ HACE:
// - Pantalla canónica de resultado VRC Individual en modo dual:
//   · Standalone (onRegister==null): consulta directa desde VrcConsultPage.
//   · Registro (onRegister!=null): gate del flujo de registro de activos.
// - Renderiza banners operativos según businessDecision (APPROVE/REVIEW/REJECT).
// - Muestra acordeón de propietario, SIMIT, licencias (PERSON) y diagnóstico.
// - Gestiona footer diferenciado por modo y por estado operativo.
//
// QUÉ NO HACE:
// - No ejecuta la consulta HTTP (eso es VrcConsultPage + VrcController).
// - No toma decisiones de negocio (eso es VrcRules).
// - No modifica RUNT Batch pages (REGLA DE INMUTABILIDAD).
//
// PRINCIPIOS:
// - Lee VrcController via Get.find (fenix:true garantiza persistencia).
// - Usa canProceedAutomatically para el botón de registro.
//   NUNCA derivar permiso de viewState == success.
// - meta.sources SOLO en sección colapsable "Diagnóstico técnico".
// - Dual-mode via onRegister: VoidCallback?
//   (null=standalone, non-null=registro).
//
// ALINEACIÓN VISUAL — DOCUMENTACIÓN OBLIGATORIA:
//
// REUTILIZADO directamente (widget público compartido):
//   · VehicleSummaryWidget → header del vehículo.
//
// REPLICADO fielmente (privado en RUNT, no extractable sin riesgo):
//   · _DataExpandableCard → _VrcExpandableCard
//     (Container borderRadius:20, border outlineVariant 0.45,
//      Theme dividerColor:transparent, ExpansionTile tilePadding 16/10,
//      leading container 48x48 borderRadius:12, title titleSmall w700,
//      subtitle bodySmall onSurfaceVariant, childrenPadding:zero)
//   · _InfoRow → _VrcInfoRow
//     (padding h16/v14, flex 4:6, label labelMedium onSurfaceVariant,
//      value bodyMedium w700 onSurface, divider outlineVariant 0.28)
//   · _LegalBadge → _VrcBanner
//     (color.withValues alpha:0.08 bg, border alpha:0.22,
//      icon 16, labelMedium w600, full-width extendido para VRC)
//   · _ActionFooter RUNT → _VrcActionFooter
//     (FilledButton.icon h:56, OutlinedButton.icon h:52, TextButton,
//      SizedBox width:double.infinity para ambos botones)
//   · _FailedView/_ConnectionInterruptedView (progress) → _VrcErrorView
//     (Container circle errorContainer, icon 60, headlineSmall w800,
//      bodyLarge onSurfaceVariant height:1.45, padding all:28)
//   · Sliver layout → CustomScrollView BouncingScrollPhysics +
//     SliverToBoxAdapter + SliverPadding fromLTRB(16,12,16,0) / (20,20,20,32)
//
// HARDCODES VISUALES ELIMINADOS (respecto a versión anterior):
//   · Colors.red              → colors.error
//   · Colors.green            → colors.primary
//   · Colors.amber.shade700   → colors.tertiary
//   · Colors.orange (degraded)→ const Color(0xFFF57C00) (alineado con
//                                _progressColor RUNT: 1–29 días)
//   · Colors.blueGrey (info)  → colors.secondary
//   · Colors.black54          → colors.onSurfaceVariant
//   · Colors.grey             → colors.outline / colors.onSurfaceVariant
//   · Colors.grey.shade50     → colors.surfaceContainerLow
//   · TextStyle(fontSize:N)   → textTheme.bodySmall/bodyMedium/labelMedium/
//                                titleSmall/headlineSmall/bodyLarge
//   · Card() sin configuración→ Container colors.surface + borderRadius(20)
//   · Colors.red.shade50      → colors.errorContainer
//   · Colors.green.shade50    → colors.primaryContainer
//
// CONSISTENCIA SIN TOCAR RUNT BATCH:
//   · Todos los cambios están exclusivamente en este archivo.
//   · _DataExpandableCard, _InfoRow, _ActionFooter de runt_query_result_page.dart
//     no fueron modificados — se replicó el patrón, no se importó.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 1 — standalone básico.
// EVOLUCIONADO (2026-04): Opción A — pantalla canónica dual-mode con
// alineación visual consolidada al ecosistema RUNT.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/vrc/models/vrc_models.dart';
import '../../../data/vrc/vrc_extensions.dart';
import '../../../data/vrc/vrc_rules.dart';
import '../../controllers/vrc/vrc_controller.dart';
import '../../widgets/asset/vehicle/vehicle_summary_widget.dart';

// ── Formateo COP ──────────────────────────────────────────────────────────────

/// Formatea un valor numérico como moneda COP.
/// Ej: 633105 → "\$ 633.105"
String _formatCop(num amount) {
  return NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$ ',
    decimalDigits: 0,
  ).format(amount);
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────

/// Página de resultado VRC en modo dual.
///
/// - [onRegister] == null → modo standalone (consulta directa).
/// - [onRegister] != null → modo registro (gate del flujo de activos).
class VrcResultPage extends StatelessWidget {
  /// Callback invocado cuando el usuario confirma el registro.
  /// null = modo standalone (sin botón de registro).
  final VoidCallback? onRegister;

  const VrcResultPage({super.key, this.onRegister});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VrcController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      appBar: AppBar(
        title: Text(onRegister != null ? 'Verificación VRC' : 'Resultado VRC'),
        centerTitle: true,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(onPressed: () {
          controller.reset();
          Get.back();
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Nueva consulta',
            onPressed: () {
              controller.reset();
              Get.back();
            },
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.viewState;
        final result = controller.result;

        switch (state) {
          case VrcViewState.idle:
          case VrcViewState.loading:
            // Estado transitorio — VrcConsultPage no navega aquí sin resultado.
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );

          case VrcViewState.failed:
            return _VrcErrorView(
              icon: Icons.error_outline_rounded,
              isError: true,
              title: 'Error al verificar',
              message: controller.errorMessage ??
                  'No fue posible completar la verificación VRC. '
                      'El servicio puede no estar disponible.',
              actionLabel: 'NUEVA CONSULTA',
              onAction: () {
                controller.reset();
                Get.back();
              },
            );

          case VrcViewState.timeout:
            return _VrcErrorView(
              icon: Icons.timer_off_rounded,
              isError: false,
              title: 'Tiempo de espera agotado',
              message: controller.errorMessage ??
                  'La verificación tardó más de lo esperado. '
                      'El servidor puede estar procesando — intenta de nuevo.',
              actionLabel: 'REINTENTAR',
              onAction: () {
                controller.reset();
                Get.back();
              },
            );

          case VrcViewState.success:
          case VrcViewState.degraded:
            if (result == null || result.data == null) {
              return _VrcErrorView(
                icon: Icons.search_off_rounded,
                isError: false,
                title: 'Sin datos disponibles',
                message: 'La verificación finalizó sin información utilizable.',
                actionLabel: 'NUEVA CONSULTA',
                onAction: () {
                  controller.reset();
                  Get.back();
                },
              );
            }
            return _VrcResultBody(
              response: result,
              controller: controller,
              onRegister: onRegister,
            );
        }
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESULT BODY — layout sliver (alineado con runt_query_result_page.dart)
// ─────────────────────────────────────────────────────────────────────────────

class _VrcResultBody extends StatelessWidget {
  final VrcResponseModel response;
  final VrcController controller;
  final VoidCallback? onRegister;

  const _VrcResultBody({
    required this.response,
    required this.controller,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final data = response.data!;
    final vehicle = data.vehicle;
    final owner = data.owner;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── 1. Vehicle Summary ─────────────────────────────────────────────
        // REUTILIZADO DIRECTAMENTE: VehicleSummaryWidget (widget público).
        // Campos disponibles en VrcVehicleModel: plate, make→brand,
        // line→model, modelYear (int→String), vehicleClass, service→serviceType.
        // Resto de campos (vin, engine, etc.) son null: widget los omite.
        if (vehicle != null)
          SliverToBoxAdapter(
            child: VehicleSummaryWidget(
              plate: vehicle.plate ?? '---',
              brand: vehicle.make,
              model: vehicle.line,
              modelYear: vehicle.modelYear?.toString(),
              vehicleClass: vehicle.vehicleClass,
              serviceType: vehicle.service,
            ),
          ),

        // ── 2. Estado del vehículo (si disponible) ─────────────────────────
        if (vehicle?.status != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _VrcStatusBadge(status: vehicle!.status!),
            ),
          ),

        // ── 3. Banners operativos ──────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _buildBannersSection(context, data),
          ),
        ),

        // ── 4. Propietario (acordeón) ──────────────────────────────────────
        if (owner != null)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _VrcOwnerCard(data: data),
            ),
          ),

        // ── 5. SIMIT (acordeón) ────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: _VrcSimitCard(data: data),
          ),
        ),

        // ── 6. Licencias RUNT (acordeón — solo PERSON) ────────────────────
        if (data.isPerson && (owner?.runt?.hasLicenses ?? false))
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _VrcLicensesCard(licenses: owner!.runt!.licenses!),
            ),
          ),

        // ── 7. Footer CTA (dual-mode) ──────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          sliver: SliverToBoxAdapter(
            child: _VrcActionFooter(
              data: data,
              onRegister: onRegister,
              onNewQuery: () {
                controller.reset();
                Get.back();
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Banners operativos ─────────────────────────────────────────────────────

  Widget _buildBannersSection(BuildContext context, VrcDataModel data) {
    final colors = Theme.of(context).colorScheme;
    final action = data.businessDecision?.action;
    final banners = <Widget>[];

    // Banner principal según businessDecision.
    // WARN → riesgo medio, registro permitido con advertencia (D1).
    if (VrcRules.shouldBlockRegistration(data)) {
      banners.add(_VrcBanner(
        icon: Icons.block_rounded,
        color: colors.error,
        title: 'Registro no permitido',
        message: action == 'REJECT'
            ? 'El vehículo no puede ser registrado según la consulta VRC.'
            : 'No se pudo determinar la situación del vehículo.',
      ));
    } else if (VrcRules.shouldRequireManualReview(data)) {
      banners.add(_VrcBanner(
        icon: Icons.manage_accounts_rounded,
        color: colors.tertiary,
        title: 'Requiere revisión manual',
        message:
            'Este caso debe ser revisado por un operador antes de continuar.',
      ));
    } else if (action == 'WARN') {
      // WARN: riesgo medio confirmado por backend — registro habilitado,
      // operador es responsable de la decisión.
      banners.add(const _VrcBanner(
        icon: Icons.warning_amber_rounded,
        color: Color(0xFFF57C00),
        title: 'Riesgo medio — procede con precaución',
        message: 'El vehículo tiene observaciones de riesgo medio. '
            'Puedes registrarlo, pero queda constancia de esta advertencia.',
      ));
    } else if (VrcRules.isDegradedForUi(data)) {
      // Degradado por businessDecision == null u UNKNOWN (sin acción WARN explícita)
      banners.add(const _VrcBanner(
        icon: Icons.info_outline_rounded,
        color: Color(0xFFF57C00),
        title: 'Información incompleta',
        message: 'Algunos datos no estuvieron disponibles durante la consulta. '
            'Verifica manualmente antes de registrar.',
      ));
    } else {
      // APPROVE + LOW sin degradación
      banners.add(_VrcBanner(
        icon: Icons.check_circle_rounded,
        color: colors.primary,
        title: 'Vehículo aprobado',
        message: 'El vehículo cumple los criterios de registro.',
      ));
    }
    // NOTA: NO se agrega banner extra para SIMIT ausente.
    // isDegradedForUi ya captura ese caso; duplicar banners confunde al operador.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: banners,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BANNER OPERATIVO — replicado de _LegalBadge (runt_query_result_page.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Banner de decisión operativa VRC.
///
/// Visual: alineado con _LegalBadge de RUNT (color.withValues alpha:0.08/0.22)
/// pero extendido a full-width con icon-container y subtítulo descriptivo.
class _VrcBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const _VrcBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container — alineado con leading de _DataExpandableCard
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: color.withValues(alpha: 0.85),
                    height: 1.35,
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

// ─────────────────────────────────────────────────────────────────────────────
// STATUS BADGE — estado del vehículo (RUNT vehicle.status)
// ─────────────────────────────────────────────────────────────────────────────

/// Badge compacto para el estado RUNT del vehículo (ej. ACTIVO, EN TRÁMITE).
///
/// Visual: alineado con _LegalBadge RUNT (mainAxisSize.min, icon 16, labelMedium w600).
class _VrcStatusBadge extends StatelessWidget {
  final String status;
  const _VrcStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isActive =
        status.toUpperCase() == 'ACTIVO' || status.toUpperCase() == 'ACTIVE';
    final color = isActive ? colors.primary : colors.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Estado RUNT: ${status.toUpperCase()}',
              style: textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD EXPANDABLE VRC — replicado de _DataExpandableCard (RUNT result page)
// ─────────────────────────────────────────────────────────────────────────────

/// Card expandible genérico para propietario, SIMIT, licencias y diagnóstico.
///
/// Patrón idéntico a _DataExpandableCard de runt_query_result_page.dart:
/// Container borderRadius:20, border outlineVariant 0.45, Theme dividerColor
/// transparent, ExpansionTile tilePadding 16/10, leading 48x48 borderRadius:12.
class _VrcExpandableCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String closedSubtitle;
  final Color? iconColorOverride;
  final List<Widget> expandedChildren;

  const _VrcExpandableCard({
    required this.title,
    required this.icon,
    required this.closedSubtitle,
    required this.expandedChildren,
    this.iconColorOverride,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconColor = iconColorOverride ?? colors.secondary;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // Elimina el divider automático de ExpansionTile — igual que RUNT
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            closedSubtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1),
            if (expandedChildren.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.inbox_rounded, size: 18, color: colors.outline),
                    const SizedBox(width: 8),
                    Text(
                      'Sin datos disponibles',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              )
            else
              ...expandedChildren,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO ROW VRC — replicado de _InfoRow (runt_query_result_page.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Fila label:valor para cards expandibles.
///
/// Patrón idéntico a _InfoRow de runt_query_result_page.dart:
/// padding h16/v14, flex 4:6, labelMedium onSurfaceVariant,
/// bodyMedium w700 onSurface, divider outlineVariant alpha:0.28.
class _VrcInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final bool isWarning;

  /// Color explícito para el valor — si se pasa, tiene precedencia sobre isWarning.
  final Color? statusColor;

  const _VrcInfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
    this.isWarning = false,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final valueColor =
        statusColor ?? (isWarning ? const Color(0xFFF57C00) : colors.onSurface);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.28),
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: textTheme.labelMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value.toUpperCase(),
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD PROPIETARIO
// ─────────────────────────────────────────────────────────────────────────────

class _VrcOwnerCard extends StatelessWidget {
  final VrcDataModel data;
  const _VrcOwnerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final owner = data.owner!;
    final rows = <_VrcInfoRow>[];

    rows.add(_VrcInfoRow(label: 'Tipo', value: data.ownerDisplayType));
    if (owner.name != null) {
      rows.add(_VrcInfoRow(label: 'Nombre', value: owner.name!));
    }
    if (owner.documentType != null && owner.document != null) {
      rows.add(_VrcInfoRow(
        label: 'Documento',
        value: '${owner.documentType} ${owner.document}',
      ));
    }
    if (data.hasRuntOwnerError) {
      rows.add(_VrcInfoRow(
        label: 'RUNT persona',
        value: owner.runt!.error!,
        isWarning: true,
        showDivider: false,
      ));
    } else if (rows.isNotEmpty) {
      // Quitar el divider del último row
      rows[rows.length - 1] = _VrcInfoRow(
        label: rows.last.label,
        value: rows.last.value,
        showDivider: false,
        isWarning: rows.last.isWarning,
      );
    }

    final subtitle = owner.name != null
        ? '${data.ownerDisplayType} · ${owner.name}'
        : data.ownerDisplayType;

    return _VrcExpandableCard(
      title: 'Propietario',
      icon: data.isCompany ? Icons.business_rounded : Icons.person_rounded,
      closedSubtitle: subtitle,
      expandedChildren: rows,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD SIMIT
// ─────────────────────────────────────────────────────────────────────────────

class _VrcSimitCard extends StatelessWidget {
  final VrcDataModel data;
  const _VrcSimitCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final summary = data.owner?.simit?.summary;

    if (summary == null) {
      // SIMIT no disponible — NUNCA mostrar "sin multas"
      return _VrcExpandableCard(
        title: 'SIMIT — Multas',
        icon: Icons.traffic_rounded,
        closedSubtitle: 'Información no disponible',
        iconColorOverride: colors.outline,
        expandedChildren: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 18, color: colors.outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'La información de multas no estuvo disponible durante esta consulta.',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final hasFines = summary.hasFines ?? false;
    // Priorizar formattedTotal del backend; si no viene, formatear COP localmente.
    final totalDisplay = summary.formattedTotal ??
        (summary.total != null ? _formatCop(summary.total!) : '—');
    final fineColor = hasFines ? colors.error : colors.primary;
    final subtitle =
        hasFines ? 'Con multas · $totalDisplay' : 'Sin multas registradas';

    final rows = <_VrcInfoRow>[];
    if (hasFines) {
      if (summary.formattedTotal != null) {
        rows.add(_VrcInfoRow(
            label: 'Total adeudado', value: summary.formattedTotal!));
      }
      if (summary.comparendos != null) {
        rows.add(
            _VrcInfoRow(label: 'Comparendos', value: '${summary.comparendos}'));
      }
      if (summary.multas != null) {
        rows.add(_VrcInfoRow(label: 'Multas', value: '${summary.multas}'));
      }
      if (summary.paymentAgreementsCount != null) {
        rows.add(_VrcInfoRow(
          label: 'Acuerdos de pago',
          value: '${summary.paymentAgreementsCount}',
          showDivider: false,
        ));
      }
    }

    return _VrcExpandableCard(
      title: 'SIMIT — Multas',
      icon: Icons.traffic_rounded,
      closedSubtitle: subtitle,
      iconColorOverride: fineColor,
      expandedChildren: [
        // Resumen visual destacado (equivalente al Container coloreado en v1)
        Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, hasFines ? 0 : 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: hasFines ? colors.errorContainer : colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  hasFines
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_rounded,
                  color: fineColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasFines
                        ? 'Tiene multas — Total: $totalDisplay'
                        : 'Sin multas registradas',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: fineColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasFines) ...[
          const SizedBox(height: 4),
          ...rows,
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD LICENCIAS (solo PERSON)
// ─────────────────────────────────────────────────────────────────────────────

class _VrcLicensesCard extends StatelessWidget {
  final List<VrcLicenseModel> licenses;
  const _VrcLicensesCard({required this.licenses});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Subtitle: estado de la primera licencia (más relevante que el conteo).
    // Si hay varias, agrega el total.
    final first = licenses.first;
    final firstStatus = first.status?.toUpperCase() ?? '—';
    final subtitle = licenses.length == 1
        ? firstStatus
        : '$firstStatus · ${licenses.length} licencias';

    final children = <Widget>[];
    for (int i = 0; i < licenses.length; i++) {
      final lic = licenses[i];
      final isLast = i == licenses.length - 1;

      // Determinar si el campo 'category' es en realidad el número de documento
      // (el backend VRC usa numero_licencia = número de cédula del titular).
      // Si coincide con el documento del propietario o es puramente numérico,
      // no se muestra como "Categoría" porque induce a error.
      final isDocNumber = lic.category != null &&
          RegExp(r'^\d+$').hasMatch(lic.category!.trim());

      // Color del estado según vigencia
      final isVencida = lic.status?.toUpperCase() == 'VENCIDA';
      final statusColor = isVencida ? colors.error : colors.primary;

      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categoría solo si es válida
                if (lic.category != null && !isDocNumber)
                  _VrcInfoRow(label: 'Categoría', value: lic.category!),

                // 1. PRIORIDAD: Vencimiento
                if (lic.expiryDate != null)
                  _VrcInfoRow(
                    label: 'Vencimiento',
                    value: lic.expiryDate!,
                  ),

                // 2. Estado (depende del vencimiento)
                if (lic.status != null)
                  _VrcInfoRow(
                    label: 'Estado',
                    value: lic.status!,
                    isWarning: isVencida,
                    statusColor: statusColor,
                  ),

                // 3. Expedición SOLO si no hay vencimiento
                if (lic.expiryDate == null && lic.issueDate != null)
                  _VrcInfoRow(
                    label: 'Expedición',
                    value: lic.issueDate!,
                    showDivider: false,
                  ),
              ],
            ),
          ),
        ),
      );

      if (!isLast) {
        children.add(Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: colors.outlineVariant.withValues(alpha: 0.28),
        ));
      } else {
        children.add(const SizedBox(height: 12));
      }
    }

    return _VrcExpandableCard(
      title: 'Licencias de conducción',
      icon: Icons.credit_card_rounded,
      closedSubtitle: subtitle,
      expandedChildren: children,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION FOOTER — dual-mode (replicado de _ActionFooter RUNT result page)
// ─────────────────────────────────────────────────────────────────────────────

/// Footer CTA adaptado al modo y al estado operativo VRC.
///
/// Modo standalone (onRegister==null):
///   · Solo "NUEVA CONSULTA" (OutlinedButton.icon h:52).
///
/// Modo registro (onRegister!=null):
///   · FilledButton.icon h:56 principal (habilitado según canProceedAutomatically).
///   · Acciones secundarias según estado: REJECT→Nueva consulta,
///     REVIEW→Marcar para revisión + Nueva consulta, default→Nueva consulta.
///
/// Patrón de botones idéntico a _ActionFooter de runt_query_result_page.dart:
/// SizedBox(width:double.infinity, height:56/52), gap 14 entre botones, TextButton final.
class _VrcActionFooter extends StatelessWidget {
  final VrcDataModel data;
  final VoidCallback? onRegister;
  final VoidCallback onNewQuery;

  const _VrcActionFooter({
    required this.data,
    required this.onNewQuery,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final isBlocked = VrcRules.shouldBlockRegistration(data);
    final needsReview = VrcRules.shouldRequireManualReview(data);
    final canProceed = !isBlocked && !needsReview;

    if (onRegister == null) {
      // ── Modo standalone: solo "NUEVA CONSULTA" ────────────────────────────
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onNewQuery,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('NUEVA CONSULTA'),
            ),
          ),
        ],
      );
    }

    // ── Modo registro: botón principal + acciones secundarias ────────────────

    final String primaryLabel;
    final IconData primaryIcon;
    final VoidCallback? primaryAction;

    if (isBlocked) {
      primaryLabel = 'Registro no permitido';
      primaryIcon = Icons.block_rounded;
      primaryAction = null;
    } else if (needsReview) {
      primaryLabel = 'Revisión manual requerida';
      primaryIcon = Icons.manage_accounts_rounded;
      primaryAction = null;
    } else {
      primaryLabel = 'REGISTRAR VEHÍCULO EN AVANZZA';
      primaryIcon = Icons.check_rounded;
      primaryAction = canProceed ? onRegister : null;
    }

    return Column(
      children: [
        // Botón principal
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: primaryAction,
            icon: Icon(primaryIcon),
            label: Text(primaryLabel),
          ),
        ),

        // Acciones secundarias según estado operativo
        if (isBlocked) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: onNewQuery,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Nueva consulta'),
            ),
          ),
        ] else if (needsReview) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () => Get.snackbar(
                'Revisión manual',
                'Este vehículo requiere revisión por un operador.',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 4),
              ),
              icon: const Icon(Icons.manage_accounts_rounded),
              label: const Text('Marcar para revisión manual'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onNewQuery,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('NUEVA CONSULTA'),
            ),
          ),
        ] else ...[
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onNewQuery,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('NUEVA CONSULTA'),
            ),
          ),
        ],

        const SizedBox(height: 8),
        TextButton(
          onPressed: onNewQuery,
          child: const Text('VOLVER AL FORMULARIO'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR VIEW — replicado de _FailedView/_ConnectionInterruptedView (progress page)
// ─────────────────────────────────────────────────────────────────────────────

/// Vista de error para estados failed / timeout / sin datos.
///
/// Patrón idéntico a _FailedView de runt_query_progress_page.dart:
/// Container circle (errorContainer/tertiaryContainer), headlineSmall w800,
/// bodyLarge onSurfaceVariant height:1.45, padding all:28.
class _VrcErrorView extends StatelessWidget {
  final IconData icon;
  final bool isError;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _VrcErrorView({
    required this.icon,
    required this.isError,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final iconBg = isError ? colors.errorContainer : colors.tertiaryContainer;
    final iconColor = isError ? colors.error : colors.tertiary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: iconColor),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

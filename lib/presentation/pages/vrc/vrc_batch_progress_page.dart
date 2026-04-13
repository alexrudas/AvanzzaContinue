// // ============================================================================
// // lib/presentation/pages/vrc/vrc_batch_progress_page.dart
// // VRC BATCH PROGRESS PAGE — UI persona-céntrica de consulta VRC multi-placa
// //
// // QUÉ HACE:
// // - Muestra el informe VRC batch centrado en el PROPIETARIO y sus vehículos.
// // - Nivel 1 (Header): resumen del propietario — nombre, documento, estado
// //   personal, multas SIMIT, licencia, riskLevel/action.
// // - Nivel 2 (Lista): cada placa con estado de consulta (consulting/success/
// //   failed), marca/línea/modelo/servicio si ya están disponibles.
// // - Cancela el polling al hacer pop (PopScope.onPopInvokedWithResult).
// // - Muestra placeholder compacto mientras no hay ningún ítem succeeded.
// //
// // QUÉ NO HACE:
// // - No registra activos — esa acción la ejecuta AssetRegistrationController.
// // - No inicia la consulta batch — eso lo hace _handleConsult() antes de navegar.
// // - No repite datos de licencia/multas por vehículo — son del propietario.
// //
// // PRINCIPIOS:
// // - Persona-céntrica: owner data se muestra UNA VEZ en el header.
// // - Owner cacheado en controller (VrcBatchController.ownerData / _ownerCached):
// //   set-once en el primer ítem succeeded — nunca recalcula ni cambia de item.
// // - AnimatedSize en header: transición suave de placeholder → contenido.
// // - Obx granulares: header y lista reconstruyen de forma independiente.
// // - NO shimmer — placeholder compacto de altura fija para evitar layout jumps.
// //
// // ENTERPRISE NOTES:
// // EVOLUCIONADO (2026-04): Rediseño persona-céntrico Phase 2.
// // Fase 1 era placa-céntrica (solo lista de placas con estado).
// // ============================================================================

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../../data/vrc/models/vrc_models.dart';
// import '../../../domain/value/registration/vehicle_plate_item.dart';
// import '../../controllers/vrc/vrc_batch_controller.dart';
// import '../../widgets/asset/vehicle/plate_widget.dart';

// // ── Formateo COP ──────────────────────────────────────────────────────────────
// String _formatCop(num amount) => NumberFormat.currency(
//       locale: 'es_CO',
//       symbol: '\$ ',
//       decimalDigits: 0,
//     ).format(amount);

// // ─────────────────────────────────────────────────────────────────────────────
// // PAGE
// // ─────────────────────────────────────────────────────────────────────────────

// class VrcBatchProgressPage extends GetView<VrcBatchController> {
//   const VrcBatchProgressPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvokedWithResult: (_, __) => controller.cancelPolling(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Consulta VRC'),
//           centerTitle: false,
//         ),
//         body: Column(
//           children: [
//             // ── Barra de estado del batch ──────────────────────────────────
//             Obx(() => _BatchStatusBar(
//                   isCreating: controller.isCreating.value,
//                   overallStatus: controller.overallStatus.value,
//                   total: controller.totalCount,
//                   processing: controller.processingCount,
//                   succeeded: controller.succeededCount,
//                   failed: controller.failedCount,
//                 )),

//             // ── Error global (red/timeout) ─────────────────────────────────
//             Obx(() {
//               final err = controller.errorMessage.value;
//               if (err == null) return const SizedBox.shrink();
//               return _GlobalErrorBanner(message: err);
//             }),

//             // ── Cuerpo scrollable: header propietario + lista vehículos ────
//             Expanded(
//               child: CustomScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 slivers: [
//                   // Nivel 1 — Header del propietario
//                   SliverToBoxAdapter(
//                     child: Obx(() => _OwnerHeader(
//                           ownerData: controller.ownerData.value,
//                         )),
//                   ),

//                   // Nivel 2 — Lista de vehículos
//                   Obx(() {
//                     final items = controller.items;
//                     if (items.isEmpty) {
//                       return SliverFillRemaining(
//                         child: Center(
//                           child: Text(
//                             'Sin placas para consultar.',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onSurfaceVariant,
//                                 ),
//                           ),
//                         ),
//                       );
//                     }
//                     return SliverPadding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       sliver: SliverList.separated(
//                         itemCount: items.length,
//                         separatorBuilder: (_, __) => const Divider(
//                           height: 1,
//                           indent: 16,
//                           endIndent: 16,
//                         ),
//                         itemBuilder: (context, index) {
//                           final item = items[index];
//                           final vrc = controller.vehicleContexts[
//                               item.plate.toUpperCase()];
//                           return _VehicleTile(
//                             item: item,
//                             vehicleData: vrc?.vehicle,
//                           );
//                         },
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),

//         // ── CTA cuando el batch termina ────────────────────────────────────
//         bottomNavigationBar: Obx(() {
//           if (!controller.isTerminal) return const SizedBox.shrink();
//           return SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
//               child: FilledButton(
//                 onPressed: Get.back,
//                 child: const Text('Cerrar'),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BARRA DE ESTADO DEL BATCH (antes _SummarySection)
// // ─────────────────────────────────────────────────────────────────────────────

// class _BatchStatusBar extends StatelessWidget {
//   final bool isCreating;
//   final String overallStatus;
//   final int total;
//   final int processing;
//   final int succeeded;
//   final int failed;

//   const _BatchStatusBar({
//     required this.isCreating,
//     required this.overallStatus,
//     required this.total,
//     required this.processing,
//     required this.succeeded,
//     required this.failed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     final statusLabel = switch (overallStatus) {
//       'queued'              => 'En cola',
//       'running'             => 'Procesando',
//       'completed'           => 'Completado',
//       'partially_completed' => 'Parcialmente completado',
//       'failed'              => 'Fallido',
//       'cancelled'           => 'Cancelado',
//       _                     => isCreating ? 'Iniciando consulta…' : 'Consultando',
//     };

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//       color: colors.surfaceContainerLow,
//       child: Row(
//         children: [
//           if (isCreating || processing > 0) ...[
//             SizedBox(
//               width: 14,
//               height: 14,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: colors.primary,
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Expanded(
//             child: Text(
//               statusLabel,
//               style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
//             ),
//           ),
//           // Contadores compactos
//           _MiniStat(value: total, label: 'Total', color: colors.onSurfaceVariant),
//           const SizedBox(width: 12),
//           _MiniStat(value: succeeded, label: 'OK', color: Colors.green.shade700),
//           const SizedBox(width: 12),
//           _MiniStat(value: failed, label: 'Fallo', color: colors.error),
//         ],
//       ),
//     );
//   }
// }

// class _MiniStat extends StatelessWidget {
//   final int value;
//   final String label;
//   final Color color;

//   const _MiniStat({
//     required this.value,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           '$value',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w800,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HEADER DEL PROPIETARIO — Nivel 1
// // ─────────────────────────────────────────────────────────────────────────────

// /// Muestra los datos del propietario UNA VEZ en la parte superior.
// ///
// /// Mientras [ownerData] es null (ningún ítem succeeded aún) muestra un
// /// placeholder compacto de altura fija para evitar layout jumps.
// /// AnimatedSize anima la transición placeholder → contenido suavemente.
// class _OwnerHeader extends StatelessWidget {
//   final VrcDataModel? ownerData;
//   const _OwnerHeader({required this.ownerData});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSize(
//       duration: const Duration(milliseconds: 280),
//       curve: Curves.easeInOut,
//       alignment: Alignment.topCenter,
//       child: ownerData == null
//           ? _OwnerPlaceholder()
//           : _OwnerContent(data: ownerData!),
//     );
//   }
// }

// /// Placeholder compacto mientras no hay propietario disponible.
// ///
// /// Altura fija — no shimmer, no spinner, solo texto neutral.
// class _OwnerPlaceholder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         border: Border(
//           bottom: BorderSide(
//             color: colors.outlineVariant.withValues(alpha: 0.4),
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: colors.surfaceContainerHighest,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.person_outline_rounded,
//               size: 20,
//               color: colors.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'Cargando datos del propietario…',
//             style: textTheme.bodySmall?.copyWith(
//               color: colors.onSurfaceVariant,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Card con la información real del propietario.
// ///
// /// Máximo 5–6 líneas visuales: nombre, documento, estado RUNT,
// /// licencia, multas SIMIT, decisión de riesgo.
// class _OwnerContent extends StatelessWidget {
//   final VrcDataModel data;
//   const _OwnerContent({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//     final owner = data.owner;
//     final simit = owner?.simit?.summary;
//     final licenses = owner?.runt?.licenses;
//     final decision = data.businessDecision;

//     // ── Colores semánticos de riesgo ──────────────────────────────────────
//     final Color riskColor = switch (decision?.riskLevel?.toUpperCase()) {
//       'HIGH'   => colors.error,
//       'MEDIUM' => const Color(0xFFF57C00),
//       'LOW'    => Colors.green.shade700,
//       _        => colors.onSurfaceVariant,
//     };

//     final bool hasDebt =
//         simit?.hasFines == true || (simit?.total != null && simit!.total! > 0);
//     final bool hasExpiredLicense = licenses?.any((l) =>
//           l.status?.toUpperCase().contains('VENCID') == true ||
//           l.status?.toUpperCase().contains('SUSPENDID') == true) ==
//         true;

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: colors.outlineVariant.withValues(alpha: 0.45),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Fila: ícono + nombre + doc ─────────────────────────────────
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: colors.secondaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.person_rounded,
//                   size: 22,
//                   color: colors.onSecondaryContainer,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       owner?.name ?? '—',
//                       style: textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     if (owner?.documentType != null || owner?.document != null)
//                       Text(
//                         '${owner?.documentType ?? ''} ${owner?.document ?? ''}'
//                             .trim(),
//                         style: textTheme.bodySmall?.copyWith(
//                           color: colors.onSurfaceVariant,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               // ── Badge de decisión (riskLevel + action) ─────────────────
//               if (decision?.riskLevel != null)
//                 _RiskBadge(
//                   riskLevel: decision!.riskLevel!,
//                   action: decision.action,
//                   color: riskColor,
//                 ),
//             ],
//           ),

//           const SizedBox(height: 10),
//           const Divider(height: 1),
//           const SizedBox(height: 10),

//           // ── Fila: estado RUNT persona ──────────────────────────────────
//           if (owner?.runt?.error != null)
//             const _InfoRow(
//               icon: Icons.warning_amber_rounded,
//               iconColor: Color(0xFFF57C00),
//               label: 'RUNT persona',
//               value: 'Sin datos disponibles',
//             ),

//           // ── Fila: licencia ─────────────────────────────────────────────
//           if (licenses != null && licenses.isNotEmpty) ...[
//             _InfoRow(
//               icon: Icons.badge_outlined,
//               iconColor: hasExpiredLicense
//                   ? colors.error
//                   : Colors.green.shade700,
//               label: 'Licencia',
//               value: hasExpiredLicense
//                   ? 'Vencida / Suspendida'
//                   : 'Al día (${licenses.length} categoría${licenses.length > 1 ? 's' : ''})',
//             ),
//           ],

//           // ── Fila: multas SIMIT ─────────────────────────────────────────
//           if (simit != null) ...[
//             _InfoRow(
//               icon: hasDebt
//                   ? Icons.gavel_rounded
//                   : Icons.check_circle_outline_rounded,
//               iconColor: hasDebt ? colors.error : Colors.green.shade700,
//               label: 'Multas SIMIT',
//               value: hasDebt
//                   ? '${simit.comparendos ?? 0} comparendo${(simit.comparendos ?? 0) != 1 ? 's' : ''} · ${_formatCop(simit.total ?? 0)}'
//                   : 'Sin deudas registradas',
//             ),
//           ] else ...[
//             _InfoRow(
//               icon: Icons.help_outline_rounded,
//               iconColor: colors.onSurfaceVariant,
//               label: 'SIMIT',
//               value: 'Sin datos disponibles',
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// /// Badge compacto de riesgo (riskLevel + action).
// class _RiskBadge extends StatelessWidget {
//   final String riskLevel;
//   final String? action;
//   final Color color;

//   const _RiskBadge({
//     required this.riskLevel,
//     required this.action,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final label = switch (riskLevel.toUpperCase()) {
//       'HIGH'   => 'Alto riesgo',
//       'MEDIUM' => 'Riesgo medio',
//       'LOW'    => 'Sin riesgo',
//       _        => riskLevel,
//     };

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.10),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withValues(alpha: 0.25)),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }

// /// Fila de información compacta dentro del header del propietario.
// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String label;
//   final String value;

//   const _InfoRow({
//     required this.icon,
//     required this.iconColor,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final colors = Theme.of(context).colorScheme;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 15, color: iconColor),
//           const SizedBox(width: 6),
//           Text(
//             '$label: ',
//             style: textTheme.labelSmall?.copyWith(
//               color: colors.onSurfaceVariant,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: textTheme.labelSmall?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: iconColor,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BANNER DE ERROR GLOBAL
// // ─────────────────────────────────────────────────────────────────────────────

// class _GlobalErrorBanner extends StatelessWidget {
//   final String message;
//   const _GlobalErrorBanner({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       color: colors.errorContainer,
//       child: Row(
//         children: [
//           Icon(Icons.warning_amber_rounded, color: colors.error, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: TextStyle(
//                 color: colors.onErrorContainer,
//                 fontSize: 13,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TILE DE VEHÍCULO — Nivel 2
// // ─────────────────────────────────────────────────────────────────────────────

// /// Tile de vehículo en la lista.
// ///
// /// Muestra: PlateWidget + marca/línea/modelo/servicio (si disponibles) +
// /// indicador de estado de consulta.
// /// NO repite datos de licencia ni multas — esos están en el header.
// class _VehicleTile extends StatelessWidget {
//   final VehiclePlateItem item;

//   /// Datos del vehículo desde el context del backend, null mientras consulta.
//   final VrcVehicleModel? vehicleData;

//   const _VehicleTile({required this.item, this.vehicleData});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     final hasVehicle = vehicleData != null;
//     final subtitle = _buildSubtitle(vehicleData);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // ── PlateWidget semántico ────────────────────────────────────────
//           PlateWidget(
//             plate: item.plate,
//             serviceType: vehicleData?.service,
//             vehicleType: vehicleData?.vehicleClass,
//           ),

//           const SizedBox(width: 12),

//           // ── Info del vehículo ────────────────────────────────────────────
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (hasVehicle && subtitle.isNotEmpty)
//                   Text(
//                     subtitle,
//                     style: textTheme.bodySmall?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 if (hasVehicle && vehicleData?.status != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 2),
//                     child: Text(
//                       vehicleData!.status!.toUpperCase(),
//                       style: textTheme.labelSmall?.copyWith(
//                         color: vehicleData!.status!.toUpperCase() == 'ACTIVO'
//                             ? Colors.green.shade700
//                             : colors.onSurfaceVariant,
//                       ),
//                     ),
//                   ),
//                 if (!hasVehicle)
//                   Text(
//                     item.status == VehiclePlateStatus.failed
//                         ? (item.errorMessage ?? 'Consulta fallida')
//                         : 'Consultando…',
//                     style: textTheme.bodySmall?.copyWith(
//                       color: item.status == VehiclePlateStatus.failed
//                           ? colors.error
//                           : colors.onSurfaceVariant,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 8),

//           // ── Indicador de estado de consulta ───────────────────────────────
//           _StatusIndicator(status: item.status),
//         ],
//       ),
//     );
//   }

//   /// Construye la línea descriptiva del vehículo: "MARCA Línea · Año · Servicio".
//   String _buildSubtitle(VrcVehicleModel? v) {
//     if (v == null) return '';
//     final parts = <String>[
//       if (v.make != null && v.make!.isNotEmpty) v.make!,
//       if (v.line != null && v.line!.isNotEmpty) v.line!,
//       if (v.modelYear != null) v.modelYear.toString(),
//       if (v.service != null && v.service!.isNotEmpty) v.service!,
//     ];
//     return parts.join(' · ');
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INDICADOR DE ESTADO POR PLACA
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatusIndicator extends StatelessWidget {
//   final VehiclePlateStatus status;
//   const _StatusIndicator({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return switch (status) {
//       VehiclePlateStatus.consulting => SizedBox(
//           width: 20,
//           height: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2.5,
//             color: colors.primary,
//           ),
//         ),
//       VehiclePlateStatus.success => Icon(
//           Icons.check_circle_rounded,
//           color: Colors.green.shade700,
//           size: 24,
//         ),
//       VehiclePlateStatus.failed => Icon(
//           Icons.cancel_rounded,
//           color: colors.error,
//           size: 24,
//         ),
//       VehiclePlateStatus.partial => const Icon(
//           Icons.warning_amber_rounded,
//           color: Color(0xFFF57C00),
//           size: 24,
//         ),
//       VehiclePlateStatus.draft => Icon(
//           Icons.radio_button_unchecked_rounded,
//           color: colors.outline,
//           size: 24,
//         ),
//     };
//   }
// }

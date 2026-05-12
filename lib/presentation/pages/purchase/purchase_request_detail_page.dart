// ============================================================================
// lib/presentation/pages/purchase/purchase_request_detail_page.dart
// PURCHASE REQUEST DETAIL PAGE — UI del loop mono-workspace admin-captura
// ============================================================================
// QUÉ HACE:
//   - Pantalla de detalle de un PurchaseRequest existente.
//   - Orquesta el ciclo admin-captura:
//       [Header + estado] → [items] → [targets + cotizaciones] → [adjudicación]
//       → [documentos emitidos] → [cerrar PR]
//   - Cada paso consume PurchaseRequestDetailController y habilita el siguiente
//     SOLO cuando el backend responde con artefactos persistidos (no hay
//     "estados de éxito" inventados por UI).
//
// QUÉ NO HACE:
//   - No crea PurchaseRequests (sigue siendo wizard separado).
//   - No implementa cross-workspace, inbox receptor, invitación ni WhatsApp.
//
// PRINCIPIOS:
//   - Observa con Obx sobre estado reactivo del controller.
//   - Disable-aware: los botones se habilitan solo cuando el estado lo permite.
//   - Errores visibles: lastError se muestra en SnackBar.
//   - No UI-sugar: "Adjudicación confirmada" solo tras devolver award.id real.
//
// ENTERPRISE NOTES:
//   - CONTRACT de ruta: Get.toNamed(Routes.purchaseDetail, arguments: String id)
//     ó Get.toNamed(Routes.purchaseDetail + '?id=<uuid>').
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/purchase/award_entity.dart';
import '../../../domain/entities/purchase/purchase_request_detail_entity.dart';
import '../../../domain/entities/purchase/purchase_request_summary_entity.dart';
import '../../../domain/entities/purchase/quote_with_items_entity.dart';
import '../../../domain/repositories/purchase_repository.dart';
import '../../controllers/purchase/purchase_request_detail_controller.dart';

class PurchaseRequestDetailPage extends StatelessWidget {
  const PurchaseRequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PurchaseRequestDetailController>();
    _wireSnackbarOnError(c);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de pedido'),
        actions: [
          Obx(() => IconButton(
                tooltip: 'Refrescar',
                icon: c.loading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                onPressed:
                    c.loading.value ? null : () => c.refreshAll(),
              )),
        ],
      ),
      body: Obx(() {
        final detail = c.detail.value;
        if (c.loading.value && detail == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (detail == null) {
          return _EmptyDetail(onRetry: c.refreshAll);
        }
        return RefreshIndicator(
          onRefresh: c.refreshAll,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeaderSection(detail: detail, c: c),
              const SizedBox(height: 16),
              _ItemsSection(detail: detail),
              const SizedBox(height: 16),
              _QuotesSection(c: c),
              const SizedBox(height: 16),
              _AwardSection(c: c),
              const SizedBox(height: 16),
              _DocumentsSection(c: c),
              const SizedBox(height: 16),
              _CloseSection(c: c),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  /// Conecta lastError a un SnackBar único. Worker `ever` se limpia por GetX
  /// al destruir el controller (lifecycle suscrito al GetxController).
  void _wireSnackbarOnError(PurchaseRequestDetailController c) {
    c.lastError.listen((err) {
      if (err == null || err.isEmpty) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!Get.isSnackbarOpen) {
          Get.snackbar(
            'Error',
            err,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    });
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// HEADER (título + estado + resumen de completion)
// ═════════════════════════════════════════════════════════════════════════════

class _HeaderSection extends StatelessWidget {
  final PurchaseRequestDetailEntity detail;
  final PurchaseRequestDetailController c;

  const _HeaderSection({required this.detail, required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                _StatusChip(status: detail.status),
                const SizedBox(width: 8),
                Text(
                  'Origen: ${detail.originType} · Tipo: ${detail.type}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
            if (detail.notes != null) ...[
              const SizedBox(height: 8),
              Text(detail.notes!, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            Obx(() {
              final s = c.summary.value;
              if (s == null) return const SizedBox.shrink();
              return Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _Pill(label: 'Items: ${s.itemsCount}'),
                  _Pill(label: 'Cotizaciones: ${c.quotes.length}'),
                  _Pill(label: 'Awards: ${s.awardsCount}'),
                  _Pill(label: 'OC: ${s.purchaseOrdersCount}'),
                  _Pill(label: 'OT: ${s.workOrdersCount}'),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'closed' => Colors.grey,
      'responded' => Colors.green,
      'partially_responded' => Colors.orange,
      _ => Colors.blue,
    };
    return Chip(
      label: Text(status),
      visualDensity: VisualDensity.compact,
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ITEMS
// ═════════════════════════════════════════════════════════════════════════════

class _ItemsSection extends StatelessWidget {
  final PurchaseRequestDetailEntity detail;
  const _ItemsSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ítems (${detail.items.length})',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.items.map(
              (it) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(it.description),
                subtitle: Text('${it.quantity} ${it.unit} · ${it.fulfillmentType}'),
                trailing: Text(it.coverageStatus,
                    style: theme.textTheme.bodySmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// COTIZACIONES (con botón registrar)
// ═════════════════════════════════════════════════════════════════════════════

class _QuotesSection extends StatelessWidget {
  final PurchaseRequestDetailController c;
  const _QuotesSection({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Cotizaciones recibidas',
                      style: theme.textTheme.titleMedium),
                ),
                Obx(() => FilledButton.tonalIcon(
                      key: const Key('pr_detail.register_quote.btn'),
                      icon: c.submittingQuote.value
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.add_box_outlined),
                      label: const Text('Registrar'),
                      onPressed: c.submittingQuote.value ||
                              c.isRequestClosed ||
                              c.detail.value == null
                          ? null
                          : () => _RegisterQuoteSheet.show(context, c),
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (c.quotes.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Sin cotizaciones. Registra las ofertas que recibas off-platform.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                );
              }
              return Column(
                children: [
                  for (final q in c.quotes) _QuoteTile(quote: q, c: c),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _QuoteTile extends StatelessWidget {
  final QuoteWithItemsEntity quote;
  final PurchaseRequestDetailController c;
  const _QuoteTile({required this.quote, required this.c});

  @override
  Widget build(BuildContext context) {
    // Obx para reaccionar cuando `_hydrateVendorLabels` termina: el título
    // pasa del fallback opaco al displayName real + badge si está eliminado.
    return Obx(() {
      final resolved = _resolveVendorLabel(c, quote.vendorContactId);
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Flexible(child: Text(resolved.label)),
            if (resolved.deleted) ...[
              const SizedBox(width: 8),
              _DeletedBadge(),
            ],
          ],
        ),
        subtitle: Text(
          'Total: ${quote.total.toStringAsFixed(0)} ${quote.currency} · '
          '${quote.items.length} ítems',
        ),
        trailing: Text(
          quote.validUntil == null
              ? ''
              : 'Vence ${_fmtDate(quote.validUntil!)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    });
  }
}

/// Chip compacto "Eliminado" para indicar que el proveedor ya no está en el
/// directorio activo. Mantiene legibilidad del historial sin ambigüedad.
class _DeletedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Eliminado',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ADJUDICACIÓN (award)
// ═════════════════════════════════════════════════════════════════════════════

class _AwardSection extends StatelessWidget {
  final PurchaseRequestDetailController c;
  const _AwardSection({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Adjudicación', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Obx(() {
              final award = c.award.value;
              if (award != null) {
                return _AwardConfirmedCard(award: award);
              }
              final detail = c.detail.value;
              final noQuotes = c.quotes.isEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (noQuotes)
                    Text(
                      'Debes registrar al menos una cotización antes de adjudicar.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
                    )
                  else
                    Text(
                      'Selecciona el proveedor ganador por cada ítem.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor),
                    ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: const Key('pr_detail.create_award.btn'),
                    icon: c.creatingAward.value
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.gavel_outlined),
                    label: const Text('Adjudicar'),
                    onPressed: detail == null ||
                            noQuotes ||
                            c.creatingAward.value ||
                            c.isRequestClosed
                        ? null
                        : () => _CreateAwardSheet.show(context, c),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AwardConfirmedCard extends StatelessWidget {
  final AwardEntity award;
  const _AwardConfirmedCard({required this.award});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 18),
              const SizedBox(width: 6),
              Text('Adjudicación CONFIRMADA',
                  style: theme.textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 4),
          Text('Award: ${award.id}',
              style: theme.textTheme.bodySmall, maxLines: 1),
          Text('Líneas adjudicadas: ${award.lines.length}',
              style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// DOCUMENTOS (OC / OT emitidos)
// ═════════════════════════════════════════════════════════════════════════════

class _DocumentsSection extends StatelessWidget {
  final PurchaseRequestDetailController c;
  const _DocumentsSection({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Documentos operativos',
                      style: theme.textTheme.titleMedium),
                ),
                Obx(() => FilledButton.icon(
                      key: const Key('pr_detail.emit_documents.btn'),
                      icon: c.emittingDocuments.value
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.description_outlined),
                      label: const Text('Emitir OC/OT'),
                      onPressed: !c.hasAward ||
                              c.hasDocuments ||
                              c.emittingDocuments.value ||
                              c.isRequestClosed
                          ? null
                          : () => _onEmit(context),
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              final s = c.summary.value;
              if (s == null ||
                  (s.purchaseOrders.isEmpty && s.workOrders.isEmpty)) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    !c.hasAward
                        ? 'Primero adjudica el pedido para emitir documentos.'
                        : 'Aún no se han emitido OC ni OT.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (s.purchaseOrders.isNotEmpty) ...[
                    Text('Órdenes de compra',
                        style: theme.textTheme.labelMedium),
                    for (final d in s.purchaseOrders)
                      _DocRefTile(docRef: d, prefix: 'OC'),
                    const SizedBox(height: 8),
                  ],
                  if (s.workOrders.isNotEmpty) ...[
                    Text('Órdenes de trabajo',
                        style: theme.textTheme.labelMedium),
                    for (final d in s.workOrders)
                      _DocRefTile(docRef: d, prefix: 'OT'),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _onEmit(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Emitir OC y OT'),
        content: const Text(
          'Se generarán las órdenes de compra y trabajo a partir de la '
          'adjudicación confirmada. Esta acción NO se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Emitir'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final result = await c.emitDocuments();
    if (result == null) return;
    if (!context.mounted) return;
    final total = result.purchaseOrders.length + result.workOrders.length;
    Get.snackbar(
      'Documentos emitidos',
      '$total documento(s) creado(s).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _DocRefTile extends StatelessWidget {
  final SummaryDocumentRefEntity docRef;
  final String prefix;
  const _DocRefTile({required this.docRef, required this.prefix});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        prefix == 'OC'
            ? Icons.receipt_long_outlined
            : Icons.construction_outlined,
      ),
      title: Text(docRef.number.isEmpty ? docRef.id : docRef.number),
      subtitle: Text('Estado: ${docRef.status}'),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CERRAR PR
// ═════════════════════════════════════════════════════════════════════════════

class _CloseSection extends StatelessWidget {
  final PurchaseRequestDetailController c;
  const _CloseSection({required this.c});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (c.isRequestClosed) {
            return Row(
              children: [
                const Icon(Icons.lock_outline, size: 18),
                const SizedBox(width: 8),
                Text('Pedido cerrado', style: theme.textTheme.titleMedium),
              ],
            );
          }
          final blockers = c.closeBlockers;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Cerrar pedido', style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              if (!c.canClose && blockers.isNotEmpty)
                Text(
                  'Acciones pendientes: ${blockers.join(", ")}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                key: const Key('pr_detail.close.btn'),
                icon: c.closingRequest.value
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.lock_outline),
                label: const Text('Cerrar pedido'),
                onPressed: !c.canClose || c.closingRequest.value
                    ? null
                    : () => _confirmAndClose(context),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _confirmAndClose(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar pedido'),
        content: const Text(
          'El pedido pasará a estado CERRADO. '
          'Esta acción no se puede deshacer desde la app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await c.closeRequest();
    if (ok && context.mounted) {
      Get.snackbar(
        'Pedido cerrado',
        'El ciclo quedó cerrado formalmente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SHEET: REGISTRAR COTIZACIÓN
// ═════════════════════════════════════════════════════════════════════════════

class _RegisterQuoteSheet extends StatefulWidget {
  final PurchaseRequestDetailController c;
  const _RegisterQuoteSheet({required this.c});

  static Future<void> show(
    BuildContext context,
    PurchaseRequestDetailController c,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _RegisterQuoteSheet(c: c),
    );
  }

  @override
  State<_RegisterQuoteSheet> createState() => _RegisterQuoteSheetState();
}

class _RegisterQuoteSheetState extends State<_RegisterQuoteSheet> {
  String? _targetId;
  final _notesCtrl = TextEditingController();
  final Map<String, TextEditingController> _priceCtrls = {};

  @override
  void dispose() {
    _notesCtrl.dispose();
    for (final c in _priceCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _priceCtrl(String itemId) =>
      _priceCtrls.putIfAbsent(itemId, () => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = widget.c.detail.value;
    if (detail == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No hay detalle cargado.')),
      );
    }
    // Targets elegibles: pending (aún no responded/rejected). Para admin-captura
    // permitimos responded también por si el admin corrige un precio.
    final targets = detail.targets;

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Registrar cotización recibida',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _targetId,
                decoration: const InputDecoration(
                  labelText: 'Proveedor / destinatario',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final t in targets)
                    DropdownMenuItem(
                      value: t.id,
                      // Muestra displayName real cuando ya lo hidrató el
                      // controller; si el proveedor está soft-deleted anota
                      // "(eliminado)" para no confundir al admin.
                      child: Builder(builder: (_) {
                        final r =
                            _resolveVendorLabel(widget.c, t.vendorContactId);
                        return Text(
                          r.deleted ? '${r.label} (eliminado)' : r.label,
                        );
                      }),
                    ),
                ],
                onChanged: (v) => setState(() => _targetId = v),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    Text('Precio por ítem',
                        style: theme.textTheme.labelLarge),
                    const SizedBox(height: 6),
                    for (final it in detail.items)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(it.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Text('${it.quantity} ${it.unit}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: theme.hintColor)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: _priceCtrl(it.id),
                                decoration: const InputDecoration(
                                  labelText: 'Precio',
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Notas (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => FilledButton(
                          onPressed: widget.c.submittingQuote.value
                              ? null
                              : () => _onSubmit(context, detail),
                          child: widget.c.submittingQuote.value
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2))
                              : const Text('Registrar'),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    BuildContext context,
    PurchaseRequestDetailEntity detail,
  ) async {
    if (_targetId == null) {
      Get.snackbar('Falta', 'Selecciona un proveedor.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final target =
        detail.targets.firstWhere((t) => t.id == _targetId, orElse: () {
      throw StateError('Target no encontrado');
    });

    // Backend exige cobertura de TODOS los ítems del PR.
    final items = <SubmitQuoteItemInput>[];
    for (final it in detail.items) {
      final raw = _priceCtrls[it.id]?.text.trim() ?? '';
      final price = double.tryParse(raw);
      if (price == null || price < 0) {
        Get.snackbar(
          'Precio inválido',
          'Ingresa el precio unitario de "${it.description}".',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      items.add(SubmitQuoteItemInput(
        purchaseRequestItemId: it.id,
        unitPrice: price,
      ));
    }

    final quote = await widget.c.submitQuote(
      vendorContactId: target.vendorContactId,
      items: items,
      notes: _notesCtrl.text,
    );
    if (quote != null && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SHEET: CREAR ADJUDICACIÓN
// ═════════════════════════════════════════════════════════════════════════════

class _CreateAwardSheet extends StatefulWidget {
  final PurchaseRequestDetailController c;
  const _CreateAwardSheet({required this.c});

  static Future<void> show(
    BuildContext context,
    PurchaseRequestDetailController c,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CreateAwardSheet(c: c),
    );
  }

  @override
  State<_CreateAwardSheet> createState() => _CreateAwardSheetState();
}

class _CreateAwardSheetState extends State<_CreateAwardSheet> {
  /// Por item: targetId ganador (o null = sin decisión).
  final Map<String, String?> _winnerByItem = {};
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = widget.c.detail.value;
    if (detail == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No hay detalle cargado.')),
      );
    }

    // Mapa rápido: por itemId, las (target, unitPrice) disponibles de quotes.
    final Map<String, List<_ItemOffer>> offersByItem = {};
    for (final q in widget.c.quotes) {
      final matchingTarget = detail.targets.firstWhereOrNull(
          (t) => t.vendorContactId == q.vendorContactId);
      if (matchingTarget == null) continue;
      for (final qi in q.items) {
        final list = offersByItem.putIfAbsent(qi.purchaseRequestItemId, () => []);
        list.add(_ItemOffer(
          targetId: matchingTarget.id,
          vendorContactId: matchingTarget.vendorContactId,
          unitPrice: qi.unitPrice,
          currency: q.currency,
        ));
      }
    }

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Adjudicar pedido', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Selecciona el proveedor ganador para cada ítem. Los ítems sin '
                'oferta no podrán adjudicarse.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    for (final it in detail.items)
                      _ItemAwardRow(
                        item: it,
                        offers: offersByItem[it.id] ?? const [],
                        winnerTargetId: _winnerByItem[it.id],
                        onPick: (tid) =>
                            setState(() => _winnerByItem[it.id] = tid),
                      ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Notas generales (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => FilledButton(
                          onPressed: widget.c.creatingAward.value
                              ? null
                              : () => _onSubmit(context, detail),
                          child: widget.c.creatingAward.value
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2))
                              : const Text('Adjudicar'),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    BuildContext context,
    PurchaseRequestDetailEntity detail,
  ) async {
    final lines = <CreateAwardLineInput>[];
    for (final it in detail.items) {
      final targetId = _winnerByItem[it.id];
      if (targetId == null || targetId.isEmpty) continue;
      final target =
          detail.targets.firstWhereOrNull((t) => t.id == targetId);
      if (target == null) continue;
      lines.add(CreateAwardLineInput(
        purchaseRequestItemId: it.id,
        targetId: target.id,
        vendorContactId: target.vendorContactId,
        awardedQuantity: it.quantity,
        conversionType:
            PurchaseRequestDetailController.awardConversionFor(it.fulfillmentType),
      ));
    }
    if (lines.isEmpty) {
      Get.snackbar(
        'Selecciona un ganador',
        'Debes adjudicar al menos un ítem.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final award = await widget.c.createAward(
      lines: lines,
      notes: _notesCtrl.text,
    );
    if (award != null && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _ItemOffer {
  final String targetId;
  final String vendorContactId;
  final double unitPrice;
  final String currency;
  const _ItemOffer({
    required this.targetId,
    required this.vendorContactId,
    required this.unitPrice,
    required this.currency,
  });
}

class _ItemAwardRow extends StatelessWidget {
  final PurchaseRequestDetailItemEntity item;
  final List<_ItemOffer> offers;
  final String? winnerTargetId;
  final ValueChanged<String?> onPick;

  const _ItemAwardRow({
    required this.item,
    required this.offers,
    required this.winnerTargetId,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.description, style: theme.textTheme.bodyLarge),
          Text('${item.quantity} ${item.unit} · ${item.fulfillmentType}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor)),
          const SizedBox(height: 6),
          if (offers.isEmpty)
            Text(
              'Sin ofertas para este ítem.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.hintColor),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final o in offers)
                  ChoiceChip(
                    label: Text(
                      '${o.unitPrice.toStringAsFixed(0)} ${o.currency}',
                    ),
                    selected: winnerTargetId == o.targetId,
                    onSelected: (sel) => onPick(sel ? o.targetId : null),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// EMPTY state
// ═════════════════════════════════════════════════════════════════════════════

class _EmptyDetail extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _EmptyDetail({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 56, color: theme.hintColor),
            const SizedBox(height: 12),
            Text('No se pudo cargar el pedido',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Helpers
// ═════════════════════════════════════════════════════════════════════════════

/// Fallback opaco: UUID truncado. Se usa cuando el `vendorContactId` no
/// resuelve a un `LocalContact` del workspace (ej. ActorRef.platform) o
/// mientras `_hydrateVendorLabels` del controller aún no ha resuelto el id.
String _targetDisplay(String vendorContactId) {
  if (vendorContactId.length <= 10) return vendorContactId;
  return '${vendorContactId.substring(0, 6)}…${vendorContactId.substring(vendorContactId.length - 4)}';
}

/// Resultado estructurado del label de proveedor para un `vendorContactId`.
/// - `label`: texto a mostrar (displayName real o fallback opaco).
/// - `deleted`: true cuando el proveedor existe pero está soft-deleted;
///   la UI muestra un badge "Eliminado" para preservar legibilidad del
///   historial sin confundir con proveedores activos del directorio.
typedef _VendorLabel = ({String label, bool deleted});

/// Resuelve el label visible del proveedor a partir del `vendorContactId`.
/// Lee del `RxMap vendorLabels` del controller, que se hidrata al cargar
/// detalle via `LocalContactRepository.getById` (incluye soft-deleted por
/// contrato del repo). Si no hay entrada resuelta aún o el id no pertenece
/// a un LocalContact, cae al display opaco truncado.
_VendorLabel _resolveVendorLabel(
  PurchaseRequestDetailController c,
  String vendorContactId,
) {
  final vm = c.vendorLabels[vendorContactId];
  if (vm == null || vm.notFound) {
    return (label: _targetDisplay(vendorContactId), deleted: false);
  }
  return (label: vm.displayName, deleted: vm.isDeleted);
}

String _fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yy = d.year.toString();
  return '$dd/$mm/$yy';
}

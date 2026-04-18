// ============================================================================
// widgets/quotes/supplier_responses_sheet.dart
// SUPPLIER RESPONSES SHEET — Detalle de cotizaciones recibidas por solicitud
//
// QUÉ HACE:
// - Muestra las respuestas de proveedores (SupplierResponseEntity) para una
//   solicitud específica en bottom sheet.
// - Carga datos vía PurchaseRepository.fetchResponsesByRequest().
// - Loading state mientras carga, empty state si no hay respuestas.
//
// QUÉ NO HACE:
// - NO edita ni acepta cotizaciones (Fase futura).
// - NO resuelve proveedorId a nombre (muestra ID raw).
// - NO usa Get.snackbar.
//
// PRINCIPIOS:
// - Honestidad: solo muestra campos que existen en SupplierResponseEntity.
// - Patrón UI: reutiliza estructura de quote_details_sheet.dart.
// ============================================================================

import 'package:flutter/material.dart';

import 'package:avanzza/core/di/container.dart';
import 'package:avanzza/domain/entities/purchase/supplier_response_entity.dart';
import '../shared/format_helpers.dart';

/// Bottom sheet con las respuestas de proveedores para una solicitud.
///
/// Abrir con:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => SupplierResponsesSheet(
///     requestId: 'xxx',
///     tipoRepuesto: 'Pastillas de freno',
///   ),
/// );
/// ```
class SupplierResponsesSheet extends StatefulWidget {
  final String requestId;
  final String tipoRepuesto;

  const SupplierResponsesSheet({
    super.key,
    required this.requestId,
    required this.tipoRepuesto,
  });

  @override
  State<SupplierResponsesSheet> createState() =>
      _SupplierResponsesSheetState();
}

class _SupplierResponsesSheetState extends State<SupplierResponsesSheet> {
  List<SupplierResponseEntity>? _responses;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  Future<void> _loadResponses() async {
    try {
      final repo = DIContainer().purchaseRepository;
      final list = await repo.fetchResponsesByRequest(widget.requestId);
      if (!mounted) return;
      setState(() {
        _responses = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error al cargar cotizaciones';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: _loading
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : _error != null
                ? SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(_error!,
                          style: t.textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54)),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      // ── Cabecera ─────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Cotizaciones',
                              style: t.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Text(
                        widget.tipoRepuesto,
                        style: t.textTheme.bodySmall
                            ?.copyWith(color: Colors.black54),
                      ),

                      const Divider(height: 24),

                      // ── Contenido ────────────────────────────────────
                      if (_responses!.isEmpty)
                        _EmptyResponses()
                      else ...[
                        Text(
                          '${_responses!.length} '
                          '${_responses!.length == 1 ? 'respuesta' : 'respuestas'}',
                          style: t.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ..._responses!.map((r) => _ResponseCard(response: r)),
                      ],
                    ],
                  ),
      ),
    );
  }
}

class _ResponseCard extends StatelessWidget {
  final SupplierResponseEntity response;
  const _ResponseCard({required this.response});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final provIdShort = response.proveedorId.length > 8
        ? response.proveedorId.substring(0, 8)
        : response.proveedorId;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Proveedor + precio ──────────────────────────────────
          Row(
            children: [
              const Icon(Icons.store_outlined, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Proveedor #$provIdShort',
                  style: t.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '\$${fmt(response.precio.toInt())} ${response.currencyCode}',
                style: t.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Disponibilidad ──────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined,
                  size: 16, color: Colors.black45),
              const SizedBox(width: 6),
              Text('Disponibilidad: ${response.disponibilidad}',
                  style: t.textTheme.bodySmall),
            ],
          ),

          // ── Lead time ───────────────────────────────────────────
          if (response.leadTimeDays != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.schedule_outlined,
                    size: 16, color: Colors.black45),
                const SizedBox(width: 6),
                Text(
                  'Entrega: ${response.leadTimeDays} '
                  '${response.leadTimeDays == 1 ? 'día' : 'días'}',
                  style: t.textTheme.bodySmall,
                ),
              ],
            ),
          ],

          // ── Notas ───────────────────────────────────────────────
          if (response.notas != null && response.notas!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes_outlined,
                    size: 16, color: Colors.black45),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(response.notas!,
                      style: t.textTheme.bodySmall
                          ?.copyWith(color: Colors.black54)),
                ),
              ],
            ),
          ],

          // ── Catálogo ────────────────────────────────────────────
          if (response.catalogoUrl != null &&
              response.catalogoUrl!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.link_outlined,
                    size: 16, color: Colors.black45),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    response.catalogoUrl!,
                    style: t.textTheme.bodySmall?.copyWith(
                      color: t.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          // ── Fecha ───────────────────────────────────────────────
          if (response.createdAt != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                fmtDateTime(response.createdAt!),
                style:
                    t.textTheme.bodySmall?.copyWith(color: Colors.black38),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyResponses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.forum_outlined,
              size: 48, color: t.hintColor.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text('Sin respuestas de proveedores',
              style: t.textTheme.bodyMedium?.copyWith(color: t.hintColor)),
        ],
      ),
    );
  }
}

// ============================================================================
// lib/presentation/widgets/asset/simit_multa_detail_bottom_sheet.dart
// SIMIT MULTA DETAIL BOTTOM SHEET — Detalle profundo de una multa on-demand
//
// QUÉ HACE:
// - Muestra el detalle completo (6 secciones) de UNA multa al expandir tarjeta.
// - Llama SimitRepository.obtenerDetalleMulta(document, comparendoId).
// - Maneja 3 estados: loading / error+retry / success.
//
// QUÉ NO HACE:
// - No persiste nada (el cache vive en Redis backend, TTL 24h).
// - No usa GetX controller (FutureBuilder local es suficiente — modal efímero).
// - No re-fetch automático: si falla, el user pulsa "Reintentar".
//
// PRINCIPIOS:
// - Stateful local + Future memoizado (no recargar al rebuild).
// - Loading state explícito sobre tiempo posible (~50-65 s en cache miss).
// - Errores: mensaje claro + retry button. No throw.
// ============================================================================

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../core/theme/spacing.dart';
import '../../../data/simit/models/simit_models.dart';
import '../../../data/simit/simit_detail_prefetch_service.dart';
import '../../../data/simit/simit_repository.dart';
import '../../../data/simit/simit_service.dart';

/// Abre un BottomSheet modal con el detalle profundo de una multa.
///
/// Devuelve un Future que completa cuando el sheet se cierra.
/// El sheet maneja internamente loading/error/success.
Future<void> showSimitMultaDetailBottomSheet({
  required BuildContext context,
  required String document,
  required String comparendoId,
  String? infraccionLabel,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _SimitMultaDetailSheet(
      document: document,
      comparendoId: comparendoId,
      infraccionLabel: infraccionLabel,
    ),
  );
}

class _SimitMultaDetailSheet extends StatefulWidget {
  final String document;
  final String comparendoId;
  final String? infraccionLabel;

  const _SimitMultaDetailSheet({
    required this.document,
    required this.comparendoId,
    this.infraccionLabel,
  });

  @override
  State<_SimitMultaDetailSheet> createState() => _SimitMultaDetailSheetState();
}

class _SimitMultaDetailSheetState extends State<_SimitMultaDetailSheet> {
  late Future<SimitFineDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// Estrategia de carga (en orden de prioridad):
  /// 1. **Join inflight prefetch** — si hay un prefetch en curso o ya
  ///    completado para este (doc, comparendoId), reusamos ese future.
  ///    Evita HTTP duplicado y aprovecha el trabajo en background.
  /// 2. **Repository** — si SimitBinding está montado (rutas asset/SIMIT).
  /// 3. **Service ad-hoc** — fallback con Dio `integrations` global,
  ///    para pantallas dev/diagnostic sin SimitBinding.
  ///
  /// El backend además aplica cache Redis 24h + single-flight, así que
  /// aún en lazy mode el costo es mínimo si otra ruta ya lo trajo.
  Future<SimitFineDetail> _load() {
    // 1) Join inflight si hay prefetch corriendo.
    if (Get.isRegistered<SimitDetailPrefetchService>()) {
      final inflight = Get.find<SimitDetailPrefetchService>().getInflight(
        document: widget.document,
        comparendoId: widget.comparendoId,
      );
      if (inflight != null) return inflight;
    }
    // 2) Repository registrado por SimitBinding.
    if (Get.isRegistered<SimitRepository>()) {
      return Get.find<SimitRepository>().obtenerDetalleMulta(
        document: widget.document,
        comparendoId: widget.comparendoId,
      );
    }
    // 3) Fallback ad-hoc.
    final service = SimitService(Get.find<Dio>(tag: 'integrations'));
    return service.getMultaDetail(
      document: widget.document,
      comparendoId: widget.comparendoId,
    );
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mq = MediaQuery.of(context);

    // El sheet ocupa hasta el 92% del alto de pantalla. Suficiente para
    // mostrar las 6 secciones con scroll interno.
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: mq.size.height * 0.92),
      child: Padding(
        padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header fijo
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalle de la multa',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.infraccionLabel != null &&
                            widget.infraccionLabel!.isNotEmpty
                        ? widget.infraccionLabel!
                        : widget.comparendoId,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Contenido scrollable
            Flexible(
              child: FutureBuilder<SimitFineDetail>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _LoadingState();
                  }
                  if (snapshot.hasError) {
                    return _ErrorState(
                      error: snapshot.error!,
                      onRetry: _retry,
                    );
                  }
                  final detail = snapshot.data;
                  if (detail == null) {
                    return _ErrorState(
                      error: 'No se recibió detalle',
                      onRetry: _retry,
                    );
                  }
                  return _DetailContent(detail: detail);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING STATE — primer hit puede tardar ~50-65 s (Chrome real + scrape)
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Consultando detalle en SIMIT…',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Puede tardar hasta un minuto la primera vez. Las consultas siguientes son inmediatas.',
            style:
                theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR STATE — mensaje + retry
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    String message;
    if (error is SimitApiException) {
      message = (error as SimitApiException).message;
    } else {
      message = error.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No se pudo obtener el detalle',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DETAIL CONTENT — 6 secciones del SimitFineDetail
// ─────────────────────────────────────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final SimitFineDetail detail;

  const _DetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        if (detail.ticketInfo != null)
          _SectionBlock(
            title: 'Información comparendo',
            icon: Icons.receipt_long_outlined,
            entries: _ticketEntries(detail.ticketInfo!),
          ),
        if (detail.infraction != null)
          _SectionBlock(
            title: 'Infracción',
            icon: Icons.gavel_outlined,
            entries: _infractionEntries(detail.infraction!),
          ),
        if (detail.driver != null)
          _SectionBlock(
            title: 'Datos conductor',
            icon: Icons.person_outline_rounded,
            entries: _driverEntries(detail.driver!),
          ),
        if (detail.vehicle != null)
          _SectionBlock(
            title: 'Información vehículo',
            icon: Icons.directions_car_outlined,
            entries: _vehicleEntries(detail.vehicle!),
          ),
        if (detail.service != null)
          _SectionBlock(
            title: 'Servicio',
            icon: Icons.badge_outlined,
            entries: _serviceEntries(detail.service!),
          ),
        if (detail.extraInfo != null)
          _SectionBlock(
            title: 'Información adicional',
            icon: Icons.info_outline_rounded,
            entries: _extraEntries(detail.extraInfo!),
          ),
      ],
    );
  }

  // Cada helper devuelve pares label→value, omitiendo nulls/vacíos.
  // Usamos toJson() de los freezed para iterar sin acoplar a campos específicos —
  // así si el contrato cambia el sheet no rompe.
  List<MapEntry<String, String>> _ticketEntries(SimitTicketInfo i) =>
      _entriesFromJson(i.toJson());
  List<MapEntry<String, String>> _infractionEntries(SimitInfractionInfo i) =>
      _entriesFromJson(i.toJson());
  List<MapEntry<String, String>> _driverEntries(SimitDriverInfo i) =>
      _entriesFromJson(i.toJson());
  List<MapEntry<String, String>> _vehicleEntries(SimitVehicleInfo i) =>
      _entriesFromJson(i.toJson());
  List<MapEntry<String, String>> _serviceEntries(SimitServiceInfo i) =>
      _entriesFromJson(i.toJson());
  List<MapEntry<String, String>> _extraEntries(SimitExtraInfo i) =>
      _entriesFromJson(i.toJson());

  /// Convierte el JSON de una sección freezed en pares label→value visibles,
  /// usando los `@JsonKey(name:)` originales (en español) como labels.
  List<MapEntry<String, String>> _entriesFromJson(Map<String, dynamic> json) {
    final entries = <MapEntry<String, String>>[];
    for (final e in json.entries) {
      final v = e.value;
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isEmpty) continue;
      entries.add(MapEntry(e.key, s));
    }
    return entries;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION BLOCK — agrupa un título + lista label/value
// ─────────────────────────────────────────────────────────────────────────────

class _SectionBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<MapEntry<String, String>> entries;

  const _SectionBlock({
    required this.title,
    required this.icon,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.4)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            entries[i].key,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 6,
                          child: Text(
                            entries[i].value,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
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
}

// lib/presentation/pages/dev/integrations_diagnostics/widgets/diagnostic_status_panel.dart
// ============================================================================
// DIAGNOSTIC STATUS PANEL (DEV-only)
// ----------------------------------------------------------------------------
// Panel reutilizable que muestra metadatos técnicos de una consulta de
// Integrations API: duración, status HTTP, errorCode, mensaje y raw JSON
// expandible. NO sustituye la UI funcional — es complementario.
// ============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Snapshot inmutable del resultado técnico de una consulta a Integrations API.
/// Construido por los controllers DEV tras cada llamada.
class DiagnosticReport {
  final Duration? duration;
  final int? httpStatus;
  final String? requestId;
  final String? source;
  final String? errorCode;
  final String? errorMessage;
  final Map<String, dynamic>? rawJson;
  final DateTime? fetchedAt;

  const DiagnosticReport({
    this.duration,
    this.httpStatus,
    this.requestId,
    this.source,
    this.errorCode,
    this.errorMessage,
    this.rawJson,
    this.fetchedAt,
  });

  bool get isEmpty =>
      duration == null &&
      httpStatus == null &&
      requestId == null &&
      errorCode == null &&
      rawJson == null;
}

class DiagnosticStatusPanel extends StatefulWidget {
  final DiagnosticReport report;

  const DiagnosticStatusPanel({super.key, required this.report});

  @override
  State<DiagnosticStatusPanel> createState() => _DiagnosticStatusPanelState();
}

class _DiagnosticStatusPanelState extends State<DiagnosticStatusPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.report;
    if (r.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con chips de métricas
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                Icon(Icons.bug_report_outlined,
                    size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Diagnóstico técnico',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (r.duration != null)
                  _MetricChip(
                    icon: Icons.timer_outlined,
                    label: '${r.duration!.inMilliseconds} ms',
                  ),
                if (r.httpStatus != null)
                  _MetricChip(
                    icon: Icons.cloud_outlined,
                    label: 'HTTP ${r.httpStatus}',
                    color: _httpColor(r.httpStatus!, cs),
                  ),
                if (r.source != null)
                  _MetricChip(
                    icon: Icons.account_tree_outlined,
                    label: r.source!,
                  ),
                if (r.requestId != null)
                  _MetricChip(
                    icon: Icons.fingerprint,
                    label: r.requestId!,
                    truncate: true,
                  ),
                if (r.errorCode != null)
                  _MetricChip(
                    icon: Icons.error_outline,
                    label: r.errorCode!,
                    color: cs.error,
                  ),
              ],
            ),
          ),

          if (r.errorMessage != null && r.errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Text(
                r.errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(color: cs.error),
              ),
            ),

          if (r.rawJson != null) _buildRawJsonExpansion(context, r.rawJson!),
        ],
      ),
    );
  }

  Widget _buildRawJsonExpansion(
      BuildContext context, Map<String, dynamic> json) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        initiallyExpanded: false,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        title: Text(
          _expanded ? 'Ocultar raw JSON' : 'Ver raw JSON',
          style: theme.textTheme.labelMedium
              ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
        ),
        leading: Icon(Icons.code, size: 18, color: cs.primary),
        trailing: IconButton(
          tooltip: 'Copiar JSON',
          icon: const Icon(Icons.copy_outlined, size: 18),
          onPressed: () => _copyJson(context, json),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(json),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyJson(
      BuildContext context, Map<String, dynamic> json) async {
    await Clipboard.setData(
      ClipboardData(text: const JsonEncoder.withIndent('  ').convert(json)),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copiado al portapapeles')),
    );
  }

  Color _httpColor(int status, ColorScheme cs) {
    if (status >= 200 && status < 300) return Colors.green.shade700;
    if (status >= 400 && status < 500) return Colors.orange.shade800;
    if (status >= 500) return cs.error;
    return cs.onSurfaceVariant;
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final bool truncate;

  const _MetricChip({
    required this.icon,
    required this.label,
    this.color,
    this.truncate = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = color ?? cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: truncate ? 120 : 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: fg,
                fontFamily: truncate ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

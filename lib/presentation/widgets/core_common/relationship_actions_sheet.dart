// ============================================================================
// lib/presentation/widgets/core_common/relationship_actions_sheet.dart
// RELATIONSHIP ACTIONS SHEET — F5 Hito 6/7 (primera acción real sobre la Relación)
// ============================================================================
// QUÉ HACE:
//   - Bottom sheet que se abre al tocar el badge "Vinculado".
//   - Acción principal: "Iniciar solicitud" — abre un dialog mínimo con
//     campo "título" obligatorio; al confirmar crea una OperationalRequest
//     en state=draft vía StartOperationalRequest (F5 Hito 7).
//   - Al confirmar: cierra el sheet y muestra un SnackBar de éxito.
//
// QUÉ NO HACE:
//   - NO lista requests existentes.
//   - NO transita a 'sent'; queda en 'draft' (editable).
//   - NO crea RequestDelivery ni toca backend.
//   - NO navega a pantallas nuevas.
//
// PRINCIPIOS:
//   - UI tonta: recibe la relationship; delega la creación al use case.
//   - createdBy se obtiene de SessionContextController (user.uid activo).
//   - Manejo de errores explícito con SnackBar — sin silent fail.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/core_common/operational_relationship_entity.dart';
import '../../controllers/session_context_controller.dart';

class RelationshipActionsSheet extends StatelessWidget {
  final OperationalRelationshipEntity relationship;

  const RelationshipActionsSheet({
    super.key,
    required this.relationship,
  });

  static Future<void> show(
    BuildContext context,
    OperationalRelationshipEntity relationship,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => RelationshipActionsSheet(relationship: relationship),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.verified, size: 18, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text('Vinculado', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('relationship_actions_sheet.start_request'),
              onPressed: () => _onStartRequest(context),
              icon: const Icon(Icons.add_task),
              label: const Text('Iniciar solicitud'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onStartRequest(BuildContext context) async {
    // Cerramos el sheet antes de abrir el dialog para no apilar sobres modales.
    final sheetContext = context;
    Navigator.of(sheetContext).pop();

    final rootContext = sheetContext;
    final created = await showDialog<bool>(
      context: rootContext,
      builder: (_) => _StartRequestDialog(relationship: relationship),
    );

    if (created == true && rootContext.mounted) {
      ScaffoldMessenger.of(rootContext).showSnackBar(
        const SnackBar(content: Text('Solicitud creada (borrador).')),
      );
    }
  }
}

class _StartRequestDialog extends StatefulWidget {
  final OperationalRelationshipEntity relationship;

  const _StartRequestDialog({required this.relationship});

  @override
  State<_StartRequestDialog> createState() => _StartRequestDialogState();
}

class _StartRequestDialogState extends State<_StartRequestDialog> {
  final _titleCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _summaryCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      !_submitting && _titleCtrl.text.trim().isNotEmpty;

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final session = Get.find<SessionContextController>();
    final uid = session.user?.uid ?? '';
    if (uid.isEmpty) {
      setState(() => _error = 'Sin sesión activa. Inicia sesión para continuar.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await DIContainer().startOperationalRequest.execute(
            relationship: widget.relationship,
            createdBy: uid,
            title: title,
            summary: _summaryCtrl.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'No se pudo crear la solicitud. Intenta de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva solicitud'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('start_request_dialog.title_field'),
            controller: _titleCtrl,
            autofocus: true,
            enabled: !_submitting,
            decoration: const InputDecoration(
              labelText: 'Título *',
              hintText: 'Ej: Cotización de mantenimiento',
            ),
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('start_request_dialog.summary_field'),
            controller: _summaryCtrl,
            enabled: !_submitting,
            decoration: const InputDecoration(
              labelText: 'Resumen (opcional)',
            ),
            maxLines: 2,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              _submitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('start_request_dialog.confirm_button'),
          onPressed: _canSubmit ? _submit : null,
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar'),
        ),
      ],
    );
  }
}

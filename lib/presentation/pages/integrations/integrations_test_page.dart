// ============================================================================
// lib/presentation/pages/integrations/integrations_test_page.dart
//
// INTEGRATIONS TEST PAGE
//
// Página de prueba para el módulo de integraciones externas.
// Permite consultar manualmente RUNT Persona y SIMIT, y visualizar
// el resultado JSON completo en pantalla.
//
// Cómo navegar a esta página:
//   Get.to(
//     () => const IntegrationsTestPage(),
//     binding: IntegrationsBinding(),
//   );
// ============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/integrations/integrations_controller.dart';
import '../../bindings/integrations/integrations_binding.dart';

/// Página de prueba para consultas RUNT Persona y SIMIT.
///
/// Muestra el resultado de cada consulta como JSON formateado.
/// Diseñada solo para validación durante desarrollo.
class IntegrationsTestPage extends StatelessWidget {
  const IntegrationsTestPage({super.key});

  /// Navega a esta página con el binding correcto sin necesidad de
  /// tener la ruta registrada en app_pages.dart.
  static void navigate() {
    Get.to(
      () => const IntegrationsTestPage(),
      binding: IntegrationsBinding(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<IntegrationsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations Test'),
        actions: [
          IconButton(
            tooltip: 'Limpiar cache',
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: ctrl.clearCache,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Sección RUNT Persona ────────────────────────────────────────
            _SectionCard(
              title: 'RUNT Persona',
              color: Colors.blue.shade700,
              child: _RuntPersonSection(ctrl: ctrl),
            ),
            const SizedBox(height: 20),

            // ── Sección SIMIT ───────────────────────────────────────────────
            _SectionCard(
              title: 'SIMIT Multas',
              color: Colors.orange.shade700,
              child: _SimitSection(ctrl: ctrl),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECCIÓN RUNT PERSONA
// ─────────────────────────────────────────────────────────────────────────────

class _RuntPersonSection extends StatefulWidget {
  final IntegrationsController ctrl;
  const _RuntPersonSection({required this.ctrl});

  @override
  State<_RuntPersonSection> createState() => _RuntPersonSectionState();
}

class _RuntPersonSectionState extends State<_RuntPersonSection> {
  final _docController = TextEditingController();
  String _selectedType = 'CC';

  static const _docTypes = ['CC', 'CE', 'PAS', 'TI'];

  @override
  void dispose() {
    _docController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campo de documento
        TextField(
          controller: _docController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Número de documento',
            border: OutlineInputBorder(),
            hintText: 'ej. 72184925',
          ),
        ),
        const SizedBox(height: 12),

        // Selector de tipo de documento
        DropdownButtonFormField<String>(
          value: _selectedType,
          decoration: const InputDecoration(
            labelText: 'Tipo de documento',
            border: OutlineInputBorder(),
          ),
          items: _docTypes
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedType = v);
          },
        ),
        const SizedBox(height: 16),

        // Botón de consulta
        Obx(
          () => FilledButton.icon(
            onPressed: widget.ctrl.isRuntLoading
                ? null
                : () => widget.ctrl.consultRuntPerson(
                      document: _docController.text,
                      type: _selectedType,
                    ),
            icon: widget.ctrl.isRuntLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.person_search_rounded),
            label: Text(
              widget.ctrl.isRuntLoading
                  ? 'Consultando...'
                  : 'Consultar RUNT Persona',
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Resultado
        Obx(() => _ResultDisplay(
              state: widget.ctrl.runtState.value,
              successData: widget.ctrl.runtPerson.value != null
                  ? _runtPersonToJson(widget.ctrl.runtPerson.value!)
                  : null,
              errorMessage: widget.ctrl.runtError.value,
            )),
      ],
    );
  }

  Map<String, dynamic> _runtPersonToJson(dynamic person) {
    return {
      'nombreCompleto': person.nombreCompleto,
      'tipoDocumento': person.tipoDocumento,
      'numeroDocumento': person.numeroDocumento,
      'estadoPersona': person.estadoPersona,
      'estadoConductor': person.estadoConductor,
      'numeroInscripcionRunt': person.numeroInscripcionRunt,
      'fechaInscripcion': person.fechaInscripcion,
      'cantidadLicencias': person.licencias.length,
      'licencias': person.licencias
          .map((l) => {
                'numeroLicencia': l.numeroLicencia,
                'estado': l.estado,
                'cantidadCategorias': l.detalles.length,
                'categorias':
                    l.detalles.map((d) => d.categoria).toList(),
              })
          .toList(),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECCIÓN SIMIT
// ─────────────────────────────────────────────────────────────────────────────

class _SimitSection extends StatefulWidget {
  final IntegrationsController ctrl;
  const _SimitSection({required this.ctrl});

  @override
  State<_SimitSection> createState() => _SimitSectionState();
}

class _SimitSectionState extends State<_SimitSection> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campo de consulta
        TextField(
          controller: _queryController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Placa o número de documento',
            border: OutlineInputBorder(),
            hintText: 'ej. SDV757 o 72184925',
          ),
        ),
        const SizedBox(height: 16),

        // Botón de consulta
        Obx(
          () => FilledButton.icon(
            onPressed: widget.ctrl.isSimitLoading
                ? null
                : () => widget.ctrl.consultSimit(
                      query: _queryController.text,
                    ),
            icon: widget.ctrl.isSimitLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.gavel_rounded),
            label: Text(
              widget.ctrl.isSimitLoading ? 'Consultando...' : 'Consultar SIMIT',
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Resultado
        Obx(() => _ResultDisplay(
              state: widget.ctrl.simitState.value,
              successData: widget.ctrl.simitResult.value != null
                  ? {
                      'query': widget.ctrl.simitResult.value!.query,
                      'tieneMultas':
                          widget.ctrl.simitResult.value!.tieneMultas,
                      'total': widget.ctrl.simitResult.value!.total,
                      'cantidadMultas':
                          widget.ctrl.simitResult.value!.cantidadMultas,
                      'resumen': widget.ctrl.simitResult.value!.resumen,
                    }
                  : null,
              errorMessage: widget.ctrl.simitError.value,
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS DE SOPORTE
// ─────────────────────────────────────────────────────────────────────────────

/// Tarjeta contenedora para cada sección con header coloreado.
class _SectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Widget que renderiza el resultado de una consulta (loading / error / JSON).
class _ResultDisplay extends StatelessWidget {
  final IntegrationsQueryState state;
  final Map<String, dynamic>? successData;
  final String? errorMessage;

  const _ResultDisplay({
    required this.state,
    this.successData,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case IntegrationsQueryState.idle:
        return const SizedBox.shrink();

      case IntegrationsQueryState.loading:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          ),
        );

      case IntegrationsQueryState.error:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            errorMessage ?? 'Error desconocido.',
            style: TextStyle(color: Colors.red.shade800),
          ),
        );

      case IntegrationsQueryState.success:
        if (successData == null) return const SizedBox.shrink();
        final prettyJson = const JsonEncoder.withIndent('  ').convert(
          successData,
        );
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: SelectableText(
            prettyJson,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        );
    }
  }
}

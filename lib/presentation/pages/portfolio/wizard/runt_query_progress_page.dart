// ============================================================================
// lib/presentation/pages/portfolio/wizard/runt_query_progress_page.dart
//
// RUNT QUERY PROGRESS PAGE — Enterprise-grade Ultra Pro 10/10
//
// PROPÓSITO
// Visualizar el progreso de la consulta RUNT asíncrona del wizard de registro
// de activos con una UX robusta, protegida y alineada con un flujo crítico.
//
// RESPONSABILIDAD
// - Renderizar el progreso global y por bloques.
// - Escuchar el estado reactivo del RuntQueryController.
// - Navegar automáticamente a la pantalla de resultado al completar.
// - Proteger al usuario contra cierres accidentales del proceso.
// - Mostrar estado de error con salida controlada al formulario.
//
// NO RESPONSABILIDAD
// - No inicia la consulta.
// - No hace polling.
// - No persiste datos.
// - No contiene lógica de negocio del wizard.
//
// NOTAS DE UX
// - Se bloquea el back físico mientras la consulta está en curso.
// - Se muestra confirmación antes de salir.
// - Si el estado ya llega "completed" al montar la pantalla, redirige de inmediato.
// - El texto de las acciones coincide con el comportamiento real.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../controllers/runt/runt_query_controller.dart';

class RuntQueryProgressPage extends StatefulWidget {
  const RuntQueryProgressPage({super.key});

  @override
  State<RuntQueryProgressPage> createState() => _RuntQueryProgressPageState();
}

class _RuntQueryProgressPageState extends State<RuntQueryProgressPage> {
  late final RuntQueryController _ctrl;
  Worker? _navigationWorker;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<RuntQueryController>();

    // Cubrir el caso donde la pantalla se monta y el estado ya está completado.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleImmediateState(_ctrl.viewState.value);
    });

    // Escucha reactiva del estado para navegar automáticamente al resultado.
    _navigationWorker = ever<RuntViewState>(
      _ctrl.viewState,
      (state) {
        if (!mounted) return;
        if (state == RuntViewState.completed) {
          Get.offNamed(Routes.runtQueryResult);
        }
      },
    );
  }

  @override
  void dispose() {
    _navigationWorker?.dispose();
    super.dispose();
  }

  void _handleImmediateState(RuntViewState state) {
    if (state == RuntViewState.completed) {
      Get.offNamed(Routes.runtQueryResult);
    }
  }

  Future<void> _confirmExit(BuildContext context) async {
    final state = _ctrl.viewState.value;

    // Si ya falló, no necesitamos diálogo: permitimos volver directamente.
    if (state == RuntViewState.failed) {
      Get.back();
      return;
    }

    final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) {
            final colors = Theme.of(dialogContext).colorScheme;
            return AlertDialog(
              title: const Text('¿Salir de la consulta?'),
              content: const Text(
                'La consulta RUNT sigue en proceso. Si sales ahora, el borrador permanecerá guardado, pero el resultado podría quedar incompleto.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('SEGUIR ESPERANDO'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(
                    'VOLVER AL FORMULARIO',
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!mounted) return;

    if (shouldExit) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _confirmExit(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Consultando RUNT'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: 'Volver al formulario',
              icon: const Icon(Icons.close),
              onPressed: () => _confirmExit(context),
            ),
          ],
        ),
        body: Obx(() {
          final state = _ctrl.viewState.value;

          if (state == RuntViewState.failed) {
            return _FailedView(
              error: _ctrl.errorMessage.value,
              onBackToForm: () => Get.back(),
            );
          }

          return _ProgressView(
            progress: _ctrl.progressPercent.value,
            steps: _ctrl.steps.value,
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISTA DE PROGRESO
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressView extends StatelessWidget {
  final int progress;
  final RuntQuerySteps steps;

  const _ProgressView({
    required this.progress,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Indicador circular principal
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 124,
                height: 124,
                child: CircularProgressIndicator(
                  value: progress.clamp(0, 100) / 100,
                  strokeWidth: 10,
                  backgroundColor: colors.surfaceContainerHighest,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '$progress%',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text(
            'Sincronizando con el sistema nacional',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Estamos obteniendo la información técnica y legal del vehículo por bloques para validar el registro antes de continuar.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 32),

          _StepTile(
            label: 'Información del vehículo',
            status: steps.vehicle,
          ),
          _StepTile(
            label: 'Vigencia SOAT',
            status: steps.soat,
          ),
          _StepTile(
            label: 'Revisión técnico-mecánica',
            status: steps.rtm,
          ),
          _StepTile(
            label: 'Historial y trazabilidad',
            status: steps.history,
          ),

          const SizedBox(height: 28),

          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 100) / 100,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Por favor, no cierres la aplicación ni bloquees tu celular.',
            style: textTheme.labelMedium?.copyWith(
              color: colors.outline,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BLOQUE DE ESTADO
// ─────────────────────────────────────────────────────────────────────────────

class _StepTile extends StatelessWidget {
  final String label;
  final RuntQueryStepStatus status;

  const _StepTile({
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _backgroundColor(colors),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _borderColor(colors),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _AnimatedStatusIcon(status: status),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: status == RuntQueryStepStatus.loading
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: status == RuntQueryStepStatus.pending
                    ? colors.outline
                    : colors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _StepStatusLabel(status: status),
        ],
      ),
    );
  }

  Color _backgroundColor(ColorScheme colors) {
    switch (status) {
      case RuntQueryStepStatus.loading:
        return colors.primaryContainer.withOpacity(0.24);
      case RuntQueryStepStatus.done:
        return colors.surface;
      case RuntQueryStepStatus.failed:
        return colors.errorContainer.withOpacity(0.35);
      case RuntQueryStepStatus.pending:
        return colors.surface;
    }
  }

  Color _borderColor(ColorScheme colors) {
    switch (status) {
      case RuntQueryStepStatus.loading:
        return colors.primary.withOpacity(0.45);
      case RuntQueryStepStatus.done:
        return colors.outlineVariant;
      case RuntQueryStepStatus.failed:
        return colors.error.withOpacity(0.35);
      case RuntQueryStepStatus.pending:
        return colors.surfaceContainerLow;
    }
  }
}

class _AnimatedStatusIcon extends StatelessWidget {
  final RuntQueryStepStatus status;

  const _AnimatedStatusIcon({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: _buildIcon(colors),
    );
  }

  Widget _buildIcon(ColorScheme colors) {
    switch (status) {
      case RuntQueryStepStatus.pending:
        return Icon(
          Icons.circle_outlined,
          key: const ValueKey('pending'),
          color: colors.outlineVariant,
          size: 22,
        );
      case RuntQueryStepStatus.loading:
        return SizedBox(
          key: const ValueKey('loading'),
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: colors.primary,
          ),
        );
      case RuntQueryStepStatus.done:
        return Icon(
          Icons.check_circle,
          key: const ValueKey('done'),
          color: colors.primary,
          size: 22,
        );
      case RuntQueryStepStatus.failed:
        return Icon(
          Icons.error,
          key: const ValueKey('failed'),
          color: colors.error,
          size: 22,
        );
    }
  }
}

class _StepStatusLabel extends StatelessWidget {
  final RuntQueryStepStatus status;

  const _StepStatusLabel({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    switch (status) {
      case RuntQueryStepStatus.done:
        return Text(
          'Cargado',
          style: TextStyle(
            color: colors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      case RuntQueryStepStatus.loading:
        return Text(
          'Consultando',
          style: TextStyle(
            color: colors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      case RuntQueryStepStatus.failed:
        return Text(
          'Error',
          style: TextStyle(
            color: colors.error,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      case RuntQueryStepStatus.pending:
        return Text(
          'Pendiente',
          style: TextStyle(
            color: colors.outline,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISTA DE ERROR
// ─────────────────────────────────────────────────────────────────────────────

class _FailedView extends StatelessWidget {
  final String? error;
  final VoidCallback onBackToForm;

  const _FailedView({
    this.error,
    required this.onBackToForm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: colors.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: colors.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Consulta interrumpida',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            error ??
                'No pudimos completar la consulta con el RUNT. Regresa al formulario y vuelve a intentarlo.',
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
              onPressed: onBackToForm,
              icon: const Icon(Icons.arrow_back),
              label: const Text('VOLVER AL FORMULARIO'),
            ),
          ),
        ],
      ),
    );
  }
}

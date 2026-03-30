// ============================================================================
// lib/presentation/pages/portfolio/wizard/runt_query_progress_page.dart
//
// RUNT QUERY PROGRESS PAGE — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Visualizar el estado de la consulta RUNT asíncrona con una UX honesta:
// indicador local de espera estimada (no falso progreso técnico del backend),
// mensajes rotativos por tramo de tiempo, y estados terminales claros.
//
// RESPONSABILIDAD
// - Renderizar un indicador de espera local durante `running`.
// - Escuchar el estado reactivo del RuntQueryController.
// - Navegar automáticamente al resultado cuando el job termina (completed/partial).
// - Proteger al usuario contra cierres accidentales del proceso.
// - Mostrar estado de error con salida controlada al formulario.
//
// NO RESPONSABILIDAD
// - No inicia la consulta.
// - No hace polling.
// - No persiste datos.
// - No contiene lógica de negocio del wizard.
// - No representa subetapas (vehicle/soat/rtm/history) como progreso operativo
//   real mientras el scraper sea monolítico.
//
// PRINCIPIOS DE UX
// - El círculo usa un temporizador LOCAL (90s estimados), no progressPercent
//   del backend, para evitar vender un falso avance técnico durante `running`.
// - El círculo se capa al 90% mientras el job siga activo.
// - Los mensajes cambian por tramos de tiempo transcurrido.
// - `failed + PARTIAL_EXTRACTION_ERROR + partialData` no colapsa en error total:
//   el controller lo resuelve como `RuntViewState.partial` y navega a resultado.
//
// ENTERPRISE NOTES
// - Se bloquea el back físico mientras la consulta está en curso.
// - Se muestra confirmación antes de salir.
// - Si el estado ya llega "completed" o "partial" al montar, redirige de inmediato.
// ============================================================================

import 'dart:async';

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

    // Cubrir el caso donde la pantalla se monta y el estado ya es terminal.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleImmediateState(_ctrl.viewState.value);
    });

    // Navegación reactiva: completed y partial van al resultado.
    _navigationWorker = ever<RuntViewState>(
      _ctrl.viewState,
      (state) {
        if (!mounted) return;
        if (state == RuntViewState.completed ||
            state == RuntViewState.partial) {
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
    if (state == RuntViewState.completed || state == RuntViewState.partial) {
      Get.offNamed(Routes.runtQueryResult);
    }
  }

  Future<void> _confirmExit(BuildContext context) async {
    final state = _ctrl.viewState.value;

    // Estados terminales sin proceso activo: salir sin diálogo.
    if (state == RuntViewState.failed ||
        state == RuntViewState.connectionInterrupted ||
        state == RuntViewState.jobUnavailable) {
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
                'La consulta RUNT sigue en proceso. Si sales ahora, el borrador '
                'permanecerá guardado, pero el resultado podría quedar incompleto.',
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
    if (shouldExit) Get.back();
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

          if (state == RuntViewState.connectionInterrupted) {
            return _ConnectionInterruptedView(
              onRetry: () => _ctrl.resumePolling(),
              onBack: () => Get.back(),
            );
          }

          if (state == RuntViewState.jobUnavailable) {
            return _JobUnavailableView(
              onNewQuery: () => Get.back(),
            );
          }

          // running / pending / completed / partial:
          // completed y partial disparan navegación inmediata vía el worker.
          // Se muestra _RunningView brevemente mientras el worker actúa.
          return const _RunningView();
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISTA DE CARGA HONESTA
// ─────────────────────────────────────────────────────────────────────────────

/// Vista de espera durante la consulta RUNT.
///
/// HONESTIDAD UX:
/// - El círculo anima de 0 a 90% con un [AnimationController] local de 90s.
///   No usa progressPercent del backend — evita vender falso avance técnico.
/// - Los mensajes cambian según el tiempo transcurrido, no por eventos reales.
/// - El círculo nunca llega al 100% mientras el backend no confirme terminación.
class _RunningView extends StatefulWidget {
  const _RunningView();

  @override
  State<_RunningView> createState() => _RunningViewState();
}

class _RunningViewState extends State<_RunningView>
    with SingleTickerProviderStateMixin {
  /// Duración estimada base: el portal RUNT tarda ~30–90s en condiciones normales.
  static const Duration _kEstimated = Duration(seconds: 90);

  /// Techo visual del círculo mientras el backend no confirma terminación.
  static const double _kCircleCap = 0.90;

  /// Mensajes honestos por tramo de tiempo transcurrido (segundos).
  /// No mencionan secciones ni sugieren validación por bloque.
  static const List<({int threshold, String text})> _kMessages = [
    (threshold: 0, text: 'Preparando la consulta...'),
    (threshold: 10, text: 'Estamos consultando la información en el RUNT...'),
    (threshold: 30, text: 'Seguimos procesando la consulta...'),
    (
      threshold: 70,
      text: 'Parece que está tardando un poco más de lo esperado.\n'
          'Seguimos intentando obtener la información disponible.',
    ),
  ];

  late final AnimationController _progressAnim;
  Timer? _tickTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();

    // Anima de 0.0 a 1.0 en 90s.
    // Valor visual del círculo = _progressAnim.value * _kCircleCap → 0% a 90%.
    _progressAnim = AnimationController(
      vsync: this,
      duration: _kEstimated,
    );
    _progressAnim.forward();

    // Tick cada segundo: actualiza contador y mensajes.
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _progressAnim.dispose();
    _tickTimer?.cancel();
    super.dispose();
  }

  double get _circleValue => _progressAnim.value * _kCircleCap;

  String get _countdownText {
    final remaining = 90 - _elapsedSeconds;
    return remaining > 0 ? '$remaining s' : '…';
  }

  String get _currentMessage {
    String msg = _kMessages.first.text;
    for (final m in _kMessages) {
      if (_elapsedSeconds >= m.threshold) msg = m.text;
    }
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnim,
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Círculo con temporizador local — NO porcentaje del backend.
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 124,
                height: 124,
                child: CircularProgressIndicator(
                  value: _circleValue,
                  strokeWidth: 10,
                  backgroundColor: colors.surfaceContainerHighest,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                _countdownText,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Título fijo.
          Text(
            'Estamos consultando la información del vehículo',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 14),

          // Mensaje rotativo con fade + slide suave.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            ),
            child: Text(
              _currentMessage,
              key: ValueKey(_currentMessage),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Text(
            'Por favor, no cierres la aplicación.',
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
// VISTA DE ERROR TOTAL
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// VISTA DE CONEXIÓN INTERRUMPIDA
// ─────────────────────────────────────────────────────────────────────────────

/// Vista cuando el polling falló por pérdida de conectividad del cliente.
///
/// NO es un fallo real del job — el backend puede seguir ejecutando.
/// El usuario puede reintentar el seguimiento sin lanzar una consulta nueva.
class _ConnectionInterruptedView extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _ConnectionInterruptedView({
    required this.onRetry,
    required this.onBack,
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
              color: colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              size: 60,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Conexión interrumpida',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Se perdió la conexión durante el seguimiento de la consulta. '
            'El proceso en el servidor puede seguir activo.',
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
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('REINTENTAR SEGUIMIENTO'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onBack,
              child: const Text('VOLVER AL FORMULARIO'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISTA DE JOB NO RECUPERABLE
// ─────────────────────────────────────────────────────────────────────────────

/// Vista cuando el backend confirmó que el job ya no existe o expiró.
///
/// Diferencia respecto a [_ConnectionInterruptedView]:
/// - Allá: Flutter no pudo confirmar el estado (red caída) → se puede reintentar.
/// - Aquí: backend confirmó que ese jobId ya no está → hay que consultar de nuevo.
class _JobUnavailableView extends StatelessWidget {
  final VoidCallback onNewQuery;

  const _JobUnavailableView({required this.onNewQuery});

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
              color: colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 60,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No fue posible recuperar la consulta',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'La consulta anterior ya no está disponible. '
            'Debes realizar una nueva consulta para continuar.',
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
              onPressed: onNewQuery,
              icon: const Icon(Icons.arrow_back),
              label: const Text('NUEVA CONSULTA'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISTA DE ERROR TOTAL
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
                'No fue posible completar la consulta oficial. '
                    'La fuente oficial puede no estar disponible en este momento.',
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

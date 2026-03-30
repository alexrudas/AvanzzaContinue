// ============================================================================
// lib/application/runt/runt_async_query_gateway.dart
//
// RUNT ASYNC QUERY GATEWAY — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Definir el contrato neutral de aplicación para la consulta RUNT asíncrona
// basada en jobs, junto con los tipos que viajan entre data y presentation.
//
// CAPA
// application/
//
// DEPENDENCIAS PERMITIDAS
// - Dart puro
// - importable desde data/ y presentation/
//
// DEPENDENCIAS PROHIBIDAS
// - Flutter / GetX
// - Dio / HTTP
// - Isar
// - widgets / controllers
//
// ARQUITECTURA
// presentation/controller
//   ↓ depende de
// RuntAsyncQueryGateway (este archivo)
//   ↑ implementado por
// data/gateways/RuntAsyncQueryGatewayImpl
//
// NOTA DE DISEÑO
// partialData y finalData permanecen como Map<String, dynamic> por ahora
// como contrato puente neutral. Si en el futuro el producto madura hacia
// value objects más fuertes, ese refinamiento debe ocurrir aquí, sin volver
// a contaminar presentation con modelos de data.
// ============================================================================

/// Contrato neutral de aplicación para consulta RUNT asíncrona.
///
/// Presentation depende de esta abstracción, nunca del service HTTP concreto.
/// Data implementa esta abstracción mediante un gateway/adaptador.
abstract class RuntAsyncQueryGateway {
  /// Inicia una consulta RUNT asíncrona y retorna el identificador del job.
  Future<RuntAsyncQueryStartResult> startQuery({
    required String plate,
    required String ownerDocument,
    required String ownerDocumentType,
  });

  /// Consulta el estado actual de un job previamente creado.
  Future<RuntAsyncQueryStatusResult> getJobStatus(String jobId);
}

// ─────────────────────────────────────────────────────────────────────────────
// Resultado de inicio del job
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado neutral de creación del job RUNT.
class RuntAsyncQueryStartResult {
  final String jobId;

  const RuntAsyncQueryStartResult({
    required this.jobId,
  })  : assert(jobId != ''),
        assert(jobId != ' ');

  @override
  String toString() => 'RuntAsyncQueryStartResult(jobId: $jobId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuntAsyncQueryStartResult &&
          runtimeType == other.runtimeType &&
          jobId == other.jobId;

  @override
  int get hashCode => jobId.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// Enums neutrales
// ─────────────────────────────────────────────────────────────────────────────

/// Estado global del job RUNT.
enum RuntQueryJobStatus {
  pending,
  running,
  completed,
  failed,
}

/// Estado individual de cada bloque del scraping.
enum RuntQueryStepStatus {
  pending,
  loading,
  done,
  failed,

  /// Bloque bloqueado por condición externa (portal caído, sección no disponible).
  /// Se pinta neutral — no es un error operativo.
  blocked,
}

// ─────────────────────────────────────────────────────────────────────────────
// Progreso por bloques
// ─────────────────────────────────────────────────────────────────────────────

/// Progreso neutral por bloques de la consulta RUNT.
///
/// Está desacoplado de cualquier modelo de infraestructura.
class RuntQuerySteps {
  final RuntQueryStepStatus vehicle;
  final RuntQueryStepStatus soat;
  final RuntQueryStepStatus rtm;
  final RuntQueryStepStatus history;

  const RuntQuerySteps({
    required this.vehicle,
    required this.soat,
    required this.rtm,
    required this.history,
  });

  /// Estado inicial estándar del flujo.
  factory RuntQuerySteps.allPending() {
    return const RuntQuerySteps(
      vehicle: RuntQueryStepStatus.pending,
      soat: RuntQueryStepStatus.pending,
      rtm: RuntQueryStepStatus.pending,
      history: RuntQueryStepStatus.pending,
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle': vehicle.name,
        'soat': soat.name,
        'rtm': rtm.name,
        'history': history.name,
      };

  factory RuntQuerySteps.fromJson(Map<String, dynamic> json) {
    // La clave `owner` se ignora intencionalmente: el backend ya no la envía.
    // Drafts previos que contengan `owner` en el JSON no rompen el parseo.
    return RuntQuerySteps(
      vehicle: _stepFromString(json['vehicle'] as String?),
      soat: _stepFromString(json['soat'] as String?),
      rtm: _stepFromString(json['rtm'] as String?),
      history: _stepFromString(json['history'] as String?),
    );
  }

  static RuntQueryStepStatus _stepFromString(String? value) {
    switch (value) {
      case 'loading':
        return RuntQueryStepStatus.loading;
      case 'done':
        return RuntQueryStepStatus.done;
      case 'failed':
        return RuntQueryStepStatus.failed;
      case 'blocked':
        return RuntQueryStepStatus.blocked;
      case 'pending':
      default:
        return RuntQueryStepStatus.pending;
    }
  }

  @override
  String toString() {
    return 'RuntQuerySteps('
        'vehicle: $vehicle, '
        'soat: $soat, '
        'rtm: $rtm, '
        'history: $history'
        ')';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuntQuerySteps &&
          runtimeType == other.runtimeType &&
          vehicle == other.vehicle &&
          soat == other.soat &&
          rtm == other.rtm &&
          history == other.history;

  @override
  int get hashCode => Object.hash(vehicle, soat, rtm, history);
}

// ─────────────────────────────────────────────────────────────────────────────
// Resultado de estado del job
// ─────────────────────────────────────────────────────────────────────────────

/// Resultado neutral del estado actual de una consulta RUNT asíncrona.
class RuntAsyncQueryStatusResult {
  final String jobId;
  final RuntQueryJobStatus status;
  final RuntQuerySteps steps;

  /// Progreso total del job en porcentaje.
  ///
  /// Rango esperado: 0..100
  final int progressPercent;

  /// Datos parciales acumulados por bloques ya completados.
  final Map<String, dynamic>? partialData;

  /// Payload final completo cuando el job termina correctamente.
  final Map<String, dynamic>? finalData;

  /// Mensaje de error cuando el job falla (campo legacy).
  ///
  /// Prioridad de lectura: [failureMessage] > [failureReason] > [error].
  final String? error;

  /// Código de razón de fallo. Valor conocido clave:
  ///   `PARTIAL_EXTRACTION_ERROR` → fallo parcial con datos utilizables en [partialData].
  final String? failureReason;

  /// Mensaje de fallo legible para mostrar al usuario.
  final String? failureMessage;

  /// Última actualización reportada por backend.
  final DateTime? updatedAt;

  /// Momento de finalización del job, si backend lo reporta.
  final DateTime? completedAt;

  const RuntAsyncQueryStatusResult({
    required this.jobId,
    required this.status,
    required this.steps,
    required this.progressPercent,
    this.partialData,
    this.finalData,
    this.error,
    this.failureReason,
    this.failureMessage,
    this.updatedAt,
    this.completedAt,
  })  : assert(jobId != ''),
        assert(jobId != ' '),
        assert(progressPercent >= 0 && progressPercent <= 100);

  bool get hasPartialData => partialData != null && partialData!.isNotEmpty;
  bool get hasFinalData => finalData != null && finalData!.isNotEmpty;
  bool get isCompleted => status == RuntQueryJobStatus.completed;
  bool get isFailed => status == RuntQueryJobStatus.failed;
  bool get isRunning => status == RuntQueryJobStatus.running;
  bool get isPending => status == RuntQueryJobStatus.pending;

  @override
  String toString() {
    return 'RuntAsyncQueryStatusResult('
        'jobId: $jobId, '
        'status: $status, '
        'progressPercent: $progressPercent, '
        'hasPartialData: $hasPartialData, '
        'hasFinalData: $hasFinalData, '
        'error: $error, '
        'failureReason: $failureReason, '
        'updatedAt: $updatedAt, '
        'completedAt: $completedAt'
        ')';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuntAsyncQueryStatusResult &&
          runtimeType == other.runtimeType &&
          jobId == other.jobId &&
          status == other.status &&
          steps == other.steps &&
          progressPercent == other.progressPercent &&
          _mapEquals(partialData, other.partialData) &&
          _mapEquals(finalData, other.finalData) &&
          error == other.error &&
          failureReason == other.failureReason &&
          failureMessage == other.failureMessage &&
          updatedAt == other.updatedAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hash(
        jobId,
        status,
        steps,
        progressPercent,
        _mapHash(partialData),
        _mapHash(finalData),
        error,
        failureReason,
        failureMessage,
        updatedAt,
        completedAt,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers privados
// ─────────────────────────────────────────────────────────────────────────────

bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return a == b;
  if (a.length != b.length) return false;

  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

int _mapHash(Map<String, dynamic>? map) {
  if (map == null) return 0;
  return Object.hashAll(
    map.entries.map((e) => Object.hash(e.key, e.value)),
  );
}

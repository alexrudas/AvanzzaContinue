// ============================================================================
// lib/data/runt/models/runt_job_models.dart
//
// RUNT JOB MODELS — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Modelos para el sistema de consulta RUNT basado en jobs asíncronos.
//
// FLUJO DE API
//   POST /runt/query
//     → RuntQueryJobResponse(jobId)
//
//   GET /runt/query/{jobId}/status
//     → RuntJobStatusResponse
//
// OBJETIVO DE DISEÑO
// - Permitir polling de progreso por bloques.
// - Permitir mostrar datos parciales en Flutter antes de que termine todo.
// - Mantener compatibilidad con payloads crudos del backend mientras se
//   prepara un mapper tipado más rico en capas superiores.
//
// NOTA ARQUITECTÓNICA
// - `data` y `partialData` se mantienen como `Map<String, dynamic>` de forma
//   intencional como puente de integración.
// - La UI y el draft persistente NO deberían parsear estos mapas en muchos
//   lugares. La capa correcta para eso es un mapper dedicado:
//       RuntJobStatusResponse -> RuntVehicleResult / RuntVehiclePartialData
// ============================================================================

/// Estado global de la consulta RUNT.
enum RuntJobStatus {
  /// Job creado pero aún no procesado.
  pending,

  /// Job en ejecución.
  running,

  /// Job completado correctamente.
  completed,

  /// Job fallido.
  failed;

  static RuntJobStatus fromString(String? value) {
    switch (value) {
      case 'pending':
        return RuntJobStatus.pending;
      case 'running':
        return RuntJobStatus.running;
      case 'completed':
        return RuntJobStatus.completed;
      case 'failed':
        return RuntJobStatus.failed;
      default:
        return RuntJobStatus.pending;
    }
  }
}

/// Estado individual de cada bloque del scraping.
enum RuntJobStepStatus {
  /// Bloque aún no iniciado.
  pending,

  /// Bloque en proceso.
  loading,

  /// Bloque completado correctamente.
  done,

  /// Bloque fallido.
  failed;

  static RuntJobStepStatus fromString(String? value) {
    switch (value) {
      case 'loading':
        return RuntJobStepStatus.loading;
      case 'done':
        return RuntJobStepStatus.done;
      case 'failed':
        return RuntJobStepStatus.failed;
      default:
        return RuntJobStepStatus.pending;
    }
  }
}

/// Progreso por bloques de una consulta RUNT.
///
/// Cada propiedad representa un segmento del scraping.
class RuntJobSteps {
  final RuntJobStepStatus vehicle;
  final RuntJobStepStatus soat;
  final RuntJobStepStatus rtm;
  final RuntJobStepStatus history;

  const RuntJobSteps({
    required this.vehicle,
    required this.soat,
    required this.rtm,
    required this.history,
  });

  /// Estado inicial estándar.
  factory RuntJobSteps.allPending() => const RuntJobSteps(
        vehicle: RuntJobStepStatus.pending,
        soat: RuntJobStepStatus.pending,
        rtm: RuntJobStepStatus.pending,
        history: RuntJobStepStatus.pending,
      );

  factory RuntJobSteps.fromJson(Map<String, dynamic> json) {
    // La clave `owner` se ignora intencionalmente: el backend ya no la envía.
    // Drafts previos que contengan `owner` en el JSON no rompen el parseo.
    return RuntJobSteps(
      vehicle: RuntJobStepStatus.fromString(json['vehicle'] as String?),
      soat: RuntJobStepStatus.fromString(json['soat'] as String?),
      rtm: RuntJobStepStatus.fromString(json['rtm'] as String?),
      history: RuntJobStepStatus.fromString(json['history'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle': vehicle.name,
        'soat': soat.name,
        'rtm': rtm.name,
        'history': history.name,
      };

  /// true si todos los bloques están en done.
  bool get isFullyDone =>
      vehicle == RuntJobStepStatus.done &&
      soat == RuntJobStepStatus.done &&
      rtm == RuntJobStepStatus.done &&
      history == RuntJobStepStatus.done;

  /// Número de bloques completados.
  int get completedCount {
    int count = 0;
    if (vehicle == RuntJobStepStatus.done) count++;
    if (soat == RuntJobStepStatus.done) count++;
    if (rtm == RuntJobStepStatus.done) count++;
    if (history == RuntJobStepStatus.done) count++;
    return count;
  }

  /// Total fijo de bloques modelados.
  int get totalCount => 4;

  /// Porcentaje redondeado de progreso.
  int get progressPercent => ((completedCount / totalCount) * 100).round();
}

/// Respuesta de creación del job.
///
/// Contrato esperado:
/// ```json
/// {
///   "jobId": "abc123"
/// }
/// ```
class RuntQueryJobResponse {
  final String jobId;

  const RuntQueryJobResponse({
    required this.jobId,
  });

  factory RuntQueryJobResponse.fromJson(Map<String, dynamic> json) {
    final rawJobId = json['jobId'];
    if (rawJobId is! String || rawJobId.trim().isEmpty) {
      throw const FormatException(
        'RuntQueryJobResponse inválido: jobId ausente o vacío.',
      );
    }

    return RuntQueryJobResponse(jobId: rawJobId);
  }

  Map<String, dynamic> toJson() => {
        'jobId': jobId,
      };
}

/// Respuesta de estado del job.
///
/// Contrato esperado de backend:
/// ```json
/// {
///   "jobId": "abc123",
///   "status": "running",
///   "steps": {
///     "vehicle": "done",
///     "owner": "done",
///     "soat": "loading",
///     "rtm": "pending",
///     "history": "pending"
///   },
///   "partialData": {
///     "vehicle": {...},
///     "owner": {...}
///   },
///   "data": null,
///   "error": null,
///   "updatedAt": "2026-03-08T14:22:00Z",
///   "completedAt": null,
///   "progressPercent": 40
/// }
/// ```
class RuntJobStatusResponse {
  final String jobId;
  final RuntJobStatus status;
  final RuntJobSteps steps;

  /// Datos parciales acumulados por bloque.
  ///
  /// Ejemplo:
  /// {
  ///   "vehicle": {...},
  ///   "owner": {...}
  /// }
  ///
  /// Se usa para renderizar progreso útil antes de que el job termine.
  final Map<String, dynamic>? partialData;

  /// Payload completo del job, disponible normalmente cuando status=completed.
  final Map<String, dynamic>? data;

  /// Mensaje de error si status=failed.
  final String? error;

  /// Timestamp de actualización del job, si el backend lo provee.
  final DateTime? updatedAt;

  /// Timestamp de finalización del job, si el backend lo provee.
  final DateTime? completedAt;

  /// Progreso porcentual.
  ///
  /// Si el backend no lo envía, se calcula desde `steps`.
  final int progressPercent;

  const RuntJobStatusResponse({
    required this.jobId,
    required this.status,
    required this.steps,
    required this.progressPercent,
    this.partialData,
    this.data,
    this.error,
    this.updatedAt,
    this.completedAt,
  });

  factory RuntJobStatusResponse.fromJson(Map<String, dynamic> json) {
    final rawJobId = json['jobId'];
    if (rawJobId is! String || rawJobId.trim().isEmpty) {
      throw const FormatException(
        'RuntJobStatusResponse inválido: jobId ausente o vacío.',
      );
    }

    final steps = json['steps'] is Map<String, dynamic>
        ? RuntJobSteps.fromJson(json['steps'] as Map<String, dynamic>)
        : RuntJobSteps.allPending();

    final rawProgress = json['progressPercent'];
    final computedProgress = steps.progressPercent;

    return RuntJobStatusResponse(
      jobId: rawJobId,
      status: RuntJobStatus.fromString(json['status'] as String?),
      steps: steps,
      partialData: _asMapOrNull(json['partialData']),
      data: _asMapOrNull(json['data']),
      error: json['error'] as String?,
      updatedAt: _parseDateTime(json['updatedAt']),
      completedAt: _parseDateTime(json['completedAt']),
      progressPercent: rawProgress is int ? rawProgress : computedProgress,
    );
  }

  Map<String, dynamic> toJson() => {
        'jobId': jobId,
        'status': status.name,
        'steps': steps.toJson(),
        'partialData': partialData,
        'data': data,
        'error': error,
        'updatedAt': updatedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'progressPercent': progressPercent,
      };

  bool get isPending => status == RuntJobStatus.pending;
  bool get isRunning => status == RuntJobStatus.running;
  bool get isCompleted => status == RuntJobStatus.completed;
  bool get isFailed => status == RuntJobStatus.failed;

  /// true si ya existe algo útil para pintar en UI aunque no haya terminado.
  bool get hasPartialData => partialData != null && partialData!.isNotEmpty;

  /// true si hay payload final.
  bool get hasFinalData => data != null && data!.isNotEmpty;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers privados
// ─────────────────────────────────────────────────────────────────────────────

Map<String, dynamic>? _asMapOrNull(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}

DateTime? _parseDateTime(dynamic value) {
  if (value is! String || value.trim().isEmpty) return null;
  return DateTime.tryParse(value);
}

// ============================================================================
// lib/data/vrc/models/vrc_batch_models.dart
// VRC BATCH MODELS — Data Layer / DTOs para consulta multi-placa
//
// QUÉ HACE:
// - Define los DTOs para los endpoints batch de la API VRC:
//     POST /v1/vrc-batches   → VrcBatchCreateResponseModel
//     GET  /v1/vrc-batches/:id → VrcBatchStatusResponseModel + VrcBatchItemModel
// - Parsea defensivamente los campos de la respuesta real del backend.
// - VrcBatchItemModel almacena el campo `context` como Map raw para uso
//   posterior (mapeo a VrcDataModel en el flujo de registro).
//
// QUÉ NO HACE:
// - No contiene lógica de negocio ni reglas operativas.
// - No persiste en Isar — el estado vive en VrcBatchController (memoria).
// - No parsea profundamente el context de cada ítem (eso lo hace el flujo
//   de registro individual una vez completada la consulta).
//
// PRINCIPIOS:
// - Null-safe: todos los campos opcionales del contrato son nullable.
// - Defensivo: lista vacía ante null/tipo incorrecto en items[].
// - isTerminal: determinado por el estado del batch completo, no por items.
//
// CONTRATO REAL (backend Node.js):
// POST /v1/vrc-batches → { ok, batchId, status: "queued" }
// GET  /v1/vrc-batches/:id → { ok, batchId, status, items[{plate, status, context, error}] }
// items[].status → "succeeded" | "failed" | "pending"
// items[].context → VEHICLE_REGISTRATION_CONTEXT | null
// rc/rtm vacíos NO son error.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Multi-plate batch registration — Phase 1.
// ACTUALIZADO (2026-04): +errorCode + retryable por ítem — fail-fast Flutter.
//   errorCode es la fuente de verdad para clasificar el fallo por placa.
//   retryable=false → Flutter hace fail inmediato sin esperar timeout global.
// ============================================================================

// ── Helpers ────────────────────────────────────────────────────────────────

String? _str(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

// ── CREATE BATCH ──────────────────────────────────────────────────────────

/// DTO para la respuesta del endpoint POST /v1/vrc-batches.
///
/// - [ok]: éxito técnico de la creación.
/// - [batchId]: identificador UUID del batch creado, necesario para el polling.
/// - [status]: estado inicial del batch (normalmente "queued").
/// - [errorMessage]: mensaje de error cuando ok == false.
class VrcBatchCreateResponseModel {
  final bool ok;
  final String? batchId;
  final String? status;
  final String? errorMessage;

  const VrcBatchCreateResponseModel({
    required this.ok,
    this.batchId,
    this.status,
    this.errorMessage,
  });

  factory VrcBatchCreateResponseModel.fromJson(Map<String, dynamic> json) {
    String? errorMsg;
    final rawError = json['error'];
    if (rawError is Map<String, dynamic>) {
      errorMsg = _str(rawError['message']);
    }

    return VrcBatchCreateResponseModel(
      ok: (json['ok'] as bool?) ?? false,
      batchId: _str(json['batchId']),
      status: _str(json['status']),
      errorMessage: errorMsg,
    );
  }
}

// ── POLL BATCH ────────────────────────────────────────────────────────────

/// DTO para la respuesta del endpoint GET /v1/vrc-batches/:batchId.
///
/// - [status]: estado global del batch: queued | running | completed |
///   partially_completed | failed | cancelled.
/// - [items]: lista de placas con su estado individual de consulta.
/// - [isTerminal]: true cuando el backend ya no va a actualizar más el estado.
class VrcBatchStatusResponseModel {
  final bool ok;
  final String batchId;
  final String status;
  final List<VrcBatchItemModel> items;

  const VrcBatchStatusResponseModel({
    required this.ok,
    required this.batchId,
    required this.status,
    required this.items,
  });

  /// El backend ya no actualizará este batch — el polling puede detenerse.
  bool get isTerminal => const {
        'completed',
        'partially_completed',
        'failed',
        'cancelled',
      }.contains(status);

  factory VrcBatchStatusResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = <VrcBatchItemModel>[];
    if (rawItems is List) {
      for (final raw in rawItems) {
        if (raw is Map<String, dynamic>) {
          items.add(VrcBatchItemModel.fromJson(raw));
        }
      }
    }

    return VrcBatchStatusResponseModel(
      ok: (json['ok'] as bool?) ?? false,
      batchId: _str(json['batchId']) ?? '',
      status: _str(json['status']) ?? '',
      items: items,
    );
  }
}

/// DTO para un ítem individual dentro de la respuesta de polling.
///
/// - [plate]: placa del vehículo (uppercase desde el backend).
/// - [status]: "succeeded" | "failed" | "pending".
/// - [context]: mapa raw con los datos del vehículo (VEHICLE_REGISTRATION_CONTEXT).
///   Null si la consulta falló o aún está pendiente.
///   Para convertir a VrcDataModel: VrcDataModel.fromJson(context!).
/// - [errorCode]: código de error tipado del backend (ej. RUNT_OWNER_MISMATCH).
///   Fuente de verdad para la clasificación del error. Null si no hay error.
/// - [errorMessage]: descripción textual del backend para apoyo al usuario.
///   Solo usar como fallback cuando no haya errorCode.
/// - [retryable]: si false, el ítem no debe continuar en consulta —
///   Flutter debe transicionarlo a failed sin esperar timeout global.
///   Default true para compatibilidad con respuestas que no incluyan el campo.
class VrcBatchItemModel {
  final String plate;
  final String status;

  /// Datos completos del vehículo — mismo contrato que VrcDataModel.
  ///
  /// Almacenado como Map raw para desacoplamiento: el flujo de registro
  /// individual lo convierte a VrcDataModel cuando el usuario decide registrar.
  final Map<String, dynamic>? context;

  /// Código de error tipado del backend.
  ///
  /// Fuente de verdad para la clasificación del fallo. Ejemplos:
  /// RUNT_OWNER_MISMATCH, RUNT_NOT_FOUND, RUNT_NAV_TIMEOUT, OCR_NO_RESULT.
  /// Flutter debe usar este campo — no inferir errores por [errorMessage].
  final String? errorCode;

  /// Descripción textual del error — solo para apoyo al usuario cuando
  /// no exista un mapeo canónico para [errorCode].
  final String? errorMessage;

  /// Si false, el error es definitivo y no debe reintentarse.
  ///
  /// Flutter debe marcar el ítem como failed inmediatamente, sin esperar
  /// que el batch overall llegue a estado terminal ni al timeout global.
  /// Ejemplos: RUNT_OWNER_MISMATCH, RUNT_NO_DATA (errores de negocio).
  final bool retryable;

  const VrcBatchItemModel({
    required this.plate,
    required this.status,
    this.context,
    this.errorCode,
    this.errorMessage,
    this.retryable = true,
  });

  bool get isSucceeded => status == 'succeeded';
  bool get isFailed => status == 'failed';
  bool get isPending => !isSucceeded && !isFailed;

  factory VrcBatchItemModel.fromJson(Map<String, dynamic> json) {
    String? errorMsg;
    final rawError = json['error'];
    if (rawError is Map<String, dynamic>) {
      errorMsg = _str(rawError['message']);
    } else if (rawError is String) {
      errorMsg = rawError;
    }

    final rawContext = json['context'];
    final context =
        rawContext is Map<String, dynamic> ? rawContext : null;

    return VrcBatchItemModel(
      plate: _str(json['plate'])?.toUpperCase() ?? '',
      status: _str(json['status']) ?? 'pending',
      context: context,
      errorCode: _str(json['errorCode']),
      errorMessage: errorMsg,
      // Default true: si el backend no incluye retryable, tratar como retryable
      // para no fail-fast prematuramente en respuestas antiguas o parciales.
      retryable: (json['retryable'] as bool?) ?? true,
    );
  }
}

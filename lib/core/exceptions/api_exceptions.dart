// ===================== lib/core/exceptions/api_exceptions.dart =====================

/// Excepción base para errores de API.
///
/// Todas las excepciones específicas de API heredan de esta clase.
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? requestId;

  const ApiException({
    required this.message,
    this.statusCode,
    this.requestId,
  });

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (statusCode != null) buffer.write(' (HTTP $statusCode)');
    if (requestId != null) buffer.write(' [RequestId: $requestId]');
    return buffer.toString();
  }
}

// ==================== EXCEPCIONES RUNT ====================

/// Excepción específica para errores de la API del RUNT.
///
/// Se lanza cuando:
/// - La respuesta HTTP no es 200
/// - El campo `ok` es false
/// - Faltan campos requeridos en la respuesta
/// - El parsing de la respuesta falla
class RuntApiException extends ApiException {
  /// Fuente del error: "network", "parsing", "business_logic"
  final String? errorSource;

  const RuntApiException({
    required super.message,
    super.statusCode,
    super.requestId,
    this.errorSource,
  });

  /// Constructor para errores de red (timeouts, no connection, etc.)
  factory RuntApiException.network(String message) {
    return RuntApiException(
      message: message,
      errorSource: 'network',
    );
  }

  /// Constructor para errores de parsing JSON
  factory RuntApiException.parsing(String message, {Object? originalError}) {
    return RuntApiException(
      message: 'Error parseando respuesta RUNT: $message',
      errorSource: 'parsing',
    );
  }

  /// Constructor para errores de lógica de negocio (ok=false)
  factory RuntApiException.businessLogic({
    required String message,
    int? statusCode,
    String? requestId,
  }) {
    return RuntApiException(
      message: message,
      statusCode: statusCode,
      requestId: requestId,
      errorSource: 'business_logic',
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('RuntApiException');
    if (errorSource != null) buffer.write(' [$errorSource]');
    buffer.write(': $message');
    if (statusCode != null) buffer.write(' (HTTP $statusCode)');
    if (requestId != null) buffer.write(' [RequestId: $requestId]');
    return buffer.toString();
  }
}

// ==================== EXCEPCIONES SIMIT ====================

/// Excepción específica para errores de la API de SIMIT.
///
/// Se lanza cuando:
/// - La respuesta HTTP no es 200
/// - El campo `ok` es false
/// - Faltan campos requeridos en la respuesta
/// - El parsing de la respuesta falla
class SimitApiException extends ApiException {
  /// Fuente del error: "network", "parsing", "business_logic"
  final String? errorSource;

  const SimitApiException({
    required super.message,
    super.statusCode,
    super.requestId,
    this.errorSource,
  });

  /// Constructor para errores de red (timeouts, no connection, etc.)
  factory SimitApiException.network(String message) {
    return SimitApiException(
      message: message,
      errorSource: 'network',
    );
  }

  /// Constructor para errores de parsing JSON
  factory SimitApiException.parsing(String message, {Object? originalError}) {
    return SimitApiException(
      message: 'Error parseando respuesta SIMIT: $message',
      errorSource: 'parsing',
    );
  }

  /// Constructor para errores de lógica de negocio (ok=false)
  factory SimitApiException.businessLogic({
    required String message,
    int? statusCode,
    String? requestId,
  }) {
    return SimitApiException(
      message: message,
      statusCode: statusCode,
      requestId: requestId,
      errorSource: 'business_logic',
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('SimitApiException');
    if (errorSource != null) buffer.write(' [$errorSource]');
    buffer.write(': $message');
    if (statusCode != null) buffer.write(' (HTTP $statusCode)');
    if (requestId != null) buffer.write(' [RequestId: $requestId]');
    return buffer.toString();
  }
}
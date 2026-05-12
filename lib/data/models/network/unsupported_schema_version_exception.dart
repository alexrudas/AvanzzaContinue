// ============================================================================
// lib/data/models/network/unsupported_schema_version_exception.dart
// UNSUPPORTED SCHEMA VERSION EXCEPTION — Señal tipada de contrato incompatible
// ============================================================================
// QUÉ HACE:
//   - Excepción tipada que el envelope lanza cuando recibe una respuesta con
//     `schemaVersion` distinto al que esta build de la app sabe consumir.
//
// CUÁNDO SE LANZA:
//   - Backend bumpeó schemaVersion (breaking change) y la app no se actualizó.
//
// CÓMO MANEJARLA:
//   - El repository la deja burbujear hasta el controller.
//   - El controller debe mapear esto a un estado UI específico:
//     "Versión de la app desactualizada. Actualiza Avanzza para continuar."
//   - NO se debe reintentar automáticamente (el problema no es transitorio).
// ============================================================================

/// Lanzada cuando un envelope llega con un schemaVersion no soportado por
/// esta build de Flutter.
class UnsupportedSchemaVersionException implements Exception {
  /// schemaVersion recibido del backend.
  final int received;

  /// schemaVersion(es) que esta build soporta.
  final List<int> supported;

  /// Endpoint del que vino la respuesta (para debugging/telemetría).
  final String endpoint;

  const UnsupportedSchemaVersionException({
    required this.received,
    required this.supported,
    required this.endpoint,
  });

  @override
  String toString() =>
      'UnsupportedSchemaVersionException(endpoint=$endpoint, '
      'received=$received, supported=$supported)';
}

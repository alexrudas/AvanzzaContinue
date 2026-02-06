/// Avanzza 2.0 · TimestampConverter
/// ------------------------------------------------------------
/// Propósito:
/// - Unificar el manejo de marcas de tiempo entre Firestore (Timestamp)
///   y los modelos (DateTime) sin romper dominio ni flujo offline-first.
/// - Facilitar la serialización/deserialización con json_serializable
///   y la persistencia local (Isar) manteniendo compatibilidad.
///
/// Casos de uso:
/// - Remoto (Firestore JSON): usar Timestamp nativo en mapas enviados a Firestore.
/// - Local (Isar/offline): permitir String ISO-8601 o epoch (int) para caché,
///   y convertirlo de forma segura a DateTime.
///
/// Recomendación de uso:
/// - En modelos data/* que utilicen json_serializable, anotar:
///     @TimestampJsonConverter() final DateTime? createdAt;
///     @TimestampJsonConverter() final DateTime? updatedAt;
/// - En repos/DS donde necesites convertir manualmente:
///     const ts = TimestampConverter();
///     final dt = ts.fromTimestamp(snapshot['updatedAt'] as Timestamp?);
///     final firestoreTs = ts.toTimestamp(model.updatedAt);
///
/// Decisión de formato al serializar:
/// - A través de @TimestampJsonConverter.toJson() se retorna, por defecto,
///   un Timestamp de Firestore para garantizar compatibilidad con backends
///   y writes remotos.
/// - En escenarios donde se quiera persistir localmente como String/epoch,
///   preferir un método alterno (p. ej., toIsarJson()) en el modelo que
///   serialice a ISO-8601 o epoch explícitamente.
///
/// Compatibilidad:
/// - fromJson acepta: null, Timestamp, int (epoch ms), String (ISO-8601).
/// - toJson emite Timestamp por defecto (ver comentarios en método).
///
/// ------------------------------------------------------------
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Conversor simple entre Firestore.Timestamp y DateTime
///
/// Útil en lógica de repos/DS cuando no se usa json_serializable.
/// Mantiene una conversión directa y explícita:
/// - fromTimestamp(Timestamp?) → DateTime?
/// - toTimestamp(DateTime?) → Timestamp?
class TimestampConverter {
  /// Constructor const: sin estado y seguro de reusar.
  const TimestampConverter();

  /// Convierte un Timestamp de Firestore (o null) a DateTime (o null).
  ///
  /// Parámetros:
  /// - [ts]: instancia de Timestamp o null.
  ///
  /// Retorno:
  /// - DateTime equivalente a ts (en zona horaria local) o null.
  DateTime? fromTimestamp(Timestamp? ts) => ts?.toDate();

  /// Convierte un DateTime (o null) a Timestamp de Firestore (o null).
  ///
  /// Parámetros:
  /// - [dt]: instancia de DateTime o null.
  ///
  /// Retorno:
  /// - Timestamp.fromDate(dt) o null si dt es null.
  Timestamp? toTimestamp(DateTime? dt) => dt == null ? null : Timestamp.fromDate(dt);
}

/// JsonConverter para json_serializable que maneja createdAt/updatedAt
/// aceptando múltiples formatos de entrada y emitiendo Timestamp por defecto.
///
/// Entradas aceptadas en fromJson:
/// - null
/// - Timestamp (Firestore)
/// - int (epoch milliseconds)
/// - String (ISO-8601)
///
/// Salida de toJson:
/// - Timestamp (Firestore) por defecto para compatibilidad de writes remotos.
///   Si necesitas persistir localmente como String/epoch, evita este converter
///   y utiliza rutas de serialización alternativas (p. ej., toIsarJson()).
///
/// Ejemplo de uso en modelo:
///   @TimestampJsonConverter()
///   final DateTime? createdAt;
///
///   @TimestampJsonConverter()
///   final DateTime? updatedAt;
class TimestampJsonConverter implements JsonConverter<DateTime?, Object?> {
  /// Constructor const: no mantiene estado; seguro para reuso.
  const TimestampJsonConverter();

  /// Deserializa a DateTime? desde varios formatos soportados.
  ///
  /// Parámetros:
  /// - [value]: puede ser null, Timestamp, int epoch ms, o String ISO-8601.
  ///
  /// Retorno:
  /// - DateTime? equivalente al valor de entrada, o null si value es null.
  ///
  /// Errores:
  /// - Lanza FormatException si el tipo es no soportado o el parse falla.
  @override
  DateTime? fromJson(Object? value) {
    if (value == null) return null;

    // Firestore Timestamp
    if (value is Timestamp) return value.toDate();

    // Epoch (ms) almacenado localmente
    if (value is int) {
      try {
        // Suponemos epoch en milisegundos. Convertimos a DateTime local.
        return DateTime.fromMillisecondsSinceEpoch(value);
      } catch (_) {
        throw const FormatException('Invalid epoch for TimestampJsonConverter');
      }
    }

    // ISO-8601 (común en serializaciones locales)
    if (value is String) {
      final dt = DateTime.tryParse(value);
      if (dt != null) return dt;
      throw const FormatException('Invalid ISO-8601 for TimestampJsonConverter');
    }

    // Tipo no soportado
    throw FormatException(
      'Unsupported type for TimestampJsonConverter: ${value.runtimeType}',
    );
  }

  /// Serializa DateTime? a un valor JSON compatible con Firestore/remote.
  ///
  /// Por defecto retorna un Timestamp para garantizar que los writes remotos
  /// funcionen sin conversiones adicionales.
  ///
  /// Parámetros:
  /// - [date]: instancia de DateTime o null.
  ///
  /// Retorno:
  /// - Timestamp (si date != null) o null.
  ///
  /// Nota:
  /// - Si necesitas un formato puramente local (String/epoch), evita este
  ///   converter y define un método de serialización local (toIsarJson()).
  @override
  Object? toJson(DateTime? date) {
    if (date == null) return null;
    // Preferimos Timestamp para compatibilidad con Firestore.
    return Timestamp.fromDate(date);
  }
}
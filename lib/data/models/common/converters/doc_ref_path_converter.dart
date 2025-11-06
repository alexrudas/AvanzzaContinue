/// Avanzza 2.0 · DocRefPathConverter
/// ------------------------------------------------------------
/// Propósito:
/// - Soportar de forma segura DocumentReference (Firestore) y path String (Isar/local)
///   sin romper el dominio ni el flujo offline-first.
/// - Centralizar la conversión path <-> DocumentReference, y documentar su uso.
///
/// Contexto de uso:
/// - Firestore JSON (remoto): usa DocumentReference nativo en los mapas que se envían
///   a Firestore (no serialices a String).
/// - Isar/local (persistencia): guarda los refs como String path (e.g. "/orgs/ORG1")
///   para que Isar pueda indexar/cachar sin dependencias de Firestore en disco.
///
/// Recomendación de patrón:
/// - En cada Model (data/models/*), implementa fábricas duales para aislar diferencias:
///     - fromFirestore(String docId, Map<String,dynamic> json, {FirebaseFirestore db})
///         Lee DocumentReference nativos; si recibes path como String, conviértelo a ref con db.doc(path)
///     - toFirestoreJson()
///         Devuelve Map<String,dynamic> con DocumentReference y Timestamp (no paths)
///     - fromIsar(Map<String,dynamic> isarJson, FirebaseFirestore db)
///         Lee paths (String) y conviértelos a DocumentReference con DocRefPathConverter
///     - toIsarJson()
///         Devuelve paths String en lugar de DocumentReference
///
/// Importante sobre JsonConverter:
/// - Un JsonConverter/@JsonKey requiere valores "const". FirebaseFirestore.instance NO es const,
///   por lo que NO puedes usar un converter que reciba 'db' como argumento directamente en el
///   decorador @JsonKey(). En su lugar:
///   1) Usa fábricas fromFirestore/fromIsar que reciban db en runtime (recomendado), o
///   2) Modela el campo para Isar como String path en el modelo y mapea externamente a DocumentReference
///      (para Firestore) en toFirestoreJson().
///
/// Ejemplos de uso recomendados (dentro de un Model):
///
///   // A) fromFirestore: acepta ref nativo o path string
///   factory MyModel.fromFirestore(String docId, Map<String, dynamic> json, {FirebaseFirestore? db}) {
///     final refAny = json['orgRef'];
///     DocumentReference<Map<String, dynamic>>? orgRef;
///     if (refAny is DocumentReference) {
///       orgRef = refAny.withConverter<Map<String, dynamic>>(
///         fromFirestore: (s, _) => s.data() ?? <String, dynamic>{},
///         toFirestore: (m, _) => m,
///       );
///     } else if (refAny is String && db != null && refAny.isNotEmpty) {
///       orgRef = db.doc(refAny);
///     }
///     // ... construir el modelo (usa *_Id como fallback si hace falta)
///   }
///
///   // B) toIsarJson: persistir paths
///   Map<String, dynamic> toIsarJson() {
///     return {
///       'orgRefPath': orgRef?.path, // <- path string para Isar
///       // ...
///     };
///   }
///
///   // C) fromIsar: reconstruir refs desde paths
///   factory MyModel.fromIsar(Map<String, dynamic> isar, FirebaseFirestore db) {
///     final conv = const DocRefPathConverter();
///     final path = isar['orgRefPath'] as String?;
///     final orgRef = conv.fromPath(db, path);
///     // ... construir el modelo
///   }
///
/// Consideraciones de seguridad/robustez:
/// - fromPath(): retorna null si path es null o vacío (defensivo).
/// - toPath(): retorna null si ref es null.
/// - No valida el "formato" del path; se asume que proviene de tu propia escritura o de una fuente validada.
///
/// ------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Conversor (runtime) path <-> DocumentReference
///
/// Úsalo:
/// - En fábricas fromIsar/fromFirestore de tus modelos (recomendado).
/// - En mapeos puntuales donde necesites reconstruir un ref a partir de un path.
class DocRefPathConverter {
  /// Constructor const: sin estado interno; idempotente.
  const DocRefPathConverter();

  /// Convierte un path (String) a DocumentReference, o null si no aplica.
  ///
  /// Parámetros:
  /// - db: instancia de FirebaseFirestore (requerida para construir el ref).
  /// - path: ruta Firestore tipo "/collection/doc/collection2/doc2".
  ///
  /// Retorna:
  /// - DocumentReference<Map<String, dynamic>> si path es válido y no vacío.
  /// - null si path es null o vacío (defensivo para datos incompletos).
  ///
  /// Nota:
  /// - No verifica la existencia del documento remoto; solo resuelve el ref.
  DocumentReference<Map<String, dynamic>>? fromPath(
    FirebaseFirestore db,
    String? path,
  ) {
    if (path == null || path.isEmpty) return null;
    return db.doc(path);
  }

  /// Extrae el path de un DocumentReference (o null si el ref es null).
  ///
  /// Útil para:
  /// - Serializar a Isar/local como String, para persistencia offline y/o índices.
  ///
  /// Ejemplo:
  ///   final path = conv.toPath(model.orgRef); // "/orgs/ORG1"
  String? toPath(DocumentReference<Map<String, dynamic>>? ref) {
    return ref?.path;
  }
}

/// JsonConverter path <-> DocumentReference (opcional)
///
/// Advertencia práctica:
/// - No puede usarse directamente con @JsonKey() si requiere un FirebaseFirestore
///   dinámico (no-const). Los decoradores requieren constantes.
/// - Empléalo solo cuando serialices estructuras auxiliares donde controles la
///   inyección del 'db' en runtime (p.ej., a través de factorías que construyan
///   este converter y llamen manualmente a fromJson/toJson).
///
/// Ejemplo (no @JsonKey): uso manual en factoría
///   final conv = DocRefJsonConverter(db);
///   final orgRef = conv.fromJson(json['orgRefPath'] as String?);
///
/// Preferencia del proyecto:
/// - Usar fábricas fromFirestore/fromIsar y toFirestoreJson/toIsarJson en los
///   modelos, y evitar @JsonKey con converters que requieran db.
class DocRefJsonConverter
    implements
        JsonConverter<DocumentReference<Map<String, dynamic>>?, String?> {
  const DocRefJsonConverter(this.db);

  /// Instancia de Firestore necesaria para crear refs desde paths.
  final FirebaseFirestore db;

  /// Convierte un path a DocumentReference (o null).
  @override
  DocumentReference<Map<String, dynamic>>? fromJson(String? path) =>
      (path == null || path.isEmpty) ? null : db.doc(path);

  /// Convierte un DocumentReference a path string (o null).
  @override
  String? toJson(DocumentReference<Map<String, dynamic>>? ref) => ref?.path;
}
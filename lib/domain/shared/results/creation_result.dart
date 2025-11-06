// lib/domain/shared/results/creation_result.dart
// Patrón Result para operaciones de creación con acumulación de errores.
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

// Comentarios en el código: error de validación individual con campo y mensaje.
class ValidationError {
  final String field;
  final String message;

  const ValidationError(this.field, this.message);

  @override
  String toString() => '$field: $message';
}

// Comentarios en el código: resultado sellado de creación con patrón success/failure para acumular errores.
abstract class CreationResult<T> {
  const CreationResult();

  bool get isSuccess;
  bool get isFailure => !isSuccess;

  T get value;
  List<ValidationError> get errors;

  factory CreationResult.success(T entity) = CreationSuccess<T>;
  factory CreationResult.failure(List<ValidationError> errors) =
      CreationFailure<T>;
}

// Comentarios en el código: resultado exitoso con valor.
class CreationSuccess<T> extends CreationResult<T> {
  final T _value;

  const CreationSuccess(this._value);

  @override
  bool get isSuccess => true;

  @override
  T get value => _value;

  @override
  List<ValidationError> get errors => const [];
}

// Comentarios en el código: resultado fallido con lista de errores inmutable.
class CreationFailure<T> extends CreationResult<T> {
  final List<ValidationError> _errors;

  const CreationFailure(this._errors);

  @override
  bool get isSuccess => false;

  @override
  T get value => throw StateError('No value on failure');

  @override
  List<ValidationError> get errors => List.unmodifiable(_errors);
}

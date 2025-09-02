class Result<T> {
  final T? data;
  final Object? error;

  bool get isOk => error == null;
  bool get isErr => error != null;

  Result.ok(this.data) : error = null;
  Result.err(this.error) : data = null;

  R fold<R>({required R Function(T data) ok, required R Function(Object error) err}) {
    if (isOk) return ok(data as T);
    return err(error!);
  }
}

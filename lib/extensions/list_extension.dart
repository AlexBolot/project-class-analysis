extension IterableExtension<T> on Iterable<T> {
  T? get firstIfAny => isEmpty ? null : first;

  T? get lastIfAny => isEmpty ? null : last;

  bool none(bool Function(T element) test) => !any(test);

  List<T> unique() => Set<T>.from(this).toList();
}

extension IterableExtensionNullable<T> on Iterable<T?> {
  T? singleWhereIfAny(bool Function(T? element) test, {T? Function()? orElse}) =>
      singleWhere(test, orElse: orElse ?? () => null as T);

  T? lastWhereIfAny(bool Function(T? element) test, {T? Function()? orElse}) =>
      lastWhere(test, orElse: orElse ?? () => null as T);

  List<T> whereNotNull() => where((i) => i != null).toList().cast<T>();
}

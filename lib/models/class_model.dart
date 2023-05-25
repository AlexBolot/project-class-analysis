class ClassModel {
  String? name;
  List<ClassModel>? dependencies;
  ClassModel? parent;

  @override
  String toString() {
    var toString = name ?? '';

    if (parent != null) {
      toString += '\n -> extends ${parent?.name}';
    }

    return toString;
  }
}

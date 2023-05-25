class ClassModel {
  String? name;
  List<ClassModel> dependencies;
  List<ClassModel> mixins;
  ClassModel? parent;

  ClassModel({
    required this.name,
    List<ClassModel>? dependencies,
    List<ClassModel>? mixins,
    this.parent,
  })  : dependencies = dependencies ?? <ClassModel>[],
        mixins = mixins ?? <ClassModel>[];

  @override
  String toString() {
    var toString = name ?? '';

    if (parent != null) {
      toString += '\n -> extends ${parent?.name}';
    }

    if (dependencies.isNotEmpty) {
      toString += '\n -> depends on ${dependencies.map((e) => e.name).toList()}';
    }

    if (mixins.isNotEmpty) {
      toString += '\n -> mixed with ${mixins.map((e) => e.name).toList()}';
    }

    return toString;
  }
}

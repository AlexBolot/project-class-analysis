class ClassModel {
  String name;
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

  List<String> toGraphviz() {
    var res = <String>[];
    //res.add(name);

    if (parent != null) {
      res.add('$name -> ${parent!.name} [ arrowhead = empty ];');
    }

    for (var mixin in mixins) {
      res.add('$name -> ${mixin.name} [ arrowhead = odot ];');
    }

    for (var dependency in dependencies) {
      res.add('${dependency.name} -> $name [ arrowhead = ediamond ];');
    }

    res.removeWhere((line) => line.contains('Synchronizable'));

    return res;
  }

  @override
  String toString() {
    var toString = name;

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

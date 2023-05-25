import 'dart:io';

import 'package:project_class_analysis/extensions/list_extension.dart';
import 'package:project_class_analysis/extensions/regex_extension.dart';
import 'package:project_class_analysis/extensions/string_extension.dart';

import 'models/class_model.dart';

class FileAnalyser {
  Future<List<ClassModel>> extractClasses(File file) async {
    if (file.path.endsWith('_jorm.dart') || file.path.endsWith('_bean.dart')) return [];

    final fileContent = file.readAsStringSync();

    final classPattern = RegExp(r'class .* \{((.|\n)*?)\}');
    final classes = classPattern.allStringMatches(fileContent);

    final classModels = <ClassModel?>[];
    for (String strClass in classes) {
      final model = ClassModel(
        name: _extractClassName(strClass),
        parent: _extractParentClassName(strClass),
        mixins: _extractMixinNames(strClass),
        dependencies: _extractDependencies(strClass),
      );
      classModels.add(model);
    }

    return classModels.where((model) => model?.name?.isNotEmpty ?? false).whereNotNull();
  }

  String? _extractClassName(String strClass) {
    /// Generates a String formatted as : "class ClassName "
    final classNamePattern = RegExp(r'class [^_][\w<>]* ');

    final rawClassName = classNamePattern.firstStringMatch(strClass)?.trim();
    return rawClassName?.split(' ')[1];
  }

  ClassModel? _extractParentClassName(String strClass) {
    /// Generates a String formatted as : "extends ClassName "
    final parentNamePattern = RegExp(r'extends [\w<>]* ');

    final rawParentName = parentNamePattern.firstStringMatch(strClass)?.trim();
    return rawParentName == null ? null : ClassModel(name: rawParentName.split(' ')[1]);
  }

  List<ClassModel> _extractMixinNames(String strClass) {
    /// Generates a String formatted as : "extends ClassName "
    final mixinsPattern = RegExp(r'with [\w<>]+(, )?(\w)* ');

    final rawMixinNames = mixinsPattern.firstStringMatch(strClass);
    final mixinNames = rawMixinNames?.removeAll('with').trim().split(', ') ?? <String>[];

    return mixinNames.map((mixin) => ClassModel(name: mixin)).toList();
  }

  List<ClassModel> _extractDependencies(String strClass) {
    final classContentPattern = RegExp(r'\{((.|\n)*?)\}');

    /// Generates a String formatted as : " [late][final] ClassName fieldName;"
    final fieldPattern = RegExp(r' (late )?(final )?[\w?\[\]]+ (\w)+;');

    final classContent = classContentPattern.firstStringMatch(strClass)!;
    final rawFields = fieldPattern.allStringMatches(classContent);
    final fields = rawFields.map((field) => field
        .removeAll(';')
        .removeAll('?')
        .removeAll('final ')
        .removeAll('late ')
        .trim()
        .split(' ')
        .first);

    final uniqueFields = fields
        .where((element) => !['bool', 'int', 'String', 'DateTime', 'double'].contains(element))
        .unique();

    return uniqueFields.map((field) => ClassModel(name: field)).toList();
  }
}

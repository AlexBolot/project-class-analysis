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
      final name = _extractClassName(strClass);

      if (name == null || name.endsWith('Bean')) continue;
      final model = ClassModel(
        name: name,
        parent: _extractParentClassName(strClass),
        mixins: _extractMixinNames(strClass),
        dependencies: _extractDependencies(strClass),
      );
      classModels.add(model);
    }

    return classModels.where((model) => model?.name.isNotEmpty ?? false).whereNotNull();
  }

  String? _extractClassName(String strClass) {
    /// Generates a String formatted as : "class ClassName "
    final classNamePattern = RegExp(r'class [\w<>]* ');

    final rawClassName = classNamePattern.firstStringMatch(strClass);

    // No class found
    if (rawClassName == null) return null;

    var className = rawClassName.split(' ')[1].sanitizeClassName();

    // We don't consider private classes
    if (className.isPrivateClassName()) return null;

    return className;
  }

  ClassModel? _extractParentClassName(String strClass) {
    /// Generates a String formatted as : "extends ClassName "
    final parentNamePattern = RegExp(r'extends [\w<>]* ');
    final rawParentName = parentNamePattern.firstStringMatch(strClass);

    // No "extends" found
    if (rawParentName == null) return null;

    var className = rawParentName.split(' ')[1].sanitizeClassName();

    // We don't need that info
    if (className == 'Synchonizable') return null;
    // We don't consider private classes
    if (className.isPrivateClassName()) return null;

    return ClassModel(name: className);
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
        .where(
            (element) => !['num', 'bool', 'int', 'String', 'DateTime', 'double'].contains(element))
        .unique();

    return uniqueFields.map((field) => ClassModel(name: field)).toList();
  }
}

/*

digraph finite_state_machine {
	rankdir=BT;

	node [shape = box; style=rounded];

	Point -> GeoPoint [arrowhead=empty];
	Point -> FilesModel [arrowhead=odot];
  FileS3 -> Point [ arrowhead=ediamond];
  City -> Point [arrowhead=ediamond];
  BusStop -> Point [arrowhead=empty];
  BusStop -> AdditionalDataMixin [arrowhead=odot];
  AttachedFurniture -> BusStop [arrowhead=ediamond];
  PointLineInfo -> BusStop [arrowhead=ediamond];
}


 */

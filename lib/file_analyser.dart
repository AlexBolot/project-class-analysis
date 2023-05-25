import 'dart:io';

import 'package:project_class_analysis/extensions/list_extension.dart';
import 'package:project_class_analysis/extensions/regex_extension.dart';

import 'models/class_model.dart';

class FileAnalyser {
  final classPattern = RegExp(r'class .* \{((.|\n)*?)\}');
  final classContentPattern = RegExp(r'\{((.|\n)*?)\}');
  final classNamePattern = RegExp(r'class [\w<>]* ');
  final parentNamePattern = RegExp(r'extends [\w<>]* ');

  Future<List<ClassModel>> extractClasses(File file) async {
    if (file.path.endsWith('_jorm.dart')) return [];

    final fileContent = file.readAsStringSync();
    final classes = classPattern.allStringMatches(fileContent);

    final classModels = <ClassModel?>[];
    for (String strClass in classes) {
      final model = ClassModel();
      model.name = _extractClassName(strClass);
      model.parent = ClassModel()..name = _extractParentClassName(strClass);
      classModels.add(model);
    }

    return classModels.whereNotNull();
  }

  String? _extractClassName(String classContent) {
    /// Give a String formatted as : "class ClassName "
    final nameExtraction = classNamePattern.firstStringMatch(classContent)?.trim();
    return nameExtraction?.split(' ')[1];
  }

  String? _extractParentClassName(String classContent) {
    /// Give a String formatted as : "extends ClassName "
    final parentNameExtraction = parentNamePattern.firstStringMatch(classContent)?.trim();
    print(parentNameExtraction);
    return parentNameExtraction?.split(' ')[1];
  }
}

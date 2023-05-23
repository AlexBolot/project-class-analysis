import 'dart:io';

import 'package:project_class_analysis/list_extension.dart';

class FileAnalyser {
  Future<String?> getClassName(File file) async {
    if (file.path.endsWith('_jorm.dart')) return null;

    final lines = file.readAsLinesSync();
    final className = lines.singleWhereIfAny((line) => line!.startsWith('class'));

    return className?.split(' ')[1];
  }
}

import 'dart:io';

import 'package:project_class_analysis/extensions/list_extension.dart';
import 'package:project_class_analysis/file_analyser.dart';
import 'package:project_class_analysis/models/class_model.dart';

Future<void> main(List<String> arguments) async {
  final directoryPath = arguments.first;
  print('... Analysing $directoryPath ...');

  final directory = Directory(directoryPath);
  final List<FileSystemEntity> entities = await directory.list().toList();
  final files = entities.whereType<File>();

  final classModels = <ClassModel?>[];

  for (var file in files) {
    classModels.addAll(await FileAnalyser().extractClasses(file));
  }

  print(classModels.whereNotNull().join('\n'));
}

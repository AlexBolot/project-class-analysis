import 'dart:io';

import 'package:project_class_analysis/extensions/list_extension.dart';
import 'package:project_class_analysis/file_analyser.dart';
import 'package:project_class_analysis/models/class_model.dart';

Future<void> main(List<String> arguments) async {
  final directoryPath = arguments.first;
  print('... Analysing $directoryPath ...');

  final files = await getAllFiles(Directory(directoryPath));
  final classModels = <ClassModel?>[];

  for (var file in files) {
    classModels.addAll(await FileAnalyser().extractClasses(file));
  }

  print(classModels.whereNotNull().map((e) => e.toGraphviz().join('\n')).join('\n'));
}

Future<List<File>> getAllFiles(Directory directory) async {
  final List<FileSystemEntity> entities = await directory.list().toList();

  final files = entities.whereType<File>().toList();
  final dirs = entities.whereType<Directory>();
  for (var directory in dirs) {
    files.addAll(await getAllFiles(directory));
  }
  return files;
}

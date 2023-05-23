import 'dart:io';

import 'package:project_class_analysis/list_extension.dart';
import 'package:project_class_analysis/project_class_analysis.dart';

Future<void> main(List<String> arguments) async {
  final directoryPath = arguments.first;
  print('... Analysing $directoryPath ...');

  final directory = Directory(directoryPath);
  final List<FileSystemEntity> entities = await directory.list().toList();
  final files = entities.whereType<File>();

  final classNames = <String?>[];

  for (var file in files) {
    classNames.add(await FileAnalyser().getClassName(file));
  }

  print(classNames.whereNotNull());
}

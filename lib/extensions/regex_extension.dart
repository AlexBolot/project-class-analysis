import 'package:project_class_analysis/extensions/list_extension.dart';

extension ExtractAsString on RegExp {
  List<String> allStringMatches(String input) {
    return allMatches(input).map((match) => match[0]).whereNotNull();
  }

  String? firstStringMatch(String input) => firstMatch(input)?[0];
}

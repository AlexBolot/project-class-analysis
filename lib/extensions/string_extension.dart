extension RemoveAll on String {
  String removeAll(Pattern from) => replaceAll(from, '');

  bool isPrivateClassName() => startsWith('_');

  String removeGenericTypes() => removeAll(RegExp(r'<\w+>'));

  String removeFirstWord() => (split(' ')..removeAt(0)).join(' ');
}

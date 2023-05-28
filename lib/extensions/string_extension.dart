extension RemoveAll on String {
  String removeAll(Pattern from) => replaceAll(from, '');

  bool isPrivateClassName() => startsWith('_');

  String sanitizeClassName() => replaceAll('<', '≤').replaceAll('>', '≥');

  String removeFirstWord() => (split(' ')..removeAt(0)).join(' ');
}

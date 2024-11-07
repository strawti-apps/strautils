/// Ao invés de:
/// ```dart
/// Widget better = simple ? Center(child: [...]) : Column(children: [...]);
/// ```
/// Use:
/// ```dart
/// bool isBetter = ternaryClean(
///   simple,
///   caseTrue: Center(child: [...]),
///   caseFalse: Column(children: [...]),
///  );
/// ```
/// 
/// Se o widget [Visibility] resolver, prefira!
T ternaryClean<T>(
  bool condition, {
  required T caseTrue,
  required T caseFalse,
}) {
  return condition ? caseTrue : caseFalse;
}

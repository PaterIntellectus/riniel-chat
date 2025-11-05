import 'package:flutter/widgets.dart';
import 'package:riniel_chat/domain/character/model/character.dart';

class CharacterRepositoryProvider extends InheritedWidget {
  const CharacterRepositoryProvider({
    super.key,
    required this.repository,
    required super.child,
  });

  final CharacterRepository repository;

  static CharacterRepository? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CharacterRepositoryProvider>()
      ?.repository;

  static CharacterRepository of(BuildContext context) {
    final repo = maybeOf(context);
    assert(repo != null, "No CharacterRepository found in context");
    return repo!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

part of 'bloc.dart';

typedef CharactersTabState = ListState<Character>;

final class CharactersTabInitial extends CharactersTabState {
  const CharactersTabInitial() : super(list: const []);
}

// processing
abstract class CharactersTabProcessing extends CharactersTabState {
  const CharactersTabProcessing({required super.list});
}

final class CharactersTabRefreshing extends CharactersTabProcessing {
  const CharactersTabRefreshing({required super.list});
}

final class CharactersTabSavingCharacter extends CharactersTabProcessing {
  const CharactersTabSavingCharacter({required super.list});
}

final class CharactersTabRemovingCharacter extends CharactersTabProcessing {
  const CharactersTabRemovingCharacter({required super.list});
}

// final
final class CharactersTabSuccess extends CharactersTabState {
  const CharactersTabSuccess({required super.list});
}

final class CharactersTabFailure extends CharactersTabState {
  const CharactersTabFailure({required super.list, required this.message});

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

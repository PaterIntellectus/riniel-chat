part of 'bloc.dart';

sealed class CharactersTabEvent extends ListEvent {
  const CharactersTabEvent();
}

final class CharactersTabStarted extends CharactersTabEvent {
  const CharactersTabStarted();
}

final class CharactersTabCharacterEdited extends CharactersTabEvent {
  const CharactersTabCharacterEdited(this.character);

  final Character character;

  @override
  List<Object?> get props => [...super.props, character];
}

final class CharactersTabCharacterRemoved extends CharactersTabEvent {
  const CharactersTabCharacterRemoved(this.characterId);

  final CharacterId characterId;

  @override
  List<Object?> get props => [...super.props, characterId];
}

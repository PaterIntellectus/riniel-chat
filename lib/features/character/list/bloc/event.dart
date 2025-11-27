part of 'bloc.dart';

sealed class CharactersListEvent with EquatableMixin {
  const CharactersListEvent();

  @override
  List<Object?> get props => const [];
}

final class CharacterListStarted extends CharactersListEvent {
  const CharacterListStarted();
}

final class CharacterListCharacterEdited extends CharactersListEvent {
  const CharacterListCharacterEdited(this.character);

  final Character character;

  @override
  List<Object?> get props => [...super.props, character];
}

final class CharacterListCharacterRemoved extends CharactersListEvent {
  const CharacterListCharacterRemoved(this.characterId);

  final CharacterId characterId;

  @override
  List<Object?> get props => [...super.props, characterId];
}

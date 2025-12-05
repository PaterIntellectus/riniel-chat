part of 'bloc.dart';

sealed class EditCharacterEvent extends Equatable {
  const EditCharacterEvent();

  @override
  List<Object> get props => [];
}

final class CharacterNameChanged extends EditCharacterEvent {
  const CharacterNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [...super.props, name];
}

final class CharacterAvatarChanged extends EditCharacterEvent {
  const CharacterAvatarChanged(this.avatarPath);

  final String avatarPath;

  @override
  List<Object> get props => [...super.props, avatarPath];
}

final class CharacterNoteChanged extends EditCharacterEvent {
  const CharacterNoteChanged(this.note);

  final String note;

  @override
  List<Object> get props => [...super.props, note];
}

final class CharacterSubmitted extends EditCharacterEvent {
  const CharacterSubmitted();
}

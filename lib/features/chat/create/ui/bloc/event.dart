part of 'bloc.dart';

sealed class CreateChatEvent extends Equatable {
  const CreateChatEvent();

  @override
  List<Object?> get props => [];
}

final class CreateChatStarted extends CreateChatEvent {
  const CreateChatStarted();
}

final class CreateChatNameChanged extends CreateChatEvent {
  const CreateChatNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [...super.props, name];
}

final class CreateChatCharacterSelected extends CreateChatEvent {
  const CreateChatCharacterSelected({required this.characterId});

  final CharacterId characterId;

  @override
  List<Object?> get props => [...super.props, characterId];
}

final class CreateChatSubmitted extends CreateChatEvent {
  const CreateChatSubmitted();
}

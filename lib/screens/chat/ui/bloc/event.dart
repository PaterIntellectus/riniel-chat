part of 'bloc.dart';

sealed class ChatEvent with EquatableMixin {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

final class ChatStarted extends ChatEvent {
  const ChatStarted(this.chatId);

  final ChatId chatId;

  @override
  List<Object?> get props => [...super.props, chatId];
}

final class ChatActorSwitched extends ChatEvent {
  const ChatActorSwitched();

  @override
  List<Object?> get props => [...super.props];
}

final class ChatMessageSubmitted extends ChatEvent {
  const ChatMessageSubmitted(this.message);

  final Message message;

  @override
  List<Object?> get props => [...super.props, message];
}

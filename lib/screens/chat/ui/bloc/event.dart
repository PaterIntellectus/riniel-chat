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
}

final class ChatMessageTextChanged extends ChatEvent {
  const ChatMessageTextChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class ChatMessageAttachmentChanged extends ChatEvent {
  const ChatMessageAttachmentChanged(this.file);

  final XFile? file;

  @override
  List<Object?> get props => [...super.props, file];
}

final class ChatMessageSubmitted extends ChatEvent {
  const ChatMessageSubmitted();

  @override
  List<Object?> get props => [...super.props];
}

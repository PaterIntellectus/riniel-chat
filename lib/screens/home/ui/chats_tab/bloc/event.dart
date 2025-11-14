part of 'bloc.dart';

sealed class ChatsTabEvent extends Equatable {
  const ChatsTabEvent();

  @override
  List<Object?> get props => [];
}

final class ChatsTabStarted extends ChatsTabEvent {
  const ChatsTabStarted();
}

final class ChatsTabChatCreated extends ChatsTabEvent {
  const ChatsTabChatCreated(this.chat);

  final Chat chat;

  @override
  List<Object?> get props => [...super.props, chat];
}

final class ChatsTabChatRemoved extends ChatsTabEvent {
  const ChatsTabChatRemoved(this.chatId);

  final ChatId chatId;

  @override
  List<Object?> get props => [...super.props, chatId];
}

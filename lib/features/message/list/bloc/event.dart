part of 'bloc.dart';

sealed class MessageListEvent extends ListEvent {
  const MessageListEvent();
}

final class MessageListSubscriptionRequested extends MessageListEvent {
  const MessageListSubscriptionRequested(this.chatId);

  final ChatId chatId;
}

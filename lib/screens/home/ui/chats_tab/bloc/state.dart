part of 'bloc.dart';

class ChatLastMessageState with EquatableMixin {
  const ChatLastMessageState(this.text, this._createdAt);

  final String text;
  final DateTime _createdAt;

  String get createdAt => '${_createdAt.hour}: ${_createdAt.minute}';

  @override
  List<Object?> get props => [text, _createdAt];
}

class ChatsTabChat with EquatableMixin {
  const ChatsTabChat({
    required this.chatId,
    required this.chatAvatarUri,
    required this.chatName,
    required this.lastMessage,
  });

  final ChatId chatId;
  final ChatName chatName;
  final Uri? chatAvatarUri;
  final ChatLastMessageState? lastMessage;

  @override
  List<Object?> get props => [chatId, chatName, chatAvatarUri, lastMessage];
}

typedef ChatsTabChatList = AsyncState<List<ChatsTabChat>>;

class ChatsTabState with EquatableMixin {
  const ChatsTabState({required ChatsTabChatList chats}) : _chats = chats;

  ChatsTabState copyWith({final ChatsTabChatList? chats}) =>
      .new(chats: chats ?? _chats);

  final ChatsTabChatList _chats;

  @override
  List<Object?> get props => [_chats];

  AsyncState<UnmodifiableListView<ChatsTabChat>> get chats => _chats.castValue(
    (value) => value == null ? null : UnmodifiableListView(value),
  );
}

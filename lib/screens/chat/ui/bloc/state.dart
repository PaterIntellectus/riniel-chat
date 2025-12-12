part of 'bloc.dart';

enum ChatActor {
  user,
  character;

  ChatActor toggle() => isUser ? character : user;

  bool get isUser => this == .user;
}

class ChatMessageRecepient with EquatableMixin {
  const ChatMessageRecepient({
    required this.id,
    required this.name,
    required this.avatarUri,
  });

  final CharacterId? id;
  final String name;
  final Uri avatarUri;

  @override
  List<Object?> get props => [id, name, avatarUri];
}

class ChatMessageComposerState with EquatableMixin {
  const ChatMessageComposerState({
    required this.text,
    required this.attachment,
  });
  const ChatMessageComposerState.empty() : text = '', attachment = null;

  ChatMessageComposerState withText(String text) =>
      .new(text: text, attachment: attachment);

  ChatMessageComposerState withAttachment(Uri? attachment) =>
      .new(text: text, attachment: attachment);

  final String text;
  final Uri? attachment;

  @override
  List<Object?> get props => [text, attachment];

  bool get hasAttachment => attachment != null;
  bool get isEmpty => text.isEmpty && !hasAttachment;
  bool get isNotEmpty => !isEmpty;
}

class ChatMessageListItem with EquatableMixin {
  const ChatMessageListItem({
    required this.text,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  final String text;
  final Uri? attachment;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [text, attachment, createdAt, updatedAt];
}

extension type const ChatMessageListState(List<ChatMessageListItem> list) {}

class ChatState with EquatableMixin {
  const ChatState({
    required this.chatId,
    required this.messages,
    required this.message,
    required this.character,
    required this.actor,
  });

  const ChatState.initial(ChatId chatId)
    : this(
        chatId: chatId,
        messages: const .loading(),
        message: const .empty(),
        character: const .loading(),
        actor: .user,
      );

  ChatState copyWith({
    final AsyncState<ChatMessageListState>? messages,
    final ChatMessageComposerState? message,
    final AsyncState<Character>? character,
    final ChatActor? actor,
  }) => .new(
    chatId: chatId,
    messages: messages ?? this.messages,
    message: message ?? this.message,
    character: character ?? this.character,
    actor: actor ?? this.actor,
  );

  final ChatId chatId;
  final AsyncState<ChatMessageListState> messages;
  final ChatMessageComposerState message;
  final AsyncState<Character> character;
  final ChatActor actor;

  @override
  List<Object?> get props => [chatId, messages, message, character, actor];

  Character? get messageAuthor => actor.isUser ? null : character.value;
}

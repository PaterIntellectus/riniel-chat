import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:riniel_chat/domain/message.dart';
import 'package:riniel_chat/domain/character.dart';

typedef ChatId = String;

abstract interface class ChatRepository {
  FutureOr<List<Chat>> list();
  FutureOr<Chat> find(ChatId id);
  FutureOr<void> save(Chat chat);
  FutureOr<void> remove(MessageId id);
}

class Chat with EquatableMixin {
  const Chat({
    required this.id,
    required this.participants,
    required this.messages,
    this.themeColor = const Color(0xffffffff),
    this.backgroundImage,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Chat.private({
    required ChatId id,
    required CharacterId creatorId,
    required CharacterId invitedId,
    List<Message> messages = const [],
    Color themeColor = const Color(0xffffffff),
  }) => Chat(
    id: id,
    participants: [creatorId, invitedId],
    messages: const [],
    themeColor: themeColor,
    backgroundImage: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    deletedAt: null,
  );

  final ChatId id;
  final List<CharacterId> participants;
  final List<Message> messages;
  final Color themeColor;
  final File? backgroundImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  @override
  List<Object?> get props => [
    id,
    participants,
    messages,
    themeColor,
    backgroundImage,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

extension ChatMutations on Chat {
  Chat _copyWith({
    // final List<CharacterId>? participants,
    final List<Message>? messages,
    final Color? themeColor,
    final File? backgroundImage,
    final DateTime? deletedAt,
  }) => Chat(
    id: id,
    participants: participants,
    messages: messages ?? this.messages,
    themeColor: themeColor ?? this.themeColor,
    backgroundImage: backgroundImage ?? this.backgroundImage,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
    deletedAt: deletedAt ?? this.deletedAt,
  );

  Chat sendMessage(Message message) =>
      _copyWith(messages: [...messages, message]);

  Chat deleteMessage(Message message) {
    // final messages = [
    //   ...this.messages.map((m) => m == message ? message.delete() : m),
    // ];

    final messages = [...this.messages]
      ..removeWhere((element) => element == message);

    return _copyWith(messages: messages);
  }

  Chat updateThemeColor(Color color) => _copyWith(themeColor: color);

  Chat changeBackgroundImage(File image) => _copyWith(backgroundImage: image);

  // Chat setReceiverAvatar(File image) =>
  //     _copyWith(receiver: receiver.setAvatar(image));

  // Chat setReceiverName(String name) =>
  //     _copyWith(receiver: receiver.setName(name));

  // Chat toggleUser() => _copyWith(sender: receiver, receiver: sender);
}

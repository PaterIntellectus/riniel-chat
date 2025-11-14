import 'dart:async';
import 'dart:ui';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

class InMemoryChatRepository implements ChatRepository {
  const InMemoryChatRepository({
    required InMemoryStorage<CharacterId, Character> characterStorage,
    required InMemoryStorage<MessageId, Message> messageStorage,
    required InMemoryStorage<ChatId, ChatMemoryStorageDto> chatStorage,
  }) : _characterStorage = characterStorage,
       _messageStorage = messageStorage,
       _chatStorage = chatStorage;

  @override
  Stream<List<Chat>> watch() {
    return _chatStorage.watch().map((chats) {
      return chats.map((chat) {
        Iterable<Character> characters = [];
        _characterStorage
            .watch(filter: (value) => chat.participantIds.contains(value.id))
            .listen((event) => characters = event);

        Message? lastMessage;
        _messageStorage
            .watch(filter: (value) => value.chatId == chat.id)
            .listen((event) => lastMessage = event.lastOrNull);

        return Chat.persisted(
          id: chat.id,
          participants: characters.toList(),
          lastMessage: lastMessage,
          color: Color(chat.srgbColor),
          createdAt: chat.createdAt,
          updatedAt: chat.updatedAt,
        );
      }).toList();
    });
  }

  @override
  void save(Chat chat) => _chatStorage.save(
    ChatMemoryStorageDto(
      id: chat.id,
      participantIds: chat.participants
          .map((character) => character.id)
          .toList(),
      srgbColor: chat.color.value32bit,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
    ),
  );

  @override
  void remove(ChatId id) => _chatStorage.remove(id);

  final InMemoryStorage<CharacterId, Character> _characterStorage;
  final InMemoryStorage<MessageId, Message> _messageStorage;
  final InMemoryStorage<ChatId, ChatMemoryStorageDto> _chatStorage;
}

class ChatMemoryStorageDto {
  const ChatMemoryStorageDto({
    required this.id,
    required this.participantIds,
    required this.srgbColor,
    required this.createdAt,
    required this.updatedAt,
  });

  final ChatId id;
  final List<CharacterId> participantIds;
  final int srgbColor;
  final DateTime createdAt;
  final DateTime updatedAt;
}

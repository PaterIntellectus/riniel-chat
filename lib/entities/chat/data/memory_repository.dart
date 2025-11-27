import 'dart:async';

import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

class InMemoryChatRepository implements ChatRepository {
  const InMemoryChatRepository({
    required InMemoryStorage<ChatId, Chat> chatStorage,
  }) : _chatStorage = chatStorage;

  @override
  Stream<List<Chat>> watch() =>
      _chatStorage.watch().map((chats) => chats.toList());

  @override
  void save(Chat chat) => _chatStorage.save(chat);

  @override
  void remove(ChatId id) => _chatStorage.remove(id);

  @override
  Chat? find(final ChatId chatId) => _chatStorage.find(chatId);

  final InMemoryStorage<ChatId, Chat> _chatStorage;
}

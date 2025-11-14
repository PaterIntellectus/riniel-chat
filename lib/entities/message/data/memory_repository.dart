import 'dart:async';

import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

class MemoryMessageRepository implements MessageRepository {
  const MemoryMessageRepository(this.memoryStorage);

  @override
  Stream<List<Message>> watch({required ChatId chatId}) => memoryStorage
      .watch(filter: (message) => message.chatId == chatId)
      .map((event) => event.toList().reversed.toList());

  @override
  void save(Message message) => memoryStorage.save(message);

  @override
  void remove(MessageId id) => memoryStorage.remove(id);

  final InMemoryStorage<MessageId, Message> memoryStorage;
}

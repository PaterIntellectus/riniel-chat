import 'dart:async';

import 'package:memory_store/memory_store.dart';
import 'package:result/result.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:uuid/uuid.dart';

class InMemoryMessageRepository implements MessageRepository {
  const InMemoryMessageRepository(this._memoryStore);

  @override
  Stream<List<Message>> watch({required ChatId? chatId}) => _memoryStore
      .watch(filter: (message) => chatId == null || message.chatId == chatId)
      .map((event) => event.toList().reversed.toList());

  @override
  List<Message> list({required ChatId? chatId}) => _memoryStore.list(
    filter: (value) => chatId == null || value.chatId == chatId,
  );

  @override
  Result<void> save(Message message) => .sync(() => _memoryStore.save(message));

  @override
  Result<void> remove(MessageId id) => .sync(() => _memoryStore.remove(id));

  @override
  MessageId nextId() => .new(Uuid().v4());

  final MemoryStore<MessageId, Message> _memoryStore;
}

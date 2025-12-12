import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:memory_store/memory_store.dart';
import 'package:riniel_chat/app/ui/app.dart';
import 'package:riniel_chat/entities/character/data/memory_repository.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/data/memory_repository.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/data/memory_repository.dart';
import 'package:riniel_chat/entities/message/model/message.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  final characterMemoryStore = MemoryStore<CharacterId, Character>(
    identifier: (value) => value.id,
  );
  final characterRepository = InMemoryCharacterRepository(
    memoryStorage: characterMemoryStore,
  );

  final firstCharacter = Character(
    id: characterRepository.nextId(),
    name: 'Egirec',
    avatarUri: null,
    note: 'Nulla et aute officia exercitation sit.',
  );

  characterMemoryStore.saveMany([
    firstCharacter,
    .new(
      id: characterRepository.nextId(),
      name: 'Antonio Grazielle',
      avatarUri: null,
    ),
    .new(
      id: characterRepository.nextId(),
      name: 'Pussy Slayer',
      avatarUri: null,
      note:
          'Officia officia fugiat eiusmod voluptate velit fugiat. Culpa eiusmod eu aliqua esse id aute minim ipsum exercitation Lorem. Labore proident irure do exercitation consectetur veniam aliqua labore tempor. Qui do nisi aliquip cupidatat eu enim et excepteur commodo mollit quis laborum.',
    ),
  ]);

  final messageMemoryStore = MemoryStore<MessageId, Message>(
    identifier: (value) => value.id,
  );

  final messageRepository = InMemoryMessageRepository(messageMemoryStore);

  messageMemoryStore.saveMany([
    .new(
      id: messageRepository.nextId(),
      chatId: const .new('1'),
      authorId: firstCharacter.id,
      text: "hi",
      attachmentUri: null,
    ),
    .new(
      id: messageRepository.nextId(),
      chatId: const .new('1'),
      authorId: const .new('2'),
      text: "Hi, who are you?",
      attachmentUri: null,
    ),
  ]);

  final memoryChatStorage = MemoryStore<ChatId, Chat>(
    identifier: (value) => value.id,
  );

  runApp(
    App(
      characterRepository: characterRepository,
      messageRepository: messageRepository,
      chatRepository: InMemoryChatRepository(chatStorage: memoryChatStorage),
    ),
  );
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    debugPrint('Bloc: ${bloc.runtimeType} transition: $transition');

    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    debugPrint('Bloc: ${bloc.runtimeType} event: $event');

    super.onEvent(bloc, event);
  }
}

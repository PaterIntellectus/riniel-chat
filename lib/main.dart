import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:riniel_chat/app/ui/app.dart';
import 'package:riniel_chat/entities/character/data/memory_repository.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/data/memory_repository.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/data/memory_repository.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  final characterMemoryStore = InMemoryStorage<CharacterId, Character>(
    indexator: (value) => value.id,
  );
  final characterRepository = InMemoryCharacterRepository(
    memoryStorage: characterMemoryStore,
  );

  final firstCharacter = Character.create(
    id: characterRepository.nextId(),
    name: 'Egirec',
    avatarUri: null,
    note: 'Nulla et aute officia exercitation sit.',
  );

  characterMemoryStore.saveMany([
    firstCharacter,
    .create(
      id: characterRepository.nextId(),
      name: 'Antonio Grazielle',
      avatarUri: null,
    ),
    .create(
      id: characterRepository.nextId(),
      name: 'Pussy Slayer',
      avatarUri: null,
      note:
          'Officia officia fugiat eiusmod voluptate velit fugiat. Culpa eiusmod eu aliqua esse id aute minim ipsum exercitation Lorem. Labore proident irure do exercitation consectetur veniam aliqua labore tempor. Qui do nisi aliquip cupidatat eu enim et excepteur commodo mollit quis laborum.',
    ),
  ]);

  final messageMemoryStore = InMemoryStorage<MessageId, Message>(
    indexator: (value) => value.id,
  );

  messageMemoryStore.saveMany([
    .create(
      chatId: .new('1'),
      authorId: firstCharacter.id,
      text: "hi",
      attachmentUri: null,
    ),
    .create(
      chatId: .new('1'),
      authorId: .new('2'),
      text: "Hi, who are you?",
      attachmentUri: null,
    ),
  ]);

  final memoryChatStorage = InMemoryStorage<ChatId, Chat>(
    indexator: (value) => value.id,
  );

  runApp(
    App(
      characterRepository: characterRepository,
      messageRepository: InMemoryMessageRepository(messageMemoryStore),
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

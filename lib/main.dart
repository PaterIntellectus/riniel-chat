import 'package:flutter/material.dart';
import 'package:riniel_chat/domain/character/data/repository.dart';
import 'package:riniel_chat/domain/character/model/character.dart';
import 'package:riniel_chat/presentation/app.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

void main() {
  final characterMemoryStore = InMemoryStorage<CharacterId, Character>({
    '1': Character(
      id: '1',
      name: 'Egirec',
      avatar: null,
      note: 'Он ваняит',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    '2': Character(
      id: '2',
      name: 'Antonio Grazielle',
      avatar: null,
      note: 'Этот перс ваще курутоооой',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  });

  runApp(
    App(
      characterRepository: CharacterRepositoryImpl(
        memorySource: characterMemoryStore,
      ),
    ),
  );
}

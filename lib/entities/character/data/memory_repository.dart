import 'dart:async';

import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

class InMemoryCharacterRepository implements CharacterRepository {
  const InMemoryCharacterRepository({
    required InMemoryStorage<CharacterId, Character> memoryStorage,
  }) : _memoryStorage = memoryStorage;

  @override
  Stream<List<Character>> watch() =>
      _memoryStorage.watch().map((data) => data.toList());

  @override
  List<Character> list() => _memoryStorage.list();

  @override
  Character? find(CharacterId id) => _memoryStorage.find(id);

  @override
  void save(Character character) => _memoryStorage.save(character);

  @override
  void remove(CharacterId id) => _memoryStorage.remove(id);

  final InMemoryStorage<CharacterId, Character> _memoryStorage;
}

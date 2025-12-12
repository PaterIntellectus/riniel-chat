import 'dart:async';

import 'package:memory_store/memory_store.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:uuid/uuid.dart';

class InMemoryCharacterRepository implements CharacterRepository {
  const InMemoryCharacterRepository({
    required MemoryStore<CharacterId, Character> memoryStorage,
  }) : _memoryStorage = memoryStorage;

  @override
  Stream<List<Character>> watch() =>
      _memoryStorage.watch().map((data) => data.toList());

  @override
  List<Character> list() => _memoryStorage.list();

  @override
  Character? find(CharacterId id) => _memoryStorage.find(id).value;

  @override
  void save(Character character) => _memoryStorage.save(character);

  @override
  void remove(CharacterId id) => _memoryStorage.remove(id);

  @override
  CharacterId nextId() {
    return CharacterId(Uuid().v4());
  }

  final MemoryStore<CharacterId, Character> _memoryStorage;
}

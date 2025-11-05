import 'dart:async';

import 'package:riniel_chat/domain/character/model/character.dart';
import 'package:riniel_chat/shared/data/memory/storage.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({required this.memorySource});

  final InMemoryStorage<CharacterId, Character> memorySource;

  @override
  Stream<List<Character>> watch() =>
      memorySource.watch().map((data) => data.toList());

  @override
  FutureOr<List<Character>> list() {
    return memorySource.list();
  }

  @override
  FutureOr<Character?> find(CharacterId id) {
    return memorySource.find(id);
  }

  @override
  void save(Character character) {
    return memorySource.save(character.id, character);
  }

  @override
  void remove(CharacterId id) {
    return memorySource.remove(id);
  }
}

import 'dart:async';

import 'package:equatable/equatable.dart';

abstract interface class CharacterRepository {
  Stream<List<Character>> watch();
  FutureOr<List<Character>> list();
  FutureOr<Character?> find(CharacterId id);
  FutureOr<void> save(Character character);
  FutureOr<void> remove(CharacterId id);
  FutureOr<CharacterId> nextId();
}

extension type CharacterId(String value) {}

class Character with EquatableMixin {
  Character._valid({
    required this.id,
    required this.name,
    required this.note,
    required this.avatarUri,
    required this.createdAt,
    required this.updatedAt,
  }) {
    if (name.isEmpty) {
      throw "Не указано имя персонажа";
    }
  }

  factory Character.create({
    required CharacterId id,
    required final String name,
    final Uri? avatarUri,
    final String note = '',
  }) => ._valid(
    id: id,
    name: name,
    note: note,
    avatarUri: avatarUri,
    createdAt: .now(),
    updatedAt: .now(),
  );

  final CharacterId id;
  final String name;
  final String note;
  final Uri? avatarUri;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, name, note, avatarUri, createdAt, updatedAt];
}

extension CharacterMutator on Character {
  Character update({
    final String? name,
    final Uri? avatarUri,
    final String? note,
  }) => ._valid(
    id: id,
    name: name ?? this.name,
    avatarUri: avatarUri ?? this.avatarUri,
    note: note ?? this.note,
    createdAt: createdAt,
    updatedAt: .now(),
  );

  Character setName(String name) => update(name: name);

  Character setAvatar(Uri avatarUri) => update(avatarUri: avatarUri);

  Character setNote(String note) => update(note: note);
}

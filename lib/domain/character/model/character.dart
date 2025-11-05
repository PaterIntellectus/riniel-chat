import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract interface class CharacterRepository {
  Stream<List<Character>> watch();
  FutureOr<List<Character>> list();
  FutureOr<Character?> find(CharacterId id);
  FutureOr<void> save(Character character);
  FutureOr<void> remove(CharacterId id);
}

typedef CharacterId = String;

class Character with EquatableMixin {
  Character({
    required this.id,
    required this.name,
    required this.note,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
  }) {
    if (name.isEmpty) {
      throw "Имя пользователя не может быть пустым";
    }
  }

  factory Character.create({
    required final String name,
    final File? avatar,
    String note = '',
  }) => Character(
    id: Uuid().v4(),
    name: name,
    note: note,
    avatar: avatar,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final CharacterId id;
  final String name;
  final String note;
  final File? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, name, note, avatar, createdAt, updatedAt];
}

extension ParticipantMutations on Character {
  Character _update({
    final String? name,
    final File? avatar,
    final String? note,
  }) {
    return Character(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Character setName(String name) => _update(name: name);

  Character setAvatar(File image) => _update(avatar: image);
}

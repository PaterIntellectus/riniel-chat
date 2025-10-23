import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract interface class CharacterRepository {
  FutureOr<List<Character>> list();
  FutureOr<Character> find(CharacterId id);
  FutureOr<void> save(Character character);
  Future<void> remove(CharacterId id);
}

typedef CharacterId = String;

class Character with EquatableMixin {
  Character({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  }) {
    if (name.isEmpty) {
      throw "Имя пользователя не может быть пустым";
    }
  }

  factory Character.create({required final String name, final File? avatar}) =>
      Character(
        id: Uuid().v4(),
        name: name,
        avatar: avatar,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      );

  final CharacterId id;
  final String name;
  final File? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    avatar,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

extension ParticipantMutations on Character {
  Character _update({final String? name, final File? avatar}) {
    return Character(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      deletedAt: deletedAt,
    );
  }

  Character setName(String name) => _update(name: name);

  Character setAvatar(File image) => _update(avatar: image);
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:uuid/uuid.dart';

extension type ChatId(String value) {}

class ChatName with EquatableMixin {
  ChatName(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw 'Название не может быть пустым';
    }
  }

  final String value;

  @override
  List<Object?> get props => [value];
}

class Chat with EquatableMixin {
  const Chat.persisted({
    required this.id,
    required this.characterId,
    required this.name,
    required this.color,
    this.backgroundImageUri,
    required this.createdAt,
    required this.updatedAt,
  });

  const Chat._valid({
    required this.id,
    required this.characterId,
    required this.name,
    required this.color,
    this.backgroundImageUri,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.create({
    required final CharacterId characterId,
    required final ChatName name,
    final Color color = const .new(0xFFFFFFFF),
    final Uri? backgroundImageUri,
  }) => ._valid(
    id: .new(Uuid().v4()),
    characterId: characterId,
    name: name,
    color: color,
    backgroundImageUri: backgroundImageUri,
    createdAt: .now(),
    updatedAt: .now(),
  );

  final ChatId id;
  final CharacterId characterId;
  final ChatName name;
  final Color color;
  final Uri? backgroundImageUri;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    characterId,
    name,
    color,
    backgroundImageUri,
    createdAt,
    updatedAt,
  ];
}

abstract interface class ChatRepository {
  Stream<List<Chat>> watch();
  FutureOr<Chat?> find(ChatId id);
  FutureOr<void> save(Chat chat);
  FutureOr<void> remove(ChatId id);
}

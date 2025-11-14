import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/message/model/message.dart';

extension type ChatId(String value) {}

class Chat with EquatableMixin {
  const Chat.persisted({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.color,
    this.backgroundImageUri,
    required this.createdAt,
    required this.updatedAt,
  });

  const Chat._valid({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.color,
    this.backgroundImageUri,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.create({
    required final ChatId id,
    required final List<Character> participants,
    final Message? lastMessage,
    final Color color = const .new(0xFFFFFFFF),
    final Uri? backgroundImageUri,
  }) => ._valid(
    id: id,
    participants: participants,
    lastMessage: lastMessage,
    color: color,
    backgroundImageUri: backgroundImageUri,
    createdAt: .now(),
    updatedAt: .now(),
  );

  final ChatId id;
  final List<Character> participants;
  final Message? lastMessage;
  final Color color;
  final Uri? backgroundImageUri;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    participants,
    lastMessage,
    createdAt,
    updatedAt,
  ];
}

abstract interface class ChatRepository {
  Stream<List<Chat>> watch();
  // FutureOr<Chat> find(ChatId id);
  FutureOr<void> save(Chat chat);
  FutureOr<void> remove(ChatId id);
}

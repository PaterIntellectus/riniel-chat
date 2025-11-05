import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:riniel_chat/domain/character/model/character.dart';
import 'package:riniel_chat/domain/chat/model/chat.dart';
import 'package:uuid/uuid.dart';

class MessageAuthorNotProvided implements Exception {
  const MessageAuthorNotProvided();

  @override
  String toString() => 'Необходимо указать автора сообщения';
}

class EmptyMessageContentException implements Exception {
  const EmptyMessageContentException();

  @override
  String toString() => "Сообщение не может быть пустым!";
}

typedef MessageId = String;

class Message with EquatableMixin {
  const Message.persisted({
    required this.id,
    required this.chatId,
    required this.authorId,
    required this.text,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Message._({
    required this.id,
    required this.chatId,
    required this.authorId,
    required this.text,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  }) {
    if (authorId.isEmpty) {
      throw MessageAuthorNotProvided();
    }

    if (text.isEmpty && attachment == null) {
      throw EmptyMessageContentException;
    }
  }

  Message({
    required ChatId chatId,
    required CharacterId authorId,
    required String text,
    required File? attachment,
  }) : this._(
         id: Uuid().v4(),
         chatId: chatId,
         authorId: authorId,
         text: text,
         attachment: attachment,
         createdAt: DateTime.now(),
         updatedAt: DateTime.now(),
         deletedAt: null,
       );

  final MessageId id;
  final ChatId chatId;
  final CharacterId authorId;
  final String text;
  final File? attachment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool isAuthor(CharacterId characterId) => characterId == authorId;

  @override
  List<Object?> get props => [
    id,
    chatId,
    authorId,
    text,
    attachment,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

extension MessageEditable on Message {
  Message _copyWith({
    final String? text,
    final File? attachment,
    final DateTime? Function(DateTime? deletedAt)? deletedAt,
  }) => Message._(
    id: id,
    chatId: chatId,
    authorId: authorId,
    text: text ?? this.text,
    attachment: attachment ?? this.attachment,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
    deletedAt: deletedAt == null ? this.deletedAt : deletedAt(this.deletedAt),
  );

  Message edit(String text) {
    return _copyWith(text: text);
  }

  Message delete() {
    return _copyWith(
      deletedAt: (deletedAt) {
        if (deletedAt != null) {
          return deletedAt;
        }

        return DateTime.now();
      },
    );
  }
}

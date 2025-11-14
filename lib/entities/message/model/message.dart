import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
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

class MessageAlreadyDeletedException implements Exception {
  const MessageAlreadyDeletedException();

  @override
  String toString() => "Сообщение уже удалено!";
}

abstract interface class MessageRepository {
  Stream<List<Message>> watch({required ChatId chatId});
  FutureOr<void> save(Message message);
  FutureOr<void> remove(MessageId id);
}

extension type MessageId(String value) {}

class Message with EquatableMixin {
  const Message.persisted({
    required this.id,
    required this.chatId,
    required this.authorId,
    required this.text,
    required this.attachmentUri,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Message._valid({
    required this.id,
    required this.chatId,
    required this.authorId,
    required this.text,
    required this.attachmentUri,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  }) {
    if (authorId.value.isEmpty) {
      throw MessageAuthorNotProvided();
    }

    if (text.isEmpty && attachmentUri == null) {
      throw EmptyMessageContentException();
    }
  }

  Message.create({
    required ChatId chatId,
    required CharacterId authorId,
    required String text,
    required Uri? attachmentUri,
  }) : this._valid(
         id: .new(Uuid().v4()),
         chatId: chatId,
         authorId: authorId,
         text: text,
         attachmentUri: attachmentUri,
         createdAt: .now(),
         updatedAt: .now(),
         deletedAt: null,
       );

  final MessageId id;
  final ChatId chatId;
  final CharacterId authorId;
  final String text;
  final Uri? attachmentUri;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  @override
  List<Object?> get props => [
    id,
    chatId,
    authorId,
    text,
    attachmentUri,
    createdAt,
    updatedAt,
    deletedAt,
  ];

  bool isAuthor(CharacterId characterId) => characterId == authorId;

  bool get isEdited => updatedAt != createdAt;
  bool get isDeleted => deletedAt != null;
}

extension MessageEditable on Message {
  Message _update({
    final String? text,
    final DateTime Function(DateTime? deletedAt)? deletedAt,
  }) => ._valid(
    id: id,
    chatId: chatId,
    authorId: authorId,
    text: text ?? this.text,
    attachmentUri: attachmentUri,
    createdAt: createdAt,
    updatedAt: .now(),
    deletedAt: deletedAt == null ? this.deletedAt : deletedAt(this.deletedAt),
  );

  Message edit(String text) {
    return _update(text: text);
  }

  Message delete() {
    return _update(
      deletedAt: (deletedAt) {
        if (deletedAt != null) {
          throw MessageAlreadyDeletedException();
        }

        return .now();
      },
    );
  }
}

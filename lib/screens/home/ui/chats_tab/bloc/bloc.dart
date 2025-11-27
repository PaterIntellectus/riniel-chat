import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/state/async.dart';

part 'event.dart';
part 'state.dart';

class ChatsTabBloc extends Bloc<ChatsTabEvent, ChatsTabState> {
  ChatsTabBloc(
    ChatRepository chatRepository,
    CharacterRepository characterRepository,
    MessageRepository messageRepository,
  ) : _chatRepository = chatRepository,
      _characterRepository = characterRepository,
      _messageRepository = messageRepository,
      super(const .new(chats: .loading(value: []))) {
    on<ChatsTabStarted>(_start, transformer: restartable());
  }

  void _start(ChatsTabStarted event, Emitter<ChatsTabState> emit) async {
    emit(state.copyWith(chats: .loading(value: state.chats.value)));

    await for (final chats in _chatRepository.watch()) {
      List<ChatsTabChat> uiChats = .empty(growable: true);

      for (final chat in chats) {
        try {
          final character = await _characterRepository.find(chat.characterId);

          if (character == null) {
            throw 'Перcонаж не найден';
          }

          final lastMessage = (await _messageRepository.list(
            chatId: chat.id,
          )).lastOrNull;

          uiChats.add(
            .new(
              chatId: chat.id,
              chatAvatarUri: character.avatarUri,
              chatName: chat.name,
              lastMessage: lastMessage != null
                  ? .new(lastMessage.text, lastMessage.createdAt)
                  : null,
            ),
          );

          emit(state.copyWith(chats: .data(uiChats)));
        } catch (e, s) {
          emit(
            state.copyWith(
              chats: .error(value: state.chats.value, error: e, stackTrace: s),
            ),
          );
        }
      }
    }
  }

  final MessageRepository _messageRepository;
  final CharacterRepository _characterRepository;
  final ChatRepository _chatRepository;
}

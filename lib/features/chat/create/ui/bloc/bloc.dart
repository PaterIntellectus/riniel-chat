import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/shared/state/async.dart';

part 'event.dart';
part 'state.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  CreateChatBloc({
    required ChatRepository chatRepository,
    required CharacterRepository characterRepository,
  }) : _characterRepository = characterRepository,
       _chatRepository = chatRepository,
       super(
         const .new(
           status: .idle,
           characters: .loading(),
           chatName: .initial(),
           selectedCharacter: null,
           message: '',
         ),
       ) {
    on<CreateChatStarted>(_start, transformer: restartable());
    on<CreateChatNameChanged>(_setName, transformer: restartable());
    on<CreateChatCharacterSelected>(
      _selectCharacter,
      transformer: restartable(),
    );
    on<CreateChatSubmitted>(_createChat, transformer: droppable());
  }

  void _start(CreateChatStarted event, Emitter<CreateChatState> emit) async {
    emit(state.copyWith(characters: .loading(value: state.characters.value)));

    emit(
      state.copyWith(
        characters: await .guard(
          () async => (await _characterRepository.list()),
        ),
      ),
    );
  }

  void _setName(CreateChatNameChanged event, Emitter<CreateChatState> emit) {
    if (event.name == state.chatName.value) {
      return;
    }

    emit(state.copyWith(chatName: .new(event.name, isDefault: false)));
  }

  void _selectCharacter(
    CreateChatCharacterSelected event,
    Emitter<CreateChatState> emit,
  ) {
    if (event.characterId == state.selectedCharacter?.id) {
      return;
    }

    try {
      final character = state._characters.value?.singleWhere(
        (character) => character.id == event.characterId,
      );

      final useCharacterNameAsChatName =
          state.chatName.value.isEmpty || state.chatName.isDefault;

      emit(
        state.copyWith(
          chatName: useCharacterNameAsChatName
              ? .new(character?.name ?? '', isDefault: true)
              : state.chatName,
          selectedCharacter: character,
        ),
      );
    } catch (error) {
      emit(state.copyWith(message: error.toString()));
    }
  }

  void _createChat(
    CreateChatSubmitted event,
    Emitter<CreateChatState> emit,
  ) async {
    try {
      if (!state.isCharacterSelected) {
        throw 'Необходимо выбрать перcонажа';
      }

      if (state.chatName.value.isEmpty) {
        throw 'Необходимо указать название чата';
      }

      await _chatRepository.save(
        .create(
          characterId: state.selectedCharacter!.id,
          name: .new(state.chatName.value),
        ),
      );

      emit(state.copyWith(status: .success));
    } catch (error) {
      emit(state.copyWith(status: .failure, message: error.toString()));
    }
  }

  final ChatRepository _chatRepository;
  final CharacterRepository _characterRepository;
}

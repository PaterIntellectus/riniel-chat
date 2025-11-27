import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/shared/state/async.dart';

part 'event.dart';
part 'state.dart';

class CharacterListBloc extends Bloc<CharactersListEvent, CharactersListState> {
  CharacterListBloc(this._repository)
    : super(const .new(status: .initial, characters: .loading(), message: '')) {
    on<CharacterListStarted>(_start, transformer: restartable());
    on<CharacterListCharacterRemoved>(
      _removeCharacter,
      transformer: droppable(),
    );
    on<CharacterListCharacterEdited>(_saveCharacter, transformer: droppable());
  }

  void _start(
    CharacterListStarted event,
    Emitter<CharactersListState> emit,
  ) async {
    emit(state.copyWith(characters: .loading(value: state.characters.value)));

    await emit.forEach(
      _repository.watch(),
      onData: (data) => state.copyWith(characters: .data(data)),
      onError: (error, stackTrace) => state.copyWith(
        characters: .error(
          value: state.characters.value,
          error: error,
          stackTrace: stackTrace,
        ),
      ),
    );
  }

  void _removeCharacter(
    CharacterListCharacterRemoved event,
    Emitter<CharactersListState> emit,
  ) async {
    emit(state.copyWith(status: .processing));

    try {
      await _repository.remove(event.characterId);
      emit(state.copyWith(status: .initial));
    } catch (error) {
      emit(state.copyWith(status: .failure, message: error.toString()));
    }
  }

  void _saveCharacter(
    CharacterListCharacterEdited event,
    Emitter<CharactersListState> emit,
  ) async {
    emit(state.copyWith(status: .processing));

    try {
      await _repository.save(event.character);
      emit(state.copyWith(status: .initial));
    } catch (error) {
      emit(state.copyWith(status: .failure, message: error.toString()));
    }
  }

  final CharacterRepository _repository;
}

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/shared/model/bloc/list.dart';
import 'package:riniel_chat/shared/model/bloc/ui_event_mixin.dart';

part 'event.dart';
part 'state.dart';

class CharactersTabBloc
    extends ListBloc<CharactersTabEvent, CharactersTabState, UiEvent>
    with BlocUiEventMixin<CharactersTabState, UiEvent> {
  CharactersTabBloc(this._repository) : super(CharactersTabInitial()) {
    on<CharactersTabStarted>(_start, transformer: restartable());
    on<CharactersTabCharacterRemoved>(
      _removeCharacter,
      transformer: droppable(),
    );
    on<CharactersTabCharacterEdited>(_editCharacter, transformer: droppable());
  }

  void _start(
    CharactersTabStarted event,
    Emitter<CharactersTabState> emit,
  ) async {
    emit(CharactersTabRefreshing(list: state.list));

    await emit.forEach(
      _repository.watch(),
      onData: (data) => CharactersTabSuccess(list: data),
      onError: (error, stackTrace) =>
          CharactersTabFailure(list: state.list, message: error.toString()),
    );
  }

  void _removeCharacter(
    CharactersTabCharacterRemoved event,
    Emitter<CharactersTabState> emit,
  ) async {
    emit(CharactersTabRemovingCharacter(list: state.list));

    try {
      await _repository.remove(event.characterId);
      emit(CharactersTabSuccess(list: state.list));
    } catch (error) {
      emit(CharactersTabFailure(list: state.list, message: error.toString()));
    }
  }

  void _editCharacter(
    CharactersTabCharacterEdited event,
    Emitter<CharactersTabState> emit,
  ) async {
    emit(CharactersTabRemovingCharacter(list: state.list));

    try {
      await _repository.save(event.character);
      emit(CharactersTabSuccess(list: state.list));
    } catch (error) {
      emit(CharactersTabFailure(list: state.list, message: error.toString()));
    }
  }

  final CharacterRepository _repository;
}

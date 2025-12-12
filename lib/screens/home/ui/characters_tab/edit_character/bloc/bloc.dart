import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';

part 'event.dart';
part 'state.dart';

class EditCharacterBloc extends Bloc<EditCharacterEvent, EditCharacterState> {
  EditCharacterBloc(
    CharacterRepository characterRepository, {
    Character? initialCharacter,
  }) : _characterRepository = characterRepository,
       super(
         .initial(
           initialCharacter: initialCharacter,
           name: .pure(value: initialCharacter?.name ?? ''),
           note: initialCharacter?.note ?? '',
           avatarPath: initialCharacter?.avatarUri?.path ?? '',
         ),
       ) {
    on<CharacterNameChanged>(_setName, transformer: restartable());
    on<CharacterAvatarChanged>(_setAvatar, transformer: restartable());
    on<CharacterNoteChanged>(_setNote, transformer: restartable());
    on<CharacterSubmitted>(_saveCharacter, transformer: droppable());
  }

  void _setName(CharacterNameChanged event, Emitter<EditCharacterState> emit) {
    emit(state.copyWith(name: .edited(event.name)));
  }

  void _setAvatar(
    CharacterAvatarChanged event,
    Emitter<EditCharacterState> emit,
  ) {
    emit(state.copyWith(avatarPath: event.avatarPath));
  }

  void _setNote(CharacterNoteChanged event, Emitter<EditCharacterState> emit) {
    emit(state.copyWith(note: event.note));
  }

  Future<void> _saveCharacter(
    CharacterSubmitted event,
    Emitter<EditCharacterState> emit,
  ) async {
    emit(state.copyWith(status: .inProgress));

    try {
      final characterId = await _characterRepository.nextId();

      final character =
          state.initialCharacter ??
          .new(
            id: characterId,
            name: state.name.value,
            avatarUri: Uri.parse(state.avatarPath),
            note: state.note,
          );

      await _characterRepository.save(character);

      emit(state.copyWith(status: .success));
    } catch (error) {
      emit(state.copyWith(status: .failure));
    } finally {
      emit(state.copyWith(status: .idle));
    }
  }

  final CharacterRepository _characterRepository;
}

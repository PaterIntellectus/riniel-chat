import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';

part 'event.dart';
part 'state.dart';

class MessageComposerBloc
    extends Bloc<MessageComposerEvent, MessageComposerState> {
  MessageComposerBloc() : super(const .initial()) {
    on<MessageComposerTextChanged>(_saveText, transformer: restartable());
    on<MessageComposerAttachmentChanged>(
      _saveAttachment,
      transformer: restartable(),
    );
    on<MessageComposerCleared>(_clear, transformer: droppable());
  }

  void _saveText(
    MessageComposerTextChanged event,
    Emitter<MessageComposerState> emit,
  ) {
    final text = event.text.trim();

    if (state.text == text) {
      return;
    }

    emit(state.copyWith(text: text));
  }

  void _saveAttachment(
    MessageComposerAttachmentChanged event,
    Emitter<MessageComposerState> emit,
  ) {
    final attachment = event.attachment != null
        ? Uri.parse(event.attachment!.path)
        : null;

    if (state.attachment == attachment) {
      return;
    }

    emit(state.copyWith(attachment: () => attachment));
  }

  void _clear(
    MessageComposerCleared event,
    Emitter<MessageComposerState> emit,
  ) async {
    emit(.initial());
  }
}

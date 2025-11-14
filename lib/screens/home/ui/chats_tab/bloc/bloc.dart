import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/shared/model/bloc/list.dart';

part 'event.dart';
part 'state.dart';

class ChatsTabBloc extends Bloc<ChatsTabEvent, ChatsTabState> {
  ChatsTabBloc(this._chatRepository) : super(ChatsTabInitial()) {
    on<ChatsTabStarted>(_start, transformer: droppable());
    on<ChatsTabChatCreated>(_createChat, transformer: droppable());
  }

  void _start(ChatsTabStarted event, Emitter<ChatsTabState> emit) async {
    emit(ChatsTabProcessing(list: state.list));

    await emit.forEach(
      _chatRepository.watch(),
      onData: (data) {
        return ChatsTabSuccess(list: data);
      },
      onError: (error, stackTrace) {
        return ChatsTabFailure(list: state.list, message: error.toString());
      },
    );
  }

  void _createChat(
    ChatsTabChatCreated event,
    Emitter<ChatsTabState> emit,
  ) async {
    emit(ChatsTabProcessing(list: state.list));

    try {
      await _chatRepository.save(event.chat);
    } catch (error) {
      emit(ChatsTabFailure(list: state.list, message: error.toString()));
    }
  }

  final ChatRepository _chatRepository;
}

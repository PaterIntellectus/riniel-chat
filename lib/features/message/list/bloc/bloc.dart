import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/model/bloc/list.dart';
import 'package:riniel_chat/shared/model/bloc/ui_event_mixin.dart';

part 'event.dart';
part 'state.dart';

class MessageListBloc
    extends ListBloc<MessageListEvent, MessageListState, UiEvent>
    with BlocUiEventMixin<MessageListState, UiEvent> {
  MessageListBloc(this.messageRepository) : super(MessageListInitial()) {
    // on<MessageListSubscriptionRequested>(_subscribe);
  }

  // void _subscribe(
  //   MessageListSubscriptionRequested event,
  //   Emitter<MessageListState> emit,
  // ) async {
  //   emit(state.asLoading());

  //   await emit.forEach(
  //     messageRepository.watch(chatId: event.chatId),
  //     onData: (data) => state.asSuccess(data),
  //     onError: (error, stackTrace) =>
  //         state.asFailure(message: error.toString()),
  //   );
  // }

  // void _sendMessage(
  //   MessageListMessageSent event,
  //   Emitter<MessageListState> emit,
  // ) async {
  //   try {
  //     await messageRepository.save(event.message);
  //   } catch (error) {
  //     state.asFailure(message: error.toString());
  //   }
  // }

  final MessageRepository messageRepository;
}

// import 'dart:collection';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:riniel_chat/entities/chat/model/chat.dart';
// import 'package:riniel_chat/entities/message/model/message.dart';

// part 'event.dart';
// part 'state.dart';

// class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
//   MessageListBloc(this.messageRepository) : super(MessageListInitial()) {
//     on<MessageListSubscriptionRequested>(_subscribe);
//   }

//   void _subscribe(
//     MessageListSubscriptionRequested event,
//     Emitter<MessageListState> emit,
//   ) async {
//     emit(const .new(messages: []));

//     await emit.forEach(
//       messageRepository.watch(chatId: event.chatId),
//       onData: (data) => .new(messages: data),
//       onError: (error, stackTrace) => MessageListFailure(
//         message: error.toString(),
//         messages: state._messages,
//       ),
//     );
//   }

//   // void _sendMessage(
//   //   MessageListMessageSent event,
//   //   Emitter<MessageListState> emit,
//   // ) async {
//   //   try {
//   //     await messageRepository.save(event.message);
//   //   } catch (error) {
//   //     state.asFailure(message: error.toString());
//   //   }
//   // }

//   final MessageRepository messageRepository;
// }

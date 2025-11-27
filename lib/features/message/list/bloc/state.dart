// part of 'bloc.dart';

// class MessageListState with EquatableMixin {
//   const MessageListState({required List<Message> messages})
//     : _messages = messages;

//   final List<Message> _messages;

//   @override
//   List<Object?> get props => [_messages];

//   UnmodifiableListView<Message> get messages => .new(_messages);
// }

// final class MessageListInitial extends MessageListState {
//   const MessageListInitial() : super(messages: const []);
// }

// final class MessageListProcessing extends MessageListState {
//   const MessageListProcessing({required super.messages});
// }

// final class MessageListSuccess extends MessageListState {
//   const MessageListSuccess({required super.messages});
// }

// final class MessageListFailure extends MessageListState {
//   const MessageListFailure({required super.messages, required this.message});

//   final String message;

//   @override
//   List<Object?> get props => [...super.props, messages, message];
// }

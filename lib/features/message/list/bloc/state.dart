part of 'bloc.dart';

typedef MessageListState = ListState<Message>;

final class MessageListInitial extends MessageListState {
  const MessageListInitial() : super(list: const []);
}

final class MessageListProcessing extends MessageListState {
  const MessageListProcessing({required super.list});
}

final class MessageListSuccess extends MessageListState {
  const MessageListSuccess({required super.list});
}

final class MessageListFailure extends MessageListState {
  const MessageListFailure({required super.list, required this.message});

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

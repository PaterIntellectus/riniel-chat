part of 'bloc.dart';

typedef ChatsTabState = ListState<Chat>;

final class ChatsTabInitial extends ChatsTabState {
  const ChatsTabInitial({super.list = const []});
}

final class ChatsTabProcessing extends ChatsTabState {
  const ChatsTabProcessing({required super.list});
}

final class ChatsTabSuccess extends ChatsTabState {
  const ChatsTabSuccess({required super.list});
}

final class ChatsTabFailure extends ChatsTabState {
  const ChatsTabFailure({required super.list, required this.message});

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

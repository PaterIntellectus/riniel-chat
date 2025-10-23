part of 'chat_bloc.dart';

sealed class ChatScreenState extends Equatable {
  const ChatScreenState({required this.message, required this.chat});

  final String message;
  final Chat chat;

  @override
  List<Object> get props => [];
}

final class ChatScreenIdle extends ChatScreenState {
  const ChatScreenIdle({super.message = '', required super.chat});
}

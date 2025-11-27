import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/state/async.dart';

part 'event.dart';
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.chatRepository,
    required this.characterRepository,
    required this.messageRepository,
  }) : super(const .initial()) {
    on<ChatStarted>(_start, transformer: restartable());
    on<ChatMessageSubmitted>(_sendMessage, transformer: droppable());
    on<ChatActorSwitched>(_switchActor, transformer: sequential());
  }

  void _start(ChatStarted event, Emitter<ChatState> emit) async {
    try {
      final chat = await chatRepository.find(event.chatId);

      if (chat == null) {
        throw 'Чат не найден';
      }

      final character = await characterRepository.find(chat.characterId);

      if (character == null) {
        throw 'Персонаж не найден';
      }

      emit(state.copyWith(character: .data(character), actor: .user));
    } catch (error) {
      emit(state.copyWith(status: .failure));
    }
  }

  void _sendMessage(ChatMessageSubmitted event, Emitter<ChatState> emit) async {
    try {
      await messageRepository.save(event.message);
    } finally {
      emit(state.copyWith(status: .idle));
    }
  }

  void _switchActor(ChatActorSwitched event, Emitter<ChatState> emit) {
    emit(state.copyWith(actor: state.actor.toggle()));
  }

  final ChatRepository chatRepository;
  final CharacterRepository characterRepository;
  final MessageRepository messageRepository;
}

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/state/async.dart';

part 'event.dart';
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required ChatRepository chatRepository,
    required CharacterRepository characterRepository,
    required MessageRepository messageRepository,
    required ChatId chatId,
  }) : _chatRepository = chatRepository,
       _messageRepository = messageRepository,
       _characterRepository = characterRepository,
       super(.initial(chatId)) {
    on<ChatStarted>(_start, transformer: restartable());
    on<ChatMessageSubmitted>(_sendMessage, transformer: droppable());
    on<ChatActorSwitched>(_switchActor, transformer: sequential());
    on<ChatMessageTextChanged>(_setMessageText, transformer: restartable());
    on<ChatMessageAttachmentChanged>(
      _setMessageAttachment,
      transformer: restartable(),
    );
  }

  void _start(ChatStarted event, Emitter<ChatState> emit) async {
    final chat = await _chatRepository.find(state.chatId);
    if (chat == null) {
      return;
    }

    final character = await _characterRepository.find(chat.characterId);
    if (character == null) {
      return;
    }

    emit(state.copyWith(character: .data(character)));

    emit.forEach(
      _messageRepository.watch(chatId: state.chatId),
      onData: (messages) {
        return state.copyWith(
          messages: .data(
            .new([
              ...messages.map(
                (message) => .new(
                  text: message.text,
                  attachment: message.attachmentUri,
                  createdAt: message.createdAt,
                  updatedAt: message.updatedAt,
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  void _switchActor(ChatActorSwitched event, Emitter<ChatState> emit) {
    emit(state.copyWith(actor: state.actor.toggle()));
  }

  void _setMessageText(ChatMessageTextChanged event, Emitter<ChatState> emit) {
    if (state.message.text == event.text) {
      return;
    }

    emit(state.copyWith(message: state.message.withText(event.text)));
  }

  void _setMessageAttachment(
    ChatMessageAttachmentChanged event,
    Emitter<ChatState> emit,
  ) {
    final attachment = event.file != null
        ? Uri.tryParse(event.file!.path)
        : null;

    if (state.message.attachment == attachment) {
      return;
    }

    emit(state.copyWith(message: state.message.withAttachment(attachment)));
  }

  void _sendMessage(ChatMessageSubmitted event, Emitter<ChatState> emit) async {
    final id = await _messageRepository.nextId();

    await _messageRepository.save(
      .new(
        id: id,
        chatId: state.chatId,
        authorId: state.character.value?.id,
        text: state.message.text,
        attachmentUri: state.message.attachment,
      ),
    );

    emit(state.copyWith(message: const .empty()));
  }

  final ChatRepository _chatRepository;
  final CharacterRepository _characterRepository;
  final MessageRepository _messageRepository;
}

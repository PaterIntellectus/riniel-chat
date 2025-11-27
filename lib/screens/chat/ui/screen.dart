import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/entities/message/ui/bubble.dart';
import 'package:riniel_chat/screens/chat/ui/bloc/bloc.dart';
import 'package:riniel_chat/screens/chat/ui/message_composer/bloc/bloc.dart';
import 'package:riniel_chat/screens/chat/ui/message_composer/message_composer.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.chatId});

  final ChatId chatId;

  @override
  Widget build(BuildContext context) {
    final chatRepository = context.watch<ChatRepository>();
    final characterRepository = context.watch<CharacterRepository>();
    final messageRepository = context.watch<MessageRepository>();

    return BlocProvider<ChatBloc>(
      create: (context) => .new(
        chatRepository: chatRepository,
        characterRepository: characterRepository,
        messageRepository: messageRepository,
      )..add(ChatStarted(chatId)),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Row(
                spacing: Sizes.s,
                children: [
                  CharacterAvatar(
                    onTap: () =>
                        context.read<ChatBloc>().add(ChatActorSwitched()),
                    avatarUri: state.character.value?.avatarUri,
                    name: state.actor.isUser
                        ? state.character.value?.name
                        : '*',
                  ),

                  Text(
                    state.actor.isUser
                        ? state.character.value?.name ?? ''
                        : 'Пользователь',
                  ),
                ],
              );
            },
          ),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: messageRepository.watch(chatId: chatId),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(child: Text(asyncSnapshot.error.toString()));
                  }

                  return ListView.separated(
                    reverse: true,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Sizes.xs),
                    itemBuilder: (context, index) {
                      final message = asyncSnapshot.data!.elementAt(index);

                      return BlocBuilder<ChatBloc, ChatState>(
                        buildWhen: (previous, current) =>
                            previous.character != current.character,
                        builder: (context, state) {
                          return MessageBubble(
                            textDirection:
                                message.authorId == state.character.value?.id
                                ? .rtl
                                : .ltr,
                            message: message,
                          );
                        },
                      );
                    },
                    itemCount: asyncSnapshot.data?.length ?? 0,
                  );
                },
              ),
            ),

            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return BlocProvider<MessageComposerBloc>(
                  create: (context) => .new(),
                  child: MessageComposer(
                    onSubmit: (value) {
                      print('qwer:author: ${state.messageAuthor?.id}');
                      print('qwer:actor: ${state.actor}');

                      context.read<ChatBloc>().add(
                        ChatMessageSubmitted(
                          .create(
                            chatId: chatId,
                            authorId: state.messageAuthor?.id,
                            text: value.text,
                            attachmentUri: value.attachment,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

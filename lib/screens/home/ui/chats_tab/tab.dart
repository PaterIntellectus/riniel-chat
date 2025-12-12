import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/features/chat/create/ui/dialog.dart';
import 'package:riniel_chat/screens/chat/ui/screen.dart';
import 'package:riniel_chat/screens/home/ui/chats_tab/bloc/bloc.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/style.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key, required this.bloc});

  final ChatsTabBloc bloc;

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab>
    with AutomaticKeepAliveClientMixin<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<ChatsTabBloc, ChatsTabState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Stack(
          children: [
            Builder(
              builder: (context) {
                if (state.chats.isReloading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.chats.hasError) {
                  final message = state.chats.errorMessage;

                  return Center(child: Text(message.toString()));
                }

                final chats = state.chats.requireValue;

                if (chats.isEmpty) {
                  return const Center(child: Text('Список чатов пуст'));
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      widget.bloc.add(const ChatsTabStarted()),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      indent: Sizes.s,
                      endIndent: Sizes.s,
                      height: 1,
                      color: containerColor,
                    ),

                    itemBuilder: (context, index) {
                      final ChatsTabChat(
                        :chatId,
                        chatAvatarUri: characterAvatarUri,
                        chatName: name,
                        :lastMessage,
                      ) = chats.elementAt(
                        index,
                      );

                      return ListTile(
                        key: ValueKey(chatId),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => ChatScreen(chatId: chatId),
                          ),
                        ),
                        leading: CharacterAvatar(
                          avatarUri: characterAvatarUri,
                          name: name.value,
                        ),
                        title: Text(name.value),
                        subtitle: lastMessage != null
                            ? Text(lastMessage.text)
                            : null,
                        trailing: lastMessage != null
                            ? Text(lastMessage.createdAt)
                            : null,
                      );
                    },
                    itemCount: chats.length,
                  ),
                );
              },
            ),

            Positioned(
              bottom: Sizes.m,
              right: Sizes.m,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const CreateChatDialog(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

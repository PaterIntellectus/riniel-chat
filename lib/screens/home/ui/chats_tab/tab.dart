import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/features/chat/settings/ui/chat_settings_dialog.dart';
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
                if (state case ChatsTabProcessing()) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state case ChatsTabFailure()) {
                  final message = state.message;

                  return Center(child: Text(message.toString()));
                }

                final chats = state.list;

                if (chats.isEmpty) {
                  return Center(
                    child: Text(
                      'Список чатов пуст, сначала создайте нового персонажа',
                    ),
                  );
                }

                final navigator = Navigator.of(context);

                return RefreshIndicator(
                  onRefresh: () async => widget.bloc.add(ChatsTabStarted()),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      indent: Sizes.s,
                      endIndent: Sizes.s,
                      height: 1,
                      color: containerColor,
                    ),

                    itemBuilder: (context, index) {
                      final chat = chats.elementAt(index);

                      final character = chat.participants.singleOrNull;
                      final lastMessage = chat.lastMessage;

                      final trailingTime = lastMessage == null
                          ? chat.createdAt
                          : lastMessage.updatedAt;

                      return ListTile(
                        onLongPress: () =>
                            widget.bloc.add(ChatsTabChatRemoved(chat.id)),
                        key: ValueKey(chat.id),
                        onTap: () => navigator.push(
                          MaterialPageRoute<void>(
                            builder: (context) => ChatScreen(chat: chat),
                          ),
                        ),
                        leading: CharacterAvatar(
                          avatarUri: character?.avatarUri,
                          name: character?.name ?? '*',
                        ),
                        title: Text(character?.name ?? 'Группа'),
                        subtitle: lastMessage != null
                            ? Text(lastMessage.text)
                            : null,
                        trailing: Text(
                          '${trailingTime.hour}:${trailingTime.minute}',
                        ),
                      );
                    },
                    itemCount: state.list.length,
                  ),
                );
              },
            ),

            Positioned(
              bottom: Sizes.m,
              right: Sizes.m,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ChatSettingsDialog(),
                  );

                  // widget.bloc.add(
                  //   ChatsTabChatCreated(
                  //     .create(
                  //       id: .new(Random().nextInt(1000).toString()),
                  //       participants: [],
                  //     ),
                  //   ),
                  // );
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

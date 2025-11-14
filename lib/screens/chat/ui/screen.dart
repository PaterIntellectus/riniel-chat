import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/ui/bubble.dart';
import 'package:riniel_chat/features/message/list/bloc/bloc.dart';
import 'package:riniel_chat/features/message/list/ui/provider.dart';
import 'package:riniel_chat/screens/chat/ui/footer.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final character = chat.participants.singleOrNull;

    return MessageListProvider(
      onCreate: (bloc) => bloc.add(MessageListSubscriptionRequested(chat.id)),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Row(
            spacing: 8,
            children: [
              CharacterAvatar(
                avatarUri: chat.participants.singleOrNull?.avatarUri,
                name: chat.participants.singleOrNull?.name ?? '*',
              ),

              Text(character?.name ?? 'Группа'),
            ],
          ),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: BlocBuilder<MessageListBloc, MessageListState>(
                builder: (context, state) {
                  return ListView.separated(
                    reverse: true,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Sizes.xs),
                    itemBuilder: (context, index) {
                      final message = state.list.elementAt(index);

                      return MessageBubble(
                        textDirection: message.authorId == character?.id
                            ? .ltr
                            : .rtl,
                        message: message,
                      );
                    },
                    itemCount: state.list.length,
                  );
                },
              ),
            ),

            ChatFooter(
              onSubmited: (text, attachment) {
                final attachmentUri = attachment == null
                    ? null
                    : Uri.tryParse(attachment.path);

                // repo.save(
                //   .create(
                //     chatId: .new('1'),
                //     authorId: .new('me'),
                //     text: text,
                //     attachmentUri: attachmentUri,
                //   ),
                // );
              },
            ),
          ],
        ),
        // body: Column(
        //   children: [
        //     Expanded(
        //       child: GestureDetector(
        //         child: ListView.separated(
        //           padding: EdgeInsets.symmetric(vertical: Sizes.xs),
        //           reverse: true,
        //           itemCount: messages.length,
        //           separatorBuilder: (context, index) =>
        //               SizedBox(height: Sizes.xs),
        //           itemBuilder: (context, index) {
        //             final message = messages.elementAt(index);

        //             return MessageBubble(
        //               textDirection: message.authorId == _chat.sender.id
        //                   ? TextDirection.rtl
        //                   : TextDirection.ltr,
        //               message: message,
        //               onLongPress: _deleteMessage,
        //             );
        //           },
        //         ),
        //       ),
        //     ),

        //     Container(
        //       decoration: BoxDecoration(
        //         color: theme.colorScheme.surface,
        //         boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 2)],
        //       ),

        //       child: ChatFooter(
        //         padding: EdgeInsets.symmetric(horizontal: Sizes.s),
        //         onMessageSubmited: (String text, File? attachment) =>
        //             _sendMessage(text: text, attachment: attachment),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );

    // return Theme(
    //   data: theme,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: theme.primaryColor,
    //       leading: BackButton(onPressed: _toggleUser),
    //       title: Row(
    //         spacing: 8,
    //         children: [
    //           UserAvatar(user: _chat.receiver, onTap: _setUserAvatar),

    //           Expanded(
    //             child: UserName(
    //               key: ValueKey(_chat.receiver.id),
    //               name: _chat.receiver.name,
    //               onSubmitted: _setUserName,
    //             ),
    //           ),
    //         ],
    //       ),
    //       actions: [
    //         Builder(
    //           builder: (context) {
    //             return IconButton(
    //               icon: Icon(
    //                 Icons.more_vert,
    //                 color: Theme.of(context).colorScheme.onPrimary,
    //               ),
    //               onPressed: () => showDialog(
    //                 context: context,
    //                 builder: (context) => ColorPickerDialog(
    //                   activeThemeMode: widget.activeThemeMode,
    //                   color: _chat.themeColor,
    //                   onColorChanged: (value) =>
    //                       setState(() => _chat = _chat.updateThemeColor(value)),
    //                   onThemeModeChanged: widget.onThemeModeChanged,
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //     body: Column(
    //       children: [
    //         Expanded(
    //           child: GestureDetector(
    //             onLongPress: _setBackgroundImage,
    //             child: DecoratedBox(
    //               decoration: BoxDecoration(
    //                 image: _chat.backgroundImage == null
    //                     ? null
    //                     : DecorationImage(
    //                         image: FileImage(_chat.backgroundImage!),
    //                         fit: BoxFit.cover,
    //                       ),
    //               ),
    //               child: ListView.separated(
    //                 padding: EdgeInsets.symmetric(vertical: Sizes.xs),
    //                 reverse: true,
    //                 itemCount: messages.length,
    //                 separatorBuilder: (context, index) =>
    //                     SizedBox(height: Sizes.xs),
    //                 itemBuilder: (context, index) {
    //                   final message = messages.elementAt(index);

    //                   return MessageBubble(
    //                     textDirection: message.authorId == _chat.sender.id
    //                         ? TextDirection.rtl
    //                         : TextDirection.ltr,
    //                     message: message,
    //                     onLongPress: _deleteMessage,
    //                   );
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),

    //         Container(
    //           decoration: BoxDecoration(
    //             color: theme.colorScheme.surface,
    //             boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 2)],
    //           ),

    //           child: ChatFooter(
    //             padding: EdgeInsets.symmetric(horizontal: Sizes.s),
    //             onMessageSubmited: (String text, File? attachment) =>
    //                 _sendMessage(text: text, attachment: attachment),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

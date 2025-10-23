import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/presentation/constants.dart';
import 'package:riniel_chat/domain/chat.dart';
import 'package:riniel_chat/domain/message.dart';
import 'package:riniel_chat/presentation/widgets/chat_footer.dart';
import 'package:riniel_chat/presentation/widgets/message_bubble.dart';
import 'package:riniel_chat/presentation/widgets/user_name.dart';
import 'package:riniel_chat/presentation/widgets/color_picker_dialog.dart';
import 'package:riniel_chat/presentation/widgets/user_avatar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chat,
    required this.activeThemeMode,
    required this.onThemeModeChanged,
  });

  final Chat chat;
  final ValueChanged<ThemeMode?> onThemeModeChanged;
  final ThemeMode activeThemeMode;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Chat _chat = widget.chat;

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final theme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: _chat.themeColor),
      textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 19)),
    );

    final messages = _chat.messages.reversed;

    return Text('chat');

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

  // void _toggleUser() => setState(() => _chat = _chat.toggleUser());

  // void _sendMessage({required String text, File? attachment}) {
  //   return setState(
  //     () => _chat = _chat.sendMessage(
  //       Message(
  //         chatId: _chat.id,
  //         authorId: _chat.sender.id,
  //         text: text,
  //         attachment: attachment,
  //       ),
  //     ),
  //   );
  // }

  // void _deleteMessage(Message message) =>
  //     setState(() => _chat = _chat.deleteMessage(message));

  // void _setBackgroundImage() async {
  //   final response = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (response == null || response.path.isEmpty) {
  //     return;
  //   }

  //   setState(() => _chat = _chat.changeBackgroundImage(File(response.path)));
  // }

  // void _setUserName(String value) =>
  //     setState(() => _chat = _chat.setReceiverName(value));

  // void _setUserAvatar() async {
  //   final response = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (response == null || response.path.isEmpty) {
  //     return;
  //   }

  //   setState(() => _chat = _chat.setReceiverAvatar(File(response.path)));
  // }
}

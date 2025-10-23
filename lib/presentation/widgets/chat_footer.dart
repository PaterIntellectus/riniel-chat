import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/presentation/widgets/message_input.dart';

class ChatFooter extends StatefulWidget {
  const ChatFooter({super.key, required this.onMessageSubmited, this.padding});

  final void Function(String text, File? attachment) onMessageSubmited;
  final EdgeInsets? padding;

  @override
  State<ChatFooter> createState() => _ChatFooterState();
}

class _ChatFooterState extends State<ChatFooter> {
  final _messageTextController = TextEditingController();
  File? _attachment;
  bool canSend = false;

  @override
  void initState() {
    _messageTextController.addListener(_listenController);

    super.initState();
  }

  void _listenController() {
    final text = _messageTextController.text.trim();

    if (text.isEmpty && canSend) {
      setState(() => canSend = false);
    }

    if (text.isNotEmpty && !canSend) {
      setState(() => canSend = true);
    }
  }

  @override
  void dispose() {
    _messageTextController.removeListener(_listenController);
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final footer = TextFieldTapRegion(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.sentiment_satisfied_sharp),
          ),

          Expanded(child: MessageInput(controller: _messageTextController)),

          IconButton(
            key: ValueKey(canSend),
            onPressed: _handleMessageSubmit,
            icon: Icon(Icons.send),
          ),

          IconButton(
            onLongPress: () => setState(() => _attachment = null),
            onPressed: () async {
              final image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (image == null || image.path.isEmpty) {
                return;
              }

              setState(() => _attachment = File(image.path));
            },
            icon: Icon(
              Icons.attach_file,
              color: _attachment == null ? null : Colors.blue,
            ),
          ),

          IconButton(onPressed: () {}, icon: Icon(Icons.mic_none)),
        ],
      ),
    );

    if (widget.padding != null) {
      return Padding(padding: widget.padding!, child: footer);
    }

    return footer;
  }

  void _handleMessageSubmit() {
    final value = _messageTextController.text.trim();

    if (value.isEmpty && _attachment == null) {
      return;
    }

    widget.onMessageSubmited(value, _attachment);

    setState(() {
      _messageTextController.clear();
      _attachment = null;
    });
  }
}

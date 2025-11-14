import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/entities/message/ui/input.dart';
import 'package:riniel_chat/shared/ui/file_picker_controller.dart';

class ChatFooter extends StatefulWidget {
  const ChatFooter({super.key, required this.onSubmited, this.padding});

  final void Function(String text, XFile? attachment) onSubmited;
  final EdgeInsets? padding;

  @override
  State<ChatFooter> createState() => _ChatFooterState();
}

class _ChatFooterState extends State<ChatFooter> {
  final _textController = TextEditingController();
  final _attachmentController = FileController();

  @override
  void dispose() {
    _attachmentController.dispose();
    _textController.dispose();

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

          Expanded(child: MessageInput(controller: _textController)),

          ValueListenableBuilder(
            valueListenable: _textController,
            builder: (context, textValue, child) => ValueListenableBuilder(
              valueListenable: _attachmentController,
              builder: (context, attachment, child) => IconButton(
                onPressed: textValue.text.isNotEmpty || attachment != null
                    ? _handleMessageSubmit
                    : null,
                icon: child!,
              ),
              child: Icon(Icons.send),
            ),
          ),

          IconButton(
            onLongPress: () => _attachmentController.value = null,
            onPressed: () async {
              final attachment = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (attachment == null) {
                return;
              }

              _attachmentController.value = attachment;
            },
            icon: ValueListenableBuilder(
              valueListenable: _attachmentController,
              builder: (context, value, child) => Icon(
                Icons.attach_file,
                color: _attachmentController.value == null ? null : Colors.blue,
              ),
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
    final text = _textController.text.trim();
    final attachment = _attachmentController.value;

    if (text.isEmpty && attachment == null) {
      return;
    }

    widget.onSubmited(text, attachment);

    _textController.clear();
    _attachmentController.drop();
  }
}

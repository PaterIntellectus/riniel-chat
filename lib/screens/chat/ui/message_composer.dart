import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/screens/chat/ui/bloc/bloc.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({super.key});

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(
      text: context.read<ChatBloc>().state.message.text,
    );
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) => current.message.text.isEmpty,
      listener: (context, state) {
        _textController.text = state.message.text;
      },
      child: Row(
        crossAxisAlignment: .end,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sentiment_satisfied_sharp),
          ),

          Expanded(
            child: TextField(
              autofocus: false,
              controller: _textController,
              onChanged: (value) => context.read<ChatBloc>().add(
                ChatMessageTextChanged(value.trim()),
              ),
              minLines: 1,
              maxLines: 5,
              keyboardType: .multiline,
              decoration: const .new(hintText: "Сообщение", border: .none),
            ),
          ),

          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) =>
                previous.message != current.message,
            builder: (context, state) {
              return IconButton(
                onPressed: state.message.isNotEmpty
                    ? () => context.read<ChatBloc>().add(
                        const ChatMessageSubmitted(),
                      )
                    : null,
                icon: const Icon(Icons.send),
              );
            },
          ),

          IconButton(
            onLongPress: () => context.read<ChatBloc>().add(
              const ChatMessageAttachmentChanged(null),
            ),
            onPressed: () async {
              final attachment = await ImagePicker().pickImage(
                source: .gallery,
              );

              if (attachment == null) {
                return;
              }

              if (context.mounted) {
                context.read<ChatBloc>().add(
                  ChatMessageAttachmentChanged(attachment),
                );
              }
            },
            icon: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) =>
                  previous.message.hasAttachment !=
                  current.message.hasAttachment,
              builder: (context, state) {
                return Icon(
                  Icons.attach_file,
                  color: state.message.hasAttachment ? Colors.blue : null,
                );
              },
            ),
          ),

          IconButton(onPressed: () {}, icon: const Icon(Icons.mic_none)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/screens/chat/ui/message_composer/bloc/bloc.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({super.key, required this.onSubmit});

  final ValueChanged<MessageComposerState> onSubmit;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageComposerBloc, MessageComposerState>(
      listenWhen: (previous, current) =>
          previous.isNotEmpty != current.isNotEmpty,
      listener: (context, state) {
        _textController.text = state.text;
      },
      child: Builder(
        builder: (context) => Row(
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
                onChanged: (value) => context.read<MessageComposerBloc>().add(
                  MessageComposerTextChanged(value.trim()),
                ),
                minLines: 1,
                maxLines: 5,
                keyboardType: .multiline,
                decoration: .new(hintText: "Сообщение", border: .none),
              ),
            ),

            BlocBuilder<MessageComposerBloc, MessageComposerState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: state.isNotEmpty
                      ? () => widget.onSubmit(state)
                      : null,
                  icon: const Icon(Icons.send),
                );
              },
            ),

            IconButton(
              onLongPress: () => context.read<MessageComposerBloc>().add(
                MessageComposerAttachmentChanged(null),
              ),
              onPressed: () async {
                final attachment = await ImagePicker().pickImage(
                  source: .gallery,
                );

                if (attachment == null) {
                  return;
                }

                if (context.mounted) {
                  context.read<MessageComposerBloc>().add(
                    MessageComposerAttachmentChanged(attachment),
                  );
                }
              },
              icon: BlocBuilder<MessageComposerBloc, MessageComposerState>(
                builder: (context, state) {
                  return Icon(
                    Icons.attach_file,
                    color: state.hasAttachment ? Colors.blue : null,
                  );
                },
              ),
            ),

            IconButton(onPressed: () {}, icon: const Icon(Icons.mic_none)),
          ],
        ),
      ),
    );
  }
}

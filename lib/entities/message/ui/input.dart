import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      minLines: 1,
      maxLines: 5,
      keyboardType: .multiline,
      decoration: InputDecoration(hintText: "Сообщение", border: .none),
    );
  }
}

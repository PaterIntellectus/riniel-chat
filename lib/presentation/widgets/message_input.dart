import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController? controller;

  const MessageInput({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      minLines: 1,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: "Сообщение",
        border: InputBorder.none,
      ),
    );
  }
}

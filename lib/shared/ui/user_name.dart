import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  final String name;
  final ValueChanged<String>? onSubmitted;

  const UserName({super.key, required this.name, this.onSubmitted});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final _focusNode = FocusNode();
  late final _controller = TextEditingController(text: widget.name);

  @override
  void initState() {
    _controller.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EditableText(
      controller: _controller,
      onSubmitted: widget.onSubmitted,
      focusNode: _focusNode,
      backgroundCursorColor: theme.colorScheme.primary,
      cursorColor: theme.colorScheme.primary,
      onTapOutside: (event) => _focusNode.unfocus(),
      style: theme.textTheme.headlineSmall!,
    );
  }
}

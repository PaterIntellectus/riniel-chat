import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ChatTheme with EquatableMixin {
  const ChatTheme({
    required this.mainColor,
    required this.messageBubbleColor,
    required this.textColor,
  });

  final Color mainColor;
  final Color messageBubbleColor;
  final Color textColor;

  @override
  List<Object?> get props => [mainColor, messageBubbleColor, textColor];
}

extension ChatThemeMutations on ChatTheme {
  ChatTheme copyWith({
    final Color? mainColor,
    final Color? messageBubbleColor,
    final Color? textColor,
  }) {
    return ChatTheme(
      mainColor: mainColor ?? this.mainColor,
      messageBubbleColor: messageBubbleColor ?? this.messageBubbleColor,
      textColor: textColor ?? this.textColor,
    );
  }
}

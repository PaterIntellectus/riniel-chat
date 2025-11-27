part of 'bloc.dart';

class MessageComposerState with EquatableMixin {
  const MessageComposerState({required String text, required this.attachment})
    : _text = text;

  const MessageComposerState.initial() : this(text: '', attachment: null);

  MessageComposerState copyWith({
    final String? text,
    final Uri? Function()? attachment,
  }) => .new(
    text: text ?? this.text,
    attachment: attachment?.call() ?? this.attachment,
  );

  final String _text;
  final Uri? attachment;

  @override
  List<Object?> get props => [_text, attachment];

  String get text => _text.trim();

  bool get hasText => text.isNotEmpty;
  bool get hasAttachment => attachment != null;
  bool get isEmpty => !hasText && !hasAttachment;
  bool get isNotEmpty => !isEmpty;
}

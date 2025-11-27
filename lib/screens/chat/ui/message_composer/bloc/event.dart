part of 'bloc.dart';

sealed class MessageComposerEvent extends Equatable {
  const MessageComposerEvent();

  @override
  List<Object?> get props => [];
}

final class MessageComposerTextChanged extends MessageComposerEvent {
  const MessageComposerTextChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class MessageComposerAttachmentChanged extends MessageComposerEvent {
  const MessageComposerAttachmentChanged(this.attachment);

  final XFile? attachment;

  @override
  List<Object?> get props => [...super.props, attachment];
}

final class MessageComposerAuthorSelected extends MessageComposerEvent {
  const MessageComposerAuthorSelected(this.authorId);

  final CharacterId? authorId;

  @override
  List<Object?> get props => [...super.props, authorId];
}

final class MessageComposerCleared extends MessageComposerEvent {
  const MessageComposerCleared();
}

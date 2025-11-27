part of 'bloc.dart';

enum ChatStatus { idle, processing, sucess, failure }

enum ChatActor {
  user,
  character;

  ChatActor toggle() => isUser ? character : user;

  bool get isUser => this == .user;
}

class ChatState with EquatableMixin {
  const ChatState({
    required this.status,
    required this.character,
    required this.actor,
  });

  const ChatState.initial()
    : this(status: .idle, character: const .loading(), actor: .user);

  ChatState copyWith({
    final ChatStatus? status,
    final AsyncValue<Character>? character,
    final ChatActor? actor,
  }) => .new(
    status: status ?? this.status,
    character: character ?? this.character,
    actor: actor ?? this.actor,
  );

  final ChatStatus status;
  final AsyncValue<Character> character;
  final ChatActor actor;

  @override
  List<Object?> get props => [status, character, actor];

  Character? get messageAuthor => actor.isUser ? null : character.value;
}

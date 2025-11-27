part of 'bloc.dart';

enum CreateChatStatus { idle, loading, success, failure }

typedef CreateChatCharacterList = AsyncValue<List<Character>>;

class ChatNameState with EquatableMixin {
  ChatNameState(String value, {required this.isDefault}) : value = value.trim();

  const ChatNameState.initial() : value = '', isDefault = true;

  final String value;
  final bool isDefault;

  @override
  List<Object?> get props => [value, isDefault];
}

class CreateChatState with EquatableMixin {
  const CreateChatState({
    required this.status,
    required final CreateChatCharacterList characters,
    required this.chatName,
    required this.selectedCharacter,
    required this.message,
  }) : _characters = characters;

  CreateChatState copyWith({
    final CreateChatStatus? status,
    final CreateChatCharacterList? characters,
    final ChatNameState? chatName,
    final Character? selectedCharacter,
    final String? message,
  }) => .new(
    status: status ?? this.status,
    characters: characters ?? _characters,
    chatName: chatName ?? this.chatName,
    selectedCharacter: selectedCharacter ?? this.selectedCharacter,
    message: message ?? '',
  );

  final CreateChatStatus status;
  final CreateChatCharacterList _characters;
  final ChatNameState chatName;
  final Character? selectedCharacter;
  final String message;

  @override
  List<Object?> get props => [
    status,
    _characters,
    chatName,
    selectedCharacter,
    message,
  ];

  bool get hasMessage => message.isNotEmpty;
  bool get isCharacterSelected => selectedCharacter != null;
  bool get canSubmit => isCharacterSelected && chatName.value.isNotEmpty;

  AsyncValue<UnmodifiableListView<Character>> get characters =>
      _characters.castValue((value) => value == null ? null : .new(value));
}

// sealed class CreateChatState extends Equatable {
//   const CreateChatState({
//     required final List<Chat> chats,
//     required final List<Character> characters,
//     required final List<Character> participants,
//   }) : _chats = chats,
//        _characters = characters,
//        _participants = participants;

//   final List<Chat> _chats;
//   final List<Character> _characters;
//   final List<Character> _participants;

//   @override
//   List<Object?> get props => [_chats, _characters, _participants];

//   UnmodifiableListView<Character> get characters =>
//       UnmodifiableListView(_characters);

//   UnmodifiableListView<Character> get participants =>
//       UnmodifiableListView(_participants);
// }

// final class CreateChatInitial extends CreateChatState {
//   const CreateChatInitial({
//     super.chats = const [],
//     super.characters = const [],
//     super.participants = const [],
//   });
// }

// final class CreateChatReady extends CreateChatState {
//   const CreateChatReady({
//     super.chats = const [],
//     super.characters = const [],
//     super.participants = const [],
//   });
// }

// // in progress
// abstract class CreateChatInProgress extends CreateChatState {
//   const CreateChatInProgress({
//     required super.chats,
//     required super.characters,
//     required super.participants,
//   });
// }

// final class CreateChatStarting extends CreateChatInProgress {
//   const CreateChatStarting({
//     required super.chats,
//     required super.characters,
//     required super.participants,
//   });
// }

// final class CreateChatSubmitting extends CreateChatInProgress {
//   const CreateChatSubmitting({
//     required super.chats,
//     required super.characters,
//     required super.participants,
//   });
// }

// // success
// final class CreateChatSuccess extends CreateChatState {
//   const CreateChatSuccess({
//     required super.chats,
//     required super.characters,
//     required super.participants,
//   });
// }

// // failure
// final class CreateChatFailure extends CreateChatState {
//   const CreateChatFailure({
//     required super.chats,
//     required super.characters,
//     required super.participants,
//     required this.message,
//   });

//   final String message;

//   @override
//   List<Object?> get props => [...super.props, message];
// }

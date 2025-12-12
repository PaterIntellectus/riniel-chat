part of 'bloc.dart';

enum CharacterListStatus { initial, processing, failure }

class CharactersListState with EquatableMixin {
  const CharactersListState({
    required this.status,
    required AsyncState<List<Character>> characters,
    required this.message,
  }) : _characters = characters;

  CharactersListState copyWith({
    final CharacterListStatus? status,
    final AsyncState<Iterable<Character>>? characters,
    final String? message,
  }) => .new(
    status: status ?? this.status,
    characters:
        characters?.castValue((value) => value?.toList()) ?? _characters,
    message: message ?? this.message,
  );

  final CharacterListStatus status;
  final AsyncState<List<Character>> _characters;
  final String message;

  @override
  List<Object?> get props => [status, _characters, message];

  AsyncState<UnmodifiableListView<Character>> get characters => _characters
      .castValue((value) => value == null ? null : UnmodifiableListView(value));
}

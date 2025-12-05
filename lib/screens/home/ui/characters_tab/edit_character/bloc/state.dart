part of 'bloc.dart';

enum EditCharacterSubmissionStatus { idle, inProgress, success, failure }

enum NameFieldError {
  empty;

  @override
  String toString() => switch (this) {
    empty => 'Необходимо заполнить поле',
  };
}

class NameField with EquatableMixin {
  const NameField._(this.value, this.isPure);
  const NameField.pure({this.value = ''}) : isPure = true;
  const NameField.edited(final String value) : this._(value, false);

  NameFieldError? validator(String value) => value.isEmpty ? .empty : null;

  final String value;
  final bool isPure;

  @override
  List<Object?> get props => [value];

  bool get isValid => validator(value) == null ? true : false;
  String? get displayError => isEdited ? validator(value).toString() : null;
  bool get isEdited => !isPure;
}

class EditCharacterState extends Equatable {
  const EditCharacterState({
    required this.status,
    required this.initialCharacter,
    required this.name,
    required this.note,
    required this.avatarPath,
  });

  const EditCharacterState.initial({
    this.initialCharacter,
    required this.name,
    required this.note,
    required this.avatarPath,
  }) : status = .idle;

  EditCharacterState copyWith({
    final EditCharacterSubmissionStatus? status,
    final NameField? name,
    final String? note,
    final String? avatarPath,
  }) => .new(
    status: status ?? this.status,
    initialCharacter: initialCharacter,
    name: name ?? this.name,
    note: note ?? this.note,
    avatarPath: avatarPath ?? this.avatarPath,
  );

  final EditCharacterSubmissionStatus status;
  final Character? initialCharacter;
  final NameField name;
  final String note;
  final String avatarPath;

  @override
  List<Object?> get props => [status, initialCharacter, name, note, avatarPath];

  bool get isCreationMode => initialCharacter == null;
  bool get isEditMode => initialCharacter != null;
}

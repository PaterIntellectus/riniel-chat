part of 'bloc.dart';

sealed class EditCharacterState extends Equatable {
  const EditCharacterState();

  @override
  List<Object> get props => [];
}

final class EditCharacterInitial extends EditCharacterState {}

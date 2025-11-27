import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class EditCharacterBloc extends Bloc<EditCharacterEvent, EditCharacterState> {
  EditCharacterBloc() : super(EditCharacterInitial()) {
    on<EditCharacterEvent>((event, emit) {
      // TODO: implement bloc to handle character creation and update processes
    });
  }
}

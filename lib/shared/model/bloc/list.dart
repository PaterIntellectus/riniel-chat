import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ListState<T> with EquatableMixin {
  const ListState({required List<T> list}) : _list = list;

  final List<T> _list;

  @override
  List<Object?> get props => [_list];

  UnmodifiableListView<T> get list => UnmodifiableListView(_list);
}

abstract class ListEvent with EquatableMixin {
  const ListEvent();

  @override
  List<Object?> get props => const [];
}

class ListBloc<E extends ListEvent, S extends ListState, U> extends Bloc<E, S> {
  ListBloc(super.initial);
}

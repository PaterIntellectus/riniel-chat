import 'dart:collection';

import 'package:equatable/equatable.dart';

abstract class ListState<T> with EquatableMixin {
  const ListState({required List<T> list}) : _list = list;

  final List<T> _list;

  @override
  List<Object?> get props => [_list];

  UnmodifiableListView<T> get list => UnmodifiableListView(_list);
}

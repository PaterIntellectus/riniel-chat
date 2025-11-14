import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

enum MessageType { info, success, warning, error }

typedef UiEvent = ({String text, MessageType type});

mixin BlocUiEventMixin<S, E> on EmittableStateStreamableSource<S> {
  @protected
  void emitUiEvent(E event) => _controller.add(event);

  final StreamController<E> _controller = .broadcast();

  Stream<E> get uiEvents => _controller.stream;

  @override
  @mustCallSuper
  Future<void> close() async {
    await _controller.close();
    await super.close();
  }
}

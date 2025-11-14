import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/shared/model/bloc/ui_event_mixin.dart';

class BlocUiEventListener<B extends BlocUiEventMixin, E>
    extends StatefulWidget {
  const BlocUiEventListener({
    super.key,
    required this.listener,
    required this.child,
  });

  final void Function(BuildContext context, UiEvent event) listener;
  final Widget child;

  @override
  State<BlocUiEventListener<B, E>> createState() =>
      _BlocUiEventListenerState<B, E>();
}

class _BlocUiEventListenerState<B extends BlocUiEventMixin, E>
    extends State<BlocUiEventListener<B, E>> {
  @override
  void initState() {
    context.read<B>().uiEvents.listen(
      (event) => mounted ? widget.listener(context, event) : null,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

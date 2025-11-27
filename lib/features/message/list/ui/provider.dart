// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:riniel_chat/entities/message/model/message.dart';
// import 'package:riniel_chat/features/message/list/bloc/bloc.dart';

// class MessageListProvider extends StatelessWidget {
//   const MessageListProvider({
//     super.key,
//     this.lazy = true,
//     this.child,
//     this.onCreate,
//   });

//   final void Function(MessageListBloc bloc)? onCreate;
//   final bool lazy;
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     final messageRepository = context.watch<MessageRepository>();

//     return BlocProvider(
//       create: (context) {
//         final bloc = MessageListBloc(messageRepository);
//         onCreate?.call(bloc);
//         return bloc;
//       },
//       lazy: lazy,
//       child: child,
//     );
//   }
// }

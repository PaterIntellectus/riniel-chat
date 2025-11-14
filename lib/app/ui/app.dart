import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/screens/home/ui/screen.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.characterRepository,
    required this.messageRepository,
    required this.chatRepository,
  });

  final CharacterRepository characterRepository;
  final MessageRepository messageRepository;
  final ChatRepository chatRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riniel Chat',
      themeMode: .system,
      theme: .light().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            .android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: .dark().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            .android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => characterRepository),
          RepositoryProvider(create: (context) => messageRepository),
          RepositoryProvider(create: (context) => chatRepository),
        ],
        child: child!,
      ),
      home: HomeScreen(),
    );
  }
}

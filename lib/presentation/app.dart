import 'package:flutter/material.dart';
import 'package:riniel_chat/data/prefs_character_repo.dart';
import 'package:riniel_chat/domain/chat.dart';
import 'package:riniel_chat/presentation/screens/chat_list_screen.dart';
import 'package:riniel_chat/presentation/screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final chat = Chat(
  id: Uuid().v4(),
  participants: [],
  messages: const [],
  themeColor: Color(0xffffffff),
  backgroundImage: null,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  deletedAt: null,
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riniel Chat',
      themeMode: themeMode,
      theme: ThemeData.from(colorScheme: ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
      routes: {
        '/': (context) => FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Scaffold(body: Center(child: Text('Loading')));
            }

            return ChatListScreen(
              characterRepo: CharacterPrefsRepository(snapshot.data!),
            );
          },
        ),
        '/chat': (context) => ChatScreen(
          chat: chat,
          activeThemeMode: themeMode,
          onThemeModeChanged: (tm) {
            print('callback:tm: $tm');

            if (tm != null) {
              setState(() => themeMode = tm);
            }
          },
        ),
      },
    );
  }
}

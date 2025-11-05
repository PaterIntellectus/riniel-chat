import 'package:flutter/material.dart';
import 'package:riniel_chat/domain/character/model/character.dart';
import 'package:riniel_chat/domain/character/ui/repository_provider.dart';
import 'package:riniel_chat/screen/home/ui/screen.dart';

class App extends StatefulWidget {
  const App({super.key, required this.characterRepository});

  final CharacterRepository characterRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return CharacterRepositoryProvider(
      repository: widget.characterRepository,
      child: MaterialApp(
        title: 'Riniel Chat',
        themeMode: themeMode,
        theme: ThemeData.from(colorScheme: ColorScheme.light()),
        darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
        routes: {'/': (context) => HomeScreen()},
      ),
    );
  }
}

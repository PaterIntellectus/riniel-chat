import 'package:flutter/widgets.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';

class Dialog extends StatelessWidget {
  const Dialog({super.key, required this.characters, required this.onSelected});

  final List<Character> characters;
  final void Function(Character chatacter) onSelected;

  @override
  Widget build(BuildContext context) {
    return RinielDialog(header: Text('Выбор персонажа:'), body: Text('er'));
  }
}

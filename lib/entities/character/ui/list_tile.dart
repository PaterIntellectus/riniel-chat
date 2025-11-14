import 'package:flutter/material.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/entities/character/ui/info_dialog.dart';
import 'package:riniel_chat/shared/ui/style.dart';

class CharacterListTile extends StatelessWidget {
  const CharacterListTile({
    super.key,
    required this.character,
    this.onLongPress,
    this.trailing,
  });

  final Character character;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Character(:name, :avatarUri, :note) = character;

    final subtitle = note.isEmpty
        ? null
        : Text(note, overflow: .ellipsis, maxLines: 1);

    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) => CharacterInfoDialog(character: character),
      ),
      tileColor: containerColor,
      leading: CharacterAvatar(avatarUri: avatarUri, name: name),
      title: Text(name),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

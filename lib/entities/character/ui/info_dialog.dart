import 'package:flutter/material.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';

class CharacterInfoDialog extends StatelessWidget {
  const CharacterInfoDialog({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasNote = character.note.isNotEmpty;

    return RinielDialog(
      header: Row(
        spacing: Sizes.s,
        children: [
          CharacterAvatar(avatarUri: character.avatarUri, name: character.name),

          Text(character.name),
        ],
      ),
      body: Padding(
        padding: const .all(Sizes.m),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            if (hasNote) ...[
              Text(character.note, style: theme.textTheme.bodyMedium),
              const SizedBox(height: Sizes.s),
            ],

            Text(
              'Создан: ${character.createdAt}',
              style: theme.textTheme.labelLarge,
            ),

            Text(
              'Изменён: ${character.updatedAt}',
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

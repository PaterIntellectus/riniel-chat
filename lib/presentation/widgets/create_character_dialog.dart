import 'package:flutter/material.dart';
import 'package:riniel_chat/domain/character/model/character.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

class CharacterEditorDialog extends StatefulWidget {
  const CharacterEditorDialog({
    super.key,
    required this.onSaved,
    this.character,
  });

  final void Function(Character character) onSaved;
  final Character? character;

  @override
  State<CharacterEditorDialog> createState() => _CharacterEditorDialogState();
}

class _CharacterEditorDialogState extends State<CharacterEditorDialog> {
  late final avatar = widget.character?.avatar;
  late final nameController = TextEditingController(
    text: widget.character?.name ?? '',
  );

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          final char = saveCharacter();

          if (char != null) {
            widget.onSaved(char);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(Sizes.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: Sizes.s,
          children: [
            Text(
              widget.character == null
                  ? 'Создание персонажа:'
                  : 'Редактирование персонажа:',
              style: theme.textTheme.titleMedium,
            ),

            Row(
              spacing: Sizes.s,
              children: [
                CircleAvatar(child: Text('X')),

                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Персонажу необходимо имя'
                        : null,
                    onTapOutside: (event) => FocusScope.of(context),
                    decoration: InputDecoration(hintText: 'Имя персонажа'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Character? saveCharacter() {
    final name =
        (nameController.text.isEmpty
            ? widget.character?.name
            : nameController.text) ??
        '';

    if (name.isEmpty) {
      return null;
    }

    if (widget.character != null) {
      return Character(
        id: widget.character!.id,
        name: name,
        avatar: avatar,
        note: '',
        createdAt: widget.character!.createdAt,
        updatedAt: widget.character!.updatedAt,
      );
    }

    return Character.create(name: name, avatar: avatar);
  }
}

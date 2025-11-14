import 'package:flutter/material.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';
import 'package:riniel_chat/shared/ui/style.dart';

class RemoveCharacterDialog extends StatelessWidget {
  const RemoveCharacterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RinielDialog(
      header: Text(
        'Вы уверены что хотите удалить данного персонажа?',
        style: theme.textTheme.titleSmall,
      ),
      footer: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Отмена'),
          ),

          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(dangerColor),
            ),
            child: Text('Подтвердить'),
          ),
        ],
      ),
    );
  }
}

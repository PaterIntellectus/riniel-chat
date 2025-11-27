import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/file_controller.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';
import 'package:riniel_chat/shared/ui/style.dart';

// Возвращает созданного или обновлённого персонажа
class EditCharacterDialog extends StatefulWidget {
  const EditCharacterDialog({super.key, this.character});

  final Character? character;

  @override
  State<EditCharacterDialog> createState() => _EditCharacterDialogState();
}

class _EditCharacterDialogState extends State<EditCharacterDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _avatarController = FileController(
    widget.character?.avatarUri != null
        ? XFile(widget.character!.avatarUri!.path)
        : null,
  );
  late final _nameController = TextEditingController(
    text: widget.character?.name ?? '',
  );
  late final _noteController = TextEditingController(
    text: widget.character?.note ?? '',
  );

  @override
  void dispose() {
    _noteController.dispose();
    _nameController.dispose();
    _avatarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    final title = widget.character == null
        ? 'Создание персонажа:'
        : 'Редактирование персонажа:';

    return RinielDialog(
      header: Text(title, style: theme.textTheme.titleMedium),
      body: Form(
        key: _formKey,
        // canPop: false,
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.s),
          child: Column(
            mainAxisSize: .min,
            spacing: Sizes.s,
            children: [
              Row(
                spacing: Sizes.s,
                children: [
                  ListenableBuilder(
                    listenable: .merge([_avatarController, _nameController]),
                    builder: (context, child) => CharacterAvatar(
                      onLongPress: () => _avatarController.value = null,
                      onTap: () async {
                        final image = await ImagePicker().pickImage(
                          source: .gallery,
                        );

                        if (image != null) {
                          _avatarController.value = image;
                        }
                      },
                      avatarUri: _avatarController.value != null
                          ? .parse(_avatarController.value!.path)
                          : null,
                      name: _nameController.value.text,
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      textCapitalization: .words,
                      autovalidateMode: .onUserInteraction,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Персонажу необходимо имя'
                          : null,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: const .new(hintText: 'Имя персонажа'),
                    ),
                  ),
                ],
              ),

              TextFormField(
                controller: _noteController,
                textCapitalization: .sentences,
                autovalidateMode: .onUserInteraction,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: const .new(
                  hintText: 'Дополнительное описание',
                  border: .none,
                  fillColor: containerColor,
                  filled: true,
                ),
                minLines: 3,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),

      footer: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          FilledButton(onPressed: navigator.pop, child: Text('Отмена')),

          FilledButton(
            onPressed: saveCharacter,
            style: const .new(
              backgroundColor: WidgetStatePropertyAll(successColor),
            ),
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void saveCharacter() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var name = widget.character?.name ?? '';
    if (_nameController.text.isNotEmpty) {
      name = _nameController.text.trim();
    }

    if (name.isEmpty) {
      return;
    }

    var avatar = widget.character?.avatarUri;
    if (_avatarController.value != null) {
      avatar = .parse(_avatarController.value!.path);
    }

    final note = _noteController.text.trim();

    Character character;
    if (widget.character != null) {
      character = widget.character!.update(
        name: name,
        avatarUri: avatar,
        note: note,
      );
    } else {
      character = .create(name: name, avatarUri: avatar, note: note);
    }

    Navigator.of(context).pop(character);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/screens/home/ui/characters_tab/edit_character/bloc/bloc.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';
import 'package:riniel_chat/shared/ui/style.dart';

class EditCharacterDialog extends StatelessWidget {
  const EditCharacterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    return BlocListener<EditCharacterBloc, EditCharacterState>(
      listener: (context, state) {
        if (state.status == .success) {
          Navigator.of(context).pop();

          final text = state.initialCharacter == null
              ? "Персонаж успешно создан"
              : "Персонаж успешно обновлён";

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        } else if (state.status == .failure) {
          final text = state.initialCharacter == null
              ? "Не удалось создать персонажа"
              : "Не удалось обновить персонажа";

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        }
      },
      child: RinielDialog(
        header: BlocBuilder<EditCharacterBloc, EditCharacterState>(
          builder: (context, state) {
            final title = state.isCreationMode
                ? 'Создание персонажа:'
                : 'Редактирование персонажа:';

            return Text(title, style: theme.textTheme.titleMedium);
          },
        ),
        body: Padding(
          padding: const .symmetric(horizontal: Sizes.s),
          child: Column(
            mainAxisSize: .min,
            spacing: Sizes.s,
            children: [
              Row(
                spacing: Sizes.s,
                children: [
                  BlocBuilder<EditCharacterBloc, EditCharacterState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          CharacterAvatar(
                            onTap: () async {
                              final image = await ImagePicker().pickImage(
                                source: .gallery,
                              );

                              if (image != null && context.mounted) {
                                context.read<EditCharacterBloc>().add(
                                  CharacterAvatarChanged(image.path),
                                );
                              }
                            },
                            avatarUri: state.avatarPath.isNotEmpty
                                ? .tryParse(state.avatarPath)
                                : null,
                            name: state.name.value,
                          ),

                          if (state.avatarPath.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => context
                                    .read<EditCharacterBloc>()
                                    .add(CharacterAvatarChanged('')),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: .circle,
                                    color: Colors.black54,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: Sizes.m,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  Expanded(
                    child: BlocBuilder<EditCharacterBloc, EditCharacterState>(
                      buildWhen: (previous, current) =>
                          previous.name != current.name,
                      builder: (context, state) {
                        return TextFormField(
                          initialValue: state.name.value,
                          textCapitalization: .words,
                          autovalidateMode: .onUserInteraction,
                          validator: (value) =>
                              state.name.validator(value ?? '').toString(),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          onChanged: (value) => context
                              .read<EditCharacterBloc>()
                              .add(CharacterNameChanged(value)),
                          decoration: .new(
                            hintText: 'Имя персонажа',
                            errorText: state.name.displayError,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              BlocBuilder<EditCharacterBloc, EditCharacterState>(
                builder: (context, state) {
                  return TextFormField(
                    initialValue: state.note,
                    textCapitalization: .sentences,
                    autovalidateMode: .onUserInteraction,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    onChanged: (value) => context.read<EditCharacterBloc>().add(
                      CharacterNoteChanged(value),
                    ),
                    decoration: const .new(
                      hintText: 'Дополнительное описание',
                      border: .none,
                      fillColor: containerColor,
                      filled: true,
                    ),
                    minLines: 3,
                    maxLines: null,
                  );
                },
              ),
            ],
          ),
        ),

        footer: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            FilledButton(onPressed: navigator.pop, child: Text('Отмена')),

            FilledButton(
              onPressed: () =>
                  context.read<EditCharacterBloc>().add(CharacterSubmitted()),
              style: const .new(
                backgroundColor: WidgetStatePropertyAll(successColor),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/features/chat/create/ui/bloc/bloc.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';
import 'package:riniel_chat/shared/ui/style.dart';

class CreateChatDialog extends StatefulWidget {
  const CreateChatDialog({super.key});

  @override
  State<CreateChatDialog> createState() => _CreateChatDialogState();
}

class _CreateChatDialogState extends State<CreateChatDialog>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final chatRepository = context.watch<ChatRepository>();
    final characterRepository = context.watch<CharacterRepository>();

    return BlocProvider<CreateChatBloc>(
      create: (context) => .new(
        chatRepository: chatRepository,
        characterRepository: characterRepository,
      )..add(CreateChatStarted()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateChatBloc, CreateChatState>(
            listenWhen: (previous, current) =>
                current.chatName.isDefault ||
                previous.chatName.isDefault != current.chatName.isDefault,
            listener: (context, state) =>
                _nameController.text = state.chatName.value,
          ),

          BlocListener<CreateChatBloc, CreateChatState>(
            listener: (context, state) {
              if (state.status == .failure && state.hasMessage) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(.new(content: Text(state.message)));
              }

              if (state.status == .success) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return RinielDialog(
              header: Text("Создание чата", style: theme.textTheme.titleMedium),
              body: Column(
                mainAxisSize: .min,
                spacing: Sizes.xs,
                children: [
                  Padding(
                    padding: const .symmetric(horizontal: Sizes.s),
                    child: TextField(
                      controller: _nameController,
                      onChanged: (value) {
                        context.read<CreateChatBloc>().add(
                          CreateChatNameChanged(value),
                        );
                      },
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: const .new(labelText: 'Название чата'),
                    ),
                  ),

                  const Flexible(child: _CreateChatCharacterList()),
                ],
              ),
              footer: Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Отмена'),
                      ),

                      BlocBuilder<CreateChatBloc, CreateChatState>(
                        builder: (context, state) {
                          return FilledButton(
                            onPressed: state.canSubmit
                                ? () => context.read<CreateChatBloc>().add(
                                    CreateChatSubmitted(),
                                  )
                                : null,
                            style: const .new(
                              backgroundColor: WidgetStatePropertyAll(
                                successColor,
                              ),
                            ),
                            child: const Text('Создать'),
                          );
                        },
                      ),
                    ],
                  ),

                  BlocBuilder<CreateChatBloc, CreateChatState>(
                    builder: (context, state) => Visibility(
                      visible: state.status == .failure,
                      child: Text(state.message),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CreateChatCharacterList extends StatelessWidget {
  const _CreateChatCharacterList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChatBloc, CreateChatState>(
      buildWhen: (previous, current) =>
          previous.selectedCharacter != current.selectedCharacter ||
          previous.characters != current.characters,
      builder: (context, state) {
        if (state.characters.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final characters = state.characters.requireValue;
        final selectedCharacter = state.selectedCharacter;

        return ListView.builder(
          shrinkWrap: characters.length < 10,
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters.elementAt(index);
            final isSelected = character.id == selectedCharacter?.id;

            return Material(
              type: .transparency,
              child: ListTile(
                onTap: () => context.read<CreateChatBloc>().add(
                  CreateChatCharacterSelected(characterId: character.id),
                ),
                selected: isSelected,
                selectedTileColor: Colors.black12,
                leading: CharacterAvatar(
                  avatarUri: character.avatarUri,
                  name: character.name,
                ),
                title: Text(character.name),
                trailing: isSelected ? const Icon(Icons.done) : null,
              ),
            );
          },
        );
      },
    );
  }
}

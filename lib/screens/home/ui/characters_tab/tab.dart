import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/avatar.dart';
import 'package:riniel_chat/entities/character/ui/info_dialog.dart';
import 'package:riniel_chat/features/character/list/bloc/bloc.dart';
import 'package:riniel_chat/screens/home/ui/characters_tab/edit_character/bloc/bloc.dart';
import 'package:riniel_chat/screens/home/ui/characters_tab/edit_character/edit_character_dialog.dart';
import 'package:riniel_chat/screens/home/ui/characters_tab/remove_character_dialog.dart';
import 'package:riniel_chat/shared/lib/snackbar.dart';
import 'package:riniel_chat/shared/state/async.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

part 'management_menu.dart';

class CharactersTab extends StatefulWidget {
  const CharactersTab({super.key, required this.bloc});

  final CharacterListBloc bloc;

  @override
  State<CharactersTab> createState() => _CharactersTabState();
}

class _CharactersTabState extends State<CharactersTab>
    with AutomaticKeepAliveClientMixin<CharactersTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<CharacterListBloc, CharactersListState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return BlocListener<CharacterListBloc, CharactersListState>(
          listener: (context, state) {
            if (state.characters case AsyncError(:var errorMessage)) {
              showSnackbarWithText(context, '$errorMessage');
            }
          },
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  if (state.characters.isReloading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state.characters.hasError) {
                    final message = state.characters.errorMessage;

                    return Center(child: Text(message.toString()));
                  }

                  final characters = state.characters.requireValue;

                  if (characters.isEmpty) {
                    return Center(child: Text('Список персонажей пуст'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        widget.bloc.add(CharacterListStarted()),
                    child: ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final character = characters.elementAt(index);

                        final Character(:name, :avatarUri, :note) = character;

                        final subtitle = note.isEmpty
                            ? null
                            : Text(note, overflow: .ellipsis, maxLines: 1);

                        return ListTile(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                CharacterInfoDialog(character: character),
                          ),
                          leading: CharacterAvatar(
                            avatarUri: avatarUri,
                            name: name,
                          ),
                          title: Text(name),
                          subtitle: subtitle,
                          trailing: CharacterManagementMenu(
                            character: character,
                            onEdited: (character) => widget.bloc.add(
                              CharacterListCharacterEdited(character),
                            ),
                            onRemoved: (character) => widget.bloc.add(
                              CharacterListCharacterRemoved(character.id),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              Positioned(
                bottom: Sizes.m,
                right: Sizes.m,
                child: Builder(
                  builder: (context) {
                    return FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () async {
                        final character = await showDialog(
                          context: context,
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                EditCharacterBloc(context.read()),
                            child: EditCharacterDialog(),
                          ),
                        );

                        if (character is Character) {
                          widget.bloc.add(
                            CharacterListCharacterEdited(character),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

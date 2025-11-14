import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riniel_chat/entities/character/model/character.dart';
import 'package:riniel_chat/entities/character/ui/list_tile.dart';
import 'package:riniel_chat/features/character/edit/ui/dialog.dart';
import 'package:riniel_chat/features/character/remove/ui/dialog.dart';
import 'package:riniel_chat/screens/home/ui/characters_tab/bloc/bloc.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

part 'management_menu.dart';

class CharactersTab extends StatefulWidget {
  const CharactersTab({super.key, required this.bloc});

  final CharactersTabBloc bloc;

  @override
  State<CharactersTab> createState() => _CharactersTabState();
}

class _CharactersTabState extends State<CharactersTab>
    with AutomaticKeepAliveClientMixin<CharactersTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<CharactersTabBloc, CharactersTabState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Stack(
          children: [
            Builder(
              builder: (context) {
                if (state case CharactersTabRefreshing()) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state case CharactersTabFailure()) {
                  final message = state.message;

                  return Center(child: Text(message.toString()));
                }

                final characters = state.list;

                if (characters.isEmpty) {
                  return Center(child: Text('Список персонажей пуст'));
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      widget.bloc.add(CharactersTabStarted()),
                  child: ListView.separated(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters.elementAt(index);

                      return Material(
                        child: CharacterListTile(
                          character: character,
                          trailing: CharacterManagementMenu(
                            character: character,
                            onEdited: (character) => widget.bloc.add(
                              CharactersTabCharacterEdited(character),
                            ),
                            onRemoved: (character) => widget.bloc.add(
                              CharactersTabCharacterRemoved(character.id),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Sizes.xs),
                  ),
                );
              },
            ),

            Positioned(
              bottom: Sizes.m,
              right: Sizes.m,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  final character = await showDialog(
                    context: context,
                    builder: (context) => EditCharacterDialog(),
                  );

                  if (character is Character) {
                    widget.bloc.add(CharactersTabCharacterEdited(character));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

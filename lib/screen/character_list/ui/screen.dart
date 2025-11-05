import 'package:flutter/material.dart';
import 'package:riniel_chat/domain/character/model/character.dart';
import 'package:riniel_chat/domain/character/ui/repository_provider.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = CharacterRepositoryProvider.of(context);

    return StreamBuilder(
      stream: repo.watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final error = snapshot.error;

          return Center(child: Text(error.toString()));
        }

        final data = snapshot.requireData;

        return Material(
          child: ListView.separated(
            itemCount: data.length,

            separatorBuilder: (context, index) => SizedBox(height: Sizes.s),
            itemBuilder: (context, index) {
              final Character(:id, :avatar, :name, :note) = data.elementAt(
                index,
              );

              final leading = avatar == null ? null : Image.file(avatar);
              final subtitle = note.isEmpty ? null : Text(note);

              return ListTile(
                tileColor: Color(0x07070707),
                onLongPress: () => repo.remove(id),
                leading: leading,
                title: Text(name),
                subtitle: subtitle,
              );
            },
          ),
        );
      },
    );
  }
}

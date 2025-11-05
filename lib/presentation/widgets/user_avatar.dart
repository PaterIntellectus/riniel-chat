import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:riniel_chat/domain/character/model/character.dart';

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({super.key, required this.character, this.onTap});

  final Character character;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,

      child: ClipOval(
        child: character.avatar == null
            ? SizedBox(
                width: 40,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(
                      (math.Random().nextDouble() * 0xFFFFFF).toInt(),
                    ).withValues(alpha: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      character.name[0].toUpperCase(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
              )
            : Image.file(
                character.avatar!,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
      ),
    );
  }
}

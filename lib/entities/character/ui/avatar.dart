import 'package:flutter/material.dart';

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    super.key,
    required this.avatarUri,
    required this.name,
    this.size = 40,
    this.onTap,
    this.onLongPress,
  });

  final Uri? avatarUri;
  final String name;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameInitialLetter = name.isEmpty ? '@' : name[0].toUpperCase();

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.green,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Text(
                      nameInitialLetter,
                      textAlign: .center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                if (avatarUri != null)
                  Image.file(
                    .fromUri(avatarUri!),
                    fit: .cover,
                    width: size,
                    height: size,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

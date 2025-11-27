import 'package:flutter/material.dart';
import 'package:riniel_chat/shared/ui/style.dart';

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
  final String? name;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: successColor,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                if (name != null && name!.isNotEmpty)
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        name![0].toUpperCase(),
                        textAlign: .center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (avatarUri != null)
                  Positioned.fill(
                    child: Image.file(
                      .fromUri(avatarUri!),
                      fit: .cover,
                      width: size,
                      height: size,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

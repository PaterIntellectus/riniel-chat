import 'package:flutter/material.dart';
import 'package:riniel_chat/entities/message/model/message.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.radius = const Radius.circular(16),
    required this.textDirection,
    this.onLongPress,
  });

  final Message message;
  final Radius radius;
  final TextDirection textDirection;
  final void Function(Message message)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final maxWidth = mediaQuery.size.width / 1.5;

    final borderRadius = BorderRadius.only(
      bottomLeft: textDirection == .rtl ? radius : .zero,
      bottomRight: textDirection == .rtl ? .zero : radius,
      topLeft: radius,
      topRight: radius,
    );

    final bubble = Row(
      crossAxisAlignment: .end,
      mainAxisSize: .min,
      textDirection: textDirection,
      children: [
        CustomPaint(
          painter: _MessageBubbleTailPainter(
            color: textDirection == .rtl
                ? theme.colorScheme.primary
                : Colors.grey[800]!,
            textDirection: textDirection,
          ),
          size: const Size(10, 10),
        ),

        Container(
          padding: const .symmetric(horizontal: Sizes.m, vertical: Sizes.s),
          constraints: BoxConstraints(minWidth: 0, maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: textDirection == .rtl
                ? theme.colorScheme.primary
                : Colors.grey[800],
            borderRadius: borderRadius,
          ),
          child: Flex(
            crossAxisAlignment: .end,
            mainAxisSize: .min,
            direction: .horizontal,
            spacing: Sizes.xs,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (message.attachmentUri != null)
                      Padding(
                        padding: .only(
                          top: Sizes.s,
                          bottom: message.text.isEmpty ? Sizes.s : Sizes.xs,
                        ),
                        child: Image.file(.fromUri(message.attachmentUri!)),
                      ),

                    if (message.text.isNotEmpty)
                      Text(
                        message.text,
                        textWidthBasis: .longestLine,
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                      ),
                  ],
                ),
              ),

              Text(
                "${message.createdAt.hour.toString().padLeft(2, '0')}:"
                "${message.createdAt.minute.toString().padLeft(2, '0')}",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (onLongPress != null) {
      return GestureDetector(
        onLongPress: () => onLongPress!(message),
        child: bubble,
      );
    }

    return bubble;
  }
}

class _MessageBubbleTailPainter extends CustomPainter {
  const _MessageBubbleTailPainter({
    required this.color,
    required this.textDirection,
  });

  final Color color;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.strokeWidth = 2;

    final path = Path();
    if (textDirection == .rtl) {
      path.moveTo(0, 0);
      path.conicTo(
        size.width * 0.1,
        size.height * 0.8,
        size.width,
        size.height,
        1,
      );
      path.lineTo(0, size.height);
    } else if (textDirection == .ltr) {
      path.moveTo(size.width, 0);
      path.conicTo(size.width * 0.7, size.height * 0.7, 0, size.height, 1);
      path.lineTo(size.width, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

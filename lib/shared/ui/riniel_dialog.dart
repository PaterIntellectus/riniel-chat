import 'package:flutter/material.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/style.dart';

class RinielDialogHeader extends StatelessWidget {
  const RinielDialogHeader({
    super.key,
    required this.child,
    this.color = containerColor,
    this.padding = const .symmetric(
      horizontal: Sizes.s,
      vertical: Sizes.s * 0.75,
    ),
  });

  final EdgeInsets padding;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: .symmetric(
        horizontal: padding.horizontal,
        vertical: padding.vertical,
      ),
      color: color,
      child: child,
    );
  }
}

class RinielDialog extends StatelessWidget {
  const RinielDialog({super.key, this.header, this.body, this.footer});

  final Widget? header;
  final Widget? body;
  final Widget? footer;

  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: Sizes.s * 1.25,
    vertical: Sizes.s,
  );

  @override
  Widget build(BuildContext context) {
    final hasHeader = header != null;
    final hasFooter = footer != null;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          if (hasHeader) RinielDialogHeader(child: header!),

          if (body != null) Flexible(child: SingleChildScrollView(child: body)),

          if (hasFooter) AppDialogFooter(child: footer),
        ],
      ),
    );
  }
}

class AppDialogFooter extends StatelessWidget {
  const AppDialogFooter({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: Sizes.s, vertical: Sizes.s * 0.75),
      child: child!,
    );
  }
}

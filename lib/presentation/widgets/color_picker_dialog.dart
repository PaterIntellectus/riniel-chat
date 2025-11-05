import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:riniel_chat/shared/ui/constants.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.color,
    required this.onColorChanged,
    required this.activeThemeMode,
    required this.onThemeModeChanged,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final ThemeMode activeThemeMode;
  final ValueChanged<ThemeMode?> onThemeModeChanged;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.m),
          child: Column(
            children: [
              ColorPicker(
                padding: EdgeInsets.zero,
                onColorChanged: (value) {},
                onColorChangeEnd: (value) => widget.onColorChanged(value),
                color: widget.color,
                pickersEnabled: {ColorPickerType.wheel: true},
                showColorCode: true,
                colorCodeHasColor: true,
                actionButtons: ColorPickerActionButtons(
                  closeButton: true,
                  dialogActionButtons: true,
                  dialogActionIcons: true,
                  dialogActionOnlyOkButton: true,
                ),
              ),

              Row(
                children: [
                  ...ThemeMode.values.map(
                    (tm) => Column(
                      children: [
                        Radio(value: tm),

                        Text(tm.name.capitalize),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

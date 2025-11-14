import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:riniel_chat/entities/chat/model/chat.dart';
import 'package:riniel_chat/shared/ui/constants.dart';
import 'package:riniel_chat/shared/ui/riniel_dialog.dart';

typedef ChatSettingsDialogTab = ({String lable, Widget child});

class ChatSettingsDialog extends StatefulWidget {
  const ChatSettingsDialog({super.key, this.chat});

  final Chat? chat;
  // TODO: нужно передавать сюда onSubmit

  @override
  State<ChatSettingsDialog> createState() => _ChatSettingsDialogState();
}

class _ChatSettingsDialogState extends State<ChatSettingsDialog>
    with TickerProviderStateMixin {
  late final _tabController = TabController(length: _tabs.length, vsync: this);
  late final _colorController = ValueNotifier(
    widget.chat?.color ?? Colors.purple,
  );

  late final _tabs = <ChatSettingsDialogTab>[
    (
      lable: 'Персонаж',
      child: ListView.builder(itemBuilder: (context, index) => ListTile()),
    ),
    (
      lable: 'Тема',
      child: Padding(
        padding: const .symmetric(horizontal: Sizes.s),
        child: ColorPicker(
          padding: .zero,
          onColorChanged: (value) {
            _colorController.value = value;
          },
          onColorChangeEnd: (value) => _colorController.value = value,
          color: _colorController.value,
          pickersEnabled: {.wheel: true},
          showColorCode: true,
          colorCodeHasColor: true,
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RinielDialog(
      header: Text("Создание чата", style: theme.textTheme.titleMedium),
      body: SingleChildScrollView(
        child: Column(
          spacing: Sizes.s,
          children: [
            TabBar(
              tabs: _tabs
                  .map(
                    (tab) => Padding(
                      padding: .symmetric(vertical: Sizes.s),
                      child: Text(tab.lable),
                    ),
                  )
                  .toList(),
              controller: _tabController,
            ),

            ListenableBuilder(
              listenable: _tabController,
              builder: (context, child) =>
                  _tabs.elementAt(_tabController.index).child,
            ),
          ],
        ),
      ),
    );
  }
}

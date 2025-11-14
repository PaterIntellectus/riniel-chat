part of 'tab.dart';

class CharacterManagementMenu extends StatefulWidget {
  const CharacterManagementMenu({
    super.key,
    required this.character,
    this.onEdited,
    this.onRemoved,
  });

  final Character character;
  final void Function(Character character)? onEdited;
  final void Function(Character character)? onRemoved;

  @override
  State<CharacterManagementMenu> createState() =>
      _CharacterManagementMenuState();
}

class _CharacterManagementMenuState extends State<CharacterManagementMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _controller,
      menuChildren: [
        if (widget.onEdited != null)
          MenuItemButton(
            trailingIcon: Icon(Icons.edit_outlined),
            child: Text('Редактировать'),
            onPressed: () async {
              final updated = await showDialog(
                context: context,
                builder: (context) =>
                    EditCharacterDialog(character: widget.character),
              );

              if (updated is Character) {
                widget.onEdited?.call(updated);
              }
            },
          ),

        if (widget.onRemoved != null)
          MenuItemButton(
            trailingIcon: Icon(Icons.delete),
            child: Text('Удалить'),
            onPressed: () async {
              final confirmed = await showDialog(
                context: context,
                builder: (context) => RemoveCharacterDialog(),
              );

              if (confirmed == true) {
                widget.onRemoved?.call(widget.character);
              }
            },
          ),
      ],
      child: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          if (_controller.isOpen) {
            _controller.close();
          } else {
            _controller.open();
          }
        },
      ),
    );
  }
}

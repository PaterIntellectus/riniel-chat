import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Chat list screen'));
  }
}

// import 'package:flutter/material.dart';
// import 'package:riniel_chat/domain/character/model/character.dart';
// import 'package:riniel_chat/presentation/widgets/create_character_dialog.dart';

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key, required this.characterRepo});

//   final CharacterRepository characterRepo;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           GestureDetector(
//             child: CircleAvatar(child: Icon(Icons.account_circle_outlined)),
//             onTap: () => print(
//               'Показать список персонажей для выбора действующего лица',
//             ),
//           ),
//         ],
//       ), // CharacterAvatar(character: user) Icon(Icons.abc_rounded)]),
//       floatingActionButton: FloatingActionButton.small(
//         child: Icon(Icons.add),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) => Dialog(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//               child: CharacterEditorDialog(onSaved: (c) => print('qwer:c: $c')),
//             ),
//           );
//         },
//       ),
//       body: FutureBuilder<List<Character>>(
//         future: Future.sync(() => characterRepo.list()),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("Список чатов пуст"));
//           }

//           return ListView.builder(
//             itemBuilder: (context, index) => Text('item'),
//           );
//         },
//       ),
//     );
//   }
// }

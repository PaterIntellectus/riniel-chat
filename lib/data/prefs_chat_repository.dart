// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:riniel_chat/domain/chat/model/chat.dart';
// import 'package:riniel_chat/shared/message.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// extension _MessageMapper on Message {
//   static Message fromPrefs(Map<String, dynamic> json) => Message.persisted(
//     id: json['id'],
//     chatId: json['chat_id'],
//     authorId: json['author_id'],
//     text: json['text'],
//     attachment: File(json['attachment_path']),
//     createdAt: DateTime.parse(json['created_at']),
//     updatedAt: DateTime.parse(json['updated_at']),
//     deletedAt: json['deleted_at'] is String
//         ? DateTime.parse(json['deleted_at'])
//         : null,
//   );

//   Map<String, dynamic> toPrefs() => {
//     'id': id,
//     'chat_id': chatId,
//     'author_id': authorId,
//     'text': text,
//     if (attachment != null) 'attachment_path': attachment!.path,
//     'created_at': createdAt.toIso8601String(),
//     'updated_at': updatedAt.toIso8601String(),
//     'deleted_at': deletedAt!.toIso8601String(),
//   };
// }

// extension _ChatDto on Chat {
//   static Chat fromPrefs(Map<String, dynamic> json) => Chat(
//     id: json['id'],
//     participants: json['participants'],
//     messages:
//         (json['messages'] as List?)
//             ?.map((m) => _MessageMapper.fromPrefs(m))
//             .toList() ??
//         const [],
//     backgroundImage: json['backgroun_image_path'] == null
//         ? null
//         : File.fromUri(Uri.parse(json['background_image_path'])),
//     themeColor: json['theme_color'],
//     createdAt: DateTime.parse(json['created_at']),
//     updatedAt: DateTime.parse(json['updated_at']),
//     deletedAt: json['deleted_at'] == null
//         ? null
//         : DateTime.parse(json['deleted_at']),
//   );

//   Map<String, dynamic> toPrefs() => {
//     'id': id,
//     'participants': participants,
//     'messages': messages.map((m) => m.toPrefs()).toList(),
//     'background_image_path': backgroundImage?.path,
//     'theme_color_code': themeColor.toARGB32(),
//     'created_at': createdAt.toIso8601String(),
//     'updated_at': updatedAt.toIso8601String(),
//     'deleted_at': deletedAt?.toIso8601String(),
//   };
// }

// class ChatPrefsRepository implements ChatRepository {
//   const ChatPrefsRepository(this._prefs);

//   final SharedPreferences _prefs;
//   static const _key = '_chat';

//   @override
//   List<Chat> list() {
//     return _prefs
//             .getStringList(_key)
//             ?.map((message) => _ChatDto.fromPrefs(jsonDecode(message)))
//             .toList() ??
//         [];
//   }

//   @override
//   Chat find(ChatId id) => list().singleWhere(
//     (ch) => ch.id == id,
//     orElse: () => throw "Чат не найден",
//   );

//   @override
//   FutureOr<void> save(Chat chat) async {
//     final chats = list();

//     final index = chats.indexWhere((ch) => ch.id == chat.id);

//     if (index != -1) {
//       chats[index] = chat;
//     } else {
//       chats.add(chat);
//     }

//     await _set(chats);
//   }

//   @override
//   FutureOr<void> remove(MessageId id) async {
//     final chats = list();
//     final index = chats.indexWhere((ch) => ch.id == id);

//     if (index != -1) {
//       chats.removeAt(index);

//       await _set(chats);
//     }
//   }

//   Future<void> _set(List<Chat> chats) async {
//     await _prefs.setStringList(
//       _key,
//       chats.map((chat) => jsonEncode(chat.toPrefs())).toList(),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:riniel_chat/domain/character.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension _Character on Character {
  static Character fromPrefs(Map<String, dynamic> json) => Character(
    id: json['id'],
    name: json['name'],
    avatar: File(json['avatar_path']),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    deletedAt: DateTime.parse(json['deleted_at']),
  );

  Map<String, dynamic> toPrefs() => {
    'id': id,
    'name': name,
    if (avatar != null) 'avatar': avatar!.path,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };
}

class CharacterPrefsRepository implements CharacterRepository {
  const CharacterPrefsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = "_characters";

  @override
  List<Character> list() =>
      _prefs
          .getStringList(_key)
          ?.map((c) => _Character.fromPrefs(jsonDecode(c)))
          .toList() ??
      [];

  @override
  Character find(CharacterId id) {
    return _prefs
        .getStringList(_key)!
        .map((c) => _Character.fromPrefs(jsonDecode(c)))
        .singleWhere(
          (c) => c.id == id,
          orElse: () => throw 'Персонаж не найден',
        );
  }

  @override
  FutureOr<void> save(Character character) async {
    final characters = list();
    final index = characters.indexWhere((c) => c.id == character.id);

    if (index != -1) {
      characters[index] = character;
    } else {
      characters.add(character);
    }

    await _prefs.setStringList(
      _key,
      characters.map((c) => jsonEncode(c.toPrefs())).toList(),
    );
  }

  @override
  Future<void> remove(CharacterId id) async {
    final characters = list();
    final index = characters.indexWhere((c) => c.id == id);

    if (index != -1) {
      characters.removeAt(index);

      await _prefs.setStringList(
        _key,
        characters.map((c) => jsonEncode(c.toPrefs())).toList(),
      );
    }
  }
}

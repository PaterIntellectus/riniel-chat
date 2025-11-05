import 'dart:async';

import 'package:rxdart/subjects.dart';

class InMemoryStorage<K, V> {
  InMemoryStorage([Map<K, V>? initial])
    : _data = initial ?? {},
      subject = initial == null
          ? BehaviorSubject()
          : BehaviorSubject.seeded(initial.values.toList());

  BehaviorSubject<Iterable<V>> subject;

  Stream<Iterable<V>> watch() => subject.asBroadcastStream();

  V? find(K key) => _data[key];

  List<V> list({int offset = 0, int? limit, bool Function(V value)? filter}) {
    var values = _data.values;

    if (filter != null) {
      values = values.where(filter);
    }

    final total = values.length;

    if (total < offset) {
      return const [];
    }

    if (offset > 0) {
      values = values.skip(offset);
    }

    if (limit != null && limit >= 0) {
      values = values.take(limit);
    }

    return values.toList();
  }

  void save(K key, V value) {
    _data[key] = value;

    subject.add(_data.values);
  }

  void saveMany(K Function(V value) key, Iterable<V> values) {
    for (final value in values) {
      _data[key(value)] = value;
    }

    subject.add(_data.values);
  }

  void remove(K key) {
    _data.remove(key);

    subject.add(_data.values);
  }

  final Map<K, V> _data;

  int get total => _data.length;
}

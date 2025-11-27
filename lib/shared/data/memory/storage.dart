import 'dart:async';
import 'dart:collection';

import 'package:rxdart/subjects.dart';

typedef InMemoryStorageFilter<V> = bool Function(V value);

class InMemoryStorage<K, V> {
  InMemoryStorage({required this.indexator, Map<K, V> initial = const {}})
    : _subject = .seeded(UnmodifiableMapView(initial));

  Stream<Iterable<V>> watch({bool Function(V value)? filter}) {
    return _subject
        .map((data) => filter != null ? data.values.where(filter) : data.values)
        .asBroadcastStream();
  }

  List<V> list({int offset = 0, int? limit, InMemoryStorageFilter<V>? filter}) {
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

  V? find(K key) => _data[key];

  void save(V value) {
    final data = _data;

    data[indexator(value)] = value;

    _subject.add(UnmodifiableMapView(data));
  }

  void saveMany(Iterable<V> values) {
    final data = _data;

    for (final value in values) {
      data[indexator(value)] = value;
    }

    _subject.add(UnmodifiableMapView(data));
  }

  void remove(K key) {
    final data = _data;

    data.remove(key);

    _subject.add(UnmodifiableMapView(data));
  }

  final BehaviorSubject<UnmodifiableMapView<K, V>> _subject;
  final K Function(V value) indexator;

  Map<K, V> get _data => {...?_subject.valueOrNull};

  int get total => _subject.value.length;
}

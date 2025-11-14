import 'dart:async';
import 'dart:collection';

import 'package:rxdart/subjects.dart';

class InMemoryStorage<K, V> {
  InMemoryStorage({required this.indexator, Map<K, V> initial = const {}})
    : _subject = .seeded(UnmodifiableMapView(initial));

  Stream<Iterable<V>> watch({bool Function(V value)? filter}) {
    return _subject
        .map((data) => filter != null ? data.values.where(filter) : data.values)
        .asBroadcastStream();
  }

  List<V> list({int offset = 0, int? limit, bool Function(V value)? filter}) {
    var values = _modifiableData.values;

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

  V? find(K key) => _modifiableData[key];

  void save(V value) {
    final data = _modifiableData;

    data[indexator(value)] = value;

    _subject.add(UnmodifiableMapView(data));
  }

  void saveMany(Iterable<V> values) {
    final data = _modifiableData;

    for (final value in values) {
      data[indexator(value)] = value;
    }

    _subject.add(UnmodifiableMapView(data));
  }

  void remove(K key) {
    final data = _modifiableData;

    data.remove(key);

    _subject.add(UnmodifiableMapView(data));
  }

  final BehaviorSubject<UnmodifiableMapView<K, V>> _subject;
  final K Function(V value) indexator;

  Map<K, V> get _modifiableData => {...?_subject.valueOrNull};

  int get total => _subject.value.length;
}

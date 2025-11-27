import 'package:equatable/equatable.dart';

typedef _Loading = ({num? progress});
typedef Error = ({Object? error, StackTrace stackTrace});

sealed class AsyncValue<T> with EquatableMixin {
  const AsyncValue({T? value}) : _value = value, _error = null, _loading = null;

  const AsyncValue._raw({
    required T? value,
    required Error? error,
    required _Loading? loading,
  }) : _value = value,
       _error = error,
       _loading = loading;

  const factory AsyncValue.data(final T value) = AsyncData;

  const factory AsyncValue.error({
    final T? value,
    final Object? error,
    required final StackTrace stackTrace,
  }) = AsyncError;

  const factory AsyncValue.loading({final T? value, final num? progress}) =
      AsyncLoading;

  // эти методы кажутся сомнительными
  // AsyncValue<T> toData(final T value) => .data(value);

  // AsyncValue<T> toError({
  //   final T? value,
  //   final Object? error,
  //   required final StackTrace stackTrace,
  // }) => .error(value: value ?? _value, error: error, stackTrace: stackTrace);

  // AsyncValue<T> toLoading({final T? value, final num? progress}) =>
  //     .loading(value: value ?? _value, progress: progress);

  AsyncValue<C> castValue<C>(C? Function(T? value) caster) => switch (this) {
    AsyncData(:final value) => .data(caster(value) as C),
    AsyncError() => .error(
      value: caster(value),
      error: _error?.error,
      stackTrace: _error?.stackTrace ?? StackTrace.current,
    ),
    AsyncLoading(:final _loading) => .loading(
      value: caster(value),
      progress: _loading.progress,
    ),
  };

  static Future<AsyncValue<T>> guard<T>(Future<T> Function() future) async {
    try {
      return .data(await future());
    } catch (error, stackTrace) {
      return .error(error: error, stackTrace: stackTrace);
    }
  }

  final T? _value;
  final Error? _error;
  final _Loading? _loading;

  @override
  List<Object?> get props => [_value, _error, _loading];

  bool get hasValue => _value != null;
  T? get value => _value;
  T get requireValue => value!;

  bool get isLoading => _loading != null;
  bool get isRefreshing => isLoading && value != null;
  bool get isReloading => isLoading && value == null;

  bool get hasError => _error?.error != null;
  String? get errorMessage => _error?.error.toString();
}

final class AsyncData<T> extends AsyncValue<T> {
  const AsyncData(final T value)
    : super._raw(value: value, error: null, loading: null);

  @override
  T get value => super.value!;
}

final class AsyncError<T> extends AsyncValue<T> {
  const AsyncError({
    super.value,
    final Object? error,
    required final StackTrace stackTrace,
  }) : super._raw(loading: null, error: (error: error, stackTrace: stackTrace));

  @override
  Error get _error => super._error!;

  @override
  bool get hasError => true;
}

final class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading({super.value, final num? progress})
    : super._raw(loading: (progress: progress), error: null);

  @override
  _Loading get _loading => (progress: super._loading?.progress);

  @override
  bool get isLoading => true;
}

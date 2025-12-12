import 'package:equatable/equatable.dart';

typedef _Loading = ({num? progress});
typedef Error = ({Object? error, StackTrace stackTrace});

sealed class AsyncState<T> with EquatableMixin {
  const AsyncState._({
    required T? value,
    required Error? error,
    required _Loading? loading,
  }) : _value = value,
       _error = error,
       _loading = loading;

  const factory AsyncState.data(final T value) = AsyncData;

  const factory AsyncState.error({
    final T? value,
    final Object? error,
    required final StackTrace stackTrace,
  }) = AsyncError;

  const factory AsyncState.loading({final T? value, final num? progress}) =
      AsyncLoading;

  AsyncState<T> cast(AsyncState<T> Function(AsyncState<T> state) caster) =>
      caster(this);

  AsyncState<C> castValue<C>(C? Function(T? value) caster) => switch (this) {
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

  static Future<AsyncState<T>> guard<T>(Future<T> Function() future) async {
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

  T? get value => _value;
  T get requireValue => value!;
  bool get hasValue => _value != null;

  bool get isLoading => _loading != null;
  bool get isRefreshing => isLoading && value != null;
  bool get isReloading => isLoading && value == null;

  bool get hasError => _error?.error != null;
  String? get errorMessage => _error?.error.toString();
}

final class AsyncData<T> extends AsyncState<T> {
  const AsyncData(final T value)
    : super._(value: value, error: null, loading: null);

  @override
  T get value => super.value!;
}

final class AsyncError<T> extends AsyncState<T> {
  const AsyncError({
    super.value,
    final Object? error,
    required final StackTrace stackTrace,
  }) : super._(loading: null, error: (error: error, stackTrace: stackTrace));

  @override
  Error get _error => super._error!;

  @override
  String get errorMessage => _error.error.toString();

  @override
  bool get hasError => true;
}

final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading({super.value, final num? progress})
    : super._(loading: (progress: progress), error: null);

  @override
  _Loading get _loading => (progress: super._loading?.progress);

  @override
  bool get isLoading => true;
}

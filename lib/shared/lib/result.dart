import 'package:equatable/equatable.dart';

sealed class Result<T> with EquatableMixin {
  const Result([this._value]);

  const factory Result.failure(
    Object? error, {
    required StackTrace stackTrace,
    T? value,
  }) = Failure;

  const factory Result.success(T value) = Success;

  factory Result.guard(
    Result<T> Function() callback, {
    Result<T> Function(Object error, StackTrace stackTrace)? onError,
    E Function<E>(Object error)? errorTransformer,
  }) {
    try {
      return callback();
    } catch (error, stackTrace) {
      return onError?.call(
            errorTransformer?.call(error) ?? error,
            stackTrace,
          ) ??
          .failure(
            errorTransformer?.call(error) ?? error,
            stackTrace: stackTrace,
          );
    }
  }

  Failure<T> toFailure(Object? error, [StackTrace? stackTrace]) =>
      .new(error, value: value, stackTrace: StackTrace.current);

  Success<T> toSuccess(T value) => .new(value);

  final T? _value;

  @override
  List<Object?> get props => [_value];

  T? get value => _value;
}

class Failure<T> extends Result<T> {
  const Failure(this.error, {required this.stackTrace, T? value})
    : super(value);

  final Object? error;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [...super.props, error, stackTrace];
}

class Success<T> extends Result<T> {
  const Success(super.value);

  @override
  T get value => super.value!;
}

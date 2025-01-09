import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.freezed.dart';

@Freezed(
  equal: true,
)
abstract class PaymentState<T> with _$PaymentState<T> {
  const factory PaymentState.initial() = _Initial<T>;

  const factory PaymentState.loading() = _Loading<T>;

  const factory PaymentState.error({Failed? message}) = _Error<T>;

  const factory PaymentState.successful({T? data}) = _Loaded<T>;
}

// ignore: strict_raw_type
extension PaymentStateX on PaymentState {
  bool get isLoading => this is _Loading;
  bool get hasError => this is _Error;
  Failed? get error => maybeWhen(
        error: (message) => message,
        orElse: () => null,
      );
}

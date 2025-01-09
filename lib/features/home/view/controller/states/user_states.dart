import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_states.freezed.dart';

@Freezed(
  equal: true,
)
abstract class UserProfileState with _$UserProfileState {
  const factory UserProfileState.initial() = _Initial;

  const factory UserProfileState.loading() = _Loading;

  const factory UserProfileState.error({Failed? message}) = _Error;

  const factory UserProfileState.loaded({required Student response}) = _Loaded;
}

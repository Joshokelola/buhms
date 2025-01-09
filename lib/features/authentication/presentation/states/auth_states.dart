import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_states.freezed.dart';

@Freezed(
  equal: true,
)
abstract class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = _Initial;

  const factory AuthenticationState.loading() = _Loading;

  const factory AuthenticationState.unauthenticated({Failed? message}) =
      _UnAuthentication;

  const factory AuthenticationState.authenticated({
    required AuthResponse response,
  }) = _Authenticated;
}

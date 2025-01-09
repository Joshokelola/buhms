import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_room_states.freezed.dart';

@Freezed(
  equal: true,
)
abstract class BookRoomState<T> with _$BookRoomState<T> {
  const factory BookRoomState.initial() = _Initial<T>;

  const factory BookRoomState.loading() = _Loading<T>;

  const factory BookRoomState.error({Failed? message}) = _Error<T>;

  const factory BookRoomState.successful({T? data}) = _Loaded<T>;
}

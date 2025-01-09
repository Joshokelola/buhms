import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/rooms/domain/hostel.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_hostel_state.freezed.dart';

@Freezed(
  equal: true,
)
abstract class BookHostelState<T> with _$BookHostelState<T> {
  const factory BookHostelState.initial() = _Initial<T>;

  const factory BookHostelState.loading() = _Loading<T>;

  const factory BookHostelState.error({Failed? message}) = _Error<T>;

  const factory BookHostelState.successful({T? data}) = _Loaded<T>;
}

// Create type-specific states using typedef
typedef RoomBookingState = BookHostelState<List<RoomInfo>>;
typedef HostelBookingState = BookHostelState<List<Hostel>>;

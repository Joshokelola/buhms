import 'package:buhms/features/admin/domain/admin_dashboard_state.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_state.freezed.dart';

@Freezed(
  equal: true,
)
abstract class AdminState with _$AdminState {
  const factory AdminState.initial() = _Initial;

  const factory AdminState.loading() = _Loading;

  const factory AdminState.error({Failed? message}) = _Error;

  const factory AdminState.successful({AdminDashboardState? data}) = _Loaded;
}
// Create type-specific states using typedef
// typedef RoomBookingState = AdminState<List<RoomInfo>>;
// typedef HostelBookingState = AdminState<List<Hostel>>;

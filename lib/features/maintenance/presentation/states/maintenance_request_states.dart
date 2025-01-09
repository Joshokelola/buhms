import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/maintenance/domain/maintenance.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_request_states.freezed.dart';

@Freezed(
  equal: true,
)
abstract class MaintenanceRequestState with _$MaintenanceRequestState {
  const factory MaintenanceRequestState.initial() = _Initial;

  const factory MaintenanceRequestState.loading() = _Loading;

  const factory MaintenanceRequestState.failed({Failed? message}) = _Failed;

  const factory MaintenanceRequestState.successful({
    required List<MaintenanceRequest> response,
  }) = _Successful;
}

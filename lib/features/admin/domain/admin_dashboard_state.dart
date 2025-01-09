import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/maintenance/domain/maintenance.dart';

class AdminDashboardState {
  AdminDashboardState({
    this.error,
    this.roomCount = 0,
    this.maintenanceRequests = const [],
    this.students = const [],
  });

  final String? error;
  final int roomCount;
  final List<MaintenanceRequest> maintenanceRequests;
  final List<Student> students;

  AdminDashboardState copyWith({
    String? error,
    int? roomCount,
    List<MaintenanceRequest>? maintenanceRequests,
    List<Student>? students,
  }) {
    return AdminDashboardState(
      error: error ?? this.error,
      roomCount: roomCount ?? this.roomCount,
      maintenanceRequests: maintenanceRequests ?? this.maintenanceRequests,
      students: students ?? this.students,
    );
  }
}

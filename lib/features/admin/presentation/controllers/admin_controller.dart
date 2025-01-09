// ignore_for_file: strict_raw_type

import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/admin/data/admin_repo.dart';
import 'package:buhms/features/admin/domain/admin_dashboard_state.dart';
import 'package:buhms/features/admin/presentation/states/admin_state.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/home/data/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminNotifier extends Notifier<AdminState> {
  late AdminRepoImpl _adminRepoImpl;
  late UserRepoImpl userRepoImpl;
  @override
  AdminState build() {
    _adminRepoImpl = ref.read(adminRepoProvider);
    userRepoImpl = ref.read(userRepoImplProvider);
    return const AdminState.initial();
  }

  Future<void> loadAdminDashboardData() async {
    state = const AdminState.loading();
    final getStudents = await _adminRepoImpl.getStudents();
    final students = getStudents.getOrElse(() => []);
    final getAmountOfRooms = await _adminRepoImpl.getNumberOfRooms();
    final amountOfRooms = getAmountOfRooms.getOrElse(() => 0);
    final getMaintenanceRequests =
        await _adminRepoImpl.getMaintenanceRequests();
    final maintenanceRequests = getMaintenanceRequests.getOrElse(() => []);
    state = AdminState.successful(
      data: AdminDashboardState(
        roomCount: amountOfRooms,
        maintenanceRequests: maintenanceRequests,
        students: students,
      ),
    );
  }

  Future<void> updateMaintenanceRequest(
    String maintenanceId,
    String status,
    String resolutionNotes,
  ) async {
    final assigneeId =
        ref.read(supabaseClientProvider).auth.currentSession?.user.id;
    await _adminRepoImpl.updateMaintenanceRequest(
      maintenanceId,
      status,
      assigneeId!,
      resolutionNotes,
    );
  }

  Future<String> getRoomNumber(String roomId) async {
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase.from('rooms').select().eq('id', roomId);
    final roomNumber = res[0]['room_number'] as String;
    return roomNumber;
  }

  Future<String> getStudentName(String userId) async {
    final res = await userRepoImpl.getStudentProfile(userId: userId);
    final student = res.getOrElse(Student.defaultStudent);
    final fullName = '${student.lastName} ${student.firstName}';
    return fullName;
  }
}

final adminNotifierProvider =
    NotifierProvider<AdminNotifier, AdminState>(AdminNotifier.new);

final getRoomNumberProvider =
    FutureProvider.family<String, String>((ref, roomId) async {
  return ref.read(adminNotifierProvider.notifier).getRoomNumber(roomId);
});

final getStudentNameProvider =
    FutureProvider.family<String, String>((ref, userId) async {
  return ref.read(adminNotifierProvider.notifier).getStudentName(userId);
});

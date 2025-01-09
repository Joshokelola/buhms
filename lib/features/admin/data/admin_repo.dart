import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/maintenance/domain/maintenance.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AdminRepo {
  Future<Either<Failed, int>> getNumberOfRooms();
  Future<Either<Failed, List<MaintenanceRequest>>> getMaintenanceRequests();
  Future<Either<Failed, List<Student>>> getStudents();
  Future<Either<Failed, MaintenanceRequest>> updateMaintenanceRequest(
    String maintenanceId,
    String status,
    String assigneeId,
    String resolutionNotes,
  );
}

class AdminRepoImpl implements AdminRepo {
  AdminRepoImpl(this.getIt);

  final GetIt getIt;
  @override
  Future<Either<Failed, List<MaintenanceRequest>>>
      getMaintenanceRequests() async {
    try {
      final supabase = getIt<SupabaseClient>();
      final res = await supabase.from('maintenance_requests').select();
      final decodedRes = res.map(MaintenanceRequest.fromJson).toList();
      //Logger().i(decodedRes);
      return right(decodedRes);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, int>> getNumberOfRooms() async {
    try {
      final supabase = getIt<SupabaseClient>();
      final res = await supabase.from('rooms').count();
      //Logger().i(res);
      return right(res);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, List<Student>>> getStudents() async {
    try {
      final supabase = getIt<SupabaseClient>();
      final res = await supabase.from('users').select().eq('role', 'user');
      // final decodedRes = res[0];
      final decodedStudents = res.map((student) {
        return Student(
          id: student['id'] as String,
          email: student['email'] as String,
          level: student['level'] as String,
          userName: student['username'] as String,
          matricNumber: student['matric_number'] as String,
          firstName: student['first_name'] as String,
          lastName: student['last_name'] as String,
          phoneNumber: student['phone_number'] as String,
          age: student['age'] as String,
          gender: student['gender'] as String,
        );
      }).toList();

      //Logger().i(decodedStudents);
      return right(decodedStudents);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, MaintenanceRequest>> updateMaintenanceRequest(
    String maintenanceId,
    String status,
    String assigneeId,
    String resolutionNotes,
  ) async {
    try {
      final supabase = getIt<SupabaseClient>();
      //TODO: update 'status', 'date_resolved', 'resolution_notes' and any other relevant field
      final res = await supabase
          .from('maintenance_requests')
          .update({
            'status': status,
            'assigned_to': assigneeId,
            'resolution_notes': resolutionNotes,
            'date_resolved': DateTime.now().toIso8601String(),
          })
          .eq('id', maintenanceId)
          .select();
      // ignore: void_checks
      final maintenanceRequest = MaintenanceRequest.fromJson(res[0]);
      return right(maintenanceRequest);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }
}

final adminRepoProvider = Provider<AdminRepoImpl>((ref) {
  return AdminRepoImpl(ref.read(getItProvider));
});

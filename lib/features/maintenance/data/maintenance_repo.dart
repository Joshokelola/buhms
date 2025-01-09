import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/maintenance/domain/maintenance.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MaintenanceRepo {
  Future<Either<Failed, List<MaintenanceRequest>>> createMaintenanceRequest({
    required String userid,
    required String roomId,
    required String description,
    required String title,
  });

  Future<Either<Failed, List<MaintenanceRequest>>> getMaintenanceRequests({
    required String userId,
  });
}

class MaintenanceRepoImpl extends MaintenanceRepo {
  MaintenanceRepoImpl(this.getIt);

  final GetIt getIt;
  @override
  Future<Either<Failed, List<MaintenanceRequest>>> createMaintenanceRequest({
    required String userid,
    required String roomId,
    required String description,
    required String title,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();

      final res = await supabase.from('maintenance_requests').insert({
        'title': title,
        'description': description,
        'date_requested': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'user_id': userid,
        'room_id': roomId,
        'assigned_to': null,
        'resolution_notes': null,
        'date_resolved': null,
      }).select();
      Logger().i(MaintenanceRequest.fromJson(res[0]));
      if (res.isNotEmpty) {
        final maintenanceRequests =
            res.map(MaintenanceRequest.fromJson).toList();
        return right(maintenanceRequests);
      } else {
        return left(
          Failed(
            code: 'INSERT_FAILED',
            message: 'No data returned after insert',
          ),
        );
      }
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, List<MaintenanceRequest>>> getMaintenanceRequests({
    required String userId,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      final res = await supabase
          .from('maintenance_requests')
          .select()
          .eq('user_id', userId);
      final decodedRes = res.map(MaintenanceRequest.fromJson).toList();
      return right(decodedRes);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }
}

final maintenanceRepoImplProvider = Provider<MaintenanceRepoImpl>((ref) {
  return MaintenanceRepoImpl(ref.read(getItProvider));
});

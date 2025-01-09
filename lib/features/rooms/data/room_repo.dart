import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomRepo {
  RoomRepo(this.getIt);

  final GetIt getIt;
  Future<Either<Failed, RoomInfo>> getUserHostel({
    required String userId,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      final res = await supabase
          .from('room_occupants')
          .select('room_id')
          .eq('user_id', userId);
      final roomId = res[0]['room_id'] as String;
      final getRoom =
          await supabase.from('room').select().eq('room_id', roomId);
      Logger().d('IS THIS WORKING');
      return right(RoomInfo.defaultRoom());
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }
}

final roomRepoProvider = Provider<RoomRepo>((ref) {
  return RoomRepo(ref.read(getItProvider));
});

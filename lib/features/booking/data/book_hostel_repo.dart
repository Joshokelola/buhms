import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/failure.dart';
import 'package:buhms/features/rooms/domain/hostel.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: one_member_abstracts
abstract class BookHostelRepo {
  Future<Either<Failed, List<Hostel>>> getHostels({
    required String userId,
  });

  Future<Either<Failed, List<RoomInfo>>> getRoomsAvailableByHostel({
    required String userId,
    required String hostelId,
  });

  Future<Either<Failed, bool>> bookRoom({
    required String roomId,
    required String userId,
  });

  Future<Either<Failed, bool>> checkIfUserHasRoom({
    required String userId,
  });
}
//TODO - CACHE RESULTS OF HOSTELS AND ROOMS(Possibly riverpod or shared_preferences.)

class BookHostelRepoImpl extends BookHostelRepo {
  BookHostelRepoImpl(this.getIt);
  final GetIt getIt;
  @override
  Future<Either<Failed, List<Hostel>>> getHostels({
    required String userId,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      var gender = '';
      final userId = supabase.auth.currentSession?.user.id;
      final userRes =
          await supabase.from('users').select('gender').eq('id', userId!);
      Logger().i(userRes);
      final getGender = userRes[0]['gender'];
      if (getGender == 'Male') {
        gender = 'M';
      } else {
        gender = 'F';
      }
      Logger().i('Gender is - $gender');
      final getHostelRes = await supabase
          .from('hostels')
          .select('id,hostel_name,gender')
          .eq('gender', gender);
      final decodeHostels = getHostelRes.map((res) {
        return Hostel(
          id: res['id'] as String,
          hostelName: res['hostel_name'] as String,
          gender: res['gender'] as String,
        );
      }).toList();
      // Logger().i(gender);
      // Logger().i(decodeHostels);
      return right(decodeHostels);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, List<RoomInfo>>> getRoomsAvailableByHostel({
    required String userId,
    required String hostelId,
  }) async {
    try {
      //TODO - Show capacity of rooms on UI
      final supabase = getIt<SupabaseClient>();
      final getRooms =
          await supabase.from('rooms').select().eq('hostel_id', hostelId);
      final decodedRooms = getRooms.map((res) {
        //TODO - Make sure that once a room's capacity is 0, it doesnt show among list of rooms available
        //Perhaps use a filter to ensure that its only rooms with capacity of at least 1 that show up.
        return RoomInfo(
          roomId: res['id'] as String,
          capacity: res['capacity'] as int,
          hostelId: res['hostel_id'] as String,
          roomNumber: res['room_number'].toString(),
          //TODO - Write query to get members of room eventually.
          roomMembers: [],
          //TODO - GET HOSTEL NAME.
          hostelName: '',
        );
      }).toList();
      //  Logger().i(getRooms[0]);
      return right(decodedRooms);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, bool>> bookRoom({
    required String roomId,
    required String userId,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      await supabase.from('room_occupants').insert({
        'room_id': roomId,
        'user_id': userId,
        'check_in_date': DateTime.now().toIso8601String(),
      });
      return right(true);
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failed, bool>> checkIfUserHasRoom({
    required String userId,
  }) async {
    try {
      final supabase = getIt<SupabaseClient>();
      final res =
          await supabase.from('room_occupants').select().eq('user_id', userId);
      Logger().i(res);
      if (res.isEmpty) {
        // User does not have a room.
        return right(false);
      } else {
        return right(true);
      }
    } on PostgrestException catch (e) {
      return left(Failed(code: e.code, message: e.message));
    }
  }

  // @override
  // Future<Either<Failed, RoomInfo>> getUserHostel(
  //     {required String userId}) async {
  //   try {
  //     final supabase = getIt<SupabaseClient>();
  //     final res =
  //         await supabase.from('room_occupants').select('room_id').eq('user_id', userId);
  //     final roomId = res[0]['room_id'] as String;
  //     final getRoom =
  //         await supabase.from('room').select().eq('room_id', roomId);
  //     Logger().i(getRoom);
  //     return right(RoomInfo.defaultRoom());
  //   } on PostgrestException catch (e) {
  //     return left(Failed(code: e.code, message: e.message));
  //   }
  // }
}

final bookHostelProvider = Provider<BookHostelRepoImpl>((ref) {
  return BookHostelRepoImpl(ref.read(getItProvider));
});
